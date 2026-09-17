import type { ExtensionAPI } from "@earendil-works/pi-coding-agent";

export default function (pi: ExtensionAPI) {
	pi.registerMarkdownTransformer((markdown) => {
		// Clean up HTML keyboard badges into Markdown inline code
		let text = markdown.replace(/<kbd>(.*?)<\/kbd>/gi, "`$1`");
		// Replace HTML break tags with newlines
		text = text.replace(/<br\s*\/?>/gi, "\n");
		return text;
	});
}
