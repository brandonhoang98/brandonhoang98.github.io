// $Header: /devl/xcs/repo/env/Databases/CAEInterfaces/verunilibs/s/MUXCY_L.v,v 1.8 2003/01/21 01:55:29 wloo Exp $

/*

FUNCTION	: 2 to 1 Multiplexer for Carry Logic

*/

`timescale  100 ps / 10 ps


module MUXCY_L (LO, CI, DI, S);

    output LO;
    reg    lo_out;

    input  CI, DI, S;

    buf B1 (LO, lo_out);

	always @(CI or DI or S) begin
	    if (S)
		lo_out <= CI;
	    else
		lo_out <= DI;
	end

    specify
	(CI => LO) = (0, 0);
	(DI => LO) = (0, 0);
	(S  => LO) = (0, 0);
    endspecify

endmodule

