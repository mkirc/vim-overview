import socket

s = socket.socket()
s.bind(("localhost", 0))
print(s.getsockname()[1], end='')
s.close()
