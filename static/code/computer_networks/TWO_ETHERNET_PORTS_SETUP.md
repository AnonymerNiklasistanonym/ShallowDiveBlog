# 2 Ethernet Ports Setup

By having 2 Ethernet connections to a PC routing can be simulated having only one PC.

## Setup

```
ip addr show
1: lo: <LOOPBACK,UP,LOWER_UP> mtu 65536 qdisc noqueue state UNKNOWN group default qlen 1000
    link/loopback 00:00:00:00:00:00 brd 00:00:00:00:00:00
    inet 127.0.0.1/8 scope host lo
       valid_lft forever preferred_lft forever
    inet6 ::1/128 scope host noprefixroute
       valid_lft forever preferred_lft forever
2: enp6s0: <BROADCAST,MULTICAST,UP,LOWER_UP> mtu 1500 qdisc fq_codel state UP group default qlen 1000
    link/ether d8:43:ae:29:e7:59 brd ff:ff:ff:ff:ff:ff
    altname enxd843ae29e759
    inet 192.168.2.193/24 brd 192.168.2.255 scope global dynamic noprefixroute enp6s0
       valid_lft 1813473sec preferred_lft 1813473sec
    inet6 2003:e2:bf0a:8c3d:306a:c0ff:a753:353f/64 scope global dynamic noprefixroute
       valid_lft 172779sec preferred_lft 86379sec
    inet6 fe80::cba2:4c8d:20cd:1b93/64 scope link noprefixroute
       valid_lft forever preferred_lft forever
3: enp18s0: <BROADCAST,MULTICAST,UP,LOWER_UP> mtu 1500 qdisc fq_codel state UP group default qlen 1000
    link/ether 0c:ef:15:5f:15:8b brd ff:ff:ff:ff:ff:ff
    altname enx0cef155f158b
    inet 192.168.2.210/24 brd 192.168.2.255 scope global dynamic noprefixroute enp18s0
       valid_lft 1813564sec preferred_lft 1813564sec
    inet6 2003:e2:bf0a:8c3d:5b5d:cb6f:de1d:19da/64 scope global dynamic noprefixroute
       valid_lft 172779sec preferred_lft 86379sec
    inet6 fe80::c5f9:2be5:442a:b3f1/64 scope link noprefixroute
       valid_lft forever preferred_lft forever
4: wlp13s0: <BROADCAST,MULTICAST> mtu 1500 qdisc noop state DOWN group default qlen 1000
    link/ether e6:38:ae:5f:50:30 brd ff:ff:ff:ff:ff:ff permaddr a8:3b:76:e6:90:ed
    altname wlxa83b76e690ed
```

In this case 2 ethernet ports `enp6s0` and `enp18s0` exist but they will be internally routed like a loopback route which can be seen when running `iperf3`:

```
iperf3 -c 192.168.2.193 -B 192.168.2.210                                                     ✔  10s 
Connecting to host 192.168.2.193, port 5201
[  5] local 192.168.2.210 port 36275 connected to 192.168.2.193 port 5201
[ ID] Interval           Transfer     Bitrate         Retr  Cwnd
[  5]   0.00-1.00   sec  6.55 GBytes  56.2 Gbits/sec    0   1.31 MBytes
[  5]   1.00-2.00   sec  6.48 GBytes  55.7 Gbits/sec    0   1.31 MBytes
[  5]   2.00-3.00   sec  6.76 GBytes  58.1 Gbits/sec    0   1.31 MBytes
[  5]   3.00-4.00   sec  6.88 GBytes  59.1 Gbits/sec    0   1.31 MBytes
[  5]   4.00-5.00   sec  6.76 GBytes  58.1 Gbits/sec    0   1.31 MBytes
[  5]   5.00-6.00   sec  6.57 GBytes  56.4 Gbits/sec    0   1.31 MBytes
[  5]   6.00-7.00   sec  6.96 GBytes  59.8 Gbits/sec    0   1.31 MBytes
[  5]   7.00-8.00   sec  6.95 GBytes  59.7 Gbits/sec    0   1.31 MBytes
[  5]   8.00-9.00   sec  6.82 GBytes  58.6 Gbits/sec    0   1.31 MBytes
[  5]   9.00-10.00  sec  6.34 GBytes  54.5 Gbits/sec    0   1.31 MBytes
- - - - - - - - - - - - - - - - - - - - - - - - -
[ ID] Interval           Transfer     Bitrate         Retr
[  5]   0.00-10.00  sec  69.2 GBytes  59.4 Gbits/sec    0            sender
[  5]   0.00-10.00  sec  69.2 GBytes  59.4 Gbits/sec                  receiver
```

You can move one physical interface into a separate network namespace so the kernel no longer considers both IPs *local* to the same `netns`.
That forces real NIC usage.

```
# create namespace
sudo ip netns add ns2

# move enp18s0 (192.168.2.210) into ns2
sudo ip link set enp18s0 netns ns2

# inside ns2: bring device up and reassign IP
sudo ip netns exec ns2 ip addr flush dev enp18s0
sudo ip netns exec ns2 ip addr add 192.168.2.210/24 dev enp18s0
sudo ip netns exec ns2 ip link set dev enp18s0 up
# Do not add a default route!
#sudo ip netns exec ns2 ip route add default via 192.168.2.1

# on host: ensure enp6s0 still has 192.168.2.193
ip addr show enp6s0
# inside ns2: ensure enp18s0 still has 192.168.2.210
ip addr show enp18s0
```

Check network interfaces:

```
ip addr show enp6s0
# 2: enp6s0: <BROADCAST,MULTICAST,UP,LOWER_UP> mtu 1500 qdisc fq_codel state UP group default qlen 1000
#     link/ether d8:43:ae:29:e7:59 brd ff:ff:ff:ff:ff:ff
#     altname enxd843ae29e759
#     inet 192.168.2.193/24 brd 192.168.2.255 scope global dynamic noprefixroute enp6s0
#        valid_lft 1809990sec preferred_lft 1809990sec
#     inet6 2003:e2:bf0a:8c3d:306a:c0ff:a753:353f/64 scope global dynamic noprefixroute
#        valid_lft 172782sec preferred_lft 86382sec
#     inet6 fe80::cba2:4c8d:20cd:1b93/64 scope link noprefixroute
#        valid_lft forever preferred_lft forever
ip addr show enp18s0
# Device "enp18s0" does not exist.
sudo ip netns exec ns2 ip addr show enp6s0
# Device "enp6s0" does not exist.
sudo ip netns exec ns2 ip addr show enp18s0
# 3: enp18s0: <BROADCAST,MULTICAST,UP,LOWER_UP> mtu 1500 qdisc fq_codel state UP group default qlen 1000
#     link/ether 0c:ef:15:5f:15:8b brd ff:ff:ff:ff:ff:ff
#     altname enx0cef155f158b
#     inet 192.168.2.210/24 scope global enp18s0
#        valid_lft forever preferred_lft forever
#     inet6 2003:e2:bf0a:8c3d:eef:15ff:fe5f:158b/64 scope global dynamic mngtmpaddr proto kernel_ra
#        valid_lft 172794sec preferred_lft 86394sec
#     inet6 fe80::eef:15ff:fe5f:158b/64 scope link proto kernel_ll
#        valid_lft forever preferred_lft forever
```

Check the routing tables:

```
ip route
# default via 192.168.2.1 dev enp6s0 proto dhcp src 192.168.2.193 metric 100
# 192.168.2.0/24 dev enp6s0 proto kernel scope link src 192.168.2.193 metric 100
sudo ip netns exec ns2 ip route
# default via 192.168.2.1 dev enp18s0
# 192.168.2.0/24 dev enp18s0 proto kernel scope link src 192.168.2.210
```

```
# TODO Explain, show before
ip route get 192.168.2.193 from 192.168.2.210
# RTNETLINK answers: Network is unreachable
ip route get 192.168.2.210 from 192.168.2.193
# 192.168.2.210 from 192.168.2.193 dev enp6s0 uid 1000
#     cache
sudo ip netns exec ns2 ip route get 192.168.2.193 from 192.168.2.210
# 192.168.2.193 from 192.168.2.210 dev enp18s0 uid 0
#     cache
sudo ip netns exec ns2 ip route get 192.168.2.210 from 192.168.2.193
# RTNETLINK answers: Network is unreachable
```


## Verify

```
sudo ip netns exec ns2 iperf3 -s
```

```
iperf3 -c 192.168.2.210 -B 192.168.2.193 -t 20
Connecting to host 192.168.2.210, port 5201
[  5] local 192.168.2.193 port 41337 connected to 192.168.2.210 port 5201
[ ID] Interval           Transfer     Bitrate         Retr  Cwnd
[  5]   0.00-1.00   sec   114 MBytes   954 Mbits/sec    0    379 KBytes
[  5]   1.00-2.00   sec   112 MBytes   942 Mbits/sec    0    379 KBytes
[  5]   2.00-3.00   sec   112 MBytes   941 Mbits/sec    0    379 KBytes
[  5]   3.00-4.00   sec   113 MBytes   947 Mbits/sec    0    379 KBytes
[  5]   4.00-5.00   sec   112 MBytes   939 Mbits/sec    0    379 KBytes
[  5]   5.00-6.00   sec   112 MBytes   941 Mbits/sec    0    379 KBytes
[  5]   6.00-7.00   sec   112 MBytes   941 Mbits/sec    0    379 KBytes
[  5]   7.00-8.00   sec   112 MBytes   941 Mbits/sec    0    379 KBytes
[  5]   8.00-9.00   sec   112 MBytes   940 Mbits/sec    0    379 KBytes
[  5]   9.00-10.00  sec   113 MBytes   947 Mbits/sec    0    379 KBytes
[  5]  10.00-11.00  sec   112 MBytes   941 Mbits/sec    0    379 KBytes
[  5]  11.00-12.00  sec   112 MBytes   941 Mbits/sec    0    379 KBytes
[  5]  12.00-13.00  sec   112 MBytes   942 Mbits/sec    0    379 KBytes
[  5]  13.00-14.00  sec   112 MBytes   943 Mbits/sec    0    379 KBytes
[  5]  14.00-15.00  sec   112 MBytes   942 Mbits/sec    0    379 KBytes
[  5]  15.00-16.00  sec   112 MBytes   943 Mbits/sec    0    379 KBytes
[  5]  16.00-17.00  sec   112 MBytes   937 Mbits/sec    0    379 KBytes
[  5]  17.00-18.00  sec   112 MBytes   944 Mbits/sec    0    379 KBytes
[  5]  18.00-19.00  sec   112 MBytes   941 Mbits/sec    0    379 KBytes
[  5]  19.00-20.00  sec   112 MBytes   941 Mbits/sec    0    379 KBytes
- - - - - - - - - - - - - - - - - - - - - - - - -
[ ID] Interval           Transfer     Bitrate         Retr
[  5]   0.00-20.00  sec  2.19 GBytes   942 Mbits/sec    0            sender
[  5]   0.00-20.00  sec  2.19 GBytes   941 Mbits/sec                  receiver
```

## Undo

TODO

```
# move interface back to default NS
sudo ip netns exec ns2 ip link set enp6s0 netns 1
sudo ip netns delete ns2
```