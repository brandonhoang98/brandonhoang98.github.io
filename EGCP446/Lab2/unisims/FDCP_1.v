// $Header: /devl/xcs/repo/env/Databases/CAEInterfaces/verunilibs/s/FDCP_1.v,v 1.9 2003/01/21 01:55:23 wloo Exp $

/*

FUNCTION	: D-FLIP-FLOP with async clear, async preset

*/

`timescale  100 ps / 10 ps


module FDCP_1 (Q, C, CLR, D, PRE);

    parameter INIT = 1'b0;

    output Q;
    reg    q_out;

    input  C, CLR, D, PRE;

    tri0 GSR = glbl.GSR;

    buf B1 (Q, q_out);

	always @(GSR or CLR or PRE)
	    if (GSR)
		assign q_out = INIT;
	    else if (CLR)
		assign q_out = 0;
	    else if (PRE)
		assign q_out = 1;
	    else
		deassign q_out;

	always @(negedge C)
	    q_out <= D;

    specify
	(posedge CLR => (Q +: 1'b0)) = (0, 0);
	if (!CLR)
	(posedge PRE => (Q +: 1'b1)) = (0, 0);
	if (!CLR && !PRE)
	    (negedge C => (Q +: D)) = (0, 0);
    endspecify

endmodule

