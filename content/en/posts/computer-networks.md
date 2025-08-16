---
title: Computer Networks
summary: A shallow dive into the computer networks stack
date: 2025-08-10T16:37:19+02:00
draft: true
math: true
tags:
  - Computer Networks
  - ARP
  - IP
  - TCP
  - UDP
  - HTTP
  - DNS
  - ICMP
  - Ethernet
  - VLAN
  - Proxy
categories:
  - Software
  - Informatics
---

## TODOS

- [ ] ASNs
- [ ] Peering / DIX
- [ ] DHCP
- [ ] Flow Label
- [ ] HTTP example and better explanation
- [ ] ICMP
  - [ ] Non existing IP Address: ICMP "Destination Unreachable"
- [ ] Gateway, routing tables
- [ ] Software designed Networking
- [ ] WLAN, beamforming, frequency modulation
- [ ] Bluetooth
- [ ] Fiber cable, dispersion
- [ ] Proxy

## Infos

### OSI Model

The Open Systems Interconnection (OSI) model is a reference model for a communication system.
The components of a communication system are distinguished in seven abstraction layers where each layer serves a class of functionality to the layer above it and is served by the layer below it.
This distributes functionality, makes it easy for different vendors to operate together and helps to isolate network problems by layer (e.g., routing issue or a cable problem).

| Layer | Name             | Data Unit | Medium / Role                         | Addressing / Identifier    | Data Structures Used                  | Typical Devices                          | Example Protocols / Technologies       |
|-------|------------------|-----------|---------------------------------------|----------------------------|---------------------------------------|------------------------------------------|----------------------------------------|
| 7     | **Application**  | Data      | User interface / network applications | Application name / URL     | Application-layer logic, DNS tables  | Computers, Phones, Web Browsers         | HTTP, FTP, DNS, SSH                    |
| 6     | **Presentation** | Data      | Encoding / encryption / compression   | File types / Encoding info | Codec settings, certificate stores   | Codecs, SSL Libraries                   | SSL/TLS, JPEG, MPEG, ASCII             |
| 5     | **Session**      | Data      | Connection management (start/stop)    | Session ID                 | Session tables, state/session caches | Application Servers, Gateways           | NetBIOS, RPC, SMB session              |
| 4     | **Transport**    | Segments  | Reliable delivery, flow control       | **Port number**            | **Socket tables**, connection states | Firewalls, Load Balancers               | TCP, UDP                               |
| 3     | **Network**      | Packets   | Routing between networks              | **IP address**             | **Routing tables**, **ARP cache**    | Routers, Layer 3 Switches               | IP (IPv4/6), ICMP                      |
| 2     | **Data Link**    | Frames    | Local delivery on a single link       | **MAC address**            | **MAC address table**                | Switches, NICs, Bridges                 | Ethernet, VLAN (802.1Q)                |
| 1     | **Physical**     | Bits      | Physical bit transmission             | Physical medium (signal)   | N/A (hardware signal interpretation) | Cables, Hubs, Repeaters, Transceivers   | RJ45, Fiber, Bluetooth, Wi-Fi (802.11) |

#### MAC Address (Layer 2)

A MAC address (Media Access Control address) is a unique identifier assigned to a network interface card (NIC) for communications on the data link layer (Layer 2) of the OSI model.

- Format: 48 bits (6 bytes), usually shown as 12 hexadecimal digits, e.g., `00:1A:2B:3C:4D:5E` or `00-1A-2B-3C-4D-5E`
- Purpose: Identifies a device uniquely on a local network (LAN)

#### IP Address (Layer 3)

A IP address is a numerical label assigned to each device on a network that uses the Internet Protocol for communication.

- Purpose:
  - Identifying the host or network interface
  - Providing the location of the host in the network

**IPV4**:

- Format: 32 bits (4 bytes), usually written as four decimal numbers (each one byte [0,255]) separated by dots, e.g., `192.168.1.1`
- Address space: $2^{32} \approx 4.3$ billion addresses

**IPv4 Address Classes**:

| Class | Leading Bits | Address Range                | Default Subnet Mask | Number of Networks  | Number of Hosts per Network | Usage                   |
| ----- | ------------ | ---------------------------- | ------------------- | ------------------- | --------------------------- | ----------------------- |
| A     | 0            | `0.0.0.0` to `127.255.255.255`   | `255.0.0.0` (/8)      | 128 (0-127)         | $2^{24} - 2 = 16,777,214$ | Large networks / ISPs   |
| B     | 10           | `128.0.0.0` to `191.255.255.255` | `255.255.0.0` (/16)   | 16,384              | $2^{16} - 2 = 65,534$ | Medium-sized networks   |
| C     | 110          | `192.0.0.0` to `223.255.255.255` | `255.255.255.0` (/24) | 2,097,152           | $2^8 - 2 = 254$ | Small networks / LANs   |
| D     | 1110         | `224.0.0.0` to `239.255.255.255` | N/A                 | Multicast addresses | N/A                         | Multicast groups        |
| E     | 1111         | `240.0.0.0` to `255.255.255.255` | N/A                 | Experimental        | N/A                         | Experimental / research |

| Private Network Class | Address Range                 | CIDR Notation  | Number of Hosts | Usage                                  |
| --------------------- | ----------------------------- | -------------- | --------------- | -------------------------------------- |
| Class A               | `10.0.0.0` to `10.255.255.255`     | `10.0.0.0/8`     | $2^{24} - 2 = 16,777,214$ | Large private networks                 |
| Class B               | `172.16.0.0` to `172.31.255.255`   | `172.16.0.0/12`  | $2^{20} - 2 = 1,048,574$        | Medium-sized private networks          |
| Class C               | `192.168.0.0` to `192.168.255.255` | `192.168.0.0/16` | $2^{16} - 2 = 65,534$ | Small private networks / home networks |

`127.0.0.1` is reserved for a loopback address.

**CIDR notation / Subnets**:

- Subnet Mask: Allows for more efficient use compared to historic classful addressing
  - It consists of consecutive `1`s (network portion) followed by `0`s (host portion) in binary

    | IP Address  | 192.168.1.100                       | Notes |
    | ----------- | ----------------------------------- | ----- |
    | **Subnet Mask** | **255.255.255.0**                       |  |
    | Binary Subnet Mask | 11111111.11111111.11111111.00000000 | Convert decimal to binary numbers |
    | Subnet Mask CIDR Notation | `/24` | Count the number of `1`s |
    | Binary IP Address | 11000000.10101000.00000001.01100100 | Convert decimal to binary numbers |
    | Binary Network address | 11000000.10101000.00000001.00000000 | Make all bits `0` that are `0` in the Subnet mask (first address) |
    | Binary Broadcast address | 11000000.10101000.00000001.11111111 | Make all bits `1` that are `0` in the Subnet mask (last address) |
    | Subnet Network address | 192.168.1.0 | Convert binary to decimal numbers |
    | Subnet Broadcast address | 192.168.1.255 | Convert binary to decimal numbers |

    - The first 24 bits are network bits (24 `1`s)
      - Subnet range: e.g. in a `/24` address you can put $2^2 = 4$ `/26` subnets ($26 - 24 = 2$)
    - The last 8 bits are host bits  (8 `0`s)
      - Host range:
        - $2^8$ - Broadcast Address - Network Address $= 256 - 2 = 254$
        - `192.168.1.1` to `192.168.1.254`

**IPV6**:

- Format: 128 bits (16 bytes), written as eight groups of four hexadecimal digits (each two byte [0,65535]/[0000,FFFF]) separated by colons, e.g., `2001:0db8:85a3:0000:0000:8a2e:0370:7334`
- Address space: $2^{128}$ (Vastly larger than IPv4)
- Leading zeros in a group can be omitted, and consecutive groups of zeros can be compressed to "::"
- IPv6 addresses can be shortened to simplify notation:

  | Case | Long | Short |
  | --- | --- | --- |
  |Leading zeros can be omitted in each block | `2001:0db8:0000:0000:0000:0000:1428:57ab` | `2001:db8:0:0:0:0:1428:57ab` |
  | One or more consecutive groups of zeros can be replaced with `::` (only once per address) | `2001:db8:0:0:0:0:1428:57ab` | `2001:db8::1428:57ab` |
  | Example both rules | `fe80:0000:0000:0000:0204:61ff:fe9d:f156` | `fe80::204:61ff:fe9d:f156` |
  | | `2001:0db8:0000:0000:0001:0000:0000:1a2b` | `2001:db8::1:0:0:1a2b` / `2001:db8:0:0:1::1a2b` |

- CIDR notation works the same as IPV4

#### Port Number (Layer 4)

A port number is a 16-bit number used in networking to identify specific processes or services on a device.
While an IP address identifies a host on a network, the port number identifies a particular application or service on that host.
It allows multiple networked apps to use the same IP address without conflict.

| Range           | Name                      | Purpose                                              |
| --------------- | ------------------------- | ---------------------------------------------------- |
| 0 - 1023      | **Well-known ports**      | Standard services like HTTP (80), SSH (22), DNS (53) |
| 1024 - 49151  | **Registered ports**      | Apps that register with IANA (e.g., 3306 for MySQL)  |
| 49152 - 65535 | **Dynamic/Private ports** | Temporary use, such as for outbound client sockets   |

### Physical Layer (Layer 1)

For the actual transmission of bits a Preamble and SFD (Start frame delimiter) in the beginning and IFG (Interframe gap) at the end.
These parts are not passed up to Layer 2 (Data Link).

![Preamble, SFD and IFG around an Ethernet II frame (And1mu, Creative Commons Attribution-Share Alike 4.0 International: https://commons.wikimedia.org/wiki/File:Preamble_SFD_Ethernet_Type_II_Frame_IFG.svg)](../../images/computer_networks/Wikimedia_Preamble_SFD_Ethernet_Type_II_Frame_IFG.svg)

| Component    | Layer | Purpose                                                                  |
| ------------ | ----- | ------------------------------------------------------------------------ |
| **Preamble** | L1    | Synchronize receiver’s clock                                             |
| **SFD**      | L1    | Marks the end of the preamble and the start of the actual Ethernet frame |
| **IFG**      | L1    | Provides idle time between frames for processing and reset               |

### Ethernet Frames (Layer 2)

- Ethernet II (DIX Ethernet)
- IEEE 802.3 (with LLC)
  - Introduced by IEEE; uses a Length field instead of a Type field
  - Followed by Logical Link Control (LLC) headers
  - Often used in older networks, non-IP protocols but rare today except in specialized systems
- IEEE 802.1Q (VLAN-tagged Ethernet II)
- IEEE 802.1ad (Q-in-Q)
  - Stacked VLAN tags (Double-tagged)
  - Used by service providers to separate customer VLANs from core infrastructure
- Jumbo Frames (Ethernet II with bigger payload)
  - A size variant of the Ethernet II frame -> standard 1500 bytes payload can be configured to up to 9000 bytes
  - Used in high-performance networking (Requires explicit configuration on both ends)

![Ethernet II Frame Format (Public Domain: https://commons.wikimedia.org/wiki/File:Ethernet_Type_II_Frame_format.svg)](../../images/computer_networks/Wikimedia_Ethernet_Type_II_Frame_format.svg)

One (**IEEE 802.1Q**) or two (**IEEE 802.1ad**) **VLAN Tag(s)** can be optionally inserted in front of the **EtherType** which each reduces the minimum payload by 4 Byte.
The maximum payload size is related to internet devices **MTU** (Maximum transmission unit) which is per default 1500 bytes with 18 bytes overhead (header and frame check sequence).
This means that internet devices like switches in such networks need to be configured to handle frames with the maximum frame size of 1522 or even 1526 bytes since the standard allows them.
Jumbo frames also just go up in size to 9000 + 18 + 4 (+ 4) = 9022/9026 bytes.

![Ethernet II 802.1Q VLAN Tag Insertion (Bill Stafford, Creative Commons Attribution-Share Alike 3.0 Unported: https://commons.wikimedia.org/wiki/File:Ethernet_802.1Q_Insert.svg)](../../images/computer_networks/Wikimedia_Ethernet_802.1Q_Insert.svg)

| Field Name         | Size (Bits) | Description                                                              |
| ------------------ | ----------- | ------------------------------------------------------------------------ |
| **TPID**           | 16          | Tag Protocol Identifier (802.1Q uses a TPID of `0x8100`, 802.1ad uses a TPID of `0x88a8`. to indicate VLAN presence)     |
| **Priority (PCP)** | 3           | Priority Code Point (used for QoS - 0 to 7)                              |
| **DEI**            | 1           | Drop Eligible Indicator (indicates frame drop priority under congestion) |
| **VLAN ID**        | 12          | VLAN Identifier (0-4095; 0 & 4095 reserved, so 1-4094 usable)            |

Usually, the outer VLAN Tag is managed by the service provider, and the inner VLAN Tag is for the customer.

**IEEE 802.3:**

It has pretty much the same structure as Ethernet II but uses a **Length** field instead of a **EtherType** field (same length of 2 bytes).
You can differentiate between them by checking the value.
The (payload) **Length** never exceeds 1500 bytes and the **EtherType** starts at 1536.
Modern usage of this frame usually adds extra headers LLC/SNAP (around 8 bytes) into the start of the payload part which thus reduces the payload size (unlike the **VLAN Tag(s)** that don't do that).

**Why LLC Exists:**

- In IEEE 802.3 frames, the field after the source MAC is a length, not an EtherType
- So Ethernet needs another mechanism (LLC) to tell the receiver what kind of data is coming (e.g., IP, ARP, etc.).
  - Ethernet II uses: `[Type: 0x0800]` = IPv4
  - IEEE 802.3 uses: `[Length: 46]` → `[LLC Header → SNAP Header]` → identifies IPv4, etc.

    ```text
    DSAP: 0xAA
    SSAP: 0xAA
    Control: 0x03
    SNAP:
        OUI: 00-00-00
        Protocol ID: 0x0800 (for IPv4)
    ```

{{< readmore url="posts/demo-arp.md" text="ARP Demo" >}}

#### ARP (Address Resolution Protocol)

ARP is used to map an IP address to a MAC address within a local network.

- To get the MAC address of an IP address on the same subnet a device can broadcasts an **ARP Request**: *Who has IP `x.x.x.x`? Tell me your MAC address*

  - The device with that IP responds with an **ARP reply**: *I have IP `x.x.x.x`, my MAC is `yy:yy:yy:yy:yy:yy`*

- This info is stored in the senders ARP cache for later reuse
- ARP requests are never routed
  - if the source device knows that the target device is outside its network (subnet/internet) it ARP requests its default gateway and then forwards any frames over there
  - **importantly this means that a frame can never be routed to a device using a MAC outside of a local network, this is only possible using IP addresses from layer 3**

- Gratuitous ARP replies can be sent by devices to notify other devices on the network of their current IP and MAC

- Gratuitous ARP requests can be sent to avoid IP conflicts by asking if anyone in the network already has that IP

| Field             | Size (bytes) | Description                                                |
| ----------------- | ------------ | ---------------------------------------------------------- |
| **Hardware Type** | 2            | Type of hardware address (e.g., Ethernet = `0x0001`)       |
| **Protocol Type** | 2            | Type of protocol address (e.g., IPv4 = `0x0800`)           |
| **Hardware Size** | 1            | Size of MAC address in bytes (usually `6`)                 |
| **Protocol Size** | 1            | Size of IP address in bytes (usually `4`)                  |
| **Opcode**        | 2            | `1` = Request, `2` = Reply                                 |
| **Sender MAC**    | 6            | MAC address of the sender                                  |
| **Sender IP**     | 4            | IP address of the sender (**Same as Target IP if request is gratuitous**) |
| **Target MAC**    | 6            | MAC address of the target (`00:00:00:00:00:00` in request) |
| **Target IP**     | 4            | IP address of the target                                   |

This adds up to a payload of 28 bytes meaning that to reach the minimum ethernet frame payload size the rest (per default 46 - 28 = 18) of the bytes need to be padded.

| Type                       | Opcode | Sender IP = Target IP | Broadcast  | Used for…                           |
| -------------------------- | ------ | ---------------------- | --------------------- | ----------------------------------- |
| **Normal ARP Request** (*Who has IP `x.x.x.x`, tell me your MAC?*) | `1`    | ❌                     | ✅ | Resolving MAC from IP (Expects **ARP Reply**) |
| **Normal ARP Reply** (*I have IP `x.x.x.x`, my MAC is `yy:yy:yy:yy:yy:yy`*) | `2`    | ❌                     | ❌ (**Unicast**) | Answering ARP request |
| **Gratuitous ARP Request** (*Is **my** IP `x.x.x.x` already in use, tell me your MAC?*) | `1`    | ✅                     | ✅           | IP conflict detection, announcement (If no one responds with an **ARP Reply** by a device who has the IP `x.x.x.x`, the device assumes it can own that IP safely) |
| **Gratuitous ARP Reply** (*My MAC is `yy:yy:yy:yy:yy:yy` and my **new** IP is `x.x.x.x`, update your ARP cache*) | `2`    | ✅                     | ✅ | IP takeover, update ARP caches in network (usually sent after a **Gratuitous ARP Request**) |

### IP Packets (Layer 3)

The header checksum excludes the **Data** field.
**TTL** (Time to live) counts down on every hop through the network, if 0 is reached the package is discarded.

![(Sirfurboy, Creative Commons Attribution-Share Alike 4.0 International: https://commons.wikimedia.org/wiki/File:IPv4_Packet-en.svg)](../../images/computer_networks/Wikimedia_IPv4_Packet-en.svg)

**Fragmentation:**

In IPv4, the `DF` (*Don't Fragment*) bit controls whether a packet can be fragmented by routers.
In IPv6, fragmentation by routers is not allowed.
If a packet is too large, routers drop it and send an `ICMPv6` *Package Too Big* message back to the sender.

Protocol Examples:

- ICMP

#### ICMP (Internet Control Message Protocol)

ICMP is a protocol used within the IP layer to send error messages and operational information for diagnostic purposes, no user data.
It is used by network devices, like routers, to communicate network issues or test connectivity.

- Example: Ping
  - Ping sends an ICMP Echo Request to a target IP and waits for an ICMP Echo Reply
  - This tests whether the target is reachable and measures round-trip time
  - It's a simple way to check if a device is alive and responding on the network

| **Field**       | **Size (bits)** | **Description**                                         |
| --------------- | --------------- | ------------------------------------------------------- |
| Type            | 8               | Type of ICMP message (8 = Echo Request, 0 = Echo Reply) |
| Code            | 8               | Subtype of the message (usually 0 for ping)             |
| Checksum        | 16              | Error-checking checksum                                 |
| Identifier      | 16              | Used to match requests/replies                          |
| Sequence Number | 16              | Incremented with each ping request                      |
| Data            | Variable        | Optional data for testing                               |

**Path MTU Discovery:**

Different links between two endpoints might have different MTU sizes:

- To not have expensive fragmentation (IPv4) during the transport of messages between 2 devices or random package drops (IPv6) a MTU discovery is made using an IP packet to avoid degraded performance and delays
  - IPv4: Don't Fragment Flag is set, IP packet is set to the maximum supported MTU, if MTU too big for a hop on the way it won't be fragmented since the flag was set and a **ICMP "Fragmentation Needed"** response is sent
  - IPv6: No fragmentation by external devices so if the MTU is too big a **ICMPv6 "Packet Too Big"** response is sent
- Not receiving a response is treated as *"no MTU size issues"*

{{< readmore url="posts/demo-mtu-discovery.md" text="MTU Discovery Demo" >}}

### TCP/UDP Segments (Layer 4)

- Ports (16 Bit, $2^{16}$) are used via sockets to allow multiple TCP/UDP connections per IP Adress/Interface

TCP:

- (sliding) window size (with optional TCP option: (sliding) window scale)
  - indicates the currently available buffer to receive data
  - sent in every message
- Flags: SYN (initialize connection), ACK (acknowledge last continuously received byte), PSH (push data to application), FIN (close connection)
- other TCP options:
  - MSS: Maximum Segment Size (smaller than MTU (Layer 2 - *max frame size*) because it's part of it since it's Layer 4 - *max TCP payload size*)
  - Timestamps: Calculate round trip time and detect bad/old sequence numbers to avoid collisions
  - SACK Perm: Selective Acknowledgments (only in SYN messages) - ACK every package to better detect missing packages

- 3 way handshake
  - [SEQ_CLIENT, DATA_LENGTH="1"] client sends SYN (with TCP option MSS)
  - [SEQ_SERVER, DATA_LENGTH="1"] server ACKs (SEQ_CLIENT+1) with a SYN flag  (with TCP option MSS)
  - [SEQ_CLIENT + 1, DATA_LENGTH="0"] client ACKs (SEQ_SERVER + 1)
- data exchange
  - [SEQ_CLIENT + 1/`x`, DATA_LENGTH=`dataLength`] client sends data with SEQ `x` and the data (length `dataLength`)
    - client can sent as many packages as the current (sliding) window allows
    - server ACKs the las continuous received byte this after some time (or every time if TCP option `SACK` is set)
      - [SEQ_SERVER + 1/, DATA_LENGTH="0"] ACK (`x` + `dataLength`)
    - next data by the client is now:
      - client: [`x` + `dataLength`, DATA_LENGTH=`dataLength2`]
      - server: [SEQ_SERVER + 1/, DATA_LENGTH="0"] ACK (`x` + `dataLength` + `dataLength2`)
- 4 way close
  - client sends FIN  [DATA_LENGTH="1"]
    - server ACKs (+1) clients FIN [DATA_LENGTH="0"]
  - data might still be sent from past interactions from the server
    - client still ACKs this data
  - server sends FIN [DATA_LENGTH="1"]
    - client ACKs (+1) servers FIN [DATA_LENGTH="0"]
- Timers are used as flow control
  - resend packages if no ACKs after some time

{{< readmore url="posts/demo-tcp.md" text="TCP Demo" >}}

### HTTP (Layer 7)

TCP based protocol to make web requests.

### DNS (Layer 7)

Domain Names make it possible to have a human readable address to address a PC with a connected IP address (can also select the locally best CDN PC).

- DNS Root Servers: Topmost servers in a DNS name server structure that recursively resolve domain names to IP adresses (using round robin for better load balancing)
  - Root server stored in Gateway to the internet: `de` (`de-1`) **TOP LEVEL DOMAIN (TLD)** (ccTLD - Country Code Top-Level Domains)
    - There are also others: gTLD (Generic Top-Level Domains) like `.com`, Sponsored gTLDs like `.edu` or new gTLDs (since 2013) like `.tech`/`.shop`
  - Forwards to DNS name server: `hdm-stuttgart` (`belwue`)
  - Replies with entry IP address
- DNS cache: Devices normally store DNS replies in a cache table with a TTL for performance reasons
- DNS prefetching: Especially applications like browsers make heavy use of prefetching of IP adresses by e.g. scraping `a` tags on a website before the user has clicked a link or through specific `link` entries
- Normally a device is not actually iteratively requesting the DNS entry but the gateway gets a DNS request and then resolves the DNS entry, then replies back to the device with the DNS entry
  - This also has the benefit of having the entry cached in the gateway in case another device requests the same domain

{{< readmore url="posts/demo-dns.md" text="DNS Demo" >}}

## Setups

### Local IP address

Linux:

```sh
ip -4 addr show
# 1: lo: <LOOPBACK,UP,LOWER_UP> mtu 65536 qdisc noqueue state UNKNOWN group default qlen 1000
#     inet 127.0.0.1/8 scope host lo
#        valid_lft forever preferred_lft forever
# 2: enp6s0: <BROADCAST,MULTICAST,UP,LOWER_UP> mtu 1500 qdisc fq_codel state UP group default qlen 1000
#     altname enxd843ae29e759
#     inet 192.168.2.184/24 brd 192.168.2.255 scope global dynamic noprefixroute enp6s0
#        valid_lft 1797516sec preferred_lft 1797516sec
ip -6 addr show
# 1: lo: <LOOPBACK,UP,LOWER_UP> mtu 65536 state UNKNOWN qlen 1000
#     inet6 ::1/128 scope host noprefixroute
#        valid_lft forever preferred_lft forever
# 2: enp6s0: <BROADCAST,MULTICAST,UP,LOWER_UP> mtu 1500 state UP qlen 1000
#     inet6 2003:e2:bf15:7996:6151:c8e8:e97b:eb81/64 scope global deprecated dynamic noprefixroute
#        valid_lft 20730sec preferred_lft 0sec
#     inet6 2003:e2:bf15:799a:a383:d847:363a:3c09/64 scope global dynamic noprefixroute
#        valid_lft 172748sec preferred_lft 86348sec
#     inet6 fe80::1870:f99:e7b0:da6b/64 scope link noprefixroute
#        valid_lft forever preferred_lft forever
```

### Local DNS Server

```sh
cat /etc/resolv.conf
# # Generated by NetworkManager
# search speedport.ip
# nameserver 192.168.2.1
# nameserver fe80::1%enp6s0
```

```sh
sudo vim /etc/dnsmasq.conf # /log + Enter
```

```text
#...
#log-queries
# CUSTOM LINES
log-queries
log-facility=/var/log/dnsmasq.log
#... + Esc + wq + Enter
```

```sh
sudo systemctl restart dnsmasq
sudo tail -f /var/log/dnsmasq.log
```

```sh
sudo pacman -S bind
dig +trace hdm-stuttgart.de
# ; <<>> DiG 9.20.10 <<>> +trace hdm-stuttgart.de
# ;; global options: +cmd
# .                       452132  IN      NS      f.root-servers.net.
# .                       452132  IN      NS      a.root-servers.net.
# .                       452132  IN      NS      m.root-servers.net.
# .                       452132  IN      NS      l.root-servers.net.
# .                       452132  IN      NS      d.root-servers.net.
# .                       452132  IN      NS      c.root-servers.net.
# .                       452132  IN      NS      b.root-servers.net.
# .                       452132  IN      NS      e.root-servers.net.
# .                       452132  IN      NS      j.root-servers.net.
# .                       452132  IN      NS      g.root-servers.net.
# .                       452132  IN      NS      i.root-servers.net.
# .                       452132  IN      NS      h.root-servers.net.
# .                       452132  IN      NS      k.root-servers.net.
# .                       452132  IN      RRSIG   NS 8 0 518400 20250730170000 20250717160000 46441 . IUlzaY6ntWz1G7nRpK/oG5ZqJj8ibkPYpWiwQ65au537T8v7WPE2gOvw # 24Ie7uzG3llNFMEW4W+jLU6buXTr2VaKnEHM8qUdMYGki4tAvMpi+g6i UG34QBemNSHlP8SdR2OriOIAm5JZigbrzUrB13BhByevxQaDTVKBZyO8 UmLPfbJ6LV171l+nN7n1i0I0SV3JLG/# ZXqfcxpxnqfhA1gDkbXYXQ9UU zibA2mFZWc1SiNF/hnCjOtsOxm89t2EtWuDFk38iAilt7oKpoPicoeLi 2nJHb/93IVsFxYW4Cw1pm4zQx7iHVQimYDwTgGDTYcI0cBuFlce3ZGMo WH194w==
# ;; Received 525 bytes from 192.168.2.1#53(192.168.2.1) in 3 ms
#
# de.                     172800  IN      NS      a.nic.de.
# de.                     172800  IN      NS      l.de.net.
# de.                     172800  IN      NS      s.de.net.
# de.                     172800  IN      NS      f.nic.de.
# de.                     172800  IN      NS      z.nic.de.
# de.                     172800  IN      NS      n.de.net.
# de.                     86400   IN      DS      26755 8 2 F341357809A5954311CCB82ADE114C6C1D724A75C0395137AA397803 5425E78D
# de.                     86400   IN      RRSIG   DS 8 1 86400 20250730190000 20250717180000 46441 . iAQeKcSVWKRQCe7Z8//69i4k8EEYDFcKaqoGmV9BXuz31dQoSL4K+ack # euBMve7KdtZdqtyv5+mQ09PM9o9Su56U18/Gomk0wz3Qcc9AvbFHuQOm LGGIRWpcla80GaTEjJqva02jz14aI2lj3hZzERo+UdROcMNkjuVzuKOS ojjMHEicS6/uGJS+c298R9TKbdIdmwb2uUaRErQWu# +iqqXo+HI/Bdo3p NyenLJ9ViISZ61RJRSQJnRZPijB2cuoM4ENnOPDMWOow6IN9OqyAnQuk Tn2y5A6lUN+3UIZyUQUEOTb8ZNY6eExuCj3eyz3Ocb8f2uYwfg6ZHnXI fJIzZg==
# ;; Received 750 bytes from 198.41.0.4#53(a.root-servers.net) in 5 ms
#
# hdm-stuttgart.de.       86400   IN      NS      dns1.belwue.de.
# hdm-stuttgart.de.       86400   IN      NS      dns3.belwue.de.
# hdm-stuttgart.de.       86400   IN      NS      iz-net-2.hdm-stuttgart.de.
# hdm-stuttgart.de.       86400   IN      NS      iz-net-3.hdm-stuttgart.de.
# hdm-stuttgart.de.       86400   IN      NS      iz-net-4.hdm-stuttgart.de.
# tjlb7qbojvmlf1s6gdriru7vsms1lg16.de. 7200 IN NSEC3 1 1 15 CA12B74ADB90591A TJLCSJAT4LJTVO0TJNCRRDF6KF6ONEFB NS SOA RRSIG DNSKEY NSEC3PARAM
# 8g989bfop5iu489vhovlnjoa2glicgju.de. 7200 IN NSEC3 1 1 15 CA12B74ADB90591A 8G9987P8K4R6C755OROF7OFL88B63296
# tjlb7qbojvmlf1s6gdriru7vsms1lg16.de. 7200 IN RRSIG NSEC3 8 2 7200 20250727041445 20250713024445 11226 de. TrK8rnOfdRGaRL8p4UEdjefMQafvyzzNEWEJe0IAx44gE6Gb74YEXNrf Oay97Ljh2BFrmad0feEcsHgWlGEJgpZljC4lMJOqw4trbNLXOIflgQgt gZr6Xl3rlJgEtzKxTHFb4y0d9YEYcz9OMbCKagJ30dsgqhVSAhcem5yg mmo=
# 8g989bfop5iu489vhovlnjoa2glicgju.de. 7200 IN RRSIG NSEC3 8 2 7200 20250726024001 20250712011001 11226 de. VczQSOGNYyVon5AdokWxeVmrql2D3eBdOmaeANw9xJEjqxhvF3funFVn lJVMsv5U5agcUbVNGZ4wfaWBRucIcQ3XKbkBaoML2r6/3Cll6x62bRuv DUDKRi3CzsQlsTOUPy26d+a1gAtLXElcd0eyMT6gAxUAzS7ic0Kp8Dxu y58=
# ;; Received 800 bytes from 2003:8:14::53#53(s.de.net) in 6 ms
#
# hdm-stuttgart.de.       1800    IN      SOA     iz-dns-master.hdm-stuttgart.de. hostmaster.hdm-stuttgart.de. 1752763849 3600 1800 3600000 1800
# ;; Received 106 bytes from 2001:7c0:0:253::133#53(dns3.belwue.de) in 9 ms
# -----------------------------
# No entry found
dig +trace ox.hdm-stuttgart.de
# ; <<>> DiG 9.20.10 <<>> +trace ox.hdm-stuttgart.de
# ;; global options: +cmd
# .                       451978  IN      NS      f.root-servers.net.
# .                       451978  IN      NS      a.root-servers.net.
# .                       451978  IN      NS      m.root-servers.net.
# .                       451978  IN      NS      l.root-servers.net.
# .                       451978  IN      NS      d.root-servers.net.
# .                       451978  IN      NS      c.root-servers.net.
# .                       451978  IN      NS      b.root-servers.net.
# .                       451978  IN      NS      e.root-servers.net.
# .                       451978  IN      NS      j.root-servers.net.
# .                       451978  IN      NS      g.root-servers.net.
# .                       451978  IN      NS      i.root-servers.net.
# .                       451978  IN      NS      h.root-servers.net.
# .                       451978  IN      NS      k.root-servers.net.
# .                       451978  IN      RRSIG   NS 8 0 518400 20250730170000 20250717160000 46441 . IUlzaY6ntWz1G7nRpK/oG5ZqJj8ibkPYpWiwQ65au537T8v7WPE2gOvw 24Ie7uzG3llNFMEW4W+jLU6buXTr2VaKnEHM8qUdMYGki4tAvMpi+g6i UG34QBemNSHlP8SdR2OriOIAm5JZigbrzUrB13BhByevxQaDTVKBZyO8 UmLPfbJ6LV171l+nN7n1i0I0SV3JLG/ZXqfcxpxnqfhA1gDkbXYXQ9UU zibA2mFZWc1SiNF/hnCjOtsOxm89t2EtWuDFk38iAilt7oKpoPicoeLi 2nJHb/93IVsFxYW4Cw1pm4zQx7iHVQimYDwTgGDTYcI0cBuFlce3ZGMo WH194w==
# ;; Received 525 bytes from 192.168.2.1#53(192.168.2.1) in 3 ms
#
# de.                     172800  IN      NS      a.nic.de.
# de.                     172800  IN      NS      f.nic.de.
# de.                     172800  IN      NS      l.de.net.
# de.                     172800  IN      NS      n.de.net.
# de.                     172800  IN      NS      s.de.net.
# de.                     172800  IN      NS      z.nic.de.
# de.                     86400   IN      DS      26755 8 2 F341357809A5954311CCB82ADE114C6C1D724A75C0395137AA397803 5425E78D
# de.                     86400   IN      RRSIG   DS 8 1 86400 20250730190000 20250717180000 46441 . iAQeKcSVWKRQCe7Z8//69i4k8EEYDFcKaqoGmV9BXuz31dQoSL4K+ack # euBMve7KdtZdqtyv5+mQ09PM9o9Su56U18/Gomk0wz3Qcc9AvbFHuQOm LGGIRWpcla80GaTEjJqva02jz14aI2lj3hZzERo+UdROcMNkjuVzuKOS ojjMHEicS6/uGJS+c298R9TKbdIdmwb2uUaRErQWu+iqqXo+HI/Bdo3p NyenLJ9ViISZ61RJRSQJnRZPijB2cuoM4ENnOPDMWOow6IN9OqyAnQuk Tn2y5A6lUN+3UIZyUQUEOTb8ZNY6eExuCj3eyz3Ocb8f2uYwfg6ZHnXI fJIzZg==
# ;; Received 753 bytes from 2001:503:c27::2:30#53(j.root-servers.net) in 6 ms
#
# hdm-stuttgart.de.       86400   IN      NS      dns1.belwue.de.
# hdm-stuttgart.de.       86400   IN      NS      dns3.belwue.de.
# hdm-stuttgart.de.       86400   IN      NS      iz-net-2.hdm-stuttgart.de.
# hdm-stuttgart.de.       86400   IN      NS      iz-net-3.hdm-stuttgart.de.
# hdm-stuttgart.de.       86400   IN      NS      iz-net-4.hdm-stuttgart.de.
# tjlb7qbojvmlf1s6gdriru7vsms1lg16.de. 7200 IN NSEC3 1 1 15 CA12B74ADB90591A TJLCSJAT4LJTVO0TJNCRRDF6KF6ONEFB NS SOA RRSIG DNSKEY NSEC3PARAM
# 8g989bfop5iu489vhovlnjoa2glicgju.de. 7200 IN NSEC3 1 1 15 CA12B74ADB90591A 8G9987P8K4R6C755OROF7OFL88B63296
# tjlb7qbojvmlf1s6gdriru7vsms1lg16.de. 7200 IN RRSIG NSEC3 8 2 7200 20250727041445 20250713024445 11226 de. TrK8rnOfdRGaRL8p4UEdjefMQafvyzzNEWEJe0IAx44gE6Gb74YEXNrf Oay97Ljh2BFrmad0feEcsHgWlGEJgpZljC4lMJOqw4trbNLXOIflgQgt gZr6Xl3rlJgEtzKxTHFb4y0d9YEYcz9OMbCKagJ30dsgqhVSAhcem5yg mmo=
# 8g989bfop5iu489vhovlnjoa2glicgju.de. 7200 IN RRSIG NSEC3 8 2 7200 20250726024001 20250712011001 11226 de. VczQSOGNYyVon5AdokWxeVmrql2D3eBdOmaeANw9xJEjqxhvF3funFVn lJVMsv5U5agcUbVNGZ4wfaWBRucIcQ3XKbkBaoML2r6/3Cll6x62bRuv DUDKRi3CzsQlsTOUPy26d+a1gAtLXElcd0eyMT6gAxUAzS7ic0Kp8Dxu y58=
# ;; Received 803 bytes from 195.243.137.26#53(s.de.net) in 6 ms
#
# ox.hdm-stuttgart.de.    3600    IN      A       141.62.16.30
# ;; Received 64 bytes from 129.143.2.10#53(dns1.belwue.de) in 10 ms
# -----------------------------
# Entry found: A 141.62.16.30 (IPv6 is a AAAA record)
dig ox.hdm-stuttgart.de AAAA
# ; <<>> DiG 9.20.10 <<>> ox.hdm-stuttgart.de AAAA
# ;; global options: +cmd
# ;; Got answer:
# ;; ->>HEADER<<- opcode: QUERY, status: NOERROR, id: 9360
# ;; flags: qr rd ra ad; QUERY: 1, ANSWER: 0, AUTHORITY: 0, ADDITIONAL: 1
#
# ;; OPT PSEUDOSECTION:
# ; EDNS: version: 0, flags:; udp: 1232
# ;; QUESTION SECTION:
# ;ox.hdm-stuttgart.de.           IN      AAAA
#
# ;; Query time: 1 msec
# ;; SERVER: 192.168.2.1#53(192.168.2.1) (UDP)
# ;; WHEN: Fri Jul 18 02:49:12 CEST 2025
# ;; MSG SIZE  rcvd: 48
# -----------------------------
# No AAAA entry found
dig google.de AAAA
# ; <<>> DiG 9.20.10 <<>> google.de AAAA
# ;; global options: +cmd
# ;; Got answer:
# ;; ->>HEADER<<- opcode: QUERY, status: NOERROR, id: 41343
# ;; flags: qr rd ra; QUERY: 1, ANSWER: 1, AUTHORITY: 0, ADDITIONAL: 1
#
# ;; OPT PSEUDOSECTION:
# ; EDNS: version: 0, flags:; udp: 512
# ;; QUESTION SECTION:
# ;google.de.                     IN      AAAA
#
# ;; ANSWER SECTION:
# google.de.              215     IN      AAAA    2a00:1450:4016:808::2003
#
# ;; Query time: 4 msec
# ;; SERVER: 192.168.2.1#53(192.168.2.1) (UDP)
# ;; WHEN: Fri Jul 18 02:51:44 CEST 2025
# ;; MSG SIZE  rcvd: 66
# -----------------------------
# AAAA entry found (2a00:1450:4016:808::2003)
```
