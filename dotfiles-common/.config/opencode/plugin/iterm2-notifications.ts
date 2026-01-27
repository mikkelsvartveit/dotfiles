import type { Plugin } from "@opencode-ai/plugin";

export const NotificationPlugin: Plugin = async ({ $ }) => {
  /**
   * Checks if the current OpenCode session is running in iTerm2
   */
  const isITerm2 = () => {
    return Boolean(process.env.ITERM_SESSION_ID);
  };

  /**
   * Checks if the current OpenCode session is the one currently visible
   * to the user in iTerm2.
   */
  const isOpenCodeActiveTab = async (): Promise<boolean> => {
    // 1. Get the unique iTerm2 Session ID for the current process
    // OpenCode usually provides this in the environment, or we can fetch it
    const currentSessionId = process.env.ITERM_SESSION_ID.split(":")[1].trim();

    if (!currentSessionId) return false;

    // 2. Use AppleScript to find the ID of the session that has focus
    const script = `
      tell application "iTerm2"
        if (count of windows) > 0 then
          tell current session of current window
            return id
          end tell
        else
          return "no_window"
        end if
      end tell
    `;

    try {
      const activeSessionId = await $`osascript -e ${script}`.text();

      // If the IDs match, the user is looking at the correct tab/pane
      return activeSessionId.trim() === currentSessionId;
    } catch {
      return false;
    }
  };

  const isITerm2Focused = async (): Promise<boolean> => {
    const result =
      await $`osascript -e 'tell application "System Events" to get name of first application process whose frontmost is true'`.text();
    return result.trim() === "iTerm2";
  };

  return {
    event: async ({ event }) => {
      // Skip if terminal is not iTerm2
      if (!isITerm2()) {
        return;
      }

      // Notify if iTerm2 is in the background OR
      // if iTerm2 is open but the user is on a different tab/pane
      const itermFocused = await isITerm2Focused();
      const tabVisible = await isOpenCodeActiveTab();
      if (!itermFocused || !tabVisible) {
        if (event.type === "session.idle") {
          await $`printf "\\033]9;Task finished!\\007"`;
        } else if (event.type === "permission.updated") {
          await $`printf "\\033]9;OpenCode is asking for your permission.\\007"`;
        }
      }
    },
  };
};
