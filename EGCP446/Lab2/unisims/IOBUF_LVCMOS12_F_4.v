// $Header: /devl/xcs/repo/env/Databases/CAEInterfaces/verunilibs/s/IOBUF_LVCMOS12_F_4.v,v 1.2 2003/01/21 01:55:26 wloo Exp $

/*

FUNCTION	: INPUT TRI-STATE OUTPUT BUFFER

*/

`timescale  100 ps / 10 ps


module IOBUF_LVCMOS12_F_4 (O, IO, I, T);

    output O;

    inout  IO;

    input  I, T;

    tri0 GTS = glbl.GTS;

    or O1 (ts, GTS, T);
    bufif0 T1 (IO, I, ts);

    buf B1 (O, IO);

    specify
	(IO *> O) = (0, 0);
	(I *> IO) = (0, 0);
	(T *> IO) = (0, 0);
    endspecify

endmodule
