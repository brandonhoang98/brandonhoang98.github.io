//    Xilinx Proprietary Primitive Cell X_OBUFDS for Verilog
//
// $Header: /devl/xcs/repo/env/Databases/CAEInterfaces/versclibs/data/X_OBUFDS.v,v 1.13 2003/01/21 02:38:37 wloo Exp $
//

`timescale 1 ps/1 ps

module X_OBUFDS (O, OB, I);

    output O, OB;

    input  I;

	buf B1 (O, I);
	not I1 (OB, I);

    specify

	(I => O) = (0:0:0, 0:0:0);
	(I => OB) = (0:0:0, 0:0:0);

	specparam PATHPULSE$ = 0;

    endspecify

endmodule
