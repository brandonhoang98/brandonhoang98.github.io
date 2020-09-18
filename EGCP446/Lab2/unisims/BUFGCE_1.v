
/*

FUNCTION	: Global Clock Mux Buffer

*/

`timescale  100 ps / 10 ps

module BUFGCE_1 (O, CE, I);

    output O;

    input  CE, I;

    wire   NCE;

    BUFGMUX_1 B1 (.I0(I),
	.I1(1'b1),
	.O(O),
	.S(NCE));

    INV I1 (.I(CE),
	.O(NCE));

endmodule
