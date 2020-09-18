//    Xilinx Proprietary Primitive Cell X_RAMD16 for Verilog
//
// $Header: /devl/xcs/repo/env/Databases/CAEInterfaces/versclibs/data/X_RAMD16.v,v 1.16 2003/01/21 02:38:44 wloo Exp $
//

`timescale 1 ps/1 ps

module X_RAMD16 (O, CLK, I, RADR0, RADR1, RADR2, RADR3, WADR0, WADR1, WADR2, WADR3, WE);

  parameter INIT = 16'h0000;

  output O;
  input CLK, I, RADR0, RADR1, RADR2, RADR3, WADR0, WADR1, WADR2, WADR3, WE;

  reg [15:0] mem;
  wire [3:0] wadr;
  wire [3:0] radr;
  wire in, we, clk;
  reg o_out;
  reg notifier;

  buf b1 (in, I);
  buf b2 (clk, CLK);
  buf b3 (we ,WE);
  buf b4 (wadr[3],WADR3);
  buf b5 (wadr[2],WADR2);
  buf b6 (wadr[1],WADR1);
  buf b7 (wadr[0],WADR0);
  buf b8 (radr[3],RADR3);
  buf b9 (radr[2],RADR2);
  buf bA (radr[1],RADR1);
  buf bB (radr[0],RADR0);
  buf bC (O, o_out);

  initial begin
    mem <= INIT;
  end

  always @(posedge clk) begin
    if (we == 1'b1)
      mem[wadr] <= in;
  end

  always @(mem or radr) begin
    o_out <= mem[radr];
  end

  always @(notifier) begin
    mem[wadr] <= 1'bx;
  end

  specify

	(CLK => O) = (0:0:0, 0:0:0);
	(RADR0 => O) = (0:0:0, 0:0:0);
	(RADR1 => O) = (0:0:0, 0:0:0);
	(RADR2 => O) = (0:0:0, 0:0:0);
	(RADR3 => O) = (0:0:0, 0:0:0);

	$setuphold (posedge CLK, posedge I &&& WE, 0:0:0, 0:0:0, notifier);
	$setuphold (posedge CLK, negedge I &&& WE, 0:0:0, 0:0:0, notifier);
	$setuphold (posedge CLK, posedge WADR0 &&& WE, 0:0:0, 0:0:0, notifier);
	$setuphold (posedge CLK, negedge WADR0 &&& WE, 0:0:0, 0:0:0, notifier);
	$setuphold (posedge CLK, posedge WADR1 &&& WE, 0:0:0, 0:0:0, notifier);
	$setuphold (posedge CLK, negedge WADR1 &&& WE, 0:0:0, 0:0:0, notifier);
	$setuphold (posedge CLK, posedge WADR2 &&& WE, 0:0:0, 0:0:0, notifier);
	$setuphold (posedge CLK, negedge WADR2 &&& WE, 0:0:0, 0:0:0, notifier);
	$setuphold (posedge CLK, posedge WADR3 &&& WE, 0:0:0, 0:0:0, notifier);
	$setuphold (posedge CLK, negedge WADR3 &&& WE, 0:0:0, 0:0:0, notifier);
	$setuphold (posedge CLK, posedge WE, 0:0:0, 0:0:0, notifier);
	$setuphold (posedge CLK, negedge WE, 0:0:0, 0:0:0, notifier);

	$width (posedge CLK &&& WE, 0:0:0, 0, notifier);
	$width (negedge CLK &&& WE, 0:0:0, 0, notifier);

	specparam PATHPULSE$ = 0;

  endspecify

endmodule
