
from time import sleep
from gpiozero import MCP3008

def readPot(c)
    pot = MCP3008(channel=c, device=0)
    threshold = 0.05

    last_value = (((pot.value - 0) * (255 - 0)) / (1 - 0)) + 0

    print(last_value)

    while True:
        new_value = (((pot.value - 0) * (255 - 0)) / (1 - 0)) + 0
        if abs((last_value - new_value) / new_value) > threshold:
            print('{:.0f}'.format(new_value))
            last_value = new_value
        else:
            sleep(0.05)

readPot(0)
readPot(1)
readPot(2)
