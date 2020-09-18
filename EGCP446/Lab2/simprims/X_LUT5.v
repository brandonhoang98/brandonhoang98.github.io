//    Xilinx Proprietary Primitive Cell X_LUT5 for Verilog
//
// $Header: /devl/xcs/repo/env/Databases/CAEInterfaces/versclibs/data/X_LUT5.v,v 1.5 2003/01/21 02:38:36 wloo Exp $
//

`timescale 1 ps/1 ps

module X_LUT5 (O, ADR0, ADR1, ADR2, ADR3, ADR4);

  parameter INIT = 32'h00000000;

  output O;
  input ADR0, ADR1, ADR2, ADR3, ADR4;

  wire out0, out1, out2, out3, out4, out5, out6, out7, out8, out9;
  wire a0, a1, a2, a3, a4;

  buf b0 (a0, ADR0);
  buf b1 (a1, ADR1);
  buf b2 (a2, ADR2);
  buf b3 (a3, ADR3);
  buf b4 (a4, ADR4);

  x_lut5_mux4 (out7, INIT[31], INIT[30], INIT[29], INIT[28], a1, a0);
  x_lut5_mux4 (out6, INIT[27], INIT[26], INIT[25], INIT[24], a1, a0);
  x_lut5_mux4 (out5, INIT[23], INIT[22], INIT[21], INIT[20], a1, a0);
  x_lut5_mux4 (out4, INIT[19], INIT[18], INIT[17], INIT[16], a1, a0);
  x_lut5_mux4 (out3, INIT[15], INIT[14], INIT[13], INIT[12], a1, a0);
  x_lut5_mux4 (out2, INIT[11], INIT[10], INIT[9], INIT[8], a1, a0);
  x_lut5_mux4 (out1, INIT[7], INIT[6], INIT[5], INIT[4], a1, a0);
  x_lut5_mux4 (out0, INIT[3], INIT[2], INIT[1], INIT[0], a1, a0);

  x_lut5_mux4 (out9, out7, out6, out5, out4, a3, a2);
  x_lut5_mux4 (out8, out3, out2, out1, out0, a3, a2);

  x_lut5_mux4 (O, 1'b0, 1'b0, out9, out8, 1'b0, a4);

  specify

	(ADR0 => O) = (0:0:0, 0:0:0);
	(ADR1 => O) = (0:0:0, 0:0:0);
	(ADR2 => O) = (0:0:0, 0:0:0);
	(ADR3 => O) = (0:0:0, 0:0:0);
	(ADR4 => O) = (0:0:0, 0:0:0);
	specparam PATHPULSE$ = 0;

  endspecify

endmodule

primitive x_lut5_mux4 (o, d3, d2, d1, d0, s1, s0);

  output o;
  input d3, d2, d1, d0;
  input s1, s0;

  table

    // d3  d2  d1  d0  s1  s0 : o;

       ?   ?   ?   1   0   0  : 1;
       ?   ?   ?   0   0   0  : 0;
       ?   ?   1   ?   0   1  : 1;
       ?   ?   0   ?   0   1  : 0;
       ?   1   ?   ?   1   0  : 1;
       ?   0   ?   ?   1   0  : 0;
       1   ?   ?   ?   1   1  : 1;
       0   ?   ?   ?   1   1  : 0;

       ?   ?   0   0   0   x  : 0;
       ?   ?   1   1   0   x  : 1;
       0   0   ?   ?   1   x  : 0;
       1   1   ?   ?   1   x  : 1;

       ?   0   ?   0   x   0  : 0;
       ?   1   ?   1   x   0  : 1;
       0   ?   0   ?   x   1  : 0;
       1   ?   1   ?   x   1  : 1;

       0   0   0   0   x   x  : 0;
       1   1   1   1   x   x  : 1;

  endtable

endprimitive
