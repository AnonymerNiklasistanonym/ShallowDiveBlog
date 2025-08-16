from scapy.all import ARP, Ether, sendp, srp
import psutil
import socket

def send_gratuitous_arp(interface, ip, mac):
    # Gratuitous ARP request: Sender and Target IP are the same (own IP)
    arp_request = ARP(
        op=1,                # ARP request
        hwsrc=mac,           # Sender MAC address
        psrc=ip,             # Sender IP address (own IP)
        hwdst="00:00:00:00:00:00",  # Target MAC unknown
        pdst=ip              # Target IP address (same as sender IP)
    )
    ether = Ether(dst="ff:ff:ff:ff:ff:ff")  # Broadcast frame

    packet = ether / arp_request
    print(f"Sending gratuitous ARP for IP {ip} on {interface}")
    sendp(packet, iface=interface, verbose=False)

def send_arp_request(interface, target_ip):
    arp = ARP(pdst=target_ip)
    ether = Ether(dst="ff:ff:ff:ff:ff:ff")  # Broadcast

    packet = ether / arp

    print(f"Sending ARP for IP {ip} on {interface}")
    ans, _ = srp(packet, timeout=2, iface=interface, verbose=False)

    for sent, received in ans:
        print(f"{target_ip} is at {received.hwsrc}")

if __name__ == "__main__":
    interfaces = []
    ips = []
    for iface_name, iface_addrs in psutil.net_if_addrs().items():
        for addr in iface_addrs:
            if addr.family == socket.AF_INET or addr.family == socket.AF_INET6:
                ips.append((addr.address))
            if addr.family == psutil.AF_LINK:
                interfaces.append((iface_name, addr.address))

    print("Available network interfaces:")
    for i, (name, mac) in enumerate(interfaces):
        print(f"{i + 1}. {name} (MAC: {mac})")

    # Ask for user input
    choice = input("Select an interface by number: ")
    try:
        index = int(choice) - 1
        selected = interfaces[index]
        interface, mac = interfaces[index]
        #interface = "eth0"
        #mac = "00:11:22:33:44:55"
    except (ValueError, IndexError):
        print("❌ Invalid interface selection.")

    # Should result in a duplicate because this is the router!
    ip_router = "192.168.2.1" # TODO Change this!
    ips.append(ip_router)
    for ip in ips:
        send_gratuitous_arp(interface, ip, mac)

    for ip in [ip_router]:
        send_arp_request(interface, ip)
