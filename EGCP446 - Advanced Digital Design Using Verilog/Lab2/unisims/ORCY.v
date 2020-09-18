// $Header: /devl/xcs/repo/env/Databases/CAEInterfaces/verunilibs/s/ORCY.v,v 1.8 2003/01/21 01:55:40 wloo Exp $

/*

FUNCTION	: OR for carry logic

*/

`timescale  100 ps / 10 ps


module ORCY (O, CI, I);

    output O;

    input  CI, I;

	or X1 (O, CI, I);

    specify
	(CI *> O) = (0, 0);
	(I *> O) = (0, 0);
    endspecify

endmodule

