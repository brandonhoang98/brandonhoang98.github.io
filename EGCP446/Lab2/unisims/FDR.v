// $Header: /devl/xcs/repo/env/Databases/CAEInterfaces/verunilibs/s/FDR.v,v 1.8 2003/01/21 01:55:23 wloo Exp $

/*

FUNCTION	: D-FLIP-FLOP with sync reset

*/

`timescale  100 ps / 10 ps


module FDR (Q, C, D, R);

    parameter INIT = 1'b0;

    output Q;
    reg    q_out;

    input  C, D, R;

    tri0 GSR = glbl.GSR;

    buf B1 (Q, q_out);

	always @(GSR)
	    if (GSR)
		assign q_out = INIT;
	    else
		deassign q_out;

	always @(posedge C)
	    if (R)
		q_out <= 0;
	    else
		q_out <= D;

    specify
	if (R)
	    (posedge C => (Q +: 1'b0)) = (0, 0);
	if (!R)
	    (posedge C => (Q +: D)) = (0, 0);
    endspecify

endmodule

