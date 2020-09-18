// $Header: /devl/xcs/repo/env/Databases/CAEInterfaces/verunilibs/s/OBUFTDS_LVPECL_33.v,v 1.8 2003/01/21 01:55:31 wloo Exp $

/*

FUNCTION	: TRI-STATE OUTPUT BUFFER

*/

`timescale  100 ps / 10 ps


module OBUFTDS_LVPECL_33 (O, OB, I, T);

    output O, OB;

    input  I, T;

    tri0 GTS = glbl.GTS;

    or O1 (ts, GTS, T);
    bufif0 B1 (O, I, ts);
    notif0 N1 (OB, I, ts);

    specify
	(I *> O) = (0, 0);
	(T *> O) = (0, 0);
	(I *> OB) = (0, 0);
	(T *> OB) = (0, 0);
    endspecify

endmodule


