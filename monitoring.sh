# !/usr/bin/bash
ARCH=$(uname -a)
CPUPHYS=$(nproc --all)
VCPU=$(cat /proc/cpuinfo | grep processor | wc -l)
MEMUSED=$(free --mega | grep "Mem:" | awk '{printf("%d", $3)}')
MEMALL=$(free --mega | grep "Mem:" | awk '{printf("%d", $2)}')
MEMPERCENT=$(echo $MEMUSED $MEMALL | awk '{printf("%.2f", $1 / $2 * 100.0)}')
DISKUSED=$(df -m | awk '{n+=$3} END {printf("%d", n)}')
DISKALL=$(df -m | awk '{n+=$2} END {printf("%d", n / 1024)}')
DISKPERCENT=$(echo $DISKUSED $DISKALL | awk '{printf("%.0f", ($1 / ($2 * 1024)) * 100)}')
CPULOAD=$(echo $(mpstat | grep all) | tr , . | awk '{printf("%.2f", 100.00 - $12)}')
LASTBOOT=$(who -b | awk '{printf("%s %s", $3, $4)}')
LVM="no"
if [ $(lsblk | grep -c lvm) -gt 0 ]
then
        LVM="yes"
fi
CONTCP=$(ss -s | grep estab | awk '{printf("%.d", $4)}')
USERLOG=$(who | wc -l)
IP=$(hostname -I)
MAC=$(ip addr | grep link/ether | awk '{print $2}')
SUDO=$(cat /var/log/sudo/sudolog | grep -c COMMAND)

clear
wall "
#Architecture: $ARCH
#CPU physical : $CPUPHYS
#vCPU : $VCPU
#Memory Usage: $MEMUSED/${MEMALL}MB ($MEMPERCENT%)
#Disk Usage: $DISKUSED/${DISKALL}GB ($DISKPERCENT%)
#CPU load: $CPULOAD%
#Last boot: $LASTBOOT
#LVM use: $LVM
#Connexions TCP : $CONTCP ESTABLISHED
#User log: $USERLOG
#Network: IP $IP ($MAC)
#Sudo : $SUDO cmd
"
