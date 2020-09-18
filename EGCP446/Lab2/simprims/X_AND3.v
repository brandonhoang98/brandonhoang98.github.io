//    Xilinx Proprietary Primitive Cell X_AND3 for Verilog
//
// $Header: /devl/xcs/repo/env/Databases/CAEInterfaces/versclibs/data/X_AND3.v,v 1.9 2003/01/21 02:38:33 wloo Exp $
//

`timescale 1 ps/1 ps

module X_AND3 (O, I0, I1, I2);

  output O;
  input I0, I1, I2;

  and (O, I0, I1, I2);

  specify

	(I0 => O) = (0:0:0, 0:0:0);
	(I1 => O) = (0:0:0, 0:0:0);
	(I2 => O) = (0:0:0, 0:0:0);
	specparam PATHPULSE$ = 0;

  endspecify

endmodule
