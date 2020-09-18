// Copyright(C) 2002 by Xilinx, Inc. All rights reserved.
// This text contains proprietary, confidential
// information of Xilinx, Inc., is distributed
// under license from Xilinx, Inc., and may be used,
// copied and/or disclosed only pursuant to the terms
// of a valid license agreement with Xilinx, Inc. This copyright
// notice must be retained as part of this text at all times.

/*
--$RCSfile: XFFT1024_V1_1.v,v $ $Revision: 1.2 $ $Date: 2003/03/04 15:15:08 $
*/
//////////////////////////////////////////////////////////////////////////////
//
// XFFT1024_V1_1 / TOP LEVEL Verilog Behavioral Model
//
///////////////////////////////////////////////////////////////////////////////
//
// Description: 
// This is the top level behavioral description for the xFFT_1024_v1_1 core
//	
///////////////////////////////////////////////////////////////////////////////

`define PE0_PIPE_LATENCY 15
`define PE1_PIPE_LATENCY 9
`define Bi 	 			 16	// Input width
`define Btw	 			 18	// Width of twiddle factors 

`timescale 1 ns / 100ps

module XFFT1024_V1_1 ( XN_INDEX, XN_RE, XN_IM, RESET, START, MRD, N_FFT,  N_FFT_WE, 
				 FWD_INV, FWD_INV_WE, SCALE_SCH, SCALE_SCH_WE,CLK, CE, 	 
				 XK_RE, XK_IM, XK_INDEX, RDY, BUSY, EDONE, DONE, OVFLO);
	
input [`Bi-1:0] XN_RE;
input [`Bi-1:0] XN_IM;
input RESET;
input START;
input MRD;
input [1:0] N_FFT;
input N_FFT_WE;
input FWD_INV;
input FWD_INV_WE;
input [9:0] SCALE_SCH;
input SCALE_SCH_WE;
input CLK;
input CE;

output [`Bi-1:0] XK_RE; 	reg [`Bi-1:0] XK_RE;
output [`Bi-1:0] XK_IM; 	reg [`Bi-1:0] XK_IM;
output [9:0] XN_INDEX; 	reg [9:0] XN_INDEX;
output [9:0] XK_INDEX; 	reg [9:0] XK_INDEX;
output BUSY;  			reg BUSY;
output EDONE;			reg EDONE;
output DONE;			reg DONE;
output OVFLO;			reg OVFLO;
output RDY;				reg RDY;

/////////////////////////////// VARIABLE DECLARATION PART /////////////////////////////// 

reg [`Btw-1:0] tw_re[1023:0];   		// twiddle memories. These will hold the real
reg [`Btw-1:0] tw_im[1023:0];   		// and the imaginary part of twiddle factors ;
reg [`Bi-1:0]  dpm_in_re[2047:0],  dpm_in_im[2047:0];	// these are the real and imaginary parts of the
reg [`Bi-1:0] dpm_PE0_re[2047:0], dpm_PE0_im[2047:0];	// combined input, 
reg [`Bi-1:0] dpm_PE1_re[1023:0], dpm_PE1_im[1023:0];	// ping-pong, and 
reg [`Bi-1:0] dpm_out_re[2047:0], dpm_out_im[2047:0];	// output buffers
reg [11:0] scale_sch, scale_sch0 , scale_sch1, scale_sch2 ;			// registers keeping the scaling schedule
reg iBS, PE0_BS, PE0_BSd, PE1_BS, oBS; 					// I/O Bank select registers for PE0 and PE1
reg ready, fwd_inv0, fwd_inv1, fwd_inv2;
reg DONE_i, EDONE_i, started0_d;

// Data inputs and outputs of PE0
reg  [2*`Bi-1:0] data_i0_PE0, data_i1_PE0, data_i2_PE0, data_i3_PE0;
wire [2*`Bi-1:0] data_o0_PE0, data_o1_PE0, data_o2_PE0, data_o3_PE0;
integer address_mask;

// Data inputs and outputs of PE1
reg  [2*`Bi-1:0] data_i0_PE1, data_i1_PE1, data_i2_PE1, data_i3_PE1;
wire [2*`Bi-1:0] data_o0_PE1, data_o1_PE1, data_o2_PE1, data_o3_PE1;
wire [`Bi-1:0] data_o0_PE1_inv, data_o1_PE1_inv, data_o2_PE1_inv, data_o3_PE1_inv;
wire [`Bi-1:0] im_i_inv;

reg [9:0] PE0_rd_addr[3:0], PE0_wr_addr[3:0];		// input and output memory addresses for PE0
reg [9:0] PE1_rd_addr[3:0], PE1_wr_addr[3:0];		// input and output memory addresses for PE1
reg [9:0] rev_addr, out_addr;
reg [9:0] XK_INDEX1;
reg [1:0]  sc_sch0, sc_sch1; 						// actual scaling for PE0 and PE1
wire OVFLO0, OVFLO1;
reg OVFLOW_PE0, OVFLOW_PE0_d, OVFLOW_PE1;
reg [9:0] cnt0, cnt1, cnt_rev;
reg inverse, bank_sel, starts;
reg MRD_locked0, MRD_locked1, MRD_locked2, MRD_locked3;
reg [2:0] started;
integer N;						// actual FFT pointsize
integer RANKS;					// log4(N)
integer frame;	    			// number of frames processed since last power-up, RESET, or N_FFT_WE
reg [2:0] rank[47:0];			// actual rank being processed by PE0
reg [9:0] n[47:0] ; 			// actual clock cycle within the frame
reg [7:0] rn[47:0] ;			// actual clock cycle within the current rank
reg [9:0] tw1, tw2, tw3;		// twiddle addresses
integer i, d, k,tw, tw_step, tw_rank, RN;
integer in_frame, out_frame; 	// these temporary variables sample the frame pointer by the time MWR or MRD goes high
reg b;

/////////////////////////////// ARCHITECTURE BODY /////////////////////////////// 

inverter inv_i(fwd_inv0, XN_IM,  im_i_inv);

inverter inv_PE0_0(fwd_inv2, data_o0_PE1[`Bi-1:0],  data_o0_PE1_inv);
inverter inv_PE0_1(fwd_inv2, data_o1_PE1[`Bi-1:0],  data_o1_PE1_inv);
inverter inv_PE0_2(fwd_inv2, data_o2_PE1[`Bi-1:0],  data_o2_PE1_inv);
inverter inv_PE0_3(fwd_inv2, data_o3_PE1[`Bi-1:0],  data_o3_PE1_inv);

// Hook up PE0
PE0	pe0(	data_i0_PE0[2*`Bi-1:`Bi], data_i0_PE0[`Bi-1:0],		// connections of the 
		 	data_i1_PE0[2*`Bi-1:`Bi], data_i1_PE0[`Bi-1:0],		// 4 complex inputs 
			data_i2_PE0[2*`Bi-1:`Bi], data_i2_PE0[`Bi-1:0], 
			data_i3_PE0[2*`Bi-1:`Bi], data_i3_PE0[`Bi-1:0],						
			tw_re[tw1], tw_im[tw1], 							// connections of the 
			tw_re[tw2], tw_im[tw2], 							// twiddle factors
			tw_re[tw3], tw_im[tw3],
			sc_sch0,OVFLO0,
			data_o0_PE0[2*`Bi-1:`Bi], data_o0_PE0[`Bi-1:0],		// connections of the 
		 	data_o1_PE0[2*`Bi-1:`Bi], data_o1_PE0[`Bi-1:0],		// 4 complex outputs 
			data_o2_PE0[2*`Bi-1:`Bi], data_o2_PE0[`Bi-1:0], 
			data_o3_PE0[2*`Bi-1:`Bi], data_o3_PE0[`Bi-1:0]);
defparam pe0.Bdrfly = `Bi;	
defparam pe0.Btw	= `Btw;	
defparam pe0.Bo	 	= `Bi;	

// Hook up PE1
PE1	pe1(	data_i0_PE1[2*`Bi-1:`Bi], data_i0_PE1[`Bi-1:0],		// connections of the 
		 	data_i1_PE1[2*`Bi-1:`Bi], data_i1_PE1[`Bi-1:0],		// 4 complex inputs 
			data_i2_PE1[2*`Bi-1:`Bi], data_i2_PE1[`Bi-1:0], 
			data_i3_PE1[2*`Bi-1:`Bi], data_i3_PE1[`Bi-1:0],						
			sc_sch1,OVFLO1,
			data_o0_PE1[2*`Bi-1:`Bi], data_o0_PE1[`Bi-1:0],		// connections of the 
		 	data_o1_PE1[2*`Bi-1:`Bi], data_o1_PE1[`Bi-1:0],		// 4 complex outputs 
			data_o2_PE1[2*`Bi-1:`Bi], data_o2_PE1[`Bi-1:0], 
			data_o3_PE1[2*`Bi-1:`Bi], data_o3_PE1[`Bi-1:0]);
defparam pe1.Bdrfly = `Bi;	
defparam pe1.Bo	 = `Bi;	

task get_rev_addr; 	// digit-reversed counter
output [9 :0] addr;
reg[9:0] tmp;
begin
	tmp = XK_INDEX1;
	case (RANKS)
		default: addr = {  2'b0,	2'b0, 	  tmp[1:0], tmp[3:2], tmp[5:4] };
		4:		 addr = {  2'b0,	tmp[1:0], tmp[3:2], tmp[5:4], tmp[7:6] };
		5:		 addr = {tmp[1:0],	tmp[3:2], tmp[5:4], tmp[7:6], tmp[9:8] };
	endcase
end
endtask

task reset;		// this function is called when RESET is asserted or
begin			// the device is "powered-up"
	tw_re[0000] = 18'h1ffff; tw_im[0000] = 18'h00000; tw_re[0001] = 18'h1fffd; tw_im[0001] = 18'h3fcdc; tw_re[0002] = 18'h1fff6; tw_im[0002] = 18'h3f9b7; tw_re[0003] = 18'h1ffea; tw_im[0003] = 18'h3f693; 
	tw_re[0004] = 18'h1ffd8; tw_im[0004] = 18'h3f36f; tw_re[0005] = 18'h1ffc2; tw_im[0005] = 18'h3f04b; tw_re[0006] = 18'h1ffa7; tw_im[0006] = 18'h3ed27; tw_re[0007] = 18'h1ff87; tw_im[0007] = 18'h3ea04; 
	tw_re[0008] = 18'h1ff62; tw_im[0008] = 18'h3e6e0; tw_re[0009] = 18'h1ff38; tw_im[0009] = 18'h3e3bd; tw_re[0010] = 18'h1ff09; tw_im[0010] = 18'h3e09a; tw_re[0011] = 18'h1fed5; tw_im[0011] = 18'h3dd78; 
	tw_re[0012] = 18'h1fe9d; tw_im[0012] = 18'h3da55; tw_re[0013] = 18'h1fe5f; tw_im[0013] = 18'h3d734; tw_re[0014] = 18'h1fe1c; tw_im[0014] = 18'h3d412; tw_re[0015] = 18'h1fdd5; tw_im[0015] = 18'h3d0f1; 
	tw_re[0016] = 18'h1fd89; tw_im[0016] = 18'h3cdd0; tw_re[0017] = 18'h1fd37; tw_im[0017] = 18'h3cab0; tw_re[0018] = 18'h1fce1; tw_im[0018] = 18'h3c791; tw_re[0019] = 18'h1fc86; tw_im[0019] = 18'h3c472; 
	tw_re[0020] = 18'h1fc26; tw_im[0020] = 18'h3c153; tw_re[0021] = 18'h1fbc1; tw_im[0021] = 18'h3be35; tw_re[0022] = 18'h1fb57; tw_im[0022] = 18'h3bb18; tw_re[0023] = 18'h1fae9; tw_im[0023] = 18'h3b7fb; 
	tw_re[0024] = 18'h1fa75; tw_im[0024] = 18'h3b4df; tw_re[0025] = 18'h1f9fd; tw_im[0025] = 18'h3b1c4; tw_re[0026] = 18'h1f97f; tw_im[0026] = 18'h3aeaa; tw_re[0027] = 18'h1f8fd; tw_im[0027] = 18'h3ab90; 
	tw_re[0028] = 18'h1f876; tw_im[0028] = 18'h3a877; tw_re[0029] = 18'h1f7ea; tw_im[0029] = 18'h3a55f; tw_re[0030] = 18'h1f759; tw_im[0030] = 18'h3a248; tw_re[0031] = 18'h1f6c4; tw_im[0031] = 18'h39f32; 
	tw_re[0032] = 18'h1f629; tw_im[0032] = 18'h39c1d; tw_re[0033] = 18'h1f58a; tw_im[0033] = 18'h39909; tw_re[0034] = 18'h1f4e6; tw_im[0034] = 18'h395f5; tw_re[0035] = 18'h1f43d; tw_im[0035] = 18'h392e3; 
	tw_re[0036] = 18'h1f38f; tw_im[0036] = 18'h38fd2; tw_re[0037] = 18'h1f2dc; tw_im[0037] = 18'h38cc2; tw_re[0038] = 18'h1f225; tw_im[0038] = 18'h389b3; tw_re[0039] = 18'h1f169; tw_im[0039] = 18'h386a5; 
	tw_re[0040] = 18'h1f0a8; tw_im[0040] = 18'h38398; tw_re[0041] = 18'h1efe2; tw_im[0041] = 18'h3808c; tw_re[0042] = 18'h1ef17; tw_im[0042] = 18'h37d82; tw_re[0043] = 18'h1ee48; tw_im[0043] = 18'h37a79; 
	tw_re[0044] = 18'h1ed74; tw_im[0044] = 18'h37771; tw_re[0045] = 18'h1ec9b; tw_im[0045] = 18'h3746b; tw_re[0046] = 18'h1ebbd; tw_im[0046] = 18'h37166; tw_re[0047] = 18'h1eadb; tw_im[0047] = 18'h36e62; 
	tw_re[0048] = 18'h1e9f4; tw_im[0048] = 18'h36b60; tw_re[0049] = 18'h1e908; tw_im[0049] = 18'h3685f; tw_re[0050] = 18'h1e817; tw_im[0050] = 18'h3655f; tw_re[0051] = 18'h1e722; tw_im[0051] = 18'h36261; 
	tw_re[0052] = 18'h1e628; tw_im[0052] = 18'h35f65; tw_re[0053] = 18'h1e52a; tw_im[0053] = 18'h35c6a; tw_re[0054] = 18'h1e426; tw_im[0054] = 18'h35971; tw_re[0055] = 18'h1e31e; tw_im[0055] = 18'h35679; 
	tw_re[0056] = 18'h1e212; tw_im[0056] = 18'h35383; tw_re[0057] = 18'h1e101; tw_im[0057] = 18'h3508f; tw_re[0058] = 18'h1dfeb; tw_im[0058] = 18'h34d9c; tw_re[0059] = 18'h1ded0; tw_im[0059] = 18'h34aab; 
	tw_re[0060] = 18'h1ddb1; tw_im[0060] = 18'h347bc; tw_re[0061] = 18'h1dc8d; tw_im[0061] = 18'h344ce; tw_re[0062] = 18'h1db65; tw_im[0062] = 18'h341e2; tw_re[0063] = 18'h1da38; tw_im[0063] = 18'h33ef9; 
	tw_re[0064] = 18'h1d906; tw_im[0064] = 18'h33c11; tw_re[0065] = 18'h1d7d0; tw_im[0065] = 18'h3392b; tw_re[0066] = 18'h1d696; tw_im[0066] = 18'h33646; tw_re[0067] = 18'h1d557; tw_im[0067] = 18'h33364; 
	tw_re[0068] = 18'h1d413; tw_im[0068] = 18'h33084; tw_re[0069] = 18'h1d2cb; tw_im[0069] = 18'h32da6; tw_re[0070] = 18'h1d17e; tw_im[0070] = 18'h32ac9; tw_re[0071] = 18'h1d02d; tw_im[0071] = 18'h327ef; 
	tw_re[0072] = 18'h1ced7; tw_im[0072] = 18'h32517; tw_re[0073] = 18'h1cd7d; tw_im[0073] = 18'h32241; tw_re[0074] = 18'h1cc1f; tw_im[0074] = 18'h31f6d; tw_re[0075] = 18'h1cabc; tw_im[0075] = 18'h31c9c; 
	tw_re[0076] = 18'h1c954; tw_im[0076] = 18'h319cc; tw_re[0077] = 18'h1c7e9; tw_im[0077] = 18'h316ff; tw_re[0078] = 18'h1c678; tw_im[0078] = 18'h31434; tw_re[0079] = 18'h1c504; tw_im[0079] = 18'h3116b; 
	tw_re[0080] = 18'h1c38b; tw_im[0080] = 18'h30ea5; tw_re[0081] = 18'h1c20e; tw_im[0081] = 18'h30be1; tw_re[0082] = 18'h1c08c; tw_im[0082] = 18'h3091f; tw_re[0083] = 18'h1bf06; tw_im[0083] = 18'h30660; 
	tw_re[0084] = 18'h1bd7c; tw_im[0084] = 18'h303a3; tw_re[0085] = 18'h1bbed; tw_im[0085] = 18'h300e8; tw_re[0086] = 18'h1ba5a; tw_im[0086] = 18'h2fe30; tw_re[0087] = 18'h1b8c3; tw_im[0087] = 18'h2fb7a; 
	tw_re[0088] = 18'h1b728; tw_im[0088] = 18'h2f8c7; tw_re[0089] = 18'h1b588; tw_im[0089] = 18'h2f617; tw_re[0090] = 18'h1b3e5; tw_im[0090] = 18'h2f369; tw_re[0091] = 18'h1b23d; tw_im[0091] = 18'h2f0bd; 
	tw_re[0092] = 18'h1b090; tw_im[0092] = 18'h2ee15; tw_re[0093] = 18'h1aee0; tw_im[0093] = 18'h2eb6e; tw_re[0094] = 18'h1ad2c; tw_im[0094] = 18'h2e8cb; tw_re[0095] = 18'h1ab73; tw_im[0095] = 18'h2e62a; 
	tw_re[0096] = 18'h1a9b6; tw_im[0096] = 18'h2e38c; tw_re[0097] = 18'h1a7f5; tw_im[0097] = 18'h2e0f1; tw_re[0098] = 18'h1a630; tw_im[0098] = 18'h2de58; tw_re[0099] = 18'h1a467; tw_im[0099] = 18'h2dbc2; 
	tw_re[0100] = 18'h1a29a; tw_im[0100] = 18'h2d92f; tw_re[0101] = 18'h1a0c9; tw_im[0101] = 18'h2d69f; tw_re[0102] = 18'h19ef4; tw_im[0102] = 18'h2d412; tw_re[0103] = 18'h19d1b; tw_im[0103] = 18'h2d188; 
	tw_re[0104] = 18'h19b3e; tw_im[0104] = 18'h2cf00; tw_re[0105] = 18'h1995d; tw_im[0105] = 18'h2cc7c; tw_re[0106] = 18'h19778; tw_im[0106] = 18'h2c9fa; tw_re[0107] = 18'h1958f; tw_im[0107] = 18'h2c77c; 
	tw_re[0108] = 18'h193a2; tw_im[0108] = 18'h2c500; tw_re[0109] = 18'h191b1; tw_im[0109] = 18'h2c288; tw_re[0110] = 18'h18fbd; tw_im[0110] = 18'h2c012; tw_re[0111] = 18'h18dc4; tw_im[0111] = 18'h2bda0; 
	tw_re[0112] = 18'h18bc8; tw_im[0112] = 18'h2bb31; tw_re[0113] = 18'h189c8; tw_im[0113] = 18'h2b8c4; tw_re[0114] = 18'h187c4; tw_im[0114] = 18'h2b65b; tw_re[0115] = 18'h185bc; tw_im[0115] = 18'h2b3f6; 
	tw_re[0116] = 18'h183b1; tw_im[0116] = 18'h2b193; tw_re[0117] = 18'h181a1; tw_im[0117] = 18'h2af34; tw_re[0118] = 18'h17f8f; tw_im[0118] = 18'h2acd8; tw_re[0119] = 18'h17d78; tw_im[0119] = 18'h2aa7f; 
	tw_re[0120] = 18'h17b5e; tw_im[0120] = 18'h2a829; tw_re[0121] = 18'h17940; tw_im[0121] = 18'h2a5d7; tw_re[0122] = 18'h1771e; tw_im[0122] = 18'h2a388; tw_re[0123] = 18'h174f9; tw_im[0123] = 18'h2a13c; 
	tw_re[0124] = 18'h172d0; tw_im[0124] = 18'h29ef4; tw_re[0125] = 18'h170a4; tw_im[0125] = 18'h29cb0; tw_re[0126] = 18'h16e74; tw_im[0126] = 18'h29a6e; tw_re[0127] = 18'h16c41; tw_im[0127] = 18'h29830; 
	tw_re[0128] = 18'h16a0a; tw_im[0128] = 18'h295f6; tw_re[0129] = 18'h167cf; tw_im[0129] = 18'h293bf; tw_re[0130] = 18'h16591; tw_im[0130] = 18'h2918b; tw_re[0131] = 18'h16350; tw_im[0131] = 18'h28f5c; 
	tw_re[0132] = 18'h1610b; tw_im[0132] = 18'h28d2f; tw_re[0133] = 18'h15ec3; tw_im[0133] = 18'h28b06; tw_re[0134] = 18'h15c77; tw_im[0134] = 18'h288e1; tw_re[0135] = 18'h15a29; tw_im[0135] = 18'h286c0; 
	tw_re[0136] = 18'h157d6; tw_im[0136] = 18'h284a2; tw_re[0137] = 18'h15581; tw_im[0137] = 18'h28288; tw_re[0138] = 18'h15328; tw_im[0138] = 18'h28071; tw_re[0139] = 18'h150cc; tw_im[0139] = 18'h27e5e; 
	tw_re[0140] = 18'h14e6c; tw_im[0140] = 18'h27c4f; tw_re[0141] = 18'h14c0a; tw_im[0141] = 18'h27a43; tw_re[0142] = 18'h149a4; tw_im[0142] = 18'h2783c; tw_re[0143] = 18'h1473b; tw_im[0143] = 18'h27638; 
	tw_re[0144] = 18'h144cf; tw_im[0144] = 18'h27438; tw_re[0145] = 18'h14260; tw_im[0145] = 18'h2723b; tw_re[0146] = 18'h13fed; tw_im[0146] = 18'h27043; tw_re[0147] = 18'h13d78; tw_im[0147] = 18'h26e4e; 
	tw_re[0148] = 18'h13aff; tw_im[0148] = 18'h26c5e; tw_re[0149] = 18'h13884; tw_im[0149] = 18'h26a71; tw_re[0150] = 18'h13605; tw_im[0150] = 18'h26888; tw_re[0151] = 18'h13384; tw_im[0151] = 18'h266a3; 
	tw_re[0152] = 18'h130ff; tw_im[0152] = 18'h264c2; tw_re[0153] = 18'h12e78; tw_im[0153] = 18'h262e5; tw_re[0154] = 18'h12bed; tw_im[0154] = 18'h2610c; tw_re[0155] = 18'h12960; tw_im[0155] = 18'h25f36; 
	tw_re[0156] = 18'h126d0; tw_im[0156] = 18'h25d65; tw_re[0157] = 18'h1243d; tw_im[0157] = 18'h25b98; tw_re[0158] = 18'h121a7; tw_im[0158] = 18'h259cf; tw_re[0159] = 18'h11f0f; tw_im[0159] = 18'h2580a; 
	tw_re[0160] = 18'h11c73; tw_im[0160] = 18'h25649; tw_re[0161] = 18'h119d5; tw_im[0161] = 18'h2548d; tw_re[0162] = 18'h11735; tw_im[0162] = 18'h252d4; tw_re[0163] = 18'h11491; tw_im[0163] = 18'h2511f; 
	tw_re[0164] = 18'h111eb; tw_im[0164] = 18'h24f6f; tw_re[0165] = 18'h10f42; tw_im[0165] = 18'h24dc3; tw_re[0166] = 18'h10c97; tw_im[0166] = 18'h24c1b; tw_re[0167] = 18'h109e9; tw_im[0167] = 18'h24a77; 
	tw_re[0168] = 18'h10738; tw_im[0168] = 18'h248d8; tw_re[0169] = 18'h10485; tw_im[0169] = 18'h2473c; tw_re[0170] = 18'h101d0; tw_im[0170] = 18'h245a5; tw_re[0171] = 18'h0ff17; tw_im[0171] = 18'h24412; 
	tw_re[0172] = 18'h0fc5d; tw_im[0172] = 18'h24284; tw_re[0173] = 18'h0f9a0; tw_im[0173] = 18'h240f9; tw_re[0174] = 18'h0f6e1; tw_im[0174] = 18'h23f73; tw_re[0175] = 18'h0f41f; tw_im[0175] = 18'h23df2; 
	tw_re[0176] = 18'h0f15b; tw_im[0176] = 18'h23c75; tw_re[0177] = 18'h0ee94; tw_im[0177] = 18'h23afc; tw_re[0178] = 18'h0ebcb; tw_im[0178] = 18'h23987; tw_re[0179] = 18'h0e900; tw_im[0179] = 18'h23817; 
	tw_re[0180] = 18'h0e633; tw_im[0180] = 18'h236ab; tw_re[0181] = 18'h0e364; tw_im[0181] = 18'h23544; tw_re[0182] = 18'h0e092; tw_im[0182] = 18'h233e1; tw_re[0183] = 18'h0ddbe; tw_im[0183] = 18'h23282; 
	tw_re[0184] = 18'h0dae8; tw_im[0184] = 18'h23128; tw_re[0185] = 18'h0d810; tw_im[0185] = 18'h22fd2; tw_re[0186] = 18'h0d536; tw_im[0186] = 18'h22e81; tw_re[0187] = 18'h0d25a; tw_im[0187] = 18'h22d35; 
	tw_re[0188] = 18'h0cf7c; tw_im[0188] = 18'h22bec; tw_re[0189] = 18'h0cc9b; tw_im[0189] = 18'h22aa9; tw_re[0190] = 18'h0c9b9; tw_im[0190] = 18'h2296a; tw_re[0191] = 18'h0c6d5; tw_im[0191] = 18'h2282f; 
	tw_re[0192] = 18'h0c3ef; tw_im[0192] = 18'h226f9; tw_re[0193] = 18'h0c107; tw_im[0193] = 18'h225c8; tw_re[0194] = 18'h0be1d; tw_im[0194] = 18'h2249b; tw_re[0195] = 18'h0bb31; tw_im[0195] = 18'h22372; 
	tw_re[0196] = 18'h0b844; tw_im[0196] = 18'h2224f; tw_re[0197] = 18'h0b555; tw_im[0197] = 18'h2212f; tw_re[0198] = 18'h0b264; tw_im[0198] = 18'h22015; tw_re[0199] = 18'h0af71; tw_im[0199] = 18'h21eff; 
	tw_re[0200] = 18'h0ac7d; tw_im[0200] = 18'h21dee; tw_re[0201] = 18'h0a987; tw_im[0201] = 18'h21ce1; tw_re[0202] = 18'h0a68f; tw_im[0202] = 18'h21bd9; tw_re[0203] = 18'h0a396; tw_im[0203] = 18'h21ad6; 
	tw_re[0204] = 18'h0a09b; tw_im[0204] = 18'h219d7; tw_re[0205] = 18'h09d9e; tw_im[0205] = 18'h218dd; tw_re[0206] = 18'h09aa0; tw_im[0206] = 18'h217e8; tw_re[0207] = 18'h097a1; tw_im[0207] = 18'h216f7; 
	tw_re[0208] = 18'h094a0; tw_im[0208] = 18'h2160c; tw_re[0209] = 18'h0919e; tw_im[0209] = 18'h21525; tw_re[0210] = 18'h08e9a; tw_im[0210] = 18'h21442; tw_re[0211] = 18'h08b95; tw_im[0211] = 18'h21365; 
	tw_re[0212] = 18'h0888e; tw_im[0212] = 18'h2128c; tw_re[0213] = 18'h08587; tw_im[0213] = 18'h211b8; tw_re[0214] = 18'h0827e; tw_im[0214] = 18'h210e8; tw_re[0215] = 18'h07f73; tw_im[0215] = 18'h2101e; 
	tw_re[0216] = 18'h07c68; tw_im[0216] = 18'h20f58; tw_re[0217] = 18'h0795b; tw_im[0217] = 18'h20e97; tw_re[0218] = 18'h0764d; tw_im[0218] = 18'h20ddb; tw_re[0219] = 18'h0733e; tw_im[0219] = 18'h20d23; 
	tw_re[0220] = 18'h0702e; tw_im[0220] = 18'h20c71; tw_re[0221] = 18'h06d1d; tw_im[0221] = 18'h20bc3; tw_re[0222] = 18'h06a0a; tw_im[0222] = 18'h20b1a; tw_re[0223] = 18'h066f7; tw_im[0223] = 18'h20a76; 
	tw_re[0224] = 18'h063e3; tw_im[0224] = 18'h209d6; tw_re[0225] = 18'h060cd; tw_im[0225] = 18'h2093c; tw_re[0226] = 18'h05db7; tw_im[0226] = 18'h208a6; tw_re[0227] = 18'h05aa0; tw_im[0227] = 18'h20815; 
	tw_re[0228] = 18'h05788; tw_im[0228] = 18'h20789; tw_re[0229] = 18'h0546f; tw_im[0229] = 18'h20702; tw_re[0230] = 18'h05156; tw_im[0230] = 18'h20680; tw_re[0231] = 18'h04e3b; tw_im[0231] = 18'h20603; 
	tw_re[0232] = 18'h04b20; tw_im[0232] = 18'h2058a; tw_re[0233] = 18'h04804; tw_im[0233] = 18'h20517; tw_re[0234] = 18'h044e8; tw_im[0234] = 18'h204a8; tw_re[0235] = 18'h041ca; tw_im[0235] = 18'h2043e; 
	tw_re[0236] = 18'h03eac; tw_im[0236] = 18'h203d9; tw_re[0237] = 18'h03b8e; tw_im[0237] = 18'h20379; tw_re[0238] = 18'h0386f; tw_im[0238] = 18'h2031e; tw_re[0239] = 18'h0354f; tw_im[0239] = 18'h202c8; 
	tw_re[0240] = 18'h0322f; tw_im[0240] = 18'h20277; tw_re[0241] = 18'h02f0e; tw_im[0241] = 18'h2022b; tw_re[0242] = 18'h02bed; tw_im[0242] = 18'h201e3; tw_re[0243] = 18'h028cc; tw_im[0243] = 18'h201a1; 
	tw_re[0244] = 18'h025aa; tw_im[0244] = 18'h20163; tw_re[0245] = 18'h02288; tw_im[0245] = 18'h2012a; tw_re[0246] = 18'h01f65; tw_im[0246] = 18'h200f6; tw_re[0247] = 18'h01c42; tw_im[0247] = 18'h200c8; 
	tw_re[0248] = 18'h0191f; tw_im[0248] = 18'h2009e; tw_re[0249] = 18'h015fc; tw_im[0249] = 18'h20079; tw_re[0250] = 18'h012d8; tw_im[0250] = 18'h20059; tw_re[0251] = 18'h00fb4; tw_im[0251] = 18'h2003d; 
	tw_re[0252] = 18'h00c90; tw_im[0252] = 18'h20027; tw_re[0253] = 18'h0096c; tw_im[0253] = 18'h20016; tw_re[0254] = 18'h00648; tw_im[0254] = 18'h2000a; tw_re[0255] = 18'h00324; tw_im[0255] = 18'h20002; 
	tw_re[0256] = 18'h00000; tw_im[0256] = 18'h20001; tw_re[0257] = 18'h3fcdc; tw_im[0257] = 18'h20002; tw_re[0258] = 18'h3f9b7; tw_im[0258] = 18'h2000a; tw_re[0259] = 18'h3f693; tw_im[0259] = 18'h20016; 
	tw_re[0260] = 18'h3f36f; tw_im[0260] = 18'h20027; tw_re[0261] = 18'h3f04b; tw_im[0261] = 18'h2003d; tw_re[0262] = 18'h3ed27; tw_im[0262] = 18'h20059; tw_re[0263] = 18'h3ea04; tw_im[0263] = 18'h20079; 
	tw_re[0264] = 18'h3e6e0; tw_im[0264] = 18'h2009e; tw_re[0265] = 18'h3e3bd; tw_im[0265] = 18'h200c8; tw_re[0266] = 18'h3e09a; tw_im[0266] = 18'h200f6; tw_re[0267] = 18'h3dd78; tw_im[0267] = 18'h2012a; 
	tw_re[0268] = 18'h3da55; tw_im[0268] = 18'h20163; tw_re[0269] = 18'h3d734; tw_im[0269] = 18'h201a1; tw_re[0270] = 18'h3d412; tw_im[0270] = 18'h201e3; tw_re[0271] = 18'h3d0f1; tw_im[0271] = 18'h2022b; 
	tw_re[0272] = 18'h3cdd0; tw_im[0272] = 18'h20277; tw_re[0273] = 18'h3cab0; tw_im[0273] = 18'h202c8; tw_re[0274] = 18'h3c791; tw_im[0274] = 18'h2031e; tw_re[0275] = 18'h3c472; tw_im[0275] = 18'h20379; 
	tw_re[0276] = 18'h3c153; tw_im[0276] = 18'h203d9; tw_re[0277] = 18'h3be35; tw_im[0277] = 18'h2043e; tw_re[0278] = 18'h3bb18; tw_im[0278] = 18'h204a8; tw_re[0279] = 18'h3b7fb; tw_im[0279] = 18'h20517; 
	tw_re[0280] = 18'h3b4df; tw_im[0280] = 18'h2058a; tw_re[0281] = 18'h3b1c4; tw_im[0281] = 18'h20603; tw_re[0282] = 18'h3aeaa; tw_im[0282] = 18'h20680; tw_re[0283] = 18'h3ab90; tw_im[0283] = 18'h20702; 
	tw_re[0284] = 18'h3a877; tw_im[0284] = 18'h20789; tw_re[0285] = 18'h3a55f; tw_im[0285] = 18'h20815; tw_re[0286] = 18'h3a248; tw_im[0286] = 18'h208a6; tw_re[0287] = 18'h39f32; tw_im[0287] = 18'h2093c; 
	tw_re[0288] = 18'h39c1d; tw_im[0288] = 18'h209d6; tw_re[0289] = 18'h39909; tw_im[0289] = 18'h20a76; tw_re[0290] = 18'h395f5; tw_im[0290] = 18'h20b1a; tw_re[0291] = 18'h392e3; tw_im[0291] = 18'h20bc3; 
	tw_re[0292] = 18'h38fd2; tw_im[0292] = 18'h20c71; tw_re[0293] = 18'h38cc2; tw_im[0293] = 18'h20d23; tw_re[0294] = 18'h389b3; tw_im[0294] = 18'h20ddb; tw_re[0295] = 18'h386a5; tw_im[0295] = 18'h20e97; 
	tw_re[0296] = 18'h38398; tw_im[0296] = 18'h20f58; tw_re[0297] = 18'h3808c; tw_im[0297] = 18'h2101e; tw_re[0298] = 18'h37d82; tw_im[0298] = 18'h210e8; tw_re[0299] = 18'h37a79; tw_im[0299] = 18'h211b8; 
	tw_re[0300] = 18'h37771; tw_im[0300] = 18'h2128c; tw_re[0301] = 18'h3746b; tw_im[0301] = 18'h21365; tw_re[0302] = 18'h37166; tw_im[0302] = 18'h21442; tw_re[0303] = 18'h36e62; tw_im[0303] = 18'h21525; 
	tw_re[0304] = 18'h36b60; tw_im[0304] = 18'h2160c; tw_re[0305] = 18'h3685f; tw_im[0305] = 18'h216f7; tw_re[0306] = 18'h3655f; tw_im[0306] = 18'h217e8; tw_re[0307] = 18'h36261; tw_im[0307] = 18'h218dd; 
	tw_re[0308] = 18'h35f65; tw_im[0308] = 18'h219d7; tw_re[0309] = 18'h35c6a; tw_im[0309] = 18'h21ad6; tw_re[0310] = 18'h35971; tw_im[0310] = 18'h21bd9; tw_re[0311] = 18'h35679; tw_im[0311] = 18'h21ce1; 
	tw_re[0312] = 18'h35383; tw_im[0312] = 18'h21dee; tw_re[0313] = 18'h3508f; tw_im[0313] = 18'h21eff; tw_re[0314] = 18'h34d9c; tw_im[0314] = 18'h22015; tw_re[0315] = 18'h34aab; tw_im[0315] = 18'h2212f; 
	tw_re[0316] = 18'h347bc; tw_im[0316] = 18'h2224f; tw_re[0317] = 18'h344ce; tw_im[0317] = 18'h22372; tw_re[0318] = 18'h341e2; tw_im[0318] = 18'h2249b; tw_re[0319] = 18'h33ef9; tw_im[0319] = 18'h225c8; 
	tw_re[0320] = 18'h33c11; tw_im[0320] = 18'h226f9; tw_re[0321] = 18'h3392b; tw_im[0321] = 18'h2282f; tw_re[0322] = 18'h33646; tw_im[0322] = 18'h2296a; tw_re[0323] = 18'h33364; tw_im[0323] = 18'h22aa9; 
	tw_re[0324] = 18'h33084; tw_im[0324] = 18'h22bec; tw_re[0325] = 18'h32da6; tw_im[0325] = 18'h22d35; tw_re[0326] = 18'h32ac9; tw_im[0326] = 18'h22e81; tw_re[0327] = 18'h327ef; tw_im[0327] = 18'h22fd2; 
	tw_re[0328] = 18'h32517; tw_im[0328] = 18'h23128; tw_re[0329] = 18'h32241; tw_im[0329] = 18'h23282; tw_re[0330] = 18'h31f6d; tw_im[0330] = 18'h233e1; tw_re[0331] = 18'h31c9c; tw_im[0331] = 18'h23544; 
	tw_re[0332] = 18'h319cc; tw_im[0332] = 18'h236ab; tw_re[0333] = 18'h316ff; tw_im[0333] = 18'h23817; tw_re[0334] = 18'h31434; tw_im[0334] = 18'h23987; tw_re[0335] = 18'h3116b; tw_im[0335] = 18'h23afc; 
	tw_re[0336] = 18'h30ea5; tw_im[0336] = 18'h23c75; tw_re[0337] = 18'h30be1; tw_im[0337] = 18'h23df2; tw_re[0338] = 18'h3091f; tw_im[0338] = 18'h23f73; tw_re[0339] = 18'h30660; tw_im[0339] = 18'h240f9; 
	tw_re[0340] = 18'h303a3; tw_im[0340] = 18'h24284; tw_re[0341] = 18'h300e8; tw_im[0341] = 18'h24412; tw_re[0342] = 18'h2fe30; tw_im[0342] = 18'h245a5; tw_re[0343] = 18'h2fb7a; tw_im[0343] = 18'h2473c; 
	tw_re[0344] = 18'h2f8c7; tw_im[0344] = 18'h248d8; tw_re[0345] = 18'h2f617; tw_im[0345] = 18'h24a77; tw_re[0346] = 18'h2f369; tw_im[0346] = 18'h24c1b; tw_re[0347] = 18'h2f0bd; tw_im[0347] = 18'h24dc3; 
	tw_re[0348] = 18'h2ee15; tw_im[0348] = 18'h24f6f; tw_re[0349] = 18'h2eb6e; tw_im[0349] = 18'h2511f; tw_re[0350] = 18'h2e8cb; tw_im[0350] = 18'h252d4; tw_re[0351] = 18'h2e62a; tw_im[0351] = 18'h2548d; 
	tw_re[0352] = 18'h2e38c; tw_im[0352] = 18'h25649; tw_re[0353] = 18'h2e0f1; tw_im[0353] = 18'h2580a; tw_re[0354] = 18'h2de58; tw_im[0354] = 18'h259cf; tw_re[0355] = 18'h2dbc2; tw_im[0355] = 18'h25b98; 
	tw_re[0356] = 18'h2d92f; tw_im[0356] = 18'h25d65; tw_re[0357] = 18'h2d69f; tw_im[0357] = 18'h25f36; tw_re[0358] = 18'h2d412; tw_im[0358] = 18'h2610c; tw_re[0359] = 18'h2d188; tw_im[0359] = 18'h262e5; 
	tw_re[0360] = 18'h2cf00; tw_im[0360] = 18'h264c2; tw_re[0361] = 18'h2cc7c; tw_im[0361] = 18'h266a3; tw_re[0362] = 18'h2c9fa; tw_im[0362] = 18'h26888; tw_re[0363] = 18'h2c77c; tw_im[0363] = 18'h26a71; 
	tw_re[0364] = 18'h2c500; tw_im[0364] = 18'h26c5e; tw_re[0365] = 18'h2c288; tw_im[0365] = 18'h26e4e; tw_re[0366] = 18'h2c012; tw_im[0366] = 18'h27043; tw_re[0367] = 18'h2bda0; tw_im[0367] = 18'h2723b; 
	tw_re[0368] = 18'h2bb31; tw_im[0368] = 18'h27438; tw_re[0369] = 18'h2b8c4; tw_im[0369] = 18'h27638; tw_re[0370] = 18'h2b65b; tw_im[0370] = 18'h2783c; tw_re[0371] = 18'h2b3f6; tw_im[0371] = 18'h27a43; 
	tw_re[0372] = 18'h2b193; tw_im[0372] = 18'h27c4f; tw_re[0373] = 18'h2af34; tw_im[0373] = 18'h27e5e; tw_re[0374] = 18'h2acd8; tw_im[0374] = 18'h28071; tw_re[0375] = 18'h2aa7f; tw_im[0375] = 18'h28288; 
	tw_re[0376] = 18'h2a829; tw_im[0376] = 18'h284a2; tw_re[0377] = 18'h2a5d7; tw_im[0377] = 18'h286c0; tw_re[0378] = 18'h2a388; tw_im[0378] = 18'h288e1; tw_re[0379] = 18'h2a13c; tw_im[0379] = 18'h28b06; 
	tw_re[0380] = 18'h29ef4; tw_im[0380] = 18'h28d2f; tw_re[0381] = 18'h29cb0; tw_im[0381] = 18'h28f5c; tw_re[0382] = 18'h29a6e; tw_im[0382] = 18'h2918b; tw_re[0383] = 18'h29830; tw_im[0383] = 18'h293bf; 
	tw_re[0384] = 18'h295f6; tw_im[0384] = 18'h295f6; tw_re[0385] = 18'h293bf; tw_im[0385] = 18'h29830; tw_re[0386] = 18'h2918b; tw_im[0386] = 18'h29a6e; tw_re[0387] = 18'h28f5c; tw_im[0387] = 18'h29cb0; 
	tw_re[0388] = 18'h28d2f; tw_im[0388] = 18'h29ef4; tw_re[0389] = 18'h28b06; tw_im[0389] = 18'h2a13c; tw_re[0390] = 18'h288e1; tw_im[0390] = 18'h2a388; tw_re[0391] = 18'h286c0; tw_im[0391] = 18'h2a5d7; 
	tw_re[0392] = 18'h284a2; tw_im[0392] = 18'h2a829; tw_re[0393] = 18'h28288; tw_im[0393] = 18'h2aa7f; tw_re[0394] = 18'h28071; tw_im[0394] = 18'h2acd8; tw_re[0395] = 18'h27e5e; tw_im[0395] = 18'h2af34; 
	tw_re[0396] = 18'h27c4f; tw_im[0396] = 18'h2b193; tw_re[0397] = 18'h27a43; tw_im[0397] = 18'h2b3f6; tw_re[0398] = 18'h2783c; tw_im[0398] = 18'h2b65b; tw_re[0399] = 18'h27638; tw_im[0399] = 18'h2b8c4; 
	tw_re[0400] = 18'h27438; tw_im[0400] = 18'h2bb31; tw_re[0401] = 18'h2723b; tw_im[0401] = 18'h2bda0; tw_re[0402] = 18'h27043; tw_im[0402] = 18'h2c012; tw_re[0403] = 18'h26e4e; tw_im[0403] = 18'h2c288; 
	tw_re[0404] = 18'h26c5e; tw_im[0404] = 18'h2c500; tw_re[0405] = 18'h26a71; tw_im[0405] = 18'h2c77c; tw_re[0406] = 18'h26888; tw_im[0406] = 18'h2c9fa; tw_re[0407] = 18'h266a3; tw_im[0407] = 18'h2cc7c; 
	tw_re[0408] = 18'h264c2; tw_im[0408] = 18'h2cf00; tw_re[0409] = 18'h262e5; tw_im[0409] = 18'h2d188; tw_re[0410] = 18'h2610c; tw_im[0410] = 18'h2d412; tw_re[0411] = 18'h25f36; tw_im[0411] = 18'h2d69f; 
	tw_re[0412] = 18'h25d65; tw_im[0412] = 18'h2d92f; tw_re[0413] = 18'h25b98; tw_im[0413] = 18'h2dbc2; tw_re[0414] = 18'h259cf; tw_im[0414] = 18'h2de58; tw_re[0415] = 18'h2580a; tw_im[0415] = 18'h2e0f1; 
	tw_re[0416] = 18'h25649; tw_im[0416] = 18'h2e38c; tw_re[0417] = 18'h2548d; tw_im[0417] = 18'h2e62a; tw_re[0418] = 18'h252d4; tw_im[0418] = 18'h2e8cb; tw_re[0419] = 18'h2511f; tw_im[0419] = 18'h2eb6e; 
	tw_re[0420] = 18'h24f6f; tw_im[0420] = 18'h2ee15; tw_re[0421] = 18'h24dc3; tw_im[0421] = 18'h2f0bd; tw_re[0422] = 18'h24c1b; tw_im[0422] = 18'h2f369; tw_re[0423] = 18'h24a77; tw_im[0423] = 18'h2f617; 
	tw_re[0424] = 18'h248d8; tw_im[0424] = 18'h2f8c7; tw_re[0425] = 18'h2473c; tw_im[0425] = 18'h2fb7a; tw_re[0426] = 18'h245a5; tw_im[0426] = 18'h2fe30; tw_re[0427] = 18'h24412; tw_im[0427] = 18'h300e8; 
	tw_re[0428] = 18'h24284; tw_im[0428] = 18'h303a3; tw_re[0429] = 18'h240f9; tw_im[0429] = 18'h30660; tw_re[0430] = 18'h23f73; tw_im[0430] = 18'h3091f; tw_re[0431] = 18'h23df2; tw_im[0431] = 18'h30be1; 
	tw_re[0432] = 18'h23c75; tw_im[0432] = 18'h30ea5; tw_re[0433] = 18'h23afc; tw_im[0433] = 18'h3116b; tw_re[0434] = 18'h23987; tw_im[0434] = 18'h31434; tw_re[0435] = 18'h23817; tw_im[0435] = 18'h316ff; 
	tw_re[0436] = 18'h236ab; tw_im[0436] = 18'h319cc; tw_re[0437] = 18'h23544; tw_im[0437] = 18'h31c9c; tw_re[0438] = 18'h233e1; tw_im[0438] = 18'h31f6d; tw_re[0439] = 18'h23282; tw_im[0439] = 18'h32241; 
	tw_re[0440] = 18'h23128; tw_im[0440] = 18'h32517; tw_re[0441] = 18'h22fd2; tw_im[0441] = 18'h327ef; tw_re[0442] = 18'h22e81; tw_im[0442] = 18'h32ac9; tw_re[0443] = 18'h22d35; tw_im[0443] = 18'h32da6; 
	tw_re[0444] = 18'h22bec; tw_im[0444] = 18'h33084; tw_re[0445] = 18'h22aa9; tw_im[0445] = 18'h33364; tw_re[0446] = 18'h2296a; tw_im[0446] = 18'h33646; tw_re[0447] = 18'h2282f; tw_im[0447] = 18'h3392b; 
	tw_re[0448] = 18'h226f9; tw_im[0448] = 18'h33c11; tw_re[0449] = 18'h225c8; tw_im[0449] = 18'h33ef9; tw_re[0450] = 18'h2249b; tw_im[0450] = 18'h341e2; tw_re[0451] = 18'h22372; tw_im[0451] = 18'h344ce; 
	tw_re[0452] = 18'h2224f; tw_im[0452] = 18'h347bc; tw_re[0453] = 18'h2212f; tw_im[0453] = 18'h34aab; tw_re[0454] = 18'h22015; tw_im[0454] = 18'h34d9c; tw_re[0455] = 18'h21eff; tw_im[0455] = 18'h3508f; 
	tw_re[0456] = 18'h21dee; tw_im[0456] = 18'h35383; tw_re[0457] = 18'h21ce1; tw_im[0457] = 18'h35679; tw_re[0458] = 18'h21bd9; tw_im[0458] = 18'h35971; tw_re[0459] = 18'h21ad6; tw_im[0459] = 18'h35c6a; 
	tw_re[0460] = 18'h219d7; tw_im[0460] = 18'h35f65; tw_re[0461] = 18'h218dd; tw_im[0461] = 18'h36261; tw_re[0462] = 18'h217e8; tw_im[0462] = 18'h3655f; tw_re[0463] = 18'h216f7; tw_im[0463] = 18'h3685f; 
	tw_re[0464] = 18'h2160c; tw_im[0464] = 18'h36b60; tw_re[0465] = 18'h21525; tw_im[0465] = 18'h36e62; tw_re[0466] = 18'h21442; tw_im[0466] = 18'h37166; tw_re[0467] = 18'h21365; tw_im[0467] = 18'h3746b; 
	tw_re[0468] = 18'h2128c; tw_im[0468] = 18'h37771; tw_re[0469] = 18'h211b8; tw_im[0469] = 18'h37a79; tw_re[0470] = 18'h210e8; tw_im[0470] = 18'h37d82; tw_re[0471] = 18'h2101e; tw_im[0471] = 18'h3808c; 
	tw_re[0472] = 18'h20f58; tw_im[0472] = 18'h38398; tw_re[0473] = 18'h20e97; tw_im[0473] = 18'h386a5; tw_re[0474] = 18'h20ddb; tw_im[0474] = 18'h389b3; tw_re[0475] = 18'h20d23; tw_im[0475] = 18'h38cc2; 
	tw_re[0476] = 18'h20c71; tw_im[0476] = 18'h38fd2; tw_re[0477] = 18'h20bc3; tw_im[0477] = 18'h392e3; tw_re[0478] = 18'h20b1a; tw_im[0478] = 18'h395f5; tw_re[0479] = 18'h20a76; tw_im[0479] = 18'h39909; 
	tw_re[0480] = 18'h209d6; tw_im[0480] = 18'h39c1d; tw_re[0481] = 18'h2093c; tw_im[0481] = 18'h39f32; tw_re[0482] = 18'h208a6; tw_im[0482] = 18'h3a248; tw_re[0483] = 18'h20815; tw_im[0483] = 18'h3a55f; 
	tw_re[0484] = 18'h20789; tw_im[0484] = 18'h3a877; tw_re[0485] = 18'h20702; tw_im[0485] = 18'h3ab90; tw_re[0486] = 18'h20680; tw_im[0486] = 18'h3aeaa; tw_re[0487] = 18'h20603; tw_im[0487] = 18'h3b1c4; 
	tw_re[0488] = 18'h2058a; tw_im[0488] = 18'h3b4df; tw_re[0489] = 18'h20517; tw_im[0489] = 18'h3b7fb; tw_re[0490] = 18'h204a8; tw_im[0490] = 18'h3bb18; tw_re[0491] = 18'h2043e; tw_im[0491] = 18'h3be35; 
	tw_re[0492] = 18'h203d9; tw_im[0492] = 18'h3c153; tw_re[0493] = 18'h20379; tw_im[0493] = 18'h3c472; tw_re[0494] = 18'h2031e; tw_im[0494] = 18'h3c791; tw_re[0495] = 18'h202c8; tw_im[0495] = 18'h3cab0; 
	tw_re[0496] = 18'h20277; tw_im[0496] = 18'h3cdd0; tw_re[0497] = 18'h2022b; tw_im[0497] = 18'h3d0f1; tw_re[0498] = 18'h201e3; tw_im[0498] = 18'h3d412; tw_re[0499] = 18'h201a1; tw_im[0499] = 18'h3d734; 
	tw_re[0500] = 18'h20163; tw_im[0500] = 18'h3da55; tw_re[0501] = 18'h2012a; tw_im[0501] = 18'h3dd78; tw_re[0502] = 18'h200f6; tw_im[0502] = 18'h3e09a; tw_re[0503] = 18'h200c8; tw_im[0503] = 18'h3e3bd; 
	tw_re[0504] = 18'h2009e; tw_im[0504] = 18'h3e6e0; tw_re[0505] = 18'h20079; tw_im[0505] = 18'h3ea04; tw_re[0506] = 18'h20059; tw_im[0506] = 18'h3ed27; tw_re[0507] = 18'h2003d; tw_im[0507] = 18'h3f04b; 
	tw_re[0508] = 18'h20027; tw_im[0508] = 18'h3f36f; tw_re[0509] = 18'h20016; tw_im[0509] = 18'h3f693; tw_re[0510] = 18'h2000a; tw_im[0510] = 18'h3f9b7; tw_re[0511] = 18'h20002; tw_im[0511] = 18'h3fcdc; 
	tw_re[0512] = 18'h20001; tw_im[0512] = 18'h00000; tw_re[0513] = 18'h20002; tw_im[0513] = 18'h00324; tw_re[0514] = 18'h2000a; tw_im[0514] = 18'h00648; tw_re[0515] = 18'h20016; tw_im[0515] = 18'h0096c; 
	tw_re[0516] = 18'h20027; tw_im[0516] = 18'h00c90; tw_re[0517] = 18'h2003d; tw_im[0517] = 18'h00fb4; tw_re[0518] = 18'h20059; tw_im[0518] = 18'h012d8; tw_re[0519] = 18'h20079; tw_im[0519] = 18'h015fc; 
	tw_re[0520] = 18'h2009e; tw_im[0520] = 18'h0191f; tw_re[0521] = 18'h200c8; tw_im[0521] = 18'h01c42; tw_re[0522] = 18'h200f6; tw_im[0522] = 18'h01f65; tw_re[0523] = 18'h2012a; tw_im[0523] = 18'h02288; 
	tw_re[0524] = 18'h20163; tw_im[0524] = 18'h025aa; tw_re[0525] = 18'h201a1; tw_im[0525] = 18'h028cc; tw_re[0526] = 18'h201e3; tw_im[0526] = 18'h02bed; tw_re[0527] = 18'h2022b; tw_im[0527] = 18'h02f0e; 
	tw_re[0528] = 18'h20277; tw_im[0528] = 18'h0322f; tw_re[0529] = 18'h202c8; tw_im[0529] = 18'h0354f; tw_re[0530] = 18'h2031e; tw_im[0530] = 18'h0386f; tw_re[0531] = 18'h20379; tw_im[0531] = 18'h03b8e; 
	tw_re[0532] = 18'h203d9; tw_im[0532] = 18'h03eac; tw_re[0533] = 18'h2043e; tw_im[0533] = 18'h041ca; tw_re[0534] = 18'h204a8; tw_im[0534] = 18'h044e8; tw_re[0535] = 18'h20517; tw_im[0535] = 18'h04804; 
	tw_re[0536] = 18'h2058a; tw_im[0536] = 18'h04b20; tw_re[0537] = 18'h20603; tw_im[0537] = 18'h04e3b; tw_re[0538] = 18'h20680; tw_im[0538] = 18'h05156; tw_re[0539] = 18'h20702; tw_im[0539] = 18'h0546f; 
	tw_re[0540] = 18'h20789; tw_im[0540] = 18'h05788; tw_re[0541] = 18'h20815; tw_im[0541] = 18'h05aa0; tw_re[0542] = 18'h208a6; tw_im[0542] = 18'h05db7; tw_re[0543] = 18'h2093c; tw_im[0543] = 18'h060cd; 
	tw_re[0544] = 18'h209d6; tw_im[0544] = 18'h063e3; tw_re[0545] = 18'h20a76; tw_im[0545] = 18'h066f7; tw_re[0546] = 18'h20b1a; tw_im[0546] = 18'h06a0a; tw_re[0547] = 18'h20bc3; tw_im[0547] = 18'h06d1d; 
	tw_re[0548] = 18'h20c71; tw_im[0548] = 18'h0702e; tw_re[0549] = 18'h20d23; tw_im[0549] = 18'h0733e; tw_re[0550] = 18'h20ddb; tw_im[0550] = 18'h0764d; tw_re[0551] = 18'h20e97; tw_im[0551] = 18'h0795b; 
	tw_re[0552] = 18'h20f58; tw_im[0552] = 18'h07c68; tw_re[0553] = 18'h2101e; tw_im[0553] = 18'h07f73; tw_re[0554] = 18'h210e8; tw_im[0554] = 18'h0827e; tw_re[0555] = 18'h211b8; tw_im[0555] = 18'h08587; 
	tw_re[0556] = 18'h2128c; tw_im[0556] = 18'h0888e; tw_re[0557] = 18'h21365; tw_im[0557] = 18'h08b95; tw_re[0558] = 18'h21442; tw_im[0558] = 18'h08e9a; tw_re[0559] = 18'h21525; tw_im[0559] = 18'h0919e; 
	tw_re[0560] = 18'h2160c; tw_im[0560] = 18'h094a0; tw_re[0561] = 18'h216f7; tw_im[0561] = 18'h097a1; tw_re[0562] = 18'h217e8; tw_im[0562] = 18'h09aa0; tw_re[0563] = 18'h218dd; tw_im[0563] = 18'h09d9e; 
	tw_re[0564] = 18'h219d7; tw_im[0564] = 18'h0a09b; tw_re[0565] = 18'h21ad6; tw_im[0565] = 18'h0a396; tw_re[0566] = 18'h21bd9; tw_im[0566] = 18'h0a68f; tw_re[0567] = 18'h21ce1; tw_im[0567] = 18'h0a987; 
	tw_re[0568] = 18'h21dee; tw_im[0568] = 18'h0ac7d; tw_re[0569] = 18'h21eff; tw_im[0569] = 18'h0af71; tw_re[0570] = 18'h22015; tw_im[0570] = 18'h0b264; tw_re[0571] = 18'h2212f; tw_im[0571] = 18'h0b555; 
	tw_re[0572] = 18'h2224f; tw_im[0572] = 18'h0b844; tw_re[0573] = 18'h22372; tw_im[0573] = 18'h0bb31; tw_re[0574] = 18'h2249b; tw_im[0574] = 18'h0be1d; tw_re[0575] = 18'h225c8; tw_im[0575] = 18'h0c107; 
	tw_re[0576] = 18'h226f9; tw_im[0576] = 18'h0c3ef; tw_re[0577] = 18'h2282f; tw_im[0577] = 18'h0c6d5; tw_re[0578] = 18'h2296a; tw_im[0578] = 18'h0c9b9; tw_re[0579] = 18'h22aa9; tw_im[0579] = 18'h0cc9b; 
	tw_re[0580] = 18'h22bec; tw_im[0580] = 18'h0cf7c; tw_re[0581] = 18'h22d35; tw_im[0581] = 18'h0d25a; tw_re[0582] = 18'h22e81; tw_im[0582] = 18'h0d536; tw_re[0583] = 18'h22fd2; tw_im[0583] = 18'h0d810; 
	tw_re[0584] = 18'h23128; tw_im[0584] = 18'h0dae8; tw_re[0585] = 18'h23282; tw_im[0585] = 18'h0ddbe; tw_re[0586] = 18'h233e1; tw_im[0586] = 18'h0e092; tw_re[0587] = 18'h23544; tw_im[0587] = 18'h0e364; 
	tw_re[0588] = 18'h236ab; tw_im[0588] = 18'h0e633; tw_re[0589] = 18'h23817; tw_im[0589] = 18'h0e900; tw_re[0590] = 18'h23987; tw_im[0590] = 18'h0ebcb; tw_re[0591] = 18'h23afc; tw_im[0591] = 18'h0ee94; 
	tw_re[0592] = 18'h23c75; tw_im[0592] = 18'h0f15b; tw_re[0593] = 18'h23df2; tw_im[0593] = 18'h0f41f; tw_re[0594] = 18'h23f73; tw_im[0594] = 18'h0f6e1; tw_re[0595] = 18'h240f9; tw_im[0595] = 18'h0f9a0; 
	tw_re[0596] = 18'h24284; tw_im[0596] = 18'h0fc5d; tw_re[0597] = 18'h24412; tw_im[0597] = 18'h0ff17; tw_re[0598] = 18'h245a5; tw_im[0598] = 18'h101d0; tw_re[0599] = 18'h2473c; tw_im[0599] = 18'h10485; 
	tw_re[0600] = 18'h248d8; tw_im[0600] = 18'h10738; tw_re[0601] = 18'h24a77; tw_im[0601] = 18'h109e9; tw_re[0602] = 18'h24c1b; tw_im[0602] = 18'h10c97; tw_re[0603] = 18'h24dc3; tw_im[0603] = 18'h10f42; 
	tw_re[0604] = 18'h24f6f; tw_im[0604] = 18'h111eb; tw_re[0605] = 18'h2511f; tw_im[0605] = 18'h11491; tw_re[0606] = 18'h252d4; tw_im[0606] = 18'h11735; tw_re[0607] = 18'h2548d; tw_im[0607] = 18'h119d5; 
	tw_re[0608] = 18'h25649; tw_im[0608] = 18'h11c73; tw_re[0609] = 18'h2580a; tw_im[0609] = 18'h11f0f; tw_re[0610] = 18'h259cf; tw_im[0610] = 18'h121a7; tw_re[0611] = 18'h25b98; tw_im[0611] = 18'h1243d; 
	tw_re[0612] = 18'h25d65; tw_im[0612] = 18'h126d0; tw_re[0613] = 18'h25f36; tw_im[0613] = 18'h12960; tw_re[0614] = 18'h2610c; tw_im[0614] = 18'h12bed; tw_re[0615] = 18'h262e5; tw_im[0615] = 18'h12e78; 
	tw_re[0616] = 18'h264c2; tw_im[0616] = 18'h130ff; tw_re[0617] = 18'h266a3; tw_im[0617] = 18'h13384; tw_re[0618] = 18'h26888; tw_im[0618] = 18'h13605; tw_re[0619] = 18'h26a71; tw_im[0619] = 18'h13884; 
	tw_re[0620] = 18'h26c5e; tw_im[0620] = 18'h13aff; tw_re[0621] = 18'h26e4e; tw_im[0621] = 18'h13d78; tw_re[0622] = 18'h27043; tw_im[0622] = 18'h13fed; tw_re[0623] = 18'h2723b; tw_im[0623] = 18'h14260; 
	tw_re[0624] = 18'h27438; tw_im[0624] = 18'h144cf; tw_re[0625] = 18'h27638; tw_im[0625] = 18'h1473b; tw_re[0626] = 18'h2783c; tw_im[0626] = 18'h149a4; tw_re[0627] = 18'h27a43; tw_im[0627] = 18'h14c0a; 
	tw_re[0628] = 18'h27c4f; tw_im[0628] = 18'h14e6c; tw_re[0629] = 18'h27e5e; tw_im[0629] = 18'h150cc; tw_re[0630] = 18'h28071; tw_im[0630] = 18'h15328; tw_re[0631] = 18'h28288; tw_im[0631] = 18'h15581; 
	tw_re[0632] = 18'h284a2; tw_im[0632] = 18'h157d6; tw_re[0633] = 18'h286c0; tw_im[0633] = 18'h15a29; tw_re[0634] = 18'h288e1; tw_im[0634] = 18'h15c77; tw_re[0635] = 18'h28b06; tw_im[0635] = 18'h15ec3; 
	tw_re[0636] = 18'h28d2f; tw_im[0636] = 18'h1610b; tw_re[0637] = 18'h28f5c; tw_im[0637] = 18'h16350; tw_re[0638] = 18'h2918b; tw_im[0638] = 18'h16591; tw_re[0639] = 18'h293bf; tw_im[0639] = 18'h167cf; 
	tw_re[0640] = 18'h295f6; tw_im[0640] = 18'h16a0a; tw_re[0641] = 18'h29830; tw_im[0641] = 18'h16c41; tw_re[0642] = 18'h29a6e; tw_im[0642] = 18'h16e74; tw_re[0643] = 18'h29cb0; tw_im[0643] = 18'h170a4; 
	tw_re[0644] = 18'h29ef4; tw_im[0644] = 18'h172d0; tw_re[0645] = 18'h2a13c; tw_im[0645] = 18'h174f9; tw_re[0646] = 18'h2a388; tw_im[0646] = 18'h1771e; tw_re[0647] = 18'h2a5d7; tw_im[0647] = 18'h17940; 
	tw_re[0648] = 18'h2a829; tw_im[0648] = 18'h17b5e; tw_re[0649] = 18'h2aa7f; tw_im[0649] = 18'h17d78; tw_re[0650] = 18'h2acd8; tw_im[0650] = 18'h17f8f; tw_re[0651] = 18'h2af34; tw_im[0651] = 18'h181a1; 
	tw_re[0652] = 18'h2b193; tw_im[0652] = 18'h183b1; tw_re[0653] = 18'h2b3f6; tw_im[0653] = 18'h185bc; tw_re[0654] = 18'h2b65b; tw_im[0654] = 18'h187c4; tw_re[0655] = 18'h2b8c4; tw_im[0655] = 18'h189c8; 
	tw_re[0656] = 18'h2bb31; tw_im[0656] = 18'h18bc8; tw_re[0657] = 18'h2bda0; tw_im[0657] = 18'h18dc4; tw_re[0658] = 18'h2c012; tw_im[0658] = 18'h18fbd; tw_re[0659] = 18'h2c288; tw_im[0659] = 18'h191b1; 
	tw_re[0660] = 18'h2c500; tw_im[0660] = 18'h193a2; tw_re[0661] = 18'h2c77c; tw_im[0661] = 18'h1958f; tw_re[0662] = 18'h2c9fa; tw_im[0662] = 18'h19778; tw_re[0663] = 18'h2cc7c; tw_im[0663] = 18'h1995d; 
	tw_re[0664] = 18'h2cf00; tw_im[0664] = 18'h19b3e; tw_re[0665] = 18'h2d188; tw_im[0665] = 18'h19d1b; tw_re[0666] = 18'h2d412; tw_im[0666] = 18'h19ef4; tw_re[0667] = 18'h2d69f; tw_im[0667] = 18'h1a0c9; 
	tw_re[0668] = 18'h2d92f; tw_im[0668] = 18'h1a29a; tw_re[0669] = 18'h2dbc2; tw_im[0669] = 18'h1a467; tw_re[0670] = 18'h2de58; tw_im[0670] = 18'h1a630; tw_re[0671] = 18'h2e0f1; tw_im[0671] = 18'h1a7f5; 
	tw_re[0672] = 18'h2e38c; tw_im[0672] = 18'h1a9b6; tw_re[0673] = 18'h2e62a; tw_im[0673] = 18'h1ab73; tw_re[0674] = 18'h2e8cb; tw_im[0674] = 18'h1ad2c; tw_re[0675] = 18'h2eb6e; tw_im[0675] = 18'h1aee0; 
	tw_re[0676] = 18'h2ee15; tw_im[0676] = 18'h1b090; tw_re[0677] = 18'h2f0bd; tw_im[0677] = 18'h1b23d; tw_re[0678] = 18'h2f369; tw_im[0678] = 18'h1b3e5; tw_re[0679] = 18'h2f617; tw_im[0679] = 18'h1b588; 
	tw_re[0680] = 18'h2f8c7; tw_im[0680] = 18'h1b728; tw_re[0681] = 18'h2fb7a; tw_im[0681] = 18'h1b8c3; tw_re[0682] = 18'h2fe30; tw_im[0682] = 18'h1ba5a; tw_re[0683] = 18'h300e8; tw_im[0683] = 18'h1bbed; 
	tw_re[0684] = 18'h303a3; tw_im[0684] = 18'h1bd7c; tw_re[0685] = 18'h30660; tw_im[0685] = 18'h1bf06; tw_re[0686] = 18'h3091f; tw_im[0686] = 18'h1c08c; tw_re[0687] = 18'h30be1; tw_im[0687] = 18'h1c20e; 
	tw_re[0688] = 18'h30ea5; tw_im[0688] = 18'h1c38b; tw_re[0689] = 18'h3116b; tw_im[0689] = 18'h1c504; tw_re[0690] = 18'h31434; tw_im[0690] = 18'h1c678; tw_re[0691] = 18'h316ff; tw_im[0691] = 18'h1c7e9; 
	tw_re[0692] = 18'h319cc; tw_im[0692] = 18'h1c954; tw_re[0693] = 18'h31c9c; tw_im[0693] = 18'h1cabc; tw_re[0694] = 18'h31f6d; tw_im[0694] = 18'h1cc1f; tw_re[0695] = 18'h32241; tw_im[0695] = 18'h1cd7d; 
	tw_re[0696] = 18'h32517; tw_im[0696] = 18'h1ced7; tw_re[0697] = 18'h327ef; tw_im[0697] = 18'h1d02d; tw_re[0698] = 18'h32ac9; tw_im[0698] = 18'h1d17e; tw_re[0699] = 18'h32da6; tw_im[0699] = 18'h1d2cb; 
	tw_re[0700] = 18'h33084; tw_im[0700] = 18'h1d413; tw_re[0701] = 18'h33364; tw_im[0701] = 18'h1d557; tw_re[0702] = 18'h33646; tw_im[0702] = 18'h1d696; tw_re[0703] = 18'h3392b; tw_im[0703] = 18'h1d7d0; 
	tw_re[0704] = 18'h33c11; tw_im[0704] = 18'h1d906; tw_re[0705] = 18'h33ef9; tw_im[0705] = 18'h1da38; tw_re[0706] = 18'h341e2; tw_im[0706] = 18'h1db65; tw_re[0707] = 18'h344ce; tw_im[0707] = 18'h1dc8d; 
	tw_re[0708] = 18'h347bc; tw_im[0708] = 18'h1ddb1; tw_re[0709] = 18'h34aab; tw_im[0709] = 18'h1ded0; tw_re[0710] = 18'h34d9c; tw_im[0710] = 18'h1dfeb; tw_re[0711] = 18'h3508f; tw_im[0711] = 18'h1e101; 
	tw_re[0712] = 18'h35383; tw_im[0712] = 18'h1e212; tw_re[0713] = 18'h35679; tw_im[0713] = 18'h1e31e; tw_re[0714] = 18'h35971; tw_im[0714] = 18'h1e426; tw_re[0715] = 18'h35c6a; tw_im[0715] = 18'h1e52a; 
	tw_re[0716] = 18'h35f65; tw_im[0716] = 18'h1e628; tw_re[0717] = 18'h36261; tw_im[0717] = 18'h1e722; tw_re[0718] = 18'h3655f; tw_im[0718] = 18'h1e817; tw_re[0719] = 18'h3685f; tw_im[0719] = 18'h1e908; 
	tw_re[0720] = 18'h36b60; tw_im[0720] = 18'h1e9f4; tw_re[0721] = 18'h36e62; tw_im[0721] = 18'h1eadb; tw_re[0722] = 18'h37166; tw_im[0722] = 18'h1ebbd; tw_re[0723] = 18'h3746b; tw_im[0723] = 18'h1ec9b; 
	tw_re[0724] = 18'h37771; tw_im[0724] = 18'h1ed74; tw_re[0725] = 18'h37a79; tw_im[0725] = 18'h1ee48; tw_re[0726] = 18'h37d82; tw_im[0726] = 18'h1ef17; tw_re[0727] = 18'h3808c; tw_im[0727] = 18'h1efe2; 
	tw_re[0728] = 18'h38398; tw_im[0728] = 18'h1f0a8; tw_re[0729] = 18'h386a5; tw_im[0729] = 18'h1f169; tw_re[0730] = 18'h389b3; tw_im[0730] = 18'h1f225; tw_re[0731] = 18'h38cc2; tw_im[0731] = 18'h1f2dc; 
	tw_re[0732] = 18'h38fd2; tw_im[0732] = 18'h1f38f; tw_re[0733] = 18'h392e3; tw_im[0733] = 18'h1f43d; tw_re[0734] = 18'h395f5; tw_im[0734] = 18'h1f4e6; tw_re[0735] = 18'h39909; tw_im[0735] = 18'h1f58a; 
	tw_re[0736] = 18'h39c1d; tw_im[0736] = 18'h1f629; tw_re[0737] = 18'h39f32; tw_im[0737] = 18'h1f6c4; tw_re[0738] = 18'h3a248; tw_im[0738] = 18'h1f759; tw_re[0739] = 18'h3a55f; tw_im[0739] = 18'h1f7ea; 
	tw_re[0740] = 18'h3a877; tw_im[0740] = 18'h1f876; tw_re[0741] = 18'h3ab90; tw_im[0741] = 18'h1f8fd; tw_re[0742] = 18'h3aeaa; tw_im[0742] = 18'h1f97f; tw_re[0743] = 18'h3b1c4; tw_im[0743] = 18'h1f9fd; 
	tw_re[0744] = 18'h3b4df; tw_im[0744] = 18'h1fa75; tw_re[0745] = 18'h3b7fb; tw_im[0745] = 18'h1fae9; tw_re[0746] = 18'h3bb18; tw_im[0746] = 18'h1fb57; tw_re[0747] = 18'h3be35; tw_im[0747] = 18'h1fbc1; 
	tw_re[0748] = 18'h3c153; tw_im[0748] = 18'h1fc26; tw_re[0749] = 18'h3c472; tw_im[0749] = 18'h1fc86; tw_re[0750] = 18'h3c791; tw_im[0750] = 18'h1fce1; tw_re[0751] = 18'h3cab0; tw_im[0751] = 18'h1fd37; 
	tw_re[0752] = 18'h3cdd0; tw_im[0752] = 18'h1fd89; tw_re[0753] = 18'h3d0f1; tw_im[0753] = 18'h1fdd5; tw_re[0754] = 18'h3d412; tw_im[0754] = 18'h1fe1c; tw_re[0755] = 18'h3d734; tw_im[0755] = 18'h1fe5f; 
	tw_re[0756] = 18'h3da55; tw_im[0756] = 18'h1fe9d; tw_re[0757] = 18'h3dd78; tw_im[0757] = 18'h1fed5; tw_re[0758] = 18'h3e09a; tw_im[0758] = 18'h1ff09; tw_re[0759] = 18'h3e3bd; tw_im[0759] = 18'h1ff38; 
	tw_re[0760] = 18'h3e6e0; tw_im[0760] = 18'h1ff62; tw_re[0761] = 18'h3ea04; tw_im[0761] = 18'h1ff87; tw_re[0762] = 18'h3ed27; tw_im[0762] = 18'h1ffa7; tw_re[0763] = 18'h3f04b; tw_im[0763] = 18'h1ffc2; 
	tw_re[0764] = 18'h3f36f; tw_im[0764] = 18'h1ffd8; tw_re[0765] = 18'h3f693; tw_im[0765] = 18'h1ffea; tw_re[0766] = 18'h3f9b7; tw_im[0766] = 18'h1fff6; tw_re[0767] = 18'h3fcdc; tw_im[0767] = 18'h1fffd; 
	tw_re[0768] = 18'h00000; tw_im[0768] = 18'h1ffff; tw_re[0769] = 18'h00324; tw_im[0769] = 18'h1fffd; tw_re[0770] = 18'h00648; tw_im[0770] = 18'h1fff6; tw_re[0771] = 18'h0096c; tw_im[0771] = 18'h1ffea; 
	tw_re[0772] = 18'h00c90; tw_im[0772] = 18'h1ffd8; tw_re[0773] = 18'h00fb4; tw_im[0773] = 18'h1ffc2; tw_re[0774] = 18'h012d8; tw_im[0774] = 18'h1ffa7; tw_re[0775] = 18'h015fc; tw_im[0775] = 18'h1ff87; 
	tw_re[0776] = 18'h0191f; tw_im[0776] = 18'h1ff62; tw_re[0777] = 18'h01c42; tw_im[0777] = 18'h1ff38; tw_re[0778] = 18'h01f65; tw_im[0778] = 18'h1ff09; tw_re[0779] = 18'h02288; tw_im[0779] = 18'h1fed5; 
	tw_re[0780] = 18'h025aa; tw_im[0780] = 18'h1fe9d; tw_re[0781] = 18'h028cc; tw_im[0781] = 18'h1fe5f; tw_re[0782] = 18'h02bed; tw_im[0782] = 18'h1fe1c; tw_re[0783] = 18'h02f0e; tw_im[0783] = 18'h1fdd5; 
	tw_re[0784] = 18'h0322f; tw_im[0784] = 18'h1fd89; tw_re[0785] = 18'h0354f; tw_im[0785] = 18'h1fd37; tw_re[0786] = 18'h0386f; tw_im[0786] = 18'h1fce1; tw_re[0787] = 18'h03b8e; tw_im[0787] = 18'h1fc86; 
	tw_re[0788] = 18'h03eac; tw_im[0788] = 18'h1fc26; tw_re[0789] = 18'h041ca; tw_im[0789] = 18'h1fbc1; tw_re[0790] = 18'h044e8; tw_im[0790] = 18'h1fb57; tw_re[0791] = 18'h04804; tw_im[0791] = 18'h1fae9; 
	tw_re[0792] = 18'h04b20; tw_im[0792] = 18'h1fa75; tw_re[0793] = 18'h04e3b; tw_im[0793] = 18'h1f9fd; tw_re[0794] = 18'h05156; tw_im[0794] = 18'h1f97f; tw_re[0795] = 18'h0546f; tw_im[0795] = 18'h1f8fd; 
	tw_re[0796] = 18'h05788; tw_im[0796] = 18'h1f876; tw_re[0797] = 18'h05aa0; tw_im[0797] = 18'h1f7ea; tw_re[0798] = 18'h05db7; tw_im[0798] = 18'h1f759; tw_re[0799] = 18'h060cd; tw_im[0799] = 18'h1f6c4; 
	tw_re[0800] = 18'h063e3; tw_im[0800] = 18'h1f629; tw_re[0801] = 18'h066f7; tw_im[0801] = 18'h1f58a; tw_re[0802] = 18'h06a0a; tw_im[0802] = 18'h1f4e6; tw_re[0803] = 18'h06d1d; tw_im[0803] = 18'h1f43d; 
	tw_re[0804] = 18'h0702e; tw_im[0804] = 18'h1f38f; tw_re[0805] = 18'h0733e; tw_im[0805] = 18'h1f2dc; tw_re[0806] = 18'h0764d; tw_im[0806] = 18'h1f225; tw_re[0807] = 18'h0795b; tw_im[0807] = 18'h1f169; 
	tw_re[0808] = 18'h07c68; tw_im[0808] = 18'h1f0a8; tw_re[0809] = 18'h07f73; tw_im[0809] = 18'h1efe2; tw_re[0810] = 18'h0827e; tw_im[0810] = 18'h1ef17; tw_re[0811] = 18'h08587; tw_im[0811] = 18'h1ee48; 
	tw_re[0812] = 18'h0888e; tw_im[0812] = 18'h1ed74; tw_re[0813] = 18'h08b95; tw_im[0813] = 18'h1ec9b; tw_re[0814] = 18'h08e9a; tw_im[0814] = 18'h1ebbd; tw_re[0815] = 18'h0919e; tw_im[0815] = 18'h1eadb; 
	tw_re[0816] = 18'h094a0; tw_im[0816] = 18'h1e9f4; tw_re[0817] = 18'h097a1; tw_im[0817] = 18'h1e908; tw_re[0818] = 18'h09aa0; tw_im[0818] = 18'h1e817; tw_re[0819] = 18'h09d9e; tw_im[0819] = 18'h1e722; 
	tw_re[0820] = 18'h0a09b; tw_im[0820] = 18'h1e628; tw_re[0821] = 18'h0a396; tw_im[0821] = 18'h1e52a; tw_re[0822] = 18'h0a68f; tw_im[0822] = 18'h1e426; tw_re[0823] = 18'h0a987; tw_im[0823] = 18'h1e31e; 
	tw_re[0824] = 18'h0ac7d; tw_im[0824] = 18'h1e212; tw_re[0825] = 18'h0af71; tw_im[0825] = 18'h1e101; tw_re[0826] = 18'h0b264; tw_im[0826] = 18'h1dfeb; tw_re[0827] = 18'h0b555; tw_im[0827] = 18'h1ded0; 
	tw_re[0828] = 18'h0b844; tw_im[0828] = 18'h1ddb1; tw_re[0829] = 18'h0bb31; tw_im[0829] = 18'h1dc8d; tw_re[0830] = 18'h0be1d; tw_im[0830] = 18'h1db65; tw_re[0831] = 18'h0c107; tw_im[0831] = 18'h1da38; 
	tw_re[0832] = 18'h0c3ef; tw_im[0832] = 18'h1d906; tw_re[0833] = 18'h0c6d5; tw_im[0833] = 18'h1d7d0; tw_re[0834] = 18'h0c9b9; tw_im[0834] = 18'h1d696; tw_re[0835] = 18'h0cc9b; tw_im[0835] = 18'h1d557; 
	tw_re[0836] = 18'h0cf7c; tw_im[0836] = 18'h1d413; tw_re[0837] = 18'h0d25a; tw_im[0837] = 18'h1d2cb; tw_re[0838] = 18'h0d536; tw_im[0838] = 18'h1d17e; tw_re[0839] = 18'h0d810; tw_im[0839] = 18'h1d02d; 
	tw_re[0840] = 18'h0dae8; tw_im[0840] = 18'h1ced7; tw_re[0841] = 18'h0ddbe; tw_im[0841] = 18'h1cd7d; tw_re[0842] = 18'h0e092; tw_im[0842] = 18'h1cc1f; tw_re[0843] = 18'h0e364; tw_im[0843] = 18'h1cabc; 
	tw_re[0844] = 18'h0e633; tw_im[0844] = 18'h1c954; tw_re[0845] = 18'h0e900; tw_im[0845] = 18'h1c7e9; tw_re[0846] = 18'h0ebcb; tw_im[0846] = 18'h1c678; tw_re[0847] = 18'h0ee94; tw_im[0847] = 18'h1c504; 
	tw_re[0848] = 18'h0f15b; tw_im[0848] = 18'h1c38b; tw_re[0849] = 18'h0f41f; tw_im[0849] = 18'h1c20e; tw_re[0850] = 18'h0f6e1; tw_im[0850] = 18'h1c08c; tw_re[0851] = 18'h0f9a0; tw_im[0851] = 18'h1bf06; 
	tw_re[0852] = 18'h0fc5d; tw_im[0852] = 18'h1bd7c; tw_re[0853] = 18'h0ff17; tw_im[0853] = 18'h1bbed; tw_re[0854] = 18'h101d0; tw_im[0854] = 18'h1ba5a; tw_re[0855] = 18'h10485; tw_im[0855] = 18'h1b8c3; 
	tw_re[0856] = 18'h10738; tw_im[0856] = 18'h1b728; tw_re[0857] = 18'h109e9; tw_im[0857] = 18'h1b588; tw_re[0858] = 18'h10c97; tw_im[0858] = 18'h1b3e5; tw_re[0859] = 18'h10f42; tw_im[0859] = 18'h1b23d; 
	tw_re[0860] = 18'h111eb; tw_im[0860] = 18'h1b090; tw_re[0861] = 18'h11491; tw_im[0861] = 18'h1aee0; tw_re[0862] = 18'h11735; tw_im[0862] = 18'h1ad2c; tw_re[0863] = 18'h119d5; tw_im[0863] = 18'h1ab73; 
	tw_re[0864] = 18'h11c73; tw_im[0864] = 18'h1a9b6; tw_re[0865] = 18'h11f0f; tw_im[0865] = 18'h1a7f5; tw_re[0866] = 18'h121a7; tw_im[0866] = 18'h1a630; tw_re[0867] = 18'h1243d; tw_im[0867] = 18'h1a467; 
	tw_re[0868] = 18'h126d0; tw_im[0868] = 18'h1a29a; tw_re[0869] = 18'h12960; tw_im[0869] = 18'h1a0c9; tw_re[0870] = 18'h12bed; tw_im[0870] = 18'h19ef4; tw_re[0871] = 18'h12e78; tw_im[0871] = 18'h19d1b; 
	tw_re[0872] = 18'h130ff; tw_im[0872] = 18'h19b3e; tw_re[0873] = 18'h13384; tw_im[0873] = 18'h1995d; tw_re[0874] = 18'h13605; tw_im[0874] = 18'h19778; tw_re[0875] = 18'h13884; tw_im[0875] = 18'h1958f; 
	tw_re[0876] = 18'h13aff; tw_im[0876] = 18'h193a2; tw_re[0877] = 18'h13d78; tw_im[0877] = 18'h191b1; tw_re[0878] = 18'h13fed; tw_im[0878] = 18'h18fbd; tw_re[0879] = 18'h14260; tw_im[0879] = 18'h18dc4; 
	tw_re[0880] = 18'h144cf; tw_im[0880] = 18'h18bc8; tw_re[0881] = 18'h1473b; tw_im[0881] = 18'h189c8; tw_re[0882] = 18'h149a4; tw_im[0882] = 18'h187c4; tw_re[0883] = 18'h14c0a; tw_im[0883] = 18'h185bc; 
	tw_re[0884] = 18'h14e6c; tw_im[0884] = 18'h183b1; tw_re[0885] = 18'h150cc; tw_im[0885] = 18'h181a1; tw_re[0886] = 18'h15328; tw_im[0886] = 18'h17f8f; tw_re[0887] = 18'h15581; tw_im[0887] = 18'h17d78; 
	tw_re[0888] = 18'h157d6; tw_im[0888] = 18'h17b5e; tw_re[0889] = 18'h15a29; tw_im[0889] = 18'h17940; tw_re[0890] = 18'h15c77; tw_im[0890] = 18'h1771e; tw_re[0891] = 18'h15ec3; tw_im[0891] = 18'h174f9; 
	tw_re[0892] = 18'h1610b; tw_im[0892] = 18'h172d0; tw_re[0893] = 18'h16350; tw_im[0893] = 18'h170a4; tw_re[0894] = 18'h16591; tw_im[0894] = 18'h16e74; tw_re[0895] = 18'h167cf; tw_im[0895] = 18'h16c41; 
	tw_re[0896] = 18'h16a0a; tw_im[0896] = 18'h16a0a; tw_re[0897] = 18'h16c41; tw_im[0897] = 18'h167cf; tw_re[0898] = 18'h16e74; tw_im[0898] = 18'h16591; tw_re[0899] = 18'h170a4; tw_im[0899] = 18'h16350; 
	tw_re[0900] = 18'h172d0; tw_im[0900] = 18'h1610b; tw_re[0901] = 18'h174f9; tw_im[0901] = 18'h15ec3; tw_re[0902] = 18'h1771e; tw_im[0902] = 18'h15c77; tw_re[0903] = 18'h17940; tw_im[0903] = 18'h15a29; 
	tw_re[0904] = 18'h17b5e; tw_im[0904] = 18'h157d6; tw_re[0905] = 18'h17d78; tw_im[0905] = 18'h15581; tw_re[0906] = 18'h17f8f; tw_im[0906] = 18'h15328; tw_re[0907] = 18'h181a1; tw_im[0907] = 18'h150cc; 
	tw_re[0908] = 18'h183b1; tw_im[0908] = 18'h14e6c; tw_re[0909] = 18'h185bc; tw_im[0909] = 18'h14c0a; tw_re[0910] = 18'h187c4; tw_im[0910] = 18'h149a4; tw_re[0911] = 18'h189c8; tw_im[0911] = 18'h1473b; 
	tw_re[0912] = 18'h18bc8; tw_im[0912] = 18'h144cf; tw_re[0913] = 18'h18dc4; tw_im[0913] = 18'h14260; tw_re[0914] = 18'h18fbd; tw_im[0914] = 18'h13fed; tw_re[0915] = 18'h191b1; tw_im[0915] = 18'h13d78; 
	tw_re[0916] = 18'h193a2; tw_im[0916] = 18'h13aff; tw_re[0917] = 18'h1958f; tw_im[0917] = 18'h13884; tw_re[0918] = 18'h19778; tw_im[0918] = 18'h13605; tw_re[0919] = 18'h1995d; tw_im[0919] = 18'h13384; 
	tw_re[0920] = 18'h19b3e; tw_im[0920] = 18'h130ff; tw_re[0921] = 18'h19d1b; tw_im[0921] = 18'h12e78; tw_re[0922] = 18'h19ef4; tw_im[0922] = 18'h12bed; tw_re[0923] = 18'h1a0c9; tw_im[0923] = 18'h12960; 
	tw_re[0924] = 18'h1a29a; tw_im[0924] = 18'h126d0; tw_re[0925] = 18'h1a467; tw_im[0925] = 18'h1243d; tw_re[0926] = 18'h1a630; tw_im[0926] = 18'h121a7; tw_re[0927] = 18'h1a7f5; tw_im[0927] = 18'h11f0f; 
	tw_re[0928] = 18'h1a9b6; tw_im[0928] = 18'h11c73; tw_re[0929] = 18'h1ab73; tw_im[0929] = 18'h119d5; tw_re[0930] = 18'h1ad2c; tw_im[0930] = 18'h11735; tw_re[0931] = 18'h1aee0; tw_im[0931] = 18'h11491; 
	tw_re[0932] = 18'h1b090; tw_im[0932] = 18'h111eb; tw_re[0933] = 18'h1b23d; tw_im[0933] = 18'h10f42; tw_re[0934] = 18'h1b3e5; tw_im[0934] = 18'h10c97; tw_re[0935] = 18'h1b588; tw_im[0935] = 18'h109e9; 
	tw_re[0936] = 18'h1b728; tw_im[0936] = 18'h10738; tw_re[0937] = 18'h1b8c3; tw_im[0937] = 18'h10485; tw_re[0938] = 18'h1ba5a; tw_im[0938] = 18'h101d0; tw_re[0939] = 18'h1bbed; tw_im[0939] = 18'h0ff17; 
	tw_re[0940] = 18'h1bd7c; tw_im[0940] = 18'h0fc5d; tw_re[0941] = 18'h1bf06; tw_im[0941] = 18'h0f9a0; tw_re[0942] = 18'h1c08c; tw_im[0942] = 18'h0f6e1; tw_re[0943] = 18'h1c20e; tw_im[0943] = 18'h0f41f; 
	tw_re[0944] = 18'h1c38b; tw_im[0944] = 18'h0f15b; tw_re[0945] = 18'h1c504; tw_im[0945] = 18'h0ee94; tw_re[0946] = 18'h1c678; tw_im[0946] = 18'h0ebcb; tw_re[0947] = 18'h1c7e9; tw_im[0947] = 18'h0e900; 
	tw_re[0948] = 18'h1c954; tw_im[0948] = 18'h0e633; tw_re[0949] = 18'h1cabc; tw_im[0949] = 18'h0e364; tw_re[0950] = 18'h1cc1f; tw_im[0950] = 18'h0e092; tw_re[0951] = 18'h1cd7d; tw_im[0951] = 18'h0ddbe; 
	tw_re[0952] = 18'h1ced7; tw_im[0952] = 18'h0dae8; tw_re[0953] = 18'h1d02d; tw_im[0953] = 18'h0d810; tw_re[0954] = 18'h1d17e; tw_im[0954] = 18'h0d536; tw_re[0955] = 18'h1d2cb; tw_im[0955] = 18'h0d25a; 
	tw_re[0956] = 18'h1d413; tw_im[0956] = 18'h0cf7c; tw_re[0957] = 18'h1d557; tw_im[0957] = 18'h0cc9b; tw_re[0958] = 18'h1d696; tw_im[0958] = 18'h0c9b9; tw_re[0959] = 18'h1d7d0; tw_im[0959] = 18'h0c6d5; 
	tw_re[0960] = 18'h1d906; tw_im[0960] = 18'h0c3ef; tw_re[0961] = 18'h1da38; tw_im[0961] = 18'h0c107; tw_re[0962] = 18'h1db65; tw_im[0962] = 18'h0be1d; tw_re[0963] = 18'h1dc8d; tw_im[0963] = 18'h0bb31; 
	tw_re[0964] = 18'h1ddb1; tw_im[0964] = 18'h0b844; tw_re[0965] = 18'h1ded0; tw_im[0965] = 18'h0b555; tw_re[0966] = 18'h1dfeb; tw_im[0966] = 18'h0b264; tw_re[0967] = 18'h1e101; tw_im[0967] = 18'h0af71; 
	tw_re[0968] = 18'h1e212; tw_im[0968] = 18'h0ac7d; tw_re[0969] = 18'h1e31e; tw_im[0969] = 18'h0a987; tw_re[0970] = 18'h1e426; tw_im[0970] = 18'h0a68f; tw_re[0971] = 18'h1e52a; tw_im[0971] = 18'h0a396; 
	tw_re[0972] = 18'h1e628; tw_im[0972] = 18'h0a09b; tw_re[0973] = 18'h1e722; tw_im[0973] = 18'h09d9e; tw_re[0974] = 18'h1e817; tw_im[0974] = 18'h09aa0; tw_re[0975] = 18'h1e908; tw_im[0975] = 18'h097a1; 
	tw_re[0976] = 18'h1e9f4; tw_im[0976] = 18'h094a0; tw_re[0977] = 18'h1eadb; tw_im[0977] = 18'h0919e; tw_re[0978] = 18'h1ebbd; tw_im[0978] = 18'h08e9a; tw_re[0979] = 18'h1ec9b; tw_im[0979] = 18'h08b95; 
	tw_re[0980] = 18'h1ed74; tw_im[0980] = 18'h0888e; tw_re[0981] = 18'h1ee48; tw_im[0981] = 18'h08587; tw_re[0982] = 18'h1ef17; tw_im[0982] = 18'h0827e; tw_re[0983] = 18'h1efe2; tw_im[0983] = 18'h07f73; 
	tw_re[0984] = 18'h1f0a8; tw_im[0984] = 18'h07c68; tw_re[0985] = 18'h1f169; tw_im[0985] = 18'h0795b; tw_re[0986] = 18'h1f225; tw_im[0986] = 18'h0764d; tw_re[0987] = 18'h1f2dc; tw_im[0987] = 18'h0733e; 
	tw_re[0988] = 18'h1f38f; tw_im[0988] = 18'h0702e; tw_re[0989] = 18'h1f43d; tw_im[0989] = 18'h06d1d; tw_re[0990] = 18'h1f4e6; tw_im[0990] = 18'h06a0a; tw_re[0991] = 18'h1f58a; tw_im[0991] = 18'h066f7; 
	tw_re[0992] = 18'h1f629; tw_im[0992] = 18'h063e3; tw_re[0993] = 18'h1f6c4; tw_im[0993] = 18'h060cd; tw_re[0994] = 18'h1f759; tw_im[0994] = 18'h05db7; tw_re[0995] = 18'h1f7ea; tw_im[0995] = 18'h05aa0; 
	tw_re[0996] = 18'h1f876; tw_im[0996] = 18'h05788; tw_re[0997] = 18'h1f8fd; tw_im[0997] = 18'h0546f; tw_re[0998] = 18'h1f97f; tw_im[0998] = 18'h05156; tw_re[0999] = 18'h1f9fd; tw_im[0999] = 18'h04e3b; 
	tw_re[1000] = 18'h1fa75; tw_im[1000] = 18'h04b20; tw_re[1001] = 18'h1fae9; tw_im[1001] = 18'h04804; tw_re[1002] = 18'h1fb57; tw_im[1002] = 18'h044e8; tw_re[1003] = 18'h1fbc1; tw_im[1003] = 18'h041ca; 
	tw_re[1004] = 18'h1fc26; tw_im[1004] = 18'h03eac; tw_re[1005] = 18'h1fc86; tw_im[1005] = 18'h03b8e; tw_re[1006] = 18'h1fce1; tw_im[1006] = 18'h0386f; tw_re[1007] = 18'h1fd37; tw_im[1007] = 18'h0354f; 
	tw_re[1008] = 18'h1fd89; tw_im[1008] = 18'h0322f; tw_re[1009] = 18'h1fdd5; tw_im[1009] = 18'h02f0e; tw_re[1010] = 18'h1fe1c; tw_im[1010] = 18'h02bed; tw_re[1011] = 18'h1fe5f; tw_im[1011] = 18'h028cc; 
	tw_re[1012] = 18'h1fe9d; tw_im[1012] = 18'h025aa; tw_re[1013] = 18'h1fed5; tw_im[1013] = 18'h02288; tw_re[1014] = 18'h1ff09; tw_im[1014] = 18'h01f65; tw_re[1015] = 18'h1ff38; tw_im[1015] = 18'h01c42; 
	tw_re[1016] = 18'h1ff62; tw_im[1016] = 18'h0191f; tw_re[1017] = 18'h1ff87; tw_im[1017] = 18'h015fc; tw_re[1018] = 18'h1ffa7; tw_im[1018] = 18'h012d8; tw_re[1019] = 18'h1ffc2; tw_im[1019] = 18'h00fb4; 
	tw_re[1020] = 18'h1ffd8; tw_im[1020] = 18'h00c90; tw_re[1021] = 18'h1ffea; tw_im[1021] = 18'h0096c; tw_re[1022] = 18'h1fff6; tw_im[1022] = 18'h00648; tw_re[1023] = 18'h1fffd; tw_im[1023] = 18'h00324; 

	RANKS=3;
	scale_sch =10'b1111111111;
	for (i=0; i<=2048; i=i+1)
		begin
		dpm_in_re [i] = 0; dpm_in_im [i] = 0;	
		dpm_PE0_re[i] = 0; dpm_PE0_im[i] = 0;	
		dpm_out_re[i] = 0; dpm_out_im[i] = 0;	
		if (i<1024) 
			begin
			dpm_PE1_re[i] = 0;
			dpm_PE1_im[i] = 0;	
			end
		end
	init(1);
end
endtask

task init;		// new point-size (N_FFT) is latched in
input initialize;
begin
	N = (1 << (RANKS<<1));			// set up flow control integers
	RN=	N >> 2;
	frame=-1;
	out_frame =0;
	PE0_BS = 0;
	for (i=1; i<48; i=i+1)
		begin
		rank[i]=0;
		n[i] =N-i;
		rn[i]=RN-i;
		end
	rank[0]=0;
	n[0] =N-1;
	rn[0]=RN-1;
	started[0] = 0; started[1] = 0; started[2] = 0; started0_d =0;
	inverse <=0;
	fwd_inv0 =0;			// set up fft/ifft control variables
	fwd_inv1 =0;
	fwd_inv2 =0;

	ready	<=1;		// set up outputs
	DONE	<=0;
	EDONE	<=0;
	DONE_i	<=0;
	EDONE_i	<=0;
	starts 	<=0;
	BUSY	<=0;
	OVFLO 	<=0;
	XK_INDEX<=0;
	XK_INDEX1<=0;
	XN_INDEX<=0;
	
	MRD_locked0 = 0;
	MRD_locked1 = 0;
	MRD_locked2 = 0;
	MRD_locked3 = 0;

	if (initialize)
		begin
		XK_RE <= 0;
		XK_IM <= 0;
		end
		
	address_mask = RN - 1;
end
endtask

/////////////////////////////// FUNCTIONAL DESCRIPTION /////////////////////////////// 
initial reset;

always @ (CLK)
	if ( (CLK) & (CE))
		begin
			if (RESET) init(1'b1);
			else 
				if (N_FFT_WE)
					begin
					RANKS=N_FFT+3;
					init(1'b0);
					end
				else
					begin				

					// if ready or DONE, and start is asserted, start a new frame
					// otherwise increment system counters, 
		
					for (i=47; i>0; i=i-1) // Shift system counter history
						begin
						rank[i] =rank[i-1];
						n[i]	=n[i-1];
						rn[i]	=rn[i-1];
						end

					if ((ready || DONE_i) && (START || starts || started[0] || started[1]))
						begin
						ready	= 0;
						rank[0] = 0;
						rn[0]   = 0;
						n[0]    = 0;
						frame	=frame+1;
						started[2]	<= started[1];
						started[1]	<= started[0];
						started[0]	<= starts | START;
						starts		= 0;
						end
					else
						if ( (!(ready || DONE_i)) && (rn[0]== ((N==1024) ? 0 : 32) + ((N>>2) -1))) 
							begin
							rank[0]	= rank[0] + 1;
							rn[0]	= 0;
							n[0] 	= n[0] + 1;
							end
						else
							begin
								starts = starts || START;
								if (! (ready || DONE))
								begin
									rn[0]	= rn[0] + 1;
									n[0] 	= n[0] + 1;
								end
							end
		
					EDONE 	<= (n[0]==N-2) & started[2];
					DONE  	<= (n[0]==N-1) & started[2] & (n[1]==N-2);
					EDONE_i <= (n[0]==N-2);
					DONE_i 	<= (n[0]==N-1) & (n[1]==N-2);
					ready	= (n[0]==N-1) & (n[1]==N-1);
					
					BUSY	<= !(ready) & (START | starts || started[0] || started[1] || started[2]);	
					in_frame<= frame;
					iBS		<= 1 - (in_frame & 1);

					
					if (EDONE) OVFLO 		<= OVFLOW_PE0_d | OVFLOW_PE1;
						
					// load new frame: Latch in operands, if START was asserted and frame is not ready yet	
					
					if (starts || started[0] || started[1] || started[2])
						XN_INDEX <= n[0];
						
					started0_d <= started[0];
					if (started0_d) 
						begin 
						dpm_in_re[{iBS, n[2] }] = XN_RE;	  	// write real part to the input buffer
						dpm_in_im[{iBS, n[2] }] = im_i_inv;  	// write imag part to the input buffer
						end

					// Latch in the new scaling schedule, if SCALE_SCH_WE is asserted,
					if (SCALE_SCH_WE) scale_sch = SCALE_SCH;
					
					if (n[1] == 0) 
						begin
						fwd_inv1 <= fwd_inv0;    
						fwd_inv2 <= fwd_inv1;    
						fwd_inv0 <= inverse; 
						end						

					// Latch in the FWD_INV signal, if FWD_INV_WE is asserted. FWD_INV = 1 => forward FFT
					if (FWD_INV_WE) inverse = !FWD_INV;			
						
					if (n[11] == 0)
						begin
						scale_sch0 <= scale_sch;
						scale_sch1 <= scale_sch0;
						scale_sch2 <= scale_sch1;
						end

				
		// PE0 calculations: 
					if (rn[`PE0_PIPE_LATENCY]==0)
						begin
						PE0_BS = (n[`PE0_PIPE_LATENCY]==0) ? 0 : !PE0_BS;
						case (rank[`PE0_PIPE_LATENCY])
							0:	sc_sch0=scale_sch1[1 : 0];
							1:	sc_sch0=scale_sch1[3 : 2];
							2:	sc_sch0=scale_sch1[5 : 4];
							3:	sc_sch0=scale_sch1[7 : 6];
							4:	sc_sch0=scale_sch1[9 : 8];
						endcase
						end
		
					if (rn[`PE0_PIPE_LATENCY]<RN)
						begin						
						i=rank[`PE0_PIPE_LATENCY];
						d= 1 << ((RANKS-i-1) << 1);
					// Set up input and output addresses						
						k = rn[`PE0_PIPE_LATENCY];
						PE0_rd_addr[0] = (( k % d) + (k / d) * (d << 2)) ;
						PE0_rd_addr[1] = PE0_rd_addr[0] + d;
						PE0_rd_addr[2] = PE0_rd_addr[1] + d;
						PE0_rd_addr[3] = PE0_rd_addr[2] + d;
					
					// Set up the twiddle addresses
						tw_step= 256 / d ;
						tw=( (k % d) * tw_step) % 1024;
				
						tw1 = tw;
						tw2 = tw * 2;
						tw3 = tw * 3;

						tw=tw+tw_step;
					
					// Fetch input opearands
						if (i == 0)
							begin
							bank_sel = (frame & 1);
							data_i0_PE0[2*`Bi-1:`Bi]	= dpm_in_re[{bank_sel, PE0_rd_addr[0]}];
							data_i1_PE0[2*`Bi-1:`Bi]	= dpm_in_re[{bank_sel, PE0_rd_addr[1]}];
							data_i2_PE0[2*`Bi-1:`Bi]	= dpm_in_re[{bank_sel, PE0_rd_addr[2]}];
							data_i3_PE0[2*`Bi-1:`Bi]	= dpm_in_re[{bank_sel, PE0_rd_addr[3]}];
							data_i0_PE0[`Bi-1:0]		= dpm_in_im[{bank_sel, PE0_rd_addr[0]}];
							data_i1_PE0[`Bi-1:0]		= dpm_in_im[{bank_sel, PE0_rd_addr[1]}];
							data_i2_PE0[`Bi-1:0]		= dpm_in_im[{bank_sel, PE0_rd_addr[2]}];
							data_i3_PE0[`Bi-1:0]		= dpm_in_im[{bank_sel, PE0_rd_addr[3]}];
							end
						else
							begin
							data_i0_PE0[2*`Bi-1:`Bi]	=  dpm_PE0_re[{PE0_BS, PE0_rd_addr[0]}];
							data_i1_PE0[2*`Bi-1:`Bi]	=  dpm_PE0_re[{PE0_BS, PE0_rd_addr[1]}];
							data_i2_PE0[2*`Bi-1:`Bi]	=  dpm_PE0_re[{PE0_BS, PE0_rd_addr[2]}];
							data_i3_PE0[2*`Bi-1:`Bi]	=  dpm_PE0_re[{PE0_BS, PE0_rd_addr[3]}];
							data_i0_PE0[`Bi-1:0] 	=  dpm_PE0_im[{PE0_BS, PE0_rd_addr[0]}];
							data_i1_PE0[`Bi-1:0]		=  dpm_PE0_im[{PE0_BS, PE0_rd_addr[1]}];
							data_i2_PE0[`Bi-1:0] 	=  dpm_PE0_im[{PE0_BS, PE0_rd_addr[2]}];
							data_i3_PE0[`Bi-1:0]		=  dpm_PE0_im[{PE0_BS, PE0_rd_addr[3]}];
							end
						end

					// Write output results
					if (rn[`PE0_PIPE_LATENCY+1]<RN)
						begin						
						if (rank[`PE0_PIPE_LATENCY+1] < RANKS-2)
							begin 
							dpm_PE0_im[{!PE0_BSd, PE0_wr_addr[0]}] <= data_o0_PE0[`Bi-1:0];
							dpm_PE0_im[{!PE0_BSd, PE0_wr_addr[1]}] <= data_o1_PE0[`Bi-1:0];
							dpm_PE0_im[{!PE0_BSd, PE0_wr_addr[2]}] <= data_o2_PE0[`Bi-1:0];
							dpm_PE0_im[{!PE0_BSd, PE0_wr_addr[3]}] <= data_o3_PE0[`Bi-1:0];
							dpm_PE0_re[{!PE0_BSd, PE0_wr_addr[0]}] <= data_o0_PE0[2*`Bi-1:`Bi];
							dpm_PE0_re[{!PE0_BSd, PE0_wr_addr[1]}] <= data_o1_PE0[2*`Bi-1:`Bi];
							dpm_PE0_re[{!PE0_BSd, PE0_wr_addr[2]}] <= data_o2_PE0[2*`Bi-1:`Bi];
							dpm_PE0_re[{!PE0_BSd, PE0_wr_addr[3]}] <= data_o3_PE0[2*`Bi-1:`Bi];
							end
						else
							begin
							dpm_PE1_im[PE0_wr_addr[0]] <= data_o0_PE0[`Bi-1:0];
							dpm_PE1_im[PE0_wr_addr[1]] <= data_o1_PE0[`Bi-1:0];
							dpm_PE1_im[PE0_wr_addr[2]] <= data_o2_PE0[`Bi-1:0];
							dpm_PE1_im[PE0_wr_addr[3]] <= data_o3_PE0[`Bi-1:0];
							dpm_PE1_re[PE0_wr_addr[0]] <= data_o0_PE0[2*`Bi-1:`Bi];
							dpm_PE1_re[PE0_wr_addr[1]] <= data_o1_PE0[2*`Bi-1:`Bi];
							dpm_PE1_re[PE0_wr_addr[2]] <= data_o2_PE0[2*`Bi-1:`Bi];
							dpm_PE1_re[PE0_wr_addr[3]] <= data_o3_PE0[2*`Bi-1:`Bi];
							end
					// Keep track of overflows
						if (n[`PE0_PIPE_LATENCY+1]==0)
							begin
							OVFLOW_PE0_d   = OVFLOW_PE0;
							OVFLOW_PE0     = OVFLO0;
							end
						else
							OVFLOW_PE0     = OVFLOW_PE0 | OVFLO0;
						end
					end
					
		// PE1 calculations: 						
					if ((n[`PE1_PIPE_LATENCY]>31) && (n[`PE1_PIPE_LATENCY]<32+RN))
						begin
						
						case (RANKS)
							3:	sc_sch1=scale_sch2[5 : 4];
							4:	sc_sch1=scale_sch2[7 : 6];
							5:	sc_sch1=scale_sch2[9 : 8];
							6:	sc_sch1=scale_sch2[11:10];
						endcase
							
						k = (rn[`PE1_PIPE_LATENCY]-32) << 2;	
						PE1_BS = frame & 1;
						out_frame 	= frame; 
					// Set up input and output addresses						
						PE1_rd_addr[0] = k;
						PE1_rd_addr[1] = k + 1;
						PE1_rd_addr[2] = k + 2;
						PE1_rd_addr[3] = k + 3;
					
					// Fetch input opearands
						data_i0_PE1[2*`Bi-1:`Bi]	=  dpm_PE1_re[PE1_rd_addr[0]];
						data_i1_PE1[2*`Bi-1:`Bi]	=  dpm_PE1_re[PE1_rd_addr[1]];
						data_i2_PE1[2*`Bi-1:`Bi]	=  dpm_PE1_re[PE1_rd_addr[2]];
						data_i3_PE1[2*`Bi-1:`Bi]	=  dpm_PE1_re[PE1_rd_addr[3]];
						data_i0_PE1[`Bi-1:0] 	=  dpm_PE1_im[PE1_rd_addr[0]];
						data_i1_PE1[`Bi-1:0]		=  dpm_PE1_im[PE1_rd_addr[1]];
						data_i2_PE1[`Bi-1:0] 	=  dpm_PE1_im[PE1_rd_addr[2]];
						data_i3_PE1[`Bi-1:0]		=  dpm_PE1_im[PE1_rd_addr[3]];
						end

					// Write output results
					if ((n[`PE1_PIPE_LATENCY]>32) && (n[`PE1_PIPE_LATENCY]<33+RN))
						begin						
						dpm_out_im[{PE1_BS, PE1_wr_addr[0]}] = data_o0_PE1_inv;
						dpm_out_im[{PE1_BS, PE1_wr_addr[1]}] = data_o1_PE1_inv;
						dpm_out_im[{PE1_BS, PE1_wr_addr[2]}] = data_o2_PE1_inv;
						dpm_out_im[{PE1_BS, PE1_wr_addr[3]}] = data_o3_PE1_inv;
						dpm_out_re[{PE1_BS, PE1_wr_addr[0]}] = data_o0_PE1[2*`Bi-1:`Bi];
						dpm_out_re[{PE1_BS, PE1_wr_addr[1]}] = data_o1_PE1[2*`Bi-1:`Bi];
						dpm_out_re[{PE1_BS, PE1_wr_addr[2]}] = data_o2_PE1[2*`Bi-1:`Bi];
						dpm_out_re[{PE1_BS, PE1_wr_addr[3]}] = data_o3_PE1[2*`Bi-1:`Bi];

					// Keep track of overflows
						OVFLOW_PE1 = OVFLO1 | ( (n[`PE1_PIPE_LATENCY]!=33) & OVFLOW_PE1);
						end
					
					for (i=0; i<4; i=i+1) 
						begin
						PE0_wr_addr[i] <= PE0_rd_addr[i];
						PE1_wr_addr[i] <= PE1_rd_addr[i];
						end
					PE0_BSd <= PE0_BS;
						
		// Write output, if MRD was asserted
					MRD_locked0 <= (MRD_locked0 & (XK_INDEX!=N-4)) | MRD;
					MRD_locked1 <= MRD_locked0;
					MRD_locked2 <= MRD_locked1;
					MRD_locked3 <= MRD_locked2;
					
					if (MRD_locked2) XK_INDEX1 <= XK_INDEX1+1;
					if ((MRD_locked2) ? (XK_INDEX1==N-1) : (MRD_locked1))
						begin
						oBS 		<= out_frame & 1;
						XK_INDEX1    <= 0;
						end
					XK_INDEX <= XK_INDEX1;
					// Latch in operands, if MWR is/was active, and frame is not ready yet	
					if (MRD_locked2) 
						begin 
						get_rev_addr(rev_addr);
						XK_RE <= dpm_out_re[{oBS, rev_addr}];	// write real part from the output buffer     
						XK_IM <= dpm_out_im[{oBS, rev_addr}];	// write imag part from the output buffer
						end
					RDY <= MRD_locked2;
		end

endmodule 
`timescale 1 ns / 100ps

module PE1 ( 	DRFLY_I0_RE, DRFLY_I0_IM,
				DRFLY_I1_RE, DRFLY_I1_IM,
				DRFLY_I2_RE, DRFLY_I2_IM,
				DRFLY_I3_RE, DRFLY_I3_IM,
				SCALE, OVFLO,
				RES_O0_RE, RES_O0_IM,
				RES_O1_RE, RES_O1_IM,
				RES_O2_RE, RES_O2_IM,
				RES_O3_RE, RES_O3_IM);
	
parameter Bdrfly = 16;	// wordlength of the dragonfly 
parameter Bo	 = 16;	// Output width

input [Bdrfly-1:0] DRFLY_I0_RE;				// <Bdrfly> bit wide port connections
input [Bdrfly-1:0] DRFLY_I0_IM;				// to the x0 input of the dragonfly
input [Bdrfly-1:0] DRFLY_I1_RE;				// <Bdrfly> bit wide port connections
input [Bdrfly-1:0] DRFLY_I1_IM;				// to the x1 input of the dragonfly
input [Bdrfly-1:0] DRFLY_I2_RE;				// <Bdrfly> bit wide port connections
input [Bdrfly-1:0] DRFLY_I2_IM;				// to the x2 input of the dragonfly
input [Bdrfly-1:0] DRFLY_I3_RE;				// <Bdrfly> bit wide port connections
input [Bdrfly-1:0] DRFLY_I3_IM;				// to the x3 input of the dragonfly

input [1:0] SCALE;

output [Bo-1:0] RES_O0_RE; 
output [Bo-1:0] RES_O0_IM; 
output [Bo-1:0] RES_O1_RE; 
output [Bo-1:0] RES_O1_IM; 
output [Bo-1:0] RES_O2_RE; 
output [Bo-1:0] RES_O2_IM; 
output [Bo-1:0] RES_O3_RE; 
output [Bo-1:0] RES_O3_IM; 
output OVFLO; 

wire [Bdrfly+1:0] drfly_o0_re; // outputs of the dragonfly
wire [Bdrfly+1:0] drfly_o0_im;
wire [Bdrfly+1:0] drfly_o1_re;				
wire [Bdrfly+1:0] drfly_o1_im;
wire [Bdrfly+1:0] drfly_o2_re;				
wire [Bdrfly+1:0] drfly_o2_im;
wire [Bdrfly+1:0] drfly_o3_re;				
wire [Bdrfly+1:0] drfly_o3_im;

parameter MSB_scale = Bdrfly+3; // MSB Position after scaling 				  (=38)

wire [MSB_scale:0] scaled0_re;
wire [MSB_scale:0] scaled0_im;
wire [MSB_scale:0] scaled1_re;
wire [MSB_scale:0] scaled1_im;
wire [MSB_scale:0] scaled2_re;
wire [MSB_scale:0] scaled2_im;
wire [MSB_scale:0] scaled3_re;
wire [MSB_scale:0] scaled3_im;

function ats3; // All The Same (returns 1 only when bits of the operands are equal)
input [2:0] x;
begin
	ats3 = (&x[2:0]) | (!(|x[2:0]));
end
endfunction

// Hook up the dragonfly
dragonfly DFLY(	DRFLY_I0_RE, DRFLY_I0_IM,	// connections of the 
				DRFLY_I1_RE, DRFLY_I1_IM, 	// 4 complex inputs and
				DRFLY_I2_RE, DRFLY_I2_IM, 
				DRFLY_I3_RE, DRFLY_I3_IM, 
				drfly_o0_re, drfly_o0_im,	// 4 complex outputs
				drfly_o1_re, drfly_o1_im, 
				drfly_o2_re, drfly_o2_im, 
				drfly_o3_re, drfly_o3_im);
defparam DFLY.WIDTH = Bdrfly;		  	// parameters to pass

// Hook up the scaler mux in the real datapath of output0 
arithmetic_shift SHIFT_0re( { drfly_o0_re, 2'b0 }, SCALE, scaled0_re ); 
defparam SHIFT_0re.WIDTH =  Bdrfly+4;				// parameters to pass

// Hook up the scaler mux in the imaginary datapath of output0 
arithmetic_shift SHIFT_0im( { drfly_o0_im, 2'b0 }, SCALE, scaled0_im ); 
defparam SHIFT_0im.WIDTH = Bdrfly+4;				// parameters to pass

// Hook up the scaler mux in the real datapath of output1 
arithmetic_shift SHIFT_1re( { drfly_o1_re, 2'b0 }, SCALE, scaled1_re ); 
defparam SHIFT_1re.WIDTH =  Bdrfly+4;				// parameters to pass

// Hook up the scaler mux in the imaginary datapath of output1 
arithmetic_shift SHIFT_1im( { drfly_o1_im, 2'b0 }, SCALE, scaled1_im ); 
defparam SHIFT_1im.WIDTH = Bdrfly+4;				// parameters to pass

// Hook up the scaler mux in the real datapath of output2 
arithmetic_shift SHIFT_2re( { drfly_o2_re, 2'b0 }, SCALE, scaled2_re ); 
defparam SHIFT_2re.WIDTH =  Bdrfly+4;				// parameters to pass

// Hook up the scaler mux in the imaginary datapath of output2 
arithmetic_shift SHIFT_2im( { drfly_o2_im, 2'b0 }, SCALE, scaled2_im ); 
defparam SHIFT_2im.WIDTH = Bdrfly+4;				// parameters to pass

// Hook up the scaler mux in the real datapath of output3 
arithmetic_shift SHIFT_3re( { drfly_o3_re, 2'b0 }, SCALE, scaled3_re ); 
defparam SHIFT_3re.WIDTH =  Bdrfly+4;				// parameters to pass

// Hook up the scaler mux in the imaginary datapath of output3 
arithmetic_shift SHIFT_3im( { drfly_o3_im, 2'b0 }, SCALE, scaled3_im ); 
defparam SHIFT_3im.WIDTH = Bdrfly+4;				// parameters to pass

// Hook up the rounder in the real datapath of output0 after the corresponding scaler
unbias_round RND0_re(scaled0_re[Bdrfly+1:0], RES_O0_RE);
defparam RND0_re.I_WIDTH = Bdrfly+2;			// Number of input bits
defparam RND0_re.O_WIDTH = Bo;					// Number of output bits

// Hook up the rounder in the imaginary datapath of output0 after the scaler
unbias_round RND0_im(scaled0_im[Bdrfly+1:0], RES_O0_IM);
defparam RND0_im.I_WIDTH = Bdrfly+2;			// Number of input bits
defparam RND0_im.O_WIDTH = Bo;					// Number of output bits

// Hook up the rounder in the real datapath of output1 after the corresponding scaler
unbias_round RND1_re(scaled1_re[Bdrfly+1:0], RES_O1_RE);
defparam RND1_re.I_WIDTH = Bdrfly+2;			// Number of input bits
defparam RND1_re.O_WIDTH = Bo;					// Number of output bits

// Hook up the rounder in the imaginary datapath of output1 after the scaler
unbias_round RND1_im(scaled1_im[Bdrfly+1:0], RES_O1_IM);
defparam RND1_im.I_WIDTH = Bdrfly+2;			// Number of input bits
defparam RND1_im.O_WIDTH = Bo;					// Number of output bits

// Hook up the rounder in the real datapath of output2 after the corresponding scaler
unbias_round RND2_re(scaled2_re[Bdrfly+1:0], RES_O2_RE);
defparam RND2_re.I_WIDTH = Bdrfly+2;			// Number of input bits
defparam RND2_re.O_WIDTH = Bo;					// Number of output bits

// Hook up the rounder in the imaginary datapath of output2 after the scaler
unbias_round RND2_im(scaled2_im[Bdrfly+1:0], RES_O2_IM);
defparam RND2_im.I_WIDTH = Bdrfly+2;			// Number of input bits
defparam RND2_im.O_WIDTH = Bo;					// Number of output bits

// Hook up the rounder in the real datapath of output3 after the corresponding scaler
unbias_round RND3_re(scaled3_re[Bdrfly+1:0], RES_O3_RE);
defparam RND3_re.I_WIDTH = Bdrfly+2;			// Number of input bits
defparam RND3_re.O_WIDTH = Bo;					// Number of output bits

// Hook up the rounder in the imaginary datapath of output3 after the scaler
unbias_round RND3_im(scaled3_im[Bdrfly+1:0], RES_O3_IM);
defparam RND3_im.I_WIDTH = Bdrfly+2;			// Number of input bits
defparam RND3_im.O_WIDTH = Bo;					// Number of output bits



assign	OVFLO  =	!ats3(scaled0_re[MSB_scale:MSB_scale-2]) |
					!ats3(scaled0_im[MSB_scale:MSB_scale-2]) |
					!ats3(scaled1_re[MSB_scale:MSB_scale-2]) |
					!ats3(scaled1_im[MSB_scale:MSB_scale-2]) |
					!ats3(scaled2_re[MSB_scale:MSB_scale-2]) |
					!ats3(scaled2_im[MSB_scale:MSB_scale-2]) |
					!ats3(scaled3_re[MSB_scale:MSB_scale-2]) |
					!ats3(scaled3_im[MSB_scale:MSB_scale-2]);
endmodule 
// PE0 module of the fft core

`timescale 1 ns / 100ps

module PE0 ( 	DRFLY_I0_RE, DRFLY_I0_IM,
				DRFLY_I1_RE, DRFLY_I1_IM,
				DRFLY_I2_RE, DRFLY_I2_IM,
				DRFLY_I3_RE, DRFLY_I3_IM,
				TW1_RE, TW1_IM, TW2_RE, TW2_IM, TW3_RE, TW3_IM,
				SCALE, OVFLO,
				RES_O0_RE, RES_O0_IM,
				RES_O1_RE, RES_O1_IM,
				RES_O2_RE, RES_O2_IM,
				RES_O3_RE, RES_O3_IM);

parameter Bdrfly = 16;	// wordlength of the dragonfly 
parameter Btw	 = 18;	// Width of twiddle factors 
parameter Bo	 = 16;	// Output width

input [Bdrfly-1:0] DRFLY_I0_RE;				// <Bdrfly> bit wide port connections
input [Bdrfly-1:0] DRFLY_I0_IM;				// to the x0 input of the dragonfly
input [Bdrfly-1:0] DRFLY_I1_RE;				// <Bdrfly> bit wide port connections
input [Bdrfly-1:0] DRFLY_I1_IM;				// to the x1 input of the dragonfly
input [Bdrfly-1:0] DRFLY_I2_RE;				// <Bdrfly> bit wide port connections
input [Bdrfly-1:0] DRFLY_I2_IM;				// to the x2 input of the dragonfly
input [Bdrfly-1:0] DRFLY_I3_RE;				// <Bdrfly> bit wide port connections
input [Bdrfly-1:0] DRFLY_I3_IM;				// to the x3 input of the dragonfly

input [Btw-1:0] TW1_RE;
input [Btw-1:0] TW1_IM;
input [Btw-1:0] TW2_RE;
input [Btw-1:0] TW2_IM;
input [Btw-1:0] TW3_RE;
input [Btw-1:0] TW3_IM;
input [1:0] SCALE;

output [Bo-1:0] RES_O0_RE; 
output [Bo-1:0] RES_O0_IM; 
output [Bo-1:0] RES_O1_RE; 
output [Bo-1:0] RES_O1_IM; 
output [Bo-1:0] RES_O2_RE; 
output [Bo-1:0] RES_O2_IM; 
output [Bo-1:0] RES_O3_RE; 
output [Bo-1:0] RES_O3_IM; 
output OVFLO;

wire [Bdrfly+1:0] drfly_o0_re;		// outputs of the dragonfly
wire [Bdrfly+1:0] drfly_o0_im;
wire [Bdrfly+1:0] drfly_o1_re;				
wire [Bdrfly+1:0] drfly_o1_im;
wire [Bdrfly+1:0] drfly_o2_re;				
wire [Bdrfly+1:0] drfly_o2_im;
wire [Bdrfly+1:0] drfly_o3_re;				
wire [Bdrfly+1:0] drfly_o3_im;

parameter MSB_mltpy = Bdrfly+Btw+1; // MSB Position after complex multiplication  (=35)
parameter MSB_scale = Bdrfly+Btw+4; // MSB Position after scaling 				  (=38)

wire [MSB_mltpy:0] mlplied1_re;
wire [MSB_mltpy:0] mlplied1_im;		// outputs of the multipliers
wire [MSB_mltpy:0] mlplied2_re;
wire [MSB_mltpy:0] mlplied2_im;
wire [MSB_mltpy:0] mlplied3_re;
wire [MSB_mltpy:0] mlplied3_im;

wire [Bdrfly+5:0] scaled0_re;
wire [Bdrfly+5:0] scaled0_im;
wire [MSB_scale:0] scaled1_re;
wire [MSB_scale:0] scaled1_im;
wire [MSB_scale:0] scaled2_re;
wire [MSB_scale:0] scaled2_im;
wire [MSB_scale:0] scaled3_re;
wire [MSB_scale:0] scaled3_im;

function ats3; // All The Same (returns 1 only when bits of the operands are equal)
input [2:0] x;
begin
	ats3 = (&x[2:0]) | (!(|x[2:0]));
end
endfunction

// Hook up the dragonfly
dragonfly DFLY(	DRFLY_I0_RE, DRFLY_I0_IM,	// connections of the 
				DRFLY_I1_RE, DRFLY_I1_IM, 	// 4 complex inputs and
				DRFLY_I2_RE, DRFLY_I2_IM, 
				DRFLY_I3_RE, DRFLY_I3_IM, 
				drfly_o0_re, drfly_o0_im,	// 4 complex outputs
				drfly_o1_re, drfly_o1_im, 
				drfly_o2_re, drfly_o2_im, 
				drfly_o3_re, drfly_o3_im);
defparam DFLY.WIDTH = Bdrfly;		  	// parameters to pass

// Hook up the 1st complex multiplier to output1 of the dragonfly
cmplx_mult Mul1(drfly_o1_re, drfly_o1_im,			// operand a
				TW1_RE, TW1_IM, 					// operand b
				mlplied1_re, mlplied1_im);			// results
defparam Mul1.WIDTH_a   = (Bdrfly+2);			// parameters to pass
defparam Mul1.WIDTH_b   = Btw;


// Hook up the 2nd complex multiplier to output1 of the dragonfly
cmplx_mult Mul2(drfly_o2_re, drfly_o2_im,			// operand a
				TW2_RE, TW2_IM,			 			// operand b
				mlplied2_re, mlplied2_im);			// results
defparam Mul2.WIDTH_a   = Bdrfly+2;				// parameters to pass
defparam Mul2.WIDTH_b   = Btw;

// Hook up the 3rd complex multiplier to output1 of the dragonfly
cmplx_mult Mul3(drfly_o3_re, drfly_o3_im,			// operand a
				TW3_RE, TW3_IM,						// operand b
				mlplied3_re, mlplied3_im);			// results
defparam Mul3.WIDTH_a   = Bdrfly+2;				// parameters to pass
defparam Mul3.WIDTH_b   = Btw;

// Hook up the scaler mux in the real datapath of output0 after the corresponding multiplier
arithmetic_shift SHIFT_0re( { drfly_o0_re[Bdrfly+1:Bdrfly+1], drfly_o0_re, 3'b0 }, SCALE, scaled0_re ); 
defparam SHIFT_0re.WIDTH =  Bdrfly+6;				// parameters to pass

// Hook up the scaler mux in the imaginary datapath of output0 after the corresponding multiplier
arithmetic_shift SHIFT_0im( { drfly_o0_im[Bdrfly+1:Bdrfly+1], drfly_o0_im, 3'b0 }, SCALE, scaled0_im ); 
defparam SHIFT_0im.WIDTH = Bdrfly+6;				// parameters to pass

// Hook up the scaler mux in the real datapath of output1 after the corresponding multiplier
arithmetic_shift SHIFT_1re( { mlplied1_re, 3'b0 }, SCALE, scaled1_re ); 
defparam SHIFT_1re.WIDTH = MSB_scale+1;				// parameters to pass

// Hook up the scaler mux in the imaginary datapath of output1 after the corresponding multiplier
arithmetic_shift SHIFT_1im( { mlplied1_im, 3'b0 }, SCALE, scaled1_im ); 
defparam SHIFT_1im.WIDTH = MSB_scale+1;				// parameters to pass

// Hook up the scaler mux in the real datapath of output2 after the corresponding multiplier
arithmetic_shift SHIFT_2re( { mlplied2_re, 3'b0 }, SCALE, scaled2_re ); 
defparam SHIFT_2re.WIDTH = MSB_scale+1;				// parameters to pass

// Hook up the scaler mux in the imaginary datapath of output2 after the corresponding multiplier
arithmetic_shift SHIFT_2im( { mlplied2_im, 3'b0 }, SCALE, scaled2_im ); 
defparam SHIFT_2im.WIDTH = MSB_scale+1;				// parameters to pass

// Hook up the scaler mux in the real datapath of output3 after the corresponding multiplier
arithmetic_shift SHIFT_3re( { mlplied3_re, 3'b0 }, SCALE, scaled3_re ); 
defparam SHIFT_3re.WIDTH = MSB_scale+1;				// parameters to pass

// Hook up the scaler mux in the imaginary datapath of output3 after the corresponding multiplier
arithmetic_shift SHIFT_3im( { mlplied3_im, 3'b0 }, SCALE, scaled3_im ); 
defparam SHIFT_3im.WIDTH = MSB_scale+1;				// parameters to pass

// Hook up the rounder in the real datapath of output0 after the corresponding scaler
unbias_round RND0_re(scaled0_re[Bdrfly+2:0], RES_O0_RE);
defparam RND0_re.I_WIDTH = Bdrfly+3;			// Number of input bits
defparam RND0_re.O_WIDTH = Bo;					// Number of output bits

// Hook up the rounder in the imaginary datapath of output0 after the scaler
unbias_round RND0_im(scaled0_im[Bdrfly+2:0], RES_O0_IM);
defparam RND0_im.I_WIDTH = Bdrfly+3;			// Number of input bits
defparam RND0_im.O_WIDTH = Bo;					// Number of output bits

// Hook up the rounder in the real datapath of output1 after the corresponding scaler
unbias_round RND1_re(scaled1_re[MSB_scale-3:0], RES_O1_RE);
defparam RND1_re.I_WIDTH = MSB_scale-2;			// Number of input bits
defparam RND1_re.O_WIDTH = Bo;					// Number of output bits

// Hook up the rounder in the imaginary datapath of output1 after the scaler
unbias_round RND1_im(scaled1_im[MSB_scale-3:0], RES_O1_IM);
defparam RND1_im.I_WIDTH = MSB_scale-2;			// Number of input bits
defparam RND1_im.O_WIDTH = Bo;					// Number of output bits

// Hook up the rounder in the real datapath of output2 after the corresponding scaler
unbias_round RND2_re(scaled2_re[MSB_scale-3:0], RES_O2_RE);
defparam RND2_re.I_WIDTH = MSB_scale-2;			// Number of input bits
defparam RND2_re.O_WIDTH = Bo;					// Number of output bits

// Hook up the rounder in the imaginary datapath of output2 after the scaler
unbias_round RND2_im(scaled2_im[MSB_scale-3:0], RES_O2_IM);
defparam RND2_im.I_WIDTH = MSB_scale-2;			// Number of input bits
defparam RND2_im.O_WIDTH = Bo;					// Number of output bits

// Hook up the rounder in the real datapath of output3 after the corresponding scaler
unbias_round RND3_re(scaled3_re[MSB_scale-3:0], RES_O3_RE);
defparam RND3_re.I_WIDTH = MSB_scale-2;			// Number of input bits
defparam RND3_re.O_WIDTH = Bo;					// Number of output bits

// Hook up the rounder in the imaginary datapath of output3 after the scaler
unbias_round RND3_im(scaled3_im[MSB_scale-3:0], RES_O3_IM);
defparam RND3_im.I_WIDTH = MSB_scale-2;			// Number of input bits
defparam RND3_im.O_WIDTH = Bo;					// Number of output bits

assign OVFLO =  	!ats3(scaled0_re[(Bdrfly+4):(Bdrfly+2)]) |
					!ats3(scaled0_im[(Bdrfly+4):(Bdrfly+2)]) |
					!ats3(scaled1_re[MSB_scale:MSB_scale-2]) |
					!ats3(scaled1_im[MSB_scale:MSB_scale-2]) |
					!ats3(scaled2_re[MSB_scale:MSB_scale-2]) |
					!ats3(scaled2_im[MSB_scale:MSB_scale-2]) |
					!ats3(scaled3_re[MSB_scale:MSB_scale-2]) |
					!ats3(scaled3_im[MSB_scale:MSB_scale-2]);
endmodule
// This module rounds a signed I_WIDTH bit integers to O_WIDTH bits without 
// introducing any bias to the signal flow.
`timescale 1 ns / 100ps

module unbias_round (D, Q);
	
parameter I_WIDTH = 8;	 		// Number of input bits
parameter O_WIDTH = 4;			// Number of output bits
parameter Nf = I_WIDTH-O_WIDTH;	// Number of fractional bits

input [I_WIDTH-1:0] D;
output [O_WIDTH-1:0] Q;

wire sign = D[I_WIDTH-1];								// sign of number
wire [O_WIDTH-1:0] integer_part = D[I_WIDTH-1:I_WIDTH-O_WIDTH];			// integer part of intput
wire first_fract_bit=D[I_WIDTH-O_WIDTH-1];					// first_fractional_bit
wire point_five=first_fract_bit & ~(|D[I_WIDTH-O_WIDTH-2:0]); // fixed point value of integer is n.500
wire integer_part_odd=D[I_WIDTH-O_WIDTH];						// integer part is odd
wire neg_fullscale = sign & !(|D[I_WIDTH-2:I_WIDTH-O_WIDTH]);		// integer part is - maxval;
wire pos_fullscale = !sign & (&D[I_WIDTH-2:I_WIDTH-O_WIDTH]);		// integer part is + maxval;
wire carry ;

	 	assign carry = ( first_fract_bit & (integer_part_odd | (!point_five))) &
		 		((sign) ? ((1)) : ((+1) & (!pos_fullscale) ));
		assign Q = integer_part + carry;
	
endmodule
// this module performs an arithmetic right shift on  (sXXXXXXX), such as:
// e.g. shift=2: 	y = sssXXXXX, 
// where s denotes the sign of x, X are the mantissa bits of x
// !!! ADJUST WIDTH OF INPUT <SHIFT> TO YOUR NEEDS !!!
`timescale 1 ns / 100ps


module arithmetic_shift(x, shift, y);
	
	parameter WIDTH   = 16;
		
	input [WIDTH-1 : 0] x;
	input [1:0] shift;
	output [WIDTH-1 : 0] y; 

	assign y =	 (shift==2'b00) ? x : 
				((shift==2'b01) ? { x[WIDTH-1] , x[WIDTH-1:1] } : 
				((shift==2'b10) ? { {2{x[WIDTH-1]}}, x[WIDTH-1:2] } :
						  		 { {3{x[WIDTH-1]}} , x[WIDTH-1:3] })); 
	endmodule
	
// this module performs a complex multiplication such as
// yr = ar * br - ai * bi;
// yi = ar * bi + ai * br;
// Has registered outputs, introduces 2 clock cycles delay to the datapath
// Output width = WIDTH_a + WIDTH_b 
// (as 1 sign bit falls out @ mults, but 1 extra bit is necessarry because of adds
`timescale 1 ns / 100ps

module cmplx_mult(ar, ai, br, bi, yr, yi);	
		
	parameter WIDTH_a   = 18;
	parameter WIDTH_b   = 18;
	parameter MULTIPLIER_DELAY   = WIDTH_a;
		
	parameter MSB_o  = WIDTH_a + WIDTH_b-1; // DO NOT MODIFY THIS EXTERNALLY
	
	input  [WIDTH_a-1 : 0] ar;
	input  [WIDTH_a-1 : 0] ai;
	input  [WIDTH_b-1 : 0] br;
	input  [WIDTH_b-1 : 0] bi;
	output [MSB_o : 0] yr; 
	output [MSB_o : 0] yi; 
	wire [MSB_o : 0] arxbr;	 
	wire [MSB_o : 0] arxbi;
	wire [MSB_o : 0] aixbr;
	wire [MSB_o : 0] aixbi;
	
	// Hook up 4 real, signed multipliers
	signed_mult mul0(ar, br, arxbr[ MSB_o : 0]);
	defparam mul0.WIDTH_a = WIDTH_a;	
	defparam mul0.WIDTH_b = WIDTH_b;	
	
	signed_mult mul1(ar, bi, arxbi[ MSB_o : 0]);
	defparam mul1.WIDTH_a = WIDTH_a;	
	defparam mul1.WIDTH_b = WIDTH_b;	
	
	signed_mult mul2(ai, br, aixbr[ MSB_o : 0]);
	defparam mul2.WIDTH_a = WIDTH_a;	
	defparam mul2.WIDTH_b = WIDTH_b;	

	signed_mult mul3(ai, bi, aixbi[ MSB_o : 0]);
	defparam mul3.WIDTH_a = WIDTH_a;	
	defparam mul3.WIDTH_b = WIDTH_b;	

	assign yr = arxbr-aixbi;
	assign yi = arxbi+aixbr;
endmodule
// this module performs a signed multiplication such as
// y = a * b;
`timescale 1 ns / 100ps

module signed_mult(a, b, y);
		
	parameter WIDTH_a   = 16;	// Must be greater than 1 to compile
	parameter WIDTH_b   = 16;	// Must be greater than 1 to compile
	
	input  [WIDTH_a-1 : 0] a;
	input  [WIDTH_b-1 : 0] b;
	output [(WIDTH_a+WIDTH_b-1) : 0] y; 
	wire signa = a[WIDTH_a-1];
	wire signb = b[WIDTH_b-1];

	wire [WIDTH_a-1 : 0] minusa;
	wire [WIDTH_a-2 : 0] absa; 
	wire [WIDTH_b-1 : 0] minusb;
	wire [WIDTH_b-2 : 0] absb;  
	wire [(WIDTH_a+WIDTH_b-3) : 0] absres;
	wire [(WIDTH_a+WIDTH_b-2) : 0] res;
	integer i;
	
	assign minusa = (a ^ {(WIDTH_a){1'b1}}) + 1;
	assign minusb = (b ^ {(WIDTH_b){1'b1}}) + 1;
	assign absa = signa ? minusa[WIDTH_a-2 : 0] : a[WIDTH_a-2 : 0];
	assign absb = signb ? minusb[WIDTH_b-2 : 0] : b[WIDTH_b-2 : 0];
	assign absres = (absa) * (absb);
	assign res[(WIDTH_a+WIDTH_b-2):0] = 
		 (signa != signb ) ? (( {1'b0, absres} ^ {(WIDTH_a+WIDTH_b-1){1'b1}}) + 1) : {1'b0, absres} ;
	
	assign y = {res[(WIDTH_a+WIDTH_b-2)], res};
endmodule
// this is a radix2 fft base block
// x0, x1 are the inputs, y0, y1 are the corresponding outputs
// r denotes the real, i denotes the imaginary part
`timescale 1 ns / 100ps

module dragonfly(x0r, x0i, x1r, x1i, x2r, x2i, x3r, x3i, y0r, y0i, y1r, y1i, y2r, y2i, y3r, y3i);
	
	parameter WIDTH   = 16;
	
	input  [WIDTH-1 : 0] x0r;
	input  [WIDTH-1 : 0] x0i;
	input  [WIDTH-1 : 0] x1r;
	input  [WIDTH-1 : 0] x1i;
	input  [WIDTH-1 : 0] x2r;
	input  [WIDTH-1 : 0] x2i;
	input  [WIDTH-1 : 0] x3r;
	input  [WIDTH-1 : 0] x3i;
	output [WIDTH+1 : 0] y0r; 
	output [WIDTH+1 : 0] y0i; 
	output [WIDTH+1 : 0] y1r; 
	output [WIDTH+1 : 0] y1i; 
	output [WIDTH+1 : 0] y2r; 
	output [WIDTH+1 : 0] y2i; 
	output [WIDTH+1 : 0] y3r; 
	output [WIDTH+1 : 0] y3i; 
	wire   [WIDTH : 0] t0r, t0i, t1r, t1i, t2r, t2i, t3r, t3i;
	wire   [WIDTH : 0] t3r_inv;
	
	butterfly BF_0(x0r, x0i, x2r, x2i, t0r, t0i, t1r, t1i);
	defparam BF_0.WIDTH = WIDTH;
		
	butterfly BF_1(x1r, x1i, x3r, x3i, t2r, t2i, t3r, t3i);
	defparam BF_1.WIDTH = WIDTH;
		
	inverter inv(1'b1, t3r, t3r_inv);	
	defparam inv.Bi = WIDTH + 1;
		
	butterfly BF_2(t0r, t0i, t2r, t2i, y0r, y0i, y2r, y2i);
	defparam BF_2.WIDTH = WIDTH + 1;
			
	butterfly BF_3(t1r, t1i, t3i, t3r_inv, y1r, y1i, y3r, y3i);
	defparam BF_3.WIDTH = WIDTH + 1;
		
endmodule
// this is a radix2 fft base block
// x0, x1 are the inputs, y0, y1 are the corresponding outputs
// r denotes the real, i denotes the imaginary part
// introduces 1 clock latency to the data path
`timescale 1 ns / 100ps

module butterfly(x0r, x0i, x1r, x1i, y0r, y0i, y1r, y1i);
	
	parameter WIDTH   = 16;
		
	input  [WIDTH-1 : 0] x0r;
	input  [WIDTH-1 : 0] x0i;															  
	input  [WIDTH-1 : 0] x1r;
	input  [WIDTH-1 : 0] x1i;
	output [WIDTH : 0] y1r; 
	output [WIDTH : 0] y0r; 
	output [WIDTH : 0] y0i; 
	output [WIDTH : 0] y1i; 
	
	wire [WIDTH : 0] i0r = {x0r[WIDTH-1], x0r[WIDTH-1:0] };
	wire [WIDTH : 0] i0i = {x0i[WIDTH-1], x0i[WIDTH-1:0] };
	wire [WIDTH : 0] i1r = {x1r[WIDTH-1], x1r[WIDTH-1:0] };
	wire [WIDTH : 0] i1i = {x1i[WIDTH-1], x1i[WIDTH-1:0] };
		  
	assign y0r = i0r+i1r;
	assign y0i = i0i+i1i;
	assign y1r = i0r-i1r;
	assign y1i = i0i-i1i;

	endmodule// saturating combinatoral inverter
`timescale 1 ns / 100ps

module inverter (gate, D, Q);				

parameter Bi = 16;
parameter prop_delay = 0;

input gate;
input [Bi-1:0] D;
output [Bi-1:0] Q;

assign   Q = gate ? ((D[Bi-1] & !(|D[Bi-2:0])) ? 			 // if D is negative fullscale
				{1'b0, {(Bi-1){1'b1}}} :	   	  			 // return positive fullscale
				(- D)) : D;				   	  			 // otherwise return -D
endmodule 
