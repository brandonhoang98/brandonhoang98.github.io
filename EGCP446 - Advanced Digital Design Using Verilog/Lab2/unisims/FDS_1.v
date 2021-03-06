// $Header: /devl/xcs/repo/env/Databases/CAEInterfaces/verunilibs/s/FDS_1.v,v 1.8 2003/01/21 01:55:23 wloo Exp $

/*

FUNCTION	: D-FLIP-FLOP with sync set

*/

`timescale  100 ps / 10 ps


module FDS_1 (Q, C, D, S);

    parameter INIT = 1'b1;

    output Q;
    reg    q_out;

    input  C, D, S;

    tri0 GSR = glbl.GSR;

    buf B1 (Q, q_out);

	always @(GSR)
	    if (GSR)
		assign q_out = INIT;
	    else
		deassign q_out;

	always @(negedge C)
	    if (S)
		q_out <= 1;
	    else
		q_out <= D;

    specify
	if (S)
	    (negedge C => (Q +: 1'b1)) = (0, 0);
	if (!S)
	    (negedge C => (Q +: D)) = (0, 0);
    endspecify

endmodule

