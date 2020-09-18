
// $Revision: 1.2 $ $Date: 2002/03/29 15:56:02 $
`timescale 1ns/10ps

`define NONE 0
`define PHASE_DITHERING 1
`define EFF 2
`define REG 1
`define CONST 2
`define ZERO_CYCLE 0
`define ONE_CYCLE 1
`define DIST_ROM 0
`define BLOCK_ROM 1
`define SINE_ONLY 0
`define COSINE_ONLY 1
`define SINE_AND_COSINE 2

module C_DDS_V4_1 (A,ACLR,CE,CLK,SCLR,WE,DATA,RDY,RFD,COSINE,
SINE) ;

// ---- User defined diagram parameters --- //

parameter C_ACCUMULATOR_LATENCY=`ONE_CYCLE;

parameter C_ACCUMULATOR_WIDTH=16;

parameter C_DATA_WIDTH=5;

parameter C_ENABLE_RLOCS=0;

parameter C_HAS_ACLR=0;

parameter C_HAS_CE=0;

parameter C_HAS_RDY=1;

parameter C_HAS_RFD=0;

parameter C_HAS_SCLR=0;

parameter C_LATENCY=0;

parameter C_MEM_TYPE=`DIST_ROM;

parameter C_NEGATIVE_COSINE=0;

parameter C_NEGATIVE_SINE=0;

parameter C_NOISE_SHAPING=`NONE;

parameter C_OUTPUTS_REQUIRED=`SINE_AND_COSINE;

parameter C_OUTPUT_WIDTH=16;

parameter C_PHASE_ANGLE_WIDTH=4;

parameter C_PHASE_INCREMENT=`REG;

parameter C_PHASE_INCREMENT_VALUE="00000";

parameter C_PHASE_OFFSET=`NONE;

parameter C_PHASE_OFFSET_VALUE="000000";

parameter C_PIPELINED=1;


// --- User defined diagram declarations -- //
parameter constantIncrement = (C_PHASE_INCREMENT==`CONST)?1:0;
parameter constantOffset = (C_PHASE_OFFSET==`CONST)?1:0;
parameter hasOffset=(C_PHASE_OFFSET!=`NONE)?1:0;
parameter hasDithering=(C_NOISE_SHAPING==`PHASE_DITHERING &&
	C_ACCUMULATOR_WIDTH>C_PHASE_ANGLE_WIDTH)?1:0;
parameter hasEff=(C_NOISE_SHAPING==`EFF)?1:0;
parameter sincosLatency=C_LATENCY-(C_PIPELINED*hasOffset)-
	(C_PIPELINED*hasDithering) - (hasEff * 6);
parameter offsetHasQ=(C_PIPELINED==1)?1:0;
parameter offsetHasS=(C_PIPELINED==0)?1:0;
parameter accumHasS=(C_ACCUMULATOR_LATENCY==`ZERO_CYCLE)?1:0;
parameter hasSinCosRdy=(C_NOISE_SHAPING==`EFF || C_HAS_RDY==1)?1:0;
parameter lookupOutputWidth=(C_NOISE_SHAPING==`EFF)?18:C_OUTPUT_WIDTH;
wire aInt;
reg [C_ACCUMULATOR_WIDTH-1:0] offsetBusReg;

// ------------ Port declarations --------- //
input A;
wire A;
input ACLR;
wire ACLR;
input CE;
wire CE;
input CLK;
wire CLK;
input SCLR;
wire SCLR;
input WE;
wire WE;
input [C_DATA_WIDTH-1:0] DATA;
wire [C_DATA_WIDTH-1:0] DATA;
output RDY;
wire RDY;
output RFD;
wire RFD;
output [C_OUTPUT_WIDTH-1:0] COSINE;
wire [C_OUTPUT_WIDTH-1:0] COSINE;
output [C_OUTPUT_WIDTH-1:0] SINE;
wire [C_OUTPUT_WIDTH-1:0] SINE;

// ----------------- Constants ------------ //
parameter DANGLING_INPUT_CONSTANT = 1'bZ;

// ----------- Signal declarations -------- //
wire ditherNd;
wire ditherRdy;
wire NET28040;
wire NET28043;
wire NET28046;
wire NET28049;
wire NET28052;
wire NET28055;
wire NET28058;
wire NET28061;
wire NET28064;
wire NET28067;
wire NET28070;
wire NET28073;
wire pincEnable;
wire poffEnable;
wire rdyLookup;
wire sinCosNd;
supply1 VCC;
wire [lookupOutputWidth-1:0] cosLookup;
wire [C_PHASE_ANGLE_WIDTH-1:0] ditherOut;
wire [C_ACCUMULATOR_WIDTH-1:0] offsetBus;
wire [C_ACCUMULATOR_WIDTH-1:0] offsetQ;
wire [C_ACCUMULATOR_WIDTH-1:0] offsetS;
wire [C_ACCUMULATOR_WIDTH-1:0] phaseAccumBus;
wire [C_ACCUMULATOR_WIDTH-1:0] phaseAccumQ;
wire [C_ACCUMULATOR_WIDTH-1:0] phaseAccumS;
wire [C_PHASE_ANGLE_WIDTH-1:0] phaseAngleBus;
wire [C_DATA_WIDTH-1:0] phaseIncBus;
wire [C_DATA_WIDTH-1:0] phaseOffsetBus;
wire [lookupOutputWidth-1:0] sinLookup;
wire [0:0] toNdNet;
wire [0:0] vccbus;

// ---- Declaration for Dangling inputs ----//
wire Dangling_Input_Signal = DANGLING_INPUT_CONSTANT;

// ----------- Continues assignments -------//

assign aInt = ((C_PHASE_INCREMENT==`REG) &&
	(C_PHASE_OFFSET==`REG))?A:
	((C_PHASE_INCREMENT==`REG)?1'b0:1'b1);

assign ditherNd = (C_PHASE_OFFSET!=`NONE&&
	C_PIPELINED==1)?toNdNet[0]:1'b1;

assign phaseAccumBus =
	(C_ACCUMULATOR_LATENCY==`ONE_CYCLE)?
	phaseAccumQ:phaseAccumS;

assign pincEnable = !aInt && WE;

assign poffEnable = aInt && WE;

assign phaseAngleBus =
	(C_NOISE_SHAPING==`PHASE_DITHERING &&
	C_ACCUMULATOR_WIDTH>C_PHASE_ANGLE_WIDTH)?ditherOut:
	offsetBus[C_ACCUMULATOR_WIDTH-1:
	C_ACCUMULATOR_WIDTH-C_PHASE_ANGLE_WIDTH];

assign sinCosNd =
	(C_NOISE_SHAPING==`PHASE_DITHERING &&
	C_ACCUMULATOR_WIDTH>C_PHASE_ANGLE_WIDTH)?ditherRdy:
	ditherNd;

assign offsetBus = offsetBusReg;
always @(offsetQ or offsetS or phaseAccumBus)
begin
	if (C_PIPELINED==1&&C_PHASE_OFFSET!=`NONE)
		offsetBusReg <= offsetQ;
	else if (C_PIPELINED==0&&C_PHASE_OFFSET!=`NONE)
		offsetBusReg <= offsetS;
	else
		offsetBusReg <= phaseAccumBus;
end
// -------- Component instantiations -------//
C_REG_FD_V5_0 CE_DELAY
(
	.ACLR(ACLR),
	.AINIT(Dangling_Input_Signal),
	.ASET(Dangling_Input_Signal),
	.CE(CE),
	.CLK(CLK),
	.D(vccbus[0:0]),
	.Q(toNdNet[0:0]),
	.SCLR(SCLR),
	.SINIT(Dangling_Input_Signal),
	.SSET(Dangling_Input_Signal)
);

defparam CE_DELAY.C_ENABLE_RLOCS = C_ENABLE_RLOCS;
defparam CE_DELAY.C_HAS_ACLR = C_HAS_ACLR;
defparam CE_DELAY.C_HAS_CE = C_HAS_CE;
defparam CE_DELAY.C_HAS_SCLR = C_HAS_SCLR;
defparam CE_DELAY.C_WIDTH = 1;

C_EFF_V4_1 EFF
(
	.ACCUMULATOR(offsetBus[C_ACCUMULATOR_WIDTH-1:0]),
	.ACLR(ACLR),
	.CE(CE),
	.CLK(CLK),
	.COS(COSINE[C_OUTPUT_WIDTH-1:0]),
	.COS_IN(cosLookup[lookupOutputWidth-1:0]),
	.ND(rdyLookup),
	.RDY(RDY),
	.SCLR(SCLR),
	.SIN(SINE[C_OUTPUT_WIDTH-1:0]),
	.SIN_IN(sinLookup[lookupOutputWidth-1:0])
);

defparam EFF.C_ACCUM_WIDTH = C_ACCUMULATOR_WIDTH;
defparam EFF.C_HAS_ACLR = C_HAS_ACLR;
defparam EFF.C_HAS_CE = C_HAS_CE;
defparam EFF.C_HAS_SCLR = C_HAS_SCLR;
defparam EFF.C_INPUT_WIDTH = lookupOutputWidth;
defparam EFF.C_LOOKUP_LATENCY = sincosLatency;
defparam EFF.C_NOISE_SHAPING = C_NOISE_SHAPING;
defparam EFF.C_OUTPUT_WIDTH = C_OUTPUT_WIDTH;
defparam EFF.C_PHASE_WIDTH = C_PHASE_ANGLE_WIDTH;
defparam EFF.C_PIPELINED = C_PIPELINED;


C_ADDSUB_V5_0 OFFSET_ADDER
(
	.A(phaseAccumBus[C_ACCUMULATOR_WIDTH-1:0]),
	.ACLR(ACLR),
	.ADD(Dangling_Input_Signal),
	.AINIT(Dangling_Input_Signal),
	.ASET(Dangling_Input_Signal),
	.A_SIGNED(Dangling_Input_Signal),
	.B(phaseOffsetBus[C_DATA_WIDTH-1:0]),
	.BYPASS(Dangling_Input_Signal),
	.B_IN(Dangling_Input_Signal),
	.B_OUT(NET28058),
	.B_SIGNED(Dangling_Input_Signal),
	.CE(CE),
	.CLK(CLK),
	.C_IN(Dangling_Input_Signal),
	.C_OUT(NET28061),
	.OVFL(NET28064),
	.Q(offsetQ[C_ACCUMULATOR_WIDTH-1:0]),
	.Q_B_OUT(NET28067),
	.Q_C_OUT(NET28070),
	.Q_OVFL(NET28073),
	.S(offsetS[C_ACCUMULATOR_WIDTH-1:0]),
	.SCLR(SCLR),
	.SINIT(Dangling_Input_Signal),
	.SSET(Dangling_Input_Signal)
);

defparam OFFSET_ADDER.C_A_WIDTH = C_ACCUMULATOR_WIDTH;
defparam OFFSET_ADDER.C_B_CONSTANT = constantOffset;
defparam OFFSET_ADDER.C_B_VALUE = C_PHASE_OFFSET_VALUE;
defparam OFFSET_ADDER.C_B_WIDTH = C_DATA_WIDTH;
defparam OFFSET_ADDER.C_ENABLE_RLOCS = C_ENABLE_RLOCS;
defparam OFFSET_ADDER.C_HAS_ACLR = C_HAS_ACLR;
defparam OFFSET_ADDER.C_HAS_B_IN = 0;
defparam OFFSET_ADDER.C_HAS_CE = C_HAS_CE;
defparam OFFSET_ADDER.C_HAS_C_IN = 0;
defparam OFFSET_ADDER.C_HAS_Q = offsetHasQ;
defparam OFFSET_ADDER.C_HAS_S = offsetHasS;
defparam OFFSET_ADDER.C_HAS_SCLR = C_HAS_SCLR;
defparam OFFSET_ADDER.C_HIGH_BIT = C_ACCUMULATOR_WIDTH-1;
defparam OFFSET_ADDER.C_LOW_BIT = 0;
defparam OFFSET_ADDER.C_OUT_WIDTH = C_ACCUMULATOR_WIDTH;
defparam OFFSET_ADDER.C_PIPE_STAGES = 0;


C_ACCUM_V5_0 PHASE_ACCUMULATOR
(
	.ACLR(ACLR),
	.ADD(Dangling_Input_Signal),
	.AINIT(Dangling_Input_Signal),
	.ASET(Dangling_Input_Signal),
	.B(phaseIncBus[C_DATA_WIDTH-1:0]),
	.BYPASS(Dangling_Input_Signal),
	.B_IN(Dangling_Input_Signal),
	.B_OUT(NET28040),
	.B_SIGNED(Dangling_Input_Signal),
	.CE(CE),
	.CLK(CLK),
	.C_IN(Dangling_Input_Signal),
	.C_OUT(NET28043),
	.OVFL(NET28046),
	.Q(phaseAccumQ[C_ACCUMULATOR_WIDTH-1:0]),
	.Q_B_OUT(NET28049),
	.Q_C_OUT(NET28052),
	.Q_OVFL(NET28055),
	.S(phaseAccumS[C_ACCUMULATOR_WIDTH-1:0]),
	.SCLR(SCLR),
	.SINIT(Dangling_Input_Signal),
	.SSET(Dangling_Input_Signal)
);

defparam PHASE_ACCUMULATOR.C_ADD_MODE = 0;
defparam PHASE_ACCUMULATOR.C_BYPASS_ENABLE = 0;
defparam PHASE_ACCUMULATOR.C_BYPASS_LOW = 0;
defparam PHASE_ACCUMULATOR.C_B_CONSTANT = constantIncrement;
defparam PHASE_ACCUMULATOR.C_B_TYPE = 1;
defparam PHASE_ACCUMULATOR.C_B_VALUE = C_PHASE_INCREMENT_VALUE;
defparam PHASE_ACCUMULATOR.C_B_WIDTH = C_DATA_WIDTH;
defparam PHASE_ACCUMULATOR.C_ENABLE_RLOCS = C_ENABLE_RLOCS;
defparam PHASE_ACCUMULATOR.C_HAS_ACLR = C_HAS_ACLR;
defparam PHASE_ACCUMULATOR.C_HAS_ADD = 0;
defparam PHASE_ACCUMULATOR.C_HAS_AINIT = 0;
defparam PHASE_ACCUMULATOR.C_HAS_ASET = 0;
defparam PHASE_ACCUMULATOR.C_HAS_BYPASS = 0;
defparam PHASE_ACCUMULATOR.C_HAS_BYPASS_WITH_CIN = 0;
defparam PHASE_ACCUMULATOR.C_HAS_B_IN = 0;
defparam PHASE_ACCUMULATOR.C_HAS_B_OUT = 0;
defparam PHASE_ACCUMULATOR.C_HAS_B_SIGNED = 0;
defparam PHASE_ACCUMULATOR.C_HAS_CE = C_HAS_CE;
defparam PHASE_ACCUMULATOR.C_HAS_C_IN = 0;
defparam PHASE_ACCUMULATOR.C_HAS_C_OUT = 0;
defparam PHASE_ACCUMULATOR.C_HAS_OVFL = 0;
defparam PHASE_ACCUMULATOR.C_HAS_Q_B_OUT = 0;
defparam PHASE_ACCUMULATOR.C_HAS_Q_C_OUT = 0;
defparam PHASE_ACCUMULATOR.C_HAS_Q_OVFL = 0;
defparam PHASE_ACCUMULATOR.C_HAS_S = accumHasS;
defparam PHASE_ACCUMULATOR.C_HAS_SCLR = C_HAS_SCLR;
defparam PHASE_ACCUMULATOR.C_HAS_SINIT = 0;
defparam PHASE_ACCUMULATOR.C_HAS_SSET = 0;
defparam PHASE_ACCUMULATOR.C_HIGH_BIT = C_ACCUMULATOR_WIDTH-1;
defparam PHASE_ACCUMULATOR.C_LOW_BIT = 0;
defparam PHASE_ACCUMULATOR.C_OUT_WIDTH = C_ACCUMULATOR_WIDTH;
defparam PHASE_ACCUMULATOR.C_PIPE_STAGES = 1;
defparam PHASE_ACCUMULATOR.C_SATURATE = 0;
defparam PHASE_ACCUMULATOR.C_SCALE = 0;
defparam PHASE_ACCUMULATOR.C_SYNC_ENABLE = 0;
defparam PHASE_ACCUMULATOR.C_SYNC_PRIORITY = 1;


C_REG_FD_V5_0 PHASE_INCREMENT_REG
(
	.ACLR(ACLR),
	.AINIT(Dangling_Input_Signal),
	.ASET(Dangling_Input_Signal),
	.CE(pincEnable),
	.CLK(CLK),
	.D(DATA[C_DATA_WIDTH-1:0]),
	.Q(phaseIncBus[C_DATA_WIDTH-1:0]),
	.SCLR(SCLR),
	.SINIT(Dangling_Input_Signal),
	.SSET(Dangling_Input_Signal)
);

defparam PHASE_INCREMENT_REG.C_ENABLE_RLOCS = C_ENABLE_RLOCS;
defparam PHASE_INCREMENT_REG.C_HAS_ACLR = C_HAS_ACLR;
defparam PHASE_INCREMENT_REG.C_HAS_CE = 1;
defparam PHASE_INCREMENT_REG.C_HAS_SCLR = C_HAS_SCLR;
defparam PHASE_INCREMENT_REG.C_WIDTH = C_DATA_WIDTH;

C_REG_FD_V5_0 PHASE_OFFSET_REG
(
	.ACLR(ACLR),
	.AINIT(Dangling_Input_Signal),
	.ASET(Dangling_Input_Signal),
	.CE(poffEnable),
	.CLK(CLK),
	.D(DATA[C_DATA_WIDTH-1:0]),
	.Q(phaseOffsetBus[C_DATA_WIDTH-1:0]),
	.SCLR(SCLR),
	.SINIT(Dangling_Input_Signal),
	.SSET(Dangling_Input_Signal)
);

defparam PHASE_OFFSET_REG.C_ENABLE_RLOCS = C_ENABLE_RLOCS;
defparam PHASE_OFFSET_REG.C_HAS_ACLR = C_HAS_ACLR;
defparam PHASE_OFFSET_REG.C_HAS_CE = 1;
defparam PHASE_OFFSET_REG.C_HAS_SCLR = C_HAS_SCLR;
defparam PHASE_OFFSET_REG.C_WIDTH = C_DATA_WIDTH;

C_SIN_COS_V4_1 SIN_COS_LOOKUP
(
	.ACLR(ACLR),
	.CE(CE),
	.CLK(CLK),
	.COSINE(cosLookup[lookupOutputWidth-1:0]),
	.ND(sinCosNd),
	.RDY(rdyLookup),
	.RFD(RFD),
	.SCLR(SCLR),
	.SINE(sinLookup[lookupOutputWidth-1:0]),
	.THETA(phaseAngleBus[C_PHASE_ANGLE_WIDTH-1:0])
);

defparam SIN_COS_LOOKUP.C_ENABLE_RLOCS = C_ENABLE_RLOCS;
defparam SIN_COS_LOOKUP.C_HAS_ACLR = C_HAS_ACLR;
defparam SIN_COS_LOOKUP.C_HAS_CE = C_HAS_CE;
defparam SIN_COS_LOOKUP.C_HAS_ND = 1;
defparam SIN_COS_LOOKUP.C_HAS_RDY = hasSinCosRdy;
defparam SIN_COS_LOOKUP.C_HAS_RFD = C_HAS_RFD;
defparam SIN_COS_LOOKUP.C_HAS_SCLR = C_HAS_SCLR;
defparam SIN_COS_LOOKUP.C_LATENCY = sincosLatency;
defparam SIN_COS_LOOKUP.C_MEM_TYPE = C_MEM_TYPE;
defparam SIN_COS_LOOKUP.C_NEGATIVE_COSINE = C_NEGATIVE_COSINE;
defparam SIN_COS_LOOKUP.C_NEGATIVE_SINE = C_NEGATIVE_SINE;
defparam SIN_COS_LOOKUP.C_OUTPUTS_REQUIRED = C_OUTPUTS_REQUIRED;
defparam SIN_COS_LOOKUP.C_OUTPUT_WIDTH = lookupOutputWidth;
defparam SIN_COS_LOOKUP.C_REG_INPUT = 0;
defparam SIN_COS_LOOKUP.C_REG_OUTPUT = C_PIPELINED;
defparam SIN_COS_LOOKUP.C_THETA_WIDTH = C_PHASE_ANGLE_WIDTH;


DITHER_ADD_V4_1 U1
(
	.A(offsetBus[C_ACCUMULATOR_WIDTH-1:0]),
	.ACLR(ACLR),
	.CE(CE),
	.CLK(CLK),
	.DITHERED_PHASE(ditherOut[C_PHASE_ANGLE_WIDTH-1:0]),
	.ND(ditherNd),
	.RDY(ditherRdy),
	.SCLR(SCLR)
);

defparam U1.ACCUM_WIDTH = C_ACCUMULATOR_WIDTH;
defparam U1.C_HAS_ACLR = C_HAS_ACLR;
defparam U1.C_HAS_CE = C_HAS_CE;
defparam U1.C_HAS_SCLR = C_HAS_SCLR;
defparam U1.C_PIPELINED = C_PIPELINED;
defparam U1.PHASE_WIDTH = C_PHASE_ANGLE_WIDTH;



// ------------- Power assignment ----------//
assign vccbus[0] = VCC;

endmodule 

`undef NONE
`undef PHASE_DITHERING
`undef EFF
`undef REG
`undef CONST
`undef ZERO_CYCLE
`undef ONE_CYCLE
`undef DIST_ROM
`undef BLOCK_ROM
`undef SINE_ONLY
`undef COSINE_ONLY
`undef SINE_AND_COSINE
