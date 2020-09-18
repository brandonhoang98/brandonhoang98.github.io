//    Xilinx Proprietary Primitive Cell X_AND5 for Verilog
//
// $Header: /devl/xcs/repo/env/Databases/CAEInterfaces/versclibs/data/X_AND5.v,v 1.9 2003/01/21 02:38:33 wloo Exp $
//

`timescale 1 ps/1 ps

module X_AND5 (O, I0, I1, I2, I3, I4);

  output O;
  input I0, I1, I2, I3, I4;

  and (O, I0, I1, I2, I3, I4);

  specify

	(I0 => O) = (0:0:0, 0:0:0);
	(I1 => O) = (0:0:0, 0:0:0);
	(I2 => O) = (0:0:0, 0:0:0);
	(I3 => O) = (0:0:0, 0:0:0);
	(I4 => O) = (0:0:0, 0:0:0);
	specparam PATHPULSE$ = 0;

  endspecify

endmodule
