---
title: DNS Demo
summary: A demo about the network protocol DNS
date: 2025-08-10T16:37:19+02:00
draft: true
tags:
  - Demo
  - Computer Networks
  - DNS
  - Wireshark
  - IP
categories:
  - Software
  - Informatics
---

[*Original parent article about Computer Networks and DNS*]({{< relref "computer-networks.md" >}})

Clear DNS cache:

```sh
sudo systemd-resolve --flush-caches
```

**Wireshark filter:** `dns`

Trigger a DNS lookup:

```sh
ping example.com
```

```text
5806	42.058843106	192.168.2.184	192.168.2.1	DNS	73	Standard query 0x7b26 A example.com
5807	42.058847536	192.168.2.184	192.168.2.1	DNS	73	Standard query 0xf621 AAAA example.com
5808	42.062255355	192.168.2.1	192.168.2.184	DNS	241	Standard query response 0xf621 AAAA example.com AAAA 2600:1406:3a00:21::173e:2e66 AAAA 2600:1406:bc00:53::b81e:94ce AAAA 2600:1408:ec00:36::1736:7f24 AAAA 2600:1406:bc00:53::b81e:94c8 AAAA 2600:1408:ec00:36::1736:7f31 AAAA 2600:1406:3a00:21::173e:2e65
5809	42.062437515	192.168.2.1	192.168.2.184	DNS	169	Standard query response 0x7b26 A example.com A 96.7.128.198 A 23.215.0.136 A 23.192.228.84 A 96.7.128.175 A 23.192.228.80 A 23.215.0.138
```

Open a website to see how DNS prefetching works: `hdm-stuttgart.de`

```text
326	2.232934325	192.168.2.184	192.168.2.1	DNS	82	Standard query 0xe376 A www.hdm-stuttgart.de
327	2.232938505	192.168.2.184	192.168.2.1	DNS	82	Standard query 0x5e77 AAAA www.hdm-stuttgart.de
329	2.233626717	192.168.2.1	192.168.2.184	DNS	114	Standard query response 0xe376 A www.hdm-stuttgart.de A 141.62.1.53 A 141.62.1.59
330	2.233918238	192.168.2.1	192.168.2.184	DNS	82	Standard query response 0x5e77 AAAA www.hdm-stuttgart.de
```
