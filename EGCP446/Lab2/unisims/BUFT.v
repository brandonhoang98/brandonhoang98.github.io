// $Header: /devl/xcs/repo/env/Databases/CAEInterfaces/verunilibs/s/BUFT.v,v 1.8 2003/01/21 01:55:23 wloo Exp $

/*

FUNCTION	: TRI-STATE BUFFER

*/

`timescale  100 ps / 10 ps


module BUFT (O, I, T);

    output O;

    input  I, T;

	bufif0 T1 (O, I, T);

    specify
	(I *> O) = (0, 0);
	(T *> O) = (0, 0);
    endspecify

endmodule

