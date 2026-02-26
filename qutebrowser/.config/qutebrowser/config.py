import os
import typing
import pywalQute.draw

# --- Linter Fix ---
if typing.TYPE_CHECKING:
    c: typing.Any = {}
    config: typing.Any = {}

# Load autoconfig first
config.load_autoconfig()

# Apply pywal colors (~/.cache/wal/colors)
pywalQute.draw.color(c, {"spacing": {"vertical": 6, "horizontal": 8}})

# Default browser
c.auto_save.session = True
c.session.default_name = "persistent"
c.auto_save.interval = 15000
c.session.lazy_restore = True

# Editor
c.editor.command = ["nvim", "{file}", "-c", "normal {line}G{column0}l"]

# Downloads
c.downloads.location.prompt = True

# --- Appearance ---
c.fonts.default_family = "JetBrainsMono Nerd Font Mono"
c.fonts.default_size = "11pt"
c.fonts.completion.entry = "11pt JetBrainsMono Nerd Font Mono"
c.fonts.debug_console = "11pt JetBrainsMono Nerd Font Mono"
c.fonts.prompts = "11pt JetBrainsMono Nerd Font Mono"
c.fonts.statusbar = "11pt JetBrainsMono Nerd Font Mono"

# Dark mode
c.colors.webpage.preferred_color_scheme = "dark"
c.colors.webpage.darkmode.enabled = True
c.colors.webpage.darkmode.policy.images = "never"

# --- UI Behaviour ---

# tabs
c.tabs.show = "multiple"
c.tabs.position = "top"
c.tabs.width = 150
c.tabs.favicons.show = "always"  # Show favicons on tabs
c.tabs.title.format = "{audio}{index}: {current_title}"  # Include audio indicator
c.tabs.background = True  # Open new tabs in background
c.tabs.pinned.frozen = True  # Prevent pinned tabs from unloading

# Status bar
c.statusbar.show = "always"
c.statusbar.widgets = ["keypress", "url", "scroll", "history", "tabs", "progress"]

# Download bar
c.downloads.position = "top"  # Show downloads at top
c.downloads.remove_finished = 1000  # Remove finished downloads after 1 sec

# hints
c.hints.leave_on_load = True  # Leave hint mode after clicking
c.hints.scatter = True  # Better positioning for hints

# --- Content & Privacy ---
c.content.blocking.enabled = True
c.content.blocking.method = "adblock"
c.content.javascript.clipboard = "access"
c.content.pdfjs = True
c.content.cookies.accept = "no-3rdparty"
c.content.headers.user_agent = (
    "Mozilla/5.0 (X11; Linux x86_64; rv:109.0) Gecko/20100101 Firefox/115.0"
)
c.content.blocking.adblock.lists = [
    "https://easylist.to/easylist/easylist.txt",
    "https://easylist.to/easylist/easyprivacy.txt",
    "https://secure.fanboy.co.nz/fanboy-annoyance.txt",
]
c.content.headers.referer = "same-domain"
c.content.headers.do_not_track = True

# --- Search Engines ---
c.url.searchengines = {
    "DEFAULT": "https://duckduckgo.com/?q={}",
    "!g": "https://www.google.com/search?hl=en&q={}",
    "!r": "https://www.reddit.com/search?q={}",
    "!gh": "https://github.com/search?q={}",
    "!aw": "https://wiki.archlinux.org/index.php?search={}",
    "!yt": "https://www.youtube.com/results?search_query={}",
    "!so": "https://stackoverflow.com/search?q={}",
    "!gem": "https://gemini.google.com/app?q={}",
    "!a": "https://www.amazon.com/s?k={}",
    "!w": "https://en.wikipedia.org/wiki/{}",
}

# --- Aliases ---
c.aliases = {
    "w": "session-save",
    "wl": "session-load",
    "wd": "session-delete",
    "q": "close",
    "qa": "quit",
    "hist": "history",
    "bm": "bookmark-list",
    "r": "config-source",
}

# --- Keybindings ---

# 1. Bitwarden
config.bind("<Ctrl-p>", "spawn --userscript qute-bitwarden")
config.bind("<Ctrl-Shift-p>", "spawn --userscript qute-bitwarden --totp")

# 2. Media (MPV)
config.bind("M", "hint links spawn mpv {hint-url}")
config.bind(";M", "spawn mpv {url}")

# 3. Toggles
config.bind("td", "config-cycle colors.webpage.darkmode.enabled true false")
config.bind("ta", "config-cycle content.blocking.enabled true false")
config.bind("ts", "config-cycle statusbar.show always never")

# 4. Zoom
config.bind("+", "zoom-in")
config.bind("-", "zoom-out")
config.bind("zz", "zoom")

# 5. Tab navigation
config.bind("J", "tab-next")
config.bind("K", "tab-prev")
config.bind("alt-1", "tab-focus 1")
config.bind("alt-2", "tab-focus 2")
config.bind("alt-3", "tab-focus 3")

# 6. Additional useful bindings
config.bind("<Ctrl-t>", "open -t")  # New tab
config.bind("<Ctrl-h>", "open qute://history")  # history
config.bind("<Ctrl-b>", "open qute://bookmarks")  # bookmarks
config.bind("<Ctrl-Shift-r>", "reload -f")  # force reload
config.bind("<F11>", "fullscreen")  # toggle fullscreen
config.bind("<Ctrl-n>", "open -w")  # new window
config.bind("<Ctrl-Shift-v>", "insert-text -- {clipboard}", mode="insert")  # paste

# 7. Performance
c.content.cache.size = 512 * 1024 * 1024  # 512 MB
c.content.dns_prefetch = True
c.qt.args = ["enable-gpu-rasterization", "enable-native-gpu-memory-buffers"]
