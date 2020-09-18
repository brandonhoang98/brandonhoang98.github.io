/* $Id: MULT_GEN_V4_0.v,v 1.4 2002/03/29 15:59:13 janeh Exp $
--
-- Filename - MULT_GEN_V4_0.v
-- Author - Xilinx
-- Creation - 22 Mar 1999
--
-- Description - This file contains the Verilog behavior for the multiplier module
*/

`timescale 1ns/10ps

`define c_set 0
`define c_clear 1
`define c_override 0
`define c_no_override 1
`define c_add 0
`define c_sub 1
`define c_add_sub 2
`define c_signed 0
`define c_unsigned 1
`define c_pin 2
`define c_distributed 0
`define c_dp_block 2
`define allUKs {(C_OUT_WIDTH)+1{1'bx}}
`define all0s {(C_OUT_WIDTH)+1{1'b0}}
`define ball0s {(C_B_WIDTH)+1{1'b0}}
`define ballxs {(C_B_WIDTH)+1{1'bx}}
`define aall0s {(C_BAAT+C_HAS_A_SIGNED)+1{1'b0}}
`define aall1s {(C_BAAT+C_HAS_A_SIGNED)+1{1'b1}}
`define inall0s {(C_A_WIDTH-1-((C_A_WIDTH-1)*C_SQM_TYPE))+1{1'b0}}
`define baatall0s {(C_BAAT)+1{1'b0}}
`define baatall1s {(C_BAAT)+1{1'b1}}
`define baatallxs {(C_BAAT)+1{1'bx}}

module MULT_GEN_V4_0 (A, B, CLK, A_SIGNED, CE, ACLR,
					  SCLR, LOADB, LOAD_DONE, SWAPB, RFD,
					  ND, RDY, O, Q);

	parameter BRAM_ADDR_WIDTH   = 8;
	parameter C_A_TYPE 			= `c_signed;
	parameter C_A_WIDTH 		= 16;
	parameter C_BAAT			= 2;
	parameter C_B_CONSTANT 		= `c_signed;
	parameter C_B_TYPE 			= `c_signed;
	parameter C_B_VALUE 		= "0000000000000001";
	parameter C_B_WIDTH 		= 16;
	parameter C_ENABLE_RLOCS	= 1;
	parameter C_HAS_ACLR 		= 0;
	parameter C_HAS_A_SIGNED 	= 0;
	parameter C_HAS_B			= 1;
	parameter C_HAS_CE 			= 0;
	parameter C_HAS_LOADB		= 0;
	parameter C_HAS_LOAD_DONE	= 0;
	parameter C_HAS_ND			= 0;
	parameter C_HAS_O			= 0;
	parameter C_HAS_Q 			= 1;
	parameter C_HAS_RDY			= 0;
	parameter C_HAS_RFD			= 0;
	parameter C_HAS_SCLR		= 0;
	parameter C_HAS_SWAPB		= 0;
	parameter C_MEM_INIT_PREFIX	= "mem";
	parameter C_MEM_TYPE    	= 0;
	parameter C_MULT_TYPE	 	= 0;
	parameter C_OUTPUT_HOLD		= 0;
	parameter C_OUT_WIDTH		= 16;
	parameter C_PIPELINE 		= 0;
	parameter C_REG_A_B_INPUTS  = 1;
	parameter C_SQM_TYPE		= 0;
	parameter C_STACK_ADDERS	= 0;
        parameter C_STANDALONE          = 0;
	parameter C_SYNC_ENABLE		= 0;
	parameter C_USE_LUTS		= 1;

	//Internal parameters

	parameter incA = (((C_HAS_A_SIGNED == 1 || C_A_TYPE == `c_signed) && C_B_TYPE == `c_unsigned) ?  1 : 0) ;
	parameter incB = (C_B_TYPE == `c_signed ? 1 : 0) ;
	parameter inc = ((C_B_TYPE == `c_unsigned && C_A_TYPE == `c_unsigned) ? 0 : 1) ;
	parameter dec = ((C_B_TYPE == `c_unsigned && C_A_TYPE == `c_unsigned) ? 1 : 0) ;
	parameter inc_a_width = ((C_BAAT < C_A_WIDTH && (C_HAS_A_SIGNED == 1 || C_A_TYPE == `c_signed) && C_HAS_LOADB == 0) ? 1 : 0) ;
	parameter decrement = ((C_HAS_A_SIGNED == 1 || (C_A_TYPE == `c_signed && C_BAAT < C_A_WIDTH)) ? 1 : 0) ;

	//Parameters to calculate the latency for the parallel multiplier.
	parameter a_ext_width_par = (C_HAS_A_SIGNED == 1 ? C_BAAT+1 : C_BAAT) ;
	parameter a_ext_width_seq = ((C_HAS_A_SIGNED == 1 || C_A_TYPE == `c_signed) ? C_BAAT+1 : C_BAAT) ;
	parameter a_ext_width = (C_BAAT < C_A_WIDTH ? a_ext_width_seq : a_ext_width_par) ;

        /* Compare the width of the A port, to the width of the B port
	 If the A port is smaller, then swap these over, otherwise leave
	 alone */

        parameter a_w = (C_A_WIDTH < C_B_WIDTH ? C_B_WIDTH : a_ext_width);
        parameter a_t = (C_A_WIDTH < C_B_WIDTH ? C_B_TYPE : C_A_TYPE);
        parameter b_w = (C_A_WIDTH < C_B_WIDTH ? a_ext_width : C_B_WIDTH);
        parameter b_t = (C_A_WIDTH < C_B_WIDTH ? C_A_TYPE : C_B_TYPE);

        // The mult18 parameter signifies if the final mult18x18 primitive is used
        // without having to pad with zeros, or sign extending - thus leading to
        // a more efficient implementation - e.g. a 35x35 (signed x signed) multiplier
        // mult18, is used in the calculation of a_prods and b_prods, which indicate
        // how many mult18x18 primitives are requred.
   
        parameter mult18 = (((a_t == `c_signed && a_w % 17 == 1) 
           && ((b_t == `c_signed && b_w <= a_w) || (b_t == `c_unsigned && b_w < a_w))) ? 1 : 0);   
   
	parameter a_prods = (a_ext_width-1)/(17 + mult18) + 1 ;
	parameter b_prods = (C_B_WIDTH-1)/(17 + mult18) + 1 ;
	parameter a_count = (a_ext_width+1)/2 ;
	parameter b_count = (C_B_WIDTH+1)/2 ;
	parameter parm_numAdders = (C_MULT_TYPE == 1 ? (a_prods*b_prods) : ((a_ext_width <= C_B_WIDTH) ? a_count : b_count)) ;

	//Parameters to calculate the latency for the constant coefficient multiplier.
	parameter rom_addr_width = (C_MEM_TYPE == `c_distributed ? 4 : BRAM_ADDR_WIDTH) ;
	parameter sig_addr_bits = (C_BAAT >= rom_addr_width ? rom_addr_width : C_BAAT) ;
	parameter effective_op_width = ((C_BAAT == C_A_WIDTH && (C_HAS_A_SIGNED == 0 || C_HAS_LOADB == 1)) ? C_BAAT : ((C_BAAT == C_A_WIDTH) ? C_BAAT+1 : (C_BAAT < C_A_WIDTH ? C_BAAT+inc_a_width : C_BAAT+1))) ;
	parameter a_input_width = ((effective_op_width % rom_addr_width == 0) ? effective_op_width : effective_op_width + rom_addr_width - (effective_op_width % rom_addr_width)) ;
	parameter mod = a_input_width % rom_addr_width ;
	parameter op_width = (mod == 0 ? a_input_width : (a_input_width + rom_addr_width) - mod) ;
	parameter a_width = (C_BAAT < C_A_WIDTH ? C_A_WIDTH : op_width) ;
	parameter need_addsub = ((C_HAS_LOADB == 1 && (C_A_TYPE == `c_signed || C_HAS_A_SIGNED == 1)) ? 1 : 0) ;
	parameter ccm_numAdders_1 = (mod == 0 ? (a_input_width/rom_addr_width) : (a_input_width/rom_addr_width)+1) ;
	parameter need_0_minus_pp = ((need_addsub == 1 && ccm_numAdders_1 <= 1) ? 1 : 0) ;
	parameter ccm_numAdders = (need_0_minus_pp == 1 ? 1 : ccm_numAdders_1 - 1) ;
	parameter ccm_init1 = ((C_HAS_LOADB == 1 && C_MEM_TYPE == `c_dp_block) ? 1 : 0) ;
	parameter ccm_init2 = ((C_HAS_LOADB == 1 && (C_A_TYPE == `c_signed || C_HAS_A_SIGNED == 1) && C_PIPELINE == 1) ? 1 : 0) ;
	parameter ccm_init3 = (((ccm_numAdders > 0 || C_HAS_SWAPB == 1) && (C_PIPELINE == 1 || C_MEM_TYPE == `c_dp_block)) ? 1 : 0) ;
	parameter ccm_init4 = ((ccm_numAdders > 0 && C_HAS_SWAPB == 1 && C_PIPELINE == 1) ? 1 : 0) ;
	parameter ccm_initial_latency = ccm_init1 + ccm_init2 + ccm_init3 + ccm_init4 ;
	parameter add_one = 0 ; 
	parameter extra_cycles = 0 ; 

	//Latency calculation
	parameter numAdders = (C_MULT_TYPE < 2 ? parm_numAdders - 1 : ccm_numAdders) ;
	parameter log = (C_PIPELINE == 1 ? (numAdders < 2 ? 0 : (numAdders < 4 ? 1 : (numAdders < 8 ? 2 : (numAdders < 16 ? 3 : (numAdders < 32 ? 4 : (numAdders < 64 ? 5 : (numAdders < 128 ? 6 : 7))))))) : 0) ; 
	parameter C_LATENCY_sub = (C_MULT_TYPE < 2 ? (numAdders > 0 ? (extra_cycles + log + 1) : 0) : (numAdders > 0 ? (ccm_initial_latency + extra_cycles + log + add_one) : ccm_initial_latency)) ;
	parameter C_LATENCY_nonseq = (C_PIPELINE == 1 ? C_LATENCY_sub : (C_MULT_TYPE < 2 ? 0 : C_LATENCY_sub)) ; //+extra_latency : 0) ;
	parameter serial_adjust1 = (C_SQM_TYPE == 1 && C_MULT_TYPE > 1 ) ? 1 : 0 ; 
	parameter serial_adjust = (C_SQM_TYPE == 1 && C_MULT_TYPE > 1) ? 1 : 0 ;
	parameter blk_mem_adjust = ((C_MULT_TYPE > 1 && C_MEM_TYPE == `c_dp_block && C_PIPELINE == 0 && ccm_numAdders_1 == 1) ? 1 : 0) ; // && C_LATENCY_nonseq == 0) ? 1 : 0) ; 
	parameter slicer_adjust = ((C_BAAT < C_A_WIDTH && ~(C_SQM_TYPE == 1 && C_MULT_TYPE > 1)) ? 1 : 0) ; // && C_PIPELINE == 0)) ? 1 : 0) ;
	parameter reg_adjust = (C_SQM_TYPE == 0 && C_PIPELINE == 0 && C_LATENCY_nonseq == 0 ? 1 : 0) ;
	parameter pipe_adjust = ((C_SQM_TYPE == 1 && C_PIPELINE == 0 && serial_adjust == 0) ? 1 : 0) ;
	parameter C_LATENCY_seq = C_LATENCY_nonseq + slicer_adjust + blk_mem_adjust ; 
	parameter nd_adjust = (C_BAAT == C_A_WIDTH && C_HAS_ND == 1 && C_LATENCY_nonseq > 1 ) ? 1 : 0 ; //&& ~(C_MEM_TYPE == `c_dp_block && C_HAS_LOADB == 1 && C_HAS_SWAPB == 1 && C_PIPELINE == 0)) ? 1 : 0 ;
	parameter desperation = C_PIPELINE ; 
	parameter C_LATENCY = (C_BAAT == C_A_WIDTH ? C_LATENCY_nonseq-nd_adjust : C_LATENCY_seq + desperation) ;

	//Parameters to calculate the number of cycles that the sequential mult takes to process the inputs.
	parameter div_cycle = (C_A_WIDTH/C_BAAT) ;
	parameter mod_cycle = (C_A_WIDTH - (C_BAAT*div_cycle)) ;
	parameter no_of_cycles = (C_BAAT == C_A_WIDTH ? 1 : (mod_cycle == 0 ? div_cycle : div_cycle+1)) ;

	parameter c_pipe = (C_PIPELINE == 1 || C_LATENCY > 0 || C_BAAT < C_A_WIDTH) ? 1 : 0 ;

	parameter multWidth = (C_BAAT*no_of_cycles)+C_B_WIDTH+decrement+1 ;
        parameter rfd_stages = (C_BAAT==C_A_WIDTH ? 1 : (no_of_cycles-C_REG_A_B_INPUTS-1));

	`define mall0s {(multWidth)+1{1'b0}}

	input [(C_A_WIDTH-1-((C_A_WIDTH-1)*C_SQM_TYPE)) : 0] A;
	input [C_B_WIDTH-1 : 0] B;
	input CLK;
	input CE;
	input A_SIGNED;
	input LOADB;
	input SWAPB;
	input ND;
	input ACLR;
	input SCLR;
	output RFD;
	output RDY;
	output LOAD_DONE;
	output [C_OUT_WIDTH-1 : 0] O;
	output [C_OUT_WIDTH-1 : 0] Q;
	 
	// Internal values to drive signals when input is missing
	wire [C_B_WIDTH-1 : 0] intBconst;
	reg [C_B_WIDTH-1 : 0] intB;
	reg [(C_A_WIDTH-1-((C_A_WIDTH-1)*C_SQM_TYPE)) : 0] intA;
	wire [C_B_WIDTH-1 : 0] regB;
	wire [C_B_WIDTH-1 : 0] regB_tmp;
	wire [(C_A_WIDTH-1-((C_A_WIDTH-1)*C_SQM_TYPE)) : 0] regA;
	wire [(C_A_WIDTH-1-((C_A_WIDTH-1)*C_SQM_TYPE)) : 0] regA_tmp;
	wire [C_B_WIDTH-1 : 0] regBB;
	wire [(C_A_WIDTH-1-((C_A_WIDTH-1)*C_SQM_TYPE)) : 0] regAA;
	reg [C_B_WIDTH-1 : 0] b_const0;
	reg [C_B_WIDTH-1 : 0] b_const1;
	reg [C_B_WIDTH-1 : 0] loadb_value ;
	reg [C_B_WIDTH-1 : 0] B_INPUT;
	wire intCE;
	reg intA_SIGNED;
	wire regA_SIGNED;
	wire regA_SIGNED_tmp;
	wire  intA_SIGNED_seq;
	wire intACLR;
	wire intACLR_for_blkmem ;
	wire seq_aclr ;
	wire intSCLR;
	wire initial_intCLK;
	reg intCLK;
	reg last_clk;
	wire intLOADB;
	reg loaded;
	wire intSWAPB;
	wire regLOADB ;
	wire regSWAPB ;
	wire intND_seq ;
	wire intND_nonseq1 ;
	wire intND_nonseq ;
	wire actualND ;
	wire regND_nonseq;
	wire regND_tmp;
	reg regND_seq;
	wire intND_for_RDY;
	wire regND;
	wire intND ;
	wire regregND;
	reg intRDY;
	wire intOP_HOLD ;
	wire intOP_HOLD_par ;
	reg intQCLKenopipe ;
	reg seqRDY ;
	reg intRFD;
	reg regRFD ;
	reg RFD_int ;
	wire regRDY ;
	reg intLOAD_DONE;
	wire intLOAD_DONE_sub;
	reg regLOAD_DONE_sub;
	wire intLD_for_RDY ;
	reg [C_OUT_WIDTH-1 : 0 ] intO;
	reg [C_OUT_WIDTH-1 : 0 ] intQ_nopipe;
	reg [C_OUT_WIDTH-1 : 0 ] intQ_bis1;
	reg [C_OUT_WIDTH-1 : 0 ] intQ_ophold;
	wire [C_OUT_WIDTH-1 : 0 ] intQ;
	wire [C_OUT_WIDTH-1 : 0 ] intQ_blkmem;
	wire [C_OUT_WIDTH-1 : 0 ] intQ_not_blkmem;
	reg [C_OUT_WIDTH-1 : 0] intQ_int ;
	wire intQ_ctrl ;
	reg last_intQ_ctrl ;
	reg lastCLK;
	reg intQCLK_nopipe ;
	reg [C_BAAT-1 : 0] max_a_val ;
    reg power_2;
	reg RDYpipe_has_one;	// added to enable fix to RDY within an rccm and there is a 
										//RDY in pipeline when loadb is asserted (see lines around 1719-37)
    
    reg invalidRDY;
        
	reg [multWidth-1 : 0] a_value ;
	reg [multWidth-1 : 0] b_value ;
	reg [multWidth-1 : 0] max_result ;
    reg [multWidth : 0] max_result1 ;
    reg [multWidth : 0] max_result2 ;
	reg [1:0] intSWAPB_pipe ;
	reg [1:0] intLD_pipe ;
	
	reg [rfd_stages:0] intRFD_delay ;
	reg intRFD_noreg ;
	reg [(no_of_cycles*C_BAAT)-1:0] intA_seq ;
	reg [C_BAAT-1 : 0] intA_seq_pipe [no_of_cycles-1 : 0] ;
	reg [C_BAAT-1 : 0] slice ;
	reg [C_OUT_WIDTH-1 : 0] intQpipe [C_LATENCY : 0]; 
	reg [C_LATENCY+nd_adjust : 0] intRDYpipe;
	reg [C_LATENCY : 0] intRFDpipe; 
	reg [C_LATENCY : 0] intLOAD_DONEpipe; 

	reg [C_OUT_WIDTH-1 : 0] intQpipeend;
	reg intQ_C_OUTpipeend;
	reg intQ_B_OUTpipeend;
	reg intQ_OVFLpipeend;
	reg [C_OUT_WIDTH-1 : 0] tmp_pipe1;
	reg [C_OUT_WIDTH-1 : 0] tmp_pipe2;
	 
	wire [C_OUT_WIDTH-1 : 0] Q = (C_HAS_Q == 1 ? (C_BAAT < C_A_WIDTH && C_OUTPUT_HOLD == 1 ? intQ_ophold : (C_BAAT < C_A_WIDTH ? intQ : intQ_int)) : `allUKs);
	wire [C_OUT_WIDTH-1 : 0] O = (C_HAS_O == 1 ? intQpipe[0] : `allUKs);

	wire RDY = (C_HAS_RDY == 1 ? ((C_MULT_TYPE > 2 || C_BAAT < C_A_WIDTH) ? (C_HAS_Q == 1 ? intRDY : intRDYpipe[0]) : (C_HAS_ND == 1 ? (C_HAS_Q == 1 ? intRDY : intRDYpipe[0]) : 1)) : 1'bx);
	wire intRDY_for_Q_ctrl = ((C_MULT_TYPE > 2 || C_BAAT < C_A_WIDTH) ? (C_HAS_Q == 1 ? intRDY : intRDYpipe[0]) : (C_HAS_ND == 1 ? (C_HAS_Q == 1 ? intRDY : intRDYpipe[0]) : 1)) ;
	
	wire RFD = (C_HAS_RFD == 1 ? ((C_HAS_LOADB == 1 && C_HAS_SWAPB == 0) ? intRFD & intLOAD_DONE_sub : intRFD) : 1'bx);

	wire LOAD_DONE = (C_HAS_LOAD_DONE == 1 ? intLOAD_DONE : 1'bx);
	
	// Sort out default values for missing ports
	
	assign regND = (C_BAAT < C_A_WIDTH ? regND_seq : regND_nonseq) ;
	assign intCE = ((C_HAS_CE == 1 && C_SYNC_ENABLE == `c_no_override) ? CE : (C_HAS_CE == 1 ? (CE & ~intSCLR) : 1));
	assign initial_intCLK = CLK;
	assign intND_nonseq1 = ((C_HAS_ND == 1 && ~((C_LATENCY == 0) && C_REG_A_B_INPUTS == 0 && C_HAS_Q == 0)) ? ((C_REG_A_B_INPUTS == 1) ? regND : ND) : 1);
	assign intND_nonseq = (C_HAS_LOADB == 1 ? intND_nonseq1 : intND_nonseq1) ;
	assign intND_seq = (C_HAS_ND == 1 ? ((C_REG_A_B_INPUTS == 1) ? (regND & regRFD) : ND & intRFD) : ((C_REG_A_B_INPUTS == 1) ? regRFD : intRFD)) ;
	assign intND = (C_BAAT < C_A_WIDTH ? intND_seq : intND_nonseq) ;
	assign intND_for_RDY = ((C_HAS_RDY == 1 && C_HAS_ND == 1) ? (C_REG_A_B_INPUTS == 1 ? regND : ND) : 0) ;
	assign actualND = (C_REG_A_B_INPUTS == 1 ? regND : intND) ;
	assign intOP_HOLD_par = (((C_PIPELINE == 0 || (C_PIPELINE == 1 && C_LATENCY == 0)) && C_REG_A_B_INPUTS == 0) ? intRDY & intCE : intCE) ;
	assign intOP_HOLD = (C_BAAT < C_A_WIDTH ? 1 : intOP_HOLD_par) ;

	assign intLOADB = (C_HAS_LOADB == 1 ? (C_REG_A_B_INPUTS == 1 ? LOADB : LOADB) : 0) ;
	assign intSWAPB = (C_HAS_SWAPB == 1 ? (C_REG_A_B_INPUTS == 1 ? SWAPB : SWAPB) : 0) ;
	assign intA_SIGNED_seq = 0 ;
	assign intLOAD_DONE_sub = (C_HAS_SWAPB == 1 ? 1 : intLOAD_DONE) ;
	assign intLD_for_RDY = (C_REG_A_B_INPUTS == 1 ? regLOAD_DONE_sub : intLOAD_DONE_sub) ;

	assign seq_aclr = ((C_HAS_LOADB == 1 && C_HAS_SWAPB == 1) ? SWAPB : ((C_HAS_LOADB == 1) ? ~intLOAD_DONE : 0)) ;
	assign intQ = ((C_BAAT == C_A_WIDTH && C_MEM_TYPE == `c_dp_block && C_MULT_TYPE > 1 && ccm_numAdders_1 == 1 && need_addsub == 0) ? intQ_blkmem : intQ_not_blkmem) ;
	assign intACLR = (C_HAS_ACLR == 1 ? ACLR : 0) ;
	assign intACLR_for_blkmem = (C_HAS_ACLR == 1 ? ((C_BAAT == C_A_WIDTH && C_MEM_TYPE == `c_dp_block && C_MULT_TYPE > 1 && ccm_numAdders_1 == 1 && need_addsub == 0) ? 0 : ACLR) : 0) ;
	assign intSCLR = (C_HAS_SCLR == 1 ? SCLR : 0);

	assign intQ_ctrl = (C_BAAT < C_A_WIDTH ? intCE : intCE & intRDY_for_Q_ctrl) ;

	integer j, k, test1, msb;
	integer pipe, pipe1;
	integer i;
	integer cycle, loadb_count, out_width, tmp_out_width, b_is_negative, b_width, new_data_present, sqm_cutoff_size ;
	integer bank_sel, loadb_delay ;
	integer shift_bits, real_latency ;
	integer loading, cycle_discarded, b_is_zero, b_is_one, a_negative, b_negative ;
	
	reg [C_B_WIDTH-1 : 0] initB_INPUT;
	reg [multWidth-1 : 0] tmpA;
	reg [multWidth-1 : 0] tmpB;
	reg [multWidth-1 : 0] tmpAB;
	reg tmpA_SIGNED ;

	reg [multWidth-1 : 0] one;
	reg [multWidth-1 : 0] zero ;

	reg [multWidth-1 : 0] product ;
	reg [multWidth-1 : 0] product_delayed ;
	reg [multWidth-1 : 0] feedback ;
	reg [multWidth-1 : 0] store ;
	reg [multWidth-1 : 0] accum_out ;
	reg [multWidth-1 : 0] total_output ;
	reg [C_LATENCY_nonseq : 0] intPRODUCTpipe [multWidth-1 : 0] ;

	C_REG_FD_V5_0 #("0", C_ENABLE_RLOCS, C_HAS_ACLR, 0, 0,
			   C_HAS_CE, C_HAS_SCLR, 0, 0,
			   "0", C_SYNC_ENABLE, 0, (C_A_WIDTH-1-((C_A_WIDTH-1)*C_SQM_TYPE))+1)
		rega (.D(A), .CLK(intCLK), .CE(intCE), .ACLR(intACLR), .ASET(1'b0),
			  .AINIT(1'b0), .SCLR(intSCLR), .SSET(1'b0), .SINIT(1'b0),
			  .Q(regA)); 

	C_REG_FD_V5_0 #("0", C_ENABLE_RLOCS, C_HAS_ACLR, 0, 0,
			   C_HAS_CE, C_HAS_SCLR, 0, 0,
			   "0", C_SYNC_ENABLE, 0, C_B_WIDTH)
		regb (.D(B_INPUT), .CLK(intCLK), .CE(intCE), .ACLR(intACLR), .ASET(1'b0),
			  .AINIT(1'b0), .SCLR(intSCLR), .SSET(1'b0), .SINIT(1'b0),
			  .Q(regB)); 

    C_REG_FD_V5_0 #("0", C_ENABLE_RLOCS, C_HAS_ACLR, 0, 0,
			   0, C_HAS_SCLR, 0, 0,
			   "0", C_SYNC_ENABLE, 0, (C_A_WIDTH-1-((C_A_WIDTH-1)*C_SQM_TYPE))+1)
		regat (.D(A), .CLK(intCLK), .CE(intCE), .ACLR(intACLR), .ASET(1'b0),
			  .AINIT(1'b0), .SCLR(intSCLR), .SSET(1'b0), .SINIT(1'b0),
			  .Q(regA_tmp)); 

	C_REG_FD_V5_0 #("0", C_ENABLE_RLOCS, C_HAS_ACLR, 0, 0,
			   0, C_HAS_SCLR, 0, 0,
			   "0", C_SYNC_ENABLE, 0, C_B_WIDTH)
		regbt (.D(B_INPUT), .CLK(intCLK), .CE(intCE), .ACLR(intACLR), .ASET(1'b0),
			  .AINIT(1'b0), .SCLR(intSCLR), .SSET(1'b0), .SINIT(1'b0),
			  .Q(regB_tmp)); 

	//The sequential multiplier uses an extra set of input registers if C_REG_A_B_INPUTS = 1.
	C_REG_FD_V5_0 #("0", C_ENABLE_RLOCS, C_HAS_ACLR, 0, 0,
			   C_HAS_CE, C_HAS_SCLR, 0, 0,
			   "0", C_SYNC_ENABLE, 0, (C_A_WIDTH-1-((C_A_WIDTH-1)*C_SQM_TYPE))+1)
		regaa (.D(regA), .CLK(intCLK), .CE(intCE), .ACLR(intACLR), .ASET(1'b0),
			  .AINIT(1'b0), .SCLR(intSCLR), .SSET(1'b0), .SINIT(1'b0),
			  .Q(regAA)); 

	C_REG_FD_V5_0 #("0", C_ENABLE_RLOCS, C_HAS_ACLR, 0, 0,
			   C_HAS_CE, C_HAS_SCLR, 0, 0,
			   "0", C_SYNC_ENABLE, 0, C_B_WIDTH)
		regbb (.D(regB), .CLK(intCLK), .CE(intCE), .ACLR(intACLR), .ASET(1'b0),
			  .AINIT(1'b0), .SCLR(intSCLR), .SSET(1'b0), .SINIT(1'b0),
			  .Q(regBB));

	C_REG_FD_V5_0 #("0", C_ENABLE_RLOCS, C_HAS_ACLR, 0, 0,
			   C_HAS_CE, C_HAS_SCLR, 0, 0,
			   "0", C_SYNC_ENABLE, 0, C_OUT_WIDTH)
		regq (.D(intQpipe[0]), .CLK(intCLK), .CE(intCE), .ACLR(intACLR), .ASET(1'b0),
			  .AINIT(1'b0), .SCLR(intSCLR), .SSET(1'b0), .SINIT(1'b0),
			  .Q(intQ_not_blkmem));

    C_REG_FD_V5_0 #("0", C_ENABLE_RLOCS, C_HAS_ACLR, 0, 0,
			   C_HAS_CE, C_HAS_SCLR, 0, 0,
			   "0", C_SYNC_ENABLE, 0, C_OUT_WIDTH)
		regqblk (.D(intQpipe[0]), .CLK(intCLK), .CE(intCE), .ACLR(intACLR_for_blkmem), 
				.ASET(1'b0),
			  .AINIT(1'b0), .SCLR(intSCLR), .SSET(1'b0), .SINIT(1'b0),
			  .Q(intQ_blkmem));

	C_REG_FD_V5_0 #("0", C_ENABLE_RLOCS, C_HAS_ACLR, 0, 0,
			   C_HAS_CE, C_HAS_SCLR, 0, 0,
			   "0", C_SYNC_ENABLE, 0, 1)
		regnd (.D(ND), .CLK(intCLK), .CE(intCE), .ACLR(intACLR), .ASET(1'b0),
			  .AINIT(1'b0), .SCLR(intSCLR), .SSET(1'b0), .SINIT(1'b0),
			  .Q(regND_nonseq)); 

	C_REG_FD_V5_0 #("0", C_ENABLE_RLOCS, C_HAS_ACLR, 0, 0,
			   C_HAS_CE, C_HAS_SCLR, 0, 0,
			   "0", C_SYNC_ENABLE, 0, 1)
		regloadb (.D(LOADB), .CLK(intCLK), .CE(intCE), .ACLR(intACLR), .ASET(1'b0),
			  .AINIT(1'b0), .SCLR(intSCLR), .SSET(1'b0), .SINIT(1'b0),
			  .Q(regLOADB)); 

	C_REG_FD_V5_0 #("0", C_ENABLE_RLOCS, C_HAS_ACLR, 0, 0,
			   C_HAS_CE, C_HAS_SCLR, 0, 0,
			   "0", C_SYNC_ENABLE, 0, 1)
		regswapb (.D(SWAPB), .CLK(intCLK), .CE(intCE), .ACLR(intACLR), .ASET(1'b0),
			  .AINIT(1'b0), .SCLR(intSCLR), .SSET(1'b0), .SINIT(1'b0),
			  .Q(regSWAPB)); 

	C_REG_FD_V5_0 #("0", C_ENABLE_RLOCS, C_HAS_ACLR, 0, 0,
			   C_HAS_CE, C_HAS_SCLR, 0, 0,
			   "0", C_SYNC_ENABLE, 0, 1)
		regregnd (.D(regND), .CLK(intCLK), .CE(intCE), .ACLR(intACLR), .ASET(1'b0),
			  .AINIT(1'b0), .SCLR(intSCLR), .SSET(1'b0), .SINIT(1'b0),
			  .Q(regregND)); 

	C_REG_FD_V5_0 #("0", C_ENABLE_RLOCS, C_HAS_ACLR, 0, 0,
			   C_HAS_CE, C_HAS_SCLR, 0, 0,
			   "0", C_SYNC_ENABLE, 0, 1)
		regasig (.D(A_SIGNED), .CLK(intCLK), .CE(intCE), .ACLR(intACLR), .ASET(1'b0),
			  .AINIT(1'b0), .SCLR(intSCLR), .SSET(1'b0), .SINIT(1'b0),
			  .Q(regA_SIGNED)); 

    C_REG_FD_V5_0 #("0", C_ENABLE_RLOCS, C_HAS_ACLR, 0, 0,
			   0, C_HAS_SCLR, 0, 0,
			   "0", C_SYNC_ENABLE, 0, 1)
		regasigt (.D(A_SIGNED), .CLK(intCLK), .CE(intCE), .ACLR(intACLR), .ASET(1'b0),
			  .AINIT(1'b0), .SCLR(intSCLR), .SSET(1'b0), .SINIT(1'b0),
			  .Q(regA_SIGNED_tmp));

    C_REG_FD_V5_0 #("0", C_ENABLE_RLOCS, C_HAS_ACLR, 0, 0,
			   0, C_HAS_SCLR, 0, 0,
			   "0", C_SYNC_ENABLE, 0, 1)
		regndtmp (.D(ND), .CLK(intCLK), .CE(intCE), .ACLR(intACLR), .ASET(1'b0),
			  .AINIT(1'b0), .SCLR(intSCLR), .SSET(1'b0), .SINIT(1'b0),
			  .Q(regND_tmp)); 

	initial
	begin
		B_INPUT = (C_MULT_TYPE < 2) ? B : to_bitsB(C_B_VALUE);
		if (C_MULT_TYPE > 2 && C_B_TYPE == `c_signed)
		begin
			j = 0 ;
			msb = 0 ;
			//Find the length of the C_B_VALUE string
			for(i = 0; i < (C_B_WIDTH*8); i = i + 1)
			begin
				if(C_B_VALUE[i] == 0 || C_B_VALUE[i] == 1)
					msb = i/8 ;
			end
			//Pad it with 1's if it is signed and negative.
			for(i = msb; i < C_B_WIDTH; i = i + 1)
			begin
				B_INPUT[i] = B_INPUT[msb];
			end
		end

		//Initialise all the signals that need to be initialised at start up.
		intQ_int = `all0s ;
		intQCLK_nopipe = 0 ;
		intRFD = 1 ;
		regRFD = 1 ;
		loading = 0 ;

		bank_sel = 0 ;
		b_const0 = B_INPUT ;
		b_const1 = B_INPUT ;
		loadb_value = B_INPUT ;
		intB = B_INPUT ;
		tmpB = B_INPUT ;
		intLOAD_DONE = 1 ;
		regLOAD_DONE_sub = 1 ;
		loadb_count = -1 ;
		loaded = 0 ;

		if (C_BAAT < C_A_WIDTH) //Sequential
		begin
			cycle_discarded = 0 ;

			intSWAPB_pipe[0] = 0 ;
			intSWAPB_pipe[1] = 0 ;
			intLD_pipe[0] = 1 ;
			intLD_pipe[1] = 1 ;

			intRFD = 1 ;
			regRFD = 0 ;
			intRDYpipe = 0 ;
			intRDY <= 0 ; 
			for(i = 0; i <= (no_of_cycles-C_REG_A_B_INPUTS-1); i = i + 1)
			begin
				intRFD_delay[i] = 0 ;
			end
			
			if (C_HAS_ND == 1)
				intRFD_noreg = 1 ;
			else
				intRFD_noreg = 0 ;

		end
		else if (C_HAS_ND == 0) //Non-sequential
		begin
			intRDY <= 1 ;
			for(k = 0 ; k <= C_LATENCY; k = k + 1)
			begin
				intRDYpipe[k] = 1 ;
			end
		end
		else if (C_HAS_ND == 1)
		begin
			intRDY <= 0 ;
			for(k = 0 ; k <= C_LATENCY+nd_adjust; k = k + 1)
			begin
				intRDYpipe[k] = 0 ;
			end
		end
		cycle=no_of_cycles+2;
		initB_INPUT = (C_MULT_TYPE < 2) ? B : to_bitsB(C_B_VALUE);
		new_data_present = 0 ;
		seqRDY = 0 ;
		intQ_nopipe = `all0s ;
		intQ_ophold = `all0s ;

		//Clear the pipeline and the inputs if there are registers involved.
		if (C_REG_A_B_INPUTS == 1 || C_LATENCY > 0)
		begin
			for(j = 0; j < multWidth; j = j + 1)
			begin
				if (C_REG_A_B_INPUTS == 1)
				begin
					intA[j] = 0 ;
					tmpA[j] = 0 ;
					if(C_MULT_TYPE < 2)
					begin
						intB[j] = 0 ;
						tmpB[j] = 0 ;
					end
				end
				tmpAB[j] = 0 ;
				intQ_ophold[j] = 0 ;
			end
			for (j = 0; j <= C_LATENCY; j = j + 1)
			begin
				intQpipe[j] = `all0s ;
			end
		end

		for(i = 0; i < multWidth; i = i + 1)
		begin
			if (i > 0)
				begin
					one[i] = 0 ;
					zero[i] = 0 ;
				end
				else
				begin
					one[i] = 1 ;
					zero[i] = 0 ;
				end
		end
		
		//Clear the pipeline for the sequential multiplier
		if (C_BAAT < C_A_WIDTH)
		begin
			for (i = 0; i < multWidth; i = i + 1)
			begin
				intA[i] = 0 ;
				if(C_MULT_TYPE < 2)
					intB[i] = 0 ;
			end
		end

		if (C_MULT_TYPE > 2)
		begin
			loadb_delay = 1 ;
			for(i = 0; i < sig_addr_bits; i = i + 1)
			begin
				loadb_delay = 2*loadb_delay ;
			end
			loadb_delay = loadb_delay-1 ;
		end

		//Find the real b input width
		if (C_MULT_TYPE > 1 && C_HAS_LOADB == 0)
		begin
			b_width = 0 ;
			for(i = 0; i < C_B_WIDTH; i = i + 1)
			begin
				if(initB_INPUT[i] == 1)
					b_width = i+1 ;
			end 
		end
		else
		begin
			b_width = C_B_WIDTH ;
		end

		//Calculate the output width of the multiplier.
		a_negative = 0 ;
		b_negative = 0 ;
		
        power_2 = 1'b1;                                        //This has been added to fix a bug found in CR128922
              for (i = 0; i < C_B_WIDTH; i = i + 1)            // where the combination of a signed input and the b-value
              begin                                            // is a power of 2 caused the model to fail.
                if ((initB_INPUT[i] == 1) && (i!=C_B_WIDTH-1))
                   power_2 = 1'b0;
              end
              
        if (C_A_TYPE == `c_signed) // || C_HAS_A_SIGNED == 1)
		begin
			a_negative = 1 ;
			max_a_val = `aall0s ;
            //for (i = C_BAAT-1; i < multWidth; i = i + 1)
            //    max_a_val[i] = 1 ;
            max_a_val[C_BAAT-1] = 1;
		end
		else
		begin
			max_a_val = `aall1s ;
		end

        if ((initB_INPUT[b_width-1] == 1) && (C_B_TYPE == `c_signed))
			b_negative = 1 ;
		for (i = 0; i < b_width; i = i + 1)
		begin
			if ((initB_INPUT[b_width-1] == 1) && (C_B_TYPE == `c_signed))
			begin
				b_value[i] = ~initB_INPUT[i] ;
			end
			else
			begin
				b_value[i] = initB_INPUT[i] ;
			end
		end
        
		for (i = 0; i < C_BAAT; i = i + 1)
		begin
			a_value[i] = max_a_val[i] ;
		end
		for (i = C_BAAT; i < multWidth; i = i + 1)
		begin
		    if(a_negative == 1 && power_2 ==1 ) //&& b_negative == 1 && power_2 == 1)
			  a_value[i] = 1 ;
            else
              a_value[i] = 0 ; // Originally just this line
		end

		

		for (i = b_width; i < multWidth; i = i + 1)
		begin
			if (C_B_TYPE == `c_signed && b_value[b_width-1] == 1)
			begin
				b_value[i] = 1 ;
			end
			else
			begin
				b_value[i] = 0 ;
			end
		end


		if ((initB_INPUT[b_width-1] == 1) && (C_B_TYPE == `c_signed))
		begin
			b_value = add(b_value, one) ;
		end

		for (i = b_width; i < multWidth; i = i + 1)
		begin
			if (C_B_TYPE == `c_signed && b_value[b_width-1] == 1)
			begin
				b_value[i] = 1 ;
			end
			else
			begin
				b_value[i] = 0 ;
			end
		end

		max_result = a_value * b_value ;

		j = 0 ;
		if ((max_result[multWidth-1] == 1) && (C_B_TYPE == `c_signed || C_A_TYPE == `c_signed || C_HAS_A_SIGNED == 1))
			j = 1 ;

		if (C_BAAT < C_A_WIDTH)
		begin
			if (b_width == 1)
			begin
				if (C_B_TYPE == `c_signed)	//dlunn added here 2/11/2000
					out_width = C_BAAT + 1;
				else
					out_width = C_BAAT + incA ;
			end
			//if (b_width == 1)
			//	out_width = C_BAAT + incA ;
			else if (b_width == 2 && C_B_TYPE == `c_signed && C_MULT_TYPE > 1)
				out_width = C_BAAT + 2 ;
			else if (b_width == 2 && C_B_TYPE == `c_signed && C_MULT_TYPE < 2)
				out_width = C_BAAT + 2 ;
			else
			begin
				if (C_B_TYPE == `c_unsigned)
					out_width = C_BAAT + C_B_WIDTH + incA ;
				else
					out_width = C_BAAT + C_B_WIDTH ;
			end
		end
		else if (C_MULT_TYPE > 1 && C_HAS_LOADB == 0)
		begin                                                                                              
		    
			//j = 0 ;
			for(i = 0; i < multWidth; i = i + 1)
			begin
				if(max_result[i] == 1)
					out_width = i+1 ;
			end
			tmp_out_width = out_width ;
			if (a_negative == 1 && b_negative == 1)
		     		out_width = out_width+1 ;
                     
			else if ((a_negative == 1 && b_negative == 0) || (a_negative == 0 && b_negative == 1))
			begin
		      max_result1 = max_result;
              if (power_2 == 1)                             //This section has been added to change the behaviour
               begin                                        //when one of the inputs is signed and the b-val is a 
                max_result1[multWidth] = 1;                  //power of 2.  This was failing in the original verison.
                    
	   	    		for(i = 0; i <= multWidth; i = i + 1)
	   	    		begin
			    		if(max_result1[i] == 1)
	   		    			tmp_out_width = i+1 ;
	  		    	end
			    	for(i = 0; i <= tmp_out_width; i = i + 1)//< tmp_out_width; i = i + 1)
			    	begin
			    		if(max_result1[i] == 0)
			    			out_width = i+2 ;
			    	end
                     
                 end
               else if ((power_2 !=1))                        // Original statement
                begin   
                    for (i = 0; i <= multWidth; i = i + 1)
			    	begin
			    		max_result[i] = ~max_result[i] ;
			    	end
			    	max_result = add(max_result, one) ;
	   		    	for(i = 0; i <= multWidth; i = i + 1)
	   		    	begin
			    		if(max_result[i] == 1)
	   		    			tmp_out_width = i+1 ;
	  		    	end
			    	for(i = 0; i < tmp_out_width; i = i + 1)
			    	begin
			    		if(max_result[i] == 0)
			    			out_width = i+2 ;
			    	end
                 end       
                end    
			
			if (C_HAS_A_SIGNED == 1 && C_B_TYPE == `c_unsigned)
				out_width = out_width + 1 ;
		end
		else
		begin
			if (C_HAS_A_SIGNED == 1 && C_B_TYPE == `c_unsigned)
				out_width = C_A_WIDTH + C_B_WIDTH + 1 ;
			else
				out_width = C_A_WIDTH + C_B_WIDTH ;
		end

		//Calculate the output width of the sequential multiplier.
		//sqm_cutoff_size = (out_width + 1 + (C_BAAT*(no_of_cycles-1))) - (((no_of_cycles)*C_BAAT) - C_A_WIDTH) ;
        sqm_cutoff_size = C_A_WIDTH+C_B_WIDTH+C_HAS_A_SIGNED;   //(C_OUT_WIDTH < C_A_WIDTH+C_B_WIDTH+C_HAS_A_SIGNED ? C_OUT_WIDTH : C_A_WIDTH+C_B_WIDTH+C_HAS_A_SIGNED);
   
   
		//Clear the sequential multiplier components that need clearing at the start.
		for (i = 0; i < multWidth; i = i + 1)
		begin
			feedback[i] = 0 ;
			accum_out[i] = 0 ;
			store[i] = 0 ;
			total_output[i] = 0 ;
		end

		//Calculate the shift bits
		if (C_MULT_TYPE != 2) 
		begin
			shift_bits = 0 ;
		end
		else
		begin
			shift_bits = 0 ;
			for(i = C_B_WIDTH-1; i >= 0; i = i - 1)
			begin
				if (b_value[i] == 1)
					shift_bits = i ;
			end
		end

		if ((C_B_TYPE == `c_unsigned && (b_width-shift_bits) == 1 && C_HAS_LOADB == 0) || (C_HAS_LOADB == 0 && b_width == 0))
		begin
			if(C_BAAT == C_A_WIDTH)
			begin
				real_latency = 0 ;
				if(C_MULT_TYPE == 2 &&
					B_INPUT[0] == 0 &&
		   			b_width == 0)
					begin
		   				b_is_zero = 1 ;
						b_is_one = 0 ;
					end
				else if(C_MULT_TYPE == 2 &&
					B_INPUT[0] == 1 &&
		   			b_width == 1)
					begin
						b_is_zero = 0 ;
						b_is_one = 1 ;
					end
				else
				begin
					b_is_zero = 0 ;
					b_is_one = 0 ;
				end
			end
			else
			begin
				real_latency = C_LATENCY - C_LATENCY_nonseq ;
				b_is_zero = 0 ;
				b_is_one = 0 ;
			end
		end
		else
		begin
			real_latency = C_LATENCY ;
			b_is_zero = 0 ;
			b_is_one = 0 ;
		end

        if (C_BAAT == C_A_WIDTH && C_MULT_TYPE < 2 && C_REG_A_B_INPUTS == 0 && C_HAS_ND == 1 && real_latency > 2)
	    begin
	       real_latency = C_LATENCY - 1;
		end

		if(b_is_zero == 1)
		begin
			intQpipe[0] <= `all0s ;
			intQ_int <= `all0s ;
		end

	end

	always@(intQ_nopipe)
	begin
		if(real_latency == 0 && C_REG_A_B_INPUTS == 0 && C_BAAT == C_A_WIDTH && C_HAS_ND == 1) //&& C_LATENCY != 0)
			intQ_int <= intQ_nopipe ;
	end

	always@(intQ)
	begin
		if(~(real_latency == 0 && C_REG_A_B_INPUTS == 0 && C_BAAT == C_A_WIDTH && C_HAS_ND == 1)) //&& C_LATENCY != 0)
		
			intQ_int <= intQ ;
	end

	always@(initial_intCLK)
	begin
		last_clk <= intCLK ;
		intCLK <= initial_intCLK ;
	end

	//Process to calculate output when the clears go high.
	//In addition action on the SWAPB and LOADB pins also cause the sequential multiplier to 
	//de-assert RFD.
	always@(intACLR or posedge intSCLR or  negedge intLOAD_DONE_sub or posedge intSWAPB)
	begin
		if (intACLR == 1 || intSCLR == 1 || intLOAD_DONE_sub == 0 || intSWAPB == 1)
		begin
			if (C_BAAT < C_A_WIDTH || ((intACLR == 1 || intSCLR == 1) && (real_latency != 0 || C_REG_A_B_INPUTS == 1 || C_HAS_Q == 1)) || (intLOAD_DONE_sub && C_HAS_SWAPB == 0))
				intRFD = 0 ;
			if (intACLR == 1)
				regRFD = 0 ;
			if(intACLR == 1 || intSCLR == 1)
				cycle = no_of_cycles+1 ;

			if (C_HAS_ACLR == 1 && intACLR == 1)
			begin
				loadb_count = -1 ;
				intLOAD_DONE = 1 ;
			end

			if ((C_BAAT == C_A_WIDTH) && (intACLR == 1))
			begin
				if ((c_pipe == 1 && real_latency > 0) || (C_REG_A_B_INPUTS == 1))
				begin
					intA = `aall0s ;
					if(C_MULT_TYPE < 2)
						intB = `ball0s ;
				end
				if (c_pipe == 1 && real_latency > 0 && (~(real_latency == 1 && C_MEM_TYPE == `c_dp_block && C_MULT_TYPE > 1))) // This section has been changed to fix an error with 
				begin																																															// the ACLR signla in conjunction with the block memory.
					for(i = 0; i <= C_LATENCY; i = i + 1)																																														// Added by allanf 28/02/01	
				begin
						intQpipe[i] = `mall0s ;
					end
				end
//				if (c_pipe == 1 && real_latency > 0)
//				begin
//					for(i = 0; i <= C_LATENCY; i = i + 1)
//					begin
//						intQpipe[i] = `mall0s ;
//					end
//				end

				intQ_nopipe = `all0s ;
			end
			else if (C_BAAT < C_A_WIDTH && intACLR == 1)
			begin
				regND_seq <= 0 ;
				for(i = 0; i < no_of_cycles-C_REG_A_B_INPUTS; i = i + 1)
				begin
					intRFD_delay[i] = 0;
				end
				if (C_LATENCY_nonseq != 0)
				begin
					if (C_REG_A_B_INPUTS == 1)
					begin
						tmpA <= `aall0s ;
						if(C_MULT_TYPE < 2)
							tmpB <= `ball0s ;
					end
					tmpAB <= `mall0s ;
					product <= `mall0s ;
				end
				if(C_REG_A_B_INPUTS == 1)
				begin
					intA <= `aall0s ;
					if(C_MULT_TYPE < 2)
						intB <= `ball0s ;
				end
				intO <= `mall0s ;
				feedback <= `mall0s ;
				store <= `mall0s ;
				accum_out <= `mall0s ;
			end
		end
	end

	//Process to examine the inputs when the clear signals go low again.
	always@(negedge intACLR or negedge intSCLR)
	begin
		if (intACLR == 0 && intSCLR == 0)
		begin
			intRFD = 1 ;
			if (C_BAAT == C_A_WIDTH)
			begin
				if ((c_pipe == 1 && real_latency > 0) || (C_REG_A_B_INPUTS == 1))
				begin
					//if ((intND == 1 || C_HAS_ND == 0 || (serial_adjust == 1 && C_HAS_ND == 1)) && intRFD == 1)
					//begin
						if (C_REG_A_B_INPUTS == 1)
						begin
							intA = regA ;
							intB = regB ;
							intA_SIGNED = A_SIGNED ;
						end
						else if (C_REG_A_B_INPUTS == 0)
						begin
							intA = A ;
							intB = B_INPUT ;
							intA_SIGNED = A_SIGNED ;
						end
					//end
				end
			end
			else if (C_BAAT < C_A_WIDTH)
			begin
				if (intND == 1  && ((C_REG_A_B_INPUTS == 0 && intRFD == 1)||(C_REG_A_B_INPUTS == 1 && regRFD == 1)))
				begin
					if (C_REG_A_B_INPUTS == 1)
					begin
						intA = regA ;
						intB = regB ;
						intA_SIGNED = regA_SIGNED ;
					end
					else if (C_REG_A_B_INPUTS == 0)
					begin
						intA = A ;
						intB = B_INPUT ;
						intA_SIGNED = A_SIGNED ;
					end
				end
			end
		end
	end

//Process to examine the inputs when the Load_done goes high or swapb goes low
	always@(posedge intLOAD_DONE_sub or negedge intSWAPB)
	begin
		if (intACLR == 0 && intSCLR == 0)
		begin
			intRFD = 1 ;
			if (C_BAAT == C_A_WIDTH)
			begin
				if ((c_pipe == 1 && real_latency > 0) || (C_REG_A_B_INPUTS == 1))
				begin
					if ((intND == 1 || C_HAS_ND == 0 || (serial_adjust == 1 && C_HAS_ND == 1)) && intRFD == 1)
					begin
						if (C_REG_A_B_INPUTS == 1)
						begin
							intA = regA ;
							intB = regB ;
							intA_SIGNED = A_SIGNED ;
						end
						else if (C_REG_A_B_INPUTS == 0)
						begin
							intA = A ;
							intB = B_INPUT ;
							intA_SIGNED = A_SIGNED ;
						end
					end
				end
			end
			else if (C_BAAT < C_A_WIDTH)
			begin
				if (intND == 1  && ((C_REG_A_B_INPUTS == 0 && intRFD == 1)||(C_REG_A_B_INPUTS == 1 && regRFD == 1)))
				begin
					if (C_REG_A_B_INPUTS == 1)
					begin
						intA = regA ;
						intB = regB ;
						intA_SIGNED = regA_SIGNED ;
					end
					else if (C_REG_A_B_INPUTS == 0)
					begin
						intA = A ;
						intB = B_INPUT ;
						intA_SIGNED = A_SIGNED ;
					end
				end
			end
		end
	end

	//Choose between registered and non-registered inputs
	always@(A or B_INPUT or regA or regB or A_SIGNED or regA_SIGNED or intLOAD_DONE_sub or posedge intND or intSWAPB) //or posedge intND)
	begin
		if(C_BAAT == C_A_WIDTH) //Not sequential.
		begin
			if (C_HAS_LOADB == 1 && C_HAS_SWAPB == 0 && intLOAD_DONE_sub == 0 )
				RFD_int = 0 ;
			else
				RFD_int = 1 ;
	
			//If there's no ND then we change the internal signals as soon as the 
			//inputs change. Otherwise we make sure that ND is high and RFD is also.
			if(C_HAS_ND == 0 || (C_REG_A_B_INPUTS == 0 && real_latency == 0))
			begin
				if (C_REG_A_B_INPUTS == 0)
				begin
					intA = A ;
					intB = B_INPUT ;
					intA_SIGNED = A_SIGNED ;
				end
				else
				begin
					intA = regA ;
					intB = regB ;
					intA_SIGNED = regA_SIGNED ;
				end
			end
			else if (C_REG_A_B_INPUTS == 0 && C_HAS_ND == 1 && intND == 1 && RFD_int == 1)
			begin
				intA = A ;
				intA_SIGNED = A_SIGNED ;
			end
			else if (C_REG_A_B_INPUTS == 1 && C_HAS_ND == 1 && intND == 1 && RFD_int == 1)
			begin
				intA = regA ;
				intA_SIGNED = regA_SIGNED ;
			end
			//If it's not a constant co-efficient multiplier then we wait for 
			//ND to go high before changing B. If it a ccm or a rccm then ND is 
			//irellevant when changing the B value.
			if (C_REG_A_B_INPUTS == 0 && C_HAS_ND == 1 && intND == 1 && C_MULT_TYPE < 2)
				intB = B_INPUT ;
			else if (C_REG_A_B_INPUTS == 1 && C_HAS_ND == 1 && intND == 1 && C_MULT_TYPE < 2)
				intB = regB ;
			else if (C_REG_A_B_INPUTS == 0 && C_MULT_TYPE > 1)
				intB = B_INPUT ;
			else if (C_REG_A_B_INPUTS == 1 && C_MULT_TYPE > 1)
				intB = regB ;
		end
		else if (C_BAAT < C_A_WIDTH && C_REG_A_B_INPUTS == 0) //Sequential with non-registered inputs.
		begin
			if (C_HAS_SWAPB == 1 && intSWAPB == 1)
			begin
				intB = B_INPUT ;
			end
			if ((intND == 1) && (intRFD == 1) && C_HAS_ND == 0)
			begin
				intA = A ;
				intB = B_INPUT ;
				intA_SIGNED = A_SIGNED ;
			end
		end
	end

	//For a sequential multiplier with registered inputs we wait for the rising edge of the 
	//clock before changing the internal signals.
	always@(posedge intCLK)
	begin
		if(C_BAAT < C_A_WIDTH && intCE == 1 && C_REG_A_B_INPUTS == 0 && C_HAS_ND == 1 && intND == 1 && intRFD == 1)
		begin
			intA_SIGNED = A_SIGNED ;
			intA = A ;
			intB = B_INPUT ;
		end
		if (C_BAAT < C_A_WIDTH && C_REG_A_B_INPUTS == 1 && intCE == 1 && intACLR == 0 && intSCLR == 0)
		begin
			if (C_HAS_LOADB == 1 && C_HAS_SWAPB == 0 && intLOAD_DONE_sub == 0)
			begin
				intB = `ballxs;
			end
			if (C_HAS_SWAPB == 1 && regSWAPB == 1)
			begin
				intB = regB ;
			end
			//if ((intND == 1 || (serial_adjust == 1 && C_HAS_ND == 1)) && (regRFD == 1))
			if ((intND == 1) && (regRFD == 1))
			begin
				intA = regA ;
				intB = regB ;
				intA_SIGNED = regA_SIGNED ;
			end
		end
	end

	//Generate the RFD for the sequential multiplier.
	always@(ND or intRFD or intRFD_delay)
	begin
		if (no_of_cycles > 2 && intACLR == 0 && intLOAD_DONE_sub == 1 && intSWAPB == 0)
		begin
			if (C_HAS_ND == 1)
				intRFD_noreg = (intRFD_delay[0] & ~intRFD) | (intRFD & ~ND) ;
			else
				intRFD_noreg = (intRFD_delay[0] & ~intRFD) ;
		end
		else if (no_of_cycles == 2 && intACLR == 0 && intLOAD_DONE_sub == 1 && intSWAPB == 0)
		begin
			if (C_HAS_ND == 1)
				intRFD_noreg = (~intRFD) | (intRFD & ~ND) ;
			else
				intRFD_noreg = ~intRFD ;
		end
	end

	//Split the A input for the sequential multiplier
	always@(posedge intCLK)
	begin
		if ((C_BAAT < C_A_WIDTH) )
		begin

			if (intCE == 1)
			begin
				//The swapb and loadb signals need to be delayed to take into account the input latency 
				//to the internal multiplier.
				if(C_REG_A_B_INPUTS == 1)
				begin
					intSWAPB_pipe[0] <= intSWAPB ;
					intSWAPB_pipe[1] <= intSWAPB_pipe[0] ;
				end
				else
				begin
					intSWAPB_pipe[1] <= intSWAPB ;
				end
				intLD_pipe[1] <= intLD_pipe[0] ;
				intLD_pipe[0] <= intLOAD_DONE_sub ;
			end

			if (intND == 1 && intCLK == 1 && intCE == 1 && ((C_REG_A_B_INPUTS == 0 && intRFD == 1)||(C_REG_A_B_INPUTS == 1 && regRFD == 1))) //&& new_data_present == 1)
			begin
				cycle_discarded = 0 ;
				//We only need to split up the input bus if the multiplier has a parallel 
				//input (C_SQM_TYPE == 0). Otherwise we just take the a input as it is.
				if (C_SQM_TYPE == 0) 
				begin
					for (j = 0; j < no_of_cycles*C_BAAT; j = j + 1)
					begin
						if (j < C_A_WIDTH)
						begin
							intA_seq[j] = intA[j] ;
							if (((j % C_BAAT) == 0) && (j != 0))
							begin
								intA_seq_pipe[(j/C_BAAT)-1] = slice ;
							end
							slice[(j % C_BAAT)] = intA[j] ;
						end
						else if ((C_A_TYPE == `c_signed && C_HAS_A_SIGNED == 0) || (C_HAS_A_SIGNED == 1 && intA_SIGNED === 1'b1)) 
						begin
							intA_seq[j] = intA[C_A_WIDTH-1] ;
							slice[(j % C_BAAT)] = intA[C_A_WIDTH-1] ;
						end
						else if ((C_A_TYPE == `c_unsigned && C_HAS_A_SIGNED == 0) || (C_HAS_A_SIGNED == 1 && intA_SIGNED === 1'b0)) 
						begin
							intA_seq[j] = 1'b0 ;
							slice[(j % C_BAAT)] = 1'b0 ;
						end
						if (j == (no_of_cycles*C_BAAT)-1)
						begin
							intA_seq_pipe[no_of_cycles-1] = slice ;
						end
						cycle = 1 ;
						new_data_present = 0 ;
					end
				end
				else if (C_SQM_TYPE == 1)
				begin
					cycle = 1 ;
					new_data_present = 0 ;
				end
				loading <= 0 ;
			end
			//At the end of the multiplication cycle has clocked up to be equal to the 
			//no_of_cycles variable. When this happens we set the ready output high 
			//for 1 clock cycle.
			if ((cycle == no_of_cycles && (intCE == 1 && seqRDY == 0))
			 || (cycle == no_of_cycles+1 && (intCE == 0 && seqRDY == 1)))
			begin
				if (((C_HAS_SWAPB == 1 || intLD_pipe[1] == 1) && (C_HAS_SWAPB == 0 || intSWAPB_pipe[1] == 0) && cycle_discarded == 0) || no_of_cycles == 2) //) || no_of_cycles == 2)
					seqRDY = 1 ;
			end
			else if (seqRDY == 1)
			begin
				seqRDY = 0 ;
			end
			//If we're loading and there isn't a swapb pin the output of the multiplier
			//is set to be all X's.
			if (intLOAD_DONE_sub == 0)
			begin
				loading <= 1 ;
				for(i = 0; i < multWidth; i = i + 1) 
				begin
					tmpB[i] = 1'bx ;
					product[i] = 1'bx ;
				end
				if (cycle != no_of_cycles && cycle != no_of_cycles-1 && cycle != no_of_cycles-2 )
					cycle_discarded = 1 ;
				if (cycle < no_of_cycles+2)
					cycle = cycle + 1 ;
			end
			else if (cycle > 0 && intCE == 1) 
			begin
				//The A input is sign extended if it's signed. This only happens on the 
				//last cycle as the previous partial products are treated as unsigned.
				//In other cases it is zero extended.
				if (((C_A_TYPE == `c_signed && C_HAS_A_SIGNED == 0) || (C_HAS_A_SIGNED == 1 && intA_SIGNED == 1)) && (cycle == no_of_cycles) && (intSWAPB_pipe[1] == 0))
				begin
				    for(j = multWidth-1; j >= C_BAAT; j = j - 1)
				    begin
						if (C_SQM_TYPE == 0)
							tmpA[j] = intA[(C_A_WIDTH-1)-((C_A_WIDTH-1)*C_SQM_TYPE)] ;
						else if (C_REG_A_B_INPUTS == 1)
							tmpA[j] = regA[(C_A_WIDTH-1)-((C_A_WIDTH-1)*C_SQM_TYPE)] ;
						else if (C_REG_A_B_INPUTS == 0)
							tmpA[j] = A[(C_A_WIDTH-1)-((C_A_WIDTH-1)*C_SQM_TYPE)] ;
				    end
			    end
				else if ((C_HAS_A_SIGNED == 1 && intA_SIGNED === 1'bx) && (cycle == no_of_cycles) && intSWAPB == 0)
				begin
				    for(j = multWidth-1; j >= C_BAAT; j = j - 1)
				    begin
						tmpA[j] = 1'bx ;
				    end
			    end
			    else
			    begin
				    for(j = multWidth-1; j >= C_BAAT; j = j - 1)
				    begin
		                tmpA[j] = 0;
				    end
			    end
				tmpA_SIGNED = intA_SIGNED ;
				if (cycle < no_of_cycles+1)
				begin
					if (C_SQM_TYPE == 0)
						tmpA[C_BAAT-1 : 0] = intA_seq_pipe[cycle-1];
					else if (C_REG_A_B_INPUTS == 1)
						tmpA[C_BAAT-1 : 0] = regA ;
					else if (C_REG_A_B_INPUTS == 0)
						tmpA[C_BAAT-1 : 0] = A ;
					tmpA_SIGNED = intA_SIGNED ;
				end
				else if ((cycle >= no_of_cycles+1) && ((C_A_TYPE == `c_signed && C_HAS_A_SIGNED == 0 && tmpA[C_BAAT-1] == 1) || (C_HAS_A_SIGNED == 1 && intA_SIGNED == 1)))
				begin
					if (C_SQM_TYPE == 0)
					begin
						for (i = 0; i < C_BAAT; i = i + 1) 
						begin
							tmpA[i] = intA[C_A_WIDTH-1] ; 
						end
						for (i = C_BAAT; i < multWidth; i = i + 1)
						begin
							tmpA[i] = 0 ;
						end
					end
					else
					begin
						if (C_REG_A_B_INPUTS == 1)
							tmpA[0] = regA[0] ;
						else
							tmpA[0] = A[0] ;
					end
					tmpA_SIGNED = intA_SIGNED ;
				end
				else if (cycle >= no_of_cycles+1)
				begin
					if (C_SQM_TYPE == 0)
					begin
						for (i = 0; i < multWidth; i = i + 1)
						begin
							if(intA[C_A_WIDTH-1] === 1'bx)
								tmpA[i] = 1'bx ;
							else
								tmpA[i] = 0 ;
						end
					end
					else
					begin
						if (C_REG_A_B_INPUTS == 1)
							tmpA[0] = regA[0] ;
						else
							tmpA[0] = A[0] ;
					end
					tmpA_SIGNED = intA_SIGNED ;
				end

				//For the B input we sign extend if C_B_TYPE is signed.
				if (C_B_TYPE == `c_signed)
				begin
				    for(j = multWidth-1; j >= 0; j = j - 1)
				    begin
						if (j >= b_width)
				        	tmpB[j] = intB[b_width-1];
						else
							tmpB[j] = intB[j] ;
				    end
			    end
			    else if(C_B_TYPE == `c_unsigned)
			    begin
				    for(j = multWidth-1; j >= 0; j = j - 1)
				    begin
						if (j >= b_width)
		                	tmpB[j] = 0;
						else
							tmpB[j] = intB[j] ;
				    end
			    end

				//When the multiplier is not a ccm or rccm then we set the output 
				//to be all 0's if both of the inputs are zero.
				if (((tmpA == `aall0s) || (tmpB == `ball0s)) && C_MULT_TYPE < 3)
				begin
					for (i = 0; i < multWidth; i = i + 1)
					begin
						product[i] = 0 ;
					end
				end
				else
				begin
					if(C_MULT_TYPE > 2 && B_INPUT == `ballxs)
					begin
						for(i = 0; i < multWidth; i = i + 1) 
						begin
							product[i] = 1'bx ;
						end
					end
					else
					begin
						product = tmpA * tmpB ;
					end
				end

				//If either of the inputs are signed then we sign 
				//extend the product.
				if (C_B_TYPE == `c_signed || (C_A_TYPE == `c_signed && C_HAS_A_SIGNED == 0) || (C_HAS_A_SIGNED == 1 && intA_SIGNED == 1))
				begin
				    for(j = multWidth-1; j >= 0; j = j - 1)
				    begin
						if (j >= out_width)
				        	product[j] = product[out_width-1];
						else
							product[j] = product[j] ;
				    end
			    end
			    else
			    begin
				    for(j = multWidth-1; j >= 0; j = j - 1)
				    begin
						if (j >= out_width)
		                	product[j] = 0;
						else
							product[j] = product[j] ;
				    end
			    end
			  
				//Clock up the cycle variable.
				if ((cycle == no_of_cycles) && (seqRDY == 0))
				begin
					cycle = cycle + 1 ;
				end
				else if (seqRDY == 1)
				begin
					cycle = cycle + 1 ;
				end
				else if (cycle < no_of_cycles+2)  
				begin
					cycle = cycle + 1 ;
				end
			end

			//Now perform the partial product calculation.
			if (cycle > 0 && intCE == 1) 
			begin
				if (cycle == 2) 
					accum_out = add(product, zero) ;
				else
					accum_out = add(product, feedback) ;
				
				if (is_X(accum_out))							 // output error during the load cycle
							for (i = 0;i < multWidth-1; i = i + 1) //
							begin																	//
								accum_out[i] = 1'bx;                      //
							end       

				for (i = 0; i < out_width-C_BAAT+inc+dec; i = i + 1)
				begin
					feedback[i] = accum_out[i+C_BAAT] ;
				end
				for (i = out_width-C_BAAT+inc+dec; i < multWidth; i = i + 1)
				begin
					if (C_B_TYPE == `c_signed)
						feedback[i] = feedback[out_width-C_BAAT-1+inc+dec] ; //was +1
					else
						feedback[i] = 0 ;
				end

				for (i = 0; i < multWidth; i = i + 1)
				begin
					if (C_HAS_LOADB == 1 && loading == 1 )								 	// this has been added to remove an
					begin
						if (is_X(store) || is_X(accum_out))							 // output error during the load cycle
							for (i = 0;i < multWidth-1; i = i + 1) //
							begin																	//
								tmpAB[i] = 1'bx;                      //
							end                                     //
					end				                                    //
					else                                         //
						if (i < (no_of_cycles-1)*C_BAAT)
						begin
							tmpAB[i] = store[i] ;
						end
						else
						begin
						tmpAB[i] = accum_out[i - (C_BAAT*(no_of_cycles-1))] ;
						end
				end
				for ( i = C_BAAT; i < multWidth; i = i + 1)
				begin
					store[i-C_BAAT] = store[i] ;
				end
				store[(C_BAAT*(no_of_cycles-1))-1 : C_BAAT*(no_of_cycles-2)] = accum_out[C_BAAT-1 : 0] ;
				product_delayed = product ;
			end
		end
	end

	//Do the multiplication for the non-sequential multipliers. This process is only called 
	//when the multiplier doesn't have an ND input or the ND input is ignored due to there 
	//not being any registers in the design.
	//always@(posedge intCLK)
	always@(intA or intB or intA_SIGNED)
	begin
		if (C_BAAT == C_A_WIDTH && (C_HAS_ND == 0 || (C_REG_A_B_INPUTS == 0 && (real_latency == 0 || (real_latency == 1 && nd_adjust == 0))) || (C_REG_A_B_INPUTS == 1 && (real_latency == 1 && nd_adjust == 0))))
		begin
			//Sign extend the A input.
			if ((C_A_TYPE == `c_signed && C_HAS_A_SIGNED == 0) || (C_HAS_A_SIGNED == 1 && intA_SIGNED === 1'b1))
			begin
			    for(j = multWidth-1; j >= C_A_WIDTH; j = j - 1)
			    begin
			        tmpA[j] = intA[C_A_WIDTH-1];
			    end
		    end
			else if(C_HAS_A_SIGNED == 1 && intA_SIGNED === 1'bx)
		    begin
			    for(j = multWidth-1; j >= C_A_WIDTH; j = j - 1)
			    begin
	                tmpA[j] = 1'bx;
			    end
		    end
		    else if((C_A_TYPE == `c_unsigned && C_HAS_A_SIGNED == 0) || (C_HAS_A_SIGNED == 1 && intA_SIGNED == 0))
		    begin
			    for(j = multWidth-1; j >= C_A_WIDTH; j = j - 1)
			    begin
	                tmpA[j] = 0;
			    end
		    end
			tmpA[C_A_WIDTH-1 : 0] = intA;
			tmpA_SIGNED = intA_SIGNED ;

			//Sign extend the B input.
			if (C_B_TYPE == `c_signed)
			begin
				for(j = multWidth-1; j >= 0; j = j - 1)
			    begin
					if (j >= b_width)
			        	tmpB[j] = intB[b_width-1];
					else
						tmpB[j] = intB[j] ;
			    end
		    end
		    else if(C_B_TYPE == `c_unsigned)
		    begin
				for(j = multWidth-1; j >= 0; j = j - 1)
			    begin
					if (j >= b_width)
	                	tmpB[j] = 0;
					else
						tmpB[j] = intB[j] ;
			    end
		    end

			//In some occasions to make the model match the netlist we have to set the 
			//output to zero if either of the inputs are all zero.
			if ((tmpA == `aall0s && C_HAS_LOADB == 0 && C_MULT_TYPE != 1) || (tmpB == `ball0s && C_MULT_TYPE < 3))
			begin
				tmpAB = `mall0s ;
			end
			else if (C_MULT_TYPE == 3 && C_HAS_LOADB == 1 && C_HAS_SWAPB == 0 && intLOAD_DONE_sub == 0)
			begin
				//If we're loading and there's no SWAPB pin present then we set the output to all X's.
				for (i = 0; i < multWidth; i = i + 1)
				begin
					tmpAB[i] = 1'bx ;
				end
			end
			else if ((C_MULT_TYPE == 0 || C_MULT_TYPE == 2) && (C_A_WIDTH > C_OUT_WIDTH) && (((intA[(C_A_WIDTH-1):(C_A_WIDTH-C_OUT_WIDTH)] == `all0s) && C_HAS_LOADB == 0 && C_MULT_TYPE != 1) && ~((C_B_TYPE == `c_signed) && ((intB[C_B_WIDTH - 1] == 1) || (intB[C_B_WIDTH - 1] === 1'bx)))))
			begin
				//If the output width is smaller than the A width and the A value is such that the 
				//product will never be a high enough value to give a non-zero output then we set 
				//the output to be all 0's.
				tmpAB = `mall0s ;
			end
			else if ((C_MULT_TYPE == 0 || C_MULT_TYPE == 2) && (C_B_WIDTH > C_OUT_WIDTH) && ((intB[(C_B_WIDTH-1):(C_B_WIDTH-C_OUT_WIDTH)] == `all0s) && ~((C_A_TYPE == `c_signed && C_HAS_A_SIGNED == 0 && ((intA[C_A_WIDTH - 1] == 1) || (intA[C_A_WIDTH - 1] === 1'bx))) || (C_HAS_A_SIGNED == 1 && intA_SIGNED == 1 && ((intA[C_A_WIDTH - 1] == 1) || (intA[C_A_WIDTH - 1] === 1'bx))))))
			begin
				//If the output width is smaller than the B width and the B value is such that the 
				//product will never be a high enough value to give a non-zero output then we set 
				//the output to be all 0's.
				tmpAB = `mall0s ;
			end
			else if (C_MULT_TYPE == 1 && tmpB == `ballxs)
			begin
				for (i = 0; i < multWidth; i = i + 1)
				begin
					tmpAB[i] = 1'bx ;
				end
			end
			else
			begin
				tmpAB = tmpA * tmpB ;
			end
        end
	end

	//Do the multiplication for the non-sequential multipliers with new data.
	//This is the same as the process above but we wait for the rising edge of the 
	//clock when there is a new data pin present.
	always@(posedge intCLK)
	begin
	  if (C_BAAT != C_A_WIDTH || C_MULT_TYPE >= 2 || C_REG_A_B_INPUTS == 1 || C_HAS_ND == 0 || C_LATENCY <= 2)
	  begin
		if (real_latency == 0 && C_REG_A_B_INPUTS == 1 && (C_HAS_SWAPB == 1 && SWAPB == 1) && C_BAAT == C_A_WIDTH)
		begin
			intB = B_INPUT ;
		end
		if (real_latency == 0 && C_REG_A_B_INPUTS == 1 && (C_HAS_ND == 1 && ND == 1) && C_BAAT == C_A_WIDTH)
		begin
			intA = A ;
			intB = B_INPUT ;
			intA_SIGNED = A_SIGNED ;
		end	
		if (C_BAAT == C_A_WIDTH && C_MULT_TYPE == 3 && C_HAS_LOADB == 1 && C_HAS_SWAPB == 0 && intLOAD_DONE_sub == 0)
		begin
			for (i = 0; i < multWidth; i = i + 1)
			begin
				tmpAB[i] = 1'bx ;
			end
		end
		else if (C_BAAT == C_A_WIDTH && (intND == 1 || (C_HAS_SWAPB == 1 && intSWAPB == 1) || (real_latency == 0 && C_REG_A_B_INPUTS == 1 && C_HAS_ND == 1 && ND == 1)) && ~(C_HAS_ND == 0 || (C_REG_A_B_INPUTS == 0 && (real_latency == 0 || (real_latency == 1 && nd_adjust == 0)) || (C_REG_A_B_INPUTS == 1 && (real_latency == 1 && nd_adjust == 0)))))
		begin
			if ((intND == 1 || (real_latency == 0 && C_REG_A_B_INPUTS == 1 && C_HAS_ND == 1 && ND == 1)) && ~(C_HAS_ND == 0 || (C_REG_A_B_INPUTS == 0 && (real_latency == 0 || (real_latency == 1 && nd_adjust == 0)))))
			begin
				if ((C_A_TYPE == `c_signed && C_HAS_A_SIGNED == 0) || (C_HAS_A_SIGNED == 1 && intA_SIGNED === 1'b1))
				begin
				    for(j = multWidth-1; j >= C_A_WIDTH; j = j - 1)
				    begin
				        tmpA[j] = intA[C_A_WIDTH-1];
			    	end
		    	end
				else if(C_HAS_A_SIGNED == 1 && intA_SIGNED === 1'bx)
		    	begin
			    	for(j = multWidth-1; j >= C_A_WIDTH; j = j - 1)
			    	begin
	                	tmpA[j] = 1'bx;
			    	end
		    	end
		    	else if((C_A_TYPE == `c_unsigned && C_HAS_A_SIGNED == 0) || (C_HAS_A_SIGNED == 1 && intA_SIGNED == 0))
		    	begin
			    	for(j = multWidth-1; j >= C_A_WIDTH; j = j - 1)
			    	begin
	            	    tmpA[j] = 0;
			    	end
		    	end
				tmpA[C_A_WIDTH-1 : 0] = intA;
				tmpA_SIGNED = intA_SIGNED ;
			end

			if (C_B_TYPE == `c_signed)
			begin
				for(j = multWidth-1; j >= 0; j = j - 1)
			    begin
					if (j >= b_width)
			        	tmpB[j] = intB[b_width-1];
					else
						tmpB[j] = intB[j] ;
			    end
		    end
		    else if(C_B_TYPE == `c_unsigned)
		    begin
				for(j = multWidth-1; j >= 0; j = j - 1)
			    begin
					if (j >= b_width)
	                	tmpB[j] = 0;
					else
						tmpB[j] = intB[j] ;
			    end
		    end

			if ((tmpA == `aall0s && C_HAS_LOADB == 0 && C_MULT_TYPE != 1) || (tmpB == `ball0s && C_MULT_TYPE < 3))
			begin
				tmpAB = `mall0s ;
			end
			else if ((C_A_WIDTH > C_OUT_WIDTH) && (((intA[(C_A_WIDTH-1):(C_A_WIDTH-C_OUT_WIDTH)] == `all0s) && C_HAS_LOADB == 0 && C_MULT_TYPE != 1) && ~((C_B_TYPE == `c_signed) && ((tmpB[C_B_WIDTH - 1] == 1) || (tmpB[C_B_WIDTH - 1] === 1'bx)))))
			begin
				tmpAB = `mall0s ;
			end
			else if ((C_B_WIDTH > C_OUT_WIDTH) && ((intB[(C_B_WIDTH-1):(C_B_WIDTH-C_OUT_WIDTH)] == `all0s) && C_HAS_LOADB == 0 && ~((C_A_TYPE == `c_signed && C_HAS_A_SIGNED == 0 && ((tmpA[C_A_WIDTH - 1] == 1) || (tmpA[C_A_WIDTH - 1] === 1'bx))) || (C_HAS_A_SIGNED == 1 && tmpA_SIGNED == 1 && ((tmpA[C_A_WIDTH - 1] == 1) || (tmpA[C_A_WIDTH - 1] === 1'bx))))))
			begin
				tmpAB = `mall0s ;
			end
			else if (C_MULT_TYPE == 1 && tmpB == `ballxs)
			begin
				for (i = 0; i < multWidth; i = i + 1)
				begin
					tmpAB[i] = 1'bx ;
				end
			end
			else
			begin
				tmpAB = tmpA * tmpB ;
			end
        end
	  end
	end

    always@(posedge intCLK)
	begin
	  if (C_BAAT == C_A_WIDTH && C_MULT_TYPE < 2 && C_REG_A_B_INPUTS == 0 && C_HAS_ND == 1 && C_LATENCY > 2)
	  begin
		if (regND_tmp == 1 && intCE == 1)
		begin
  		  if ((C_A_TYPE == `c_signed && C_HAS_A_SIGNED == 0) || (C_HAS_A_SIGNED == 1 && regA_SIGNED_tmp === 1'b1))
		  begin
		    for(j = multWidth-1; j >= C_A_WIDTH; j = j - 1)
	        begin
	          tmpA[j] = regA_tmp[C_BAAT-1];
	   	    end
		  end
		  else if(C_HAS_A_SIGNED == 1 && intA_SIGNED === 1'bx)
	   	  begin
	    	for(j = multWidth-1; j >= C_A_WIDTH; j = j - 1)
	    	begin
	          tmpA[j] = 1'bx;
	        end
	   	  end
	   	  else if((C_A_TYPE == `c_unsigned && C_HAS_A_SIGNED == 0) || (C_HAS_A_SIGNED == 1 && regA_SIGNED_tmp == 0))
	   	  begin
		    for(j = multWidth-1; j >= C_A_WIDTH; j = j - 1)
		    begin
              tmpA[j] = 0;
		    end
		  end
		  tmpA[C_A_WIDTH-1 : 0] = regA_tmp;
	      tmpA_SIGNED = regA_SIGNED_tmp ;

		  if (C_B_TYPE == `c_signed)
		  begin
			for(j = multWidth-1; j >= 0; j = j - 1)
		    begin
				if (j >= b_width)
		        	tmpB[j] = regB_tmp[b_width-1];
				else
					tmpB[j] = regB_tmp[j] ;
		    end
	      end
	      else if(C_B_TYPE == `c_unsigned)
	      begin
			for(j = multWidth-1; j >= 0; j = j - 1)
		    begin
				if (j >= b_width)
                	tmpB[j] = 0;
				else
					tmpB[j] = regB_tmp[j] ;
		    end
	      end

		  if ((tmpA == `aall0s && C_HAS_LOADB == 0 && C_MULT_TYPE != 1) || (tmpB == `ball0s && C_MULT_TYPE < 3))
		  begin
			  tmpAB = `mall0s ;
		  end
		  else if ((C_A_WIDTH > C_OUT_WIDTH) && (((intA[(C_A_WIDTH-1):(C_A_WIDTH-C_OUT_WIDTH)] == `all0s) && C_HAS_LOADB == 0 && C_MULT_TYPE != 1) && ~((C_B_TYPE == `c_signed) && ((tmpB[C_B_WIDTH - 1] == 1) || (tmpB[C_B_WIDTH - 1] === 1'bx)))))
		  begin
		  	tmpAB = `mall0s ;
		  end
		  else if ((C_B_WIDTH > C_OUT_WIDTH) && ((intB[(C_B_WIDTH-1):(C_B_WIDTH-C_OUT_WIDTH)] == `all0s) && C_HAS_LOADB == 0 && ~((C_A_TYPE == `c_signed && C_HAS_A_SIGNED == 0 && ((tmpA[C_A_WIDTH - 1] == 1) || (tmpA[C_A_WIDTH - 1] === 1'bx))) || (C_HAS_A_SIGNED == 1 && tmpA_SIGNED == 1 && ((tmpA[C_A_WIDTH - 1] == 1) || (tmpA[C_A_WIDTH - 1] === 1'bx))))))
		  begin
		  	tmpAB = `mall0s ;
		  end
		  else if (C_MULT_TYPE == 1 && tmpB == `ballxs)
		  begin
			for (i = 0; i < multWidth; i = i + 1)
			begin
				tmpAB[i] = 1'bx ;
			end
		  end
		  else
		  begin
			  tmpAB = tmpA * tmpB ;
		  end
       end
	  end
    end

	always@(intRDYpipe[0])
	begin
		if(C_BAAT == C_A_WIDTH && real_latency == 0 && C_MULT_TYPE == 2 && ((b_width-shift_bits) == 0 || b_is_zero == 1))
			intRDY = intRDYpipe[0] ;
		//else if (C_BAAT == C_A_WIDTH && real_latency == 0 && C_MULT_TYPE == 2 && b_is_one == 1 && C_REG_A_B_INPUTS == 1)
		//	intRDY = intRDYpipe[1];
	end

	//Pipelining, loadb generation.
	always@(posedge intCLK)
	begin
	if (intCLK == 1 && last_clk == 0)
	begin
		//Sequential multiplier needs a delayed version of the RFD to be able to 
		//Calculate the actual RFD and the ND signal (if none present).
		if (C_BAAT < C_A_WIDTH && intCE == 1 && intCLK == 1 && intACLR == 0 && intSCLR == 0 && intLOAD_DONE_sub == 1 && intSWAPB == 0)
		begin
			regRFD <= intRFD ;
			intRFD <= intRFD_noreg ;
			regND_seq <= ND ;
			if (no_of_cycles > 2)
			begin
				for(pipe1 = 0; pipe1 <= no_of_cycles-C_REG_A_B_INPUTS-3; pipe1 = pipe1 + 1)
				begin
					intRFD_delay[pipe1] <= intRFD_delay[pipe1+1];
				end
				if (C_REG_A_B_INPUTS == 1 && C_HAS_ND == 1)
					intRFD_delay[no_of_cycles-C_REG_A_B_INPUTS-2] <= regRFD & regND;
				else if (C_REG_A_B_INPUTS == 1 && C_HAS_ND == 0)
					intRFD_delay[no_of_cycles-C_REG_A_B_INPUTS-2] <= regRFD ;	
			 	else if (C_REG_A_B_INPUTS == 0 && C_HAS_ND == 1)
					intRFD_delay[no_of_cycles-C_REG_A_B_INPUTS-2] <= intRFD & ND;
				else if (C_REG_A_B_INPUTS == 0 && C_HAS_ND == 0)
					intRFD_delay[no_of_cycles-C_REG_A_B_INPUTS-2] <= intRFD ;	
			end
		end
		else if (C_BAAT < C_A_WIDTH && ((intCE == 1 && intSCLR == 1) || intSWAPB == 1 || intLOAD_DONE_sub == 0))
		begin
			regRFD <= intRFD ;
			regND_seq <= 0 ;
			for(i = 0; i < no_of_cycles-C_REG_A_B_INPUTS; i = i + 1)
			begin
				intRFD_delay[i] <= 0;
			end
		end

		//Cope with SCLR
		if (C_BAAT == C_A_WIDTH && intSCLR == 1)
		begin
			if ((C_PIPELINE == 1 && real_latency > 0) || (C_REG_A_B_INPUTS == 1))
			begin
				intA = `aall0s ;
				intB = `ball0s ;
			end
			if (C_PIPELINE == 1 && real_latency > 0)
			begin
				for(i = 0; i <= C_LATENCY; i = i + 1)
				begin
					intQpipe[i] = `mall0s ;
				end
			end
			intQ_nopipe = `all0s ;
		end
		else if (C_BAAT < C_A_WIDTH && intSCLR == 1 && intCE == 1)
		begin
			regRFD = 0 ;
			regND_seq <= 0 ;
			for(i = 0; i < no_of_cycles-C_REG_A_B_INPUTS; i = i + 1)
			begin
				intRFD_delay[i] = 0;
			end
			if (C_LATENCY_nonseq != 0 || C_REG_A_B_INPUTS == 1)
			begin
				if (C_REG_A_B_INPUTS == 1)
				begin
					tmpA <= `aall0s ;
					if(C_MULT_TYPE < 2)
						tmpB <= `ball0s ;
				end
				tmpAB <= `mall0s ;
				product <= `mall0s ;
			end
			intO <= `mall0s ;
			feedback <= `mall0s ;
			store <= `mall0s ;
			accum_out <= `mall0s ;
		end
		
		//Generate the RDY signal for the multipliers.
		if (C_BAAT == C_A_WIDTH && intCE == 1)
		begin
			regLOAD_DONE_sub <= intLOAD_DONE_sub ;
			if (intRDY == 1)
				intQCLK_nopipe = 1 ;
			else
				intQCLK_nopipe = 0 ;
       //new line (special case)
        if (C_BAAT == C_A_WIDTH && b_is_one == 1 && C_HAS_ND == 1 && C_MULT_TYPE == 2 && (C_LATENCY > 0 || nd_adjust > 0))//&& C_REG_A_B_INPUTS == 1 
              intRDY = intRDYpipe[1] ;
  	    else if (C_BAAT < C_A_WIDTH || real_latency > 0 || C_MULT_TYPE != 2 || (b_width-shift_bits) != 0)
		    intRDY = intRDYpipe[0] ;
		end
		else if (C_BAAT < C_A_WIDTH && intCE == 1 )
		
		RDYpipe_has_one = 1'b0;
        invalidRDY = 1'b0;
        for (i = 0; i < C_LATENCY+nd_adjust+1; i = i +1)
		    begin	
			    if (intRDYpipe[i] == 1)
			        if ((C_BAAT == C_A_WIDTH) && intLOADB == 1 && i == ((C_LATENCY+nd_adjust)-1) && C_HAS_SWAPB == 0 )
			   		invalidRDY = 1'b1;
                    else
                    RDYpipe_has_one = 1'b1; //this is used to show there is a RDY pulse in RDY pipeline
		    end
        begin
			
            if ((C_BAAT == C_A_WIDTH) && C_HAS_ND == 0 && C_HAS_RDY == 1) //added 19/6/01 to fix parallel RDY bug
                intRDY = 1;     // For a Parallel mult without ND, RDY tied high
            else if (C_HAS_LOADB == 1 && intLOADB == 1 && C_HAS_ND == 0 && b_is_one == 1 )// Added to fix sqm_rccm for cases
				intRDY = intRDYpipe[1];											     // with b = constant and b = 1
			else if (intCE == 1 && C_HAS_LOADB == 1 && intLOADB == 1 && C_HAS_LOAD_DONE == 1 &&  C_HAS_SWAPB == 0 && C_HAS_ND == 0) // Added to fix sqm_rccm RDY bug 14/02/01
				if (RDYpipe_has_one == 1)
					intRDY = intRDYpipe[0] ; // this allows the RDY pulse in pipeline to be propagated to output
				else	
				intRDY = 1'b0;	// used if no RDY pulse in pipeline																					
			
            else if ((C_BAAT < C_A_WIDTH) && C_HAS_LOADB == 1 && intLOADB == 1 && invalidRDY == 1 && C_HAS_ND == 0) // added C_BAAT < C_A_WIDTH to fix another Parallel bug
                                                                                                                    // addedd C_HAS_ND ==0 to fix a serial bug.
                for (i = 0; i < C_LATENCY+nd_adjust+1; i = i +1)
       		    begin
       		        intRDYpipe[i] = 1'b0;
                end
		    else if (intCE == 1 && intSCLR == 0 && intACLR == 0)
			  intRDY = intRDYpipe[0] ;
			else if (intSCLR == 1 || intACLR == 1) 
			  intRDY = 0;
		end

		//Do the loadb stuff
		if (intCE == 1 && intSCLR == 1)
		begin
			loadb_count = -1 ;
			intLOAD_DONE <= 1 ;
			bank_sel = 0 ;
			regLOAD_DONE_sub <= 1 ;
		end
		else if (intCE == 1 && intLOADB == 1)
		begin
			loadb_count = loadb_delay ;
			loadb_value = B ;
			intLOAD_DONE <= 0 ;
			loaded <= 1 ;
		end
		else if (intCE == 1)
		begin
			if (loadb_count > 0)
			begin
				loadb_count = loadb_count - 1 ;
			end
			else if (loadb_count == 0)
			begin
				if (bank_sel == 0 && C_HAS_SWAPB == 1)
					b_const1 <= loadb_value ;
				else
					b_const0 <= loadb_value ;
				loadb_count = -1 ;
				intLOAD_DONE <= 1 ;
				if (intSWAPB == 1 && intLOAD_DONE == 1)
				begin
					if (bank_sel == 0)
						bank_sel = 1 ;
					else
						bank_sel = 0 ;
				end
			end
			else
			begin
				if (intSWAPB == 1 && intLOAD_DONE == 1)
				begin
					if (bank_sel == 0)
						bank_sel = 1 ;
					else
						bank_sel = 0 ;
				end
			end
		end

		//Update the pipelines

		if (c_pipe == 1 && real_latency > 0)
		begin
			if(intCLK === 1 && intCE === 1) // OK! Update pipelines!
			begin
				for(pipe = 0; pipe <= real_latency+nd_adjust-1; pipe = pipe + 1)
				begin
				  intRDYpipe[pipe] <= intRDYpipe[pipe+1];
				end
				if (real_latency == 1 && nd_adjust == 0 && C_BAAT == C_A_WIDTH ) 
				begin
					if(intND == 1 || (C_HAS_LOADB == 1 && intLOADB == 1) || (C_HAS_SWAPB == 1 && intSWAPB == 1)) // added last or statement!
					begin
						intQpipe[0] <= intQpipe[1] ;
					end
				end
				else
				begin
					for(pipe = 0; pipe <= real_latency; pipe = pipe + 1)
					begin
						intQpipe[pipe] <= intQpipe[pipe+1];
					end
				end
			end
		end
		if (c_pipe == 0 && seqRDY == 1 && intCE == 1 && intCLK == 1)
					intQ_ophold <= intO ;
		else if (c_pipe == 1 && intRDYpipe[0] == 1 && intCE == 1 && intCLK == 1)
					intQ_ophold <= intQpipe[0] ;
	end
	end

	//B_INPUT generation for re-loadable multiplier.
	always@(b_const0 or b_const1 or bank_sel or B or intLOAD_DONE)
	begin
		if (C_MULT_TYPE < 2)
		begin
			B_INPUT = B ;
		end
		else if ((intLOAD_DONE == 1) || (C_HAS_SWAPB == 1))
		begin
			if (bank_sel == 0 && C_MULT_TYPE > 2 && loaded == 1)
				B_INPUT <= b_const0 ;
			else if (bank_sel == 1 && C_MULT_TYPE > 2 && loaded == 1)
				B_INPUT <= b_const1 ;
		end
		else
		begin
			if (bank_sel == 0 && C_MULT_TYPE > 2 && loaded == 1)
				B_INPUT <= {(C_B_WIDTH)+1{1'bx}} ;
			else if (bank_sel == 1 && C_MULT_TYPE > 2 && loaded == 1)
				B_INPUT <= {(C_B_WIDTH)+1{1'bx}} ;
		end
	end

	//Route the multiplication through to the O output.
	always@(tmpAB or negedge intACLR or negedge intSCLR) // or negedge intSCLR added 15/02/01 to fix ser_sqm variant.
	begin
		if ((C_BAAT == C_A_WIDTH && C_OUT_WIDTH > out_width) || (C_BAAT < C_A_WIDTH  && C_OUT_WIDTH > sqm_cutoff_size))
		begin
			if (((C_BAAT == C_A_WIDTH ) && (C_B_TYPE == `c_signed || (C_A_TYPE == `c_signed && C_HAS_A_SIGNED == 0) || (C_HAS_A_SIGNED == 1 && tmpA_SIGNED == 1)))
				||((C_BAAT < C_A_WIDTH) && (C_B_TYPE == `c_signed || ((C_A_TYPE == `c_signed) && C_HAS_A_SIGNED == 0 && (cycle == no_of_cycles+1)) || (C_HAS_A_SIGNED == 1 && tmpA_SIGNED == 1 && (cycle == no_of_cycles+1)))))
			begin
			    for(j = C_OUT_WIDTH-1; j >= 0; j = j - 1)
			    begin
					if(C_BAAT == C_A_WIDTH)
					begin
						if (j >= out_width)
			        		intO[j] = tmpAB[out_width-1];
						else
							intO[j] = tmpAB[j] ;
					end
					else if (sqm_cutoff_size <= multWidth)
					begin
						if (j >= sqm_cutoff_size)
			        		intO[j] = tmpAB[multWidth-1];
						else
							intO[j] = tmpAB[j] ;
					end
					else if (sqm_cutoff_size > multWidth)
					begin
						if (j >= multWidth)
			        		intO[j] = tmpAB[multWidth-1]; 
						else
							intO[j] = tmpAB[j] ;
					end
			    end
		    end
		    else 
		    begin
			    for(j = C_OUT_WIDTH-1; j >= 0; j = j - 1)
			    begin
					if (C_BAAT == C_A_WIDTH)
					begin
						if (j >= out_width)
	               	 		intO[j] = 0;
						else
							intO[j] = tmpAB[j] ;
					end
					else if (sqm_cutoff_size <= multWidth)
					begin
						if (j >= sqm_cutoff_size)
			        		intO[j] = 0;
						else
							intO[j] = tmpAB[j] ;
					end
					else if (sqm_cutoff_size > multWidth)
					begin
						if (j >= multWidth)
			        		intO[j] = 0;
						else
							intO[j] = tmpAB[j] ;
					end
			    end
		    end
		end
		else 
		begin
			if (C_BAAT == C_A_WIDTH && C_MULT_TYPE < 2)
			begin
				for(j = C_OUT_WIDTH-1; j >= 0; j = j - 1)
				begin
					intO[j] = tmpAB[(out_width-C_OUT_WIDTH)+j] ;
				end
			end
			else if (C_BAAT < C_A_WIDTH && sqm_cutoff_size <= multWidth)
			begin
				for(j = 0; j < C_OUT_WIDTH; j = j + 1)
				begin
					intO[j] = tmpAB[(sqm_cutoff_size-C_OUT_WIDTH)+j] ;
				end
			end
			else if (C_BAAT < C_A_WIDTH && sqm_cutoff_size > multWidth)
			begin
				for(j = 0; j < multWidth; j = j + 1)
				begin
					intO[j] = tmpAB[(sqm_cutoff_size-C_OUT_WIDTH)+j] ;
				end
				for(j = multWidth; j < C_OUT_WIDTH; j = j + 1)
				begin
					intO[j] = tmpAB[multWidth-1] ;
				end
			end
			else
			begin
				for(j = 0; j < C_OUT_WIDTH; j = j + 1)
				begin
					intO[j] = tmpAB[(out_width-C_OUT_WIDTH)+j] ;
//                    intO[j] = tmpAB[(out_width-1-C_OUT_WIDTH)+j] ;
				end
			end
		end
	end

	always@(intO)
	begin
		if (C_BAAT == C_A_WIDTH)
		begin
			if(b_is_zero == 1)
			begin
				intQpipe[0] <= `all0s ;
			end
			if (c_pipe == 0)
			begin
				intQpipe[0] <= intO;
			end
			else
			begin
				intQpipe[real_latency] <= intO;
			end
		end
		else
		begin
			if (c_pipe == 0)
			begin
				intQpipe[0] <= intO;
			end
			else
			begin
				intQpipe[real_latency] <= intO;
			end
		end
	end

	always@(intQ_ctrl)
	begin
		if(intQ_ctrl == 1 && last_intQ_ctrl == 0)
		begin
			intQ_nopipe = intQpipe[0] ;
		end
	end

	always@(intCLK)
	begin
		last_intQ_ctrl <= intQ_ctrl ;
	end

	always@(ND)
	begin
		if(b_is_zero == 1  && C_HAS_ND == 1 && C_BAAT == C_A_WIDTH)//(b_is_zero == 1 || b_is_one == 1)
		begin
			intRDYpipe[0] <= ND ;
		end
	end

	//Calculate the ready output.
	always@(seqRDY or intND or regND_tmp or intND_for_RDY or intLD_for_RDY or intRDYpipe)
	begin
		if (C_BAAT == C_A_WIDTH && b_is_zero == 0 ) //&& b_is_one == 0)
		begin
			if (~((C_PIPELINE == 0 || C_LATENCY == 0) && C_REG_A_B_INPUTS == 0 && C_HAS_Q == 0))
			begin
				if (c_pipe == 0)
					if (C_HAS_ND == 0)
						intRDYpipe[0] <= intND ; //& intLD_for_RDY ; 
					else
						intRDYpipe[0] <= intND & intLD_for_RDY ;	
			   else if (C_BAAT == C_A_WIDTH)
					if (C_HAS_ND == 0)
						intRDYpipe[real_latency+nd_adjust] <= intND   ;//& intLD_for_RDY ; //intLOAD_DONE_sub ;
				    else if (C_BAAT == C_A_WIDTH && C_MULT_TYPE < 2 && C_REG_A_B_INPUTS == 0 && C_HAS_ND == 1 && C_LATENCY > 2)
	                    intRDYpipe[real_latency+nd_adjust] <= regND_tmp & intLD_for_RDY;
					else
						intRDYpipe[real_latency+nd_adjust] <= intND & intLD_for_RDY;
			end
			else if (C_HAS_ND == 1)
			begin
				if (c_pipe == 0)
					intRDYpipe[0] <= intND_for_RDY & intLD_for_RDY; //intLOAD_DONE_sub ;
				else
					intRDYpipe[real_latency+nd_adjust] <= intND_for_RDY  & intLD_for_RDY ; //intLOAD_DONE_sub ;
			end
			else
			begin
				if (c_pipe == 0)
					intRDYpipe[0] <= 1'b1 ; //intLOAD_DONE_sub ;
				else
			            intRDYpipe[real_latency+nd_adjust] <= 1'b1 ;
              	//	intRDYpipe[real_latency+nd_adjust] <= intLD_for_RDY; //intLOAD_DONE_sub ;
			end
		end
		else if (C_BAAT < C_A_WIDTH)
		begin
			if (c_pipe == 0)
				intRDYpipe[0] <= seqRDY ; 
			else
				intRDYpipe[real_latency+nd_adjust] <= seqRDY ; 
		end
	end


/* helper functions */
	
	function defval;
	input i;
	input hassig;
	input val;
		begin
			if(hassig == 1)
				defval = i;
			else
				defval = val;
		end
	endfunction
		
	function [C_B_WIDTH - 1 : 0] to_bitsB;
	input [C_B_WIDTH*8 : 1] instring;
	integer i;
	integer non_null_string;
	begin
		non_null_string = 0;
		for(i = C_B_WIDTH; i > 0; i = i - 1)
		begin // Is the string empty?
			if(instring[(i*8)] == 0 && 
				instring[(i*8)-1] == 0 && 
				instring[(i*8)-2] == 0 && 
				instring[(i*8)-3] == 0 && 
				instring[(i*8)-4] == 0 && 
				instring[(i*8)-5] == 0 && 
				instring[(i*8)-6] == 0 && 
				instring[(i*8)-7] == 0 &&
				non_null_string == 0)
					non_null_string = 0; // Use the return value to flag a non-empty string
			else
					non_null_string = 1; // Non-null character!
		end
		if(non_null_string == 0) // String IS empty! Just return the value to be all '0's
		begin
			for(i = C_B_WIDTH; i > 0; i = i - 1)
				to_bitsB[i-1] = 0;
		end
		else
		begin
			for(i = C_B_WIDTH; i > 0; i = i - 1)
			begin // Is this character a '0'? (ASCII = 48 = 00110000)
				if(instring[(i*8)] == 0 && 
					instring[(i*8)-1] == 0 && 
					instring[(i*8)-2] == 1 && 
					instring[(i*8)-3] == 1 && 
					instring[(i*8)-4] == 0 && 
					instring[(i*8)-5] == 0 && 
					instring[(i*8)-6] == 0 && 
					instring[(i*8)-7] == 0)
						to_bitsB[i-1] = 0;
				  // Or is it a '1'? 
				else if(instring[(i*8)] == 0 && 
					instring[(i*8)-1] == 0 && 
					instring[(i*8)-2] == 1 && 
					instring[(i*8)-3] == 1 && 
					instring[(i*8)-4] == 0 && 
					instring[(i*8)-5] == 0 && 
					instring[(i*8)-6] == 0 && 
					instring[(i*8)-7] == 1)		
						to_bitsB[i-1] = 1;
				  // Or is it a ' '? (a null char - in which case insert a '0')
				else if(instring[(i*8)] == 0 && 
					instring[(i*8)-1] == 0 && 
					instring[(i*8)-2] == 0 && 
					instring[(i*8)-3] == 0 && 
					instring[(i*8)-4] == 0 && 
					instring[(i*8)-5] == 0 && 
					instring[(i*8)-6] == 0 && 
					instring[(i*8)-7] == 0)		
						to_bitsB[i-1] = 0;
				else
				begin
					$display("Error in %m at time %d ns: non-binary digit in string \"%s\"\nExiting simulation...",$time, instring);
					$finish;
				end
			end
		end 
	end
	endfunction

	function findB_width;
	input [C_B_WIDTH-1 : 0] b_input;
	integer i;
	begin
		for(i = C_B_WIDTH-1; i > 0; i = i - 1)
		begin
			if(b_input[i] == 1)
				findB_width = i ;
			else
				findB_width = findB_width ;
		end 
	end
	endfunction

	function modulus;
	input a ;
	input b ;
	integer divide ;
	begin
		divide = (a < b ? 0 : (a / b)) ;
		modulus = a - (b*divide) ;
	end
	endfunction
	
	function max;
	input a;
	input b;
	begin
		max = (a > b) ? a : b;
	end
	endfunction
	
	function is_X;
	input [multWidth-1 : 0] i;
	begin
		is_X = 1'b0;
		for(j = 0; j < multWidth; j = j + 1)
		begin
			if(i[j] === 1'bx) 
				is_X = 1'b1;
		end // loop
	end
	endfunction
	
	function [multWidth-1 : 0] add;
	input [multWidth-1 : 0] i1;
	input [multWidth-1 : 0] i2;
	integer bit;
	integer carryin, carryout;
	begin
		carryin = 0;
		carryout = 0;
		for(bit=0; bit < multWidth; bit = bit + 1)
		begin
			if (i1[bit] === 1'bx || i2[bit] === 1'bx)
			begin
				add[bit] = 1'bx ;
				carryout = 1'bx ;
				carryin = carryout ;
			end
			else if (carryin === 1'bx)
			begin
				add[bit] = 1'bx ;
				carryout = 0 ;
				carryin = carryout ;
			end
			else
			begin
				add[bit] = i1[bit] ^ i2[bit] ^ carryin;
				carryout = (i1[bit] && i2[bit]) || (carryin && (i1[bit] || i2[bit]));
				carryin = carryout;
			end
		end
	end
	endfunction

	function [multWidth-1 : 0] mult;
	input [multWidth-1 : 0] i1;
	input [multWidth-1 : 0] i2;
	input SIGN_PIN ;
	integer a_count, b_count;
	integer carryin, carryout;
	reg value ; 
	reg [multWidth-1 : 0] la ;
	reg [multWidth-1 : 0] lb ;
	reg [multWidth-1 : 0] result ;
	integer negative, index ;
	begin
		negative = 0 ;
		if (C_B_TYPE == `c_unsigned)
		begin
			if ((C_A_TYPE == `c_signed && i1[multWidth-1] == 1) || (SIGN_PIN == 1))
				negative = 1 ;
		end
		else if (C_A_TYPE == `c_unsigned || SIGN_PIN == 0)
		begin
			if (C_B_TYPE == `c_signed && i2[multWidth-1] == 1)
				negative = 1 ;
		end
		else if ((C_B_TYPE == `c_signed) && ((C_A_TYPE == `c_signed) || (SIGN_PIN == 1)))
		begin
			if  ((i1[multWidth-1] == 1 && i2[multWidth-1] == 0) || (i2[multWidth-1] == 1 && i1[multWidth-1] == 0))
				negative = 1 ;
		end
		if ((C_A_TYPE == `c_signed && i1[multWidth-1] == 1) || (SIGN_PIN == 1))
		begin
			//twos comp A
			for(a_count = 0; a_count < multWidth; a_count = a_count + 1)
			begin
				la[a_count] = ~i1[a_count] ;
			end
			la = add(la, one) ;
		end
		else
		begin
			la = i1 ;
		end
		if (C_B_TYPE == `c_signed && i2[multWidth-1] == 1)
		begin
			//twos comp B
			for(b_count = 0; b_count < multWidth; b_count = b_count + 1)
			begin
				lb[b_count] = ~i2[b_count] ;
			end
			lb = add(lb, one) ;
		end
		else
		begin
			lb = i2 ;
		end
		carryin = 0;
		carryout = 0;
		for(a_count=0; a_count < multWidth; a_count = a_count + 1)
		begin
			mult[a_count] = 0 ;
		end
		for(a_count=0; a_count < multWidth; a_count = a_count + 1)
		begin
			if (la[a_count] == 1)
			begin
				index = a_count ;
				carryin = 0 ;
				for (b_count=0 ; b_count < multWidth; b_count = b_count + 1)
				begin
					value = mult[index] ^ lb[b_count] ^ carryin;
					carryout = (mult[index] & lb[b_count]) | (mult[index] & carryin) | (lb[b_count] & carryin);
					mult[index] = value ;
					carryin = carryout;
					index = index + 1 ;
				end
				mult[index] = mult[index] ^ carryout ;
			end
			else
			begin
				carryin = 0 ;
			end
		end
		result = mult ;
		if (negative == 1)
		begin
			//twos comp B
			for(a_count = 0; a_count < multWidth; a_count = a_count + 1)
			begin
				mult[a_count] = ~mult[a_count] ;
			end
			mult = add(mult, one) ;
		end
		result = mult ;
	end
	endfunction
	
	function [multWidth-1 : 0] sub;
	input [multWidth-1 : 0] i1;
	input [multWidth-1 : 0] i2;
	begin
		i2 = add(~i2, 1);
		sub = add(i1, i2);
	end
	endfunction

	function calc_latency;
	input A_WIDTH;
	input B_WIDTH;
	input B_TYPE;
	input HAS_A_SIGNED;
	input REG_A_B_INPUTS;
	input MEM_TYPE;
	input PIPELINE;
	input MULT_TYPE;
	input HAS_LOADB;
	input BAAT;
	input B_VALUE;
	input A_TYPE;
	integer rom_addr_width ;
	integer a_input_width ;
	begin
		calc_latency = 1 ;
	end
	endfunction

	function calc_no_of_cycles;
	input C_BAAT;
	input C_A_WIDTH;
	begin
		calc_no_of_cycles = 4;
	end
	endfunction
	
endmodule

`undef c_set
`undef c_clear
`undef c_override
`undef c_no_override
`undef c_add
`undef c_sub
`undef c_add_sub
`undef c_signed
`undef c_unsigned
`undef c_pin
`undef allUKs
`undef all0s
`undef ball0s
`undef ballxs
`undef aall0s
`undef baatall0s
`undef baatall1s
`undef baatallxs
`undef c_distributed
`undef c_dp_block
`undef mall0s
`undef inall0s
































