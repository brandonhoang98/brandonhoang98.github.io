// $Id: DITHER_ADD_V4_1.v,v 1.2 2002/03/29 15:56:02 janeh Exp $
`timescale 1ns/10ps

module DITHER_ADD_V4_1 (A,ACLR,CE,CLK,DITHERED_PHASE,ND,RDY,SCLR) ;

// ---- User defined diagram parameters --- //
parameter ACCUM_WIDTH = 16;
parameter C_HAS_ACLR = 0;
parameter C_HAS_CE = 0;
parameter C_HAS_SCLR = 0;
parameter C_PIPELINED = 0;
parameter PHASE_WIDTH = 8;

// --- User defined diagram declarations -- //
integer i;
integer scaledDitherIndex, ditherIndex;
reg [ACCUM_WIDTH-PHASE_WIDTH:0] scaledDitherReg;

// ------------ Port declarations --------- //
input ACLR;
wire ACLR;
input CE;
wire CE;
input CLK;
wire CLK;
input ND;
wire ND;
input SCLR;
wire SCLR;
input [ACCUM_WIDTH-1:0] A;
wire [ACCUM_WIDTH-1:0] A;

output RDY;
wire RDY;
output [PHASE_WIDTH-1:0] DITHERED_PHASE;
wire [PHASE_WIDTH-1:0] DITHERED_PHASE;

// ----------------- Constants ------------ //
parameter DANGLING_INPUT_CONSTANT = 1'bZ;

// ----------- Signal declarations -------- //
wire [ACCUM_WIDTH-1:0] addQ;
wire [ACCUM_WIDTH-1:0] addS;
wire [31:0] ditherInt;
wire [0:0] ditherRdy;
wire [9:0] ditherVector;
wire [0:0] ndDelay;
wire [ACCUM_WIDTH-PHASE_WIDTH:0] scaledDither;
wire NET5396;
wire NET5400;
wire NET5404;
wire NET5408;
wire NET5412;
wire NET5416;

// ---- Declaration for Dangling inputs ----//
wire Dangling_Input_Signal = DANGLING_INPUT_CONSTANT;

// ------- User defined Verilog code -------//

//----- Verilog statement0 ----//
assign DITHERED_PHASE = (C_PIPELINED==1) ? addQ[ACCUM_WIDTH-1:
	ACCUM_WIDTH-PHASE_WIDTH] : addS[ACCUM_WIDTH-1:
	ACCUM_WIDTH-PHASE_WIDTH];

//----- Verilog statement1 ----//
assign RDY = (C_PIPELINED==1) ? ndDelay[0] : ND;
assign ditherRdy[0] = ND;

//----- Verilog statement2 ----//
assign ditherVector = ditherInt;
assign scaledDither = scaledDitherReg;
always @(ditherVector)
begin
	scaledDitherIndex = ACCUM_WIDTH-PHASE_WIDTH;
	ditherIndex = 9;
	for (i=scaledDitherIndex; i>=0; i=i-1)
	begin
		if (ditherIndex >= 0)
			scaledDitherReg[i] <=  ditherVector[ditherIndex];
		else
			scaledDitherReg[i] <= 1'b0;
		ditherIndex = ditherIndex-1;
	end
end

DITHER_V4_1 DITHER
(
	.AINIT(ACLR),
	.CE(CE),
	.CLK(CLK),
	.DITHER(ditherInt),
	.SINIT(SCLR)
);

defparam DITHER.HASAINIT = C_HAS_ACLR;
defparam DITHER.HASCE = C_HAS_CE;
defparam DITHER.HASSINIT = C_HAS_SCLR;
defparam DITHER.PIPELINED = C_PIPELINED;

C_REG_FD_V5_0 U2
(
	.ACLR(ACLR),
	.AINIT(Dangling_Input_Signal),
	.ASET(Dangling_Input_Signal),
	.CE(CE),
	.CLK(CLK),
	.D(ditherRdy[0:0]),
	.Q(ndDelay[0:0]),
	.SCLR(SCLR),
	.SINIT(Dangling_Input_Signal),
	.SSET(Dangling_Input_Signal)
);

defparam U2.C_HAS_ACLR = C_HAS_ACLR;
defparam U2.C_HAS_CE = C_HAS_CE;
defparam U2.C_HAS_SCLR = C_HAS_SCLR;
defparam U2.C_WIDTH = 1;

C_ADDSUB_V5_0 U3
(
	.A(A[ACCUM_WIDTH-1:0]),
	.ACLR(ACLR),
	.ADD(Dangling_Input_Signal),
	.AINIT(Dangling_Input_Signal),
	.ASET(Dangling_Input_Signal),
	.A_SIGNED(Dangling_Input_Signal),
	.B(scaledDither[ACCUM_WIDTH-PHASE_WIDTH:0]),
	.BYPASS(Dangling_Input_Signal),
	.B_IN(Dangling_Input_Signal),
	.B_OUT(NET5396),
	.B_SIGNED(Dangling_Input_Signal),
	.CE(CE),
	.CLK(CLK),
	.C_IN(Dangling_Input_Signal),
	.C_OUT(NET5400),
	.OVFL(NET5404),
	.Q(addQ[ACCUM_WIDTH-1:0]),
	.Q_B_OUT(NET5408),
	.Q_C_OUT(NET5412),
	.Q_OVFL(NET5416),
	.S(addS[ACCUM_WIDTH-1:0]),
	.SCLR(SCLR),
	.SINIT(Dangling_Input_Signal),
	.SSET(Dangling_Input_Signal)
);

defparam U3.C_A_WIDTH = ACCUM_WIDTH;
defparam U3.C_B_TYPE = 0;
defparam U3.C_B_WIDTH = ACCUM_WIDTH-PHASE_WIDTH+1;
defparam U3.C_HAS_ACLR = C_HAS_ACLR;
defparam U3.C_HAS_B_IN = 0;
defparam U3.C_HAS_CE = C_HAS_CE;
defparam U3.C_HAS_C_IN = 0;
defparam U3.C_HAS_S = 1;
defparam U3.C_HAS_SCLR = C_HAS_SCLR;
defparam U3.C_HIGH_BIT = ACCUM_WIDTH-1;
defparam U3.C_LATENCY = C_PIPELINED;
defparam U3.C_LOW_BIT = 0;
defparam U3.C_OUT_WIDTH = ACCUM_WIDTH;



endmodule 
