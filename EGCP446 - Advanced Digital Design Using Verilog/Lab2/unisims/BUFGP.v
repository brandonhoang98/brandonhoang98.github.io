// $Header: /devl/xcs/repo/env/Databases/CAEInterfaces/verunilibs/s/BUFGP.v,v 1.8 2003/01/21 01:55:23 wloo Exp $

/*

FUNCTION	: BUFFER

*/

`timescale  100 ps / 10 ps


module BUFGP (O, I);

    output O;

    input  I;

	buf B1 (O, I);

    specify
	(I *> O) = (0, 0);
    endspecify

endmodule

