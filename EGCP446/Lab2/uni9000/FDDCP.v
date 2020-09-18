// $Header: $

/*

FUNCTION	: Dual edge triggered D-FLIP-FLOP with async clear, async preset

*/

`timescale  100 ps / 10 ps

module FDDCP (Q, C, CLR, D, PRE);

    parameter INIT = 1'b0;

    output Q;
    reg    q_out;

    input  C, CLR, D, PRE;

    tri0 PRLD = glbl.PRLD;

    buf B1 (Q, q_out);

	always @(PRLD or CLR or PRE)
	    if (PRLD)
		assign q_out = INIT;
	    else if (CLR)
		assign q_out = 0;
	    else if (PRE)
		assign q_out = 1;
	    else
		deassign q_out;

	always @(posedge C or negedge C)
	    q_out <= D;

    specify
	(posedge CLR => (Q +: 1'b0)) = (0, 0);
	if (!CLR)
	(posedge PRE => (Q +: 1'b1)) = (0, 0);
	if (!CLR)
	(negedge PRE => (Q +: 1'b1)) = (0, 0);
	if (!CLR && !PRE)
	(posedge C => (Q +: D)) = (0, 0);
	if (!CLR && !PRE)
        (negedge C => (Q +: D)) = (0, 0);
    endspecify

endmodule

