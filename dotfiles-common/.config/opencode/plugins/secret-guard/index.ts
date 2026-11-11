// Denies agent access to secret files with an explanatory message, so a blocked
// command is not mistaken for shell access being blocked in general.
//
// This plugin is the only enforcement: there are deliberately no matching
// `deny` rules in opencode.json, because the permission `evaluate` hook only
// runs for `allow` and `ask` decisions, and a configured `deny` is final with a
// generic error. If this plugin fails to load, only OpenCode's built-in `ask`
// for `.env` reads remains; shell access is unguarded.
//
// No imports: `Plugin.define` from `@opencode/plugin` is the identity function,
// so a plain object avoids installing the SDK and its dependencies.

// A dotenv file name as a whole shell token, e.g. `.env`, `./.env.local`,
// `"app/.env.production"`. Requiring a token boundary before the dot avoids
// matching `process.env` or `import.meta.env`.
const BEFORE = String.raw`(?:^|[\s"'=<>(:/])`;
const AFTER = String.raw`(?=$|[\s"';|&<>)])`;
const TEMPLATE_SUFFIX = String.raw`\.(?:example|template)`;
const SHELL_SECRET = new RegExp(
  `${BEFORE}\\.env(?!${TEMPLATE_SUFFIX}${AFTER})(?:\\.[\\w.-]+)?${AFTER}`,
);

// Mirrors the read rules in opencode.json: `*.env` and `*.env.*`, except templates.
const READ_SECRET = /\.env(?:\.[^/]*)?$/;
const READ_TEMPLATE = /\.env\.(?:example|template)$/;

// .NET user secrets.
const USER_SECRETS = /usersecrets|user-secrets\s+list/;

const SECRET_MESSAGE =
  "Blocked by the user's secret-file policy: .env files and .NET user secrets " +
  "contain credentials and must not be read, printed, copied, or sourced by agents. " +
  "To learn which variables exist, read .env.example or .env.template, " +
  "or ask the user.";

type Evaluation = {
  readonly action: string;
  readonly resources: ReadonlyArray<string>;
  effect: "allow" | "ask" | "deny";
  message?: string;
};

function isSecret(action: string, resource: string): boolean {
  if (action === "read") {
    return (
      USER_SECRETS.test(resource) ||
      (READ_SECRET.test(resource) && !READ_TEMPLATE.test(resource))
    );
  }
  if (action === "shell")
    return USER_SECRETS.test(resource) || SHELL_SECRET.test(resource);
  return false;
}

export default {
  id: "secret-guard",
  async setup(ctx: any) {
    await ctx.permission.hook("evaluate", (event: Evaluation) => {
      if (event.resources.some((r) => isSecret(event.action, r))) {
        event.effect = "deny";
        event.message = SECRET_MESSAGE;
      }
    });
  },
};
