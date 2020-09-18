// $Header: /devl/xcs/repo/env/Databases/CAEInterfaces/verunilibs/s/MUXF7_D.v,v 1.9 2003/01/21 01:55:29 wloo Exp $

/*

FUNCTION	: 2 to 1 Multiplexer for Carry Logic

*/

`timescale  100 ps / 10 ps


module MUXF7_D (LO, O, I0, I1, S);

    output LO, O;
    reg    o_out, lo_out;

    input  I0, I1, S;

    buf B1 (O, o_out);
    buf B2 (LO, lo_out);

	always @(I0 or I1 or S) begin
	    if (S)
		o_out <= I1;
	    else
		o_out <= I0;
	end

	always @(I0 or I1 or S) begin
	    if (S)
		lo_out <= I1;
	    else
		lo_out <= I0;
	end

    specify
	(I0 => O) = (0, 0);
	(I1 => O) = (0, 0);
	(S  => O) = (0, 0);
	(I0 => LO) = (0, 0);
	(I1 => LO) = (0, 0);
	(S  => LO) = (0, 0);
    endspecify

endmodule

