//    Xilinx Proprietary Dual Edge Triggered Primitive Cell X_FDD for Verilog
//
// $Header: /devl/xcs/repo/env/Databases/CAEInterfaces/versclibs/data/X_FDD.v,v 1.7 2003/02/04 17:56:59 patrickp Exp $
//

`timescale 1 ps/1 ps
 
module X_FDD (O, CE, CLK, I, RST, SET);

  parameter INIT = 1'b0;

  output O;
  input CE, CLK, I, RST, SET;

  wire ni, nrst, nset, in_out;
  wire in_clk_enable, ce_clk_enable, rst_clk_enable, set_clk_enable;
  reg notifier;

  not (ni, I);
  not (nrst, RST);
  not (nset, SET);
  xor (in_out, I, O);

  and (in_clk_enable, nrst, nset, CE);
  and (ce_clk_enable, nrst, nset, in_out);
  and (rst_clk_enable, CE, I);
  and (set_clk_enable, CE, nrst, ni);

  ffsrced (O, CLK, I, CE, SET, RST, notifier);

  specify

	(CLK => O) = (0:0:0, 0:0:0);
	(SET => O) = (0:0:0, 0:0:0);
	(RST => O) = (0:0:0, 0:0:0);

	$setuphold (posedge CLK, posedge CE &&& (ce_clk_enable!=0), 0:0:0, 0:0:0, notifier);
	$setuphold (posedge CLK, negedge CE &&& (ce_clk_enable!=0), 0:0:0, 0:0:0, notifier);
	$setuphold (negedge CLK, posedge CE &&& (ce_clk_enable!=0), 0:0:0, 0:0:0, notifier);
	$setuphold (negedge CLK, negedge CE &&& (ce_clk_enable!=0), 0:0:0, 0:0:0, notifier);
	$setuphold (posedge CLK, posedge I &&& (in_clk_enable!=0), 0:0:0, 0:0:0, notifier);
	$setuphold (posedge CLK, negedge I &&& (in_clk_enable!=0), 0:0:0, 0:0:0, notifier);
	$setuphold (negedge CLK, posedge I &&& (in_clk_enable!=0), 0:0:0, 0:0:0, notifier);
	$setuphold (negedge CLK, negedge I &&& (in_clk_enable!=0), 0:0:0, 0:0:0, notifier);

	$recrem (negedge RST, posedge CLK &&& (rst_clk_enable!=0), 0:0:0, 0:0:0, notifier);
	$recrem (negedge RST, negedge CLK &&& (rst_clk_enable!=0), 0:0:0, 0:0:0, notifier);
	$recrem (negedge SET, posedge CLK &&& (set_clk_enable!=0), 0:0:0, 0:0:0, notifier);
	$recrem (negedge SET, negedge CLK &&& (set_clk_enable!=0), 0:0:0, 0:0:0, notifier);

	$width (posedge CLK, 0:0:0, 0, notifier);
	$width (negedge CLK, 0:0:0, 0, notifier);
	$width (posedge RST, 0:0:0, 0, notifier);
	$width (posedge SET, 0:0:0, 0, notifier);

	specparam PATHPULSE$ = 0;

  endspecify

endmodule


primitive ffsrced (q, clk, d, ce, set, rst, notifier);

  output q; reg q;
  input clk, d, ce, set, rst, notifier;

  table

    //   clk    d     ce   set   rst   notifier    q     q+;

         (01)   0      1    0     0       ?    :   ?  :  0;
         (01)   1      1    0     0       ?    :   ?  :  1;
         (01)   x      1    0     0       ?    :   ?  :  x;
         (01)   0      x    0     0       ?    :   0  :  0;
         (01)   1      x    0     0       ?    :   1  :  1;

         (10)   0      1    0     0       ?    :   ?  :  0;
         (10)   1      1    0     0       ?    :   ?  :  1;
         (10)   x      1    0     0       ?    :   ?  :  x;
         (10)   0      x    0     0       ?    :   0  :  0;
         (10)   1      x    0     0       ?    :   1  :  1;

         (??)   ?      0    0     0       ?    :   ?  :  -;

          ?     ?      ?    1     0       ?    :   ?  :  1;
          ?     ?      ?    ?     1       ?    :   ?  :  0;
          ?     ?      ?    0     x       ?    :   0  :  0;
         (01)   0      1    0     x       ?    :   ?  :  0;
         (10)   0      1    0     x       ?    :   ?  :  0;
          ?     ?      ?    x     0       ?    :   1  :  1;
         (01)   1      1    x     0       ?    :   ?  :  1;
         (10)   1      1    x     0       ?    :   ?  :  1;

          ?    (??)    ?    0     0       ?    :   ?  :  -;
          ?     ?    (??)   0     0       ?    :   ?  :  -;
          ?     ?      ?   (?0)   ?       ?    :   ?  :  -;
          ?     ?      ?    ?    (?0)     ?    :   ?  :  -;

          ?     ?      ?    ?     ?       *    :   ?  :  x;

  endtable

endprimitive
