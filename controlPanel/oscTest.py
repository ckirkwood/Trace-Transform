from OSC import OSCServer, OSCClient, OSCMessage
from time import sleep
from gpiozero import Button, MCP3008


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
    last_value = [0, 0, 0]
    new_value = [0, 0, 0]
    values = [0, 0, 0]
    threshold = 0.99

    while True: 
        for i in range(3):
            pots = [MCP3008(channel=0, device=0), MCP3008(channel=1, device=0), MCP3008(channel=2, device=0)]

            last_value[i] = int((((pots[i].value - 0) * (255 - 0)) / (1 - 0)) + 0)

            new_value[i] = int((((pots[i].value - 0) * (255 - 0)) / (1 - 0)) + 0)

            if abs((last_value[i] - new_value[i]) / new_value[i]) > threshold:
                one, two, three = new_value[0], new_value[1], new_value[2]
                print(one)
                last_value[i] = new_value[i]
            else:
                sleep(0.01)


# assign server ip and port
server = OSCServer((server_ip, 9090))
send_address = (client_ip, 8000)

c = OSCClient()
c.connect(send_address)


p = readPots()
while True:
    print(p)
