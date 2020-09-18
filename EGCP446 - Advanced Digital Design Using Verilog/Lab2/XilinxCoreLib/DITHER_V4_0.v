//$Id: DITHER_V4_0.v,v 1.4 2002/03/29 15:55:55 janeh Exp $
`timescale 1ns/10ps

module DITHER_V4_0 (AINIT, CE, CLK, DITHER, SINIT);
	
	parameter HASAINIT		= 0;
	parameter HASCE			= 0;
	parameter HASSINIT		= 0;
	parameter LFSRALENGTH	= 13;
	parameter LFSRBLENGTH	= 14;
	parameter LFSRCLENGTH	= 15;
	parameter LFSRDLENGTH	= 16;
	parameter PIPELINED		= 1;
	
	input AINIT;
	input CE;
	input CLK;
	output DITHER;
	integer DITHER;
	input SINIT;
	
	wire aInitInt		= (HASAINIT==1 ? AINIT : 1'b0);
	wire sInitInt		= (HASSINIT==1 ? SINIT : 1'b0);	
	wire ceInt			= (HASCE==1 ? CE : 1'b1);
	reg [LFSRALENGTH-1:0] lfsrA;
	reg [LFSRBLENGTH-1:0] lfsrB; 
	reg [LFSRCLENGTH-1:0] lfsrC;
	reg [LFSRDLENGTH-1:0] lfsrD;  
	integer sumPipe;
	integer sumPipeMinusOne;
	integer sum;
	
	initial
		begin
			lfsrA <=  {1'b1,{LFSRALENGTH-1{1'b0}}};
			lfsrB <=  {1'b1,{LFSRBLENGTH-1{1'b0}}};
			lfsrC <=  {1'b1,{LFSRCLENGTH-1{1'b0}}};
			lfsrD <=  {1'b1,{LFSRDLENGTH-1{1'b0}}};
			sumPipe <= 0;
			sumPipeMinusOne <= 0;
		end
	
	always @(posedge CLK or posedge aInitInt)
		begin
			if (aInitInt || sInitInt)
				begin  
					lfsrA <=  {1'b1,{LFSRALENGTH-1{1'b0}}};
					lfsrB <=  {1'b1,{LFSRBLENGTH-1{1'b0}}};
					lfsrC <=  {1'b1,{LFSRCLENGTH-1{1'b0}}};
					lfsrD <=  {1'b1,{LFSRDLENGTH-1{1'b0}}};
				end
			else if (ceInt)
				begin
					lfsrA[0] <= lfsrA[0] ^ lfsrA[2] ^ lfsrA[3] ^ lfsrA[12];
					lfsrA[12:1] <= lfsrA[11:0];
					lfsrB[0] <= lfsrB[0] ^ lfsrB[5] ^ lfsrB[9] ^ lfsrB[13];
					lfsrB[13:1] <= lfsrB[12:0];
					lfsrC[0] <= lfsrC[0] ^ lfsrC[14];
					lfsrC[14:1] <= lfsrC[13:0];
					lfsrD[0] <= lfsrD[0] ^ lfsrD[2] ^ lfsrD[11] ^ lfsrD[15];
					lfsrD[15:1] <= lfsrD[14:0];
				end
		end
	
	always @(lfsrA or lfsrB or lfsrC or lfsrD)
		begin
			sum <= {{32-8{lfsrA[LFSRALENGTH-1]}}, lfsrA[LFSRALENGTH-1:LFSRALENGTH-8]} +
			{{32-8{lfsrB[LFSRBLENGTH-1]}}, lfsrB[LFSRBLENGTH-1:LFSRBLENGTH-8]} +
			{{32-8{lfsrC[LFSRCLENGTH-1]}}, lfsrC[LFSRCLENGTH-1:LFSRCLENGTH-8]} +
			{{32-8{lfsrD[LFSRDLENGTH-1]}}, lfsrD[LFSRDLENGTH-1:LFSRDLENGTH-8]};
		end
	
	always @(posedge CLK or posedge aInitInt)
		begin
			if (PIPELINED==1)
				begin
					if (aInitInt || sInitInt)
						begin
							sumPipe <= 0;
							sumPipeMinusOne <= 0;
						end
					else if (ceInt)
						begin
							sumPipe = sumPipeMinusOne;
							sumPipeMinusOne = sum;
						end	
				end
		end
	
	always @(sum or sumPipe)
		begin  
			if (PIPELINED)
				DITHER <= sumPipe;
			else
				DITHER <= sum;
		end
endmodule 
