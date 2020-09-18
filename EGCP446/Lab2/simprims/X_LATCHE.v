//    Xilinx Proprietary Primitive Cell X_LATCHE for Verilog
//
// $Header: /devl/xcs/repo/env/Databases/CAEInterfaces/versclibs/data/X_LATCHE.v,v 1.16.20.1 2003/08/22 22:39:00 wloo Exp $
//

`timescale 1 ps/1 ps
 
module X_LATCHE (O, CLK, GE, I, RST, SET);

  parameter INIT = 1'b0;

  output O;
  input CLK, GE, I, RST, SET;

  wire nrst, nset, in_out;
  wire in_clk_enable, ge_clk_enable, set_clk_enable;

  reg o_out;
  reg notifier_next, notifier_prev;
  reg notifier;

  not (nrst, RST);
  not (nset, SET);
  xor (in_out, I, O);

  and (in_clk_enable, nrst, nset, GE);
  and (ge_clk_enable, nrst, nset, in_out);
  and (set_clk_enable, nrst, GE);

  buf (ge_in, GE);
  buf (clk_in, CLK);
  buf (i_in, I);
  buf (rst_in, RST);
  buf (set_in, SET);
  buf (O, o_out);

    always @ (notifier) begin
	notifier_prev = notifier_next;
	notifier_next = notifier;
    end

    always @ (set_in or rst_in) begin
	if (rst_in === 1)
	    assign o_out = 0;
	else if ((set_in === 1) && (rst_in === 0))
	    assign o_out = 1;
	else if ((set_in === 1'bx) && (rst_in === 1'bx)) begin
	    assign o_out = 1'bx;
	    deassign o_out;
	end
	else begin
	    assign o_out = o_out;
	    deassign o_out;
	end
    end

    always @ (notifier_next) begin
	if (notifier_prev != notifier_next)
	    o_out <= 1'bx;
    end

    always @(clk_in or ge_in or i_in) begin
	if ((clk_in === 1'b1) && (ge_in === 1'b1) && (set_in === 1'b0) && (rst_in === 1'b0))
	    o_out <= i_in;

	else if (((clk_in === 1'b0) || (ge_in === 1'b0)) && (set_in === 1'b0) && (rst_in === 1'b0))
	    o_out <= o_out;

	else if ((i_in === 1'b0) && (set_in === 1'b0) && (o_out === 1'b0))
	    o_out <= o_out;
	else if ((i_in === 1'b1) && (rst_in === 1'b0) && (o_out === 1'b1))
	    o_out <= o_out;

	else if (((clk_in === 1'b0) || (ge_in === 1'b0)) && (set_in === 1'b0) && (rst_in === 1'bx) && (o_out === 1'b0))
	    o_out <= 1'b0;
	else if ((clk_in === 1'b1) && (i_in === 1'b0) && (set_in === 1'b0) && (rst_in === 1'bx) && (ge_in === 1'b1))
	    o_out <= 1'b0;

	else if (((clk_in === 1'b0) || (ge_in === 1'b0)) && (set_in === 1'bx) && (rst_in === 1'b0) && (o_out === 1'b1))
	    o_out <= 1'b1;
	else if ((clk_in === 1'b1) && (i_in === 1'b1) && (ge_in === 1'b1) && (set_in === 1'bx) && (rst_in === 1'b0))
	    o_out <= 1'b1;

	else
	    o_out <= 1'bx;
    end

  specify

	(I => O) = (0:0:0, 0:0:0);
	(CLK => O) = (0:0:0, 0:0:0);
	(GE => O) = (0:0:0, 0:0:0);
	(SET => O) = (0:0:0, 0:0:0);
	(RST => O) = (0:0:0, 0:0:0);

	$setuphold (negedge CLK, posedge GE &&& ge_clk_enable, 0:0:0, 0:0:0, notifier);
	$setuphold (negedge CLK, negedge GE &&& ge_clk_enable, 0:0:0, 0:0:0, notifier);
	$setuphold (negedge CLK, posedge I &&& in_clk_enable, 0:0:0, 0:0:0, notifier);
	$setuphold (negedge CLK, negedge I &&& in_clk_enable, 0:0:0, 0:0:0, notifier);

	$recrem (negedge RST, negedge CLK &&& GE, 0:0:0, 0:0:0, notifier);
	$recrem (negedge SET, negedge CLK &&& set_clk_enable, 0:0:0, 0:0:0, notifier);

	$width (posedge CLK, 0:0:0, 0, notifier);
	$width (posedge GE, 0:0:0, 0, notifier);
	$width (posedge RST, 0:0:0, 0, notifier);
	$width (posedge SET, 0:0:0, 0, notifier);

	specparam PATHPULSE$ = 0;

  endspecify

endmodule
