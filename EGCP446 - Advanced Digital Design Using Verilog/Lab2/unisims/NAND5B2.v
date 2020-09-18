// $Header: /devl/xcs/repo/env/Databases/CAEInterfaces/verunilibs/s/NAND5B2.v,v 1.8 2003/01/21 01:55:29 wloo Exp $

/*

FUNCTION	: 5-INPUT NAND GATE

*/

`timescale  100 ps / 10 ps


module NAND5B2 (O, I0, I1, I2, I3, I4);

    output O;

    input  I0, I1, I2, I3, I4;

    not N1 (i1_inv, I1);
    not N0 (i0_inv, I0);
    nand A1 (O, i0_inv, i1_inv, I2, I3, I4);

    specify
	(I0 *> O) = (0, 0);
	(I1 *> O) = (0, 0);
	(I2 *> O) = (0, 0);
	(I3 *> O) = (0, 0);
	(I4 *> O) = (0, 0);
    endspecify

endmodule

