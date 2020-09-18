
/*

FUNCTION	: 4-INPUT NAND GATE

*/

`timescale  100 ps / 10 ps

`celldefine

module NAND4 (O, I0, I1, I2, I3);


    output O;

    input  I0, I1, I2, I3;

    nand A1 (O, I0, I1, I2, I3);

    specify
	(I0 *> O) = (0, 0);
	(I1 *> O) = (0, 0);
	(I2 *> O) = (0, 0);
	(I3 *> O) = (0, 0);
    endspecify

endmodule

`endcelldefine
