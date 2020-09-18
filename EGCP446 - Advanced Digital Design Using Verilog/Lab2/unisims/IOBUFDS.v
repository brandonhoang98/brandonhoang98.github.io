// $Header: /devl/xcs/repo/env/Databases/CAEInterfaces/verunilibs/s/IOBUFDS.v,v 1.11 2003/06/17 01:56:16 wloo Exp $

/*

FUNCTION	: INPUT TRI-STATE OUTPUT BUFFER

*/

`timescale  100 ps / 10 ps


module IOBUFDS (O, IO, IOB, I, T);

    parameter CAPACITANCE = "DONT_CARE";
    parameter DRIVE = 12;
    parameter IOSTANDARD = "LVDS_25";
    parameter SLEW = "SLOW";

    output O;
    inout  IO, IOB;
    input  I, T;

    tri0 GTS = glbl.GTS;

    or O1 (ts, GTS, T);
    bufif0 B1 (IO, I, ts);
    notif0 N1 (IOB, I, ts);

    buf B2 (O, IO);

endmodule


