// $Header: /devl/xcs/repo/env/Databases/CAEInterfaces/verunilibs/s/FDE_1.v,v 1.8 2003/01/21 01:55:23 wloo Exp $

/*

FUNCTION	: D-FLIP-FLOP with clock enable

*/

`timescale  100 ps / 10 ps


module FDE_1 (Q, C, CE, D);

    parameter INIT = 1'b0;

    output Q;
    reg    q_out;

    input  C, CE, D;

    tri0 GSR = glbl.GSR;

    buf B1 (Q, q_out);

	always @(GSR)
	    if (GSR)
		assign q_out = INIT;
	    else
		deassign q_out;

	always @(negedge C)
	    if (CE)
		q_out <= D;

    specify
	if (CE)
	    (negedge C => (Q +: D)) = (0, 0);
    endspecify

endmodule

