#!/usr/bin/env node
// PreToolUse hook that denies agent access to secret files with an explanatory
// message, so a blocked command is not mistaken for shell access being blocked
// in general.
//
// This hook is the only enforcement: settings.json deliberately has no matching
// `deny` rules. It is registered with `onFailure: "block"`, so if this script
// crashes or cannot start, the tool call is blocked rather than allowed.
//
// Keep the patterns and message in sync with the OpenCode plugin at
// .config/opencode/plugins/secret-guard/index.ts.

// A dotenv file name as a whole shell token, e.g. `.env`, `./.env.local`,
// `"app/.env.production"`. Requiring a token boundary before the dot avoids
// matching `process.env` or `import.meta.env`.
const BEFORE = String.raw`(?:^|[\s"'=<>(:/])`;
const AFTER = String.raw`(?=$|[\s"';|&<>)])`;
const TEMPLATE_SUFFIX = String.raw`\.(?:example|template)`;
const SHELL_SECRET = new RegExp(
  `${BEFORE}\\.env(?!${TEMPLATE_SUFFIX}${AFTER})(?:\\.[\\w.-]+)?${AFTER}`,
);

// File paths matching `*.env` and `*.env.*`, except templates.
const READ_SECRET = /\.env(?:\.[^/]*)?$/;
const READ_TEMPLATE = /\.env\.(?:example|template)$/;

// Grep `glob` filters that select dotenv files, e.g. `.env*` or `*.env`.
const GLOB_SECRET = /\.env(?!\.(?:example|template)$)/;

// .NET user secrets.
const USER_SECRETS = /usersecrets|user-secrets\s+list/;

const SECRET_MESSAGE =
  "Blocked by the user's secret-file policy: .env files and .NET user secrets " +
  "contain credentials and must not be read, printed, copied, or sourced by agents. " +
  "To learn which variables exist, read .env.example or .env.template, " +
  "or ask the user.";

const isSecretPath = (path) =>
  USER_SECRETS.test(path) || (READ_SECRET.test(path) && !READ_TEMPLATE.test(path));

function isSecret(tool, input) {
  switch (tool) {
    case "Read":
      return isSecretPath(input.file_path ?? "");
    case "Grep":
      return isSecretPath(input.path ?? "") || GLOB_SECRET.test(input.glob ?? "");
    case "Bash":
      return USER_SECRETS.test(input.command ?? "") || SHELL_SECRET.test(input.command ?? "");
    default:
      return false;
  }
}

let raw = "";
for await (const chunk of process.stdin) raw += chunk;
const { tool_name, tool_input } = JSON.parse(raw);

if (isSecret(tool_name, tool_input ?? {})) {
  process.stdout.write(
    JSON.stringify({
      hookSpecificOutput: {
        hookEventName: "PreToolUse",
        permissionDecision: "deny",
        permissionDecisionReason: SECRET_MESSAGE,
      },
    }),
  );
}
