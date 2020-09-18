// $Header: $

/*

FUNCTION	: Dual edge triggered D-FLIP-FLOP with async preset

*/

`timescale  100 ps / 10 ps

module FDDP (Q, C, D, PRE);

    parameter INIT = 1'b1;

    output Q;
    reg    q_out;

    input  C, D, PRE;

    tri0 PRLD = glbl.PRLD;

    buf B1 (Q, q_out);

	always @(PRLD or PRE)
	    if (PRLD)
		assign q_out = INIT;
	    else if (PRE)
		assign q_out = 1;
	    else
		deassign q_out;

	always @(posedge C or negedge C)
	    q_out <= D;

    specify
	(posedge PRE => (Q +: 1'b1)) = (0, 0);
	if (!PRE)
	    (posedge C => (Q +: D)) = (0, 0);
	if (!PRE)
	    (negedge C => (Q +: D)) = (0, 0);
    endspecify

endmodule
