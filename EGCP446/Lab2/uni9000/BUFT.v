
/*

FUNCTION	: TRI-STATE BUFFER

*/

`timescale  100 ps / 10 ps

`celldefine

module BUFT (O, I, T);


    output O;

    input  I, T;

	bufif0 T1 (O, I, T);

    specify
	(I *> O) = (0, 0);
	(T *> O) = (0, 0);
    endspecify

endmodule

`endcelldefine
