/***************************************************************
 * MPFSImg2.c
 * Defines an MPFS2 image to be stored in program memory.
 *
 * NOT FOR HAND MODIFICATION
 * This file is automatically generated by the MPFS2 Utility
 * ALL MODIFICATIONS WILL BE OVERWRITTEN BY THE MPFS2 GENERATOR
 * Generated Wednesday, July 13, 2011 7:24:27 PM
 ***************************************************************/

#define __MPFSIMG2_C

#include "TCPIPConfig.h"
#if !defined(MPFS_USE_EEPROM) && !defined(MPFS_USE_SPI_FLASH)

#include "TCPIP Stack/TCPIP.h"
#if defined(STACK_USE_MPFS2)


/**************************************
 * MPFS2 Image Data
 **************************************/
#define DATACHUNK000000 \
	0x4d,0x50,0x46,0x53,0x02,0x01,0x05,0x00,0x06,0x9e,0xff,0xff,0xac,0xe4,0xec,0x46, /* MPFS...........F */ \
	0xff,0xff,0x80,0x00,0x00,0x00,0xa7,0x00,0x00,0x00,0x0b,0x00,0x00,0x00,0x23,0x29, /* ..............#) */ \
	0x1e,0x4e,0x00,0x00,0x00,0x00,0x02,0x00,0x8a,0x00,0x00,0x00,0xb2,0x00,0x00,0x00, /* .N.............. */ \
	0x08,0x00,0x00,0x00,0x23,0x29,0x1e,0x4e,0x00,0x00,0x00,0x00,0x00,0x00,0x8b,0x00, /* ....#).N........ */ \
	0x00,0x00,0xba,0x00,0x00,0x00,0xd0,0x00,0x00,0x00,0x32,0xfc,0x1d,0x4e,0x00,0x00, /* ..........2..N.. */ \
	0x00,0x00,0x00,0x00,0x9b,0x00,0x00,0x00,0x8a,0x01,0x00,0x00,0xcb,0x01,0x00,0x00, /* ................ */ \
	0xed,0x9b,0x1d,0x4e,0x00,0x00,0x00,0x00,0x02,0x00,0xa6,0x00,0x00,0x00,0x55,0x03, /* ...N..........U. */ \
	0x00,0x00,0x40,0x00,0x00,0x00,0xed,0x9b,0x1d,0x4e,0x00,0x00,0x00,0x00,0x00,0x00, /* ..@......N...... */ \
	0x62,0x74,0x6e,0x69,0x63,0x2e,0x63,0x67,0x69,0x00,0x00,0x63,0x72,0x6f,0x73,0x73, /* btnic.cgi..cross */ \
	0x64,0x6f,0x6d,0x61,0x69,0x6e,0x2e,0x78,0x6d,0x6c,0x00,0x69,0x6e,0x64,0x65,0x78, /* domain.xml.index */ \
	0x2e,0x68,0x74,0x6d,0x6c,0x00,0x00,0x7e,0x42,0x54,0x4e,0x69,0x63,0x5f,0x43,0x47, /* .html..~BTNic_CG */ \
	0x49,0x7e,0x00,0x00,0x00,0x00,0x02,0x00,0x00,0x00,0x3c,0x3f,0x78,0x6d,0x6c,0x20, /* I~........<?xml  */ \
	0x76,0x65,0x72,0x73,0x69,0x6f,0x6e,0x3d,0x22,0x31,0x2e,0x30,0x22,0x3f,0x3e,0x0d, /* version="1.0"?>. */ \
	0x0a,0x3c,0x21,0x44,0x4f,0x43,0x54,0x59,0x50,0x45,0x20,0x63,0x72,0x6f,0x73,0x73, /* .<!DOCTYPE cross */ \
	0x2d,0x64,0x6f,0x6d,0x61,0x69,0x6e,0x2d,0x70,0x6f,0x6c,0x69,0x63,0x79,0x20,0x0d, /* -domain-policy . */ \
	0x0a,0x20,0x20,0x53,0x59,0x53,0x54,0x45,0x4d,0x20,0x22,0x68,0x74,0x74,0x70,0x3a, /* .  SYSTEM "http: */ \
	0x2f,0x2f,0x77,0x77,0x77,0x2e,0x6d,0x61,0x63,0x72,0x6f,0x6d,0x65,0x64,0x69,0x61, /* //www.macromedia */ \
	0x2e,0x63,0x6f,0x6d,0x2f,0x78,0x6d,0x6c,0x2f,0x64,0x74,0x64,0x73,0x2f,0x63,0x72, /* .com/xml/dtds/cr */ \
	0x6f,0x73,0x73,0x2d,0x64,0x6f,0x6d,0x61,0x69,0x6e,0x2d,0x70,0x6f,0x6c,0x69,0x63, /* oss-domain-polic */ \
	0x79,0x2e,0x64,0x74,0x64,0x22,0x3e,0x0d,0x0a,0x3c,0x63,0x72,0x6f,0x73,0x73,0x2d, /* y.dtd">..<cross- */ \
	0x64,0x6f,0x6d,0x61,0x69,0x6e,0x2d,0x70,0x6f,0x6c,0x69,0x63,0x79,0x3e,0x0d,0x0a, /* domain-policy>.. */ \
	0x20,0x20,0x3c,0x61,0x6c,0x6c,0x6f,0x77,0x2d,0x61,0x63,0x63,0x65,0x73,0x73,0x2d, /*   <allow-access- */ \
	0x66,0x72,0x6f,0x6d,0x20,0x64,0x6f,0x6d,0x61,0x69,0x6e,0x3d,0x22,0x2a,0x22,0x20, /* from domain="."  */ \
	0x2f,0x3e,0x0d,0x0a,0x3c,0x2f,0x63,0x72,0x6f,0x73,0x73,0x2d,0x64,0x6f,0x6d,0x61, /* />..</cross-doma */ \
	0x69,0x6e,0x2d,0x70,0x6f,0x6c,0x69,0x63,0x79,0x3e,0x3c,0x68,0x74,0x6d,0x6c,0x3e, /* in-policy><html> */ \
	0x0d,0x0a,0x3c,0x68,0x65,0x61,0x64,0x3e,0x3c,0x74,0x69,0x74,0x6c,0x65,0x3e,0x42, /* ..<head><title>B */ \
	0x54,0x6e,0x69,0x63,0x3c,0x2f,0x74,0x69,0x74,0x6c,0x65,0x3e,0x3c,0x2f,0x68,0x65, /* Tnic</title></he */ \
	0x61,0x64,0x3e,0x0d,0x0a,0x3c,0x6d,0x65,0x74,0x61,0x20,0x68,0x74,0x74,0x70,0x2d, /* ad>..<meta http- */ \
	0x65,0x71,0x75,0x69,0x76,0x3d,0x22,0x72,0x65,0x66,0x72,0x65,0x73,0x68,0x22,0x20, /* equiv="refresh"  */ \
	0x63,0x6f,0x6e,0x74,0x65,0x6e,0x74,0x3d,0x22,0x31,0x22,0x3e,0x0d,0x0a,0x3c,0x62, /* content="1">..<b */ \
	0x6f,0x64,0x79,0x3e,0x0d,0x0a,0x3c,0x68,0x31,0x3e,0x42,0x54,0x4e,0x69,0x63,0x20, /* ody>..<h1>BTNic  */ \
	0x45,0x6d,0x62,0x65,0x64,0x64,0x65,0x64,0x3c,0x2f,0x68,0x31,0x3e,0x0d,0x0a,0x3c, /* Embedded</h1>..< */ \
	0x68,0x32,0x3e,0x42,0x54,0x4e,0x69,0x63,0x20,0x56,0x65,0x72,0x73,0x69,0x6f,0x6e, /* h2>BTNic Version */ \
	0x3c,0x2f,0x68,0x32,0x3e,0x0d,0x0a,0x7e,0x42,0x54,0x56,0x65,0x72,0x7e,0x0d,0x0a, /* </h2>..~BTVer~.. */ \
	0x3c,0x68,0x32,0x3e,0x42,0x54,0x43,0x6f,0x6d,0x6d,0x20,0x53,0x74,0x61,0x74,0x75, /* <h2>BTComm Statu */ \
	0x73,0x3c,0x2f,0x68,0x32,0x3e,0x0d,0x0a,0x3c,0x75,0x6c,0x3e,0x0d,0x0a,0x3c,0x6c, /* s</h2>..<ul>..<l */ \
	0x69,0x3e,0x53,0x74,0x61,0x74,0x65,0x3a,0x20,0x7e,0x42,0x54,0x53,0x74,0x61,0x74, /* i>State: ~BTStat */ \
	0x65,0x7e,0x3c,0x2f,0x6c,0x69,0x3e,0x0d,0x0a,0x3c,0x6c,0x69,0x3e,0x42,0x54,0x43, /* e~</li>..<li>BTC */ \
	0x6f,0x6d,0x6d,0x54,0x69,0x6d,0x65,0x72,0x28,0x6d,0x73,0x29,0x3a,0x20,0x7e,0x42, /* ommTimer(ms): ~B */ \
	0x54,0x43,0x6f,0x6d,0x6d,0x54,0x69,0x6d,0x65,0x72,0x7e,0x3c,0x2f,0x6c,0x69,0x3e, /* TCommTimer~</li> */ \
	0x0d,0x0a,0x3c,0x6c,0x69,0x3e,0x54,0x69,0x63,0x6b,0x28,0x6d,0x73,0x29,0x3a,0x20, /* ..<li>Tick(ms):  */ \
	0x7e,0x54,0x69,0x63,0x6b,0x47,0x65,0x74,0x7e,0x3c,0x2f,0x6c,0x69,0x3e,0x0d,0x0a, /* ~TickGet~</li>.. */ \
	0x3c,0x6c,0x69,0x3e,0x42,0x75,0x66,0x66,0x65,0x72,0x3a,0x20,0x7e,0x42,0x54,0x42, /* <li>Buffer: ~BTB */ \
	0x75,0x66,0x66,0x65,0x72,0x7e,0x3c,0x2f,0x6c,0x69,0x3e,0x0d,0x0a,0x3c,0x2f,0x75, /* uffer~</li>..</u */ \
	0x6c,0x3e,0x0d,0x0a,0x0d,0x0a,0x3c,0x68,0x32,0x3e,0x49,0x32,0x43,0x20,0x53,0x74, /* l>....<h2>I2C St */ \
	0x61,0x74,0x75,0x73,0x3c,0x2f,0x68,0x32,0x3e,0x0d,0x0a,0x3c,0x75,0x6c,0x3e,0x0d, /* atus</h2>..<ul>. */ \
	0x0a,0x3c,0x6c,0x69,0x3e,0x53,0x53,0x50,0x31,0x43,0x4f,0x4e,0x31,0x3a,0x20,0x7e, /* .<li>SSP1CON1: ~ */ \
	0x53,0x53,0x50,0x31,0x43,0x4f,0x4e,0x31,0x7e,0x3c,0x2f,0x6c,0x69,0x3e,0x0d,0x0a, /* SSP1CON1~</li>.. */ \
	0x3c,0x6c,0x69,0x3e,0x53,0x53,0x50,0x31,0x43,0x4f,0x4e,0x32,0x3a,0x20,0x7e,0x53, /* <li>SSP1CON2: ~S */ \
	0x53,0x50,0x31,0x43,0x4f,0x4e,0x32,0x7e,0x3c,0x2f,0x6c,0x69,0x3e,0x0d,0x0a,0x3c, /* SP1CON2~</li>..< */ \
	0x6c,0x69,0x3e,0x53,0x53,0x50,0x31,0x53,0x54,0x41,0x54,0x3a,0x20,0x7e,0x53,0x53, /* li>SSP1STAT: ~SS */ \
	0x50,0x31,0x53,0x54,0x41,0x54,0x7e,0x3c,0x2f,0x6c,0x69,0x3e,0x0d,0x0a,0x3c,0x2f, /* P1STAT~</li>..</ */ \
	0x75,0x6c,0x3e,0x0d,0x0a,0x3c,0x2f,0x62,0x6f,0x64,0x79,0x3e,0x0d,0x0a,0x3c,0x2f, /* ul>..</body>..</ */ \
	0x68,0x74,0x6d,0x6c,0x3e,0x8d,0x00,0x00,0x00,0x01,0x00,0x00,0x00,0xbf,0x00,0x00, /* html>........... */ \
	0x00,0x09,0x00,0x00,0x00,0xe4,0x00,0x00,0x00,0x07,0x00,0x00,0x00,0x06,0x01,0x00, /* ................ */ \
	0x00,0x08,0x00,0x00,0x00,0x22,0x01,0x00,0x00,0x0a,0x00,0x00,0x00,0x65,0x01,0x00, /* .....".......e.. */ \
	0x00,0x04,0x00,0x00,0x00,0x84,0x01,0x00,0x00,0x05,0x00,0x00,0x00,0xa3,0x01,0x00, /* ................ */ \
	0x00,0x06,0x00,0x00,0x00                                                         /* .....            */


/**************************************
 * MPFS2 C linkable symbols
 **************************************/
// For C18, these are split into seperate arrays because it speeds up compilation a lot.  
// For other compilers, the entire data array must be defined as a single variable to 
// ensure that the linker does not reorder the data chunks in Flash when compiler 
// optimizations are turned on.
#if defined(__18CXX)
	ROM BYTE MPFS_Start[] = {DATACHUNK000000};
#else
	ROM BYTE MPFS_Start[] = {DATACHUNK000000};
#endif


/**************************************************************
 * End of MPFS
 **************************************************************/
#endif // #if defined(STACK_USE_MPFS2)
#endif // #if !defined(MPFS_USE_EEPROM) && !defined(MPFS_USE_SPI_FLASH)