//    Xilinx Proprietary Primitive Cell X_RAMB4_S2 for Verilog
//
// $Header: /devl/xcs/repo/env/Databases/CAEInterfaces/versclibs/data/X_RAMB4_S2.v,v 1.17 2003/01/21 02:38:42 wloo Exp $
//

`timescale 1 ps/1 ps

module X_RAMB4_S2 (DO, ADDR, CLK, DI, EN, GSR, RST, WE);

    parameter INIT_00 = 256'h0000000000000000000000000000000000000000000000000000000000000000;
    parameter INIT_01 = 256'h0000000000000000000000000000000000000000000000000000000000000000;
    parameter INIT_02 = 256'h0000000000000000000000000000000000000000000000000000000000000000;
    parameter INIT_03 = 256'h0000000000000000000000000000000000000000000000000000000000000000;
    parameter INIT_04 = 256'h0000000000000000000000000000000000000000000000000000000000000000;
    parameter INIT_05 = 256'h0000000000000000000000000000000000000000000000000000000000000000;
    parameter INIT_06 = 256'h0000000000000000000000000000000000000000000000000000000000000000;
    parameter INIT_07 = 256'h0000000000000000000000000000000000000000000000000000000000000000;
    parameter INIT_08 = 256'h0000000000000000000000000000000000000000000000000000000000000000;
    parameter INIT_09 = 256'h0000000000000000000000000000000000000000000000000000000000000000;
    parameter INIT_0A = 256'h0000000000000000000000000000000000000000000000000000000000000000;
    parameter INIT_0B = 256'h0000000000000000000000000000000000000000000000000000000000000000;
    parameter INIT_0C = 256'h0000000000000000000000000000000000000000000000000000000000000000;
    parameter INIT_0D = 256'h0000000000000000000000000000000000000000000000000000000000000000;
    parameter INIT_0E = 256'h0000000000000000000000000000000000000000000000000000000000000000;
    parameter INIT_0F = 256'h0000000000000000000000000000000000000000000000000000000000000000;

    output [1:0] DO;
    reg d0_out, d1_out;

    input [10:0] ADDR;
    input [1:0] DI;
    input EN, CLK, WE, RST;

    reg [4095:0] mem;
    reg [8:0] count;

    wire [10:0] addr_int;
    wire [1:0] di_int;
    wire en_int, clk_int, we_int, rst_int;
    wire di_enable;
    reg notifier;

    and (di_enable, EN, WE);

    input GSR;
    wire gsr_int;

    always @(gsr_int)
	if (gsr_int)
	    begin
		assign d0_out = 0;
		assign d1_out = 0;
	    end
	else
	    begin
		deassign d0_out;
		deassign d1_out;
	    end

    buf b_gsr (gsr_int, GSR);
    buf b_do_out0 (DO[0], d0_out);
    buf b_do_out1 (DO[1], d1_out);
    buf b_addr_0 (addr_int[0], ADDR[0]);
    buf b_addr_1 (addr_int[1], ADDR[1]);
    buf b_addr_2 (addr_int[2], ADDR[2]);
    buf b_addr_3 (addr_int[3], ADDR[3]);
    buf b_addr_4 (addr_int[4], ADDR[4]);
    buf b_addr_5 (addr_int[5], ADDR[5]);
    buf b_addr_6 (addr_int[6], ADDR[6]);
    buf b_addr_7 (addr_int[7], ADDR[7]);
    buf b_addr_8 (addr_int[8], ADDR[8]);
    buf b_addr_9 (addr_int[9], ADDR[9]);
    buf b_addr_10 (addr_int[10], ADDR[10]);
    buf b_di_0 (di_int[0], DI[0]);
    buf b_di_1 (di_int[1], DI[1]);
    buf b_en (en_int, EN);
    buf b_clk (clk_int, CLK);
    buf b_we (we_int, WE);
    buf b_rst (rst_int, RST);

    initial
    begin
	for (count = 0; count < 256; count = count + 1)
	begin
	    mem[count]		 <= INIT_00[count];
	    mem[256 * 1 + count] <= INIT_01[count];
	    mem[256 * 2 + count] <= INIT_02[count];
	    mem[256 * 3 + count] <= INIT_03[count];
	    mem[256 * 4 + count] <= INIT_04[count];
	    mem[256 * 5 + count] <= INIT_05[count];
	    mem[256 * 6 + count] <= INIT_06[count];
	    mem[256 * 7 + count] <= INIT_07[count];
	    mem[256 * 8 + count] <= INIT_08[count];
	    mem[256 * 9 + count] <= INIT_09[count];
	    mem[256 * 10 + count] <= INIT_0A[count];
	    mem[256 * 11 + count] <= INIT_0B[count];
	    mem[256 * 12 + count] <= INIT_0C[count];
	    mem[256 * 13 + count] <= INIT_0D[count];
	    mem[256 * 14 + count] <= INIT_0E[count];
	    mem[256 * 15 + count] <= INIT_0F[count];
	end
    end

    always @(posedge clk_int)
    begin
	if (en_int == 1'b1)
	    if (rst_int == 1'b1)
		begin
		    d0_out <= 0;
		    d1_out <= 0;
		end
	    else
		if (we_int == 1'b1)
		    begin
			d0_out <= di_int[0];
			d1_out <= di_int[1];
		    end
		else
		    begin
			d0_out <= mem[addr_int * 2];
			d1_out <= mem[addr_int * 2 + 1];
		    end
    end

    always @(posedge clk_int)
    begin
	if (en_int == 1'b1 && we_int == 1'b1)
	    begin
	        mem[addr_int * 2] <= di_int[0];
	        mem[addr_int * 2 + 1] <= di_int[1];
	    end
    end

    always @(notifier) begin
	d0_out <= 1'bx;
	d1_out <= 1'bx;
    end

    specify

  	(CLK => DO[0]) = (0:0:0, 0:0:0);
  	(CLK => DO[1]) = (0:0:0, 0:0:0);
  	(GSR => DO[0]) = (0:0:0, 0:0:0);
  	(GSR => DO[1]) = (0:0:0, 0:0:0);

       	$setuphold (posedge CLK, posedge ADDR[0] &&& EN, 0:0:0, 0:0:0, notifier);
       	$setuphold (posedge CLK, negedge ADDR[0] &&& EN, 0:0:0, 0:0:0, notifier);
       	$setuphold (posedge CLK, posedge ADDR[1] &&& EN, 0:0:0, 0:0:0, notifier);
       	$setuphold (posedge CLK, negedge ADDR[1] &&& EN, 0:0:0, 0:0:0, notifier);
       	$setuphold (posedge CLK, posedge ADDR[2] &&& EN, 0:0:0, 0:0:0, notifier);
       	$setuphold (posedge CLK, negedge ADDR[2] &&& EN, 0:0:0, 0:0:0, notifier);
       	$setuphold (posedge CLK, posedge ADDR[3] &&& EN, 0:0:0, 0:0:0, notifier);
       	$setuphold (posedge CLK, negedge ADDR[3] &&& EN, 0:0:0, 0:0:0, notifier);
       	$setuphold (posedge CLK, posedge ADDR[4] &&& EN, 0:0:0, 0:0:0, notifier);
       	$setuphold (posedge CLK, negedge ADDR[4] &&& EN, 0:0:0, 0:0:0, notifier);
       	$setuphold (posedge CLK, posedge ADDR[5] &&& EN, 0:0:0, 0:0:0, notifier);
       	$setuphold (posedge CLK, negedge ADDR[5] &&& EN, 0:0:0, 0:0:0, notifier);
       	$setuphold (posedge CLK, posedge ADDR[6] &&& EN, 0:0:0, 0:0:0, notifier);
       	$setuphold (posedge CLK, negedge ADDR[6] &&& EN, 0:0:0, 0:0:0, notifier);
       	$setuphold (posedge CLK, posedge ADDR[7] &&& EN, 0:0:0, 0:0:0, notifier);
       	$setuphold (posedge CLK, negedge ADDR[7] &&& EN, 0:0:0, 0:0:0, notifier);
       	$setuphold (posedge CLK, posedge ADDR[8] &&& EN, 0:0:0, 0:0:0, notifier);
       	$setuphold (posedge CLK, negedge ADDR[8] &&& EN, 0:0:0, 0:0:0, notifier);
       	$setuphold (posedge CLK, posedge ADDR[9] &&& EN, 0:0:0, 0:0:0, notifier);
       	$setuphold (posedge CLK, negedge ADDR[9] &&& EN, 0:0:0, 0:0:0, notifier);
       	$setuphold (posedge CLK, posedge ADDR[10] &&& EN, 0:0:0, 0:0:0, notifier);
       	$setuphold (posedge CLK, negedge ADDR[10] &&& EN, 0:0:0, 0:0:0, notifier);
       	$setuphold (posedge CLK, posedge DI[0] &&& di_enable, 0:0:0, 0:0:0, notifier);
       	$setuphold (posedge CLK, negedge DI[0] &&& di_enable, 0:0:0, 0:0:0, notifier);
       	$setuphold (posedge CLK, posedge DI[1] &&& di_enable, 0:0:0, 0:0:0, notifier);
       	$setuphold (posedge CLK, negedge DI[1] &&& di_enable, 0:0:0, 0:0:0, notifier);
       	$setuphold (posedge CLK, posedge EN, 0:0:0, 0:0:0, notifier);
       	$setuphold (posedge CLK, negedge EN, 0:0:0, 0:0:0, notifier);
       	$setuphold (posedge CLK, posedge RST &&& EN, 0:0:0, 0:0:0, notifier);
       	$setuphold (posedge CLK, negedge RST &&& EN, 0:0:0, 0:0:0, notifier);
       	$setuphold (posedge CLK, posedge WE &&& EN, 0:0:0, 0:0:0, notifier);
       	$setuphold (posedge CLK, negedge WE &&& EN, 0:0:0, 0:0:0, notifier);
       	$recrem (negedge GSR, posedge CLK, 0:0:0, 0:0:0, notifier);

  	$width (posedge CLK, 0:0:0, 0, notifier);
  	$width (negedge CLK, 0:0:0, 0, notifier);
  	$width (posedge GSR, 0:0:0, 0, notifier);

	specparam PATHPULSE$ = 0;

    endspecify

endmodule
