
/*

FUNCTION	: 5-INPUT NOR GATE

*/

`timescale  100 ps / 10 ps

`celldefine

module NOR5 (O, I0, I1, I2, I3, I4);


    output O;

    input  I0, I1, I2, I3, I4;

    nor O1 (O, I0, I1, I2, I3, I4);

    specify
	(I0 *> O) = (0, 0);
	(I1 *> O) = (0, 0);
	(I2 *> O) = (0, 0);
	(I3 *> O) = (0, 0);
	(I4 *> O) = (0, 0);
    endspecify

endmodule

`endcelldefine
