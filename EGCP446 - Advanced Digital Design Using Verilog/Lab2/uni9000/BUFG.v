
/*

FUNCTION	: BUFFER

*/

`timescale  100 ps / 10 ps

`celldefine

module BUFG (O, I);


    output O;

    input  I;

	buf B1 (O, I);

    specify
	(I *> O) = (0, 0);
    endspecify

endmodule

`endcelldefine
