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

    last_value_1 = (((pot1.value - 0) * (255 - 0)) / (1 - 0)) + 0
    last_value_2 = (((pot2.value - 0) * (255 - 0)) / (1 - 0)) + 0
    last_value_3 = (((pot3.value - 0) * (255 - 0)) / (1 - 0)) + 0

    while True:

        new_value_1 = (((pot1.value - 0) * (255 - 0)) / (1 - 0)) + 0
        if abs((last_value_1 - new_value_1) / new_value_1) > threshold:
            message1 = '{:.0f}'.format(new_value_1)
            send_osc('/pot1', int(message1))
	    print('pot1 = ', message1)
        else:
            sleep(0.05)

        new_value_2 = (((pot2.value - 0) * (255 - 0)) / (1 - 0)) + 0
        if abs((last_value_2 - new_value_2) / new_value_2) > threshold:
            message2 = '{:.0f}'.format(new_value_2)
            send_osc('/pot2', int(message2))
            print('pot2 = ', message2)
        else:
            sleep(0.05)

        new_value_3 = (((pot3.value - 0) * (255 - 0)) / (1 - 0)) + 0
        if abs((last_value_3 - new_value_3) / new_value_3) > threshold:
            message3 = '{:.0f}'.format(new_value_3)
            send_osc('/pot3', int(message3))
            print('pot3 = ', message3)
        else:
            sleep(0.05)

# assign server ip and port
server = OSCServer((server_ip, 9090))
send_address = (client_ip, 8000)

c = OSCClient()
c.connect(send_address)


readPots()
