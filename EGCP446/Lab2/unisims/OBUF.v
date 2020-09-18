// $Header: /devl/xcs/repo/env/Databases/CAEInterfaces/verunilibs/s/OBUF.v,v 1.12 2003/06/17 01:56:16 wloo Exp $

/*

FUNCTION	: OUTPUT BUFFER

*/

`timescale  100 ps / 10 ps


module OBUF (O, I);

    parameter CAPACITANCE = "DONT_CARE";
    parameter DRIVE = 12;
    parameter IOSTANDARD = "LVCMOS25";
    parameter SLEW = "SLOW";
   
    output O;

    input  I;

    tri0 GTS = glbl.GTS;

    bufif0 B1 (O, I, GTS);

endmodule

