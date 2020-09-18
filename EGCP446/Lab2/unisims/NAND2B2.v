// $Header: /devl/xcs/repo/env/Databases/CAEInterfaces/verunilibs/s/NAND2B2.v,v 1.8 2003/01/21 01:55:29 wloo Exp $

/*

FUNCTION	: 2-INPUT NAND GATE

*/

`timescale  100 ps / 10 ps


module NAND2B2 (O, I0, I1);

    output O;

    input  I0, I1;

    not N1 (i1_inv, I1);
    not N0 (i0_inv, I0);
    nand A1 (O, i0_inv, i1_inv);

    specify
	(I0 *> O) = (0, 0);
	(I1 *> O) = (0, 0);
    endspecify

endmodule

