from time import sleep
from gpiozero import MCP3008


pot1_last_read = 0
pot2_last_read = 0
pot3_last_read = 0
tolerance = 5

print("Opening readings: ", pot1_last_read, pot2_last_read, pot3_last_read)

while True:
    pot1 = MCP3008(channel=0, device=0)
    pot2 = MCP3008(channel=1, device=0)
    pot3 = MCP3008(channel=2, device=0)

    pot1_changed = False
    pot2_changed = False
    pot3_changed = False

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

    if pot1_changed == True:
        print('Pot1: ', one)
        pot1_last_read = one
    if pot2_changed == True:
        print('Pot2: ', two)
        pot2_last_read = two
    if pot3_changed == True:
        print('Pot3: ', three)
        pot3_last_read = three

sleep(0.1)
