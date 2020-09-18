
/*

FUNCTION	: 3-INPUT AND GATE

*/

`timescale  100 ps / 10 ps

`celldefine

module AND3 (O, I0, I1, I2);


    output O;

    input  I0, I1, I2;

    and A1 (O, I0, I1, I2);

    specify
	(I0 *> O) = (0, 0);
	(I1 *> O) = (0, 0);
	(I2 *> O) = (0, 0);
    endspecify

endmodule

`endcelldefine
