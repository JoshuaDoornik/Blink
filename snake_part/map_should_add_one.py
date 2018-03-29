#Though it looks like an ordinary python import, the addList module is implemented in C
import blink

def plus_one(i):
    return i+1

l = [1,2,3,4,5]
print blink.own_map(l,plus_one)
