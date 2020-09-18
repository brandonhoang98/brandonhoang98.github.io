//    Xilinx Proprietary Primitive Cell X_CKBUF for Verilog
//
// $Header: /devl/xcs/repo/env/Databases/CAEInterfaces/versclibs/data/X_CKBUF.v,v 1.9 2003/01/21 02:38:34 wloo Exp $
//

`timescale 1 ps/1 ps

module X_CKBUF (O, I);

  output O;
  input I;

  buf (O, I);

  specify

	(I => O) = (0:0:0, 0:0:0);
	specparam PATHPULSE$ = 0;

  endspecify

endmodule
