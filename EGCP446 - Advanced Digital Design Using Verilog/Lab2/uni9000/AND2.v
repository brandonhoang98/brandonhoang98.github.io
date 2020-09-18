
/*

FUNCTION	: 2-INPUT AND GATE

*/

`timescale  100 ps / 10 ps

`celldefine

module AND2 (O, I0, I1);


    output O;

    input  I0, I1;

    and A1 (O, I0, I1);

    specify
	(I0 *> O) = (0, 0);
	(I1 *> O) = (0, 0);
    endspecify

endmodule

`endcelldefine
