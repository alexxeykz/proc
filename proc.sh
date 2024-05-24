#!/usr/bin/env bash

proc_uptime=$(TZ=UTC date -d@$(cut -d\  -f1 /proc/uptime) +'%j %T' | awk '{print $1-1"d",$2}')

clk_tck=$(getconf CLK_TCK)

echo "PID||TTY||STAT||TIME||COMMAND"

for pid in $(ls -ln /proc | awk '{print $9}' | grep -s "^[0-9]*[0-9]$"| sort -n );
do

tty=$(cat 2>/dev/null /proc/$pid/stat | awk '{print $7}')
stat=$(cat 2>/dev/null /proc/$pid/stat | awk '{print $3}')
cmd=$(cat 2>/dev/null /proc/$pid/cmdline | awk '{print $0}')

timeu=$(cat 2>/dev/null /proc/$pid/stat | awk '{print $14}')
times=$(cat  2>/dev/null /proc/$pid/stat | awk '{print $17}')


ntime=$((timeu + times))
time=$((ntime / clk_tck))
printf "%-8s | %-15s | %s\n" "$pid | $tty | $stat | $time | $cmd" | column -t  -s '|'
done
echo "uptime:  $proc_uptime"
