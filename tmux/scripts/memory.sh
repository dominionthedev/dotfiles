#!/bin/bash

PAGE_SIZE=$(vm_stat | awk '/page size of/ {print $8}')

read PAGES_ACTIVE PAGES_INACTIVE PAGES_WIRED PAGES_COMPRESSED <<< $(
  vm_stat | awk '
    /Pages active:/ {a=$3}
    /Pages inactive:/ {i=$3}
    /Pages wired down:/ {w=$4}
    /Pages occupied by compressor:/ {c=$5}
    END {gsub(/\./,"",a); gsub(/\./,"",i); gsub(/\./,"",w); gsub(/\./,"",c); print a, i, w, c}
  '
)

USED_PAGES=$((PAGES_ACTIVE + PAGES_WIRED + PAGES_COMPRESSED))
TOTAL_MEM=$(sysctl -n hw.memsize)

USED_BYTES=$((USED_PAGES * PAGE_SIZE))

PCT=$(echo "scale=0; ($USED_BYTES*100)/$TOTAL_MEM" | bc)

if [ "$PCT" -ge 80 ]; then
  echo "#[fg=#{@red}]#[bg=#{@red},fg=#{@base}]󰍛 #[bg=#{@surface0},fg=#{@red},bold] ${PCT}%"
elif [ "$PCT" -ge 70 ]; then
  echo "#[fg=#{@yellow}]#[bg=#{@yellow},fg=#{@base}]󰍛 #[bg=#{@surface0},fg=#{@yellow}] ${PCT}%"
else
  echo "#[fg=#{@sapphire}]#[bg=#{@sapphire},fg=#{@base}]󰍛 #[bg=#{@surface0},fg=#{@sapphire}] ${PCT}%"
fi
