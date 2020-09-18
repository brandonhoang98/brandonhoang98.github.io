// $Header: /devl/xcs/repo/env/Databases/CAEInterfaces/verunilibs/s/OFDDRTCPE.v,v 1.5 2003/01/21 01:55:40 wloo Exp $

/*

FUNCTION	: Dual Data Rate output D-FLIP-FLOP with async clear, async preset and clock enable

*/

`timescale  100 ps / 10 ps

module OFDDRTCPE (O, C0, C1, CE, CLR, D0, D1, PRE, T);

    output O;

    input  C0, C1, CE, CLR, D0, D1, PRE, T;

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

    OBUFT O1 (.I(q_out),
	.T(T),
	.O(O));

endmodule
