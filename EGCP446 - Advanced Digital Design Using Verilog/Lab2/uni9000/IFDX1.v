/*

FUNCTION	: Input D-FLIP-FLOP with clock enable

*/

`timescale  100 ps / 10 ps

`celldefine

module IFDX1(Q, C, CE, D);


    output Q;
    reg    q_out;

    input  C, CE, D;

    tri0 PRLD = glbl.PRLD;

    buf B1 (Q, q_out);

	always @(PRLD)
	    if (PRLD)
		assign q_out = 0;
	    else
		deassign q_out;

	always @(posedge C)
	    if (CE)
		q_out = D;

    specify
	(posedge C => (Q +: D)) = (0, 0);
    endspecify

endmodule

`endcelldefine
