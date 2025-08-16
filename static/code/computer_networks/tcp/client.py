import socket
import time
import sys

if __name__ == "__main__":
    port = 6000
    ip = sys.argv[1] if len(sys.argv) > 1 else '127.0.0.1'

    # Create a TCP socket
    client = socket.socket(socket.AF_INET, socket.SOCK_STREAM)

    # Connect to the server (triggers 3-way handshake)
    client.connect((ip, port))
    print("Connected to server.")

    # Send a message
    client.send(b'Hello, ')
    client.send(b'server!')
    print("Message sent.")

    # Wait for message from server
    data = client.recv(14)
    print(f"Received: {data.decode()}")

    # Close the connection (triggers FIN -> ACK -> FIN -> ACK)
    client.close()
    print("Connection closed.")
