
/*

FUNCTION	: TRI-STATE OUTPUT BUFFER

*/

`timescale  100 ps / 10 ps

`celldefine

module OBUFE_S (O, E, I);


    output O;

    input  E, I;

	bufif1 T1 (O, I, E);

    specify
	(I *> O) = (0, 0);
	(E *> O) = (0, 0);
    endspecify

endmodule

`endcelldefine
