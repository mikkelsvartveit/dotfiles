---
name: pr
description: Prepare GitHub pull requests and open prefilled PR forms. Use for /pr, requests to open a PR form, or requests to create or submit a pull request.
---

# Pull requests

## Choose the requested outcome

- `/pr` defaults to opening a prefilled browser form for the current branch.
- “PR form”, “open a PR form”, and “prefill a PR” mean a browser form that the user reviews and submits. Never submit, publish, or create a draft PR for these requests. The word “form” is deliberate; do not autocorrect it to “for me”.
- An explicit request to create, submit, or publish a PR authorizes actual creation. Follow that request without adding another confirmation step.
- If opening the form fails, return a prefilled compare URL. Never fall back to creating a PR.

## Prepare the content

Inspect repository guidance, the current branch, its base, commits, and the final diff. Use the repository's PR template when present. Write a concise title and body describing the problem, resulting behavior, and validation actually performed. Include the issue reference when available.

Commit and push the intended changes when needed to make the requested PR or form usable, respecting existing authorization and repository conventions. Exclude unrelated changes, avoid force pushes, and use the correct base for dependent branches. Check for an existing open PR before creating a duplicate; if one exists, report it instead of claiming a new form was opened.

Write the body to a temporary file with literal newlines. Pass it with `--body-file`; do not interpolate Markdown into shell command text.

## Open the form

Use the GitHub CLI's browser mode with explicit base, head, title, and body:

```sh
gh pr create --web --base "$pr_base" --head "$pr_head" \
  --title "$pr_title" --body-file "$pr_body_file"
```

Keep `--web` in every form-opening attempt. `--head` skips the CLI's automatic pushing/forking prompts, so push the branch separately when needed. Browser mode opens the creation form; the user clicks the final submit button. Do not use `--dry-run` as a substitute for the form.

If the browser cannot open, provide a URL shaped like:

```text
https://github.com/OWNER/REPO/compare/BASE...HEAD?expand=1&title=ENCODED_TITLE&body=ENCODED_BODY
```

URL-encode the branch names and query values, preserving the compare separator and fork-head syntax when applicable. Use a standard URL encoder rather than manual escaping. Report whether the form opened or only a link was prepared.

## Create a PR when explicitly requested

Use `gh pr create` with the same prepared base, head, title, and `--body-file`, without `--web`. Add `--draft` only when requested. Return the resulting PR link.

Reference: [GitHub CLI: gh pr create](https://cli.github.com/manual/gh_pr_create).
