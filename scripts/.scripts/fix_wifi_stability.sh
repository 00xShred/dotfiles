#!/bin/bash
# WiFi Stability Fix Script

echo "Applying WiFi stability settings..."

# Get current active WiFi connection
CURRENT_CONN=$(nmcli -t -f NAME,TYPE,DEVICE connection show --active | grep wifi | cut -d: -f1)

if [ -n "$CURRENT_CONN" ]; then
    echo "Current WiFi connection: $CURRENT_CONN"
    
    # Apply stability settings
    nmcli connection modify "$CURRENT_CONN" \
      802-11-wireless.cloned-mac-address permanent \
      connection.autoconnect-priority 50 \
      wifi.mac-address-randomization 0
    
    echo "Stability settings applied to: $CURRENT_CONN"
else
    echo "No active WiFi connection found."
fi

# Also set global NetworkManager settings for better roaming
sudo tee /etc/NetworkManager/conf.d/wifi-stability.conf << 'INNEREOF'
[connection]
wifi.powersave=2
wifi.scan-rand-mac-address=no

[device]
wifi.scan-rand-mac-address=no
INNEREOF

# Restart NetworkManager to apply global settings
sudo systemctl restart NetworkManager

echo "WiFi stability fixes applied. Reconnect to your network."
