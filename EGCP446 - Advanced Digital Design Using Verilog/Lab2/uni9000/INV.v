
/*

FUNCTION	: INVERTER

*/

`timescale  100 ps / 10 ps

`celldefine

module INV (O, I);


    output O;

    input  I;

	not N1 (O, I);

    specify
	(I *> O) = (0, 0);
    endspecify

endmodule

`endcelldefine
