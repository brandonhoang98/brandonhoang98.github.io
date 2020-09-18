// $Header: /devl/xcs/repo/env/Databases/CAEInterfaces/verunilibs/s/IBUFGDS_LVDS_25.v,v 1.9 2003/01/21 01:55:24 wloo Exp $

/*

FUNCTION	: INPUT BUFFER

*/

`timescale  100 ps / 10 ps


module IBUFGDS_LVDS_25 (O, I, IB);

    output O;

    input  I, IB;

    reg o_out;

    buf b_0 (O, o_out);

    always @(I or IB) begin
	if (I == 1'b1 && IB == 1'b0)
	    o_out <= I;
	else if (I == 1'b0 && IB == 1'b1)
	    o_out <= I;
    end

    specify
	(I *> O) = (0, 0);
    endspecify

endmodule


