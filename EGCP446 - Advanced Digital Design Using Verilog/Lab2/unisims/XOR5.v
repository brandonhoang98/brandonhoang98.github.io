// $Header: /devl/xcs/repo/env/Databases/CAEInterfaces/verunilibs/s/XOR5.v,v 1.8 2003/01/21 01:55:44 wloo Exp $

/*

FUNCTION	: 5-INPUT XOR GATE

*/

`timescale  100 ps / 10 ps


module XOR5 (O, I0, I1, I2, I3, I4);

    output O;

    input  I0, I1, I2, I3, I4;

	xor X1 (O, I0, I1, I2, I3, I4);

    specify
	(I0 *> O) = (0, 0);
	(I1 *> O) = (0, 0);
	(I2 *> O) = (0, 0);
	(I3 *> O) = (0, 0);
	(I4 *> O) = (0, 0);
    endspecify

endmodule

