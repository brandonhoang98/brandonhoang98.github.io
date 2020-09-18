
/*

FUNCTION	: 7-INPUT NAND GATE

*/

`timescale  100 ps / 10 ps

`celldefine

module NAND7 (O, I0, I1, I2, I3, I4, I5, I6);


    output O;

    input  I0, I1, I2, I3, I4, I5, I6;

    nand A1 (O, I0, I1, I2, I3, I4, I5, I6);

    specify
	(I0 *> O) = (0, 0);
	(I1 *> O) = (0, 0);
	(I2 *> O) = (0, 0);
	(I3 *> O) = (0, 0);
	(I4 *> O) = (0, 0);
	(I5 *> O) = (0, 0);
	(I6 *> O) = (0, 0);
    endspecify

endmodule

`endcelldefine
