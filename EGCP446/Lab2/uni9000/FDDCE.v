// $Header: $

/*

FUNCTION	: Dual edge triggered D-FLIP-FLOP with async clear and clock enable

*/

`timescale  100 ps / 10 ps

module FDDCE (Q, C, CE, CLR, D);


    output Q;
    reg    q_out;

    input  C, CE, CLR, D;

    tri0 PRLD = glbl.PRLD;

    buf B1 (Q, q_out);

	always @(PRLD or CLR)
	    if (PRLD || CLR)
		assign q_out = 0;
	    else
		deassign q_out;

	always @(posedge C or negedge C)
	    if (CE)
		q_out = D;

    specify
	(posedge CLR => (Q +: 1'b0)) = (0, 0);
	if (!CLR && CE)
	    (posedge C => (Q +: D)) = (0, 0);
	if (!CLR && CE)
	    (negedge C => (Q +: D)) = (0, 0);
    endspecify

endmodule
