import hashlib
import http.client
import json
import os
import time
import urllib.error
import urllib.request
import uuid
from pathlib import Path

ICONS = {
    'python': ('🐍', ('.py', '.pyi')),
    'javascript': ('🟨', ('.js', '.mjs', '.cjs', '.jsx')),
    'typescript': ('🔷', ('.ts', '.tsx')),
    'bash': ('🐚', ('.sh', '.bash')),
    'powershell': ('💠', ('.ps1', '.psm1', '.psd1')),
    'markdown': ('📝', ('.md', '.mdx')),
    'json': ('📋', ('.json', '.jsonc')),
    'yaml': ('⚙️', ('.yaml', '.yml', '.toml', '.ini', '.cfg')),
    'html5': ('🌐', ('.html', '.htm')),
    'css3': ('🎨', ('.css', '.scss')),
    'rust': ('🦀', ('.rs',)),
    'go': ('🐹', ('.go',)),
    'java': ('☕', ('.java',)),
    'cplusplus': ('🔧', ('.cpp', '.cc', '.hpp', '.c', '.h')),
    'csharp': ('🟪', ('.cs',)),
    'folder': ('📁', ()),
    'file': ('📄', ()),
}


def file_icon(path, icons, directory=False):
    key = (
        'folder'
        if directory or path.endswith('/')
        else next(
            (
                name
                for name, (_, extensions) in ICONS.items()
                if Path(path).suffix.lower() in extensions
            ),
            'file',
        )
    )
    return {
        'type': 'custom_emoji',
        'custom_emoji_id': icons.get(key, 'icon:' + key),
        'alternative_text': ICONS[key][0],
    }


class IconError(Exception):
    pass


class TelegramConnection(http.client.HTTPSConnection):
    def __init__(self, *args, **kwargs):
        super().__init__(*args, source_address=('0.0.0.0', 0), **kwargs)


class TelegramHandler(urllib.request.HTTPSHandler):
    def https_open(self, request):
        return self.do_open(TelegramConnection, request, context=self._context)


def open_telegram(request, timeout):
    return urllib.request.build_opener(TelegramHandler()).open(request, timeout=timeout)


def api(method, payload, attachment=None):
    if attachment:
        boundary = uuid.uuid4().hex
        fields = []
        for name, value in payload.items():
            value = value if isinstance(value, str) else json.dumps(value)
            fields.append(
                (
                    f'--{boundary}\r\nContent-Disposition: form-data; '
                    f'name="{name}"\r\n\r\n{value}\r\n'
                ).encode()
            )
        fields.append(
            (
                f'--{boundary}\r\nContent-Disposition: form-data; '
                'name="sticker"; filename="icon.png"\r\n'
                'Content-Type: image/png\r\n\r\n'
            ).encode()
        )
        fields.extend([attachment.read_bytes(), f'\r\n--{boundary}--\r\n'.encode()])
        body = b''.join(fields)
        content_type = 'multipart/form-data; boundary=' + boundary
    else:
        body = json.dumps(payload).encode()
        content_type = 'application/json'
    for attempt in range(3):
        request = urllib.request.Request(
            'https://api.telegram.org/bot' + os.environ['TELEGRAM_BOT_TOKEN'] + '/' + method,
            data=body,
            headers={'Content-Type': content_type},
            method='POST',
        )
        try:
            with open_telegram(request, timeout=30) as response:
                result = json.load(response)
        except urllib.error.HTTPError as error:
            result = json.loads(error.read(1000000))
        if result.get('ok'):
            return result['result']
        if method == 'getStickerSet' and 'STICKERSET_INVALID' in result.get('description', ''):
            return None
        delay = (result.get('parameters') or {}).get('retry_after')
        if (
            attempt < 2
            and result.get('error_code') == 429
            and isinstance(delay, int)
            and 0 < delay <= 60
        ):
            time.sleep(delay)
            continue
        raise IconError('icon_api_failed')


def ensure_icons(payload):
    pending = {}

    def visit(value):
        if isinstance(value, dict):
            identifier = value.get('custom_emoji_id', '')
            if identifier.startswith('icon:'):
                pending.setdefault(identifier[5:], []).append(value)
            for child in value.values():
                visit(child)
        elif isinstance(value, list):
            for child in value:
                visit(child)

    visit(payload)
    if not pending:
        return
    owner = os.environ['TELEGRAM_CHAT_ID']
    if not owner.isdecimal():
        raise IconError('icon_owner_must_be_private_user')
    bot = api('getMe', {})
    namespace = hashlib.sha256((str(bot['id']) + ':' + owner).encode()).hexdigest()[:8]
    name = f'code{namespace}_v1_by_{bot["username"]}'
    pack = api('getStickerSet', {'name': name})
    known = {item['emoji']: item['custom_emoji_id'] for item in pack['stickers']} if pack else {}
    for key, entities in pending.items():
        emoji = ICONS[key][0]
        if emoji not in known:
            uploaded = api(
                'uploadStickerFile',
                {'user_id': int(owner), 'sticker_format': 'static'},
                Path(__file__).parent / 'icons' / (key + '.png'),
            )
            sticker = {
                'sticker': uploaded['file_id'],
                'format': 'static',
                'emoji_list': [emoji],
            }
            try:
                if pack is None:
                    api(
                        'createNewStickerSet',
                        {
                            'user_id': int(owner),
                            'name': name,
                            'title': 'GitHub · языки и файлы',
                            'sticker_type': 'custom_emoji',
                            'stickers': [sticker],
                        },
                    )
                else:
                    api(
                        'addStickerToSet',
                        {'user_id': int(owner), 'name': name, 'sticker': sticker},
                    )
            except (IconError, urllib.error.URLError, TimeoutError):
                pack = api('getStickerSet', {'name': name})
                known = (
                    {item['emoji']: item['custom_emoji_id'] for item in pack['stickers']}
                    if pack
                    else {}
                )
                if emoji not in known:
                    raise IconError('icon_creation_unconfirmed') from None
            pack = api('getStickerSet', {'name': name})
            known = {item['emoji']: item['custom_emoji_id'] for item in pack['stickers']}
        for entity in entities:
            entity['custom_emoji_id'] = known[emoji]
