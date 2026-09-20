import { spawn } from "node:child_process";
import * as readline from "node:readline";
import type { ExtensionAPI, ExtensionCommandContext } from "@earendil-works/pi-coding-agent";
import {
  type AssistantMessage,
  type AssistantMessageEventStream,
  type Context,
  type Model,
  type SimpleStreamOptions,
  createAssistantMessageEventStream,
} from "@earendil-works/pi-ai";

const PROVIDER_ID = "claude-cli";
const PROVIDER_NAME = "Claude Code CLI";

function getClaudeModelArg(modelId: string): string {
  if (modelId.includes("opus")) return "opus";
  if (modelId.includes("haiku")) return "haiku";
  if (modelId.includes("sonnet")) return "claude-sonnet-5";
  return "sonnet";
}

function formatMessagesForClaude(context: Context): string {
  const parts: string[] = [];

  if (context.systemPrompt?.trim()) {
    parts.push(`[System Instructions]\n${context.systemPrompt.trim()}`);
  }

  for (const msg of context.messages) {
    let content = "";
    if (typeof msg.content === "string") {
      content = msg.content;
    } else if (Array.isArray(msg.content)) {
      content = msg.content
        .map((c: any) => {
          if (c.type === "text") return c.text;
          if (c.type === "thinking") return `[Thinking: ${c.thinking}]`;
          if (c.type === "toolCall") return `[Tool Call: ${c.name}(${JSON.stringify(c.arguments)})]`;
          if (c.type === "toolResult") return `[Tool Result: ${typeof c.content === "string" ? c.content : JSON.stringify(c.content)}]`;
          return "";
        })
        .filter(Boolean)
        .join("\n");
    }

    const role = msg.role === "user" ? "User" : msg.role === "assistant" ? "Assistant" : "System";
    parts.push(`${role}:\n${content}`);
  }

  return parts.join("\n\n");
}

function streamClaudeCli(
  model: Model<any>,
  context: Context,
  options?: SimpleStreamOptions,
): AssistantMessageEventStream {
  const stream = createAssistantMessageEventStream();

  const output: AssistantMessage = {
    role: "assistant",
    content: [],
    api: "claude-cli" as any,
    provider: model.provider,
    model: model.id,
    usage: {
      input: 0,
      output: 0,
      cacheRead: 0,
      cacheWrite: 0,
      totalTokens: 0,
      cost: { input: 0, output: 0, cacheRead: 0, cacheWrite: 0, total: 0 },
    },
    stopReason: "pending",
    timestamp: Date.now(),
  };

  const modelArg = getClaudeModelArg(model.id);
  const prompt = formatMessagesForClaude(context);

  const claudeArgs = [
    "-p",
    "--model",
    modelArg,
    "--output-format=stream-json",
    "--include-partial-messages",
    "--verbose",
    "--tools",
    "",
    "--no-session-persistence",
  ];

  const claudeBin = process.env.CLAUDE_BIN || "claude";
  const child = spawn(claudeBin, claudeArgs, {
    stdio: ["pipe", "pipe", "pipe"],
    env: { ...process.env },
  });

  let stderrText = "";
  child.stderr.on("data", (chunk) => {
    stderrText += chunk.toString();
  });

  if (options?.signal) {
    const onAbort = () => {
      try {
        child.kill("SIGTERM");
      } catch {}
    };
    if (options.signal.aborted) {
      onAbort();
    } else {
      options.signal.addEventListener("abort", onAbort, { once: true });
    }
  }

  stream.push({ type: "start", partial: output });

  const rl = readline.createInterface({
    input: child.stdout,
    crlfDelay: Infinity,
  });

  rl.on("line", (line) => {
    const trimmed = line.trim();
    if (!trimmed.startsWith("{")) return;

    try {
      const data = JSON.parse(trimmed);

      if (data.type === "stream_event" && data.event) {
        const ev = data.event;

        if (ev.type === "content_block_start") {
          if (ev.content_block?.type === "thinking") {
            output.content.push({ type: "thinking", thinking: "" });
            stream.push({
              type: "thinking_start",
              contentIndex: output.content.length - 1,
              partial: output,
            });
          } else if (ev.content_block?.type === "text") {
            output.content.push({ type: "text", text: "" });
            stream.push({
              type: "text_start",
              contentIndex: output.content.length - 1,
              partial: output,
            });
          }
        } else if (ev.type === "content_block_delta") {
          const contentIndex = ev.index ?? (output.content.length - 1);
          const block = output.content[contentIndex];

          if (ev.delta?.type === "thinking_delta" && block && block.type === "thinking") {
            block.thinking += ev.delta.thinking;
            stream.push({
              type: "thinking_delta",
              contentIndex,
              delta: ev.delta.thinking,
              partial: output,
            });
          } else if (ev.delta?.type === "text_delta" && block && block.type === "text") {
            block.text += ev.delta.text;
            stream.push({
              type: "text_delta",
              contentIndex,
              delta: ev.delta.text,
              partial: output,
            });
          }
        } else if (ev.type === "content_block_stop") {
          const contentIndex = ev.index ?? (output.content.length - 1);
          const block = output.content[contentIndex];

          if (block?.type === "text") {
            stream.push({
              type: "text_end",
              contentIndex,
              content: block.text,
              partial: output,
            });
          } else if (block?.type === "thinking") {
            stream.push({
              type: "thinking_end",
              contentIndex,
              content: block.thinking,
              partial: output,
            });
          }
        }
      } else if (data.type === "result") {
        if (data.usage) {
          output.usage.input = data.usage.input_tokens ?? 0;
          output.usage.output = data.usage.output_tokens ?? 0;
          output.usage.totalTokens = output.usage.input + output.usage.output;
        }
        output.stopReason = "stop";
      }
    } catch {
      // Ignore unparseable lines
    }
  });

  child.on("error", (err) => {
    output.stopReason = "error";
    output.errorMessage = `Failed to spawn Claude Code CLI (${claudeBin}): ${err.message}`;
    stream.push({ type: "error", reason: "error", error: output });
    stream.end();
  });

  child.on("close", (code) => {
    if (output.stopReason === "pending") {
      if (options?.signal?.aborted) {
        output.stopReason = "aborted";
      } else if (code !== 0 && output.content.length === 0) {
        output.stopReason = "error";
        output.errorMessage =
          stderrText.trim() || `Claude Code CLI process exited with code ${code}`;
      } else {
        output.stopReason = "stop";
      }
    }

    if (output.stopReason === "error") {
      stream.push({ type: "error", reason: "error", error: output });
    } else {
      stream.push({ type: "done", reason: output.stopReason, message: output });
    }
    stream.end();
  });

  // Send the prompt to Claude CLI's stdin
  child.stdin.end(prompt, "utf-8");

  return stream;
}

export default function (pi: ExtensionAPI): void {
  // Register Claude Code CLI as a provider
  // Keep Claude CLI available to subagents without exposing it in Pi's interactive picker.
  if (process.env.PI_SUBAGENT !== "1") return;
  pi.registerProvider(PROVIDER_ID, {
    name: PROVIDER_NAME,
    baseUrl: "http://localhost",
    apiKey: "claude-cli-local",
    api: "claude-cli" as any,
    streamSimple: streamClaudeCli,
    models: [
      {
        id: "claude-sonnet-5",
        name: "Claude Sonnet 5 (Claude CLI)",
        reasoning: true,
        input: ["text", "image"],
        cost: { input: 0, output: 0, cacheRead: 0, cacheWrite: 0 },
        contextWindow: 200000,
        maxTokens: 64000,
      },
      {
        id: "claude-opus-5",
        name: "Claude Opus 5 (Claude CLI)",
        reasoning: true,
        input: ["text", "image"],
        cost: { input: 0, output: 0, cacheRead: 0, cacheWrite: 0 },
        contextWindow: 200000,
        maxTokens: 64000,
      },
      {
        id: "claude-haiku-4-5",
        name: "Claude Haiku 4.5 (Claude CLI)",
        reasoning: true,
        input: ["text", "image"],
        cost: { input: 0, output: 0, cacheRead: 0, cacheWrite: 0 },
        contextWindow: 200000,
        maxTokens: 64000,
      },
    ],
  });

  // Register /claude convenience command
  pi.registerCommand("claude", {
    description: "Run a prompt directly through Claude Code CLI",
    handler: async (args: string, ctx: ExtensionCommandContext) => {
      const prompt = args.trim();
      if (!prompt) {
        if (ctx.hasUI) ctx.ui.notify("Usage: /claude <prompt>", "warning");
        else console.log("Usage: /claude <prompt>");
        return;
      }

      if (ctx.hasUI) ctx.ui.notify("Querying Claude Code CLI…", "info");

      const child = spawn(
        process.env.CLAUDE_BIN || "claude",
        ["-p", "--tools", "", "--no-session-persistence"],
        { stdio: ["pipe", "pipe", "pipe"] },
      );

      let stdout = "";
      let stderr = "";

      child.stdout.on("data", (chunk) => {
        stdout += chunk.toString();
      });
      child.stderr.on("data", (chunk) => {
        stderr += chunk.toString();
      });

      child.stdin.end(prompt, "utf-8");

      await new Promise<void>((resolve) => {
        child.on("close", () => resolve());
      });

      if (stdout.trim()) {
        if (ctx.hasUI) {
          ctx.ui.notify(stdout.trim(), "info");
        } else {
          console.log(stdout.trim());
        }
      } else if (stderr.trim()) {
        if (ctx.hasUI) {
          ctx.ui.notify(`Claude Code CLI error: ${stderr.trim()}`, "error");
        } else {
          console.error(stderr.trim());
        }
      }
    },
  });
}
