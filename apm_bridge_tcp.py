import socket
from _thread import *
import queue
import time

ANDROID_HOST = "172.28.190.84"
ANDROID_PORT = 4000

socks = {}
socks['android'] = None
socks['apm'] = None

q = queue.Queue()

def processInput():
    while True:
        data = input()
        # Do something based on what is input in STDIN
        print(data)

        # Sends mavlink data to android phone
        # q.put([('android', mavlink_data)])

        # Sends mavlink data to mission planner
        # q.put([('mp', mavlink_data)])


def androidThread(socks):
    while True:
        print("Connecting to Android")

        socks['android'] = socket.socket(socket.AF_INET, socket.SOCK_STREAM)
        try:
            socks['android'].connect((ANDROID_HOST, ANDROID_PORT))
        except ConnectionRefusedError:
            print("Refused")
            socks['android'] = None
            time.sleep(2)
            continue


        print("Connected to Android")
        while True:
            data = socks['android'].recv(1000)
            if len(data) == 0:
                break
            q.put(['mp', data])

        print("Disconnected from Android")
        socks['android'].close()

def missionPlannerThread(socks, conn):
    print("Connected to Mission Planner")
    start_new_thread(androidThread, (socks,));
    while True:
        q.put(['android', conn.recv(1000)])

def consumerThread(socks):
    while True:
        dest, data = q.get()

        #print("[Consumer]:", dest, data);
        socket = socks[dest]
        if socket is not None:
            try:
                socket.send(data)
            except OSError:
                pass

if __name__ == "__main__":
    s = socket.socket(socket.AF_INET, socket.SOCK_STREAM)
    s.bind(("", 4000));
    s.listen(10)

    start_new_thread(consumerThread, (socks,))
    start_new_thread(processInput, tuple())
    while True:
        conn, addr = s.accept()
        socks['mp'] = conn
        start_new_thread(missionPlannerThread, (socks, conn,))
