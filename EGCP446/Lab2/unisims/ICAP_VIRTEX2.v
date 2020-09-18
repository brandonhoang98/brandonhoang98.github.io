// $Header: /devl/xcs/repo/env/Databases/CAEInterfaces/verunilibs/s/ICAP_VIRTEX2.v,v 1.9 2003/01/21 01:55:25 wloo Exp $
/*

FUNCTION	: Special Function Cell, ICAP_VIRTEX2

*/

`timescale  100 ps / 10 ps


module ICAP_VIRTEX2 (BUSY, O, CE, CLK, I, WRITE);

    output BUSY;
    output [7:0] O;
    input  CE, CLK, WRITE;
    input  [7:0] I;

endmodule

