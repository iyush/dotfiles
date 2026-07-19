import type { ExtensionAPI } from "@earendil-works/pi-coding-agent";
import { Type } from "typebox";
import { execFile } from "node:child_process";
import { mkdir, readFile } from "node:fs/promises";
import { join } from "node:path";
import { tmpdir } from "node:os";

function run(command: string, args: string[]): Promise<void> {
  return new Promise((resolve, reject) => {
    execFile(command, args, { timeout: 15_000 }, (error) => {
      if (error) reject(error);
      else resolve();
    });
  });
}

async function captureScreenshot() {
  const dir = join(tmpdir(), "pi-screenshots");
  await mkdir(dir, { recursive: true });

  const path = join(dir, `screenshot-${Date.now()}.png`);

  try {
    await run("grim", [path]);
  } catch (error) {
    throw new Error(
      `Failed to take screenshot with grim. Install grim first. Original error: ${error instanceof Error ? error.message : String(error)}`,
    );
  }

  const data = (await readFile(path)).toString("base64");
  return { path, data };
}

export default function (pi: ExtensionAPI) {
  pi.registerTool({
    name: "screenshot_review",
    label: "Screenshot Review",
    description: "Take a screenshot of the current desktop and return it as an image so the model can visually inspect UI changes.",
    promptSnippet: "Take a desktop screenshot and inspect the visual result of UI changes",
    promptGuidelines: [
      "Use screenshot_review after changing visible UI such as Quickshell, Waybar, Hyprland, themes, or layouts so you can inspect what was actually rendered.",
    ],
    parameters: Type.Object({
      note: Type.Optional(Type.String({ description: "Optional note about what to inspect in the screenshot." })),
    }),
    async execute(_toolCallId, params) {
      const shot = await captureScreenshot();
      const note = params.note ? `\nFocus: ${params.note}` : "";

      return {
        content: [
          { type: "text", text: `Screenshot captured: ${shot.path}${note}` },
          { type: "image", mimeType: "image/png", data: shot.data },
        ],
        details: { path: shot.path },
      };
    },
  });

  pi.registerCommand("screenshot-review", {
    description: "Take a desktop screenshot and send it to the current model for visual review",
    handler: async (args) => {
      const shot = await captureScreenshot();
      const prompt = args?.trim() || "Review this screenshot. Describe visual problems and suggest concrete fixes.";

      pi.sendUserMessage([
        { type: "text", text: prompt },
        { type: "image", mimeType: "image/png", data: shot.data },
      ]);
    },
  });
}
