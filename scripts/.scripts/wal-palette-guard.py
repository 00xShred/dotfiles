#!/usr/bin/env python3
"""
wal-palette-guard.py
Ensures pywal palettes always have distinct, high-contrast accent colors,
especially when using dark, monochrome, or low-saturation wallpapers.
Defaults to the vibrant palette from brightAlleyJap.jpg if accents are lacking.
"""

import sys
import os
import json
import colorsys
from pywal import export, sequences

WAL_CACHE = os.path.expanduser("~/.cache/wal/colors.json")

# Default vibrant accents extracted from brightAlleyJap.jpg
BRIGHT_ALLEY_ACCENTS = {
    "color1": "#A11B4D",  # Rose / Red
    "color2": "#C1A554",  # Gold / Amber
    "color3": "#09599B",  # Deep Blue
    "color4": "#3A5AA7",  # Soft Blue
    "color5": "#B661A5",  # Violet / Magenta
    "color6": "#2B9FDE",  # Vivid Cyan
    "color8": "#575a6b",  # Muted Slate Gray
    "color9": "#A11B4D",
    "color10": "#C1A554",
    "color11": "#09599B",
    "color12": "#3A5AA7",
    "color13": "#B661A5",
    "color14": "#2B9FDE",
}

def hex_to_hls(hex_str):
    hex_clean = hex_str.lstrip("#")
    r, g, b = [int(hex_clean[i:i+2], 16) / 255.0 for i in (0, 2, 4)]
    return colorsys.rgb_to_hls(r, g, b)

def is_lacking_accents(data):
    colors = data.get("colors", {})
    sats = []
    lights = []
    low_sat_count = 0

    for i in range(1, 7):
        key = f"color{i}"
        if key not in colors:
            continue
        h, l, s = hex_to_hls(colors[key])
        sats.append(s)
        lights.append(l)
        if s < 0.18:
            low_sat_count += 1

    if not sats or not lights:
        return True

    avg_sat = sum(sats) / len(sats)
    max_light = max(lights)
    avg_light = sum(lights) / len(lights)

    # Trigger if:
    # 1. All colors are dark mud (max lightness < 0.22)
    # 2. Average saturation is very low (< 0.22)
    # 3. 4 or more of the 6 accent colors have near-zero saturation
    return (max_light < 0.22) or (avg_sat < 0.22) or (low_sat_count >= 4)

def apply_guard(force=False):
    if not os.path.isfile(WAL_CACHE):
        return False

    with open(WAL_CACHE, "r") as f:
        data = json.load(f)

    lacking = is_lacking_accents(data)

    if not lacking and not force:
        print("[wal-palette-guard] Palette has healthy accents. No adjustment needed.")
        return False

    print("[wal-palette-guard] Dark/monochrome palette detected! Injecting brightAlleyJap accents...")

    # Preserve background (color0 & special.background) and foreground
    # Update accent colors 1..6, 8, 9..14
    for k, v in BRIGHT_ALLEY_ACCENTS.items():
        data["colors"][k] = v

    # Ensure foreground is legible (at least 60% lightness)
    fg = data.get("special", {}).get("foreground", "#c1c1c4")
    _, fg_l, _ = hex_to_hls(fg)
    if fg_l < 0.60:
        data["special"]["foreground"] = "#c1c1c4"
        data["special"]["cursor"] = "#c1c1c4"
        data["colors"]["color7"] = "#c1c1c4"
        data["colors"]["color15"] = "#c1c1c4"

    # Save modified json
    with open(WAL_CACHE, "w") as f:
        json.dump(data, f, indent=4)

    # Re-export all templates and send terminal sequences
    export.every(data)
    sequences.send(data)
    print("[wal-palette-guard] Successfully refreshed templates and terminal colors.")
    return True

if __name__ == "__main__":
    force_run = "--force" in sys.argv
    apply_guard(force=force_run)
