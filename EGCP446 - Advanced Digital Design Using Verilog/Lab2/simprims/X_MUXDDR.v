//    Xilinx Proprietary Primitive Cell X_MUXDDR for Verilog
//
// $Header: /devl/xcs/repo/env/Databases/CAEInterfaces/versclibs/data/X_MUXDDR.v,v 1.15 2003/01/21 02:38:37 wloo Exp $
//

`timescale 1 ps/1 ps


module X_MUXDDR (O, CE, CLK0, CLK1, I0, I1);

    output O;
    reg    o_out;
    reg    s;

    input  CE, CLK0, CLK1, I0, I1;

    wire clk0_in, clk1_in;

    buf b_CLK0 (clk0_in, CLK0);
    buf b_CLK1 (clk1_in, CLK1);
    buf b_O (O, o_out);

	always @(posedge clk0_in)
	    if (CE)
		s <= 0;

	always @(posedge clk1_in)
	    if (CE)
		s <= 1;

	always @(s or I0 or I1)
	    if (s)
		o_out <= I1;
	    else
		o_out <= I0;

    specify

	(CLK0 => O) = (0:0:0, 0:0:0);
	(CLK1 => O) = (0:0:0, 0:0:0);
	(I0 => O) = (0:0:0, 0:0:0);
	(I1 => O) = (0:0:0, 0:0:0);

	specparam PATHPULSE$ = 0;

    endspecify

endmodule
