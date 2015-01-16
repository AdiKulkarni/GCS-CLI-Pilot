import socket
import struct
import sys
from tkinter import *
from PIL import Image, ImageTk
from io import BytesIO
from _thread import *
import time

import time
current_milli_time = lambda: time.time() * 1000

# from datetime import datetime
# def current_milli_time():
#     c = datetime.now()
#     return (c.days * 24 * 60 * 60 + c.seconds) * 1000 + c.microseconds / 1000.0


#####

WIDTH = 640
HEIGHT = 480
HOST = ("localhost", 4004)

if len(sys.argv) == 3:
    HOST = (sys.argv[1], int(sys.argv[2]))

class Packet(object):
    def __init__(self, b):
        b = bytearray(b)

        self.packet_type = int.from_bytes([b[0]], byteorder='big')
        self.trace = int.from_bytes([b[1]], byteorder='big')

        self.total_pieces = int.from_bytes([b[2]], byteorder='big')
        self.current_piece = int.from_bytes([b[3]], byteorder='big')
        self.timestamp = int.from_bytes(b[4:12], byteorder='big')

        self.data = b[12:]

class PacketsBuffer(object):
    def __init__(self, n):
        self.total = n
        self.packets = {}

    def add_packet(self, packet):
        self.packets[packet.current_piece] = packet
        return self.data_if_complete()

    def data_if_complete(self):
        if len(self.packets) != self.total:
            return None

        data = b''
        for i in range(self.total):
            packet = self.packets[i]
            data += packet.data

        return data

class Viewer(object):
    def __init__(self):
        root = Tk()
        root.geometry("%dx%d+0+0" % (WIDTH, HEIGHT))
        root.resizable(False,False)

        frame = Frame(root)
        canvas = Canvas(frame)
        canvas.pack(fill=BOTH, expand=YES)
        canvas.pack()
        frame.pack(fill=BOTH, expand=YES)

        self.root = root
        self.frame = frame
        self.canvas = canvas

    def update_image(self, image):
        self.imagetk = ImageTk.PhotoImage(image)
        self.canvas.create_image(WIDTH, HEIGHT, image=self.imagetk, anchor=SE)
        self.root.update()


viewer = Viewer()

sock = socket.socket(socket.AF_INET, socket.SOCK_DGRAM)
#sock.settimeout(1)

receive_rate = 0
def recvThread(sock):
    global receive_rate
    while True:
        print(receive_rate)
        rr = struct.pack('l', receive_rate)[::-1]
        data = bytes([0x1, 0x1]) + rr
        sock.sendto(data, HOST)

        receive_rate = 0
        time.sleep(1)

buf = {}
last_shown_timestamp = 0
frame_packet = struct.pack('>I', 0)
sock.sendto(frame_packet, HOST)
start_new_thread(recvThread, (sock,))

print("===========================")
print("Host:", HOST)
print("===========================")


try:
    while True:
        data, addr = sock.recvfrom(65527)
        receive_rate += len(data)

        p = Packet(data)

        #print(p.total_pieces, p.current_piece, p.timestamp)
        #if p.total_pieces > 1:
            #print("Multi-piece frame:", p.timestamp)

        timestamp = p.timestamp
        # Ignore images with an earlier timestamp
        if timestamp < last_shown_timestamp:
            print("Out of order: late")
            continue

        # Create new packets buffer if we don't have it yet
        if timestamp not in buf:
            buf[timestamp] = PacketsBuffer(p.total_pieces)

        # Add current packet to the buffer
        image = buf[p.timestamp].add_packet(p)
        if image:
            image = Image.open(BytesIO(image))
            viewer.update_image(image)

            # Purge old images
            buf = {k:v for (k,v) in buf.items() if k <= timestamp}
            last_shown_timestamp = timestamp
except KeyboardInterrupt:
    sock.sendto(frame_packet, HOST)
    print("Bye")
