//    Xilinx Proprietary Primitive Cell X_MUX2 for Verilog
//
// $Header: /devl/xcs/repo/env/Databases/CAEInterfaces/versclibs/data/X_MUX2.v,v 1.9 2003/01/21 02:38:37 wloo Exp $
//

`timescale 1 ps/1 ps

module X_MUX2 (O, IA, IB, SEL);

  output O;
  input IA, IB, SEL;

  mux (O, IA, IB, SEL);

  specify

	(IA => O) = (0:0:0, 0:0:0);
	(IB => O) = (0:0:0, 0:0:0);
	(SEL => O) = (0:0:0, 0:0:0);
	specparam PATHPULSE$ = 0;

  endspecify

endmodule


primitive mux (out, ina, inb, sel);

  output out;
  input  ina, inb, sel;

  table

   //    ina   inb   sel   out;

          0     ?     0  :  0;
          1     ?     0  :  1;
          ?     0     1  :  0;
          ?     1     1  :  1;
          0     0     x  :  0;
          1     1     x  :  1;

  endtable

endprimitive
