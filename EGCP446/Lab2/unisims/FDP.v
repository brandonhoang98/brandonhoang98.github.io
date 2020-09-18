// $Header: /devl/xcs/repo/env/Databases/CAEInterfaces/verunilibs/s/FDP.v,v 1.9 2003/01/21 01:55:23 wloo Exp $

/*

FUNCTION	: D-FLIP-FLOP with async preset

*/

`timescale  100 ps / 10 ps


module FDP (Q, C, D, PRE);

    parameter INIT = 1'b1;

    output Q;
    reg    q_out;

    input  C, D, PRE;

    tri0 GSR = glbl.GSR;

    buf B1 (Q, q_out);

	always @(GSR or PRE)
	    if (GSR)
		assign q_out = INIT;
	    else if (PRE)
		assign q_out = 1;
	    else
		deassign q_out;

	always @(posedge C)
	    q_out <= D;

    specify
	(posedge PRE => (Q +: 1'b1)) = (0, 0);
	if (!PRE)
	    (posedge C => (Q +: D)) = (0, 0);
    endspecify

endmodule

