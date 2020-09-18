//    Xilinx Proprietary Primitive Cell X_FF for Verilog
//
// $Header: 
//

`timescale 1 ps/1 ps
 
module X_FF (O, CE, CLK, I, RST, SET);

  parameter INIT = 1'b0;

  output O;
  input CE, CLK, I, RST, SET;

  wire ni, nrst, nset, in_out;
  wire in_clk_enable, ce_clk_enable, rst_clk_enable, set_clk_enable;

  reg o_out;
  reg clk_next, clk_prev;
  reg notifier_next, notifier_prev;
  reg notifier;

  not (ni, I);
  not (nrst, RST);
  not (nset, SET);
  xor (in_out, I, O);

  and (in_clk_enable, nrst, nset, CE);
  and (ce_clk_enable, nrst, nset, in_out);
  and (rst_clk_enable, CE, I);
  and (set_clk_enable, CE, nrst, ni);

  buf (ce_in, CE);
  buf (clk_in, CLK);
  buf (i_in, I);
  buf (rst_in, RST);
  buf (set_in, SET);
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
	if ((clk_prev === 0) && (clk_next === 1) && (ce_in === 1) && (set_in === 0) && (rst_in === 0))
	    o_out <= i_in;

	else if (ce_in === 0)
	    o_out <= o_out;
	else if (clk_prev === 1)
	    o_out <= o_out;
	else if (clk_next === 0)
	    o_out <= o_out;

	else if ((clk_prev === 0) && (clk_next === 1) && (i_in === 0) && (ce_in === 1) && (set_in === 0))
	    o_out <= 0;
	else if ((clk_prev === 0) && (clk_next === 1) && (i_in === 1) && (ce_in === 1) && (rst_in === 0))
	    o_out <= 1;

	else if ((clk_prev === 0) && (clk_next === 1) && (i_in === 0) && (o_out === 0) && (ce_in === 1'bx) && (set_in === 0) && (rst_in === 1'bx))
	    o_out <= 0;
	else if ((clk_prev === 0) && (clk_next === 1) && (i_in === 1) && (o_out === 0) && (ce_in === 1'bx) && (set_in === 1'bx) && (rst_in === 0))
	    o_out <= 1;

	else if (((clk_prev === 0) || (clk_next === 1)) && (i_in === o_out) && (set_in === 0) && (rst_in === 0))
	    o_out <= o_out;

	else if (((clk_prev === 0) || (clk_next === 1)) && (i_in === 0) && (o_out === 0) && (ce_in === 1) && (set_in === 0) && (rst_in === 1'bx))
	    o_out <= 0;
	else if (((clk_prev === 0) || (clk_next === 1)) && (i_in === 1) && (o_out === 1) && (ce_in === 1) && (set_in === 1'bx) && (rst_in === 0))
	    o_out <= 1;

	else if (((clk_prev === 0) || (clk_next === 1)) && (i_in === 0) && (o_out === 0) && (ce_in === 1'bx) && (set_in === 0) && (rst_in === 1'bx))
	    o_out <= 0;
	else if (((clk_prev === 0) || (clk_next === 1)) && (i_in === 1) && (o_out === 1) && (ce_in === 1'bx) && (set_in === 1'bx) && (rst_in === 0))
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

	$recrem (negedge RST, posedge CLK &&& (rst_clk_enable!=0), 0:0:0, 0:0:0, notifier);
	$recrem (negedge SET, posedge CLK &&& (set_clk_enable!=0), 0:0:0, 0:0:0, notifier);

	$width (posedge CLK &&& CE, 0:0:0, 0, notifier);
	$width (negedge CLK &&& CE, 0:0:0, 0, notifier);
	$width (posedge RST, 0:0:0, 0, notifier);
	$width (posedge SET, 0:0:0, 0, notifier);

	specparam PATHPULSE$ = 0;

  endspecify

endmodule
