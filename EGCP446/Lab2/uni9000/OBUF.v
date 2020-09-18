
/*

FUNCTION	: OUTPUT BUFFER

*/

`timescale  100 ps / 10 ps

`celldefine

module OBUF (O, I);


    output O;
    reg    O;

    input  I;

    always @(I)
	if (I === 1'bz)
	   #1 O = 1'bz;
	else
	   #1 O = I;

    specify
    endspecify

endmodule

`endcelldefine
