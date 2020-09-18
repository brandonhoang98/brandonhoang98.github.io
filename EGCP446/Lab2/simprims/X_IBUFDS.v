//    Xilinx Proprietary Primitive Cell X_IBUFDS for Verilog
//
// $Header: /devl/xcs/repo/env/Databases/CAEInterfaces/versclibs/data/X_IBUFDS.v,v 1.13 2003/01/21 02:38:35 wloo Exp $
//

`timescale 1 ps/1 ps


module X_IBUFDS (O, I, IB);

    output O;

    input  I, IB;

    wire i_in, ib_in;
    reg o_out;

    buf b_I (i_in, I);
    buf b_IB (ib_in, IB);
    buf b_O (O, o_out);

    always @(i_in or ib_in) begin
	if (i_in == 1'b1 && ib_in == 1'b0)
	    o_out <= i_in;
	else if (i_in == 1'b0 && ib_in == 1'b1)
	    o_out <= i_in;
    end

    specify

	(I => O) = (0:0:0, 0:0:0);
	(IB => O) = (0:0:0, 0:0:0);

	specparam PATHPULSE$ = 0;

    endspecify

endmodule

