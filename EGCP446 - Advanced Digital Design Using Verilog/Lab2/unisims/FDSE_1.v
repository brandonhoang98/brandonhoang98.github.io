// $Header: /devl/xcs/repo/env/Databases/CAEInterfaces/verunilibs/s/FDSE_1.v,v 1.8 2003/01/21 01:55:23 wloo Exp $

/*

FUNCTION	: D-FLIP-FLOP with sync set and clock enable

*/

`timescale  100 ps / 10 ps


module FDSE_1 (Q, C, CE, D, S);

    parameter INIT = 1'b1;

    output Q;
    reg    q_out;

    input  C, CE, D, S;

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
	    else if (CE)
		q_out <= D;

    specify
	if (S)
	    (negedge C => (Q +: 1'b1)) = (0, 0);
	if (!S && CE)
	    (negedge C => (Q +: D)) = (0, 0);
    endspecify

endmodule

