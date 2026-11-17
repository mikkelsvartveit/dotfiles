// Posts a synthetic Ctrl+V. Synthetic events bypass Karabiner, so this
// doesn't retrigger the rule. Needs Accessibility permission; prompts if missing.
ObjC.import("CoreGraphics")
ObjC.bindFunction("CGPreflightPostEventAccess", ["bool", []])
ObjC.bindFunction("CGRequestPostEventAccess", ["bool", []])

function run() {
  if (!$.CGPreflightPostEventAccess()) {
    $.CGRequestPostEventAccess()
    const app = Application.currentApplication()
    app.includeStandardAdditions = true
    app.displayNotification("Grant Accessibility access so Ctrl+V can be re-sent", {
      withTitle: "ssh-clip-paste",
    })
    return
  }
  for (const down of [true, false]) {
    const e = $.CGEventCreateKeyboardEvent($(), 9 /* kVK_ANSI_V */, down)
    $.CGEventSetFlags(e, 0x40000 /* kCGEventFlagMaskControl */)
    $.CGEventPost(0 /* kCGHIDEventTap */, e)
  }
}
