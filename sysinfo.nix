{ pkgs }:

pkgs.writeShellScriptBin "sysinfo" ''
if [ $1 == "cpu" ]; then
  read cpu user nice system idle iowait irq softirq steal guest < /proc/stat

  # compute active and total utilizations
  cpu_active_prev=$((user+system+nice+softirq+steal))
  cpu_total_prev=$((user+system+nice+softirq+steal+idle+iowait))

  usleep 50000

  # Read /proc/stat file (for second datapoint)
  read cpu user nice system idle iowait irq softirq steal guest< /proc/stat

  # compute active and total utilizations
  cpu_active_cur=$((user+system+nice+softirq+steal))
  cpu_total_cur=$((user+system+nice+softirq+steal+idle+iowait))

  # compute CPU utilization (%)
  cpu_del_active=$(($cpu_active_cur-$cpu_active_prev))
  cpu_del_total=$(($cpu_total_cur-$cpu_total_prev))

  echo "scale=1;100*$cpu_del_active/$cpu_del_total" | bc

elif [ $1 == "memory" ]; then
  mem_total=$(awk '/MemTotal/ { printf "%.3f \n", $2/1024/1024 }' /proc/meminfo)
  mem_ava=$(awk '/MemAvailable/ { printf "%.3f \n", $2/1024/1024 }' /proc/meminfo)
  mem_util=$(echo "$mem_total $mem_ava" | awk '{print ($1 - $2)}')

  printf "%.1f" "$mem_util"
fi
''
