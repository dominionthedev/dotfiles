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

USED_GB=$(echo "scale=2; $USED_BYTES/1024/1024/1024" | bc)
TOTAL_GB=$(echo "scale=0; $TOTAL_MEM/1024/1024/1024" | bc)

PCT=$(echo "scale=0; ($USED_BYTES*100)/$TOTAL_MEM" | bc)

if [ "$PCT" -ge 80 ]; then
  echo "#[fg=#{@red},bold]󰍛 ${PCT}%#[default]"
elif [ "$PCT" -ge 70 ]; then
  echo "#[fg=#{@yellow}]󰍛 ${PCT}%"
else
  echo "#[fg=#{@blue}]󰍛 ${PCT}%"
fi
