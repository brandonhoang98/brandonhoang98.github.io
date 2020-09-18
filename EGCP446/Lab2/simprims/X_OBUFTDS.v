//    Xilinx Proprietary Primitive Cell X_OBUFTDS for Verilog
//
// $Header: /devl/xcs/repo/env/Databases/CAEInterfaces/versclibs/data/X_OBUFTDS.v,v 1.13 2003/01/21 02:38:37 wloo Exp $
//

`timescale 1 ps/1 ps

module X_OBUFTDS (O, OB, I, T);

    output O, OB;

    input  I, T;

    bufif0 B1 (O, I, T);
    notif0 N1 (OB, I, T);

    specify

	(I => O)  = (0:0:0, 0:0:0);
	(I => OB) = (0:0:0, 0:0:0);
	(T => O)  = (0:0:0, 0:0:0,
		     0:0:0, 0:0:0,
		     0:0:0, 0:0:0);
	(T => OB) = (0:0:0, 0:0:0,
		     0:0:0, 0:0:0,
		     0:0:0, 0:0:0);

	specparam PATHPULSE$ = 0;

    endspecify

endmodule
