import hashlib
import json
import os
import re
import subprocess
import sys
import time
import urllib.error
import urllib.parse
import urllib.request
import uuid
import zipfile
from pathlib import Path

from telegram_icons import ensure_icons, file_icon, open_telegram

ZERO_SHA = '0' * 40


class NotificationError(Exception):
    pass


def git(*arguments, required=True, input_data=None):
    result = subprocess.run(
        ['git', '-c', 'core.hooksPath=/dev/null', '-c', 'gc.auto=0', *arguments],
        stdin=subprocess.DEVNULL if input_data is None else None,
        input=input_data,
        stdout=subprocess.PIPE,
        stderr=subprocess.DEVNULL,
        timeout=120,
        check=False,
        env={**os.environ, 'GIT_TERMINAL_PROMPT': '0'},
    )
    if result.returncode:
        if required:
            raise NotificationError('git_operation_failed')
        return None
    return result.stdout


def validate_sha(value):
    if not isinstance(value, str) or not re.fullmatch(r'[0-9a-f]{40}', value):
        raise NotificationError('invalid_commit_sha')
    return value


def ensure_revision(value):
    validate_sha(value)
    if value == ZERO_SHA:
        return git('hash-object', '-t', 'tree', '-w', '--stdin').decode().strip()
    if git('cat-file', '-e', value + '^{commit}', required=False) is None:
        git('fetch', '--no-tags', '--depth=1', 'origin', value)
    git('cat-file', '-e', value + '^{commit}')
    return value


def changed_files(raw):
    fields = raw.split(b'\0')
    files = []
    index = 0
    while index < len(fields) and fields[index]:
        metadata = fields[index].decode('ascii').split()
        old_path = fields[index + 1].decode('utf-8', errors='surrogateescape')
        new_path = old_path
        index += 2
        if metadata[4][0] in ('R', 'C'):
            new_path = fields[index].decode('utf-8', errors='surrogateescape')
            index += 1
        files.append(
            {
                'status': metadata[4],
                'before_path': old_path,
                'after_path': new_path,
                'before_blob': metadata[2],
                'after_blob': metadata[3],
                'before_mode': metadata[0].lstrip(':'),
                'after_mode': metadata[1],
            }
        )
    return files


def zip_path(path):
    parts = []
    for part in path.split('/'):
        if not part or part in ('.', '..') or re.search(r'[\\:\x00-\x1f\ud800-\udfff]', part):
            raw = part.encode('utf-8', errors='surrogateescape')
            part = ''.join(f'%{byte:02X}' for byte in raw) or '%00'
        parts.append(part)
    return '/'.join(parts)


def create_archive(repository, before, after, target):
    old = ensure_revision(before)
    new = ensure_revision(after)
    options = ('--no-ext-diff', '--no-textconv', '--find-renames')
    files = changed_files(git('diff', '--raw', '-z', '--no-abbrev', *options, old, new, '--'))
    files = [
        item
        for item in files
        if any(
            item[side + '_path'].startswith(('codex/', 'scripts/')) for side in ('before', 'after')
        )
    ]
    blobs = sorted(
        {
            item[side + '_blob']
            for item in files
            for side in ('before', 'after')
            if item[side + '_mode'] not in ('000000', '160000')
        }
    )
    sizes = {}
    if blobs:
        lines = (
            git(
                'cat-file',
                '--batch-check=%(objectname) %(objectsize)',
                input_data=('\n'.join(blobs) + '\n').encode(),
            )
            .decode()
            .splitlines()
        )
        sizes = {line.split()[0]: int(line.split()[1]) for line in lines}
    for item in files:
        for side in ('before', 'after'):
            item[side + '_size'] = sizes.get(item[side + '_blob'], 0)
    revision = old if after == ZERO_SHA else new
    roots = [
        root
        for root in ('codex', 'scripts')
        if git('cat-file', '-e', revision + ':' + root, required=False) is not None
    ]
    if roots:
        git('archive', '--format=zip', '--output=' + str(target), revision, '--', *roots)
    else:
        with zipfile.ZipFile(target, 'w'):
            pass
    if target.stat().st_size > 45000000:
        raise NotificationError('archive_exceeds_telegram_limit')
    return files


def paragraph(text):
    return {'type': 'paragraph', 'text': text}


def file_size(size):
    if size < 1024:
        return f'{size} Б'
    if size < 1024 * 1024:
        return f'{size / 1024:.1f} КБ'
    return f'{size / (1024 * 1024):.1f} МБ'


def notification(repository, branch, before, after, files, commit_text='', icons=None):
    url = 'https://github.com/' + repository
    labels = {
        'A': 'Добавлен',
        'M': 'Изменён',
        'D': 'Удалён',
        'R': 'Переименован',
        'C': 'Скопирован',
        'T': 'Изменён тип',
    }
    statuses = {item['status'][0] for item in files}
    change_text = (
        'Добавлены файлы.'
        if statuses == {'A'}
        else 'Добавлены и изменены файлы.'
        if 'A' in statuses
        else 'Изменены файлы.'
    )
    blocks = [
        {
            'type': 'document',
            'document': {'type': 'document', 'media': 'attach://archive'},
        },
        {'type': 'divider'},
        paragraph(
            [
                'Ветка удалена. Последний коммит '
                if after == ZERO_SHA
                else 'Зафиксирован новый коммит ',
                {'type': 'marked', 'text': before if after == ZERO_SHA else after},
                '. ' + change_text if files else '.',
            ]
        ),
    ]
    if commit_text:
        blocks.append({'type': 'blockquote', 'blocks': [paragraph(commit_text)]})
    items = [
        [
            {'text': 'Файл', 'is_header': True},
            {'text': 'Было', 'is_header': True},
            {'text': 'Стало', 'is_header': True},
        ]
    ]
    for item in files:
        status = item['status'][0]
        path = item['before_path'] if status == 'D' else item['after_path']
        revision = before if status == 'D' else after
        name = (
            path.encode('utf-8', errors='backslashreplace')
            .decode('utf-8')
            .replace('\n', '\\n')
            .replace('\r', '\\r')
        )
        directory = item.get('after_mode' if status != 'D' else 'before_mode') == '160000'
        text = [file_icon(path, icons or {}, directory), ' ', name]
        if status not in ('A', 'M'):
            text.append(' (' + labels.get(status, status) + ')')
        link = {
            'type': 'url',
            'text': text,
            'url': url
            + ('/tree/' if directory else '/blob/')
            + revision
            + '/'
            + urllib.parse.quote(path.encode('utf-8', errors='surrogateescape'), safe='/'),
        }
        if status in ('R', 'C'):
            text.append(
                ' (из '
                + item['before_path'].encode('utf-8', errors='backslashreplace').decode('utf-8')
                + ')'
            )
        items.append(
            [
                {'text': link},
                {'text': file_size(item['before_size'])},
                {'text': file_size(item['after_size'])},
            ]
        )
    if files:
        for row in items:
            for cell in row:
                cell.update(align='left', valign='middle')
        blocks.append(
            {
                'type': 'table',
                'cells': items,
                'is_bordered': True,
                'is_striped': True,
                'is_compact': True,
            }
        )
    else:
        blocks.append(paragraph('В папках codex и scripts изменений нет.'))
    buttons = [{'text': 'Открыть репозиторий', 'url': url}]
    return {
        'rich_message': {'blocks': blocks, 'skip_entity_detection': True},
        'reply_markup': {'inline_keyboard': [buttons]},
    }


def prior_delivery(repository, run_id, attempt, token):
    if attempt == 1:
        return False
    page = 1
    while True:
        url = f'https://api.github.com/repos/{repository}/actions/runs/{run_id}/artifacts?per_page=100&page={page}'
        request = urllib.request.Request(
            url,
            headers={
                'Authorization': 'Bearer ' + token,
                'Accept': 'application/vnd.github+json',
                'X-GitHub-Api-Version': '2026-03-10',
            },
        )
        with urllib.request.urlopen(request, timeout=20) as response:
            result = json.load(response)
        artifacts = result['artifacts']
        if any(item['name'] == 'telegram-delivery-' + run_id for item in artifacts):
            return True
        if len(artifacts) < 100:
            return False
        page += 1


def prepare():
    repository = os.environ['GITHUB_REPOSITORY']
    if not re.fullmatch(r'[A-Za-z0-9_.-]+/[A-Za-z0-9_.-]+', repository):
        raise NotificationError('invalid_repository')
    run_id = os.environ['GITHUB_RUN_ID']
    if not run_id.isdecimal():
        raise NotificationError('invalid_run_id')
    if prior_delivery(
        repository,
        run_id,
        int(os.environ['GITHUB_RUN_ATTEMPT']),
        os.environ['GH_TOKEN'],
    ):
        with open(os.environ['GITHUB_OUTPUT'], 'a') as output:
            output.write('ready=false\n')
        print('Existing delivery intent found. Automatic duplicate sending skipped.')
        return
    event = json.loads(Path(os.environ['GITHUB_EVENT_PATH']).read_text())
    values = (
        event.get('inputs') if os.environ['GITHUB_EVENT_NAME'] == 'workflow_dispatch' else event
    )
    before, after = validate_sha(values['before']), validate_sha(values['after'])
    branch = event.get('ref', os.environ.get('GITHUB_REF', '')).removeprefix('refs/heads/')
    directory = Path(os.environ['RUNNER_TEMP']) / 'telegram-changes'
    directory.mkdir(parents=True, exist_ok=True)
    revision = before if after == ZERO_SHA else after
    target = directory / f'{revision}.zip'
    files = create_archive(repository, before, after, target)
    commit_text = (
        git('show', '-s', '--format=%B', revision).decode('utf-8', errors='replace').strip()
    )
    payload = notification(repository, branch, before, after, files, commit_text)
    (directory / 'message.json').write_text(json.dumps(payload, ensure_ascii=True))
    (directory / 'intent.json').write_text(
        json.dumps(
            {
                'archive': target.name,
                'sha256': hashlib.sha256(target.read_bytes()).hexdigest(),
                'run_id': run_id,
                'before': before,
                'after': after,
            }
        )
    )
    with open(os.environ['GITHUB_OUTPUT'], 'a') as output:
        output.write('ready=true\n')
    print(json.dumps({'changed_files': len(files), 'archive_bytes': target.stat().st_size}))


def multipart(payload, archive):
    boundary = uuid.uuid4().hex
    parts = []
    for name, value in payload.items():
        text = value if isinstance(value, str) else json.dumps(value, ensure_ascii=True)
        parts.append(
            (
                f'--{boundary}\r\nContent-Disposition: form-data; name="{name}"\r\n\r\n{text}\r\n'
            ).encode()
        )
    parts.append(
        (
            f'--{boundary}\r\nContent-Disposition: form-data; name="archive"; '
            f'filename="{archive.name}"\r\nContent-Type: application/zip\r\n\r\n'
        ).encode()
    )
    parts.extend([archive.read_bytes(), f'\r\n--{boundary}--\r\n'.encode()])
    return b''.join(parts), 'multipart/form-data; boundary=' + boundary


def send():
    directory = Path(os.environ['RUNNER_TEMP']) / 'telegram-changes'
    result_path = directory.parent / 'telegram-result.json'
    intent = json.loads((directory / 'intent.json').read_text())
    archive = directory / intent['archive']
    if hashlib.sha256(archive.read_bytes()).hexdigest() != intent['sha256']:
        raise NotificationError('archive_checksum_mismatch')
    payload = json.loads((directory / 'message.json').read_text())
    ensure_icons(payload)
    payload['chat_id'] = os.environ['TELEGRAM_CHAT_ID']
    body, content_type = multipart(payload, archive)
    url = 'https://api.telegram.org/bot' + os.environ['TELEGRAM_BOT_TOKEN'] + '/sendRichMessage'
    result = {'status': 'uncertain', 'started_at_ms': time.time_ns() // 1000000}
    result_path.write_text(json.dumps(result))
    for attempt in range(3):
        request = urllib.request.Request(
            url, data=body, headers={'Content-Type': content_type}, method='POST'
        )
        try:
            with open_telegram(request, timeout=60) as response:
                answer = json.loads(response.read(2000000))
        except urllib.error.HTTPError as error:
            answer = json.loads(error.read(1000000))
        if answer.get('ok'):
            message = answer['result']
            result.update(
                status='sent',
                message_id=str(message['message_id']),
                telegram_sent_at_ms=message['date'] * 1000,
                confirmed_at_ms=time.time_ns() // 1000000,
            )
            result_path.write_text(json.dumps(result))
            print(json.dumps({'status': 'sent', 'message_id': result['message_id']}))
            return
        code = answer.get('error_code')
        delay = (answer.get('parameters') or {}).get('retry_after')
        if code == 429 and attempt < 2 and isinstance(delay, int) and 0 < delay <= 60:
            time.sleep(delay)
            continue
        result.update(
            status='rejected' if isinstance(code, int) and 400 <= code < 500 else 'uncertain',
            error_code=code,
        )
        result_path.write_text(json.dumps(result))
        raise NotificationError('telegram_request_failed')


def validate():
    token = os.environ.get('TELEGRAM_BOT_TOKEN', '')
    chat_id = os.environ.get('TELEGRAM_CHAT_ID', '')
    if not re.fullmatch(r'[0-9]+:[A-Za-z0-9_-]+', token) or not re.fullmatch(r'-?[0-9]+', chat_id):
        raise NotificationError('missing_notification_secrets')


if __name__ == '__main__':
    try:
        {'validate': validate, 'prepare': prepare, 'send': send}[sys.argv[1]]()
    except Exception as error:
        print(
            json.dumps(
                {
                    'error': str(error)
                    if isinstance(error, NotificationError)
                    else type(error).__name__
                }
            )
        )
        raise SystemExit(1) from None
