// $Header: /devl/xcs/repo/env/Databases/CAEInterfaces/verunilibs/s/OBUFDS.v,v 1.12 2003/06/17 01:56:16 wloo Exp $

/*

FUNCTION	: OUTPUT BUFFER

*/

`timescale  100 ps / 10 ps


module OBUFDS (O, OB, I);

    parameter CAPACITANCE = "DONT_CARE";
    parameter DRIVE = 12;
    parameter IOSTANDARD = "LVDS_25";
    parameter SLEW = "SLOW";
   
    output O, OB;
    input  I;

    tri0 GTS = glbl.GTS;

    bufif0 B1 (O, I, GTS);
    notif0 N1 (OB, I, GTS);

endmodule


