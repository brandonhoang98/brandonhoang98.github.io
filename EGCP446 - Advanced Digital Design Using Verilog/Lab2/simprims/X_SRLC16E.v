//    Xilinx Proprietary Primitive Cell X_SRLC16E for Verilog
//
// $Header: /devl/xcs/repo/env/Databases/CAEInterfaces/versclibs/data/X_SRLC16E.v,v 1.16 2003/01/21 02:38:44 wloo Exp $
//

`timescale 1 ps/1 ps

module X_SRLC16E (Q, Q15, A0, A1, A2, A3, CE, CLK, D);

  parameter INIT = 16'h0000;

  output Q, Q15;
  input  A0, A1, A2, A3, CE, CLK, D;

  reg  [5:0]  count;
  reg  [15:0] data;
  wire [3:0]  addr;
  wire d_in, ce_in, clk_in;
  reg  q_out, q15_out;
  reg notifier;

  buf b_d (d_in, D);
  buf b_ce (ce_in, CE);
  buf b_clk (clk_in, CLK);

  buf b_a3 (addr[3], A3);
  buf b_a2 (addr[2], A2);
  buf b_a1 (addr[1], A1);
  buf b_a0 (addr[0], A0);

  buf b_q (Q, q_out);
  buf b_q15 (Q15, q15_out);

  initial begin
    while (clk_in === 1'bx)
      #1000;
    for (count = 0; count < 16; count = count + 1)
      data[count] <= INIT[count];
  end

  always @(posedge clk_in) begin
    if (ce_in == 1'b1) begin
      {data[15:0]} <= {data[14:0], d_in};
    end
  end

  always @(data or addr) begin
    q_out <= data[addr];
    q15_out <= data[15];
  end

  always @(notifier) begin
    data[0] <= 1'bx;
  end

  specify

	(A0 => Q) = (0:0:0, 0:0:0);
	(A1 => Q) = (0:0:0, 0:0:0);
	(A2 => Q) = (0:0:0, 0:0:0);
	(A3 => Q) = (0:0:0, 0:0:0);
	(CLK => Q) = (0:0:0, 0:0:0);
	(CLK => Q15) = (0:0:0, 0:0:0);

	$setuphold (posedge CLK, posedge D &&& CE, 0:0:0, 0:0:0, notifier);
	$setuphold (posedge CLK, negedge D &&& CE, 0:0:0, 0:0:0, notifier);
	$setuphold (posedge CLK, posedge CE, 0:0:0, 0:0:0, notifier);
	$setuphold (posedge CLK, negedge CE, 0:0:0, 0:0:0, notifier);

	$width (posedge CLK, 0:0:0, 0, notifier);
	$width (negedge CLK, 0:0:0, 0, notifier);

	specparam PATHPULSE$ = 0;

  endspecify

endmodule
