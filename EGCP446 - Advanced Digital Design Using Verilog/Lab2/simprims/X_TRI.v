//    Xilinx Proprietary Primitive Cell X_TRI for Verilog
//
// $Header: /devl/xcs/repo/env/Databases/CAEInterfaces/versclibs/data/X_TRI.v,v 1.10 2003/01/21 02:38:44 wloo Exp $
//

`timescale 1 ps/1 ps

module X_TRI (O, CTL, I);

  output O;
  input CTL, I;

  bufif1 (O, I, CTL);

  specify

	(I => O) = (0:0:0, 0:0:0);
	(CTL => O) = (0:0:0, 0:0:0,
                      0:0:0, 0:0:0,
                      0:0:0, 0:0:0);

	specparam PATHPULSE$ = 0;

  endspecify

endmodule
