// $Header: /devl/xcs/repo/env/Databases/CAEInterfaces/verunilibs/s/LDPE_1.v,v 1.9 2003/01/21 01:55:29 wloo Exp $

/*

FUNCTION	: D-LATCH with async preset and gate enable

*/

`timescale  100 ps / 10 ps


module LDPE_1 (Q, D, G, GE, PRE);

    parameter INIT = 1'b1;

    output Q;
    reg    q_out;

    input  D, G, GE, PRE;

    tri0 GSR = glbl.GSR;

    buf B1 (Q, q_out);

	always @(GSR or PRE or D or G or GE)
	    if (GSR)
		q_out <= INIT;
	    else if (PRE)
		q_out <= 1;
	    else if (!G && GE)
		q_out <= D;

    specify
	if (!PRE && !G && GE)
	    (D +=> Q) = (0, 0);
	if (!PRE && GE)
	    (negedge G => (Q +: D)) = (0, 0);
	if (!PRE && !G)
	    (posedge GE => (Q +: D)) = (0, 0);
	(posedge PRE => (Q +: 1'b1)) = (0, 0);
    endspecify

endmodule

