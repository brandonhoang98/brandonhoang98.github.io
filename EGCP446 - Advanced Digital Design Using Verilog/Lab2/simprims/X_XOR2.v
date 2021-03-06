//    Xilinx Proprietary Primitive Cell X_XOR2 for Verilog
//
// $Header: /devl/xcs/repo/env/Databases/CAEInterfaces/versclibs/data/X_XOR2.v,v 1.9 2003/01/21 02:38:45 wloo Exp $
//

`timescale 1 ps/1 ps

module X_XOR2 (O, I0, I1);

  output O;
  input I0, I1;

  xor (O, I0, I1);

  specify

	(I0 => O) = (0:0:0, 0:0:0);
	(I1 => O) = (0:0:0, 0:0:0);

	specparam PATHPULSE$ = 0;

  endspecify

endmodule
