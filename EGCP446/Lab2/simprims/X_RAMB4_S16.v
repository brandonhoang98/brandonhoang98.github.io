//    Xilinx Proprietary Primitive Cell X_RAMB4_S16 for Verilog
//
// $Header: /devl/xcs/repo/env/Databases/CAEInterfaces/versclibs/data/X_RAMB4_S16.v,v 1.17 2003/01/21 02:38:41 wloo Exp $
//

`timescale 1 ps/1 ps

module X_RAMB4_S16 (DO, ADDR, CLK, DI, EN, GSR, RST, WE);

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

    output [15:0] DO;
    reg d0_out, d1_out, d2_out, d3_out, d4_out, d5_out, d6_out, d7_out, d8_out, d9_out, d10_out, d11_out, d12_out, d13_out, d14_out, d15_out;

    input [7:0] ADDR;
    input [15:0] DI;
    input EN, CLK, WE, RST;

    reg [4095:0] mem;
    reg [8:0] count;

    wire [7:0] addr_int;
    wire [15:0] di_int;
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
		assign d2_out = 0;
		assign d3_out = 0;
		assign d4_out = 0;
		assign d5_out = 0;
		assign d6_out = 0;
		assign d7_out = 0;
		assign d8_out = 0;
		assign d9_out = 0;
		assign d10_out = 0;
		assign d11_out = 0;
		assign d12_out = 0;
		assign d13_out = 0;
		assign d14_out = 0;
		assign d15_out = 0;
	    end
	else
	    begin
		deassign d0_out;
		deassign d1_out;
		deassign d2_out;
		deassign d3_out;
		deassign d4_out;
		deassign d5_out;
		deassign d6_out;
		deassign d7_out;
		deassign d8_out;
		deassign d9_out;
		deassign d10_out;
		deassign d11_out;
		deassign d12_out;
		deassign d13_out;
		deassign d14_out;
		deassign d15_out;
	    end

    buf b_gsr (gsr_int, GSR);
    buf b_do_out0 (DO[0], d0_out);
    buf b_do_out1 (DO[1], d1_out);
    buf b_do_out2 (DO[2], d2_out);
    buf b_do_out3 (DO[3], d3_out);
    buf b_do_out4 (DO[4], d4_out);
    buf b_do_out5 (DO[5], d5_out);
    buf b_do_out6 (DO[6], d6_out);
    buf b_do_out7 (DO[7], d7_out);
    buf b_do_out8 (DO[8], d8_out);
    buf b_do_out9 (DO[9], d9_out);
    buf b_do_out10 (DO[10], d10_out);
    buf b_do_out11 (DO[11], d11_out);
    buf b_do_out12 (DO[12], d12_out);
    buf b_do_out13 (DO[13], d13_out);
    buf b_do_out14 (DO[14], d14_out);
    buf b_do_out15 (DO[15], d15_out);
    buf b_addr_0 (addr_int[0], ADDR[0]);
    buf b_addr_1 (addr_int[1], ADDR[1]);
    buf b_addr_2 (addr_int[2], ADDR[2]);
    buf b_addr_3 (addr_int[3], ADDR[3]);
    buf b_addr_4 (addr_int[4], ADDR[4]);
    buf b_addr_5 (addr_int[5], ADDR[5]);
    buf b_addr_6 (addr_int[6], ADDR[6]);
    buf b_addr_7 (addr_int[7], ADDR[7]);
    buf b_di_0 (di_int[0], DI[0]);
    buf b_di_1 (di_int[1], DI[1]);
    buf b_di_2 (di_int[2], DI[2]);
    buf b_di_3 (di_int[3], DI[3]);
    buf b_di_4 (di_int[4], DI[4]);
    buf b_di_5 (di_int[5], DI[5]);
    buf b_di_6 (di_int[6], DI[6]);
    buf b_di_7 (di_int[7], DI[7]);
    buf b_di_8 (di_int[8], DI[8]);
    buf b_di_9 (di_int[9], DI[9]);
    buf b_di_10 (di_int[10], DI[10]);
    buf b_di_11 (di_int[11], DI[11]);
    buf b_di_12 (di_int[12], DI[12]);
    buf b_di_13 (di_int[13], DI[13]);
    buf b_di_14 (di_int[14], DI[14]);
    buf b_di_15 (di_int[15], DI[15]);
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
		    d2_out <= 0;
		    d3_out <= 0;
		    d4_out <= 0;
		    d5_out <= 0;
		    d6_out <= 0;
		    d7_out <= 0;
		    d8_out <= 0;
		    d9_out <= 0;
		    d10_out <= 0;
		    d11_out <= 0;
		    d12_out <= 0;
		    d13_out <= 0;
		    d14_out <= 0;
		    d15_out <= 0;
		end
	    else
		if (we_int == 1'b1)
		    begin
			d0_out <= di_int[0];
			d1_out <= di_int[1];
			d2_out <= di_int[2];
			d3_out <= di_int[3];
			d4_out <= di_int[4];
			d5_out <= di_int[5];
			d6_out <= di_int[6];
			d7_out <= di_int[7];
			d8_out <= di_int[8];
			d9_out <= di_int[9];
			d10_out <= di_int[10];
			d11_out <= di_int[11];
			d12_out <= di_int[12];
			d13_out <= di_int[13];
			d14_out <= di_int[14];
			d15_out <= di_int[15];
		    end
		else
		    begin
			d0_out <= mem[addr_int * 16];
			d1_out <= mem[addr_int * 16 + 1];
			d2_out <= mem[addr_int * 16 + 2];
			d3_out <= mem[addr_int * 16 + 3];
			d4_out <= mem[addr_int * 16 + 4];
			d5_out <= mem[addr_int * 16 + 5];
			d6_out <= mem[addr_int * 16 + 6];
			d7_out <= mem[addr_int * 16 + 7];
			d8_out <= mem[addr_int * 16 + 8];
			d9_out <= mem[addr_int * 16 + 9];
			d10_out <= mem[addr_int * 16 + 10];
			d11_out <= mem[addr_int * 16 + 11];
			d12_out <= mem[addr_int * 16 + 12];
			d13_out <= mem[addr_int * 16 + 13];
			d14_out <= mem[addr_int * 16 + 14];
			d15_out <= mem[addr_int * 16 + 15];
		    end
    end

    always @(posedge clk_int)
    begin
	if (en_int == 1'b1 && we_int == 1'b1)
	    begin
		mem[addr_int * 16] <= di_int[0];
		mem[addr_int * 16 + 1] <= di_int[1];
		mem[addr_int * 16 + 2] <= di_int[2];
		mem[addr_int * 16 + 3] <= di_int[3];
		mem[addr_int * 16 + 4] <= di_int[4];
		mem[addr_int * 16 + 5] <= di_int[5];
		mem[addr_int * 16 + 6] <= di_int[6];
		mem[addr_int * 16 + 7] <= di_int[7];
		mem[addr_int * 16 + 8] <= di_int[8];
		mem[addr_int * 16 + 9] <= di_int[9];
		mem[addr_int * 16 + 10] <= di_int[10];
		mem[addr_int * 16 + 11] <= di_int[11];
		mem[addr_int * 16 + 12] <= di_int[12];
		mem[addr_int * 16 + 13] <= di_int[13];
		mem[addr_int * 16 + 14] <= di_int[14];
		mem[addr_int * 16 + 15] <= di_int[15];
	    end
    end

    always @(notifier) begin
	d0_out <= 1'bx;
	d1_out <= 1'bx;
	d2_out <= 1'bx;
	d3_out <= 1'bx;
	d4_out <= 1'bx;
	d5_out <= 1'bx;
	d6_out <= 1'bx;
	d7_out <= 1'bx;
	d8_out <= 1'bx;
	d9_out <= 1'bx;
	d10_out <= 1'bx;
	d11_out <= 1'bx;
	d12_out <= 1'bx;
	d13_out <= 1'bx;
	d14_out <= 1'bx;
	d15_out <= 1'bx;
    end

    specify

  	(CLK => DO[0]) = (0:0:0, 0:0:0);
  	(CLK => DO[1]) = (0:0:0, 0:0:0);
  	(CLK => DO[2]) = (0:0:0, 0:0:0);
  	(CLK => DO[3]) = (0:0:0, 0:0:0);
  	(CLK => DO[4]) = (0:0:0, 0:0:0);
  	(CLK => DO[5]) = (0:0:0, 0:0:0);
  	(CLK => DO[6]) = (0:0:0, 0:0:0);
  	(CLK => DO[7]) = (0:0:0, 0:0:0);
  	(CLK => DO[8]) = (0:0:0, 0:0:0);
  	(CLK => DO[9]) = (0:0:0, 0:0:0);
  	(CLK => DO[10]) = (0:0:0, 0:0:0);
  	(CLK => DO[11]) = (0:0:0, 0:0:0);
  	(CLK => DO[12]) = (0:0:0, 0:0:0);
  	(CLK => DO[13]) = (0:0:0, 0:0:0);
  	(CLK => DO[14]) = (0:0:0, 0:0:0);
  	(CLK => DO[15]) = (0:0:0, 0:0:0);
  	(GSR => DO[0]) = (0:0:0, 0:0:0);
  	(GSR => DO[1]) = (0:0:0, 0:0:0);
  	(GSR => DO[2]) = (0:0:0, 0:0:0);
  	(GSR => DO[3]) = (0:0:0, 0:0:0);
  	(GSR => DO[4]) = (0:0:0, 0:0:0);
  	(GSR => DO[5]) = (0:0:0, 0:0:0);
  	(GSR => DO[6]) = (0:0:0, 0:0:0);
  	(GSR => DO[7]) = (0:0:0, 0:0:0);
  	(GSR => DO[8]) = (0:0:0, 0:0:0);
  	(GSR => DO[9]) = (0:0:0, 0:0:0);
  	(GSR => DO[10]) = (0:0:0, 0:0:0);
  	(GSR => DO[11]) = (0:0:0, 0:0:0);
  	(GSR => DO[12]) = (0:0:0, 0:0:0);
  	(GSR => DO[13]) = (0:0:0, 0:0:0);
  	(GSR => DO[14]) = (0:0:0, 0:0:0);
  	(GSR => DO[15]) = (0:0:0, 0:0:0);

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
       	$setuphold (posedge CLK, posedge DI[0] &&& di_enable, 0:0:0, 0:0:0, notifier);
       	$setuphold (posedge CLK, negedge DI[0] &&& di_enable, 0:0:0, 0:0:0, notifier);
       	$setuphold (posedge CLK, posedge DI[1] &&& di_enable, 0:0:0, 0:0:0, notifier);
       	$setuphold (posedge CLK, negedge DI[1] &&& di_enable, 0:0:0, 0:0:0, notifier);
       	$setuphold (posedge CLK, posedge DI[2] &&& di_enable, 0:0:0, 0:0:0, notifier);
       	$setuphold (posedge CLK, negedge DI[2] &&& di_enable, 0:0:0, 0:0:0, notifier);
       	$setuphold (posedge CLK, posedge DI[3] &&& di_enable, 0:0:0, 0:0:0, notifier);
       	$setuphold (posedge CLK, negedge DI[3] &&& di_enable, 0:0:0, 0:0:0, notifier);
       	$setuphold (posedge CLK, posedge DI[4] &&& di_enable, 0:0:0, 0:0:0, notifier);
       	$setuphold (posedge CLK, negedge DI[4] &&& di_enable, 0:0:0, 0:0:0, notifier);
       	$setuphold (posedge CLK, posedge DI[5] &&& di_enable, 0:0:0, 0:0:0, notifier);
       	$setuphold (posedge CLK, negedge DI[5] &&& di_enable, 0:0:0, 0:0:0, notifier);
       	$setuphold (posedge CLK, posedge DI[6] &&& di_enable, 0:0:0, 0:0:0, notifier);
       	$setuphold (posedge CLK, negedge DI[6] &&& di_enable, 0:0:0, 0:0:0, notifier);
       	$setuphold (posedge CLK, posedge DI[7] &&& di_enable, 0:0:0, 0:0:0, notifier);
       	$setuphold (posedge CLK, negedge DI[7] &&& di_enable, 0:0:0, 0:0:0, notifier);
       	$setuphold (posedge CLK, posedge DI[8] &&& di_enable, 0:0:0, 0:0:0, notifier);
       	$setuphold (posedge CLK, negedge DI[8] &&& di_enable, 0:0:0, 0:0:0, notifier);
       	$setuphold (posedge CLK, posedge DI[9] &&& di_enable, 0:0:0, 0:0:0, notifier);
       	$setuphold (posedge CLK, negedge DI[9] &&& di_enable, 0:0:0, 0:0:0, notifier);
       	$setuphold (posedge CLK, posedge DI[10] &&& di_enable, 0:0:0, 0:0:0, notifier);
       	$setuphold (posedge CLK, negedge DI[10] &&& di_enable, 0:0:0, 0:0:0, notifier);
       	$setuphold (posedge CLK, posedge DI[11] &&& di_enable, 0:0:0, 0:0:0, notifier);
       	$setuphold (posedge CLK, negedge DI[11] &&& di_enable, 0:0:0, 0:0:0, notifier);
       	$setuphold (posedge CLK, posedge DI[12] &&& di_enable, 0:0:0, 0:0:0, notifier);
       	$setuphold (posedge CLK, negedge DI[12] &&& di_enable, 0:0:0, 0:0:0, notifier);
       	$setuphold (posedge CLK, posedge DI[13] &&& di_enable, 0:0:0, 0:0:0, notifier);
       	$setuphold (posedge CLK, negedge DI[13] &&& di_enable, 0:0:0, 0:0:0, notifier);
       	$setuphold (posedge CLK, posedge DI[14] &&& di_enable, 0:0:0, 0:0:0, notifier);
       	$setuphold (posedge CLK, negedge DI[14] &&& di_enable, 0:0:0, 0:0:0, notifier);
       	$setuphold (posedge CLK, posedge DI[15] &&& di_enable, 0:0:0, 0:0:0, notifier);
       	$setuphold (posedge CLK, negedge DI[15] &&& di_enable, 0:0:0, 0:0:0, notifier);
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
