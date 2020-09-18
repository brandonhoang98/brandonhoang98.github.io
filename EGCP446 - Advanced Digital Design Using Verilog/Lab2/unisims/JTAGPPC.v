// $Header: /devl/xcs/repo/env/Databases/CAEInterfaces/verunilibs/s/JTAGPPC.v,v 1.3 2003/01/21 01:55:28 wloo Exp $

/*

		: JTAG for PPC

*/

`timescale  100 ps / 10 ps

module JTAGPPC (TCK, TDIPPC, TMS, TDOPPC, TDOTSPPC);

output TCK;
output TDIPPC;
output TMS;

input TDOPPC;
input TDOTSPPC;

endmodule
