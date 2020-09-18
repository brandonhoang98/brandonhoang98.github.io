// $Header: /devl/xcs/repo/env/Databases/CAEInterfaces/verunilibs/s/OR4.v,v 1.8 2003/01/21 01:55:40 wloo Exp $

/*

FUNCTION	: 4-INPUT OR GATE

*/

`timescale  100 ps / 10 ps


module OR4 (O, I0, I1, I2, I3);

    output O;

    input  I0, I1, I2, I3;

    or O1 (O, I0, I1, I2, I3);

    specify
	(I0 *> O) = (0, 0);
	(I1 *> O) = (0, 0);
	(I2 *> O) = (0, 0);
	(I3 *> O) = (0, 0);
    endspecify

endmodule

