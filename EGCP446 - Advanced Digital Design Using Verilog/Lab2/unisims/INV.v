// $Header: /devl/xcs/repo/env/Databases/CAEInterfaces/verunilibs/s/INV.v,v 1.8 2003/01/21 01:55:25 wloo Exp $

/*

FUNCTION	: INVERTER

*/

`timescale  100 ps / 10 ps


module INV (O, I);

    output O;

    input  I;

	not N1 (O, I);

    specify
	(I *> O) = (0, 0);
    endspecify

endmodule

