
/*

FUNCTION	: TRI-STATE OUTPUT BUFFER

*/

`timescale  100 ps / 10 ps

`celldefine

module OBUFEX1 (O, E, I);


    output O;

    input  I, E;

    reg O;

    always @(I or E)
	if (E === 1'b0)
	    O = 1'bz;
	else
	   if (I === 1'bz)
		O = 1'bz;
	   else
		O = I;

    specify
    endspecify

endmodule

`endcelldefine
