// $Header: /devl/xcs/repo/env/Databases/CAEInterfaces/verunilibs/s/IBUFG.v,v 1.10 2003/05/06 02:52:34 wloo Exp $

/*

FUNCTION	: INPUT BUFFER

*/

`timescale  100 ps / 10 ps


module IBUFG (O, I);

    parameter CAPACITANCE = "DONT_CARE";
    parameter IOSTANDARD = "LVCMOS25";

    output O;
    input  I;

	buf B1 (O, I);

endmodule
