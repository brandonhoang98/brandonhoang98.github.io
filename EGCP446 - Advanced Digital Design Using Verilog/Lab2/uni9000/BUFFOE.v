
/*

FUNCTION	: BUFFFOE

*/

`timescale  100 ps / 10 ps

`celldefine

module BUFFOE (O, I);


    output O;

    input  I;

	buf B1 (O, I);

    specify
	(I *> O) = (0, 0);
    endspecify

endmodule

`endcelldefine
