---
title: ARP Demo
summary: A demo about the network protocol ARP
date: 2025-08-10T16:37:19+02:00
draft: true
tags:
  - Demo
  - Computer Networks
  - ARP
  - Wireshark
  - Python
  - IP
categories:
  - Software
  - Informatics
---

[*Original parent article about Computer Networks and ARP*]({{< relref "computer-networks.md" >}})

**Wireshark filter:** `arp.opcode == 1 && arp.src.proto_ipv4 == arp.dst.proto_ipv4` (`arp.opcode == 1` see all arp requests, `arp` to see arp answers)

```sh
sudo python -m main
```

```text
1187	10.262630621	00:00:00_00:00:00		ARP	110	ARP Announcement for 323030333a65323a626631353a373936663a393837323a663562303a373039653a346237…
1188	10.290534827	00:00:00_00:00:00		ARP	110	ARP Announcement for 323030333a65323a626631353a373939363a363135313a633865383a653937623a656238…
1189	10.325622815	00:00:00_00:00:00		ARP	98	ARP Announcement for 666538303a3a313837303a6639393a653762303a6461366225656e70367330
1171	10.175663096	00:00:00_00:00:00		ARP	44	ARP Announcement for 127.0.0.1
1172	10.201567800	00:00:00_00:00:00		ARP	42	ARP Announcement for 3a3a31
1178	10.232572523	MicroStarINT_29:e7:59		ARP	44	ARP Announcement for 192.168.2.184
1179	10.233753240	HuaweiDevice_5b:9c:e8		ARP	62	Who has 192.168.2.184? Tell 192.168.3.1
1180	10.233759570	MicroStarINT_29:e7:59		ARP	44	192.168.2.184 is at d8:43:ae:29:e7:59
1191	10.344620487	MicroStarINT_29:e7:59		ARP	44	ARP Announcement for 192.168.2.1 (duplicate use of 192.168.2.1 detected!)
```

```text
1201	10.369734366	MicroStarINT_29:e7:59		ARP	44	Who has 192.168.2.1? Tell 192.168.2.184
1202	10.370059448	Arcadyan_2b:f0:0c		ARP	62	192.168.2.1 is at c8:99:b2:2b:f0:0c
```

Automatic ARP requests from time to time:

```text
6779	56.005096634	Arcadyan_2b:f0:0c		ARP	62	Who has 192.168.2.184? Tell 192.168.2.1
6780	56.005100414	MicroStarINT_29:e7:59		ARP	44	192.168.2.184 is at d8:43:ae:29:e7:59
```

```sh
# Flush ARP cache and show the current ARP cache is empty
sudo ip neigh flush all && ip neigh show
# View current ARP cache
ip neigh show
# 192.168.2.1 dev enp6s0 lladdr c8:99:b2:2b:f0:0c REACHABLE
# fe80::1 dev enp6s0 lladdr c8:99:b2:2b:f0:0c router REACHABLE
```

Code:

{{< include_code file="static/code/computer_networks/arp/main.py" lang="py" >}}
