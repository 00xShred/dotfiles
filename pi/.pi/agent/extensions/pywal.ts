import { execFileSync } from "node:child_process";
import { join } from "node:path";
import type { ExtensionAPI } from "@earendil-works/pi-coding-agent";

export default function (pi: ExtensionAPI) {
  pi.registerCommand("pywal", {
    description: "Regenerate pywal theme and reload Pi",
    handler: async (_args, ctx) => {
      const script = join(process.env.HOME ?? "/home/0xShred", ".pi/agent/scripts/pi-pywal-theme.mjs");
      execFileSync(script, { stdio: "ignore" });
      ctx.ui.notify("pywal theme regenerated", "info");
      await ctx.reload();
    },
  });
}
