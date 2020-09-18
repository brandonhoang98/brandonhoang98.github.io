// $Header: /devl/xcs/repo/env/Databases/CAEInterfaces/verunilibs/s/AND2B1.v,v 1.8 2003/01/21 01:55:22 wloo Exp $

/*

FUNCTION	: 2-INPUT AND GATE

*/

`timescale  100 ps / 10 ps


module AND2B1 (O, I0, I1);

    output O;

    input  I0, I1;

    not N0 (i0_inv, I0);
    and A1 (O, i0_inv, I1);

    specify
	(I0 *> O) = (0, 0);
	(I1 *> O) = (0, 0);
    endspecify

endmodule

