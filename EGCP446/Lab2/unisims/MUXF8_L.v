// $Header: /devl/xcs/repo/env/Databases/CAEInterfaces/verunilibs/s/MUXF8_L.v,v 1.8 2003/01/21 01:55:29 wloo Exp $

/*

FUNCTION	: 2 to 1 Multiplexer for Carry Logic

*/

`timescale  100 ps / 10 ps


module MUXF8_L (LO, I0, I1, S);

    output LO;
    reg    lo_out;

    input  I0, I1, S;

    buf B1 (LO, lo_out);

	always @(I0 or I1 or S) begin
	    if (S)
		lo_out <= I1;
	    else
		lo_out <= I0;
	end

    specify
	(I0 => LO) = (0, 0);
	(I1 => LO) = (0, 0);
	(S  => LO) = (0, 0);
    endspecify

endmodule

