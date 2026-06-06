#!/bin/sh

battery() {
	for bat in /sys/class/power_supply/BAT*; do
		[ -r "$bat/capacity" ] || continue
		capacity=$(cat "$bat/capacity")
		bat_status=$(cat "$bat/status" 2>/dev/null)
		case "$bat_status" in
			Charging|Full) icon="󰂄" ;;
			*) icon="󰁹" ;;
		esac
		printf "%s %s%%" "$icon" "$capacity"
		return
	done
}

ram_usage() {
	awk '/MemTotal/ { total=$2 } /MemAvailable/ { avail=$2 } END {
		printf "󰍛 %.1fG", (total - avail) / 1048576
	}' /proc/meminfo
}

temp() {
	for zone in /sys/class/thermal/thermal_zone*/temp; do
		[ -r "$zone" ] || continue
		t=$(cat "$zone")
		printf " %d°C" "$((t / 1000))"
		return
	done
}

power_profile() {
	profile="$(powerprofilesctl get 2>/dev/null)" || return
	case "$profile" in
		performance) printf "󱐋 perf" ;;
		balanced)    printf "󰾅 bal" ;;
		power-saver) printf "󰌪 eco" ;;
		*)           printf "%s" "$profile" ;;
	esac
}

if [ -x "$HOME/.local/bin/somebar" ]; then
	somebar_cmd="$HOME/.local/bin/somebar"
elif command -v somebar >/dev/null 2>&1; then
	somebar_cmd="somebar"
else
	exit 0
fi

send_status() {
	local fifo="" pid fd target
	for pid in $(pgrep -x somebar 2>/dev/null); do
		for fd in /proc/"$pid"/fd/*; do
			target=$(readlink "$fd" 2>/dev/null)
			case "$target" in
				*/somebar-[0-9]*) fifo="$target"; break 2 ;;
			esac
		done
	done
	[ -n "$fifo" ] && printf 'status %s\n' "$1" > "$fifo" 2>/dev/null
}

cpu_prev_idle=0
cpu_prev_total=0

while :; do
	# CPU usage computed inline — subshells can't persist state
	read -r _ user nice system idle iowait irq softirq steal _rest < /proc/stat
	idle_val=$((idle + iowait))
	total=$((user + nice + system + idle + iowait + irq + softirq + steal))
	diff_idle=$((idle_val - cpu_prev_idle))
	diff_total=$((total - cpu_prev_total))
	[ "$diff_total" -gt 0 ] \
		&& cpu_pct=$(( (diff_total - diff_idle) * 100 / diff_total )) \
		|| cpu_pct=0
	cpu_prev_idle=$idle_val
	cpu_prev_total=$total

	media="$(playerctl metadata --format '󰎆 {{artist}} - {{title}}' 2>/dev/null)"
	datetime="$(date '+%-d %b  %H:%M')"
	bat="$(battery)"
	ram="$(ram_usage)"
	temperature="$(temp)"
	profile="$(power_profile)"

	center="${media:+$media   }${datetime}"
	stats="${bat:+$bat  }󰻠 ${cpu_pct}%  ${ram}  ${temperature}${profile:+  $profile}"
	send_status "${center}"$'\x1f'"${stats}"
	sleep 5
done
