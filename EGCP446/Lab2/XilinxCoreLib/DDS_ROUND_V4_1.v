// $Id: DDS_ROUND_V4_1.v,v 1.2 2002/03/29 15:56:02 janeh Exp $
`timescale 1ns / 10ps
`define c_signed 0
`define c_unsigned 1

module DDS_ROUND_V4_1 (CE,CLK,DIN,ROUND) ;

// ---- User defined diagram parameters --- //
parameter C_HAS_CE = 0;
parameter C_INPUT_WIDTH = 35;
parameter C_OUTPUT_WIDTH = 18;

// ------------ Port declarations --------- //
input CE;
wire CE;
input CLK;
wire CLK;
input [C_INPUT_WIDTH-1:0] DIN;
wire [C_INPUT_WIDTH-1:0] DIN;

output [C_OUTPUT_WIDTH-1:0] ROUND;
wire [C_OUTPUT_WIDTH-1:0] ROUND;

// ----------------- Constants ------------ //
parameter DANGLING_INPUT_CONSTANT = 1'bZ;

// ----------- Signal declarations -------- //
wire [C_INPUT_WIDTH:0] noConnect;
wire [C_OUTPUT_WIDTH-1:0] noConnect2;
wire [C_OUTPUT_WIDTH:0] noConnect3;
wire [C_OUTPUT_WIDTH:0] outputTwosCompOut;
wire [C_OUTPUT_WIDTH-1:0] roundAdderOut;
wire [C_INPUT_WIDTH:0] twosCompOut;
wire NET3093;
wire NET3103;
wire NET3107;
wire NET3111;
wire NET3115;
wire NET3119;

// ---- Declaration for Dangling inputs ----//
wire Dangling_Input_Signal = DANGLING_INPUT_CONSTANT;

// ------- User defined Verilog code -------//

//----- Verilog statement0 ----//
assign ROUND = outputTwosCompOut[C_OUTPUT_WIDTH-1 : 0];

C_ADDSUB_V5_0 ROUNDING_ADDER
(
	.A(twosCompOut[C_INPUT_WIDTH-1:C_INPUT_WIDTH-C_OUTPUT_WIDTH]),
	.ACLR(Dangling_Input_Signal),
	.ADD(Dangling_Input_Signal),
	.AINIT(Dangling_Input_Signal),
	.ASET(Dangling_Input_Signal),
	.A_SIGNED(Dangling_Input_Signal),
	.B(twosCompOut[C_INPUT_WIDTH-1-C_OUTPUT_WIDTH:C_INPUT_WIDTH-1-C_OUTPUT_WIDTH]),
	.BYPASS(Dangling_Input_Signal),
	.B_IN(Dangling_Input_Signal),
	.B_OUT(NET3103),
	.B_SIGNED(Dangling_Input_Signal),
	.CE(Dangling_Input_Signal),
	.CLK(Dangling_Input_Signal),
	.C_IN(Dangling_Input_Signal),
	.C_OUT(NET3107),
	.OVFL(NET3111),
	.Q(noConnect2[C_OUTPUT_WIDTH-1:0]),
	.Q_B_OUT(NET3115),
	.Q_C_OUT(NET3119),
	.Q_OVFL(NET3093),
	.S(roundAdderOut[C_OUTPUT_WIDTH-1:0]),
	.SCLR(Dangling_Input_Signal),
	.SINIT(Dangling_Input_Signal),
	.SSET(Dangling_Input_Signal)
);

defparam ROUNDING_ADDER.C_A_TYPE = `c_signed;
defparam ROUNDING_ADDER.C_A_WIDTH = C_OUTPUT_WIDTH;
defparam ROUNDING_ADDER.C_B_CONSTANT = 0;
defparam ROUNDING_ADDER.C_B_TYPE = `c_unsigned;
defparam ROUNDING_ADDER.C_B_VALUE = "0000";
defparam ROUNDING_ADDER.C_B_WIDTH = 1;
defparam ROUNDING_ADDER.C_HAS_BYPASS = 0;
defparam ROUNDING_ADDER.C_HAS_B_IN = 0;
defparam ROUNDING_ADDER.C_HAS_CE = 0;
defparam ROUNDING_ADDER.C_HAS_C_IN = 0;
defparam ROUNDING_ADDER.C_HAS_OVFL = 0;
defparam ROUNDING_ADDER.C_HAS_Q = 0;
defparam ROUNDING_ADDER.C_HAS_Q_OVFL = 0;
defparam ROUNDING_ADDER.C_HAS_S = 1;
defparam ROUNDING_ADDER.C_HIGH_BIT = C_OUTPUT_WIDTH-1;
defparam ROUNDING_ADDER.C_LOW_BIT = 0;
defparam ROUNDING_ADDER.C_OUT_WIDTH = C_OUTPUT_WIDTH;

C_TWOS_COMP_V5_0 INPUT_TWOS_COMP
(
	.A(DIN[C_INPUT_WIDTH-1:0]),
	.ACLR(Dangling_Input_Signal),
	.AINIT(Dangling_Input_Signal),
	.ASET(Dangling_Input_Signal),
	.BYPASS(Dangling_Input_Signal),
	.CE(Dangling_Input_Signal),
	.CLK(Dangling_Input_Signal),
	.Q(noConnect[C_INPUT_WIDTH:0]),
	.S(twosCompOut[C_INPUT_WIDTH:0]),
	.SCLR(Dangling_Input_Signal),
	.SINIT(Dangling_Input_Signal),
	.SSET(Dangling_Input_Signal)
);

defparam INPUT_TWOS_COMP.C_HAS_ACLR = 0;
defparam INPUT_TWOS_COMP.C_HAS_AINIT = 0;
defparam INPUT_TWOS_COMP.C_HAS_ASET = 0;
defparam INPUT_TWOS_COMP.C_HAS_BYPASS = 0;
defparam INPUT_TWOS_COMP.C_HAS_CE = 0;
defparam INPUT_TWOS_COMP.C_HAS_Q = 0;
defparam INPUT_TWOS_COMP.C_HAS_S = 1;
defparam INPUT_TWOS_COMP.C_HAS_SCLR = 0;
defparam INPUT_TWOS_COMP.C_HAS_SINIT = 0;
defparam INPUT_TWOS_COMP.C_HAS_SSET = 0;
defparam INPUT_TWOS_COMP.C_PIPE_STAGES = 0;
defparam INPUT_TWOS_COMP.C_WIDTH = C_INPUT_WIDTH;

C_TWOS_COMP_V5_0 OUTPUT_TWOS_COMP
(
	.A(roundAdderOut[C_OUTPUT_WIDTH-1:0]),
	.ACLR(Dangling_Input_Signal),
	.AINIT(Dangling_Input_Signal),
	.ASET(Dangling_Input_Signal),
	.BYPASS(Dangling_Input_Signal),
	.CE(CE),
	.CLK(CLK),
	.Q(outputTwosCompOut[C_OUTPUT_WIDTH:0]),
	.S(noConnect3[C_OUTPUT_WIDTH:0]),
	.SCLR(Dangling_Input_Signal),
	.SINIT(Dangling_Input_Signal),
	.SSET(Dangling_Input_Signal)
);

defparam OUTPUT_TWOS_COMP.C_HAS_ACLR = 0;
defparam OUTPUT_TWOS_COMP.C_HAS_AINIT = 0;
defparam OUTPUT_TWOS_COMP.C_HAS_ASET = 0;
defparam OUTPUT_TWOS_COMP.C_HAS_BYPASS = 0;
defparam OUTPUT_TWOS_COMP.C_HAS_CE = C_HAS_CE;
defparam OUTPUT_TWOS_COMP.C_HAS_Q = 1;
defparam OUTPUT_TWOS_COMP.C_HAS_S = 0;
defparam OUTPUT_TWOS_COMP.C_HAS_SCLR = 0;
defparam OUTPUT_TWOS_COMP.C_HAS_SINIT = 0;
defparam OUTPUT_TWOS_COMP.C_HAS_SSET = 0;
defparam OUTPUT_TWOS_COMP.C_PIPE_STAGES = 0;
defparam OUTPUT_TWOS_COMP.C_WIDTH = C_OUTPUT_WIDTH;



endmodule 
