//    Xilinx Proprietary Primitive Cell X_PD for Verilog
//
// $Header: /devl/xcs/repo/env/Databases/CAEInterfaces/versclibs/data/X_PD.v,v 1.10 2003/01/21 02:38:38 wloo Exp $
//

`timescale 1 ps/1 ps

module X_PD (O);

  output O;

  pulldown (weak0) (O);

endmodule
