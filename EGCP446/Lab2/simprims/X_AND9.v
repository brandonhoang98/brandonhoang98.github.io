//    Xilinx Proprietary Primitive Cell X_AND9 for Verilog
//
// $Header: /devl/xcs/repo/env/Databases/CAEInterfaces/versclibs/data/X_AND9.v,v 1.2 2003/01/21 02:38:33 wloo Exp $
//

`timescale 1 ps/1 ps

module X_AND9 (O, I0, I1, I2, I3, I4, I5, I6, I7, I8);

  output O;
  input I0, I1, I2, I3, I4, I5, I6, I7, I8;

  and (O, I0, I1, I2, I3, I4, I5, I6, I7, I8);

  specify

	(I0 => O) = (0:0:0, 0:0:0);
	(I1 => O) = (0:0:0, 0:0:0);
	(I2 => O) = (0:0:0, 0:0:0);
	(I3 => O) = (0:0:0, 0:0:0);
	(I4 => O) = (0:0:0, 0:0:0);
	(I5 => O) = (0:0:0, 0:0:0);
	(I6 => O) = (0:0:0, 0:0:0);
	(I7 => O) = (0:0:0, 0:0:0);
	(I8 => O) = (0:0:0, 0:0:0);
	specparam PATHPULSE$ = 0;

  endspecify

endmodule
