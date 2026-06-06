/* dwl config.h */
#include <X11/XF86keysym.h>

/* appearance */
static const int sloppyfocus = 1;
static const int bypass_surface_visibility = 0;
static const unsigned int borderpx = 2;
static const float activeopacity = 0.95f;
static const float inactiveopacity = 0.88f;
#include "/home/gabriel/.cache/wal/colors-codex-dwl.h"
static const float fullscreen_bg[] = {0.0f, 0.0f, 0.0f, 1.0f};
static const int smartgaps = 1; /* no outer gap when there is only one tiled window */
static const int monoclegaps = 0; /* outer gaps in monocle layout */
static const unsigned int gappih = 6; /* horizontal inner gap between tiled windows */
static const unsigned int gappiv = 6; /* vertical inner gap between tiled windows */
static const unsigned int gappoh = 6; /* horizontal outer gap between windows and screen edge */
static const unsigned int gappov = 6; /* vertical outer gap between windows and screen edge */

/* tagging - TAGCOUNT must be no greater than 31 */
#define TAGCOUNT (7)

/* logging */
static int log_level = WLR_ERROR;

/* window rules */
static const Rule rules[] = {
    /* app_id              title                 tags mask  isfloating  monitor  isterminal  noswallow */
    {"kitty", NULL, 0, 0, -1, 1, 0},
    {"wallpaper_selector", NULL, 0, 1, -1, 1, 1},
    {"kitty", "Choose Wallpaper", 0, 1, -1, 1, 1},
    {"floating_note", NULL, 0, 1, -1, 1, 1},
    {"Spotify", NULL, 0, 1, -1, 0, 1},
    {NULL, "Spotify", 0, 1, -1, 0, 1},
};

/* layouts */
static const Layout layouts[] = {
    {"[]=", tile},
    {"TTT", bstack},
    {"###", gaplessgrid},
    {"[M]", monocle},
    {"><>", NULL},
};

/* monitors
 * Kanshi handles runtime profile switching (Laptop vs Docked).
 * These monrules are fallback defaults only.
 *
 *   eDP-1   Lenovo 1920x1200  — laptop panel (disabled when docked)
 *   DP-10   Acer KG271        — vertical left (transform 90)
 *   DP-9    Samsung Smart M50D — horizontal right
 */
static const MonitorRule monrules[] = {
    /* name    mfact   nmaster scale  layout       rotate/reflect                 x     y */
    {"eDP-1", 0.5f, 1, 1, &layouts[0], WL_OUTPUT_TRANSFORM_NORMAL, 0, 0},
    {"DP-10", 0.5f, 1, 1, &layouts[1], WL_OUTPUT_TRANSFORM_90, 0, 0},
    {"DP-9", 0.5f, 1, 1, &layouts[0], WL_OUTPUT_TRANSFORM_NORMAL, 1080, 350},
    {NULL, 0.5f, 1, 1, &layouts[0], WL_OUTPUT_TRANSFORM_NORMAL, -1, -1},
};

/* keyboard */
static const struct xkb_rule_names xkb_rules = {
    .layout = "us",
    .options = "caps:escape",
};

static const int repeat_rate = 25;
static const int repeat_delay = 600;

/* touchpad */
static const int tap_to_click = 1;
static const int tap_and_drag = 1;
static const int drag_lock = 0;
static const int natural_scrolling = 0;
static const int disable_while_typing = 1;
static const int left_handed = 0;
static const int middle_button_emulation = 0;
static const enum libinput_config_scroll_method scroll_method = LIBINPUT_CONFIG_SCROLL_2FG;
static const enum libinput_config_click_method click_method =
    LIBINPUT_CONFIG_CLICK_METHOD_BUTTON_AREAS;
static const uint32_t send_events_mode = LIBINPUT_CONFIG_SEND_EVENTS_ENABLED;
static const enum libinput_config_accel_profile accel_profile =
    LIBINPUT_CONFIG_ACCEL_PROFILE_ADAPTIVE;
static const double accel_speed = 0.0;
static const enum libinput_config_tap_button_map button_map = LIBINPUT_CONFIG_TAP_MAP_LRM;

/* commands */
static const char *termcmd[] = {"kitty", NULL};
static const char *menucmd[] = {"sh", "-c", "$HOME/.scripts/app_launcher.sh", NULL};
static const char *browsercmd[] = {"zen-browser", NULL};
static const char *qutecmd[] = {"qutebrowser", NULL};
static const char *filemgrcmd[] = {"dolphin", NULL};
static const char *lockcmd[] = {"swaylock", NULL};
static const char *scrotcmd[] = {"sh", "-c", "~/.scripts/screenshot.sh copy", NULL};
static const char *scrotsavecmd[] = {"sh", "-c", "~/.scripts/screenshot.sh save", NULL};
static const char *powermenucmd[] = {"sh", "-c", "~/.scripts/powermenu.sh", NULL};
static const char *wallpcmd[] = {"kitty", "--class", "wallpaper_selector",      "-e",
                                 "sh",    "-c",      "~/.scripts/wallpaper.sh", NULL};
static const char *clipmenucmd[] = {"sh", "-c", "~/.scripts/clipmenu.sh", NULL};
static const char *notecmd[] = {"sh", "-c", "~/.scripts/quick_note.sh", NULL};
static const char *notesrchcmd[] = {"kitty", "--class", "floating_note",           "-e",
                                    "sh",    "-c",      "~/.scripts/qn_search.sh", NULL};
static const char *cliptocmd[] = {"sh", "-c", "~/.scripts/clip_to_note.sh", NULL};
static const char *aerccmd[] = {"kitty", "-e", "aerc", NULL};
static const char *taskcmd[] = {"kitty", "-e", "taskwarrior-tui", NULL};
static const char *volup[] = {"sh", "-c", "~/.scripts/volume.sh up", NULL};
static const char *voldown[] = {"sh", "-c", "~/.scripts/volume.sh down", NULL};
static const char *volmute[] = {"sh", "-c", "~/.scripts/volume.sh mute", NULL};
static const char *micmute[] = {"pactl", "set-source-mute", "@DEFAULT_SOURCE@", "toggle", NULL};
static const char *brup[] = {"sh", "-c", "~/.scripts/brightness.sh up", NULL};
static const char *brdown[] = {"sh", "-c", "~/.scripts/brightness.sh down", NULL};
static const char *nwgdisps[] = {"nwg-displays", NULL};
static const char *qbwcmd[] = {"sh", "-c", "~/.scripts/qutebw.sh", NULL};
static const char *spotifycmd[] = {
    "sh", "-c", "spotify-launcher --skip-update >/tmp/spotify-scratchpad.log 2>&1", NULL};
static const char *togglebarcmd[] = {"sh", "-c", "$HOME/.local/bin/somebar -c 'toggle selected'",
                                     NULL};
static const char *reloadbar[] = {"sh", "-c", "$HOME/.scripts/reload-somebar.sh", NULL};

static const Scratchpad scratchpads[] = {
    {"Spotify", "Spotify", spotifycmd},
};

#define MODKEY WLR_MODIFIER_LOGO

/* TAGKEYS uses KEY (unshifted) and SKEY (shifted) per config.def.h convention */
#define TAGKEYS(KEY, SKEY, TAG)                                                                    \
    {MODKEY, KEY, view, {.ui = 1 << TAG}},                                                         \
        {MODKEY | WLR_MODIFIER_CTRL, KEY, toggleview, {.ui = 1 << TAG}},                           \
        {MODKEY | WLR_MODIFIER_SHIFT, SKEY, tag, {.ui = 1 << TAG}},                                \
        {MODKEY | WLR_MODIFIER_CTRL | WLR_MODIFIER_SHIFT, SKEY, toggletag, {.ui = 1 << TAG}},

static const Key keys[] = {
    /* modifier                  key                       function          argument */

    /* apps */
    {MODKEY, XKB_KEY_Return, spawn, {.v = termcmd}},
    {MODKEY, XKB_KEY_d, spawn, {.v = menucmd}},
    {MODKEY, XKB_KEY_b, spawn, {.v = browsercmd}},
    {MODKEY | WLR_MODIFIER_SHIFT, XKB_KEY_B, spawn, {.v = qutecmd}},
    {MODKEY | WLR_MODIFIER_ALT, XKB_KEY_b, spawn, {.v = qbwcmd}},
    {MODKEY | WLR_MODIFIER_CTRL, XKB_KEY_b, spawn, {.v = togglebarcmd}},
    {MODKEY, XKB_KEY_w, spawn, {.v = wallpcmd}},
    {MODKEY, XKB_KEY_e, spawn, {.v = filemgrcmd}},
    {MODKEY, XKB_KEY_a, spawn, {.v = aerccmd}},
    {MODKEY, XKB_KEY_t, spawn, {.v = taskcmd}},
    {MODKEY | WLR_MODIFIER_SHIFT, XKB_KEY_P, togglescratch, {.ui = 0}},

    /* screenshots */
    {MODKEY, XKB_KEY_s, spawn, {.v = scrotcmd}},
    {MODKEY | WLR_MODIFIER_SHIFT, XKB_KEY_S, spawn, {.v = scrotsavecmd}},

    /* system */
    {MODKEY, XKB_KEY_p, spawn, {.v = powermenucmd}},
    {MODKEY | WLR_MODIFIER_ALT, XKB_KEY_l, spawn, {.v = lockcmd}},
    {MODKEY | WLR_MODIFIER_SHIFT, XKB_KEY_M, spawn, {.v = nwgdisps}},
    {MODKEY, XKB_KEY_r, spawn, {.v = reloadbar}},
    {MODKEY | WLR_MODIFIER_SHIFT, XKB_KEY_R, reloadcolors, {0}},

    /* clipboard & notes */
    {MODKEY | WLR_MODIFIER_SHIFT, XKB_KEY_C, spawn, {.v = clipmenucmd}},
    {MODKEY, XKB_KEY_n, spawn, {.v = notecmd}},
    {MODKEY | WLR_MODIFIER_SHIFT, XKB_KEY_N, spawn, {.v = notesrchcmd}},
    {MODKEY, XKB_KEY_c, spawn, {.v = cliptocmd}},

    /* volume */
    {MODKEY, XKB_KEY_m, spawn, {.v = volmute}},
    {0, XF86XK_AudioRaiseVolume, spawn, {.v = volup}},
    {0, XF86XK_AudioLowerVolume, spawn, {.v = voldown}},
    {0, XF86XK_AudioMute, spawn, {.v = volmute}},
    {0, XF86XK_AudioMicMute, spawn, {.v = micmute}},

    /* brightness */
    {0, XF86XK_MonBrightnessUp, spawn, {.v = brup}},
    {0, XF86XK_MonBrightnessDown, spawn, {.v = brdown}},

    /* focus */
    {MODKEY, XKB_KEY_h, focusstack, {.i = +1}},
    {MODKEY, XKB_KEY_l, focusstack, {.i = -1}},
    {MODKEY, XKB_KEY_Left, focusstack, {.i = +1}},
    {MODKEY, XKB_KEY_Right, focusstack, {.i = -1}},
    {MODKEY, XKB_KEY_j, focusstack, {.i = +1}},
    {MODKEY, XKB_KEY_k, focusstack, {.i = -1}},
    {MODKEY, XKB_KEY_Up, focusstack, {.i = -1}},
    {MODKEY, XKB_KEY_Down, focusstack, {.i = +1}},
    {MODKEY | WLR_MODIFIER_SHIFT, XKB_KEY_j, movestack, {.i = +1}},
    {MODKEY | WLR_MODIFIER_SHIFT, XKB_KEY_k, movestack, {.i = -1}},
    {MODKEY | WLR_MODIFIER_SHIFT, XKB_KEY_Down, movestack, {.i = +1}},
    {MODKEY | WLR_MODIFIER_SHIFT, XKB_KEY_Up, movestack, {.i = -1}},

    /* window management */
    {MODKEY, XKB_KEY_q, killclient, {0}},
    {MODKEY, XKB_KEY_f, togglefullscreen, {0}},
    {MODKEY, XKB_KEY_v, togglefloating, {0}},
    {MODKEY | WLR_MODIFIER_SHIFT, XKB_KEY_Return, zoom, {0}},

    /* nmaster */
    {MODKEY, XKB_KEY_i, incnmaster, {.i = +1}},
    {MODKEY, XKB_KEY_u, incnmaster, {.i = -1}},

    /* resize master */
    {MODKEY | WLR_MODIFIER_CTRL, XKB_KEY_h, setmfact, {.f = -0.05f}},
    {MODKEY | WLR_MODIFIER_CTRL, XKB_KEY_l, setmfact, {.f = +0.05f}},

    /* layouts */
    {MODKEY, XKB_KEY_F1, setlayout, {.v = &layouts[0]}},
    {MODKEY, XKB_KEY_F2, setlayout, {.v = &layouts[1]}},
    {MODKEY, XKB_KEY_F3, setlayout, {.v = &layouts[2]}},
    {MODKEY, XKB_KEY_F4, setlayout, {.v = &layouts[3]}},
    {MODKEY, XKB_KEY_F5, setlayout, {.v = &layouts[4]}},

    /* tags */
    {MODKEY, XKB_KEY_Tab, view, {0}},
    {WLR_MODIFIER_ALT, XKB_KEY_Tab, focusstack, {.i = +1}},
    {WLR_MODIFIER_ALT | WLR_MODIFIER_SHIFT, XKB_KEY_Tab, focusstack, {.i = -1}},
    {MODKEY, XKB_KEY_grave, view, {.ui = ~0}},
    TAGKEYS(XKB_KEY_1, XKB_KEY_exclam, 0) TAGKEYS(XKB_KEY_2, XKB_KEY_at, 1)
        TAGKEYS(XKB_KEY_3, XKB_KEY_numbersign, 2) TAGKEYS(XKB_KEY_4, XKB_KEY_dollar, 3)
            TAGKEYS(XKB_KEY_5, XKB_KEY_percent, 4) TAGKEYS(XKB_KEY_6, XKB_KEY_asciicircum, 5)
                TAGKEYS(XKB_KEY_7, XKB_KEY_ampersand, 6)

    /* monitor focus */
    {MODKEY, XKB_KEY_comma, focusmon, {.i = WLR_DIRECTION_LEFT}},
    {MODKEY, XKB_KEY_period, focusmon, {.i = WLR_DIRECTION_RIGHT}},
    {MODKEY | WLR_MODIFIER_SHIFT, XKB_KEY_less, tagmon, {.i = WLR_DIRECTION_LEFT}},
    {MODKEY | WLR_MODIFIER_SHIFT, XKB_KEY_greater, tagmon, {.i = WLR_DIRECTION_RIGHT}},

/* VT switching */
#define CHVT(n)                                                                                    \
    {                                                                                              \
        WLR_MODIFIER_CTRL | WLR_MODIFIER_ALT, XKB_KEY_XF86Switch_VT_##n, chvt, {                   \
            .ui = (n)                                                                              \
        }                                                                                          \
    }
    CHVT(1),
    CHVT(2),
    CHVT(3),
    CHVT(4),
    CHVT(5),
    CHVT(6),
    CHVT(7),
    CHVT(8),
    CHVT(9),
    CHVT(10),
    CHVT(11),
    CHVT(12),

    /* exit */
    {MODKEY | WLR_MODIFIER_SHIFT, XKB_KEY_E, quit, {0}},
    {WLR_MODIFIER_CTRL | WLR_MODIFIER_ALT, XKB_KEY_Terminate_Server, quit, {0}},
};

static const Button buttons[] = {
    {MODKEY, BTN_LEFT, moveresize, {.ui = CurMove}},
    {MODKEY, BTN_MIDDLE, togglefloating, {0}},
    {MODKEY, BTN_RIGHT, moveresize, {.ui = CurResize}},
};
