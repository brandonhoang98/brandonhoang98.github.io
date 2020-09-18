//    Xilinx Proprietary Primitive Cell X_RAMB16_S1 for Verilog
//
// $Header: /devl/xcs/repo/env/Databases/CAEInterfaces/versclibs/data/X_RAMB16_S2_S4.v,v 1.32 2003/05/28 01:17:26 wloo Exp $
//

`timescale 1 ps/1 ps

module X_RAMB16_S2_S4 (DOA, DOB, ADDRA, ADDRB, CLKA, CLKB, DIA, DIB, ENA, ENB, GSR, SSRA, SSRB, WEA, WEB);

    parameter INIT_A = 2'h0;
    parameter INIT_B = 4'h0;
    parameter SRVAL_A = 2'h0;
    parameter SRVAL_B = 4'h0;
    parameter WRITE_MODE_A = "WRITE_FIRST";
    parameter WRITE_MODE_B = "WRITE_FIRST";
    parameter SETUP_ALL = 1000;
    parameter SETUP_READ_FIRST = 3000;

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
    parameter INIT_10 = 256'h0000000000000000000000000000000000000000000000000000000000000000;
    parameter INIT_11 = 256'h0000000000000000000000000000000000000000000000000000000000000000;
    parameter INIT_12 = 256'h0000000000000000000000000000000000000000000000000000000000000000;
    parameter INIT_13 = 256'h0000000000000000000000000000000000000000000000000000000000000000;
    parameter INIT_14 = 256'h0000000000000000000000000000000000000000000000000000000000000000;
    parameter INIT_15 = 256'h0000000000000000000000000000000000000000000000000000000000000000;
    parameter INIT_16 = 256'h0000000000000000000000000000000000000000000000000000000000000000;
    parameter INIT_17 = 256'h0000000000000000000000000000000000000000000000000000000000000000;
    parameter INIT_18 = 256'h0000000000000000000000000000000000000000000000000000000000000000;
    parameter INIT_19 = 256'h0000000000000000000000000000000000000000000000000000000000000000;
    parameter INIT_1A = 256'h0000000000000000000000000000000000000000000000000000000000000000;
    parameter INIT_1B = 256'h0000000000000000000000000000000000000000000000000000000000000000;
    parameter INIT_1C = 256'h0000000000000000000000000000000000000000000000000000000000000000;
    parameter INIT_1D = 256'h0000000000000000000000000000000000000000000000000000000000000000;
    parameter INIT_1E = 256'h0000000000000000000000000000000000000000000000000000000000000000;
    parameter INIT_1F = 256'h0000000000000000000000000000000000000000000000000000000000000000;
    parameter INIT_20 = 256'h0000000000000000000000000000000000000000000000000000000000000000;
    parameter INIT_21 = 256'h0000000000000000000000000000000000000000000000000000000000000000;
    parameter INIT_22 = 256'h0000000000000000000000000000000000000000000000000000000000000000;
    parameter INIT_23 = 256'h0000000000000000000000000000000000000000000000000000000000000000;
    parameter INIT_24 = 256'h0000000000000000000000000000000000000000000000000000000000000000;
    parameter INIT_25 = 256'h0000000000000000000000000000000000000000000000000000000000000000;
    parameter INIT_26 = 256'h0000000000000000000000000000000000000000000000000000000000000000;
    parameter INIT_27 = 256'h0000000000000000000000000000000000000000000000000000000000000000;
    parameter INIT_28 = 256'h0000000000000000000000000000000000000000000000000000000000000000;
    parameter INIT_29 = 256'h0000000000000000000000000000000000000000000000000000000000000000;
    parameter INIT_2A = 256'h0000000000000000000000000000000000000000000000000000000000000000;
    parameter INIT_2B = 256'h0000000000000000000000000000000000000000000000000000000000000000;
    parameter INIT_2C = 256'h0000000000000000000000000000000000000000000000000000000000000000;
    parameter INIT_2D = 256'h0000000000000000000000000000000000000000000000000000000000000000;
    parameter INIT_2E = 256'h0000000000000000000000000000000000000000000000000000000000000000;
    parameter INIT_2F = 256'h0000000000000000000000000000000000000000000000000000000000000000;
    parameter INIT_30 = 256'h0000000000000000000000000000000000000000000000000000000000000000;
    parameter INIT_31 = 256'h0000000000000000000000000000000000000000000000000000000000000000;
    parameter INIT_32 = 256'h0000000000000000000000000000000000000000000000000000000000000000;
    parameter INIT_33 = 256'h0000000000000000000000000000000000000000000000000000000000000000;
    parameter INIT_34 = 256'h0000000000000000000000000000000000000000000000000000000000000000;
    parameter INIT_35 = 256'h0000000000000000000000000000000000000000000000000000000000000000;
    parameter INIT_36 = 256'h0000000000000000000000000000000000000000000000000000000000000000;
    parameter INIT_37 = 256'h0000000000000000000000000000000000000000000000000000000000000000;
    parameter INIT_38 = 256'h0000000000000000000000000000000000000000000000000000000000000000;
    parameter INIT_39 = 256'h0000000000000000000000000000000000000000000000000000000000000000;
    parameter INIT_3A = 256'h0000000000000000000000000000000000000000000000000000000000000000;
    parameter INIT_3B = 256'h0000000000000000000000000000000000000000000000000000000000000000;
    parameter INIT_3C = 256'h0000000000000000000000000000000000000000000000000000000000000000;
    parameter INIT_3D = 256'h0000000000000000000000000000000000000000000000000000000000000000;
    parameter INIT_3E = 256'h0000000000000000000000000000000000000000000000000000000000000000;
    parameter INIT_3F = 256'h0000000000000000000000000000000000000000000000000000000000000000;
    parameter INITP_00 = 256'h0000000000000000000000000000000000000000000000000000000000000000;
    parameter INITP_01 = 256'h0000000000000000000000000000000000000000000000000000000000000000;
    parameter INITP_02 = 256'h0000000000000000000000000000000000000000000000000000000000000000;
    parameter INITP_03 = 256'h0000000000000000000000000000000000000000000000000000000000000000;
    parameter INITP_04 = 256'h0000000000000000000000000000000000000000000000000000000000000000;
    parameter INITP_05 = 256'h0000000000000000000000000000000000000000000000000000000000000000;
    parameter INITP_06 = 256'h0000000000000000000000000000000000000000000000000000000000000000;
    parameter INITP_07 = 256'h0000000000000000000000000000000000000000000000000000000000000000;

    output [1:0] DOA;
    reg [1:0] doa_out;
    wire doa_out0, doa_out1;

    input [12:0] ADDRA;
    input [1:0] DIA;
    input ENA, CLKA, WEA, SSRA;

    output [3:0] DOB;
    reg [3:0] dob_out;
    wire dob_out0, dob_out1, dob_out2, dob_out3;

    input [11:0] ADDRB;
    input [3:0] DIB;
    input ENB, CLKB, WEB, SSRB;

    reg [18431:0] mem;
    reg [8:0] count;
    reg [1:0] wr_mode_a, wr_mode_b;

    reg [5:0] dmi, dbi;
    reg [5:0] pmi, pbi;

    wire [12:0] addra_int;
    reg [12:0] addra_reg;
    wire [1:0] dia_int;
    wire ena_int, clka_int, wea_int, ssra_int;
    reg ena_reg, wea_reg, ssra_reg;
    wire [11:0] addrb_int;
    reg [11:0] addrb_reg;
    wire [3:0] dib_int;
    wire enb_int, clkb_int, web_int, ssrb_int;
    reg enb_reg, web_reg, ssrb_reg;

    time time_clka, time_clkb;
    time time_clka_clkb;
    time time_clkb_clka;

    reg setup_all_a_b;
    reg setup_all_b_a;
    reg setup_zero;
    reg setup_rf_a_b;
    reg setup_rf_b_a;
    reg [1:0] data_collision, data_collision_a_b, data_collision_b_a;
    reg memory_collision, memory_collision_a_b, memory_collision_b_a;
    reg address_collision, address_collision_a_b, address_collision_b_a;
    reg change_clka;
    reg change_clkb;

    wire [14:0] data_addra_int;
    wire [14:0] data_addra_reg;
    wire [14:0] data_addrb_int;
    wire [14:0] data_addrb_reg;

    wire dia_enable = ena_int && wea_int;
    wire dib_enable = enb_int && web_int;
    reg notifier, notifier_a, notifier_b;

    input GSR;
    wire gsr_int;

    always @(gsr_int)
	if (gsr_int) begin
	    assign doa_out = INIT_A[1:0];
	    assign dob_out = INIT_B[3:0];
	end
	else begin
	    deassign doa_out;
	    deassign dob_out;
	end

    buf b_gsr (gsr_int, GSR);
    buf b_doa_out0 (doa_out0, doa_out[0]);
    buf b_doa_out1 (doa_out1, doa_out[1]);
    buf b_dob_out0 (dob_out0, dob_out[0]);
    buf b_dob_out1 (dob_out1, dob_out[1]);
    buf b_dob_out2 (dob_out2, dob_out[2]);
    buf b_dob_out3 (dob_out3, dob_out[3]);

    buf b_doa0 (DOA[0], doa_out0);
    buf b_doa1 (DOA[1], doa_out1);
    buf b_dob0 (DOB[0], dob_out0);
    buf b_dob1 (DOB[1], dob_out1);
    buf b_dob2 (DOB[2], dob_out2);
    buf b_dob3 (DOB[3], dob_out3);

    buf b_addra_0 (addra_int[0], ADDRA[0]);
    buf b_addra_1 (addra_int[1], ADDRA[1]);
    buf b_addra_2 (addra_int[2], ADDRA[2]);
    buf b_addra_3 (addra_int[3], ADDRA[3]);
    buf b_addra_4 (addra_int[4], ADDRA[4]);
    buf b_addra_5 (addra_int[5], ADDRA[5]);
    buf b_addra_6 (addra_int[6], ADDRA[6]);
    buf b_addra_7 (addra_int[7], ADDRA[7]);
    buf b_addra_8 (addra_int[8], ADDRA[8]);
    buf b_addra_9 (addra_int[9], ADDRA[9]);
    buf b_addra_10 (addra_int[10], ADDRA[10]);
    buf b_addra_11 (addra_int[11], ADDRA[11]);
    buf b_addra_12 (addra_int[12], ADDRA[12]);
    buf b_dia_0 (dia_int[0], DIA[0]);
    buf b_dia_1 (dia_int[1], DIA[1]);
    buf b_ena (ena_int, ENA);
    buf b_clka (clka_int, CLKA);
    buf b_ssra (ssra_int, SSRA);
    buf b_wea (wea_int, WEA);
    buf b_addrb_0 (addrb_int[0], ADDRB[0]);
    buf b_addrb_1 (addrb_int[1], ADDRB[1]);
    buf b_addrb_2 (addrb_int[2], ADDRB[2]);
    buf b_addrb_3 (addrb_int[3], ADDRB[3]);
    buf b_addrb_4 (addrb_int[4], ADDRB[4]);
    buf b_addrb_5 (addrb_int[5], ADDRB[5]);
    buf b_addrb_6 (addrb_int[6], ADDRB[6]);
    buf b_addrb_7 (addrb_int[7], ADDRB[7]);
    buf b_addrb_8 (addrb_int[8], ADDRB[8]);
    buf b_addrb_9 (addrb_int[9], ADDRB[9]);
    buf b_addrb_10 (addrb_int[10], ADDRB[10]);
    buf b_addrb_11 (addrb_int[11], ADDRB[11]);
    buf b_dib_0 (dib_int[0], DIB[0]);
    buf b_dib_1 (dib_int[1], DIB[1]);
    buf b_dib_2 (dib_int[2], DIB[2]);
    buf b_dib_3 (dib_int[3], DIB[3]);
    buf b_enb (enb_int, ENB);
    buf b_clkb (clkb_int, CLKB);
    buf b_ssrb (ssrb_int, SSRB);
    buf b_web (web_int, WEB);

    initial begin
	for (count = 0; count < 256; count = count + 1) begin
	    mem[count]		  <= INIT_00[count];
	    mem[256 * 1 + count]  <= INIT_01[count];
	    mem[256 * 2 + count]  <= INIT_02[count];
	    mem[256 * 3 + count]  <= INIT_03[count];
	    mem[256 * 4 + count]  <= INIT_04[count];
	    mem[256 * 5 + count]  <= INIT_05[count];
	    mem[256 * 6 + count]  <= INIT_06[count];
	    mem[256 * 7 + count]  <= INIT_07[count];
	    mem[256 * 8 + count]  <= INIT_08[count];
	    mem[256 * 9 + count]  <= INIT_09[count];
	    mem[256 * 10 + count] <= INIT_0A[count];
	    mem[256 * 11 + count] <= INIT_0B[count];
	    mem[256 * 12 + count] <= INIT_0C[count];
	    mem[256 * 13 + count] <= INIT_0D[count];
	    mem[256 * 14 + count] <= INIT_0E[count];
	    mem[256 * 15 + count] <= INIT_0F[count];
	    mem[256 * 16 + count] <= INIT_10[count];
	    mem[256 * 17 + count] <= INIT_11[count];
	    mem[256 * 18 + count] <= INIT_12[count];
	    mem[256 * 19 + count] <= INIT_13[count];
	    mem[256 * 20 + count] <= INIT_14[count];
	    mem[256 * 21 + count] <= INIT_15[count];
	    mem[256 * 22 + count] <= INIT_16[count];
	    mem[256 * 23 + count] <= INIT_17[count];
	    mem[256 * 24 + count] <= INIT_18[count];
	    mem[256 * 25 + count] <= INIT_19[count];
	    mem[256 * 26 + count] <= INIT_1A[count];
	    mem[256 * 27 + count] <= INIT_1B[count];
	    mem[256 * 28 + count] <= INIT_1C[count];
	    mem[256 * 29 + count] <= INIT_1D[count];
	    mem[256 * 30 + count] <= INIT_1E[count];
	    mem[256 * 31 + count] <= INIT_1F[count];
	    mem[256 * 32 + count] <= INIT_20[count];
	    mem[256 * 33 + count] <= INIT_21[count];
	    mem[256 * 34 + count] <= INIT_22[count];
	    mem[256 * 35 + count] <= INIT_23[count];
	    mem[256 * 36 + count] <= INIT_24[count];
	    mem[256 * 37 + count] <= INIT_25[count];
	    mem[256 * 38 + count] <= INIT_26[count];
	    mem[256 * 39 + count] <= INIT_27[count];
	    mem[256 * 40 + count] <= INIT_28[count];
	    mem[256 * 41 + count] <= INIT_29[count];
	    mem[256 * 42 + count] <= INIT_2A[count];
	    mem[256 * 43 + count] <= INIT_2B[count];
	    mem[256 * 44 + count] <= INIT_2C[count];
	    mem[256 * 45 + count] <= INIT_2D[count];
	    mem[256 * 46 + count] <= INIT_2E[count];
	    mem[256 * 47 + count] <= INIT_2F[count];
	    mem[256 * 48 + count] <= INIT_30[count];
	    mem[256 * 49 + count] <= INIT_31[count];
	    mem[256 * 50 + count] <= INIT_32[count];
	    mem[256 * 51 + count] <= INIT_33[count];
	    mem[256 * 52 + count] <= INIT_34[count];
	    mem[256 * 53 + count] <= INIT_35[count];
	    mem[256 * 54 + count] <= INIT_36[count];
	    mem[256 * 55 + count] <= INIT_37[count];
	    mem[256 * 56 + count] <= INIT_38[count];
	    mem[256 * 57 + count] <= INIT_39[count];
	    mem[256 * 58 + count] <= INIT_3A[count];
	    mem[256 * 59 + count] <= INIT_3B[count];
	    mem[256 * 60 + count] <= INIT_3C[count];
	    mem[256 * 61 + count] <= INIT_3D[count];
	    mem[256 * 62 + count] <= INIT_3E[count];
	    mem[256 * 63 + count] <= INIT_3F[count];
	    mem[256 * 64 + count] <= INITP_00[count];
	    mem[256 * 65 + count] <= INITP_01[count];
	    mem[256 * 66 + count] <= INITP_02[count];
	    mem[256 * 67 + count] <= INITP_03[count];
	    mem[256 * 68 + count] <= INITP_04[count];
	    mem[256 * 69 + count] <= INITP_05[count];
	    mem[256 * 70 + count] <= INITP_06[count];
	    mem[256 * 71 + count] <= INITP_07[count];
	end
	address_collision <= 0;
	address_collision_a_b <= 0;
	address_collision_b_a <= 0;
	change_clka <= 0;
	change_clkb <= 0;
	data_collision <= 0;
	data_collision_a_b <= 0;
	data_collision_b_a <= 0;
	memory_collision <= 0;
	memory_collision_a_b <= 0;
	memory_collision_b_a <= 0;
	setup_all_a_b <= 0;
	setup_all_b_a <= 0;
	setup_zero <= 0;
	setup_rf_a_b <= 0;
	setup_rf_b_a <= 0;
    end

    assign data_addra_int = addra_int * 2;
    assign data_addra_reg = addra_reg * 2;
    assign data_addrb_int = addrb_int * 4;
    assign data_addrb_reg = addrb_reg * 4;

`ifdef DISABLE_COLLISION_CHECK
`else

    always @(posedge clka_int) begin
	time_clka = $time;
	#0 time_clkb_clka = time_clka - time_clkb;
	change_clka = ~change_clka;
    end

    always @(posedge clkb_int) begin
	time_clkb = $time;
	#0 time_clka_clkb = time_clkb - time_clka;
	change_clkb = ~change_clkb;
    end

    always @(change_clkb) begin
	if ((0 < time_clka_clkb) && (time_clka_clkb < SETUP_ALL))
	    setup_all_a_b = 1;
	if ((0 < time_clka_clkb) && (time_clka_clkb < SETUP_READ_FIRST))
	    setup_rf_a_b = 1;
    end

    always @(change_clka) begin
	if ((0 < time_clkb_clka) && (time_clkb_clka < SETUP_ALL))
	    setup_all_b_a = 1;
	if ((0 < time_clkb_clka) && (time_clkb_clka < SETUP_READ_FIRST))
	    setup_rf_b_a = 1;
    end

    always @(change_clkb or change_clka) begin
	if ((time_clkb_clka == 0) && (time_clka_clkb == 0))
	    setup_zero = 1;
    end

    always @(posedge setup_zero) begin
	if ((ena_int == 1) && (wea_int == 1) &&
	    (enb_int == 1) && (web_int == 1) &&
	    (data_addra_int[14:2] == data_addrb_int[14:2]))
	    memory_collision <= 1;
    end

    always @(posedge setup_all_a_b or posedge setup_rf_a_b) begin
	if ((ena_reg == 1) && (wea_reg == 1) &&
	    (enb_int == 1) && (web_int == 1) &&
	    (data_addra_reg[14:2] == data_addrb_int[14:2]))
	    memory_collision_a_b <= 1;
    end

    always @(posedge setup_all_b_a or posedge setup_rf_b_a) begin
	if ((ena_int == 1) && (wea_int == 1) &&
	    (enb_reg == 1) && (web_reg == 1) &&
	    (data_addra_int[14:2] == data_addrb_reg[14:2]))
	    memory_collision_b_a <= 1;
    end

    always @(posedge setup_all_a_b) begin
	if (data_addra_reg[14:2] == data_addrb_int[14:2]) begin
	if ((ena_reg == 1) && (enb_int == 1)) begin
	    case ({wr_mode_a, wr_mode_b, wea_reg, web_int})
		6'b000011 : begin data_collision_a_b <= 2'b11; display_all_a_b; end
		6'b000111 : begin data_collision_a_b <= 2'b11; display_all_a_b; end
		6'b001011 : begin data_collision_a_b <= 2'b10; display_all_a_b; end
//		6'b010011 : begin data_collision_a_b <= 2'b00; display_all_a_b; end
//		6'b010111 : begin data_collision_a_b <= 2'b00; display_all_a_b; end
//		6'b011011 : begin data_collision_a_b <= 2'b00; display_all_a_b; end
		6'b100011 : begin data_collision_a_b <= 2'b01; display_all_a_b; end
		6'b100111 : begin data_collision_a_b <= 2'b01; display_all_a_b; end
		6'b101011 : begin display_all_a_b; end
		6'b000001 : begin data_collision_a_b <= 2'b10; display_all_a_b; end
//		6'b000101 : begin data_collision_a_b <= 2'b00; display_all_a_b; end
		6'b001001 : begin data_collision_a_b <= 2'b10; display_all_a_b; end
		6'b010001 : begin data_collision_a_b <= 2'b10; display_all_a_b; end
//		6'b010101 : begin data_collision_a_b <= 2'b00; display_all_a_b; end
		6'b011001 : begin data_collision_a_b <= 2'b10; display_all_a_b; end
		6'b100001 : begin data_collision_a_b <= 2'b10; display_all_a_b; end
//		6'b100101 : begin data_collision_a_b <= 2'b00; display_all_a_b; end
		6'b101001 : begin data_collision_a_b <= 2'b10; display_all_a_b; end
		6'b000010 : begin data_collision_a_b <= 2'b01; display_all_a_b; end
		6'b000110 : begin data_collision_a_b <= 2'b01; display_all_a_b; end
		6'b001010 : begin data_collision_a_b <= 2'b01; display_all_a_b; end
//		6'b010010 : begin data_collision_a_b <= 2'b00; display_all_a_b; end
//		6'b010110 : begin data_collision_a_b <= 2'b00; display_all_a_b; end
//		6'b011010 : begin data_collision_a_b <= 2'b00; display_all_a_b; end
		6'b100010 : begin data_collision_a_b <= 2'b01; display_all_a_b; end
		6'b100110 : begin data_collision_a_b <= 2'b01; display_all_a_b; end
		6'b101010 : begin data_collision_a_b <= 2'b01; display_all_a_b; end
	    endcase
	end
	end
	setup_all_a_b <= 0;
    end

    task display_all_a_b;
    begin
	    $display("Timing Violation Error : Setup time %.3f ns violated on X_RAMB16_S2_S4 instance %m on CLKA port at simulation time %.3f ns with respect to CLKB port at simulation time %.3f ns.  Expected setup time is %.3f ns", time_clka_clkb/1000.0, time_clka/1000.0, time_clkb/1000.0, SETUP_ALL/1000.0);
    end
    endtask

    always @(posedge setup_all_b_a) begin
	if (data_addra_int[14:2] == data_addrb_reg[14:2]) begin
	if ((ena_int == 1) && (enb_reg == 1)) begin
	    case ({wr_mode_a, wr_mode_b, wea_int, web_reg})
		6'b000011 : begin data_collision_b_a <= 2'b11; display_all_b_a; end
//		6'b000111 : begin data_collision_b_a <= 2'b00; display_all_b_a; end
		6'b001011 : begin data_collision_b_a <= 2'b10; display_all_b_a; end
		6'b010011 : begin data_collision_b_a <= 2'b11; display_all_b_a; end
//		6'b010111 : begin data_collision_b_a <= 2'b00; display_all_b_a; end
		6'b011011 : begin data_collision_b_a <= 2'b10; display_all_b_a; end
		6'b100011 : begin data_collision_b_a <= 2'b01; display_all_b_a; end
		6'b100111 : begin data_collision_b_a <= 2'b01; display_all_b_a; end
		6'b101011 : begin display_all_b_a; end
		6'b000001 : begin data_collision_b_a <= 2'b10; display_all_b_a; end
		6'b000101 : begin data_collision_b_a <= 2'b10; display_all_b_a; end
		6'b001001 : begin data_collision_b_a <= 2'b10; display_all_b_a; end
		6'b010001 : begin data_collision_b_a <= 2'b10; display_all_b_a; end
		6'b010101 : begin data_collision_b_a <= 2'b10; display_all_b_a; end
		6'b011001 : begin data_collision_b_a <= 2'b10; display_all_b_a; end
		6'b100001 : begin data_collision_b_a <= 2'b10; display_all_b_a; end
		6'b100101 : begin data_collision_b_a <= 2'b10; display_all_b_a; end
		6'b101001 : begin data_collision_b_a <= 2'b10; display_all_b_a; end
		6'b000010 : begin data_collision_b_a <= 2'b01; display_all_b_a; end
		6'b000110 : begin data_collision_b_a <= 2'b01; display_all_b_a; end
		6'b001010 : begin data_collision_b_a <= 2'b01; display_all_b_a; end
//		6'b010010 : begin data_collision_b_a <= 2'b00; display_all_b_a; end
//		6'b010110 : begin data_collision_b_a <= 2'b00; display_all_b_a; end
//		6'b011010 : begin data_collision_b_a <= 2'b00; display_all_b_a; end
		6'b100010 : begin data_collision_b_a <= 2'b01; display_all_b_a; end
		6'b100110 : begin data_collision_b_a <= 2'b01; display_all_b_a; end
		6'b101010 : begin data_collision_b_a <= 2'b01; display_all_b_a; end
	    endcase
	end
	end
	setup_all_b_a <= 0;
    end

    task display_all_b_a;
    begin
	    $display("Timing Violation Error : Setup time %.3f ns violated on X_RAMB16_S1_S1 instance %m on CLKB port at simulation time %.3f ns with respect to CLKA port at simulation time %.3f ns.  Expected setup time is %.3f ns", time_clkb_clka/1000.0, time_clkb/1000.0, time_clka/1000.0, SETUP_ALL/1000.0);
    end
    endtask

    always @(posedge setup_zero) begin
	if (data_addra_int[14:2] == data_addrb_int[14:2]) begin
	if ((ena_int == 1) && (enb_int == 1)) begin
	    case ({wr_mode_a, wr_mode_b, wea_int, web_int})
		6'b000011 : begin data_collision <= 2'b11; display_zero; end
		6'b000111 : begin data_collision <= 2'b11; display_zero; end
		6'b001011 : begin data_collision <= 2'b10; display_zero; end
		6'b010011 : begin data_collision <= 2'b11; display_zero; end
		6'b010111 : begin data_collision <= 2'b11; display_zero; end
		6'b011011 : begin data_collision <= 2'b10; display_zero; end
		6'b100011 : begin data_collision <= 2'b01; display_zero; end
		6'b100111 : begin data_collision <= 2'b01; display_zero; end
		6'b101011 : begin display_zero; end
		6'b000001 : begin data_collision <= 2'b10; display_zero; end
//		6'b000101 : begin data_collision <= 2'b00; display_zero; end
		6'b001001 : begin data_collision <= 2'b10; display_zero; end
		6'b010001 : begin data_collision <= 2'b10; display_zero; end
//		6'b010101 : begin data_collision <= 2'b00; display_zero; end
		6'b011001 : begin data_collision <= 2'b10; display_zero; end
		6'b100001 : begin data_collision <= 2'b10; display_zero; end
//		6'b100101 : begin data_collision <= 2'b00; display_zero; end
		6'b101001 : begin data_collision <= 2'b10; display_zero; end
		6'b000010 : begin data_collision <= 2'b01; display_zero; end
		6'b000110 : begin data_collision <= 2'b01; display_zero; end
		6'b001010 : begin data_collision <= 2'b01; display_zero; end
//		6'b010010 : begin data_collision <= 2'b00; display_zero; end
//		6'b010110 : begin data_collision <= 2'b00; display_zero; end
//		6'b011010 : begin data_collision <= 2'b00; display_zero; end
		6'b100010 : begin data_collision <= 2'b01; display_zero; end
		6'b100110 : begin data_collision <= 2'b01; display_zero; end
		6'b101010 : begin data_collision <= 2'b01; display_zero; end
	    endcase
	end
	end
	setup_zero <= 0;
    end

    task display_zero;
    begin
	    $display("Timing Violation Error : Setup time %.3f ns violated on X_RAMB16_S2_S4 instance %m on CLKA port at simulation time %.3f ns with respect to CLKB port at simulation time %.3f ns.  Expected setup time is %.3f ns", time_clka_clkb/1000.0, time_clka/1000.0, time_clkb/1000.0, SETUP_ALL/1000.0);
    end
    endtask

    always @(posedge setup_rf_a_b) begin
	if (data_addra_reg[14:2] == data_addrb_int[14:2]) begin
	if ((ena_reg == 1) && (enb_int == 1)) begin
	    case ({wr_mode_a, wr_mode_b, wea_reg, web_int})
//		6'b000011 : begin data_collision_a_b <= 2'b00; display_rf_a_b; end
//		6'b000111 : begin data_collision_a_b <= 2'b00; display_rf_a_b; end
//		6'b001011 : begin data_collision_a_b <= 2'b00; display_rf_a_b; end
		6'b010011 : begin data_collision_a_b <= 2'b11; display_rf_a_b; end
		6'b010111 : begin data_collision_a_b <= 2'b11; display_rf_a_b; end
		6'b011011 : begin data_collision_a_b <= 2'b10; display_rf_a_b; end
//		6'b100011 : begin data_collision_a_b <= 2'b00; display_rf_a_b; end
//		6'b100111 : begin data_collision_a_b <= 2'b00; display_rf_a_b; end
//		6'b101011 : begin data_collision_a_b <= 2'b00; display_rf_a_b; end
//		6'b000001 : begin data_collision_a_b <= 2'b00; display_rf_a_b; end
//		6'b000101 : begin data_collision_a_b <= 2'b00; display_rf_a_b; end
//		6'b001001 : begin data_collision_a_b <= 2'b00; display_rf_a_b; end
//		6'b010001 : begin data_collision_a_b <= 2'b00; display_rf_a_b; end
//		6'b010101 : begin data_collision_a_b <= 2'b00; display_rf_a_b; end
//		6'b011001 : begin data_collision_a_b <= 2'b00; display_rf_a_b; end
//		6'b100001 : begin data_collision_a_b <= 2'b00; display_rf_a_b; end
//		6'b100101 : begin data_collision_a_b <= 2'b00; display_rf_a_b; end
//		6'b101001 : begin data_collision_a_b <= 2'b00; display_rf_a_b; end
//		6'b000010 : begin data_collision_a_b <= 2'b00; display_rf_a_b; end
//		6'b000110 : begin data_collision_a_b <= 2'b00; display_rf_a_b; end
//		6'b001010 : begin data_collision_a_b <= 2'b00; display_rf_a_b; end
		6'b010010 : begin data_collision_a_b <= 2'b01; display_rf_a_b; end
		6'b010110 : begin data_collision_a_b <= 2'b01; display_rf_a_b; end
		6'b011010 : begin data_collision_a_b <= 2'b01; display_rf_a_b; end
//		6'b100010 : begin data_collision_a_b <= 2'b00; display_rf_a_b; end
//		6'b100110 : begin data_collision_a_b <= 2'b00; display_rf_a_b; end
//		6'b101010 : begin data_collision_a_b <= 2'b00; display_rf_a_b; end
	    endcase
	end
	end
	setup_rf_a_b <= 0;
    end

    task display_rf_a_b;
    begin
	    $display("Timing Violation Error : Setup time %.3f ns violated on X_RAMB16_S1_S1 instance %m on CLKA port at simulation time %.3f ns with respect to CLKB port at simulation time %.3f ns.  Expected setup time is %.3f ns", time_clka_clkb/1000.0, time_clka/1000.0, time_clkb/1000.0, SETUP_READ_FIRST/1000.0);
    end
    endtask

    always @(posedge setup_rf_b_a) begin
	if (data_addra_int[14:2] == data_addrb_reg[14:2]) begin
	if ((ena_int == 1) && (enb_reg == 1)) begin
	    case ({wr_mode_a, wr_mode_b, wea_int, web_reg})
//		6'b000011 : begin data_collision_b_a <= 2'b00; display_rf_b_a; end
		6'b000111 : begin data_collision_b_a <= 2'b11; display_rf_b_a; end
//		6'b001011 : begin data_collision_b_a <= 2'b00; display_rf_b_a; end
//		6'b010011 : begin data_collision_b_a <= 2'b00; display_rf_b_a; end
		6'b010111 : begin data_collision_b_a <= 2'b11; display_rf_b_a; end
//		6'b011011 : begin data_collision_b_a <= 2'b00; display_rf_b_a; end
//		6'b100011 : begin data_collision_b_a <= 2'b00; display_rf_b_a; end
		6'b100111 : begin data_collision_b_a <= 2'b01; display_rf_b_a; end
//		6'b101011 : begin data_collision_b_a <= 2'b00; display_rf_b_a; end
//		6'b000001 : begin data_collision_b_a <= 2'b00; display_rf_b_a; end
		6'b000101 : begin data_collision_b_a <= 2'b10; display_rf_b_a; end
//		6'b001001 : begin data_collision_b_a <= 2'b00; display_rf_b_a; end
//		6'b010001 : begin data_collision_b_a <= 2'b00; display_rf_b_a; end
		6'b010101 : begin data_collision_b_a <= 2'b10; display_rf_b_a; end
//		6'b011001 : begin data_collision_b_a <= 2'b00; display_rf_b_a; end
//		6'b100001 : begin data_collision_b_a <= 2'b00; display_rf_b_a; end
		6'b100101 : begin data_collision_b_a <= 2'b10; display_rf_b_a; end
//		6'b101001 : begin data_collision_b_a <= 2'b00; display_rf_b_a; end
//		6'b000010 : begin data_collision_b_a <= 2'b00; display_rf_b_a; end
//		6'b000110 : begin data_collision_b_a <= 2'b00; display_rf_b_a; end
//		6'b001010 : begin data_collision_b_a <= 2'b00; display_rf_b_a; end
//		6'b010010 : begin data_collision_b_a <= 2'b00; display_rf_b_a; end
//		6'b010110 : begin data_collision_b_a <= 2'b00; display_rf_b_a; end
//		6'b011010 : begin data_collision_b_a <= 2'b00; display_rf_b_a; end
//		6'b100010 : begin data_collision_b_a <= 2'b00; display_rf_b_a; end
//		6'b100110 : begin data_collision_b_a <= 2'b00; display_rf_b_a; end
//		6'b101010 : begin data_collision_b_a <= 2'b00; display_rf_b_a; end
	    endcase
	end
	end
	setup_rf_b_a <= 0;
    end

    task display_rf_b_a;
    begin
	    $display("Timing Violation Error : Setup time %.3f ns violated on X_RAMB16_S1_S1 instance %m on CLKB port at simulation time %.3f ns with respect to CLKA port at simulation time %.3f ns.  Expected setup time is %.3f ns", time_clkb_clka/1000.0, time_clkb/1000.0, time_clka/1000.0, SETUP_READ_FIRST/1000.0);
    end
    endtask

    always @(posedge clka_int) begin
	addra_reg <= addra_int;
	ena_reg <= ena_int;
	ssra_reg <= ssra_int;
	wea_reg <= wea_int;
    end

    always @(posedge clkb_int) begin
	addrb_reg <= addrb_int;
	enb_reg <= enb_int;
	ssrb_reg <= ssrb_int;
	web_reg <= web_int;
    end

    // Data
    always @(posedge memory_collision) begin
	for (dmi = 0; dmi < 2; dmi = dmi + 1) begin
	    mem[data_addra_int + dmi] <= 1'bX;
	end
	memory_collision <= 0;
    end

    always @(posedge memory_collision_a_b) begin
	for (dmi = 0; dmi < 2; dmi = dmi + 1) begin
	    mem[data_addra_reg + dmi] <= 1'bX;
	end
	memory_collision_a_b <= 0;
    end

    always @(posedge memory_collision_b_a) begin
	for (dmi = 0; dmi < 2; dmi = dmi + 1) begin
	    mem[data_addra_int + dmi] <= 1'bX;
	end
	memory_collision_b_a <= 0;
    end

    always @(posedge data_collision[1]) begin
	if (ssra_int == 0) begin
	    doa_out <= 2'bX;
	end
	data_collision[1] <= 0;
    end

    always @(posedge data_collision[0]) begin
	if (ssrb_int == 0) begin
	    for (dbi = 0; dbi < 2; dbi = dbi + 1) begin
		dob_out[data_addra_int[1 : 0] + dbi] <= 1'bX;
	    end
	end
	data_collision[0] <= 0;
    end

    always @(posedge data_collision_a_b[1]) begin
	if (ssra_reg == 0) begin
	    doa_out <= 2'bX;
	end
	data_collision_a_b[1] <= 0;
    end

    always @(posedge data_collision_a_b[0]) begin
	if (ssrb_int == 0) begin
	    for (dbi = 0; dbi < 2; dbi = dbi + 1) begin
		dob_out[data_addra_reg[1 : 0] + dbi] <= 1'bX;
	    end
	end
	data_collision_a_b[0] <= 0;
    end

    always @(posedge data_collision_b_a[1]) begin
	if (ssra_int == 0) begin
	    doa_out <= 2'bX;
	end
	data_collision_b_a[1] <= 0;
    end

    always @(posedge data_collision_b_a[0]) begin
	if (ssrb_reg == 0) begin
	    for (dbi = 0; dbi < 2; dbi = dbi + 1) begin
		dob_out[data_addra_int[1 : 0] + dbi] <= 1'bX;
	    end
	end
	data_collision_b_a[0] <= 0;
    end

`endif

    initial begin
	case (WRITE_MODE_A)
	    "WRITE_FIRST" : wr_mode_a <= 2'b00;
	    "READ_FIRST"  : wr_mode_a <= 2'b01;
	    "NO_CHANGE"   : wr_mode_a <= 2'b10;
	    default       : begin
				$display("Attribute Syntax Error : The Attribute WRITE_MODE_A on X_RAMB16_S2_S4 instance %m is set to %s.  Legal values for this attribute are WRITE_FIRST, READ_FIRST or NO_CHANGE.", WRITE_MODE_A);
				$finish;
			    end
	endcase
    end

    initial begin
	case (WRITE_MODE_B)
	    "WRITE_FIRST" : wr_mode_b <= 2'b00;
	    "READ_FIRST"  : wr_mode_b <= 2'b01;
	    "NO_CHANGE"   : wr_mode_b <= 2'b10;
	    default       : begin
				$display("Attribute Syntax Error : The Attribute WRITE_MODE_B on X_RAMB16_S2_S4 instance %m is set to %s.  Legal values for this attribute are WRITE_FIRST, READ_FIRST or NO_CHANGE.", WRITE_MODE_B);
				$finish;
			    end
	endcase
    end

    // Port A
    always @(posedge clka_int) begin
	if (ena_int == 1'b1) begin
	    if (ssra_int == 1'b1) begin
		doa_out[0] <= SRVAL_A[0];
		doa_out[1] <= SRVAL_A[1];
	    end
	    else begin
		if (wea_int == 1'b1) begin
		    if (wr_mode_a == 2'b00) begin
			doa_out <= dia_int;
		    end
		    else if (wr_mode_a == 2'b01) begin
			doa_out[0] <= mem[data_addra_int + 0];
			doa_out[1] <= mem[data_addra_int + 1];
		    end
		end
		else begin
		    doa_out[0] <= mem[data_addra_int + 0];
		    doa_out[1] <= mem[data_addra_int + 1];
		end
	    end
	end
    end

    always @(posedge clka_int) begin
	if (ena_int == 1'b1 && wea_int == 1'b1) begin
	    mem[data_addra_int + 0] <= dia_int[0];
	    mem[data_addra_int + 1] <= dia_int[1];
	end
    end

    // Port B
    always @(posedge clkb_int) begin
	if (enb_int == 1'b1) begin
	    if (ssrb_int == 1'b1) begin
		dob_out[0] <= SRVAL_B[0];
		dob_out[1] <= SRVAL_B[1];
		dob_out[2] <= SRVAL_B[2];
		dob_out[3] <= SRVAL_B[3];
	    end
	    else begin
		if (web_int == 1'b1) begin
		    if (wr_mode_b == 2'b00) begin
			dob_out <= dib_int;
		    end
		    else if (wr_mode_b == 2'b01) begin
			dob_out[0] <= mem[data_addrb_int + 0];
			dob_out[1] <= mem[data_addrb_int + 1];
			dob_out[2] <= mem[data_addrb_int + 2];
			dob_out[3] <= mem[data_addrb_int + 3];
		    end
		end
		else begin
		    dob_out[0] <= mem[data_addrb_int + 0];
		    dob_out[1] <= mem[data_addrb_int + 1];
		    dob_out[2] <= mem[data_addrb_int + 2];
		    dob_out[3] <= mem[data_addrb_int + 3];
		end
	    end
	end
    end

    always @(posedge clkb_int) begin
	if (enb_int == 1'b1 && web_int == 1'b1) begin
	    mem[data_addrb_int + 0] <= dib_int[0];
	    mem[data_addrb_int + 1] <= dib_int[1];
	    mem[data_addrb_int + 2] <= dib_int[2];
	    mem[data_addrb_int + 3] <= dib_int[3];
	end
    end

    always @(notifier or notifier_a) begin
	doa_out[0] <= 1'bx;
	doa_out[1] <= 1'bx;
    end 

    always @(notifier or notifier_b) begin
	dob_out[0] <= 1'bx;
	dob_out[1] <= 1'bx;
	dob_out[2] <= 1'bx;
	dob_out[3] <= 1'bx;
    end

    specify

        (CLKA => DOA[0]) = (0:0:0, 0:0:0);
        (CLKA => DOA[1]) = (0:0:0, 0:0:0);
        (CLKB => DOB[0]) = (0:0:0, 0:0:0);
        (CLKB => DOB[1]) = (0:0:0, 0:0:0);
        (CLKB => DOB[2]) = (0:0:0, 0:0:0);
        (CLKB => DOB[3]) = (0:0:0, 0:0:0);
        (GSR => DOA[0]) = (0:0:0, 0:0:0);
        (GSR => DOA[1]) = (0:0:0, 0:0:0);
        (GSR => DOB[0]) = (0:0:0, 0:0:0);
        (GSR => DOB[1]) = (0:0:0, 0:0:0);
        (GSR => DOB[2]) = (0:0:0, 0:0:0);
        (GSR => DOB[3]) = (0:0:0, 0:0:0);

       	$setuphold (posedge CLKA, posedge ADDRA[0] &&& ENA, 0:0:0, 0:0:0, notifier_a);
       	$setuphold (posedge CLKA, negedge ADDRA[0] &&& ENA, 0:0:0, 0:0:0, notifier_a);
       	$setuphold (posedge CLKA, posedge ADDRA[1] &&& ENA, 0:0:0, 0:0:0, notifier_a);
       	$setuphold (posedge CLKA, negedge ADDRA[1] &&& ENA, 0:0:0, 0:0:0, notifier_a);
       	$setuphold (posedge CLKA, posedge ADDRA[2] &&& ENA, 0:0:0, 0:0:0, notifier_a);
       	$setuphold (posedge CLKA, negedge ADDRA[2] &&& ENA, 0:0:0, 0:0:0, notifier_a);
       	$setuphold (posedge CLKA, posedge ADDRA[3] &&& ENA, 0:0:0, 0:0:0, notifier_a);
       	$setuphold (posedge CLKA, negedge ADDRA[3] &&& ENA, 0:0:0, 0:0:0, notifier_a);
       	$setuphold (posedge CLKA, posedge ADDRA[4] &&& ENA, 0:0:0, 0:0:0, notifier_a);
       	$setuphold (posedge CLKA, negedge ADDRA[4] &&& ENA, 0:0:0, 0:0:0, notifier_a);
       	$setuphold (posedge CLKA, posedge ADDRA[5] &&& ENA, 0:0:0, 0:0:0, notifier_a);
       	$setuphold (posedge CLKA, negedge ADDRA[5] &&& ENA, 0:0:0, 0:0:0, notifier_a);
       	$setuphold (posedge CLKA, posedge ADDRA[6] &&& ENA, 0:0:0, 0:0:0, notifier_a);
       	$setuphold (posedge CLKA, negedge ADDRA[6] &&& ENA, 0:0:0, 0:0:0, notifier_a);
       	$setuphold (posedge CLKA, posedge ADDRA[7] &&& ENA, 0:0:0, 0:0:0, notifier_a);
       	$setuphold (posedge CLKA, negedge ADDRA[7] &&& ENA, 0:0:0, 0:0:0, notifier_a);
       	$setuphold (posedge CLKA, posedge ADDRA[8] &&& ENA, 0:0:0, 0:0:0, notifier_a);
       	$setuphold (posedge CLKA, negedge ADDRA[8] &&& ENA, 0:0:0, 0:0:0, notifier_a);
       	$setuphold (posedge CLKA, posedge ADDRA[9] &&& ENA, 0:0:0, 0:0:0, notifier_a);
       	$setuphold (posedge CLKA, negedge ADDRA[9] &&& ENA, 0:0:0, 0:0:0, notifier_a);
       	$setuphold (posedge CLKA, posedge ADDRA[10] &&& ENA, 0:0:0, 0:0:0, notifier_a);
       	$setuphold (posedge CLKA, negedge ADDRA[10] &&& ENA, 0:0:0, 0:0:0, notifier_a);
       	$setuphold (posedge CLKA, posedge ADDRA[11] &&& ENA, 0:0:0, 0:0:0, notifier_a);
       	$setuphold (posedge CLKA, negedge ADDRA[11] &&& ENA, 0:0:0, 0:0:0, notifier_a);
       	$setuphold (posedge CLKA, posedge ADDRA[12] &&& ENA, 0:0:0, 0:0:0, notifier_a);
       	$setuphold (posedge CLKA, negedge ADDRA[12] &&& ENA, 0:0:0, 0:0:0, notifier_a);
       	$setuphold (posedge CLKA, posedge DIA[0] &&& dia_enable, 0:0:0, 0:0:0, notifier_a);
       	$setuphold (posedge CLKA, negedge DIA[0] &&& dia_enable, 0:0:0, 0:0:0, notifier_a);
       	$setuphold (posedge CLKA, posedge DIA[1] &&& dia_enable, 0:0:0, 0:0:0, notifier_a);
       	$setuphold (posedge CLKA, negedge DIA[1] &&& dia_enable, 0:0:0, 0:0:0, notifier_a);
       	$setuphold (posedge CLKA, posedge ENA, 0:0:0, 0:0:0, notifier_a);
       	$setuphold (posedge CLKA, negedge ENA, 0:0:0, 0:0:0, notifier_a);
       	$setuphold (posedge CLKA, posedge SSRA &&& ENA, 0:0:0, 0:0:0, notifier_a);
       	$setuphold (posedge CLKA, negedge SSRA &&& ENA, 0:0:0, 0:0:0, notifier_a);
       	$setuphold (posedge CLKA, posedge WEA &&& ENA, 0:0:0, 0:0:0, notifier_a);
       	$setuphold (posedge CLKA, negedge WEA &&& ENA, 0:0:0, 0:0:0, notifier_a);
       	$recrem (negedge GSR, posedge CLKA, 0:0:0, 0:0:0, notifier_a);

       	$setuphold (posedge CLKB, posedge ADDRB[0] &&& ENB, 0:0:0, 0:0:0, notifier_b);
       	$setuphold (posedge CLKB, negedge ADDRB[0] &&& ENB, 0:0:0, 0:0:0, notifier_b);
       	$setuphold (posedge CLKB, posedge ADDRB[1] &&& ENB, 0:0:0, 0:0:0, notifier_b);
       	$setuphold (posedge CLKB, negedge ADDRB[1] &&& ENB, 0:0:0, 0:0:0, notifier_b);
       	$setuphold (posedge CLKB, posedge ADDRB[2] &&& ENB, 0:0:0, 0:0:0, notifier_b);
       	$setuphold (posedge CLKB, negedge ADDRB[2] &&& ENB, 0:0:0, 0:0:0, notifier_b);
       	$setuphold (posedge CLKB, posedge ADDRB[3] &&& ENB, 0:0:0, 0:0:0, notifier_b);
       	$setuphold (posedge CLKB, negedge ADDRB[3] &&& ENB, 0:0:0, 0:0:0, notifier_b);
       	$setuphold (posedge CLKB, posedge ADDRB[4] &&& ENB, 0:0:0, 0:0:0, notifier_b);
       	$setuphold (posedge CLKB, negedge ADDRB[4] &&& ENB, 0:0:0, 0:0:0, notifier_b);
       	$setuphold (posedge CLKB, posedge ADDRB[5] &&& ENB, 0:0:0, 0:0:0, notifier_b);
       	$setuphold (posedge CLKB, negedge ADDRB[5] &&& ENB, 0:0:0, 0:0:0, notifier_b);
       	$setuphold (posedge CLKB, posedge ADDRB[6] &&& ENB, 0:0:0, 0:0:0, notifier_b);
       	$setuphold (posedge CLKB, negedge ADDRB[6] &&& ENB, 0:0:0, 0:0:0, notifier_b);
       	$setuphold (posedge CLKB, posedge ADDRB[7] &&& ENB, 0:0:0, 0:0:0, notifier_b);
       	$setuphold (posedge CLKB, negedge ADDRB[7] &&& ENB, 0:0:0, 0:0:0, notifier_b);
       	$setuphold (posedge CLKB, posedge ADDRB[8] &&& ENB, 0:0:0, 0:0:0, notifier_b);
       	$setuphold (posedge CLKB, negedge ADDRB[8] &&& ENB, 0:0:0, 0:0:0, notifier_b);
       	$setuphold (posedge CLKB, posedge ADDRB[9] &&& ENB, 0:0:0, 0:0:0, notifier_b);
       	$setuphold (posedge CLKB, negedge ADDRB[9] &&& ENB, 0:0:0, 0:0:0, notifier_b);
       	$setuphold (posedge CLKB, posedge ADDRB[10] &&& ENB, 0:0:0, 0:0:0, notifier_b);
       	$setuphold (posedge CLKB, negedge ADDRB[10] &&& ENB, 0:0:0, 0:0:0, notifier_b);
       	$setuphold (posedge CLKB, posedge ADDRB[11] &&& ENB, 0:0:0, 0:0:0, notifier_b);
       	$setuphold (posedge CLKB, negedge ADDRB[11] &&& ENB, 0:0:0, 0:0:0, notifier_b);
       	$setuphold (posedge CLKB, posedge DIB[0] &&& dib_enable, 0:0:0, 0:0:0, notifier_b);
       	$setuphold (posedge CLKB, negedge DIB[0] &&& dib_enable, 0:0:0, 0:0:0, notifier_b);
       	$setuphold (posedge CLKB, posedge DIB[1] &&& dib_enable, 0:0:0, 0:0:0, notifier_b);
       	$setuphold (posedge CLKB, negedge DIB[1] &&& dib_enable, 0:0:0, 0:0:0, notifier_b);
       	$setuphold (posedge CLKB, posedge DIB[2] &&& dib_enable, 0:0:0, 0:0:0, notifier_b);
       	$setuphold (posedge CLKB, negedge DIB[2] &&& dib_enable, 0:0:0, 0:0:0, notifier_b);
       	$setuphold (posedge CLKB, posedge DIB[3] &&& dib_enable, 0:0:0, 0:0:0, notifier_b);
       	$setuphold (posedge CLKB, negedge DIB[3] &&& dib_enable, 0:0:0, 0:0:0, notifier_b);
       	$setuphold (posedge CLKB, posedge ENB, 0:0:0, 0:0:0, notifier_b);
       	$setuphold (posedge CLKB, negedge ENB, 0:0:0, 0:0:0, notifier_b);
       	$setuphold (posedge CLKB, posedge SSRB &&& ENB, 0:0:0, 0:0:0, notifier_b);
       	$setuphold (posedge CLKB, negedge SSRB &&& ENB, 0:0:0, 0:0:0, notifier_b);
       	$setuphold (posedge CLKB, posedge WEB &&& ENB, 0:0:0, 0:0:0, notifier_b);
       	$setuphold (posedge CLKB, negedge WEB &&& ENB, 0:0:0, 0:0:0, notifier_b);
       	$recrem (negedge GSR, posedge CLKB, 0:0:0, 0:0:0, notifier_b);

        $width (posedge CLKA &&& ENA, 0:0:0, 0, notifier_a);
        $width (negedge CLKA &&& ENA, 0:0:0, 0, notifier_a);
        $width (posedge CLKB &&& ENB, 0:0:0, 0, notifier_b);
        $width (negedge CLKB &&& ENB, 0:0:0, 0, notifier_b);
        $width (posedge GSR, 0:0:0, 0, notifier);

	specparam PATHPULSE$ = 0;

    endspecify

endmodule
