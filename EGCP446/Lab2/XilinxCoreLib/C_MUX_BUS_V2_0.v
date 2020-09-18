/* $Id: C_MUX_BUS_V2_0.v,v 1.10 2001/05/24 21:25:47 haotao Exp $
--
-- Filename - C_MUX_BUS_V2_0.v
-- Author - Xilinx
-- Creation - 4 Feb 1999
--
-- Description - This file contains the Verilog behavior for the Baseblocks C_MUX_BUS_V2_0 module
*/



`define c_set 0
`define c_clear 1
`define c_override 0
`define c_no_override 1
`define c_lut_based 0
`define c_buft_based 1

`define allmyXs {C_WIDTH{1'bx}}
`define allmyZs {C_WIDTH{1'bz}}

module C_MUX_BUS_V2_0 (MA, MB, MC, MD, ME, MF, MG, MH, S, CLK, CE, EN, ACLR, ASET, AINIT, SCLR, SSET, SINIT, O, Q);

	parameter C_AINIT_VAL 		= "";
	parameter C_ENABLE_RLOCS	= 1;
	parameter C_HAS_ACLR 		= 0;
	parameter C_HAS_AINIT 		= 0;
	parameter C_HAS_ASET 		= 0;
	parameter C_HAS_CE 			= 0;
	parameter C_HAS_EN 			= 0;
	parameter C_HAS_O 			= 0;
	parameter C_HAS_Q 			= 1;
	parameter C_HAS_SCLR 		= 0;
	parameter C_HAS_SINIT 		= 0;
	parameter C_HAS_SSET 		= 0;
	parameter C_INPUTS 			= 2; 				
	parameter C_MUX_TYPE 		= `c_lut_based;
	parameter C_SEL_WIDTH 		= 1; 				
	parameter C_SINIT_VAL 		= "";
	parameter C_SYNC_ENABLE 	= `c_override;	
	parameter C_SYNC_PRIORITY 	= `c_clear;	
	parameter C_WIDTH 			= 16;					

	input [C_WIDTH-1 : 0] MA;
	input [C_WIDTH-1 : 0] MB;
	input [C_WIDTH-1 : 0] MC;
	input [C_WIDTH-1 : 0] MD;
	input [C_WIDTH-1 : 0] ME;
	input [C_WIDTH-1 : 0] MF;
	input [C_WIDTH-1 : 0] MG;
	input [C_WIDTH-1 : 0] MH;
	input [C_SEL_WIDTH-1 : 0] S;
	input CLK;
	input CE;
	input EN;
	input ACLR;
	input ASET;
	input AINIT;
	input SCLR;
	input SSET;
	input SINIT;
	output [C_WIDTH-1 : 0] O;
	output [C_WIDTH-1 : 0] Q;
	 
	// Internal values to drive signals when input is missing
	wire [C_WIDTH-1 : 0] intMA = MA;
	wire [C_WIDTH-1 : 0] intMB = MB;
	wire [C_WIDTH-1 : 0] intMC = (C_INPUTS > 2 ? MC : `allmyXs);
	wire [C_WIDTH-1 : 0] intMD = (C_INPUTS > 3 ? MD : `allmyXs);
	wire [C_WIDTH-1 : 0] intME = (C_INPUTS > 4 ? ME : `allmyXs);
	wire [C_WIDTH-1 : 0] intMF = (C_INPUTS > 5 ? MF : `allmyXs);
	wire [C_WIDTH-1 : 0] intMG = (C_INPUTS > 6 ? MG : `allmyXs);
	wire [C_WIDTH-1 : 0] intMH = (C_INPUTS > 7 ? MH : `allmyXs);
	wire intEN;
	reg [C_WIDTH-1 : 0] intO;
	wire [C_WIDTH-1 : 0] intQ;
	wire [C_SEL_WIDTH-1 : 0] intS = S;
		 
	wire [C_WIDTH-1 : 0] Q = (C_HAS_Q == 1 ? intQ : `allmyXs);
	wire [C_WIDTH-1 : 0] O = (C_HAS_O == 1 ? intO : `allmyXs);
	
	// Sort out default values for missing ports
	
	assign intEN = defval(EN, C_HAS_EN, 1);
	
	integer j, k, j1, k1;
	integer m, unknown, m1, unknown1;
	
	// Register on output by default
	C_REG_FD_V2_0 #(C_AINIT_VAL, C_ENABLE_RLOCS, C_HAS_ACLR, C_HAS_AINIT, C_HAS_ASET,
			   C_HAS_CE, C_HAS_SCLR, C_HAS_SINIT, C_HAS_SSET,
			   C_SINIT_VAL, C_SYNC_ENABLE, C_SYNC_PRIORITY, C_WIDTH)
		reg1 (.D(intO), .CLK(CLK), .CE(CE), .ACLR(ACLR), .ASET(ASET),
			  .AINIT(AINIT), .SCLR(SCLR), .SSET(SSET), .SINIT(SINIT),
			  .Q(intQ)); 

	initial 
	begin

		#1;
		k = 1;
		m = 1; 
		unknown = 0;
		for(j = 0; j < C_SEL_WIDTH; j = j + 1)
		begin
			if(intS[j] === 1)
				k = k + m;
			else if(intS[j] === 1'bz || intS[j] === 1'bx)
				unknown = 1;
			m = m * 2;
		end
		
		if(intEN === 1'b0)
			intO <= #1 `allmyZs;
		else if(intEN === 1'bx)
			intO <= #1 `allmyXs;
		else if(unknown == 1)
			intO <= #1 `allmyXs;
		else if (k == 1) 
			intO <= #1 intMA;
		else if (k == 2) 
			intO <= #1 intMB;
		else if (k == 3) 
			intO <= #1 intMC;
		else if (k == 4) 
			intO <= #1 intMD;
		else if (k == 5) 
			intO <= #1 intME;
		else if (k == 6) 
			intO <= #1 intMF;
		else if (k == 7) 
			intO <= #1 intMG;
		else if (k == 8) 
			intO <= #1 intMH;
		else
			intO <= #1 `allmyXs;
			
	end
	
	always@(intMA or intMB or intMC or intMD or intME or intMF or intMG or intMH or intEN or intS)
	begin
		k1 = 1;
		m1 = 1; 
		unknown1 = 0;
		for(j1 = 0; j1 < C_SEL_WIDTH; j1 = j1 + 1)
		begin
			if(intS[j1] === 1)
				k1 = k1 + m1;
			else if(intS[j1] === 1'bz || intS[j1] === 1'bx)
				unknown1 = 1;
			m1 = m1 * 2;
		end
		
		if(intEN === 1'b0)
			intO = #1 `allmyZs;
		else if(intEN === 1'bx)
			intO = #1 `allmyXs;
		else if(unknown1 == 1)
			intO <= #1 `allmyXs;
		else if (k1 == 1) 
			intO <= #1 intMA;
		else if (k1 == 2) 
			intO <= #1 intMB;
		else if (k1 == 3) 
			intO <= #1 intMC;
		else if (k1 == 4) 
			intO <= #1 intMD;
		else if (k1 == 5) 
			intO <= #1 intME;
		else if (k1 == 6) 
			intO <= #1 intMF;
		else if (k1 == 7) 
			intO <= #1 intMG;
		else if (k1 == 8) 
			intO <= #1 intMH;
		else
			intO <= #1 `allmyXs;
	end
		
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
	
endmodule

`undef c_set
`undef c_clear
`undef c_override
`undef c_no_override
`undef c_lut_based
`undef c_buft_based

`undef allmyXs
`undef allmyZs

