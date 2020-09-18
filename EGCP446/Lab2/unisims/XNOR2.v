// $Header: /devl/xcs/repo/env/Databases/CAEInterfaces/verunilibs/s/XNOR2.v,v 1.8 2003/01/21 01:55:44 wloo Exp $

/*

FUNCTION	: 2-INPUT XNOR GATE

*/

`timescale  100 ps / 10 ps


module XNOR2 (O, I0, I1);

    output O;

    input  I0, I1;

	xnor X1 (O, I0, I1);

    specify
	(I0 *> O) = (0, 0);
	(I1 *> O) = (0, 0);
    endspecify

endmodule

