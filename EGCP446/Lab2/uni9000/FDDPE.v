// $Header: $

/*

FUNCTION	: Dual edge triggered D-FLIP-FLOP with async preset and clock enable

*/

`timescale  100 ps / 10 ps

module FDDPE (Q, C, CE, D, PRE);

    output Q;
    reg    q_out;

    input  C, CE, D, PRE;

    tri0 PRLD = glbl.PRLD;

    buf B1 (Q, q_out);

	always @(PRLD or PRE)
	    if (PRLD || PRE)
		assign q_out = 1;
	    else
		deassign q_out;

	always @(posedge C or negedge C)
	    if (CE)
		q_out = D;

    specify
	(posedge PRE => (Q +: 1'b1)) = (0, 0);
	if (!PRE && CE)
	    (posedge C => (Q +: D)) = (0, 0);
	if (!PRE && CE)
	    (negedge C => (Q +: D)) = (0, 0);
    endspecify

endmodule

