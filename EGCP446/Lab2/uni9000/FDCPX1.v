
/*

FUNCTION	: D-FLIP-FLOP with async clear and async preset

*/

`timescale  100 ps / 10 ps

`celldefine

module FDCPX1 (Q, C, CLR, D, PRE);


    output Q;
    reg    q_out;

    input  C, CLR, D, PRE;

    tri0 PRLD = glbl.PRLD;

    buf B1 (Q, q_out);

	always @(PRLD or CLR or PRE)
	    if (PRLD || CLR)
		assign q_out = 0;
	    else if (PRE)
		assign q_out = 1;
	    else
		deassign q_out;

	always @(posedge C)
	    q_out = D;

    specify
	(posedge C => (Q +: D)) = (0, 0);
	(posedge CLR => (Q +: 1'b0)) = (0, 0);
	(posedge PRE => (Q +: 1'b1)) = (0, 0);
    endspecify

endmodule

`endcelldefine
