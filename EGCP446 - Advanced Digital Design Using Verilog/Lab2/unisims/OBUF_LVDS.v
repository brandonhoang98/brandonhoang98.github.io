// $Header: /devl/xcs/repo/env/Databases/CAEInterfaces/verunilibs/s/OBUF_LVDS.v,v 1.9 2003/01/21 01:55:38 wloo Exp $

/*

FUNCTION	: OUTPUT BUFFER

*/

`timescale  100 ps / 10 ps


module OBUF_LVDS (O, I);

    output O;

    input  I;

    tri0 GTS = glbl.GTS;

    bufif0 B1 (O, I, GTS);

    specify
	(I *> O) = (0, 0);
    endspecify

endmodule

