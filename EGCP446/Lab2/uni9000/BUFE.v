
/*

FUNCTION	: TRI-STATE BUFFER

*/

`timescale  100 ps / 10 ps

`celldefine

module BUFE (O, I, E);


    output O;

    input  I, E;

	bufif1 T1 (O, I, E);

    specify
	(I *> O) = (0, 0);
	(E *> O) = (0, 0);
    endspecify

endmodule

`endcelldefine
