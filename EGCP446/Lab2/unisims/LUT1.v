// $Header: /devl/xcs/repo/env/Databases/CAEInterfaces/verunilibs/s/LUT1.v,v 1.7 2003/01/21 01:55:29 wloo Exp $
/*

FUNCTION	: 2-inputs LUT

*/

`timescale  100 ps / 10 ps


module LUT1 (O, I0);

    parameter INIT = 2'h0;

    input I0;

    output O;

    wire out;

    lut1_mux2 (out, INIT[1], INIT[0], I0);

    buf b1 (O, out);

    specify
	(I0 *> O) = (0, 0);
    endspecify

endmodule


primitive lut1_mux2 (O, d1, d0, s0);

  output O;
  input d1, d0;
  input s0;

  table

    // d1  d0  s0 : O;

       ?   1   0  : 1;
       ?   0   0  : 0;
       1   ?   1  : 1;
       0   ?   1  : 0;
       0   0   x  : 0;
       1   1   x  : 1;

  endtable

endprimitive
