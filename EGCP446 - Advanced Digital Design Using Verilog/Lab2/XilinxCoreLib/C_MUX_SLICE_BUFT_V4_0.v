/* $Id: C_MUX_SLICE_BUFT_V4_0.v,v 1.3 2001/05/24 21:41:11 haotao Exp $
--
-- Filename - C_MUX_SLICE_BUFT_V4_0.v
-- Author - Xilinx
-- Creation - 4 Feb 1999
--
-- Description - This file contains the Verilog behavior for the Baseblocks C_MUX_SLICE_BUFT_V4_0 module
*/


`define allXs {C_WIDTH{1'bx}}
`define allZs {C_WIDTH{1'bz}}

module C_MUX_SLICE_BUFT_V4_0 (I, T, O);

	parameter C_WIDTH = 16;						/* Width of the single input */	

	input [C_WIDTH-1 : 0] I;
	input T;
	output [C_WIDTH-1 : 0] O;
	 
	reg [C_WIDTH-1 : 0] intO;

	wire [C_WIDTH-1 : 0] #1 O = intO;
	
	initial 
	begin

		if (T == 0) 
			intO = I;
		else if (T == 1) 
			intO = `allZs;
		else
			intO = `allXs;			
	end
	
	always@(I or T)
	begin
		if (T == 0) 
			intO <= I;
		else if (T == 1) 
			intO <= `allZs;
		else
			intO <= `allXs;			
	end
		
endmodule

`undef allXs
`undef allZs

