// $Header: $

/*

FUNCTION	: Dual edge triggered D-FLIP-FLOP

*/

`timescale  100 ps / 10 ps

module FDD (Q, C, D);

    parameter INIT = 1'b0;

    output Q;
    reg    q_out;

    input  C, D;

    tri0 PRLD = glbl.PRLD;

    buf B1 (Q, q_out);

	always @(PRLD)
	    if (PRLD)
		assign q_out = INIT;
	    else
		deassign q_out;

	always @(posedge C or negedge C)
	    q_out <= D;

    specify
	(posedge C => (Q +: D)) = (0, 0);
	(negedge C => (Q +: D)) = (0, 0); 
    endspecify

endmodule

