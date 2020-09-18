// $Header: /devl/xcs/repo/env/Databases/CAEInterfaces/verunilibs/s/AND5.v,v 1.8 2003/01/21 01:55:22 wloo Exp $

/*

FUNCTION	: 5-INPUT AND GATE

*/

`timescale  100 ps / 10 ps


module AND5 (O, I0, I1, I2, I3, I4);

    output O;

    input  I0, I1, I2, I3, I4;

    and A1 (O, I0, I1, I2, I3, I4);

    specify
	(I0 *> O) = (0, 0);
	(I1 *> O) = (0, 0);
	(I2 *> O) = (0, 0);
	(I3 *> O) = (0, 0);
	(I4 *> O) = (0, 0);
    endspecify

endmodule

