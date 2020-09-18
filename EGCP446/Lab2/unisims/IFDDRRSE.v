// $Header: /devl/xcs/repo/env/Databases/CAEInterfaces/verunilibs/s/IFDDRRSE.v,v 1.7 2003/01/21 01:55:25 wloo Exp $

/*

FUNCTION	: Dual Data Rate input D-FLIP-FLOP with sync reset, sync set and clock enable

*/

`timescale  100 ps / 10 ps

module IFDDRRSE (Q0, Q1, C0, C1, CE, D, R, S);

    output Q0, Q1;

    input  C0, C1, CE, D, R, S;

    wire   d_in;

    IBUF I1 (.I(D),
	.O(d_in));

    FDRSE F0 (.C(C0),
	.CE(CE),
	.R(R),
	.D(d_in),
	.S(S),
	.Q(Q0));
    defparam F0.INIT = 1'b0;

    FDRSE F1 (.C(C1),
	.CE(CE),
	.R(R),
	.D(d_in),
	.S(S),
	.Q(Q1));
    defparam F1.INIT = "0";

endmodule
