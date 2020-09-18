// $Header: /devl/xcs/repo/env/Databases/CAEInterfaces/verunilibs/s/LDE_1.v,v 1.8 2003/01/21 01:55:29 wloo Exp $

/*

FUNCTION	: D-LATCH with gate enable

*/

`timescale  100 ps / 10 ps


module LDE_1 (Q, D, G, GE);

    parameter INIT = 1'b0;

    output Q;
    reg    q_out;

    input  D, G, GE;

    tri0 GSR = glbl.GSR;

    buf B1 (Q, q_out);

	always @(GSR or D or G or GE)
	    if (GSR)
		q_out <= INIT;
	    else if (!G && GE)
		q_out <= D;

    specify
	if (!G && GE)
	    (D +=> Q) = (0, 0);
	if (GE)
	    (negedge G => (Q +: D)) = (0, 0);
	if (!G)
	    (posedge GE => (Q +: D)) = (0, 0);
    endspecify

endmodule

