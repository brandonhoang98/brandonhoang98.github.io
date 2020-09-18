
/*

FUNCTION	: T-FLIP-FLOP with async clear and async preset

*/

`timescale  100 ps / 10 ps

`celldefine

module FTCP (Q, C, CLR, PRE, T);


    output Q;
    reg    q_out;

    input  C, CLR, PRE, T;

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
	    if (T)
		q_out = ~q_out;

    specify
	(posedge C => (Q -: Q)) = (0, 0);
	(posedge CLR => (Q +: 1'b0)) = (0, 0);
	(posedge PRE => (Q +: 1'b1)) = (0, 0);
    endspecify

endmodule

`endcelldefine
