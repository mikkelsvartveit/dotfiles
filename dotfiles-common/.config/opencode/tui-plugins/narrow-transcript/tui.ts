// Caps the width of the session transcript so long lines stay readable on wide terminals.
//
// This reaches into OpenCode's internal renderable tree, which is not part of the plugin API.
// It finds the transcript's ScrollBox (sticky to the bottom, no id) and pads its content node,
// which OpenCode itself never styles. An OpenCode update may break this.

import { Plugin } from "@opencode/plugin/tui"

type Align = "center" | "left"
type Settings = { enabled: boolean; width: number; align: Align }

const DEFAULTS: Settings = { enabled: true, width: 100, align: "center" }
const EXCLUDED_IDS = new Set(["shell-output-scroll"])

function isTranscript(node: any): boolean {
  return (
    node &&
    typeof node === "object" &&
    "content" in node &&
    "viewport" in node &&
    node.stickyStart === "bottom" &&
    !EXCLUDED_IDS.has(node.id)
  )
}

function collect(node: any, out: any[], depth = 0) {
  if (!node || depth > 60) return
  if (isTranscript(node)) {
    out.push(node)
    return // don't descend into the transcript itself
  }
  const children = typeof node.getChildren === "function" ? node.getChildren() : []
  for (const child of children) collect(child, out, depth + 1)
}

export default Plugin.define({
  id: "local.narrow-transcript",
  setup(context) {
    const opts = (context.options ?? {}) as Partial<Settings>
    const initial: Settings = {
      enabled: opts.enabled ?? DEFAULTS.enabled,
      width: typeof opts.width === "number" && opts.width > 20 ? opts.width : DEFAULTS.width,
      align: opts.align === "left" ? "left" : DEFAULTS.align,
    }
    const [settings, update] = context.storage.store("settings", { initial })

    // Remember what we applied per scrollbox so we only touch it when something changed.
    const applied = new WeakMap<object, string>()

    // Pads the content node so its inner width is at most `width`. Padding is recomputed from the
    // viewport width on every scan, so terminal resizes and sidebar toggles are picked up.
    const padding = (scroll: any, s: Settings) => {
      if (!s.enabled) return { left: 0, right: 0 }
      const available = Number(scroll.viewport?.width ?? scroll.width ?? 0)
      const extra = Math.max(0, Math.floor(available - s.width))
      if (s.align === "left") return { left: 0, right: extra }
      const left = Math.floor(extra / 2)
      return { left, right: extra - left }
    }

    // The boxes stacked under the transcript in the same column: the "Jump to latest" row and the
    // composer/prompt box. OpenCode sets no padding on them, so ours sticks.
    const siblingsBelow = (scroll: any): any[] => {
      const wrapper = scroll.parent
      const column = wrapper?.parent
      if (!column || typeof column.getChildren !== "function") return []
      const children = column.getChildren()
      const index = children.indexOf(wrapper)
      if (index < 0 || children.length > 6) return []
      return children.slice(index + 1)
    }

    const apply = (force = false) => {
      const s = settings as Settings
      const found: any[] = []
      try {
        collect(context.renderer.root, found)
      } catch {
        return
      }
      for (const scroll of found) {
        try {
          const p = padding(scroll, s)
          // Absolute column where the transcript text starts, so the boxes below can line up with it.
          const textLeft = Number(scroll.viewport?.screenX ?? scroll.screenX ?? 0) + p.left
          const below = siblingsBelow(scroll)
          const belowPads = below.map((box) => {
            if (!s.enabled) return { left: 0, right: 0 }
            const left = Math.max(0, textLeft - Number(box.screenX ?? 0))
            const right = Math.max(0, Number(box.width ?? 0) - left - s.width)
            return { left, right }
          })
          const key = `${p.left}:${p.right}|${belowPads.map((b) => `${b.left}:${b.right}`).join(",")}`
          if (!force && applied.get(scroll) === key) continue
          scroll.contentOptions = { paddingLeft: p.left, paddingRight: p.right }
          below.forEach((box, i) => {
            box.paddingLeft = belowPads[i].left
            box.paddingRight = belowPads[i].right
          })
          applied.set(scroll, key)
          scroll.requestRender?.()
        } catch {
          // Internals changed; fail quietly rather than breaking the TUI.
        }
      }
    }

    // Transcripts mount and unmount as you switch sessions, so re-scan periodically.
    // The walk stops at the transcript, so it only visits the surrounding layout boxes.
    apply(true)
    const timer = setInterval(() => apply(), 100)

    const set = async (patch: Partial<Settings>) => {
      await update((draft: Settings) => Object.assign(draft, patch))
      apply(true)
    }

    context.keymap.layer(() => ({
      mode: "global",
      commands: [
        {
          id: "narrow-transcript.toggle",
          title: "Toggle narrow transcript",
          group: "Narrow transcript",
          palette: true,
          slash: { name: "narrow" },
          run: async () => {
            const next = !(settings as Settings).enabled
            await set({ enabled: next })
            context.ui.toast.show({
              message: next ? `Transcript capped at ${(settings as Settings).width} columns` : "Transcript full width",
            })
          },
        },
        {
          id: "narrow-transcript.width",
          title: "Set transcript width",
          group: "Narrow transcript",
          palette: true,
          slash: { name: "narrow-width" },
          run: async () => {
            const value = await context.ui.dialog.prompt({
              title: "Transcript max width (columns)",
              placeholder: String((settings as Settings).width),
            })
            const width = Number.parseInt(String(value ?? ""), 10)
            if (!Number.isFinite(width) || width < 20) return
            await set({ width, enabled: true })
          },
        },
        {
          id: "narrow-transcript.align",
          title: "Toggle transcript alignment (center/left)",
          group: "Narrow transcript",
          palette: true,
          run: async () => {
            await set({ align: (settings as Settings).align === "center" ? "left" : "center" })
          },
        },
      ],
    }))

    return () => {
      clearInterval(timer)
      // Restore full width when the plugin is disabled or reloaded.
      const found: any[] = []
      try {
        collect(context.renderer.root, found)
        for (const scroll of found) {
          scroll.contentOptions = { paddingLeft: 0, paddingRight: 0 }
          for (const box of siblingsBelow(scroll)) {
            box.paddingLeft = 0
            box.paddingRight = 0
          }
        }
      } catch {}
    }
  },
})
