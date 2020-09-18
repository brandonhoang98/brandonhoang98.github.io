// $Header: /devl/xcs/repo/env/Databases/CAEInterfaces/verunilibs/s/BSCAN_VIRTEX2.v,v 1.11 2003/01/21 01:55:22 wloo Exp $

/*

FUNCTION	: BSCAN_VIRTEX2 dummy simulation module

*/

`timescale  100 ps / 10 ps


module BSCAN_VIRTEX2 (CAPTURE, DRCK1, DRCK2, RESET, SEL1, SEL2, SHIFT, TDI, UPDATE, TDO1, TDO2);

    input TDO1, TDO2;

    output CAPTURE, DRCK1, DRCK2, RESET, SEL1, SEL2, SHIFT, TDI, UPDATE;

    pulldown (DRCK1);
    pulldown (DRCK2);
    pulldown (RESET);
    pulldown (SEL1);
    pulldown (SEL2);
    pulldown (SHIFT);
    pulldown (TDI);
    pulldown (UPDATE);

    specify
	(TDO1, TDO2 *> DRCK1) = (0,0);
	(TDO1, TDO2 *> DRCK2) = (0,0);
	(TDO1, TDO2 *> RESET) = (0,0);
	(TDO1, TDO2 *> SEL1) = (0,0);
	(TDO1, TDO2 *> SEL2) = (0,0);
	(TDO1, TDO2 *> SHIFT) = (0,0);
	(TDO1, TDO2 *> TDI) = (0,0);
	(TDO1, TDO2 *> UPDATE) = (0,0);
    endspecify

endmodule

