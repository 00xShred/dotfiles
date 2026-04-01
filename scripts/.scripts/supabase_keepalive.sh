#!/bin/bash

URLS=(
    "https://screen-savor.gawindlin.com/"
    "https://our-place.gawindlin.com/"
)

for url in "${URLS[@]}"; do
    response=$(curl -s -o /dev/null -w "%{http_code}" --max-time 10 "$url")
    echo "$(date '+%Y-%m-%d %H:%M:%S') $url -> $response"
done
