//    Xilinx Proprietary Primitive Cell X_KEEPER for Verilog
//
// $Header: /devl/xcs/repo/env/Databases/CAEInterfaces/versclibs/data/X_KEEPER.v,v 1.9 2003/01/21 02:38:36 wloo Exp $
//

`timescale 1 ps/1 ps
 
module X_KEEPER (O);

  inout O;
  wire  O_int;
  reg   I;

    always @(O_int)
        if (O_int)
            I <= 1;
        else
            I <= 0;

    buf (pull1, pull0) (O, I);
    buf (O_int, O);

  specify

      (O => O) = (0:0:0, 0:0:0);

  endspecify

endmodule
