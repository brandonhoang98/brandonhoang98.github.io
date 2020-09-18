// $Header: /devl/xcs/repo/env/Databases/CAEInterfaces/verunilibs/s/BSCAN_SPARTAN2.v,v 1.10 2003/01/21 01:55:22 wloo Exp $

/*

FUNCTION	: BSCAN_SPARTAN2 dummy simulation module

*/

`timescale  100 ps / 10 ps


module BSCAN_SPARTAN2 (DRCK1, DRCK2, RESET, SEL1, SEL2, SHIFT, TDI, UPDATE, TDO1, TDO2);

    input TDO1, TDO2;

    output DRCK1, DRCK2, RESET, SEL1, SEL2, SHIFT, TDI, UPDATE;

    pulldown (TDI);
    pulldown (RESET);
    pulldown (SHIFT);
    pulldown (UPDATE);
    pulldown (SEL1);
    pulldown (DRCK1);
    pulldown (SEL2);
    pulldown (DRCK2);

    specify
	(TDO1, TDO2 *> TDI) = (0,0);
	(TDO1, TDO2 *> RESET) = (0,0);
	(TDO1, TDO2 *> SHIFT) = (0,0);
	(TDO1, TDO2 *> UPDATE) = (0,0);
	(TDO1, TDO2 *> SEL1) = (0,0);
	(TDO1, TDO2 *> DRCK1) = (0,0);
	(TDO1, TDO2 *> SEL2) = (0,0);
	(TDO1, TDO2 *> DRCK2) = (0,0);
    endspecify

endmodule

