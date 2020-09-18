// $Header: /devl/xcs/repo/env/Databases/CAEInterfaces/verunilibs/s/IBUF_GTLP.v,v 1.8 2003/01/21 01:55:25 wloo Exp $

/*

FUNCTION	: INPUT BUFFER

*/

`timescale  100 ps / 10 ps


module IBUF_GTLP (O, I);

    output O;

    input  I;

	buf B1 (O, I);

    specify
	(I *> O) = (0, 0);
    endspecify

endmodule

