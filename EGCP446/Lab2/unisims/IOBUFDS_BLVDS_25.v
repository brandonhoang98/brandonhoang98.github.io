// $Header: /devl/xcs/repo/env/Databases/CAEInterfaces/verunilibs/s/IOBUFDS_BLVDS_25.v,v 1.5 2003/01/21 01:55:26 wloo Exp $

/*

FUNCTION	: INPUT TRI-STATE OUTPUT BUFFER

*/

`timescale  100 ps / 10 ps


module IOBUFDS_BLVDS_25 (O, IO, IOB, I, T);

    output O;

    inout  IO, IOB;

    input  I, T;

    tri0 GTS = glbl.GTS;

	or O1 (ts, GTS, T);
	bufif0 B1 (IO, I, ts);
	notif0 N1 (IOB, I, ts);

    buf B2 (O, IO);

    specify
	(IO *> O) = (0, 0);
	(I *> IO) = (0, 0);
	(T *> IO) = (0, 0);
	(I *> IOB) = (0, 0);
	(T *> IOB) = (0, 0);
    endspecify

endmodule


