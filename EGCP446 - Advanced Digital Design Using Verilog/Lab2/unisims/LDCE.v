// $Header: /devl/xcs/repo/env/Databases/CAEInterfaces/verunilibs/s/LDCE.v,v 1.9 2003/01/21 01:55:28 wloo Exp $

/*

FUNCTION	: D-LATCH with async clear and gate enable

*/

`timescale  100 ps / 10 ps


module LDCE (Q, CLR, D, G, GE);

    parameter INIT = 1'b0;

    output Q;
    reg    q_out;

    input  CLR, D, G, GE;

    tri0 GSR = glbl.GSR;

    buf B1 (Q, q_out);

	always @(GSR or CLR or D or G or GE)
	    if (GSR)
		q_out <= INIT;
	    else if (CLR)
		q_out <= 0;
	    else if (G && GE)
		q_out <= D;

    specify
	if (!CLR && G && GE)
	    (D +=> Q) = (0, 0);
	if (!CLR && GE)
	    (posedge G => (Q +: D)) = (0, 0);
	if (!CLR && G)
	    (posedge GE => (Q +: D)) = (0, 0);
	(posedge CLR => (Q +: 1'b0)) = (0, 0);
    endspecify

endmodule

