//    Xilinx Proprietary Primitive Cell X_OR4 for Verilog
//
// $Header: /devl/xcs/repo/env/Databases/CAEInterfaces/versclibs/data/X_OR4.v,v 1.9 2003/01/21 02:38:37 wloo Exp $
//

`timescale 1 ps/1 ps

module X_OR4 (O, I0, I1, I2, I3);

  output O;
  input I0, I1, I2, I3;

  or (O, I0, I1, I2, I3);

  specify

	(I0 => O) = (0:0:0, 0:0:0);
	(I1 => O) = (0:0:0, 0:0:0);
	(I2 => O) = (0:0:0, 0:0:0);
	(I3 => O) = (0:0:0, 0:0:0);

	specparam PATHPULSE$ = 0;

  endspecify

endmodule
