// $Header: /devl/xcs/repo/env/Databases/CAEInterfaces/versclibs/data/X_FDDRRSE.v,v 1.2 2003/02/14 00:30:10 patrickp Exp $


`timescale  1 ps / 1 ps

module X_FDDRRSE (Q, C0, C1, CE, D0, D1, GSR, R, S);

    parameter INIT = 1'b0;

    output Q;
    reg notifier;
    reg    q_out;

    input  C0, C1, CE, D0, D1, GSR, R, S;

    buf B1 (Q, q_out);
    buf B2 (c0_in, C0);
    buf B3 (c1_in, C1);
    buf B4 (r_in, R);
    buf B5 (gsr_in, GSR);
    buf B6 (s_in, S);

	always @(gsr_in)
	    if (gsr_in)
		assign q_out = 0;
	    else
		deassign q_out;

	always @(posedge c0_in)
	    if (r_in)
		q_out <= 0;
	    else if (s_in)
		q_out <= 1;
	    else if (CE)
		q_out <= D0;

	always @(posedge c1_in)
	    if (r_in)
		q_out <= 0;
	    else if (s_in)
		q_out <= 1;
	    else if (CE)
		q_out <= D1;


    not (nr, R);
    not (ns, S);
    not (ngsr, GSR);
    xor (in_out0, D0, Q);
    xor (in_out1, D1, Q);

    and (s_enable, ngsr, nr);
    and (in_clk_enable, ngsr, nr, ns, CE);
    and (ce_clk_enable0, ngsr, nr, ns, in_out0);
    and (ce_clk_enable1, ngsr, nr, ns, in_out1);

    always @(notifier) begin
       q_out <= 1'bx;
    end


    specify

	(C0 => Q) = (0:0:0, 0:0:0);
	(C1 => Q) = (0:0:0, 0:0:0);
	(GSR => Q) = (0:0:0, 0:0:0);

	$setuphold (posedge C0, posedge CE &&& (ce_clk_enable0!=0), 0:0:0, 0:0:0, notifier);
	$setuphold (posedge C1, posedge CE &&& (ce_clk_enable1!=0), 0:0:0, 0:0:0, notifier);
	$setuphold (posedge C0, negedge CE &&& (ce_clk_enable0!=0), 0:0:0, 0:0:0, notifier);
	$setuphold (posedge C1, negedge CE &&& (ce_clk_enable1!=0), 0:0:0, 0:0:0, notifier);

	$setuphold (posedge C0, posedge D0 &&& (in_clk_enable!=0), 0:0:0, 0:0:0, notifier);
	$setuphold (posedge C1, posedge D1 &&& (in_clk_enable!=0), 0:0:0, 0:0:0, notifier);
	$setuphold (posedge C0, negedge D0 &&& (in_clk_enable!=0), 0:0:0, 0:0:0, notifier);
	$setuphold (posedge C1, negedge D1 &&& (in_clk_enable!=0), 0:0:0, 0:0:0, notifier);

	$setuphold (posedge C0, posedge R &&& (GSR==0), 0:0:0, 0:0:0, notifier);
	$setuphold (posedge C0, negedge R &&& (GSR==0), 0:0:0, 0:0:0, notifier);
	$setuphold (posedge C1, posedge R &&& (GSR==0), 0:0:0, 0:0:0, notifier);
	$setuphold (posedge C1, negedge R &&& (GSR==0), 0:0:0, 0:0:0, notifier);

	$setuphold (posedge C0, posedge S &&& (s_enable!=0), 0:0:0, 0:0:0, notifier);
	$setuphold (posedge C0, negedge S &&& (s_enable!=0), 0:0:0, 0:0:0, notifier);
	$setuphold (posedge C1, posedge S &&& (s_enable!=0), 0:0:0, 0:0:0, notifier);
	$setuphold (posedge C1, negedge S &&& (s_enable!=0), 0:0:0, 0:0:0, notifier);

	$recrem (negedge GSR, posedge C0, 0:0:0, 0:0:0, notifier);
	$recrem (negedge GSR, posedge C1, 0:0:0, 0:0:0, notifier);

	$width (posedge C0, 0:0:0, 0, notifier);
	$width (negedge C0, 0:0:0, 0, notifier);
	$width (posedge C1, 0:0:0, 0, notifier);
	$width (negedge C1, 0:0:0, 0, notifier);
	$width (posedge R, 0:0:0, 0, notifier);
	$width (posedge S, 0:0:0, 0, notifier);
	$width (posedge GSR, 0:0:0, 0, notifier);

	specparam PATHPULSE$ = 0;

    endspecify

endmodule

