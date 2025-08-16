---
title: MTU Discovery Demo
summary: A demo about the network protocol MTU Discovery
date: 2025-08-10T16:37:19+02:00
draft: true
tags:
  - Demo
  - Computer Networks
  - MTU Discovery
  - Wireshark
  - IP
categories:
  - Software
  - Informatics
---

[*Original parent article about Computer Networks and MTU-Discovery*]({{< relref "computer-networks.md" >}})

**Wireshark filter:** `icmp || icmpv6` (or `icmpv6.type == 2 || icmpv6.type == 128 || icmpv6.type == 129` for ICMPv6 Packet Too Big, Echo Request, Echo Reply and ingoring other ones)

```sh
ping -4 google.de
# PING google.de (142.251.36.163) 56(84) bytes of data.
# 64 bytes from muc12s11-in-f3.1e100.net (142.251.36.163): icmp_seq=1 ttl=119 time=6.92 ms
# ...
ping -6 google.de
# PING google.de (2a00:1450:4001:80f::2003) 56 data bytes
# 64 bytes from fra07s64-in-x2003.1e100.net (2a00:1450:4001:80f::2003): icmp_seq=1 ttl=119 time=8.62 m
# ...
sudo python -m main 142.251.36.163 2a00:1450:4001:80f::2003
# Starting Path MTU Discovery to target_ip='142.251.36.163' max_mtu=1500 min_mtu=576
# Fragmentation Needed at MTU 1500, lowering MTU
# Packet of size 1490 passed successfully
# Path MTU is approximately 1490
# -----------------------------------------------------------------
# Starting Path MTU Discovery to 2a00:1450:4001:80f::2003 (IPv6)
# Packet Too Big received, new MTU suggested: 1492
# No reply for MTU 1492, stopping
```

| No.  | Time (s)    | Source                                      | Destination                               | Protocol | Length | Info                                                        |
|-------|-------------|---------------------------------------------|-------------------------------------------|----------|--------|-------------------------------------------------------------|
| 163   | 2.117740538 | `192.168.2.184`                               | `142.251.36.163`                            | ICMP     | 1514   | Echo (ping) request id=0x0000, seq=0/0, ttl=64 (no response found!) |
| 164   | 2.118099809 | `192.168.2.1`                                 | `192.168.2.184`                            | ICMP     | 590    | Destination unreachable (Fragmentation needed)               |
| 165   | 2.148337724 | `192.168.2.184`                               | `142.251.36.163`                            | ICMP     | 1504   | Echo (ping) request id=0x0000, seq=0/0, ttl=64 (reply in 166) |
| 166   | 2.155286064 | `142.251.36.163`                              | `192.168.2.184`                            | ICMP     | 1504   | Echo (ping) reply id=0x0000, seq=0/0, ttl=119 (request in 165) |
| 169   | 2.221720502 | `2003:e2:bf15:799a:a383:d847:363a:3c09`     | `2a00:1450:4001:80f::2003`                 | ICMPv6   | 1514   | Echo (ping) request id=0x0000, seq=0, hop limit=64 (no response found!) |
| 170   | 2.222140373 | `2003:e2:bf15:799a:ca99:b2ff:fe2b:f00c`     | `2003:e2:bf15:799a:a383:d847:363a:3c09`    | ICMPv6   | 1294   | Packet Too Big                                               |
| 171   | 2.249987962 | `2003:e2:bf15:799a:a383:d847:363a:3c09`     | `2a00:1450:4001:80f::2003`                 | ICMPv6   | 1506   | Echo (ping) request id=0x0000, seq=0, hop limit=64 (reply in 172) |
| 172   | 2.259107978 | `2a00:1450:4001:80f::2003`                    | `2003:e2:bf15:799a:a383:d847:363a:3c09`    | ICMPv6   | 1506   | Echo (ping) reply id=0x0000, seq=0, hop limit=119 (request in 171) |

Code:

{{< include_code file="computer_networks/mtu_discovery/main.py" lang="py" >}}
