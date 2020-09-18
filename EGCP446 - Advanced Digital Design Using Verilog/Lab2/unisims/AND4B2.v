// $Header: /devl/xcs/repo/env/Databases/CAEInterfaces/verunilibs/s/AND4B2.v,v 1.8 2003/01/21 01:55:22 wloo Exp $

/*

FUNCTION	: 4-INPUT AND GATE

*/

`timescale  100 ps / 10 ps


module AND4B2 (O, I0, I1, I2, I3);

    output O;

    input  I0, I1, I2, I3;

    not N1 (i1_inv, I1);
    not N0 (i0_inv, I0);
    and A1 (O, i0_inv, i1_inv, I2, I3);

    specify
	(I0 *> O) = (0, 0);
	(I1 *> O) = (0, 0);
	(I2 *> O) = (0, 0);
	(I3 *> O) = (0, 0);
    endspecify

endmodule

