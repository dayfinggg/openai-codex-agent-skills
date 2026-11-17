# GitHub pull request review threads

Check the current [`gh api` manual](https://cli.github.com/manual/gh_api), [GitHub GraphQL pull request reference](https://docs.github.com/en/graphql/reference/pulls), and [REST review comment endpoints](https://docs.github.com/en/rest/pulls/comments) before relying on an exact field or mutation.

## Read all threads and their state

Review threads are separate from pull request conversation comments and review summaries. Query the pull request's `reviewThreads` connection and paginate until `hasNextPage` is false. Read the thread node ID, resolution state, outdated state, file path, line, and each comment's author, body, and URL. Outdated threads still need a decision. A summary endpoint that omits inline threads is not complete evidence.

GitHub GraphQL exposes the `reviewThreads` connection and its pagination fields. It also documents `addPullRequestReviewThreadReply` for replies and `resolveReviewThread` for resolution. Use those supported operations rather than the deprecated `addPullRequestReviewComment` mutation.

## Reply and resolve

Reply by thread node ID when possible, because that targets the thread directly. Confirm that the pull request and thread still exist and that the proposed reply accurately describes the code change or reason for disagreement. A reply does not itself resolve a thread. Resolve a thread only when the user requested it and the finding has been addressed or the reply explains why it needs no change.

Use `gh api` field forms according to its current help. A raw field is a string; typed field parsing converts booleans, null, integers, and repository placeholders, and an `@` value reads a file. Keep review bodies out of command arguments when they contain private data or shell metacharacters. Do not enable verbose HTTP logging around credentials.

## Post review comments

For an authorized inline review, collect all comments into one review submission when the current REST or GraphQL API supports that form. Pin the review to the exact head commit inspected. Validate every file path and diff line against that commit. Use the API's current side and line-range fields, and avoid deprecated diff-relative fields. If the line is not commentable, put the finding in the review body instead of inventing a position.

Use `COMMENT` or `REQUEST_CHANGES` only when that state matches the user's request and the reviewed evidence. `APPROVE` requires an explicit request. After posting, read the returned status and verify the resulting comments or thread state before reporting success.
