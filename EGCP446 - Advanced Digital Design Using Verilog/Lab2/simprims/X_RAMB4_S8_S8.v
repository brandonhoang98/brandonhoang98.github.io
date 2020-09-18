//    Xilinx Proprietary Primitive Cell X_RAMB4_S8_S8 for Verilog
//
// $Header: /devl/xcs/repo/env/Databases/CAEInterfaces/versclibs/data/X_RAMB4_S8_S8.v,v 1.29 2003/05/28 01:17:29 wloo Exp $
//

`timescale 1 ps/1 ps

module X_RAMB4_S8_S8 (DOA, DOB, ADDRA, ADDRB, CLKA, CLKB, DIA, DIB, ENA, ENB, GSR, RSTA, RSTB, WEA, WEB);

    parameter SETUP_ALL = 100;

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

    output [7:0] DOA;
    reg [7:0] doa_out;
    wire doa_out0, doa_out1, doa_out2, doa_out3, doa_out4, doa_out5, doa_out6, doa_out7;

    input [8:0] ADDRA;
    input [7:0] DIA;
    input ENA, CLKA, WEA, RSTA;

    output [7:0] DOB;
    reg [7:0] dob_out;
    wire dob_out0, dob_out1, dob_out2, dob_out3, dob_out4, dob_out5, dob_out6, dob_out7;

    input [8:0] ADDRB;
    input [7:0] DIB;
    input ENB, CLKB, WEB, RSTB;

    reg [4095:0] mem;
    reg [8:0] count;

    reg [5:0] mi, mj, ai, aj, bi, bj, ci, cj, di, dj, ei, ej, fi, fj;

    wire [8:0] addra_int;
    reg [8:0] addra_reg;
    wire [7:0] dia_int;
    wire ena_int, clka_int, wea_int, rsta_int;
    reg ena_reg, wea_reg, rsta_reg;
    wire [8:0] addrb_int;
    reg [8:0] addrb_reg;
    wire [7:0] dib_int;
    wire enb_int, clkb_int, web_int, rstb_int;
    reg enb_reg, web_reg, rstb_reg;

    time time_clka, time_clkb;
    time time_clka_clkb;
    time time_clkb_clka;

    reg setup_all_a_b;
    reg setup_all_b_a;
    reg setup_zero;
    reg [1:0] data_collision, data_collision_a_b, data_collision_b_a;
    reg memory_collision, memory_collision_a_b, memory_collision_b_a;
    reg address_collision, address_collision_a_b, address_collision_b_a;
    reg change_clka;
    reg change_clkb;

    wire dia_enable = ena_int && wea_int;
    wire dib_enable = enb_int && web_int;
    reg notifier, notifier_a, notifier_b;

    wire [11:0] mem_addra_int;
    wire [11:0] mem_addra_reg;
    wire [11:0] mem_addrb_int;
    wire [11:0] mem_addrb_reg;

    input GSR;
    wire gsr_int;

    always @(gsr_int)
	if (gsr_int) begin
	    assign doa_out = 0;
	end
	else begin
	    deassign doa_out;
	end

    always @(gsr_int)
	if (gsr_int) begin
	    assign dob_out = 0;
	end
	else begin
	    deassign dob_out;
	end

    buf b_gsr (gsr_int, GSR);
    buf b_doa_out0 (doa_out0, doa_out[0]);
    buf b_doa_out1 (doa_out1, doa_out[1]);
    buf b_doa_out2 (doa_out2, doa_out[2]);
    buf b_doa_out3 (doa_out3, doa_out[3]);
    buf b_doa_out4 (doa_out4, doa_out[4]);
    buf b_doa_out5 (doa_out5, doa_out[5]);
    buf b_doa_out6 (doa_out6, doa_out[6]);
    buf b_doa_out7 (doa_out7, doa_out[7]);
    buf b_dob_out0 (dob_out0, dob_out[0]);
    buf b_dob_out1 (dob_out1, dob_out[1]);
    buf b_dob_out2 (dob_out2, dob_out[2]);
    buf b_dob_out3 (dob_out3, dob_out[3]);
    buf b_dob_out4 (dob_out4, dob_out[4]);
    buf b_dob_out5 (dob_out5, dob_out[5]);
    buf b_dob_out6 (dob_out6, dob_out[6]);
    buf b_dob_out7 (dob_out7, dob_out[7]);
    buf b_doa0 (DOA[0], doa_out0);
    buf b_doa1 (DOA[1], doa_out1);
    buf b_doa2 (DOA[2], doa_out2);
    buf b_doa3 (DOA[3], doa_out3);
    buf b_doa4 (DOA[4], doa_out4);
    buf b_doa5 (DOA[5], doa_out5);
    buf b_doa6 (DOA[6], doa_out6);
    buf b_doa7 (DOA[7], doa_out7);
    buf b_dob0 (DOB[0], dob_out0);
    buf b_dob1 (DOB[1], dob_out1);
    buf b_dob2 (DOB[2], dob_out2);
    buf b_dob3 (DOB[3], dob_out3);
    buf b_dob4 (DOB[4], dob_out4);
    buf b_dob5 (DOB[5], dob_out5);
    buf b_dob6 (DOB[6], dob_out6);
    buf b_dob7 (DOB[7], dob_out7);
    buf b_addra_0 (addra_int[0], ADDRA[0]);
    buf b_addra_1 (addra_int[1], ADDRA[1]);
    buf b_addra_2 (addra_int[2], ADDRA[2]);
    buf b_addra_3 (addra_int[3], ADDRA[3]);
    buf b_addra_4 (addra_int[4], ADDRA[4]);
    buf b_addra_5 (addra_int[5], ADDRA[5]);
    buf b_addra_6 (addra_int[6], ADDRA[6]);
    buf b_addra_7 (addra_int[7], ADDRA[7]);
    buf b_addra_8 (addra_int[8], ADDRA[8]);
    buf b_dia_0 (dia_int[0], DIA[0]);
    buf b_dia_1 (dia_int[1], DIA[1]);
    buf b_dia_2 (dia_int[2], DIA[2]);
    buf b_dia_3 (dia_int[3], DIA[3]);
    buf b_dia_4 (dia_int[4], DIA[4]);
    buf b_dia_5 (dia_int[5], DIA[5]);
    buf b_dia_6 (dia_int[6], DIA[6]);
    buf b_dia_7 (dia_int[7], DIA[7]);
    buf b_clka (clka_int, CLKA);
    buf b_ena (ena_int, ENA);
    buf b_rsta (rsta_int, RSTA);
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
    buf b_dib_0 (dib_int[0], DIB[0]);
    buf b_dib_1 (dib_int[1], DIB[1]);
    buf b_dib_2 (dib_int[2], DIB[2]);
    buf b_dib_3 (dib_int[3], DIB[3]);
    buf b_dib_4 (dib_int[4], DIB[4]);
    buf b_dib_5 (dib_int[5], DIB[5]);
    buf b_dib_6 (dib_int[6], DIB[6]);
    buf b_dib_7 (dib_int[7], DIB[7]);
    buf b_clkb (clkb_int, CLKB);
    buf b_enb (enb_int, ENB);
    buf b_rstb (rstb_int, RSTB);
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
    end

    assign mem_addra_int = addra_int * 8;
    assign mem_addra_reg = addra_reg * 8;
    assign mem_addrb_int = addrb_int * 8;
    assign mem_addrb_reg = addrb_reg * 8;

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
    end

    always @(change_clka) begin
	if ((0 < time_clkb_clka) && (time_clkb_clka < SETUP_ALL))
	    setup_all_b_a = 1;
    end

    always @(change_clkb or change_clka) begin
	if ((time_clkb_clka == 0) && (time_clka_clkb == 0))
	    setup_zero = 1;
    end

    always @(posedge setup_zero) begin
	if ((ena_int == 1) && (wea_int == 1) &&
	    (enb_int == 1) && (web_int == 1))
	    memory_collision <= 1;
    end

    always @(posedge setup_all_a_b) begin
	if ((ena_reg == 1) && (enb_int == 1)) begin
	    case ({wea_reg, web_int})
		6'b11 : begin data_collision_a_b <= 2'b11; display_all_a_b; end
		6'b01 : begin data_collision_a_b <= 2'b10; display_all_a_b; end
		6'b10 : begin data_collision_a_b <= 2'b01; display_all_a_b; end
	    endcase
	end
	setup_all_a_b <= 0;
    end

    task display_all_a_b;
    begin
	address_collision_a_b = 1'b0;
	for (ci = 0; ci < 8; ci = ci + 8) begin
	    if ((mem_addra_reg) == (mem_addrb_int + ci)) begin
		address_collision_a_b = 1'b1;
	    end
	end
	if (address_collision_a_b == 1'b1)
	    $display("Timing Violation Error : Setup time %.3f ns violated on X_RAMB4_S8_S8 instance %m on CLKA port at simulation time %.3f ns with respect to CLKB port at simulation time %.3f ns.  Expected setup time is %.3f ns", time_clka_clkb/1000.0, time_clka/1000.0, time_clkb/1000.0, SETUP_ALL/1000.0);
    end
    endtask

    always @(posedge setup_all_b_a) begin
	if ((ena_int == 1) && (enb_reg == 1)) begin
	    case ({wea_int, web_reg})
		6'b11 : begin data_collision_b_a <= 2'b11; display_all_b_a; end
		6'b01 : begin data_collision_b_a <= 2'b10; display_all_b_a; end
		6'b10 : begin data_collision_b_a <= 2'b01; display_all_b_a; end
	    endcase
	end
	setup_all_b_a <= 0;
    end

    task display_all_b_a;
    begin
	address_collision_b_a = 1'b0;
	for (ci = 0; ci < 8; ci = ci + 8) begin
	    if ((mem_addra_int) == (mem_addrb_reg + ci)) begin
		address_collision_b_a = 1'b1;
	    end
	end
	if (address_collision_b_a == 1'b1)
	    $display("Timing Violation Error : Setup time %.3f ns violated on X_RAMB16_S1_S1 instance %m on CLKB port at simulation time %.3f ns with respect to CLKA port at simulation time %.3f ns.  Expected setup time is %.3f ns", time_clkb_clka/1000.0, time_clkb/1000.0, time_clka/1000.0, SETUP_ALL/1000.0);
    end
    endtask

    always @(posedge setup_zero) begin
	if ((ena_int == 1) && (enb_int == 1)) begin
	    case ({wea_int, web_int})
		6'b11 : begin data_collision <= 2'b11; display_zero; end
		6'b01 : begin data_collision <= 2'b10; display_zero; end
		6'b10 : begin data_collision <= 2'b01; display_zero; end
	    endcase
	end
	setup_zero <= 0;
    end

    task display_zero;
    begin
	address_collision = 1'b0;
	for (ci = 0; ci < 8; ci = ci + 8) begin
	    if ((mem_addra_int) == (mem_addrb_int + ci)) begin
		address_collision = 1'b1;
	    end
	end
	if (address_collision == 1'b1)
	    $display("Timing Violation Error : Setup time %.3f ns violated on X_RAMB4_S8_S8 instance %m on CLKA port at simulation time %.3f ns with respect to CLKB port at simulation time %.3f ns.  Expected setup time is %.3f ns", time_clka_clkb/1000.0, time_clka/1000.0, time_clkb/1000.0, SETUP_ALL/1000.0);
    end
    endtask

    always @(posedge clka_int) begin
	addra_reg <= addra_int;
	ena_reg <= ena_int;
	rsta_reg <= rsta_int;
	wea_reg <= wea_int;
    end

    always @(posedge clkb_int) begin
	addrb_reg <= addrb_int;
	enb_reg <= enb_int;
	rstb_reg <= rstb_int;
	web_reg <= web_int;
    end

    // Data
    always @(posedge memory_collision) begin
	for (mi = 0; mi < 8; mi = mi + 8) begin
	    if ((mem_addra_int) == (mem_addrb_int + mi)) begin
		for (mj = 0; mj < 8; mj = mj + 1) begin
		    mem[mem_addrb_int + mi + mj] <= 1'bX;
		end
	    end
	end
	memory_collision <= 0;
    end

    always @(posedge memory_collision_a_b) begin
	for (mi = 0; mi < 8; mi = mi + 8) begin
	    if ((mem_addra_reg) == (mem_addrb_int + mi)) begin
		for (mj = 0; mj < 8; mj = mj + 1) begin
		    mem[mem_addrb_int + mi + mj] <= 1'bX;
		end
	    end
	end
	memory_collision_a_b <= 0;
    end

    always @(posedge memory_collision_b_a) begin
	for (mi = 0; mi < 8; mi = mi + 8) begin
	    if ((mem_addra_int) == (mem_addrb_reg + mi)) begin
		for (mj = 0; mj < 8; mj = mj + 1) begin
		    mem[mem_addrb_reg + mi + mj] <= 1'bX;
		end
	    end
	end
	memory_collision_b_a <= 0;
    end

    always @(posedge data_collision[1]) begin
	if (rsta_int == 0) begin
	    for (ai = 0; ai < 8; ai = ai + 8) begin
		if ((mem_addra_int) == (mem_addrb_int + ai)) begin
		    doa_out <= 8'bX;
		end
	    end
	end
	data_collision[1] <= 0;
    end

    always @(posedge data_collision[0]) begin
	if (rstb_int == 0) begin
	    for (bi = 0; bi < 8; bi = bi + 8) begin
		if ((mem_addra_int) == (mem_addrb_int + bi)) begin
		    for (bj = 0; bj < 8; bj = bj + 1) begin
			dob_out[bi + bj] <= 1'bX;
		    end
		end
	    end
	end
	data_collision[0] <= 0;
    end

    always @(posedge data_collision_a_b[1]) begin
	if (rsta_reg == 0) begin
	    for (ai = 0; ai < 8; ai = ai + 8) begin
		if ((mem_addra_reg) == (mem_addrb_int + ai)) begin
		    doa_out <= 8'bX;
		end
	    end
	end
	data_collision_a_b[1] <= 0;
    end

    always @(posedge data_collision_a_b[0]) begin
	if (rstb_int == 0) begin
	    for (bi = 0; bi < 8; bi = bi + 8) begin
		if ((mem_addra_reg) == (mem_addrb_int + bi)) begin
		    for (bj = 0; bj < 8; bj = bj + 1) begin
			dob_out[bi + bj] <= 1'bX;
		    end
		end
	    end
	end
	data_collision_a_b[0] <= 0;
    end

    always @(posedge data_collision_b_a[1]) begin
	if (rsta_int == 0) begin
	    for (ai = 0; ai < 8; ai = ai + 8) begin
		if ((mem_addra_int) == (mem_addrb_reg + ai)) begin
		    doa_out <= 8'bX;
		end
	    end
	end
	data_collision_b_a[1] <= 0;
    end

    always @(posedge data_collision_b_a[0]) begin
	if (rstb_reg == 0) begin
	    for (bi = 0; bi < 8; bi = bi + 8) begin
		if ((mem_addra_int) == (mem_addrb_reg + bi)) begin
		    for (bj = 0; bj < 8; bj = bj + 1) begin
			dob_out[bi + bj] <= 1'bX;
		    end
		end
	    end
	end
	data_collision_b_a[0] <= 0;
    end

`endif

    always @(posedge clka_int) begin
	if (ena_int == 1'b1) begin
	    if (rsta_int == 1'b1) begin
		doa_out <= 8'b0;
	    end
	    else if (wea_int == 0) begin
		doa_out[0] <= mem[mem_addra_int + 0];
		doa_out[1] <= mem[mem_addra_int + 1];
		doa_out[2] <= mem[mem_addra_int + 2];
		doa_out[3] <= mem[mem_addra_int + 3];
		doa_out[4] <= mem[mem_addra_int + 4];
		doa_out[5] <= mem[mem_addra_int + 5];
		doa_out[6] <= mem[mem_addra_int + 6];
		doa_out[7] <= mem[mem_addra_int + 7];
	    end
	    else begin
		doa_out <= dia_int;
	    end
	end
    end

    always @(posedge clka_int) begin
	if (ena_int == 1'b1 && wea_int == 1'b1) begin
	    mem[mem_addra_int + 0] <= dia_int[0];
	    mem[mem_addra_int + 1] <= dia_int[1];
	    mem[mem_addra_int + 2] <= dia_int[2];
	    mem[mem_addra_int + 3] <= dia_int[3];
	    mem[mem_addra_int + 4] <= dia_int[4];
	    mem[mem_addra_int + 5] <= dia_int[5];
	    mem[mem_addra_int + 6] <= dia_int[6];
	    mem[mem_addra_int + 7] <= dia_int[7];
	end
    end

    always @(posedge clkb_int) begin
	if (enb_int == 1'b1) begin
	    if (rstb_int == 1'b1) begin
		dob_out <= 8'b0;
	    end
	    else if (web_int == 0) begin
		dob_out[0] <= mem[mem_addrb_int + 0];
		dob_out[1] <= mem[mem_addrb_int + 1];
		dob_out[2] <= mem[mem_addrb_int + 2];
		dob_out[3] <= mem[mem_addrb_int + 3];
		dob_out[4] <= mem[mem_addrb_int + 4];
		dob_out[5] <= mem[mem_addrb_int + 5];
		dob_out[6] <= mem[mem_addrb_int + 6];
		dob_out[7] <= mem[mem_addrb_int + 7];
	    end
	    else begin
		dob_out <= dib_int;
	    end
	end
    end

    always @(posedge clkb_int) begin
	if (enb_int == 1'b1 && web_int == 1'b1) begin
	    mem[mem_addrb_int + 0] <= dib_int[0];
	    mem[mem_addrb_int + 1] <= dib_int[1];
	    mem[mem_addrb_int + 2] <= dib_int[2];
	    mem[mem_addrb_int + 3] <= dib_int[3];
	    mem[mem_addrb_int + 4] <= dib_int[4];
	    mem[mem_addrb_int + 5] <= dib_int[5];
	    mem[mem_addrb_int + 6] <= dib_int[6];
	    mem[mem_addrb_int + 7] <= dib_int[7];
	end
    end

    always @(notifier or notifier_a) begin
	doa_out[0] <= 1'bx;
	doa_out[1] <= 1'bx;
	doa_out[2] <= 1'bx;
	doa_out[3] <= 1'bx;
	doa_out[4] <= 1'bx;
	doa_out[5] <= 1'bx;
	doa_out[6] <= 1'bx;
	doa_out[7] <= 1'bx;
    end
 
    always @(notifier or notifier_b) begin
	dob_out[0] <= 1'bx;
	dob_out[1] <= 1'bx;
	dob_out[2] <= 1'bx;
	dob_out[3] <= 1'bx;
	dob_out[4] <= 1'bx;
	dob_out[5] <= 1'bx;
	dob_out[6] <= 1'bx;
	dob_out[7] <= 1'bx;
    end

    specify

	(CLKA => DOA[0]) = (0:0:0, 0:0:0);
  	(CLKA => DOA[1]) = (0:0:0, 0:0:0);
  	(CLKA => DOA[2]) = (0:0:0, 0:0:0);
  	(CLKA => DOA[3]) = (0:0:0, 0:0:0);
  	(CLKA => DOA[4]) = (0:0:0, 0:0:0);
  	(CLKA => DOA[5]) = (0:0:0, 0:0:0);
  	(CLKA => DOA[6]) = (0:0:0, 0:0:0);
  	(CLKA => DOA[7]) = (0:0:0, 0:0:0);

  	$width (posedge CLKA &&& ENA, 0:0:0, 0, notifier_a);
  	$width (negedge CLKA &&& ENA, 0:0:0, 0, notifier_a);

  	(CLKB => DOB[0]) = (0:0:0, 0:0:0);
  	(CLKB => DOB[1]) = (0:0:0, 0:0:0);
  	(CLKB => DOB[2]) = (0:0:0, 0:0:0);
  	(CLKB => DOB[3]) = (0:0:0, 0:0:0);
  	(CLKB => DOB[4]) = (0:0:0, 0:0:0);
  	(CLKB => DOB[5]) = (0:0:0, 0:0:0);
  	(CLKB => DOB[6]) = (0:0:0, 0:0:0);
  	(CLKB => DOB[7]) = (0:0:0, 0:0:0);

  	$width (posedge CLKB &&& ENB, 0:0:0, 0, notifier_b);
  	$width (negedge CLKB &&& ENB, 0:0:0, 0, notifier_b);

  	(GSR => DOA[0]) = (0:0:0, 0:0:0);
  	(GSR => DOA[1]) = (0:0:0, 0:0:0);
  	(GSR => DOA[2]) = (0:0:0, 0:0:0);
  	(GSR => DOA[3]) = (0:0:0, 0:0:0);
  	(GSR => DOA[4]) = (0:0:0, 0:0:0);
  	(GSR => DOA[5]) = (0:0:0, 0:0:0);
  	(GSR => DOA[6]) = (0:0:0, 0:0:0);
  	(GSR => DOA[7]) = (0:0:0, 0:0:0);
  	(GSR => DOB[0]) = (0:0:0, 0:0:0);
  	(GSR => DOB[1]) = (0:0:0, 0:0:0);
  	(GSR => DOB[2]) = (0:0:0, 0:0:0);
  	(GSR => DOB[3]) = (0:0:0, 0:0:0);
  	(GSR => DOB[4]) = (0:0:0, 0:0:0);
  	(GSR => DOB[5]) = (0:0:0, 0:0:0);
  	(GSR => DOB[6]) = (0:0:0, 0:0:0);
  	(GSR => DOB[7]) = (0:0:0, 0:0:0);

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
       	$setuphold (posedge CLKA, posedge DIA[0] &&& dia_enable, 0:0:0, 0:0:0, notifier_a);
       	$setuphold (posedge CLKA, negedge DIA[0] &&& dia_enable, 0:0:0, 0:0:0, notifier_a);
       	$setuphold (posedge CLKA, posedge DIA[1] &&& dia_enable, 0:0:0, 0:0:0, notifier_a);
       	$setuphold (posedge CLKA, negedge DIA[1] &&& dia_enable, 0:0:0, 0:0:0, notifier_a);
       	$setuphold (posedge CLKA, posedge DIA[2] &&& dia_enable, 0:0:0, 0:0:0, notifier_a);
       	$setuphold (posedge CLKA, negedge DIA[2] &&& dia_enable, 0:0:0, 0:0:0, notifier_a);
       	$setuphold (posedge CLKA, posedge DIA[3] &&& dia_enable, 0:0:0, 0:0:0, notifier_a);
       	$setuphold (posedge CLKA, negedge DIA[3] &&& dia_enable, 0:0:0, 0:0:0, notifier_a);
       	$setuphold (posedge CLKA, posedge DIA[4] &&& dia_enable, 0:0:0, 0:0:0, notifier_a);
       	$setuphold (posedge CLKA, negedge DIA[4] &&& dia_enable, 0:0:0, 0:0:0, notifier_a);
       	$setuphold (posedge CLKA, posedge DIA[5] &&& dia_enable, 0:0:0, 0:0:0, notifier_a);
       	$setuphold (posedge CLKA, negedge DIA[5] &&& dia_enable, 0:0:0, 0:0:0, notifier_a);
       	$setuphold (posedge CLKA, posedge DIA[6] &&& dia_enable, 0:0:0, 0:0:0, notifier_a);
       	$setuphold (posedge CLKA, negedge DIA[6] &&& dia_enable, 0:0:0, 0:0:0, notifier_a);
       	$setuphold (posedge CLKA, posedge DIA[7] &&& dia_enable, 0:0:0, 0:0:0, notifier_a);
       	$setuphold (posedge CLKA, negedge DIA[7] &&& dia_enable, 0:0:0, 0:0:0, notifier_a);
       	$setuphold (posedge CLKA, posedge ENA, 0:0:0, 0:0:0, notifier_a);
       	$setuphold (posedge CLKA, negedge ENA, 0:0:0, 0:0:0, notifier_a);
       	$setuphold (posedge CLKA, posedge RSTA &&& ENA, 0:0:0, 0:0:0, notifier);
       	$setuphold (posedge CLKA, negedge RSTA &&& ENA, 0:0:0, 0:0:0, notifier);
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
       	$setuphold (posedge CLKB, posedge DIB[0] &&& dib_enable, 0:0:0, 0:0:0, notifier_b);
       	$setuphold (posedge CLKB, negedge DIB[0] &&& dib_enable, 0:0:0, 0:0:0, notifier_b);
       	$setuphold (posedge CLKB, posedge DIB[1] &&& dib_enable, 0:0:0, 0:0:0, notifier_b);
       	$setuphold (posedge CLKB, negedge DIB[1] &&& dib_enable, 0:0:0, 0:0:0, notifier_b);
       	$setuphold (posedge CLKB, posedge DIB[2] &&& dib_enable, 0:0:0, 0:0:0, notifier_b);
       	$setuphold (posedge CLKB, negedge DIB[2] &&& dib_enable, 0:0:0, 0:0:0, notifier_b);
       	$setuphold (posedge CLKB, posedge DIB[3] &&& dib_enable, 0:0:0, 0:0:0, notifier_b);
       	$setuphold (posedge CLKB, negedge DIB[3] &&& dib_enable, 0:0:0, 0:0:0, notifier_b);
       	$setuphold (posedge CLKB, posedge DIB[4] &&& dib_enable, 0:0:0, 0:0:0, notifier_b);
       	$setuphold (posedge CLKB, negedge DIB[4] &&& dib_enable, 0:0:0, 0:0:0, notifier_b);
       	$setuphold (posedge CLKB, posedge DIB[5] &&& dib_enable, 0:0:0, 0:0:0, notifier_b);
       	$setuphold (posedge CLKB, negedge DIB[5] &&& dib_enable, 0:0:0, 0:0:0, notifier_b);
       	$setuphold (posedge CLKB, posedge DIB[6] &&& dib_enable, 0:0:0, 0:0:0, notifier_b);
       	$setuphold (posedge CLKB, negedge DIB[6] &&& dib_enable, 0:0:0, 0:0:0, notifier_b);
       	$setuphold (posedge CLKB, posedge DIB[7] &&& dib_enable, 0:0:0, 0:0:0, notifier_b);
       	$setuphold (posedge CLKB, negedge DIB[7] &&& dib_enable, 0:0:0, 0:0:0, notifier_b);
       	$setuphold (posedge CLKB, posedge ENB, 0:0:0, 0:0:0, notifier_b);
       	$setuphold (posedge CLKB, negedge ENB, 0:0:0, 0:0:0, notifier_b);
       	$setuphold (posedge CLKB, posedge RSTB &&& ENB, 0:0:0, 0:0:0, notifier);
       	$setuphold (posedge CLKB, negedge RSTB &&& ENB, 0:0:0, 0:0:0, notifier);
       	$setuphold (posedge CLKB, posedge WEB &&& ENB, 0:0:0, 0:0:0, notifier_b);
       	$setuphold (posedge CLKB, negedge WEB &&& ENB, 0:0:0, 0:0:0, notifier_b);
       	$recrem (negedge GSR, posedge CLKB, 0:0:0, 0:0:0, notifier_b);

  	$width (posedge GSR, 0:0:0, 0, notifier);

	specparam PATHPULSE$ = 0;

    endspecify

endmodule
