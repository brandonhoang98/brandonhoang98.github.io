//    Xilinx Proprietary Primitive Cell X_RAMD32 for Verilog
//
// $Header: /devl/xcs/repo/env/Databases/CAEInterfaces/versclibs/data/X_RAMD32.v,v 1.15 2003/01/21 02:38:44 wloo Exp $
//

`timescale 1 ps/1 ps

module X_RAMD32 (O, CLK, I, RADR0, RADR1, RADR2, RADR3, RADR4, WADR0, WADR1, WADR2, WADR3, WADR4, WE);

  parameter INIT = 32'h00000000;

  output O;
  input CLK, I, RADR0, RADR1, RADR2, RADR3, RADR4, WADR0, WADR1, WADR2, WADR3, WADR4, WE;

  reg [31:0] mem;
  wire [4:0] wadr;
  wire [4:0] radr;
  wire in, we, clk;
  reg o_out;
  reg notifier;

  buf b1 (in, I);
  buf b2 (clk, CLK);
  buf b3 (we ,WE);
  buf b4 (wadr[4],WADR4);
  buf b5 (wadr[3],WADR3);
  buf b6 (wadr[2],WADR2);
  buf b7 (wadr[1],WADR1);
  buf b8 (wadr[0],WADR0);
  buf b9 (radr[4],RADR4);
  buf bA (radr[3],RADR3);
  buf bB (radr[2],RADR2);
  buf bC (radr[1],RADR1);
  buf bD (radr[0],RADR0);
  buf bE (O, o_out);

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
	(RADR4 => O) = (0:0:0, 0:0:0);

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
	$setuphold (posedge CLK, posedge WADR4 &&& WE, 0:0:0, 0:0:0, notifier);
	$setuphold (posedge CLK, negedge WADR4 &&& WE, 0:0:0, 0:0:0, notifier);
	$setuphold (posedge CLK, posedge WE, 0:0:0, 0:0:0, notifier);
	$setuphold (posedge CLK, negedge WE, 0:0:0, 0:0:0, notifier);

	$width (posedge CLK &&& WE, 0:0:0, 0, notifier);
	$width (negedge CLK &&& WE, 0:0:0, 0, notifier);

	specparam PATHPULSE$ = 0;

  endspecify

endmodule
