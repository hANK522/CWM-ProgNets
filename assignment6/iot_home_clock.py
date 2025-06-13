#!/usr/bin/env python3

import time as sleeptime
from scapy.all import *

class Ihome(Packet):
    name = "ihome"
    fields_desc = [ StrFixedLenField("P", "P", length=1),
                    StrFixedLenField("Four", "4", length=1),
                    XByteField("version", 0x01),
                    StrFixedLenField("cmd", "U", length=1),
                    IntField("time", 0),
                    IntField("status", 0)]

bind_layers(Ether, Ihome, type=0x1234)

def add_n_mins(time,n):
    hour = time // 100
    minute = time % 100
    
    minute += n
    if minute >= 60:
        minute -= 60
        hour += 1
        
    if hour == 24:
    	hour = 0
    	
    return hour * 100 + minute

def isUserControl(current_status):
    if current_status == 1 or current_status == 0:
    	s = 'U'
    else:
    	s = 'C'
    return s
    
def snl(iface, s, t): #send and listen
    pkt = Ether(dst='E4:5F:01:84:8C:CE', type=0x1234) / Ihome(cmd = s,time = int(t))

    pkt = pkt/' '

    #pkt.show()
    resp = srp1(pkt, iface=iface,timeout=5, verbose=False)
    
    return resp
    
def get_if():
    ifs=get_if_list()
    iface= "veth0-1" # "h1-eth0"
    #for i in get_if_list():
    #    if "eth0" in i:
    #        iface=i
    #        break;
    #if not iface:
    #    print("Cannot find eth0 interface")
    #    exit(1)
    #print(iface)
    return iface

def main():
	n = 10
	interval = 0.5
	u = 'U'
	c = 'C'
	#iface = get_if()
	iface = "enx0c37965f8a18"
	current_status = 0
	t = 0
    
	while True:
		t = add_n_mins(t,n)
		print(t)

        
		try:
			resp = snl(iface, c, t)
            
			if resp:
				ihome=resp[Ihome]
				if ihome:
					current_status = ihome.status
					#print(current_status) 
					if current_status == 1:
						print('Light ON')
					elif current_status == 0:
						print('Light OFF')
					elif current_status == 2:
						print('Light OFF')
						sleeptime.sleep(interval)
						t = add_n_mins(t,n)
						print(t)
						print('Light OFF')
					else:
						print('Light ON')
						sleeptime.sleep(interval)
						t = add_n_mins(t,n)
						print(t)
						print('Light ON')
					resp = snl(iface, u, t)
				else:
					print("cannot find ihome header in the packet")
			else:
				print("Didn't receive response")
				
		except Exception as error:
			print(error)
			
		sleeptime.sleep(interval)


if __name__ == '__main__':
	main()


