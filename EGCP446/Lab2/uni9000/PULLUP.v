
/*

FUNCTION	: pullup cell

*/

`timescale  100 ps / 10 ps

`celldefine

module PULLUP (O);


    output O;
	pullup (A);
	buf (pull0,pull1) #(1,1) (O,A);

endmodule

`endcelldefine
