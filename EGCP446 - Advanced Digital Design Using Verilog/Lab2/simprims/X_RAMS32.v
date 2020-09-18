//    Xilinx Proprietary Primitive Cell X_RAMS32 for Verilog
//
// $Header: /devl/xcs/repo/env/Databases/CAEInterfaces/versclibs/data/X_RAMS32.v,v 1.15 2003/01/21 02:38:44 wloo Exp $
//

`timescale 1 ps/1 ps

module X_RAMS32 (O, ADR0, ADR1, ADR2, ADR3, ADR4, CLK, I, WE);

  parameter INIT = 32'h00000000;

  output O;
  input ADR0, ADR1, ADR2, ADR3, ADR4, CLK, I, WE;

  reg [31:0] mem;
  wire [4:0] adr;

  wire in, we, clk;
  reg o_out;
  reg notifier;

  buf b1 (in, I);
  buf b2 (clk, CLK);
  buf b3 (we ,WE);
  buf b4 (adr[4],ADR4);
  buf b5 (adr[3],ADR3);
  buf b6 (adr[2],ADR2);
  buf b7 (adr[1],ADR1);
  buf b8 (adr[0],ADR0);
  buf b9 (O, o_out);

  initial begin
    mem <= INIT;
  end

  always @(posedge clk) begin
    if (we == 1'b1)
      mem[adr] <= in;
  end

  always @(mem or adr) begin
    o_out <= mem[adr];
  end

  always @(notifier) begin
    mem[adr] <= 1'bx;
  end

  specify

	(CLK => O) = (0:0:0, 0:0:0);
	(ADR0 => O) = (0:0:0, 0:0:0);
	(ADR1 => O) = (0:0:0, 0:0:0);
	(ADR2 => O) = (0:0:0, 0:0:0);
	(ADR3 => O) = (0:0:0, 0:0:0);
	(ADR4 => O) = (0:0:0, 0:0:0);

	$setuphold (posedge CLK, posedge I &&& WE, 0:0:0, 0:0:0, notifier);
	$setuphold (posedge CLK, negedge I &&& WE, 0:0:0, 0:0:0, notifier);
	$setuphold (posedge CLK, posedge ADR0 &&& WE, 0:0:0, 0:0:0, notifier);
	$setuphold (posedge CLK, negedge ADR0 &&& WE, 0:0:0, 0:0:0, notifier);
	$setuphold (posedge CLK, posedge ADR1 &&& WE, 0:0:0, 0:0:0, notifier);
	$setuphold (posedge CLK, negedge ADR1 &&& WE, 0:0:0, 0:0:0, notifier);
	$setuphold (posedge CLK, posedge ADR2 &&& WE, 0:0:0, 0:0:0, notifier);
	$setuphold (posedge CLK, negedge ADR2 &&& WE, 0:0:0, 0:0:0, notifier);
	$setuphold (posedge CLK, posedge ADR3 &&& WE, 0:0:0, 0:0:0, notifier);
	$setuphold (posedge CLK, negedge ADR3 &&& WE, 0:0:0, 0:0:0, notifier);
	$setuphold (posedge CLK, posedge ADR4 &&& WE, 0:0:0, 0:0:0, notifier);
	$setuphold (posedge CLK, negedge ADR4 &&& WE, 0:0:0, 0:0:0, notifier);
	$setuphold (posedge CLK, posedge WE, 0:0:0, 0:0:0, notifier);
	$setuphold (posedge CLK, negedge WE, 0:0:0, 0:0:0, notifier);

	$width (posedge CLK &&& WE, 0:0:0, 0, notifier);
	$width (negedge CLK &&& WE, 0:0:0, 0, notifier);

	specparam PATHPULSE$ = 0;

  endspecify

endmodule
