// $Header: /devl/xcs/repo/env/Databases/CAEInterfaces/verunilibs/s/LUT3_L.v,v 1.7 2003/01/21 01:55:29 wloo Exp $
/*

FUNCTION	: 3-inputs LUT

*/

`timescale  100 ps / 10 ps


module LUT3_L (LO, I0, I1, I2);

    parameter INIT = 8'h00;

    input I0, I1, I2;

    output LO;

    wire out0, out1, out;

    lut3_l_mux4 (out1, INIT[7], INIT[6], INIT[5], INIT[4], I1, I0);
    lut3_l_mux4 (out0, INIT[3], INIT[2], INIT[1], INIT[0], I1, I0);
    lut3_l_mux4 (out, 1'b0, 1'b0, out1, out0, 1'b0, I2);

    buf b3 (LO, out);

    specify
	(I0 *> LO) = (0, 0);
	(I1 *> LO) = (0, 0);
	(I2 *> LO) = (0, 0);
    endspecify

endmodule


primitive lut3_l_mux4 (o, d3, d2, d1, d0, s1, s0);

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
