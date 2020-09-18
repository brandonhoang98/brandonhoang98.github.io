// $Header: /devl/xcs/repo/env/Databases/CAEInterfaces/verunilibs/s/IBUFGDS_DIFF_OUT.v,v 1.2 2003/01/21 01:05:42 wloo Exp $

/*

FUNCTION	: INPUT BUFFER

*/

`timescale  100 ps / 10 ps


module IBUFGDS_DIFF_OUT (O, OB, I, IB);

    parameter IOSTANDARD = "LVDS_25";

    output O, OB;

    input  I, IB;

    reg  o_out;

    buf B0 (O, o_out);
    not B1 (OB, o_out);

    always @(I or IB) begin
	if (I == 1'b1 && IB == 1'b0)
	    o_out <= I;
	else if (I == 1'b0 && IB == 1'b1)
	    o_out <= I;
    end

    specify
	(I  *>  O) = (0, 0);
	(IB *>  O) = (0, 0);
	(I  *> OB) = (0, 0);
	(IB *> OB) = (0, 0);
    endspecify

endmodule

