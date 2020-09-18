// $Header: /devl/xcs/repo/env/Databases/CAEInterfaces/verunilibs/s/PULLUP.v,v 1.9 2003/01/21 01:55:40 wloo Exp $

/*

FUNCTION	: pullup cell

*/

`timescale  100 ps / 10 ps


module PULLUP (O);

    output O;
	pullup (A);
	buf (weak0,weak1) #(1,1) (O,A);

endmodule

