
/*

FUNCTION	: 3-INPUT NAND GATE

*/

`timescale  100 ps / 10 ps

`celldefine

module NAND3B1 (O, I0, I1, I2);


    output O;

    input  I0, I1, I2;

    not N0 (i0_inv, I0);
    nand A1 (O, i0_inv, I1, I2);

    specify
	(I0 *> O) = (0, 0);
	(I1 *> O) = (0, 0);
	(I2 *> O) = (0, 0);
    endspecify

endmodule

`endcelldefine
