// $Header: /devl/xcs/repo/env/Databases/CAEInterfaces/verunilibs/s/OBUFTDS.v,v 1.12 2003/06/17 01:56:16 wloo Exp $

/*

FUNCTION	: TRI-STATE OUTPUT BUFFER

*/

`timescale  100 ps / 10 ps

module OBUFTDS (O, OB, I, T);

    parameter CAPACITANCE = "DONT_CARE";
    parameter DRIVE = 12;
    parameter IOSTANDARD = "LVDS_25";
    parameter SLEW = "SLOW";
   
    output O, OB;
    input  I, T;

    tri0 GTS = glbl.GTS;

    or O1 (ts, GTS, T);
    bufif0 B1 (O, I, ts);
    notif0 N1 (OB, I, ts);

endmodule


