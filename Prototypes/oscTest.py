#!/usr/bin/env python

from OSC import OSCServer, OSCClient, OSCMessage
from time import sleep
from gpiozero import Button, MCP3008, LED


server_ip = '192.168.1.107'
client_ip = '192.168.1.104'

button = Button(19)
red = LED(13)
green = LED(12)
yellow = LED(6)

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

server = OSCServer((server_ip, 9090))
send_address = (client_ip, 8000)
c = OSCClient()
c.connect(send_address)

def test_ping():
    green.off()
    red.off()
    yellow.on()
    sleep(0.5)
    for i in range(10):
        send_osc('/test', 'ping')
        sleep(0.5)


while True:
    try:
        test_ping()
    except Exception as e:
        yellow.off()
        for i in range(10, 0, -1):
            print 'Client not found, trying connection again in ' + str(i) + ' seconds'
            red.on()
            sleep(0.5)
            red.off()
            sleep(0.5)
        print 'Trying connection again...'
        continue
    break


pot1_last_read = 0
pot2_last_read = 0
pot3_last_read = 0
pot4_last_read = 0
pot5_last_read = 0
pot6_last_read = 0
tolerance = 5

while True:
    yellow.off()
    green.on()

    pot1 = MCP3008(channel=0, device=0)
    pot2 = MCP3008(channel=1, device=0)
    pot3 = MCP3008(channel=2, device=0)

    pot1_changed = False
    pot2_changed = False
    pot3_changed = False
    pot4_changed = False
    pot5_changed = False
    pot6_changed = False

    one = int(pot1.value * 255)
    two = int(pot2.value * 255)
    three = int(pot3.value * 255)

    pot1_movement = abs(one - pot1_last_read)
    pot2_movement = abs(two - pot2_last_read)
    pot3_movement = abs(three - pot3_last_read)

    if pot1_movement > tolerance:
        pot1_changed = True
    if pot2_movement > tolerance:
        pot2_changed = True
    if pot3_movement > tolerance:
        pot3_changed = True
    if pot1_movement > tolerance and button.is_pressed == True:
        pot4_changed = True
    if pot2_movement > tolerance and button.is_pressed == True:
        pot5_changed = True
    if pot3_movement > tolerance and button.is_pressed == True:
        pot6_changed = True

    if pot1_changed == True and button.is_pressed == False:
        print('Pot1: ', one)
        send_osc('/pot1', one)
        pot1_last_read = one
    if pot2_changed == True and button.is_pressed == False:
        print('Pot2: ', two)
        send_osc('/pot2', two)
        pot2_last_read = two
    if pot3_changed == True and button.is_pressed == False:
        print('Pot3: ', three)
        send_osc('/pot3', three)
        pot3_last_read = three
    if pot1_changed == True and button.is_pressed == True:
        print('Pot4: ', one)
        send_osc('/pot4', one)
        pot4_last_read = one
    if pot2_changed == True and button.is_pressed == True:
        print('Pot5: ', two)
        send_osc('/pot5', two)
        pot5_last_read = two
    if pot3_changed == True and button.is_pressed == True:
        print('Pot6: ', three)
        send_osc('/pot6', three)
        pot6_last_read = three

    sleep(0.1)
