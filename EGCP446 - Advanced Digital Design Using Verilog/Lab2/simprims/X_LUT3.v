//    Xilinx Proprietary Primitive Cell X_LUT3 for Verilog
//
// $Header: /devl/xcs/repo/env/Databases/CAEInterfaces/versclibs/data/X_LUT3.v,v 1.9 2003/01/21 02:38:36 wloo Exp $
//

`timescale 1 ps/1 ps

module X_LUT3 (O, ADR0, ADR1, ADR2);

  parameter INIT = 8'h00;

  output O;
  input ADR0, ADR1, ADR2;

  wire out0, out1, a0, a1, a2;

  buf b0 (a0, ADR0);
  buf b1 (a1, ADR1);
  buf b2 (a2, ADR2);

  x_lut3_mux4 (out1, INIT[7], INIT[6], INIT[5], INIT[4], a1, a0);
  x_lut3_mux4 (out0, INIT[3], INIT[2], INIT[1], INIT[0], a1, a0);
  x_lut3_mux4 (O, 1'b0, 1'b0, out1, out0, 1'b0, a2);

  specify

	(ADR0 => O) = (0:0:0, 0:0:0);
	(ADR1 => O) = (0:0:0, 0:0:0);
	(ADR2 => O) = (0:0:0, 0:0:0);
	specparam PATHPULSE$ = 0;

  endspecify

endmodule

primitive x_lut3_mux4 (o, d3, d2, d1, d0, s1, s0);

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
