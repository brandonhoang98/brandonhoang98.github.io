// $Header: /devl/xcs/repo/env/Databases/CAEInterfaces/verunilibs/s/NOR3B2.v,v 1.8 2003/01/21 01:55:30 wloo Exp $

/*

FUNCTION	: 3-INPUT NOR GATE

*/

`timescale  100 ps / 10 ps


module NOR3B2 (O, I0, I1, I2);

    output O;

    input  I0, I1, I2;

    not N1 (i1_inv, I1);
    not N0 (i0_inv, I0);
    nor O1 (O, i0_inv, i1_inv, I2);

    specify
	(I0 *> O) = (0, 0);
	(I1 *> O) = (0, 0);
	(I2 *> O) = (0, 0);
    endspecify

endmodule
