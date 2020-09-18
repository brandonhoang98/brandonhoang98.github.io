// $Header: /devl/xcs/repo/env/Databases/CAEInterfaces/verunilibs/s/FDDRRSE.v,v 1.10 2003/01/21 01:55:23 wloo Exp $

/*

FUNCTION	: Dual Data Rate MUX

*/

`timescale  100 ps / 10 ps


module FDDRRSE (Q, C0, C1, CE, D0, D1, R, S);

    parameter INIT = 1'h0;

    output Q;
    reg    q_out;

    input  C0, C1, CE, D0, D1, R, S;

    tri0 GSR = glbl.GSR;

    buf B1 (Q, q_out);

	always @(GSR)
	    if (GSR)
		assign q_out = INIT;
	    else
		deassign q_out;

	always @(posedge C0)
	    if (R)
		q_out <= 0;
	    else if (S)
		q_out <= 1;
	    else if (CE)
		q_out <= D0;

	always @(posedge C1)
	    if (R)
		q_out <= 0;
	    else if (S)
		q_out <= 1;
	    else if (CE)
		q_out <= D1;

    specify
	if (R)
	    (posedge C0 => (Q +: 1'b0)) = (0, 0);
	if (!R && S)
	    (posedge C0 => (Q +: 1'b1)) = (0, 0);
	if (!R && !S && CE)
	    (posedge C0 => (Q +: D0)) = (0, 0);
	if (R)
	    (posedge C1 => (Q +: 1'b0)) = (0, 0);
	if (!R && S)
	    (posedge C1 => (Q +: 1'b1)) = (0, 0);
	if (!R && !S && CE)
	    (posedge C1 => (Q +: D1)) = (0, 0);
    endspecify

endmodule

