//    Xilinx Proprietary Primitive Cell X_BUF for Verilog
//
// $Header: /devl/xcs/repo/env/Databases/CAEInterfaces/versclibs/data/X_BUF.v,v 1.10 2003/01/21 02:38:33 wloo Exp $
//

`timescale 1 ps/1 ps

module X_BUF (O, I);

  output O;
  input I;

  buf (O, I);

  specify

	(I => O) = (0:0:0,  0:0:0);
	specparam PATHPULSE$ = 0;

  endspecify

endmodule
