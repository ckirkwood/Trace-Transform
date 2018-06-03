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

def send_pots():
    pot1 = MCP3008(channel=0)
    pot2 = MCP3008(channel=1)
    pot3 = MCP3008(channel=2)
    pots = [pot1.value, pot2.value, pot3.value]
    send_osc('/pots', pots)
    print(pots)

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
    send_pots()
