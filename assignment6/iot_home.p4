/* -*- P4_16 -*- */

/*
 * The Protocol header looks like this:
 *
 *        0                1                  2              3
 * +----------------+----------------+----------------+---------------+
 * |      P         |      4         |   version      |     cmd       |
 * +----------------+----------------+----------------+---------------+
 * |               time              |    status      |               | 
 * +----------------+----------------+----------------+---------------+
 */
 
 
#include <core.p4>
#include <v1model.p4>


header ethernet_t {
    bit<48> dstAddr;
    bit<48> srcAddr;
    bit<16> etherType;
}


const bit<16> IHOME_ETYPE = 0x1234;
const bit<8>  IHOME_P     = 0x50;   // 'P'
const bit<8>  IHOME_4     = 0x34;   // '4'
const bit<8>  IHOME_VER   = 0x01;   // v0.1
const bit<8>  IHOME_UPDATE= 0x55;   // 'U'
const bit<8>  IHOME_USROFF= 0x30;   // '0'
const bit<8>  IHOME_USRON = 0x31;   // '1'


header ihome_t{
    
    bit<8> p;
    bit<8> four;
    bit<8> ver;
    bit<8> cmd;
    bit<16> time;
    bit<8> status;
}
    
struct headers {
    ethernet_t   ethernet;
    ihome_t     ihome;
}


struct metadata {
    /* In our case it is empty */
}


/*************************************************************************
 ***********************  P A R S E R  ***********************************
 *************************************************************************/

parser MyParser(packet_in packet,
                out headers hdr,
                inout metadata meta,
                inout standard_metadata_t standard_metadata) {
    state start {
        packet.extract(hdr.ethernet);
        transition select(hdr.ethernet.etherType) {
            IHOME_ETYPE : check_ihome;
            default      : accept;
        }
    }

    state check_ihome {

        transition select(packet.lookahead<ihome_t>().p,
        packet.lookahead<ihome_t>().four,
        packet.lookahead<ihome_t>().ver) {
            (IHOME_P, IHOME_4, IHOME_VER) : parse_ihome;
            default                          : accept;
        }
        
    }

    state parse_ihome {
        packet.extract(hdr.ihome);
        transition accept;
    }
}


/*************************************************************************
 ************   C H E C K S U M    V E R I F I C A T I O N   *************
 *************************************************************************/
control MyVerifyChecksum(inout headers hdr,
                         inout metadata meta) {
    apply { }
}


/*************************************************************************
 **************  I N G R E S S   P R O C E S S I N G   *******************
 *************************************************************************/
control MyIngress(inout headers hdr,
                  inout metadata meta,
                  inout standard_metadata_t standard_metadata){
	action send_back() {
	
		bit<48> tmp_mac;
        	tmp_mac = hdr.ethernet.dstAddr;
        	hdr.ethernet.dstAddr = hdr.ethernet.srcAddr;
        	hdr.ethernet.srcAddr = tmp_mac;
         
        	standard_metadata.egress_spec = standard_metadata.ingress_port;
        }
        
        action light_time(){
       		if (hdr.ihome.time > 1800 && hdr.ihome.time < 2300){
       			hdr.ihome.status = 1; //on	
       		}
       			
       		else{
       			hdr.ihome.status = 0; //off
       		}
       		send_back();
       	}
        
        action light_on(){
        	hdr.ihome.status = 1;
        	send_back();
        }
        
        action light_off(){
        	hdr.ihome.status = 0;
        	send_back();
        }
        	
        action operation_drop() {
        	mark_to_drop(standard_metadata);
    	}	
        
        
        table modify_status {
        	key = {
            		hdr.ihome.cmd        : exact;
        	}
        	actions = {
			light_time;
			light_on;
			light_off;
			operation_drop;
        	}
        	const default_action = operation_drop();
        	const entries = {
        		IHOME_UPDATE: light_time();
        		IHOME_USRON : light_on();
        		IHOME_USROFF: light_off();
        
        	}
    	}
	
	
	apply {
        	if (hdr.ihome.isValid()) {
            		modify_status.apply();
        	} else {
            		//operation_drop();
            		send_back();
        	}
    	}
}
	
	
	
/*************************************************************************
 ****************  E G R E S S   P R O C E S S I N G   *******************
 *************************************************************************/
control MyEgress(inout headers hdr,
                 inout metadata meta,
                 inout standard_metadata_t standard_metadata) {
    apply { }
}

/*************************************************************************
 *************   C H E C K S U M    C O M P U T A T I O N   **************
 *************************************************************************/

control MyComputeChecksum(inout headers hdr, inout metadata meta) {
    apply { }
}

/*************************************************************************
 ***********************  D E P A R S E R  *******************************
 *************************************************************************/
control MyDeparser(packet_out packet, in headers hdr) {
    apply {
        packet.emit(hdr.ethernet);
        packet.emit(hdr.ihome);
    }
}

/*************************************************************************
 ***********************  S W I T T C H **********************************
 *************************************************************************/

V1Switch(
MyParser(),
MyVerifyChecksum(),
MyIngress(),
MyEgress(),
MyComputeChecksum(),
MyDeparser()
) main;	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	

 
 
