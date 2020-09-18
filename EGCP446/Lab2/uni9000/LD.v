
/*

FUNCTION	: D-LATCH

*/

`timescale  100 ps / 10 ps

`celldefine

module LD (Q, D, G);


    output Q;
    reg    q_out;

    input  D, G;

    tri0 PRLD = glbl.PRLD;

    buf B1 (Q, q_out);

	always @(PRLD or D or G)
	    if (PRLD)
		q_out = 0;
	    else if (G)
		q_out = D;

    specify
	if (G)
	    (D +=> Q) = (0, 0);
	(posedge G => (Q +: D)) = (0, 0);
    endspecify

endmodule

`endcelldefine
