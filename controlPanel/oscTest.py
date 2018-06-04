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
def readPot(c):
    pot = MCP3008(channel=c, device=0)
    threshold = 0.05

    last_value = int((((pot.value - 0) * (255 - 0)) / (1 - 0)) + 0)

    print(last_value)

    while True:
        new_value = (((pot.value - 0) * (255 - 0)) / (1 - 0)) + 0
        if abs((last_value - new_value) / new_value) > threshold:
            message = int(new_value)
            send_osc('/pot' + str(c), message)
            print('Sending ', message, ' to pot #', str(c))
            last_value = message
        else:
            sleep(0.05)

# assign server ip and port
server = OSCServer((server_ip, 9090))
send_address = (client_ip, 8000)

c = OSCClient()
c.connect(send_address)

readPot(0)
readPot(1)
readPot(2)
