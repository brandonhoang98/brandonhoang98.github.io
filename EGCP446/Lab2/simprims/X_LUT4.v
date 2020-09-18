//    Xilinx Proprietary Primitive Cell X_LUT4 for Verilog
//
// $Header: /devl/xcs/repo/env/Databases/CAEInterfaces/versclibs/data/X_LUT4.v,v 1.9 2003/01/21 02:38:36 wloo Exp $
//

`timescale 1 ps/1 ps

module X_LUT4 (O, ADR0, ADR1, ADR2, ADR3);

  parameter INIT = 16'h0000;

  output O;
  input ADR0, ADR1, ADR2, ADR3;

  wire out0, out1, out2, out3, a0, a1, a2, a3;

  buf b0 (a0, ADR0);
  buf b1 (a1, ADR1);
  buf b2 (a2, ADR2);
  buf b3 (a3, ADR3);

  x_lut4_mux4 (out3, INIT[15], INIT[14], INIT[13], INIT[12], a1, a0);
  x_lut4_mux4 (out2, INIT[11], INIT[10], INIT[9], INIT[8], a1, a0);
  x_lut4_mux4 (out1, INIT[7], INIT[6], INIT[5], INIT[4], a1, a0);
  x_lut4_mux4 (out0, INIT[3], INIT[2], INIT[1], INIT[0], a1, a0);
  x_lut4_mux4 (O, out3, out2, out1, out0, a3, a2);

  specify

	(ADR0 => O) = (0:0:0, 0:0:0);
	(ADR1 => O) = (0:0:0, 0:0:0);
	(ADR2 => O) = (0:0:0, 0:0:0);
	(ADR3 => O) = (0:0:0, 0:0:0);
	specparam PATHPULSE$ = 0;

  endspecify

endmodule

primitive x_lut4_mux4 (o, d3, d2, d1, d0, s1, s0);

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
