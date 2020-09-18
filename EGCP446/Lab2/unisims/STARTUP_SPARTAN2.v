// $Header: /devl/xcs/repo/env/Databases/CAEInterfaces/verunilibs/s/STARTUP_SPARTAN2.v,v 1.9 2003/01/21 01:55:44 wloo Exp $
/*

FUNCTION	: Special Function Cell, STARTUP_SPARTAN2

*/

`timescale  100 ps / 10 ps


module STARTUP_SPARTAN2 (CLK, GSR, GTS);

    input  CLK, GSR, GTS;

    tri0 GSR, GTS;

	assign glbl.GSR = GSR;
	assign glbl.GTS = GTS;

endmodule

