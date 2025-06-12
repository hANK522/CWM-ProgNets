/* -*- P4_16 -*- */

/*
 * The Protocol header looks like this:
 *
 *        0                1                  2              3
 * +----------------+----------------+----------------+---------------+
 * |      P         |      4         |   version      |     time      |
 * +----------------+----------------+----------------+---------------+
 * |    time        |   info_type    |    value       |     temp      | 
 * +----------------+----------------+----------------+---------------+
 * |     hum        |  light_status  |   ac_status1   |   ac_status2  |
 * +----------------+----------------+----------------+---------------+
 * | curtain_status |                                                 |
 * +----------------+-------------------------------------------------+
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
const bit<8>  IHOME_HUM

 
 
