// $Header: /devl/xcs/repo/env/Databases/CAEInterfaces/verunilibs/s/STARTUP_FPGACORE.v,v 1.1 2003/01/23 01:39:09 wloo Exp $
/*

FUNCTION	: Special Function Cell, STARTUP_FPGACORE

*/

`timescale  100 ps / 10 ps


module STARTUP_FPGACORE (CLK, GSR, GTS);

    input  CLK, GSR, GTS;

    tri0 GSR, GTS;

	assign glbl.GSR = GSR;
	assign glbl.GTS = GTS;

endmodule

