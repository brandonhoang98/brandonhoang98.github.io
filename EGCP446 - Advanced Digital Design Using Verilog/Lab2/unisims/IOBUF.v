// $Header: /devl/xcs/repo/env/Databases/CAEInterfaces/verunilibs/s/IOBUF.v,v 1.11 2003/06/17 01:56:16 wloo Exp $

/*

FUNCTION	: INPUT TRI-STATE OUTPUT BUFFER

*/

`timescale  100 ps / 10 ps


module IOBUF (O, IO, I, T);

    parameter CAPACITANCE = "DONT_CARE";
    parameter DRIVE = 12;
    parameter IOSTANDARD = "LVCMOS25";
    parameter SLEW = "SLOW";

    output O;
    inout  IO;
    input  I, T;

    tri0 GTS = glbl.GTS;

    or O1 (ts, GTS, T);
    bufif0 T1 (IO, I, ts);

    buf B1 (O, IO);

endmodule

