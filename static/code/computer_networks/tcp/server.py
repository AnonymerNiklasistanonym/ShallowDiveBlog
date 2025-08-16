# Run this before starting the client
import socket
import sys
import time

if __name__ == "__main__":
    port = 6000
    ip = sys.argv[1] if len(sys.argv) > 1 else '127.0.0.1'

    server = socket.socket(socket.AF_INET, socket.SOCK_STREAM)
    server.bind((ip, port))
    server.listen(1)
    print(f"Server listening on {ip}:{port}")

    conn, addr = server.accept()
    print(f"Connected by {addr}")

    data = conn.recv(14)
    print(f"Received: {data.decode()}")

    # Send one message
    conn.sendall(b'Hello, client!')

    # Keep the connection alive
    print("Connection open. Waiting...")
    time.sleep(1)
    print("Closing connection.")
    conn.close()
    server.close()
