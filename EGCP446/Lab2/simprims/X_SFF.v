//    Xilinx Proprietary Primitive Cell X_SFF for Verilog
//
// $Header: /devl/xcs/repo/env/Databases/CAEInterfaces/versclibs/data/X_SFF.v,v 1.23.2.2 2003/08/08 18:59:09 wloo Exp $
//

`timescale 1 ps/1 ps
 
module X_SFF (O, CE, CLK, I, RST, SET, SRST, SSET);

  parameter INIT = 1'b0;

  output O;
  input CE, CLK, I, RST, SET, SRST, SSET;

  wire ni, nrst, nset, nsrst, nsset, in_out;
  wire in_clk_enable, ce_clk_enable, rst_clk_enable, set_clk_enable;
  wire srst_clk_enable, sset_clk_enable;

  reg o_out;
  reg clk_next, clk_prev;
  reg notifier_next, notifier_prev;
  reg notifier;

  not (ni, I);
  not (nrst, RST);
  not (nset, SET);
  not (nsrst, SRST);
  not (nsset, SSET);
  xor (in_out, I, O);
  
  and (in_clk_enable, nrst, nset, nsrst, nsset, CE);
  and (ce_clk_enable, nrst, nset, nsrst, nsset, in_out);
  and (rst_clk_enable, CE, I);
  and (set_clk_enable, CE, nrst, ni);
  and (srst_clk_enable, nrst, nset, nsrst);
  and (sset_clk_enable, nrst, nset);

  buf (ce_in, CE);
  buf (clk_in, CLK);
  buf (i_in, I);
  buf (rst_in, RST);
  buf (set_in, SET);
  buf (srst_in, SRST);
  buf (sset_in, SSET);
  buf (O, o_out);

    always @ (clk_in) begin
	clk_prev = clk_next;
	clk_next = clk_in;
    end

    always @ (notifier) begin
	notifier_prev = notifier_next;
	notifier_next = notifier;
    end

    always @ (set_in or rst_in) begin
	if (rst_in === 1)
	    assign o_out = 0;
	else if ((set_in === 1) && (rst_in === 0))
	    assign o_out = 1;
	else if ((set_in === 0) && (rst_in === 0))
	    deassign o_out;
	else if ((set_in === 1) && (rst_in === 1'bx))
	    assign o_out = 1'bx;
	else if ((set_in === 1'bx) && (rst_in === 1))
	    assign o_out = 1'bx;
	else if ((set_in === 1'bx) && (rst_in === 1'bx))
	    assign o_out = 1'bx;
	else if ((set_in === 0) && (rst_in === 1'bx) && (o_out === 0)) begin
	    assign o_out = 0;
	    deassign o_out;
	end
	else if ((set_in === 1'bx) && (rst_in === 0) && (o_out === 1)) begin
	    assign o_out = 1;
	    deassign o_out;
	end
	else if ((set_in === 0) && (rst_in === 1'bx)) begin
	    assign o_out = 1'bx;
	    deassign o_out;
	end
	else if ((set_in === 1'bx) && (rst_in === 0)) begin
	    assign o_out = 1'bx;
	    deassign o_out;
	end
    end

    always @ (notifier_next) begin
	if (notifier_prev != notifier_next)
	    o_out <= 1'bx;
    end

    always @ (clk_next) begin
	if ((clk_prev === 0) && (clk_next === 1) && (set_in === 0) && (rst_in === 0) && (srst_in === 1))
	    o_out <= 0;
	else if ((clk_prev === 0) && (clk_next === 1) && (set_in === 0) && (rst_in === 0) && (sset_in === 1) && (srst_in === 0))
	    o_out <= 1;
	else if (((clk_prev === 0) || (clk_next === 1)) && (set_in === 0) && (rst_in === 0) && (srst_in === 1) && (o_out === 0))
	    o_out <= 0;
	else if (((clk_prev === 0) || (clk_next === 1)) && (set_in === 0) && (rst_in === 0) && (sset_in === 1) && (srst_in === 0) && (o_out === 1))
	    o_out <= 1;

	else if ((clk_prev === 0) && (clk_next === 1) && (ce_in === 1) && (set_in === 0) && (rst_in === 0) && (sset_in === 0) && (srst_in === 0))
	    o_out <= i_in;
	else if ((clk_prev === 0) && (clk_next === 1) && (i_in === 0) && (ce_in === 1'bx) && (set_in === 0) && (rst_in === 0) && (sset_in === 0) && (srst_in === 0) && (o_out === 0))
	    o_out <= 0;
	else if ((clk_prev === 0) && (clk_next === 1) && (i_in === 1) && (ce_in === 1'bx) && (set_in === 0) && (rst_in === 0) && (sset_in === 0) && (srst_in === 0) && (o_out === 1))
	    o_out <= 1;

	else if ((ce_in === 0) && (sset_in === 0) && (srst_in === 0))
	    o_out <= o_out;
	else if (clk_prev === 1)
	    o_out <= o_out;
	else if (clk_next === 0)
	    o_out <= o_out;

	else if ((clk_prev === 0) && (clk_next === 1) && (ce_in === 0) && (set_in === 0) && (rst_in === 0) && (sset_in === 0) && (srst_in === 1'bx) && (o_out === 0))
	    o_out <= 0;
	else if ((clk_prev === 0) && (clk_next === 1) && (i_in === 0) && (ce_in === 1) && (set_in === 0) && (rst_in === 0) && (sset_in === 0) && (srst_in === 1'bx))
	    o_out <= 0;
	else if ((clk_prev === 0) && (clk_next === 1) && (ce_in === 0) && (set_in === 0) && (rst_in === 0) && (sset_in === 1'bx) && (srst_in === 0) && (o_out === 1))
	    o_out <= 1;
	else if ((clk_prev === 0) && (clk_next === 1) && (i_in === 1) && (ce_in === 1) && (set_in === 0) && (rst_in === 0) && (sset_in === 1'bx) && (srst_in === 0))
	    o_out <= 1;

	else if (((clk_prev === 0) || (clk_next === 1)) && (ce_in === 0) && (set_in === 0) && (rst_in === 0) && (sset_in === 0) && (srst_in === 1'bx) && (o_out === 0))
	    o_out <= 0;
	else if (((clk_prev === 0) || (clk_next === 1)) && (ce_in === 0) && (set_in === 0) && (rst_in === 0) && (sset_in === 1'bx) && (srst_in === 0) && (o_out === 1))
	    o_out <= 1;

	else if ((clk_prev === 0) && (clk_next === 1) && (i_in === 0) && (set_in === 0) && (rst_in === 1'bx) && (sset_in === 0) && (srst_in === 0) && (o_out === 0))
	    o_out <= 0;
	else if ((clk_prev === 0) && (clk_next === 1) && (ce_in === 0) && (set_in === 0) && (rst_in === 1'bx) && (sset_in === 0) && (srst_in === 1'bx) && (o_out === 0))
	    o_out <= 0;
	else if ((clk_prev === 0) && (clk_next === 1) && (i_in === 0) && (set_in === 0) && (rst_in === 1'bx) && (sset_in === 0) && (srst_in === 1'bx) && (o_out === 0))
	    o_out <= 0;
	else if ((clk_prev === 0) && (clk_next === 1) && (set_in === 0) && (rst_in === 1'bx) && (srst_in === 1))
	    o_out <= 0;
	else if ((clk_prev === 0) && (clk_next === 1) && (i_in === 0) && (ce_in === 1) && (set_in === 0) && (rst_in === 1'bx) && (sset_in === 0))
	    o_out <= 0;

	else if (((clk_prev === 0) || (clk_next === 1)) && (i_in === 0) && (set_in === 0) && (rst_in === 1'bx) && (sset_in === 0) && (srst_in === 0) && (o_out === 0))
	    o_out <= 0;
	else if (((clk_prev === 0) || (clk_next === 1)) && (ce_in === 0) && (set_in === 0) && (rst_in === 1'bx) && (sset_in === 0) && (srst_in === 1'bx) && (o_out === 0))
	    o_out <= 0;
	else if (((clk_prev === 0) || (clk_next === 1)) && (i_in === 0) && (set_in === 0) && (rst_in === 1'bx) && (sset_in === 0) && (srst_in === 1'bx) && (o_out === 0))
	    o_out <= 0;
	else if (((clk_prev === 0) || (clk_next === 1)) && (set_in === 0) && (rst_in === 1'bx) && (srst_in === 1) && (o_out === 0))
	    o_out <= 0;

	else if ((clk_prev === 0) && (clk_next === 1) && (i_in === 1) && (set_in === 1'bx) && (rst_in === 0) && (sset_in === 0) && (srst_in === 0) && (o_out === 1))
	    o_out <= 1;
	else if ((clk_prev === 0) && (clk_next === 1) && (ce_in === 0) && (set_in === 1'bx) && (rst_in === 0) && (sset_in === 1'bx) && (srst_in === 0) && (o_out === 1))
	    o_out <= 1;
	else if ((clk_prev === 0) && (clk_next === 1) && (i_in === 1) && (set_in === 1'bx) && (rst_in === 0) && (sset_in === 1'bx) && (srst_in === 0) && (o_out === 1))
	    o_out <= 1;
	else if ((clk_prev === 0) && (clk_next === 1) && (set_in === 1'bx) && (rst_in === 0) && (sset_in === 1) && (srst_in === 0))
	    o_out <= 1;
	else if ((clk_prev === 0) && (clk_next === 1) && (i_in === 1) && (ce_in === 1) && (set_in === 1'bx) && (rst_in === 0) && (srst_in === 0))
	    o_out <= 1;

	else if (((clk_prev === 0) || (clk_next === 1)) && (i_in === 1) && (set_in === 1'bx) && (rst_in === 0) && (sset_in === 0) && (srst_in === 0) && (o_out === 1))
	    o_out <= 1;
	else if (((clk_prev === 0) || (clk_next === 1)) && (ce_in === 0) && (set_in === 1'bx) && (rst_in === 0) && (sset_in === 1'bx) && (srst_in === 0) && (o_out === 1))
	    o_out <= 1;
	else if (((clk_prev === 0) || (clk_next === 1)) && (i_in === 1) && (set_in === 1'bx) && (rst_in === 0) && (sset_in === 1'bx) && (srst_in === 0) && (o_out === 1))
	    o_out <= 1;
	else if (((clk_prev === 0) || (clk_next === 1)) && (set_in === 1'bx) && (rst_in === 0) && (sset_in === 1) && (srst_in === 0) && (o_out === 1))
	    o_out <= 1;

        else if (((clk_prev === 0) || (clk_next === 1)) && (i_in === 0) && (set_in === 0) && (sset_in === 0) && (o_out === 0))
            o_out <= 0;
        else if (((clk_prev === 0) || (clk_next === 1)) && (i_in === 1) && (rst_in === 0) && (srst_in === 0) && (o_out === 1))
            o_out <= 1;

	else if ((clk_prev === 0) && (clk_next === 1) && (rst_in === 1))
            o_out <= 0;
	else if ((clk_prev === 0) && (clk_next === 1) && (set_in === 1) && (rst_in === 0))
            o_out <= 1;

	else
	    o_out <= 1'bx;
    end

  specify

	(CLK => O) = (0:0:0, 0:0:0);
	(SET => O) = (0:0:0, 0:0:0);
	(RST => O) = (0:0:0, 0:0:0);

	$setuphold (posedge CLK, posedge CE &&& (ce_clk_enable!=0), 0:0:0, 0:0:0, notifier);
	$setuphold (posedge CLK, negedge CE &&& (ce_clk_enable!=0), 0:0:0, 0:0:0, notifier);
	$setuphold (posedge CLK, posedge I &&& (in_clk_enable!=0), 0:0:0, 0:0:0, notifier);
	$setuphold (posedge CLK, negedge I &&& (in_clk_enable!=0), 0:0:0, 0:0:0, notifier);
	$setuphold (posedge CLK, posedge SRST &&& (srst_clk_enable!=0), 0:0:0, 0:0:0, notifier);
	$setuphold (posedge CLK, negedge SRST &&& (srst_clk_enable!=0), 0:0:0, 0:0:0, notifier);
	$setuphold (posedge CLK, posedge SSET &&& (sset_clk_enable!=0), 0:0:0, 0:0:0, notifier);
	$setuphold (posedge CLK, negedge SSET &&& (sset_clk_enable!=0), 0:0:0, 0:0:0, notifier);

	$recrem (negedge RST, posedge CLK &&& (rst_clk_enable!=0), 0:0:0, 0:0:0, notifier);
	$recrem (negedge SET, posedge CLK &&& (set_clk_enable!=0), 0:0:0, 0:0:0, notifier);

	$width (posedge CLK, 0:0:0, 0, notifier);
	$width (negedge CLK, 0:0:0, 0, notifier);
	$width (posedge RST, 0:0:0, 0, notifier);
	$width (posedge SET, 0:0:0, 0, notifier);

	specparam PATHPULSE$ = 0;

  endspecify

endmodule

