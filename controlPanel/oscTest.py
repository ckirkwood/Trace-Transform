from OSC import OSCServer, OSCClient, OSCMessage
from time import sleep
from threading import Thread
from gpiozero import Button
import Adafruit_MCP3008
from signal import pause

CLK = 11
MISO = 9
MOSI = 10
CS = 8
mcp = Adafruit_MCP3008.MCP3008(clk=CLK, cs=CS, miso=MISO, mosi=MOSI)

server_ip = '192.168.1.105'
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

# send switch status
def switch1_on():
    send_osc('/switch1', 1)

def switch1_off():
    send_osc('/switch1', 0)

def switch2_on():
    send_osc('/switch2', 1)

def switch2_off():
    send_osc('/switch2', 0)

def send_pots():
    pot1 = mcp.read_adc(0)
    pot2 = mcp.read_adc(1)
    pot3 = mcp.read_adc(2)
    pot4 = mcp.read_adc(3)
    pot5 = mcp.read_adc(4)
    pot6 = mcp.read_adc(5)
    pot7 = mcp.read_adc(6)
    pot8 = mcp.read_adc(7)
    pots = [pot1, pot2, pot3, pot4, pot5, pot6, pot7, pot8]
    send_osc('/pots', pots)
    print(pots)

# assign server ip and port
server = OSCServer((server_ip, 9090))
send_address = (client_ip, 8000)

c = OSCClient()
c.connect(send_address)

# add message handlers - assign functions to incoming message addresses
server.addMsgHandler("/rgb", rgb)
server.addMsgHandler("/hsv", hsv)
server.addMsgHandler("/beat", beat)
server.addMsgHandler("/count", loop_counter)
server.addMsgHandler("/clear_counter", clear_counter)
server.addMsgHandler("/clear_all", clear_all)

# start thread
server_thread = Thread(target=server.serve_forever)
server_thread.daemon = True
server_thread.start()

switch1 = Button(20)
switch2 = Button(21)

try: # send message only when switch status changes
    switch1.when_pressed = switch1_on
    switch1.when_released = switch1_off
    switch2.when_pressed = switch2_on
    switch2.when_released = switch2_off

    while True:
        send_pots()

    pause()

  
except KeyboardInterrupt:
    print 'losing...' # makes use of the '^C' following keyboard interrupt
    server.close()
