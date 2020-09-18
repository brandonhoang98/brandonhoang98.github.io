
/*

FUNCTION	: T-FLIP-FLOP with async clear

*/

`timescale  100 ps / 10 ps

`celldefine

module FTC (Q, C, CLR, T);


    output Q;
    reg    q_out;

    input  C, CLR, T;

    tri0 PRLD = glbl.PRLD;

    buf B1 (Q, q_out);

	always @(PRLD or CLR)
	    if (PRLD || CLR)
		assign q_out = 0;
	    else
		deassign q_out;

	always @(posedge C)
	    if (T)
		q_out = ~q_out;

    specify
	(posedge C => (Q -: Q)) = (0, 0);
	(posedge CLR => (Q +: 1'b0)) = (0, 0);
    endspecify

endmodule

`endcelldefine
