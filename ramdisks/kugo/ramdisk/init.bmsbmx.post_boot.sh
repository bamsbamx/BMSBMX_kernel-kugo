#!/system/bin/sh

setprop ro.hwui.texture_cache_size 32
setprop ro.config.zram false
setprop ro.core_ctl_min_cpu 1

echo 95 > /proc/sys/kernel/sched_upmigrate
echo 85 > /proc/sys/kernel/sched_downmigrate

# The following will make most runnable tasks be assigned to most power efficient CPUs (LITTLE cluster)
echo 3 > /sys/devices/system/cpu/cpu0/sched_mostly_idle_nr_run
echo 3 > /sys/devices/system/cpu/cpu1/sched_mostly_idle_nr_run
echo 3 > /sys/devices/system/cpu/cpu2/sched_mostly_idle_nr_run
echo 3 > /sys/devices/system/cpu/cpu3/sched_mostly_idle_nr_run
echo 2 > /sys/devices/system/cpu/cpu4/sched_mostly_idle_nr_run
echo 2 > /sys/devices/system/cpu/cpu5/sched_mostly_idle_nr_run

# Disable thermal & BCL core_control to avoid changes in the CPU frequencies
echo 0 > /sys/module/msm_thermal/core_control/enabled
for mode in /sys/devices/soc.0/qcom,bcl.*/mode
do
    echo -n disable > $mode
done
for hotplug_mask in /sys/devices/soc.0/qcom,bcl.*/hotplug_mask
do
    echo 0 > $hotplug_mask
done
for hotplug_soc_mask in /sys/devices/soc.0/qcom,bcl.*/hotplug_soc_mask
do
    echo 0 > $hotplug_soc_mask
done
for mode in /sys/devices/soc.0/qcom,bcl.*/mode
do
    echo -n enable > $mode
done

# enable governor for power cluster
echo 1 > /sys/devices/system/cpu/cpu0/online
echo "ondemand" > /sys/devices/system/cpu/cpu0/cpufreq/scaling_governor
echo 0 > /sys/devices/system/cpu/cpu0/cpufreq/ondemand/ignore_nice_load
echo 0 > /sys/devices/system/cpu/cpu0/cpufreq/ondemand/io_is_busy
echo 0 > /sys/devices/system/cpu/cpu0/cpufreq/ondemand/powersave_bias
echo 4 > /sys/devices/system/cpu/cpu0/cpufreq/ondemand/sampling_down_factor
echo 50000 > /sys/devices/system/cpu/cpu0/cpufreq/ondemand/sampling_rate
echo 50000 > /sys/devices/system/cpu/cpu0/cpufreq/ondemand/sampling_rate_min
echo 90 > /sys/devices/system/cpu/cpu0/cpufreq/ondemand/up_threshold
echo 400000 > /sys/devices/system/cpu/cpu0/cpufreq/scaling_min_freq
echo 1017000 > /sys/devices/system/cpu/cpu0/cpufreq/scaling_max_freq

# enable governor for perf cluster
echo 1 > /sys/devices/system/cpu/cpu4/online
echo "ondemand" > /sys/devices/system/cpu/cpu4/cpufreq/scaling_governor
echo 0 > /sys/devices/system/cpu/cpu4/cpufreq/ondemand/ignore_nice_load
echo 0 > /sys/devices/system/cpu/cpu4/cpufreq/ondemand/io_is_busy
echo 0 > /sys/devices/system/cpu/cpu4/cpufreq/ondemand/powersave_bias
echo 4 > /sys/devices/system/cpu/cpu4/cpufreq/ondemand/sampling_down_factor
echo 50000 > /sys/devices/system/cpu/cpu4/cpufreq/ondemand/sampling_rate
echo 50000 > /sys/devices/system/cpu/cpu4/cpufreq/ondemand/sampling_rate_min
echo 95 > /sys/devices/system/cpu/cpu4/cpufreq/ondemand/up_threshold
echo 400000 > /sys/devices/system/cpu/cpu4/cpufreq/scaling_min_freq
echo 1056000 > /sys/devices/system/cpu/cpu4/cpufreq/scaling_max_freq

# HMP Task packing settings for 8976
echo 15 > /proc/sys/kernel/sched_small_task
echo 20 > /sys/devices/system/cpu/cpu0/sched_mostly_idle_load
echo 20 > /sys/devices/system/cpu/cpu1/sched_mostly_idle_load
echo 20 > /sys/devices/system/cpu/cpu2/sched_mostly_idle_load
echo 20 > /sys/devices/system/cpu/cpu3/sched_mostly_idle_load
echo 5 > /sys/devices/system/cpu/cpu4/sched_mostly_idle_load
echo 5 > /sys/devices/system/cpu/cpu5/sched_mostly_idle_load

# Set lower BIG CPU hotplug values to allow them go OFFLINE
echo 0 > /sys/devices/system/cpu/cpu4/core_ctl/min_cpus
echo 2 > /sys/devices/system/cpu/cpu4/core_ctl/max_cpus
echo 75 > /sys/devices/system/cpu/cpu4/core_ctl/busy_up_thres
echo 40 > /sys/devices/system/cpu/cpu4/core_ctl/busy_down_thres
echo 50 > /sys/devices/system/cpu/cpu4/core_ctl/offline_delay_ms
echo 1 > /sys/devices/system/cpu/cpu4/core_ctl/is_big_cluster

