// $Header: /devl/xcs/repo/env/Databases/CAEInterfaces/verunilibs/s/OBUF_SSTL18_I.v,v 1.2 2003/01/21 01:55:39 wloo Exp $

/*

FUNCTION	: OUTPUT BUFFER

*/

`timescale  100 ps / 10 ps


module OBUF_SSTL18_I (O, I);

    output O;

    input  I;

    tri0 GTS = glbl.GTS;

    bufif0 B1 (O, I, GTS);

    specify
	(I *> O) = (0, 0);
    endspecify

endmodule

