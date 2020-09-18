//    Xilinx Proprietary Primitive Cell X_MULT18X18S for Verilog
//
// $Header: /devl/xcs/repo/env/Databases/CAEInterfaces/versclibs/data/X_MULT18X18S.v,v 1.5 2003/01/21 02:38:36 wloo Exp $
//

`timescale 1 ps/1 ps

module X_MULT18X18S (P, A, B, C, CE, GSR, R);

    output [35:0] P;

    input  [17:0] A;
    input  [17:0] B;
    input  C;
    input  CE;
    input  GSR;
    input  R;

    wire [35:0] a_in, b_in;
    wire c_in, ce_in, gsr_in, r_in;
    wire [35:0] p_in;
    reg [35:0] p_out;

    wire p0_out, p1_out, p2_out, p3_out, p4_out, p5_out, p6_out, p7_out, p8_out, p9_out, p10_out, p11_out, p12_out, p13_out, p14_out, p15_out, p16_out, p17_out, p18_out, p19_out, p20_out, p21_out, p22_out, p23_out, p24_out, p25_out, p26_out, p27_out, p28_out, p29_out, p30_out, p31_out, p32_out, p33_out, p34_out, p35_out;

    wire ce_enable, d_enable, not_r;
    reg  notifier;

    not (ce_enable, R);
    not (not_r, R);
    and (d_enable, CE, not_r);

    buf A0 (a_in[0], A[0]);
    buf A1 (a_in[1], A[1]);
    buf A2 (a_in[2], A[2]);
    buf A3 (a_in[3], A[3]);
    buf A4 (a_in[4], A[4]);
    buf A5 (a_in[5], A[5]);
    buf A6 (a_in[6], A[6]);
    buf A7 (a_in[7], A[7]);
    buf A8 (a_in[8], A[8]);
    buf A9 (a_in[9], A[9]);
    buf A10 (a_in[10], A[10]);
    buf A11 (a_in[11], A[11]);
    buf A12 (a_in[12], A[12]);
    buf A13 (a_in[13], A[13]);
    buf A14 (a_in[14], A[14]);
    buf A15 (a_in[15], A[15]);
    buf A16 (a_in[16], A[16]);
    buf A17 (a_in[17], A[17]);
    buf A18 (a_in[18], A[17]);
    buf A19 (a_in[19], A[17]);
    buf A20 (a_in[20], A[17]);
    buf A21 (a_in[21], A[17]);
    buf A22 (a_in[22], A[17]);
    buf A23 (a_in[23], A[17]);
    buf A24 (a_in[24], A[17]);
    buf A25 (a_in[25], A[17]);
    buf A26 (a_in[26], A[17]);
    buf A27 (a_in[27], A[17]);
    buf A28 (a_in[28], A[17]);
    buf A29 (a_in[29], A[17]);
    buf A30 (a_in[30], A[17]);
    buf A31 (a_in[31], A[17]);
    buf A32 (a_in[32], A[17]);
    buf A33 (a_in[33], A[17]);
    buf A34 (a_in[34], A[17]);
    buf A35 (a_in[35], A[17]);
    buf B0 (b_in[0], B[0]);
    buf B1 (b_in[1], B[1]);
    buf B2 (b_in[2], B[2]);
    buf B3 (b_in[3], B[3]);
    buf B4 (b_in[4], B[4]);
    buf B5 (b_in[5], B[5]);
    buf B6 (b_in[6], B[6]);
    buf B7 (b_in[7], B[7]);
    buf B8 (b_in[8], B[8]);
    buf B9 (b_in[9], B[9]);
    buf B10 (b_in[10], B[10]);
    buf B11 (b_in[11], B[11]);
    buf B12 (b_in[12], B[12]);
    buf B13 (b_in[13], B[13]);
    buf B14 (b_in[14], B[14]);
    buf B15 (b_in[15], B[15]);
    buf B16 (b_in[16], B[16]);
    buf B17 (b_in[17], B[17]);
    buf B18 (b_in[18], B[17]);
    buf B19 (b_in[19], B[17]);
    buf B20 (b_in[20], B[17]);
    buf B21 (b_in[21], B[17]);
    buf B22 (b_in[22], B[17]);
    buf B23 (b_in[23], B[17]);
    buf B24 (b_in[24], B[17]);
    buf B25 (b_in[25], B[17]);
    buf B26 (b_in[26], B[17]);
    buf B27 (b_in[27], B[17]);
    buf B28 (b_in[28], B[17]);
    buf B29 (b_in[29], B[17]);
    buf B30 (b_in[30], B[17]);
    buf B31 (b_in[31], B[17]);
    buf B32 (b_in[32], B[17]);
    buf B33 (b_in[33], B[17]);
    buf B34 (b_in[34], B[17]);
    buf B35 (b_in[35], B[17]);

    buf C0 (c_in, C);
    buf CE0 (ce_in, CE);
    buf GSR0 (gsr_in, GSR);
    buf R0 (r_in, R);

    buf P0 (P[0], p0_out);
    buf P1 (P[1], p1_out);
    buf P2 (P[2], p2_out);
    buf P3 (P[3], p3_out);
    buf P4 (P[4], p4_out);
    buf P5 (P[5], p5_out);
    buf P6 (P[6], p6_out);
    buf P7 (P[7], p7_out);
    buf P8 (P[8], p8_out);
    buf P9 (P[9], p9_out);
    buf P10 (P[10], p10_out);
    buf P11 (P[11], p11_out);
    buf P12 (P[12], p12_out);
    buf P13 (P[13], p13_out);
    buf P14 (P[14], p14_out);
    buf P15 (P[15], p15_out);
    buf P16 (P[16], p16_out);
    buf P17 (P[17], p17_out);
    buf P18 (P[18], p18_out);
    buf P19 (P[19], p19_out);
    buf P20 (P[20], p20_out);
    buf P21 (P[21], p21_out);
    buf P22 (P[22], p22_out);
    buf P23 (P[23], p23_out);
    buf P24 (P[24], p24_out);
    buf P25 (P[25], p25_out);
    buf P26 (P[26], p26_out);
    buf P27 (P[27], p27_out);
    buf P28 (P[28], p28_out);
    buf P29 (P[29], p29_out);
    buf P30 (P[30], p30_out);
    buf P31 (P[31], p31_out);
    buf P32 (P[32], p32_out);
    buf P33 (P[33], p33_out);
    buf P34 (P[34], p34_out);
    buf P35 (P[35], p35_out);

    assign p_in = a_in * b_in;
    assign {p35_out, p34_out, p33_out, p32_out, p31_out, p30_out, p29_out, p28_out, p27_out, p26_out, p25_out, p24_out, p23_out, p22_out, p21_out, p20_out, p19_out, p18_out, p17_out, p16_out, p15_out, p14_out, p13_out, p12_out, p11_out, p10_out, p9_out, p8_out, p7_out, p6_out, p5_out, p4_out, p3_out, p2_out, p1_out, p0_out} = p_out;

        always @(gsr_in)
            if (gsr_in)
                assign p_out = 36'b0;
            else
                deassign p_out;

        always @(posedge c_in)
            if (R)
                p_out <= 36'b0;
            else if (ce_in)
                p_out <= p_in;

	always @(notifier) begin
		p_out <= 36'bx;
	end

    specify

	(C => P[0]) = (0:0:0, 0:0:0);
	(C => P[1]) = (0:0:0, 0:0:0);
	(C => P[2]) = (0:0:0, 0:0:0);
	(C => P[3]) = (0:0:0, 0:0:0);
	(C => P[4]) = (0:0:0, 0:0:0);
	(C => P[5]) = (0:0:0, 0:0:0);
	(C => P[6]) = (0:0:0, 0:0:0);
	(C => P[7]) = (0:0:0, 0:0:0);
	(C => P[8]) = (0:0:0, 0:0:0);
	(C => P[9]) = (0:0:0, 0:0:0);
	(C => P[10]) = (0:0:0, 0:0:0);
	(C => P[11]) = (0:0:0, 0:0:0);
	(C => P[12]) = (0:0:0, 0:0:0);
	(C => P[13]) = (0:0:0, 0:0:0);
	(C => P[14]) = (0:0:0, 0:0:0);
	(C => P[15]) = (0:0:0, 0:0:0);
	(C => P[16]) = (0:0:0, 0:0:0);
	(C => P[17]) = (0:0:0, 0:0:0);
	(C => P[18]) = (0:0:0, 0:0:0);
	(C => P[19]) = (0:0:0, 0:0:0);
	(C => P[20]) = (0:0:0, 0:0:0);
	(C => P[21]) = (0:0:0, 0:0:0);
	(C => P[22]) = (0:0:0, 0:0:0);
	(C => P[23]) = (0:0:0, 0:0:0);
	(C => P[24]) = (0:0:0, 0:0:0);
	(C => P[25]) = (0:0:0, 0:0:0);
	(C => P[26]) = (0:0:0, 0:0:0);
	(C => P[27]) = (0:0:0, 0:0:0);
	(C => P[28]) = (0:0:0, 0:0:0);
	(C => P[29]) = (0:0:0, 0:0:0);
	(C => P[30]) = (0:0:0, 0:0:0);
	(C => P[31]) = (0:0:0, 0:0:0);
	(C => P[32]) = (0:0:0, 0:0:0);
	(C => P[33]) = (0:0:0, 0:0:0);
	(C => P[34]) = (0:0:0, 0:0:0);
	(C => P[35]) = (0:0:0, 0:0:0);

	(GSR => P[0]) = (0:0:0, 0:0:0);
	(GSR => P[1]) = (0:0:0, 0:0:0);
	(GSR => P[2]) = (0:0:0, 0:0:0);
	(GSR => P[3]) = (0:0:0, 0:0:0);
	(GSR => P[4]) = (0:0:0, 0:0:0);
	(GSR => P[5]) = (0:0:0, 0:0:0);
	(GSR => P[6]) = (0:0:0, 0:0:0);
	(GSR => P[7]) = (0:0:0, 0:0:0);
	(GSR => P[8]) = (0:0:0, 0:0:0);
	(GSR => P[9]) = (0:0:0, 0:0:0);
	(GSR => P[10]) = (0:0:0, 0:0:0);
	(GSR => P[11]) = (0:0:0, 0:0:0);
	(GSR => P[12]) = (0:0:0, 0:0:0);
	(GSR => P[13]) = (0:0:0, 0:0:0);
	(GSR => P[14]) = (0:0:0, 0:0:0);
	(GSR => P[15]) = (0:0:0, 0:0:0);
	(GSR => P[16]) = (0:0:0, 0:0:0);
	(GSR => P[17]) = (0:0:0, 0:0:0);
	(GSR => P[18]) = (0:0:0, 0:0:0);
	(GSR => P[19]) = (0:0:0, 0:0:0);
	(GSR => P[20]) = (0:0:0, 0:0:0);
	(GSR => P[21]) = (0:0:0, 0:0:0);
	(GSR => P[22]) = (0:0:0, 0:0:0);
	(GSR => P[23]) = (0:0:0, 0:0:0);
	(GSR => P[24]) = (0:0:0, 0:0:0);
	(GSR => P[25]) = (0:0:0, 0:0:0);
	(GSR => P[26]) = (0:0:0, 0:0:0);
	(GSR => P[27]) = (0:0:0, 0:0:0);
	(GSR => P[28]) = (0:0:0, 0:0:0);
	(GSR => P[29]) = (0:0:0, 0:0:0);
	(GSR => P[30]) = (0:0:0, 0:0:0);
	(GSR => P[31]) = (0:0:0, 0:0:0);
	(GSR => P[32]) = (0:0:0, 0:0:0);
	(GSR => P[33]) = (0:0:0, 0:0:0);
	(GSR => P[34]) = (0:0:0, 0:0:0);
	(GSR => P[35]) = (0:0:0, 0:0:0);

	$setuphold (posedge C, posedge A[0] &&& d_enable, 0:0:0, 0:0:0, notifier);
	$setuphold (posedge C, negedge A[0] &&& d_enable, 0:0:0, 0:0:0, notifier);
	$setuphold (posedge C, posedge A[1] &&& d_enable, 0:0:0, 0:0:0, notifier);
	$setuphold (posedge C, negedge A[1] &&& d_enable, 0:0:0, 0:0:0, notifier);
	$setuphold (posedge C, posedge A[2] &&& d_enable, 0:0:0, 0:0:0, notifier);
	$setuphold (posedge C, negedge A[2] &&& d_enable, 0:0:0, 0:0:0, notifier);
	$setuphold (posedge C, posedge A[3] &&& d_enable, 0:0:0, 0:0:0, notifier);
	$setuphold (posedge C, negedge A[3] &&& d_enable, 0:0:0, 0:0:0, notifier);
	$setuphold (posedge C, posedge A[4] &&& d_enable, 0:0:0, 0:0:0, notifier);
	$setuphold (posedge C, negedge A[4] &&& d_enable, 0:0:0, 0:0:0, notifier);
	$setuphold (posedge C, posedge A[5] &&& d_enable, 0:0:0, 0:0:0, notifier);
	$setuphold (posedge C, negedge A[5] &&& d_enable, 0:0:0, 0:0:0, notifier);
	$setuphold (posedge C, posedge A[6] &&& d_enable, 0:0:0, 0:0:0, notifier);
	$setuphold (posedge C, negedge A[6] &&& d_enable, 0:0:0, 0:0:0, notifier);
	$setuphold (posedge C, posedge A[7] &&& d_enable, 0:0:0, 0:0:0, notifier);
	$setuphold (posedge C, negedge A[7] &&& d_enable, 0:0:0, 0:0:0, notifier);
	$setuphold (posedge C, posedge A[8] &&& d_enable, 0:0:0, 0:0:0, notifier);
	$setuphold (posedge C, negedge A[8] &&& d_enable, 0:0:0, 0:0:0, notifier);
	$setuphold (posedge C, posedge A[9] &&& d_enable, 0:0:0, 0:0:0, notifier);
	$setuphold (posedge C, negedge A[9] &&& d_enable, 0:0:0, 0:0:0, notifier);
	$setuphold (posedge C, posedge A[10] &&& d_enable, 0:0:0, 0:0:0, notifier);
	$setuphold (posedge C, negedge A[10] &&& d_enable, 0:0:0, 0:0:0, notifier);
	$setuphold (posedge C, posedge A[11] &&& d_enable, 0:0:0, 0:0:0, notifier);
	$setuphold (posedge C, negedge A[11] &&& d_enable, 0:0:0, 0:0:0, notifier);
	$setuphold (posedge C, posedge A[12] &&& d_enable, 0:0:0, 0:0:0, notifier);
	$setuphold (posedge C, negedge A[12] &&& d_enable, 0:0:0, 0:0:0, notifier);
	$setuphold (posedge C, posedge A[13] &&& d_enable, 0:0:0, 0:0:0, notifier);
	$setuphold (posedge C, negedge A[13] &&& d_enable, 0:0:0, 0:0:0, notifier);
	$setuphold (posedge C, posedge A[14] &&& d_enable, 0:0:0, 0:0:0, notifier);
	$setuphold (posedge C, negedge A[14] &&& d_enable, 0:0:0, 0:0:0, notifier);
	$setuphold (posedge C, posedge A[15] &&& d_enable, 0:0:0, 0:0:0, notifier);
	$setuphold (posedge C, negedge A[15] &&& d_enable, 0:0:0, 0:0:0, notifier);
	$setuphold (posedge C, posedge A[16] &&& d_enable, 0:0:0, 0:0:0, notifier);
	$setuphold (posedge C, negedge A[16] &&& d_enable, 0:0:0, 0:0:0, notifier);
	$setuphold (posedge C, posedge A[17] &&& d_enable, 0:0:0, 0:0:0, notifier);
	$setuphold (posedge C, negedge A[17] &&& d_enable, 0:0:0, 0:0:0, notifier);
	$setuphold (posedge C, posedge B[0] &&& d_enable, 0:0:0, 0:0:0, notifier);
	$setuphold (posedge C, negedge B[0] &&& d_enable, 0:0:0, 0:0:0, notifier);
	$setuphold (posedge C, posedge B[1] &&& d_enable, 0:0:0, 0:0:0, notifier);
	$setuphold (posedge C, negedge B[1] &&& d_enable, 0:0:0, 0:0:0, notifier);
	$setuphold (posedge C, posedge B[2] &&& d_enable, 0:0:0, 0:0:0, notifier);
	$setuphold (posedge C, negedge B[2] &&& d_enable, 0:0:0, 0:0:0, notifier);
	$setuphold (posedge C, posedge B[3] &&& d_enable, 0:0:0, 0:0:0, notifier);
	$setuphold (posedge C, negedge B[3] &&& d_enable, 0:0:0, 0:0:0, notifier);
	$setuphold (posedge C, posedge B[4] &&& d_enable, 0:0:0, 0:0:0, notifier);
	$setuphold (posedge C, negedge B[4] &&& d_enable, 0:0:0, 0:0:0, notifier);
	$setuphold (posedge C, posedge B[5] &&& d_enable, 0:0:0, 0:0:0, notifier);
	$setuphold (posedge C, negedge B[5] &&& d_enable, 0:0:0, 0:0:0, notifier);
	$setuphold (posedge C, posedge B[6] &&& d_enable, 0:0:0, 0:0:0, notifier);
	$setuphold (posedge C, negedge B[6] &&& d_enable, 0:0:0, 0:0:0, notifier);
	$setuphold (posedge C, posedge B[7] &&& d_enable, 0:0:0, 0:0:0, notifier);
	$setuphold (posedge C, negedge B[7] &&& d_enable, 0:0:0, 0:0:0, notifier);
	$setuphold (posedge C, posedge B[8] &&& d_enable, 0:0:0, 0:0:0, notifier);
	$setuphold (posedge C, negedge B[8] &&& d_enable, 0:0:0, 0:0:0, notifier);
	$setuphold (posedge C, posedge B[9] &&& d_enable, 0:0:0, 0:0:0, notifier);
	$setuphold (posedge C, negedge B[9] &&& d_enable, 0:0:0, 0:0:0, notifier);
	$setuphold (posedge C, posedge B[10] &&& d_enable, 0:0:0, 0:0:0, notifier);
	$setuphold (posedge C, negedge B[10] &&& d_enable, 0:0:0, 0:0:0, notifier);
	$setuphold (posedge C, posedge B[11] &&& d_enable, 0:0:0, 0:0:0, notifier);
	$setuphold (posedge C, negedge B[11] &&& d_enable, 0:0:0, 0:0:0, notifier);
	$setuphold (posedge C, posedge B[12] &&& d_enable, 0:0:0, 0:0:0, notifier);
	$setuphold (posedge C, negedge B[12] &&& d_enable, 0:0:0, 0:0:0, notifier);
	$setuphold (posedge C, posedge B[13] &&& d_enable, 0:0:0, 0:0:0, notifier);
	$setuphold (posedge C, negedge B[13] &&& d_enable, 0:0:0, 0:0:0, notifier);
	$setuphold (posedge C, posedge B[14] &&& d_enable, 0:0:0, 0:0:0, notifier);
	$setuphold (posedge C, negedge B[14] &&& d_enable, 0:0:0, 0:0:0, notifier);
	$setuphold (posedge C, posedge B[15] &&& d_enable, 0:0:0, 0:0:0, notifier);
	$setuphold (posedge C, negedge B[15] &&& d_enable, 0:0:0, 0:0:0, notifier);
	$setuphold (posedge C, posedge B[16] &&& d_enable, 0:0:0, 0:0:0, notifier);
	$setuphold (posedge C, negedge B[16] &&& d_enable, 0:0:0, 0:0:0, notifier);
	$setuphold (posedge C, posedge B[17] &&& d_enable, 0:0:0, 0:0:0, notifier);
	$setuphold (posedge C, negedge B[17] &&& d_enable, 0:0:0, 0:0:0, notifier);
	$setuphold (posedge C, posedge CE &&& ce_enable, 0:0:0, 0:0:0, notifier);
	$setuphold (posedge C, negedge CE &&& ce_enable, 0:0:0, 0:0:0, notifier);
	$setuphold (posedge C, posedge R, 0:0:0, 0:0:0, notifier);
	$setuphold (posedge C, negedge R, 0:0:0, 0:0:0, notifier);

	$recrem (negedge GSR, posedge C, 0:0:0, 0:0:0, notifier);

	$width (posedge C, 0:0:0, 0, notifier);
	$width (negedge C, 0:0:0, 0, notifier);
	$width (posedge GSR, 0:0:0, 0, notifier);

	specparam PATHPULSE$ = 0;

  endspecify

endmodule
