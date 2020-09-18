// $Header: /devl/xcs/repo/env/Databases/CAEInterfaces/verunilibs/s/LD_1.v,v 1.8 2003/01/21 01:55:29 wloo Exp $

/*

FUNCTION	: D-LATCH

*/

`timescale  100 ps / 10 ps


module LD_1 (Q, D, G);

    parameter INIT = 1'b0;

    output Q;
    reg    q_out;

    input  D, G;

    tri0 GSR = glbl.GSR;

    buf B1 (Q, q_out);

	always @(GSR or D or G)
	    if (GSR)
		q_out <= INIT;
	    else if (!G)
		q_out <= D;

    specify
	if (!G)
	    (D +=> Q) = (0, 0);
	(negedge G => (Q +: D)) = (0, 0);
    endspecify

endmodule

