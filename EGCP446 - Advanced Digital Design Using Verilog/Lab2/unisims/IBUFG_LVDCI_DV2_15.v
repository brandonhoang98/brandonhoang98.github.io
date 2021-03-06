// $Header: /devl/xcs/repo/env/Databases/CAEInterfaces/verunilibs/s/IBUFG_LVDCI_DV2_15.v,v 1.8 2003/01/21 01:55:25 wloo Exp $

/*

FUNCTION	: INPUT BUFFER

*/

`timescale  100 ps / 10 ps


module IBUFG_LVDCI_DV2_15 (O, I);

    output O;

    input  I;

	buf B1 (O, I);

    specify
	(I *> O) = (0, 0);
    endspecify

endmodule

