// $Header: $

/*

FUNCTION	: Dual edge triggered D-FLIP-FLOP with async clear

*/

`timescale  100 ps / 10 ps

module FDDC (Q, C, CLR, D);

    parameter INIT = 1'b0;

    output Q;
    reg    q_out;

    input  C, CLR, D;

    tri0 PRLD = glbl.PRLD;

    buf B1 (Q, q_out);

	always @(PRLD or CLR)
	    if (PRLD)
		assign q_out = INIT;
	    else if (CLR)
		assign q_out = 0;
	    else
		deassign q_out;

	always @(posedge C or negedge C)
	    q_out <= D;

    specify
	(posedge CLR => (Q +: 1'b0)) = (0, 0);
	if (!CLR)
	    (posedge C => (Q +: D)) = (0, 0);
	if (!CLR)
	    (negedge C => (Q +: D)) = (0, 0);
    endspecify

endmodule

