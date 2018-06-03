from OSC import OSCServer, OSCClient, OSCMessage
from time import sleep
from threading import Thread
from gpiozero import Button, MCP3008
from signal import pause


server_ip = '192.168.1.107'
client_ip = '192.168.1.104'

# function to send message with multiple values
def send_osc(addr, *stuff):
    msg = OSCMessage()
    msg.setAddress(addr)
    for item in stuff:
        msg.append(item)
    c.send(msg)


### functions to call when osc message received ###
def oscInput(addr, tags, stuff, source):
  print addr, stuff, source

# pot listener courtsey of Maxmillian Peters - https://stackoverflow.com/questions/37897483/how-to-display-a-changing-value-python
def readPots(i):
    pot = MCP3008(channel=i, device=0)
    threshold = 0.05

    last_value = (((pot.value - 0) * (255 - 0)) / (1 - 0)) + 0

    while True:
        new_value = (((pot.value - 0) * (255 - 0)) / (1 - 0)) + 0
        if abs((last_value - new_value) / new_value) > threshold:
            message = '{:.0f}'.format(new_value)
            send_osc('/pot' + i, pot.value)
            last_value = new_value
            return message
        else:
            sleep(0.05)

# assign server ip and port
server = OSCServer((server_ip, 9090))
send_address = (client_ip, 8000)

c = OSCClient()
c.connect(send_address)

# start thread
server_thread = Thread(target=server.serve_forever)
server_thread.daemon = True
server_thread.start()

while True:
    one = readPots(0)
    two = readPots(1)
    three = readPots(2)
    print(one, two, three)
