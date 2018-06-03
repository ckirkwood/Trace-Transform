
from time import sleep
from gpiozero import MCP3008

pot = MCP3008(channel=0, device=0)

while True:
    print(pot.value)

