/* $Id: C_MUX_BIT_V2_0.v,v 1.4 2001/05/24 21:25:26 haotao Exp $
--
-- Filename - C_MUX_BIT_V2_0.v
-- Author - Xilinx
-- Creation - 21 Oct 1998
--
-- Description - This file contains the Verilog behavior for the Baseblocks C_MUX_BIT_V2_0 module
*/



`define c_set 0
`define c_clear 1
`define c_override 0
`define c_no_override 1

module C_MUX_BIT_V2_0 (M, S, CLK, CE, ACLR, ASET, AINIT, SCLR, SSET, SINIT, O, Q);

	parameter C_AINIT_VAL 		= "";
	parameter C_ENABLE_RLOCS	= 1;
	parameter C_HAS_ACLR 		= 0;
	parameter C_HAS_AINIT 		= 0;
	parameter C_HAS_ASET 		= 0;
	parameter C_HAS_CE 			= 0;
	parameter C_HAS_O 			= 0;
	parameter C_HAS_Q 			= 1;
	parameter C_HAS_SCLR 		= 0;
	parameter C_HAS_SINIT 		= 0;
	parameter C_HAS_SSET 		= 0;
	parameter C_INPUTS 			= 2; 			
	parameter C_SEL_WIDTH 		= 1; 			
	parameter C_SINIT_VAL 		= "";
	parameter C_SYNC_ENABLE 	= `c_override;		
	parameter C_SYNC_PRIORITY 	= `c_clear;		
	
	parameter C_PIPE_STAGES         = 0;

	input [C_INPUTS-1 : 0] M;
	input [C_SEL_WIDTH-1 : 0] S;
	input CLK;
	input CE;
	input ACLR;
	input ASET;
	input AINIT;
	input SCLR;
	input SSET;
	input SINIT;
	output O;
	output Q;
	 
	// Internal values to drive signals when input is missing
	wire intCE;
	reg intO;
	wire intQ;
	reg lastCLK;
	
	reg [C_PIPE_STAGES+2 : 0] intQpipe;
	reg intQpipeend;
	 
	wire Q = (C_HAS_Q == 1 ? intQ : 1'bx);
	wire O = (C_HAS_O == 1 ? intO : 1'bx);
	
	// Sort out default values for missing ports
	
	assign intCE = defval(CE, C_HAS_CE, 1);
	
	integer j, k;
	integer m, unknown;
	integer pipe;
	
	// Register on output by default
	C_REG_FD_V2_0 #(C_AINIT_VAL, C_ENABLE_RLOCS, C_HAS_ACLR, C_HAS_AINIT, C_HAS_ASET,
			   C_HAS_CE, C_HAS_SCLR, C_HAS_SINIT, C_HAS_SSET,
			   C_SINIT_VAL, C_SYNC_ENABLE, C_SYNC_PRIORITY, 1)
		reg1 (.D(intQpipeend), .CLK(CLK), .CE(CE), .ACLR(ACLR), .ASET(ASET),
			  .AINIT(AINIT), .SCLR(SCLR), .SSET(SSET), .SINIT(SINIT),
			  .Q(intQ)); 

	initial 
	begin

		#1;

		intQpipe = 'b0;
		k = 1;
		m = 1; 
		unknown = 0;
		for(j = 0; j < C_SEL_WIDTH; j = j + 1)
		begin
			if(S[j] === 1)
				k = k + m;
			else if(S[j] === 1'bz || S[j] === 1'bx)
				unknown = 1;
			m = m * 2;
		end
		
		if(unknown == 1)
			intO <= 1'bx;
		else
			intO <= M[k-1];
			
		if(C_PIPE_STAGES < 2) // No pipeline
			intQpipeend = intO;
		else // Pipeline stages required
		begin
			intQpipeend = intQpipe[2];
		end
	end
	
	always @(CLK)
  		lastCLK <= CLK;

	always@(M or S)
	begin
		k = 1;
		m = 1; 
		unknown = 0;
		for(j = 0; j < C_SEL_WIDTH; j = j + 1)
		begin
			if(S[j] === 1)
				k = k + m;
			else if(S[j] === 1'bz || S[j] === 1'bx)
				unknown = 1;
			m = m * 2;
		end
		
		if(unknown == 1)
			intO <= #1 1'bx;
		else
			intO <= #1 M[k-1];
	end
	
	always@(posedge CLK)
	begin
		if(CLK === 1'b1 && lastCLK === 1'b0 && intCE === 1'b1) // OK! Update pipelines!
		begin
			for(pipe = 2; pipe <= C_PIPE_STAGES-1; pipe = pipe + 1)
			begin
				intQpipe[pipe] <= intQpipe[pipe+1];
			end
			intQpipe[C_PIPE_STAGES] <= intO;
		end
		else if((CLK === 1'bx && lastCLK === 1'b0) || (CLK === 1'b1 && lastCLK === 1'bx) || intCE === 1'bx) // POSSIBLY Update pipelines!
		begin
			for(pipe = 2; pipe <= C_PIPE_STAGES-1; pipe = pipe + 1)
			begin
				if(intQpipe[pipe] !== intQpipe[pipe+1])
					intQpipe[pipe] <= 1'bx;
			end
			if(intQpipe[C_PIPE_STAGES] !== intO)
				intQpipe[C_PIPE_STAGES] <= 1'bx;
		end
	end
	
	always@(intO or intQpipe[2])
	begin
		if(C_PIPE_STAGES < 2) // No pipeline
			intQpipeend <= intO;
		else // Pipeline stages required
		begin
			intQpipeend <= intQpipe[2];
		end
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

