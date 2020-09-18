//	Xilinx Proprietary Primitive Cell X_BUFGMUX for Verilog
//
// $Header: /devl/xcs/repo/env/Databases/CAEInterfaces/versclibs/data/X_BUFGMUX.v,v 1.3 2003/01/21 02:38:33 wloo Exp $

`timescale 1 ps/1 ps

module X_BUFGMUX (O, GSR, I0, I1, S);

    output O;

    input  GSR, I0, I1, S;

    reg q0, q1;
    reg q0_enable, q1_enable;
    wire gsr_in, i0_in, i1_in, s_in;
    wire o_out;
    reg notifier;

    buf B0 (gsr_in, GSR);
    buf B1 (i0_in, I0);
    buf B2 (i1_in, I1);
    buf B3 (s_in, S);
    buf B4 (O, o_out);

    bufif1 BI0 (o_out, i0_in, q0);
    bufif1 BI1 (o_out, i1_in, q1);
    pulldown P1 (o_out);

	always @(gsr_in or i0_in or s_in or q0_enable)
 	    if (gsr_in)
		q0 <= 1;
 	    else if (!i0_in)
		q0 <= !s_in && q0_enable;

	always @(gsr_in or i1_in or s_in or q1_enable)
 	    if (gsr_in)
		q1 <= 0;
 	    else if (!i1_in)
		q1 <= s_in && q1_enable;

	always @(gsr_in or q1 or i0_in)
 	    if (gsr_in)
		q0_enable <= 1;
	    else if (q1)
		q0_enable <= 0;
	    else if (i0_in)
		q0_enable <= !q1;

	always @(gsr_in or q0 or i1_in)
 	    if (gsr_in)
		q1_enable <= 0;
	    else if (q0)
		q1_enable <= 0;
	    else if (i1_in)
		q1_enable <= !q0;

    specify

	(I0 => O) = (0:0:0, 0:0:0);
	(I1 => O) = (0:0:0, 0:0:0);
	$setuphold (posedge I0, posedge S, 0:0:0, 0:0:0, notifier);
	$setuphold (posedge I0, negedge S, 0:0:0, 0:0:0, notifier);
	$setuphold (posedge I1, posedge S, 0:0:0, 0:0:0, notifier);
	$setuphold (posedge I1, negedge S, 0:0:0, 0:0:0, notifier);
	specparam PATHPULSE$ = 0;

    endspecify

endmodule
