// $Header: /devl/xcs/repo/env/Databases/CAEInterfaces/verunilibs/s/LDCP_1.v,v 1.9 2003/01/21 01:55:28 wloo Exp $

/*

FUNCTION	: D-LATCH with async clear, async preset

*/

`timescale  100 ps / 10 ps


module LDCP_1 (Q, CLR, D, G, PRE);

    parameter INIT = 1'b0;

    output Q;
    reg    q_out;

    input  CLR, D, G, PRE;

    tri0 GSR = glbl.GSR;

    buf B1 (Q, q_out);

	always @(GSR or CLR or PRE or D or G)
	    if (GSR)
		q_out <= INIT;
	    else if (CLR)
		q_out <= 0;
	    else if (PRE)
		q_out <= 1;
	    else if (!G)
		q_out <= D;

    specify
	if (!CLR && !PRE && !G)
	    (D +=> Q) = (0, 0);
	if (!CLR && !PRE)
	    (negedge G => (Q +: D)) = (0, 0);
	if (!CLR)
	    (posedge PRE => (Q +: 1'b1)) = (0, 0);
	(posedge CLR => (Q +: 1'b0)) = (0, 0);
    endspecify

endmodule

