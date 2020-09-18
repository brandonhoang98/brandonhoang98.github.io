// $Header: /devl/xcs/repo/env/Databases/CAEInterfaces/verunilibs/s/LUT2_D.v,v 1.8 2003/01/21 01:55:29 wloo Exp $
/*

FUNCTION	: 2-inputs LUT

*/

`timescale  100 ps / 10 ps


module LUT2_D (LO, O, I0, I1);

    parameter INIT = 4'h0;

    input I0, I1;

    output LO, O;

    wire out;

    lut2_d_mux4 (out, INIT[3], INIT[2], INIT[1], INIT[0], I1, I0);

    buf b2 (LO, out);
    buf b3 (O, out);

    specify
	(I0 *> LO) = (0, 0);
	(I1 *> LO) = (0, 0);
	(I0 *> O) = (0, 0);
	(I1 *> O) = (0, 0);
    endspecify

endmodule


primitive lut2_d_mux4 (O, d3, d2, d1, d0, s1, s0);

  output O;
  input d3, d2, d1, d0;
  input s1, s0;

  table

    // d3  d2  d1  d0  s1  s0 : O;

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
