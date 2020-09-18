// $Header: /devl/xcs/repo/env/Databases/CAEInterfaces/verunilibs/s/STARTUP_VIRTEX.v,v 1.9 2003/01/21 01:55:44 wloo Exp $
/*

FUNCTION	: Special Function Cell, STARTUP_VIRTEX

*/

`timescale  100 ps / 10 ps


module STARTUP_VIRTEX (CLK, GSR, GTS);

    input  CLK, GSR, GTS;

    tri0 GSR, GTS;

	assign glbl.GSR = GSR;
	assign glbl.GTS = GTS;

endmodule

