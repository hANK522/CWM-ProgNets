#!/usr/bin/env python3


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

    s = ''
    #iface = get_if()
    iface = "enx0c37965f8a18"
    
    while True:
        s = input('cmd: ')
        if s == "U":
       	    t = input('time:')
        else:
            t = 0
        
        
        try:
            
            pkt = Ether(dst='E4:5F:01:84:8C:CE', type=0x1234) / Ihome(cmd = s,time = int(t))

            pkt = pkt/' '

            #pkt.show()
            resp = srp1(pkt, iface=iface,timeout=5, verbose=False)
            
            if resp:
                ihome=resp[Ihome]
                
                if ihome:
                    current_status = ihome.status
                    #print(current_status)
                    if current_status == 1 or current_status == 3:
                    	print('Light ON')
                    else:
                    	print('Light OFF')
                else:
                    print("cannot find ihome header in the packet")
            else:
                print("Didn't receive response")
        except Exception as error:
            print(error)


if __name__ == '__main__':
    main()


