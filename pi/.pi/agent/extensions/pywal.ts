import { execFileSync } from "node:child_process";
import { existsSync, readFileSync, watch, type FSWatcher } from "node:fs";
import { homedir } from "node:os";
import { join } from "node:path";
import type { ExtensionAPI } from "@earendil-works/pi-coding-agent";

export default function (pi: ExtensionAPI) {
  const home = process.env.HOME ?? homedir();
  const scriptPath = join(home, ".pi/agent/scripts/pi-pywal-theme.mjs");
  const themeJsonPath = join(home, ".pi/agent/themes/pywal.json");
  const walCacheDir = join(home, ".cache/wal");
  const colorsJsonPath = join(walCacheDir, "colors.json");

  let watcher: FSWatcher | null = null;
  let debounceTimer: NodeJS.Timeout | null = null;

  function regenerateAndApplyTheme(ctx?: { ui: any }): boolean {
    try {
      if (!existsSync(scriptPath)) return false;
      execFileSync(process.execPath, [scriptPath], { stdio: "ignore" });
      if (ctx?.ui && existsSync(themeJsonPath)) {
        const themeContent = JSON.parse(readFileSync(themeJsonPath, "utf8"));
        ctx.ui.setTheme(themeContent);
        return true;
      }
    } catch {
      // Ignore transient file read/write errors during atomic updates
    }
    return false;
  }

  pi.on("session_start", async (_event, ctx) => {
    if (!ctx.hasUI) return;

    if (watcher) {
      watcher.close();
      watcher = null;
    }

    if (existsSync(walCacheDir)) {
      try {
        watcher = watch(walCacheDir, (_eventType, filename) => {
          if (filename === "colors.json" || filename === "colors") {
            if (debounceTimer) clearTimeout(debounceTimer);
            debounceTimer = setTimeout(() => {
              const applied = regenerateAndApplyTheme(ctx);
              if (applied) {
                ctx.ui.notify("pywal palette updated", "info");
              }
            }, 150);
          }
        });
      } catch {
        if (existsSync(colorsJsonPath)) {
          try {
            watcher = watch(colorsJsonPath, () => {
              if (debounceTimer) clearTimeout(debounceTimer);
              debounceTimer = setTimeout(() => {
                const applied = regenerateAndApplyTheme(ctx);
                if (applied) {
                  ctx.ui.notify("pywal palette updated", "info");
                }
              }, 150);
            });
          } catch {}
        }
      }
    }
  });

  pi.on("session_shutdown", async () => {
    if (watcher) {
      watcher.close();
      watcher = null;
    }
    if (debounceTimer) {
      clearTimeout(debounceTimer);
      debounceTimer = null;
    }
  });

  pi.registerCommand("pywal", {
    description: "Regenerate pywal theme and reload Pi",
    handler: async (_args, ctx) => {
      regenerateAndApplyTheme(ctx);
      ctx.ui.notify("pywal theme regenerated", "info");
      await ctx.reload();
    },
  });
}
