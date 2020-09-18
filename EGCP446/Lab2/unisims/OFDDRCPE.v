// $Header: /devl/xcs/repo/env/Databases/CAEInterfaces/verunilibs/s/OFDDRCPE.v,v 1.6 2003/01/21 01:55:40 wloo Exp $

/*

FUNCTION	: Dual Data Rate output D-FLIP-FLOP with async clear, async preset and clock enable

*/

`timescale  100 ps / 10 ps

module OFDDRCPE (Q, C0, C1, CE, CLR, D0, D1, PRE);

    output Q;

    input  C0, C1, CE, CLR, D0, D1, PRE;

    wire   q_out;

    FDDRCPE F0 (.C0(C0),
	.C1(C1),
	.CE(CE),
	.CLR(CLR),
	.D0(D0),
	.D1(D1),
	.PRE(PRE),
	.Q(q_out));
    defparam F0.INIT = 1'b0;

    OBUF O1 (.I(q_out),
	.O(Q));

endmodule
