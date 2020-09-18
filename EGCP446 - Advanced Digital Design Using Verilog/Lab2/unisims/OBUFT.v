// $Header: /devl/xcs/repo/env/Databases/CAEInterfaces/verunilibs/s/OBUFT.v,v 1.12 2003/06/17 01:56:16 wloo Exp $

/*

FUNCTION	: TRI-STATE OUTPUT BUFFER

*/

`timescale  100 ps / 10 ps


module OBUFT (O, I, T);

    parameter CAPACITANCE = "DONT_CARE";
    parameter DRIVE = 12;
    parameter IOSTANDARD = "LVCMOS25";
    parameter SLEW = "SLOW";
   
    output O;
    input  I, T;

    tri0 GTS = glbl.GTS;

    or O1 (ts, GTS, T);
    bufif0 T1 (O, I, ts);

endmodule

