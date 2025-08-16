from scapy.all import *
import sys

def mtu_discovery(target_ip, max_mtu=1500, min_mtu=576):
    current_mtu = max_mtu
    last_successful_mtu = min_mtu

    print(f"Starting Path MTU Discovery to {target_ip=} {max_mtu=} {min_mtu=}")
    while current_mtu >= min_mtu:
        # Build an IP packet with DF bit set and payload size = current_mtu - header sizes
        ip = IP(dst=target_ip, flags="DF")
        # Payload length = MTU - IP header (20) - ICMP header (8)
        payload_size = current_mtu - 28
        if payload_size < 0:
            print("Payload size too small, stopping.")
            break

        payload = Raw(load="X" * payload_size)
        pkt = ip/ICMP()/payload

        # Send and wait for response or timeout
        reply = sr1(pkt, timeout=2, verbose=0)

        if reply is None:
            print(f"No reply for MTU {current_mtu} ({ip}) - maybe packet passed (or ICMP blocked)")
            last_successful_mtu = current_mtu
            break

        # Check if we got an ICMP "Fragmentation Needed" (Type 3, Code 4)
        if (reply.haslayer(ICMP) and reply.getlayer(ICMP).type == 3 and reply.getlayer(ICMP).code == 4):
            print(f"Fragmentation Needed at MTU {current_mtu}, lowering MTU")
            current_mtu -= 10  # Reduce MTU and try again
        else:
            print(f"Packet of size {current_mtu} passed successfully")
            last_successful_mtu = current_mtu
            break

    print(f"Path MTU is approximately {last_successful_mtu}")

def path_mtu_discovery_ipv6(dst_ip):
    print(f"Starting Path MTU Discovery to {dst_ip} (IPv6)")

    # Start with a large packet size
    mtu = 1500

    while mtu > 1280:  # IPv6 minimum MTU is 1280 bytes
        # Create an IPv6 packet with an ICMPv6 Echo Request and set the 'M' flag in Fragment Header
        pkt = (
            IPv6(dst=dst_ip) /
            ICMPv6EchoRequest() /
            Raw(b'X' * (mtu - 40 - 8))  # Subtract IPv6 header (40 bytes) and ICMPv6 header (8 bytes)
        )
        # Send and wait for response, timeout 2s
        reply = sr1(pkt, timeout=2, verbose=0)

        if reply is None:
            print(f"No reply for MTU {mtu}, stopping")
            break

        # Check if reply is ICMPv6 Packet Too Big
        if reply.haslayer(ICMPv6PacketTooBig):
            new_mtu = reply[ICMPv6PacketTooBig].mtu
            print(f"Packet Too Big received, new MTU suggested: {new_mtu}")
            mtu = new_mtu
        else:
            print(f"Reply received with MTU {mtu}, path MTU discovered")
            break

if __name__ == "__main__":
    if len(sys.argv) < 1:
        sys.exit(1)
    mtu_discovery(sys.argv[1])

    if len(sys.argv) < 2:
        sys.exit(1)

    path_mtu_discovery_ipv6(sys.argv[2])
