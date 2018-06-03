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
def readPots():
    pot1 = MCP3008(channel=0, device=0)
    pot2 = MCP3008(channel=1, device=0)    
    pot3 = MCP3008(channel=2, device=0)
    threshold = 0.05

    1_last_value = (((pot1.value - 0) * (255 - 0)) / (1 - 0)) + 0
    2_last_value = (((pot2.value - 0) * (255 - 0)) / (1 - 0)) + 0
    3_last_value = (((pot3.value - 0) * (255 - 0)) / (1 - 0)) + 0

    while True:

        1_new_value = (((pot1.value - 0) * (255 - 0)) / (1 - 0)) + 0
        if abs((1_last_value - 1_new_value) / 1_new_value) > threshold:
            message1 = '{:.0f}'.format(1_new_value)
            send_osc('/pot1', message1)
	    print('pot1 = ', message1)
        else:
            sleep(0.05)

        2_new_value = (((pot2.value - 0) * (255 - 0)) / (1 - 0)) + 0
        if abs((2_last_value - 2_new_value) / 2_new_value) > threshold:
            message2 = '{:.0f}'.format(2_new_value)
            send_osc('/pot2', message2)
            print('pot2 = ', message2)
        else:
            sleep(0.05)

        3_new_value = (((pot3.value - 0) * (255 - 0)) / (1 - 0)) + 0
        if abs((3_last_value - 3_new_value) / 3_new_value) > threshold:
            message3 = '{:.0f}'.format(3_new_value)
            send_osc('/pot3', message3)
            print('pot3 = ', message3)
        else:
            sleep(0.05)

# assign server ip and port
server = OSCServer((server_ip, 9090))
send_address = (client_ip, 8000)

c = OSCClient()
c.connect(send_address)

while True:
    readPots()
