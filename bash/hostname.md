# 变更hostname

## rhel 6

```
vim /etc/hosts
vim /etc/sysconfig/network
echo newhostname > /proc/sys/kernel/hostname 

# service network restart
OR
# /etc/init.d/network restart
```

## rhel 7

```
To set host name to “R2-D2”, enter:
# hostnamectl set-hostname R2-D2

To set static host name to “server1.cyberciti.biz”, enter:
# hostnamectl set-hostname server1.cyberciti.biz --static

To set pretty host name to “Senator Padme Amidala’s Laptop”, enter:
# hostnamectl set-hostname "Senator Padme Amidala's Laptop" --pretty

To verify new settings, enter:
# hostnamectl status
```
