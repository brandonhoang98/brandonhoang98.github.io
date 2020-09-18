// $Header: /devl/xcs/repo/env/Databases/CAEInterfaces/verunilibs/s/OBUFT_LVCMOS12_F_8.v,v 1.2 2003/01/21 01:55:32 wloo Exp $

/*

FUNCTION	: TRI-STATE OUTPUT BUFFER

*/

`timescale  100 ps / 10 ps


module OBUFT_LVCMOS12_F_8 (O, I, T);

    output O;

    input  I, T;

    tri0 GTS = glbl.GTS;

    or O1 (ts, GTS, T);
    bufif0 T1 (O, I, ts);

    specify
	(I *> O) = (0, 0);
	(T *> O) = (0, 0);
    endspecify

endmodule

