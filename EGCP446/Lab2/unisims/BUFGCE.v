
/*

FUNCTION	: Global Clock Mux Buffer

*/

`timescale  100 ps / 10 ps

module BUFGCE (O, CE, I);

    output O;

    input  CE, I;

    wire   NCE;

    BUFGMUX B1 (.I0(I),
	.I1(1'b0),
	.O(O),
	.S(NCE));

    INV I1 (.I(CE),
	.O(NCE));

endmodule
