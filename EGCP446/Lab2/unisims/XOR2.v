// $Header: /devl/xcs/repo/env/Databases/CAEInterfaces/verunilibs/s/XOR2.v,v 1.8 2003/01/21 01:55:44 wloo Exp $

/*

FUNCTION	: 2-INPUT XOR GATE

*/

`timescale  100 ps / 10 ps


module XOR2 (O, I0, I1);

    output O;

    input  I0, I1;

	xor X1 (O, I0, I1);

    specify
	(I0 *> O) = (0, 0);
	(I1 *> O) = (0, 0);
    endspecify

endmodule

