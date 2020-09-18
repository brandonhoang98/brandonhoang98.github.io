// $Header: /devl/xcs/repo/env/Databases/CAEInterfaces/verunilibs/s/IBUF_LVPECL.v,v 1.9 2003/01/21 01:55:25 wloo Exp $

/*

FUNCTION	: INPUT BUFFER

*/

`timescale  100 ps / 10 ps


module IBUF_LVPECL (O, I);

    output O;

    input  I;

	buf B1 (O, I);

    specify
	(I *> O) = (0, 0);
    endspecify

endmodule

