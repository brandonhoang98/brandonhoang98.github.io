// $Header: /devl/xcs/repo/env/Databases/CAEInterfaces/verunilibs/s/MUXCY_D.v,v 1.9 2003/01/21 01:55:29 wloo Exp $

/*

FUNCTION	: 2 to 1 Multiplexer for Carry Logic

*/

`timescale  100 ps / 10 ps


module MUXCY_D (LO, O, CI, DI, S);

    output LO, O;
    reg    o_out, lo_out;

    input  CI, DI, S;

    buf B1 (O, o_out);
    buf B2 (LO, lo_out);

	always @(CI or DI or S) begin
	    if (S)
		o_out <= CI;
	    else
		o_out <= DI;
	end

	always @(CI or DI or S) begin
	    if (S)
		lo_out <= CI;
	    else
		lo_out <= DI;
	end

    specify
	(CI => O) = (0, 0);
	(DI => O) = (0, 0);
	(S  => O) = (0, 0);
	(CI => LO) = (0, 0);
	(DI => LO) = (0, 0);
	(S  => LO) = (0, 0);
    endspecify

endmodule

