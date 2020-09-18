
/*

FUNCTION	: 2-INPUT NOR GATE

*/

`timescale  100 ps / 10 ps

`celldefine

module NOR2 (O, I0, I1);


    output O;

    input  I0, I1;

    nor O1 (O, I0, I1);

    specify
	(I0 *> O) = (0, 0);
	(I1 *> O) = (0, 0);
    endspecify

endmodule

`endcelldefine
