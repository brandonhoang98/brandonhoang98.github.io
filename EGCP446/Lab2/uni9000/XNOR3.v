
/*

FUNCTION	: 3-INPUT XNOR GATE

*/

`timescale  100 ps / 10 ps

`celldefine

module XNOR3 (O, I0, I1, I2);


    output O;

    input  I0, I1, I2;

	xnor X1 (O, I0, I1, I2);

    specify
	(I0 *> O) = (0, 0);
	(I1 *> O) = (0, 0);
	(I2 *> O) = (0, 0);
    endspecify

endmodule

`endcelldefine
