//    Xilinx Proprietary Primitive Cell X_SUH for Verilog
//
// $Header: /devl/xcs/repo/env/Databases/CAEInterfaces/versclibs/data/X_SUH.v,v 1.11 2003/01/21 02:38:44 wloo Exp $
//

`timescale 1 ps/1 ps
 
module X_SUH (I, CE, CLK);

  input I, CLK, CE;

  specify

      $setuphold (posedge CLK, posedge CE, 0:0:0, 0:0:0);
      $setuphold (posedge CLK, negedge CE, 0:0:0, 0:0:0);
      $setuphold (negedge CLK, posedge CE, 0:0:0, 0:0:0);
      $setuphold (negedge CLK, negedge CE, 0:0:0, 0:0:0);

      $setuphold (posedge CLK, posedge I &&& CE, 0:0:0, 0:0:0);
      $setuphold (posedge CLK, negedge I &&& CE, 0:0:0, 0:0:0);
      $setuphold (negedge CLK, posedge I &&& CE, 0:0:0, 0:0:0);
      $setuphold (negedge CLK, negedge I &&& CE, 0:0:0, 0:0:0);

  endspecify

endmodule
