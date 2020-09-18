// $Revision: 1.2 $ $Date: 2002/03/29 15:56:02 $
`timescale 1ns / 10ps
`define EFF 2
`define c_signed 0
`define c_unsigned 1
`define c_fixed 0
`define v2_parallel 1
`define c_add 0
`define c_sub 1

module C_EFF_V4_1 (ACLR,CE,CLK,ND,SCLR,ACCUMULATOR,COS_IN,SIN_IN,RDY,COS,
SIN) ;

// ---- User defined diagram parameters --- //

parameter C_ACCUM_WIDTH=32;

parameter C_CONST_WIDTH=16;

parameter C_HAS_ACLR=0;

parameter C_HAS_CE=0;

parameter C_HAS_SCLR=0;

parameter C_INPUT_WIDTH= 18;

parameter C_LOOKUP_LATENCY=1;

parameter C_NOISE_SHAPING=`EFF;

parameter C_OUTPUT_WIDTH=18;

parameter C_PHASE_WIDTH=12;

parameter C_PIPELINED=1;

parameter X_ACCUM_HIGH_BIT=(C_ACCUM_WIDTH>=20)?19:C_ACCUM_WIDTH-1;

parameter X_ACCUM_LOW_BIT=(C_ACCUM_WIDTH>=5)?4:0;


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
input [C_ACCUM_WIDTH-1:0] ACCUMULATOR;
wire [C_ACCUM_WIDTH-1:0] ACCUMULATOR;
input [C_INPUT_WIDTH-1:0] COS_IN;
wire [C_INPUT_WIDTH-1:0] COS_IN;
input [C_INPUT_WIDTH-1:0] SIN_IN;
wire [C_INPUT_WIDTH-1:0] SIN_IN;
output RDY;
wire RDY;
output [C_OUTPUT_WIDTH-1:0] COS;
wire [C_OUTPUT_WIDTH-1:0] COS;
output [C_OUTPUT_WIDTH-1:0] SIN;
wire [C_OUTPUT_WIDTH-1:0] SIN;

// ----------------- Constants ------------ //
parameter DANGLING_INPUT_CONSTANT = 1'bZ;

// ----------- Signal declarations -------- //
wire ceDelay;
wire cosOvfl;
wire gnd;
wire NET14694;
wire NET14698;
wire NET14702;
wire NET14706;
wire NET14710;
wire NET14720;
wire NET14724;
wire NET14797;
wire NET14806;
wire NET14810;
wire NET14814;
wire NET14818;
wire NET14822;
wire NET14835;
wire NET14842;
wire NET14846;
wire NET14850;
wire NET14854;
wire NET14858;
wire sinOvfl;
wire [15:0] accumInt;
wire [16:0] constZeroPadding;
wire [15:0] const_in;
wire [16:0] const_mult;
wire [34:0] cosAddIn;
wire [34:0] cosAddOut;
wire [C_INPUT_WIDTH-1:0] cosDelayed;
wire [C_OUTPUT_WIDTH-1:0] cosRegOut;
wire [C_OUTPUT_WIDTH-1:0] cosRound;
wire [34:0] cosSaturate;
wire [34:0] cosSaturateReg;
wire [C_INPUT_WIDTH-1:0] COS_MULT_IN;
wire [34:0] cos_mult_o;
wire [34:0] cos_mult_out;
wire [34:0] cos_mult_q;
wire [16:0] errorToRad;
wire [16:0] noConnect;
wire [34:0] noConnect2;
wire [34:0] noConnect3;
wire [4:0] noConnect4;
wire [4:0] noConnect5;
wire [0:0] outRegCe;
wire [0:0] rdyBus;
wire [34:0] sinAddIn;
wire [34:0] sinAddOut;
wire [C_INPUT_WIDTH-1:0] sinDelayed;
wire [C_OUTPUT_WIDTH-1:0] sinRegOut;
wire [C_OUTPUT_WIDTH-1:0] sinRound;
wire [34:0] sinSaturate;
wire [34:0] sinSaturateReg;
wire [C_INPUT_WIDTH-1:0] SIN_MULT_IN;
wire [34:0] sin_mult_o;
wire [34:0] sin_mult_out;
wire [34:0] sin_mult_q;

// ---- Declaration for Dangling inputs ----//
wire Dangling_Input_Signal = DANGLING_INPUT_CONSTANT;

// ----------- Continues assignments -------//

assign const_in =  16'b0000000001100101;

assign accumInt = (C_NOISE_SHAPING==`EFF)?
	ACCUMULATOR[X_ACCUM_HIGH_BIT:X_ACCUM_LOW_BIT] : 0;

assign cos_mult_out = cos_mult_q;
assign sin_mult_out = sin_mult_q;

assign constZeroPadding = {17{1'b0}};

assign cosAddIn = {cosDelayed, constZeroPadding};
assign sinAddIn = {sinDelayed, constZeroPadding};

assign SIN = (C_NOISE_SHAPING==`EFF)?
	sinRegOut : SIN_IN;
assign COS = (C_NOISE_SHAPING==`EFF)?
	cosRegOut : COS_IN;

assign SIN_MULT_IN = COS_IN;
assign COS_MULT_IN = SIN_IN;

assign sinSaturate = (sinOvfl==1'b1)?
	((sinAddOut[34]==1'b0)?
		{1'b1, {34{1'b0}}}:
		{1'b0, {34{1'b1}}}):sinAddOut;

assign cosSaturate = (cosOvfl==1'b1)?
	((cosAddOut[34]==1'b0)?
		{1'b1, {34{1'b0}}}:
		{1'b0, {34{1'b1}}}):cosAddOut;

assign RDY = (C_PIPELINED==0 || C_NOISE_SHAPING!=`EFF)?
	ND : rdyBus[0];

assign outRegCe[0] = (C_HAS_CE==1)?
	CE && ceDelay:ceDelay;
// -------- Component instantiations -------//
C_SHIFT_RAM_V5_0 COS_PIPE_BALANCE
(
	.A(Dangling_Input_Signal),
	.ACLR(ACLR),
	.AINIT(Dangling_Input_Signal),
	.ASET(Dangling_Input_Signal),
	.CE(CE),
	.CLK(CLK),
	.D(COS_IN[C_INPUT_WIDTH-1:0]),
	.Q(cosDelayed[C_INPUT_WIDTH-1:0]),
	.SCLR(SCLR),
	.SINIT(Dangling_Input_Signal),
	.SSET(Dangling_Input_Signal)
);

defparam COS_PIPE_BALANCE.C_ADDR_WIDTH = 1;
defparam COS_PIPE_BALANCE.C_DEPTH = 2;
defparam COS_PIPE_BALANCE.C_GENERATE_MIF = 0;
defparam COS_PIPE_BALANCE.C_HAS_A = 0;
defparam COS_PIPE_BALANCE.C_HAS_ACLR = 0;
defparam COS_PIPE_BALANCE.C_HAS_AINIT = 0;
defparam COS_PIPE_BALANCE.C_HAS_ASET = 0;
defparam COS_PIPE_BALANCE.C_HAS_CE = C_HAS_CE;
defparam COS_PIPE_BALANCE.C_HAS_SCLR = 0;
defparam COS_PIPE_BALANCE.C_HAS_SINIT = 0;
defparam COS_PIPE_BALANCE.C_HAS_SSET = 0;
defparam COS_PIPE_BALANCE.C_READ_MIF = 0;
defparam COS_PIPE_BALANCE.C_REG_LAST_BIT = 0;
defparam COS_PIPE_BALANCE.C_SHIFT_TYPE = `c_fixed;
defparam COS_PIPE_BALANCE.C_WIDTH = C_INPUT_WIDTH;


DDS_ROUND_V4_1 COS_ROUND
(
	.CE(CE),
	.CLK(CLK),
	.DIN(cosSaturateReg[34:0]),
	.ROUND(cosRound[C_OUTPUT_WIDTH-1:0])
);

defparam COS_ROUND.C_HAS_CE = C_HAS_CE;
defparam COS_ROUND.C_INPUT_WIDTH = 35;
defparam COS_ROUND.C_OUTPUT_WIDTH = C_OUTPUT_WIDTH;


C_REG_FD_V5_0 COS_SAT_REG
(
	.ACLR(ACLR),
	.AINIT(Dangling_Input_Signal),
	.ASET(Dangling_Input_Signal),
	.CE(CE),
	.CLK(CLK),
	.D(cosSaturate[34:0]),
	.Q(cosSaturateReg[34:0]),
	.SCLR(SCLR),
	.SINIT(Dangling_Input_Signal),
	.SSET(Dangling_Input_Signal)
);

defparam COS_SAT_REG.C_HAS_ACLR = C_HAS_ACLR;
defparam COS_SAT_REG.C_HAS_AINIT = 0;
defparam COS_SAT_REG.C_HAS_ASET = 0;
defparam COS_SAT_REG.C_HAS_CE = C_HAS_CE;
defparam COS_SAT_REG.C_HAS_SCLR = C_HAS_SCLR;
defparam COS_SAT_REG.C_HAS_SINIT = 0;
defparam COS_SAT_REG.C_HAS_SSET = 0;
defparam COS_SAT_REG.C_WIDTH = 35;


C_SHIFT_RAM_V5_0 SIN_PIPE_BALANCE
(
	.A(Dangling_Input_Signal),
	.ACLR(ACLR),
	.AINIT(Dangling_Input_Signal),
	.ASET(Dangling_Input_Signal),
	.CE(CE),
	.CLK(CLK),
	.D(SIN_IN[C_INPUT_WIDTH-1:0]),
	.Q(sinDelayed[C_INPUT_WIDTH-1:0]),
	.SCLR(SCLR),
	.SINIT(Dangling_Input_Signal),
	.SSET(Dangling_Input_Signal)
);

defparam SIN_PIPE_BALANCE.C_ADDR_WIDTH = 1;
defparam SIN_PIPE_BALANCE.C_DEPTH = 2;
defparam SIN_PIPE_BALANCE.C_GENERATE_MIF = 0;
defparam SIN_PIPE_BALANCE.C_HAS_A = 0;
defparam SIN_PIPE_BALANCE.C_HAS_ACLR = 0;
defparam SIN_PIPE_BALANCE.C_HAS_AINIT = 0;
defparam SIN_PIPE_BALANCE.C_HAS_ASET = 0;
defparam SIN_PIPE_BALANCE.C_HAS_CE = C_HAS_CE;
defparam SIN_PIPE_BALANCE.C_HAS_SCLR = 0;
defparam SIN_PIPE_BALANCE.C_HAS_SINIT = 0;
defparam SIN_PIPE_BALANCE.C_HAS_SSET = 0;
defparam SIN_PIPE_BALANCE.C_READ_MIF = 0;
defparam SIN_PIPE_BALANCE.C_REG_LAST_BIT = 0;
defparam SIN_PIPE_BALANCE.C_SHIFT_TYPE = `c_fixed;
defparam SIN_PIPE_BALANCE.C_WIDTH = C_INPUT_WIDTH;

DDS_ROUND_V4_1 SIN_ROUND
(
	.CE(CE),
	.CLK(CLK),
	.DIN(sinSaturateReg[34:0]),
	.ROUND(sinRound[C_OUTPUT_WIDTH-1:0])
);

defparam SIN_ROUND.C_HAS_CE = C_HAS_CE;
defparam SIN_ROUND.C_INPUT_WIDTH = 35;
defparam SIN_ROUND.C_OUTPUT_WIDTH = C_OUTPUT_WIDTH;


C_REG_FD_V5_0 SIN_SAT_REG
(
	.ACLR(ACLR),
	.AINIT(Dangling_Input_Signal),
	.ASET(Dangling_Input_Signal),
	.CE(CE),
	.CLK(CLK),
	.D(sinSaturate[34:0]),
	.Q(sinSaturateReg[34:0]),
	.SCLR(SCLR),
	.SINIT(Dangling_Input_Signal),
	.SSET(Dangling_Input_Signal)
);

defparam SIN_SAT_REG.C_HAS_ACLR = C_HAS_ACLR;
defparam SIN_SAT_REG.C_HAS_AINIT = 0;
defparam SIN_SAT_REG.C_HAS_ASET = 0;
defparam SIN_SAT_REG.C_HAS_CE = C_HAS_CE;
defparam SIN_SAT_REG.C_HAS_SCLR = C_HAS_SCLR;
defparam SIN_SAT_REG.C_HAS_SINIT = 0;
defparam SIN_SAT_REG.C_HAS_SSET = 0;
defparam SIN_SAT_REG.C_WIDTH = 35;


C_SHIFT_FD_V5_0 ce_delay
(
	.ACLR(ACLR),
	.AINIT(Dangling_Input_Signal),
	.ASET(Dangling_Input_Signal),
	.CE(CE),
	.CLK(CLK),
	.D(noConnect5[4:0]),
	.LSB_2_MSB(Dangling_Input_Signal),
	.P_LOAD(Dangling_Input_Signal),
	.Q(noConnect4[4:0]),
	.SCLR(SCLR),
	.SDIN(ND),
	.SDOUT(ceDelay),
	.SINIT(Dangling_Input_Signal),
	.SSET(Dangling_Input_Signal)
);

defparam ce_delay.C_HAS_ACLR = C_HAS_ACLR;
defparam ce_delay.C_HAS_CE = C_HAS_CE;
defparam ce_delay.C_HAS_D = 0;
defparam ce_delay.C_HAS_LSB_2_MSB = 0;
defparam ce_delay.C_HAS_Q = 0;
defparam ce_delay.C_HAS_SCLR = C_HAS_SCLR;
defparam ce_delay.C_HAS_SDIN = 1;
defparam ce_delay.C_HAS_SDOUT = 1;
defparam ce_delay.C_WIDTH = 5;


MULT_GEN_V5_0 constant_mult
(
	.A(accumInt[15:0]),
	.ACLR(gnd),
	.A_SIGNED(gnd),
	.B(const_in[15:0]),
	.CE(CE),
	.CLK(CLK),
	.LOADB(gnd),
	.LOAD_DONE(NET14694),
	.ND(gnd),
	.O(const_mult[16:0]),
	.Q(noConnect[16:0]),
	.RDY(NET14698),
	.RFD(NET14702),
	.SCLR(gnd),
	.SWAPB(gnd)
);

defparam constant_mult.C_A_TYPE = `c_unsigned;
defparam constant_mult.C_A_WIDTH = 16;
defparam constant_mult.C_BAAT = 16;
defparam constant_mult.C_B_TYPE = `c_unsigned;
defparam constant_mult.C_B_WIDTH = 16;
defparam constant_mult.C_HAS_B = 1;
defparam constant_mult.C_HAS_CE = C_HAS_CE;
defparam constant_mult.C_HAS_O = 1;
defparam constant_mult.C_HAS_Q = 0;
defparam constant_mult.C_MULT_TYPE = `v2_parallel;
defparam constant_mult.C_OUT_WIDTH = 17;
defparam constant_mult.C_REG_A_B_INPUTS = 0;

C_ADDSUB_V5_0 cos_add
(
	.A(cosAddIn[34:0]),
	.ACLR(ACLR),
	.ADD(Dangling_Input_Signal),
	.AINIT(Dangling_Input_Signal),
	.ASET(Dangling_Input_Signal),
	.A_SIGNED(Dangling_Input_Signal),
	.B(cos_mult_out[34:0]),
	.BYPASS(Dangling_Input_Signal),
	.B_IN(Dangling_Input_Signal),
	.B_OUT(NET14842),
	.B_SIGNED(Dangling_Input_Signal),
	.CE(CE),
	.CLK(CLK),
	.C_IN(Dangling_Input_Signal),
	.C_OUT(NET14846),
	.OVFL(NET14850),
	.Q(cosAddOut[34:0]),
	.Q_B_OUT(NET14854),
	.Q_C_OUT(NET14858),
	.Q_OVFL(cosOvfl),
	.S(noConnect3[34:0]),
	.SCLR(SCLR),
	.SINIT(Dangling_Input_Signal),
	.SSET(Dangling_Input_Signal)
);

defparam cos_add.C_ADD_MODE = `c_add;
defparam cos_add.C_A_TYPE = `c_signed;
defparam cos_add.C_A_WIDTH = 35;
defparam cos_add.C_BYPASS_LOW = 0;
defparam cos_add.C_B_CONSTANT = 0;
defparam cos_add.C_B_TYPE = `c_signed;
defparam cos_add.C_B_WIDTH = 35;
defparam cos_add.C_HAS_ACLR = 0;
defparam cos_add.C_HAS_ADD = 0;
defparam cos_add.C_HAS_AINIT = 0;
defparam cos_add.C_HAS_ASET = 0;
defparam cos_add.C_HAS_A_SIGNED = 0;
defparam cos_add.C_HAS_BYPASS = 0;
defparam cos_add.C_HAS_BYPASS_WITH_CIN = 0;
defparam cos_add.C_HAS_B_IN = 0;
defparam cos_add.C_HAS_B_OUT = 0;
defparam cos_add.C_HAS_B_SIGNED = 0;
defparam cos_add.C_HAS_CE = C_HAS_CE;
defparam cos_add.C_HAS_C_IN = 0;
defparam cos_add.C_HAS_C_OUT = 0;
defparam cos_add.C_HAS_OVFL = 0;
defparam cos_add.C_HAS_Q = 1;
defparam cos_add.C_HAS_Q_B_OUT = 0;
defparam cos_add.C_HAS_Q_C_OUT = 0;
defparam cos_add.C_HAS_Q_OVFL = 1;
defparam cos_add.C_HAS_S = 0;
defparam cos_add.C_HAS_SCLR = 0;
defparam cos_add.C_HAS_SINIT = 0;
defparam cos_add.C_HAS_SSET = 0;
defparam cos_add.C_HIGH_BIT = 34;
defparam cos_add.C_LATENCY = 0;
defparam cos_add.C_LOW_BIT = 0;
defparam cos_add.C_OUT_WIDTH = 35;
defparam cos_add.C_PIPE_STAGES = 0;


MULT_GEN_V5_0 cos_mult
(
	.A(COS_MULT_IN[C_INPUT_WIDTH-1:0]),
	.ACLR(gnd),
	.A_SIGNED(gnd),
	.B(errorToRad[16:0]),
	.CE(CE),
	.CLK(CLK),
	.LOADB(gnd),
	.LOAD_DONE(NET14835),
	.ND(gnd),
	.O(cos_mult_o[34:0]),
	.Q(cos_mult_q[34:0]),
	.RDY(NET14724),
	.RFD(NET14720),
	.SCLR(gnd),
	.SWAPB(gnd)
);

defparam cos_mult.C_A_TYPE = `c_signed;
defparam cos_mult.C_A_WIDTH = C_INPUT_WIDTH;
defparam cos_mult.C_BAAT = C_INPUT_WIDTH;
defparam cos_mult.C_B_TYPE = `c_unsigned;
defparam cos_mult.C_B_WIDTH = 17;
defparam cos_mult.C_HAS_CE = C_HAS_CE;
defparam cos_mult.C_HAS_O = 0;
defparam cos_mult.C_HAS_Q = 1;
defparam cos_mult.C_MULT_TYPE = `v2_parallel;
defparam cos_mult.C_OUT_WIDTH = 35;
defparam cos_mult.C_PIPELINE = 1;
defparam cos_mult.C_REG_A_B_INPUTS = 0;

C_REG_FD_V5_0 cos_reg
(
	.ACLR(ACLR),
	.AINIT(Dangling_Input_Signal),
	.ASET(Dangling_Input_Signal),
	.CE(outRegCe[0]),
	.CLK(CLK),
	.D(cosRound[C_OUTPUT_WIDTH-1:0]),
	.Q(cosRegOut[C_OUTPUT_WIDTH-1:0]),
	.SCLR(SCLR),
	.SINIT(Dangling_Input_Signal),
	.SSET(Dangling_Input_Signal)
);

defparam cos_reg.C_HAS_ACLR = C_HAS_ACLR;
defparam cos_reg.C_HAS_AINIT = 0;
defparam cos_reg.C_HAS_ASET = 0;
defparam cos_reg.C_HAS_CE = 1;
defparam cos_reg.C_HAS_SCLR = C_HAS_SCLR;
defparam cos_reg.C_HAS_SINIT = 0;
defparam cos_reg.C_HAS_SSET = 0;
defparam cos_reg.C_WIDTH = C_OUTPUT_WIDTH;


C_SHIFT_RAM_V5_0 error_delay
(
	.A(Dangling_Input_Signal),
	.ACLR(ACLR),
	.AINIT(Dangling_Input_Signal),
	.ASET(Dangling_Input_Signal),
	.CE(CE),
	.CLK(CLK),
	.D(const_mult[16:0]),
	.Q(errorToRad[16:0]),
	.SCLR(SCLR),
	.SINIT(Dangling_Input_Signal),
	.SSET(Dangling_Input_Signal)
);

defparam error_delay.C_ADDR_WIDTH = 1;
defparam error_delay.C_DEPTH = 3;
defparam error_delay.C_HAS_CE = C_HAS_CE;
defparam error_delay.C_WIDTH = 17;

C_REG_FD_V5_0 rdyReg
(
	.ACLR(ACLR),
	.AINIT(Dangling_Input_Signal),
	.ASET(Dangling_Input_Signal),
	.CE(CE),
	.CLK(CLK),
	.D(outRegCe[0:0]),
	.Q(rdyBus[0:0]),
	.SCLR(SCLR),
	.SINIT(Dangling_Input_Signal),
	.SSET(Dangling_Input_Signal)
);

defparam rdyReg.C_HAS_ACLR = C_HAS_ACLR;
defparam rdyReg.C_HAS_AINIT = 0;
defparam rdyReg.C_HAS_ASET = 0;
defparam rdyReg.C_HAS_CE = C_HAS_CE;
defparam rdyReg.C_HAS_SCLR = C_HAS_SCLR;
defparam rdyReg.C_HAS_SINIT = 0;
defparam rdyReg.C_HAS_SSET = 0;
defparam rdyReg.C_WIDTH = 1;


C_ADDSUB_V5_0 sin_add
(
	.A(sinAddIn[34:0]),
	.ACLR(ACLR),
	.ADD(Dangling_Input_Signal),
	.AINIT(Dangling_Input_Signal),
	.ASET(Dangling_Input_Signal),
	.A_SIGNED(Dangling_Input_Signal),
	.B(sin_mult_out[34:0]),
	.BYPASS(Dangling_Input_Signal),
	.B_IN(Dangling_Input_Signal),
	.B_OUT(NET14806),
	.B_SIGNED(Dangling_Input_Signal),
	.CE(CE),
	.CLK(CLK),
	.C_IN(Dangling_Input_Signal),
	.C_OUT(NET14810),
	.OVFL(NET14814),
	.Q(sinAddOut[34:0]),
	.Q_B_OUT(NET14818),
	.Q_C_OUT(NET14822),
	.Q_OVFL(sinOvfl),
	.S(noConnect2[34:0]),
	.SCLR(SCLR),
	.SINIT(Dangling_Input_Signal),
	.SSET(Dangling_Input_Signal)
);

defparam sin_add.C_ADD_MODE = `c_sub;
defparam sin_add.C_A_TYPE = `c_signed;
defparam sin_add.C_A_WIDTH = 35;
defparam sin_add.C_BYPASS_LOW = 0;
defparam sin_add.C_B_CONSTANT = 0;
defparam sin_add.C_B_TYPE = `c_signed;
defparam sin_add.C_B_WIDTH = 35;
defparam sin_add.C_HAS_ACLR = 0;
defparam sin_add.C_HAS_ADD = 0;
defparam sin_add.C_HAS_AINIT = 0;
defparam sin_add.C_HAS_ASET = 0;
defparam sin_add.C_HAS_A_SIGNED = 0;
defparam sin_add.C_HAS_BYPASS = 0;
defparam sin_add.C_HAS_BYPASS_WITH_CIN = 0;
defparam sin_add.C_HAS_B_IN = 0;
defparam sin_add.C_HAS_B_OUT = 0;
defparam sin_add.C_HAS_B_SIGNED = 0;
defparam sin_add.C_HAS_CE = C_HAS_CE;
defparam sin_add.C_HAS_C_IN = 0;
defparam sin_add.C_HAS_C_OUT = 0;
defparam sin_add.C_HAS_OVFL = 0;
defparam sin_add.C_HAS_Q = 1;
defparam sin_add.C_HAS_Q_B_OUT = 0;
defparam sin_add.C_HAS_Q_C_OUT = 0;
defparam sin_add.C_HAS_Q_OVFL = 1;
defparam sin_add.C_HAS_S = 0;
defparam sin_add.C_HAS_SCLR = 0;
defparam sin_add.C_HAS_SINIT = 0;
defparam sin_add.C_HAS_SSET = 0;
defparam sin_add.C_HIGH_BIT = 34;
defparam sin_add.C_LATENCY = 0;
defparam sin_add.C_LOW_BIT = 0;
defparam sin_add.C_OUT_WIDTH = 35;
defparam sin_add.C_PIPE_STAGES = 0;


MULT_GEN_V5_0 sin_mult
(
	.A(SIN_MULT_IN[C_INPUT_WIDTH-1:0]),
	.ACLR(gnd),
	.A_SIGNED(gnd),
	.B(errorToRad[16:0]),
	.CE(CE),
	.CLK(CLK),
	.LOADB(gnd),
	.LOAD_DONE(NET14797),
	.ND(gnd),
	.O(sin_mult_o[34:0]),
	.Q(sin_mult_q[34:0]),
	.RDY(NET14706),
	.RFD(NET14710),
	.SCLR(gnd),
	.SWAPB(gnd)
);

defparam sin_mult.C_A_TYPE = `c_signed;
defparam sin_mult.C_A_WIDTH = C_INPUT_WIDTH;
defparam sin_mult.C_BAAT = C_INPUT_WIDTH;
defparam sin_mult.C_B_TYPE = `c_unsigned;
defparam sin_mult.C_B_WIDTH = 17;
defparam sin_mult.C_HAS_CE = C_HAS_CE;
defparam sin_mult.C_HAS_O = 0;
defparam sin_mult.C_HAS_Q = 1;
defparam sin_mult.C_MULT_TYPE = `v2_parallel;
defparam sin_mult.C_OUT_WIDTH = 35;
defparam sin_mult.C_PIPELINE = 1;
defparam sin_mult.C_REG_A_B_INPUTS = 0;


C_REG_FD_V5_0 sin_reg
(
	.ACLR(ACLR),
	.AINIT(Dangling_Input_Signal),
	.ASET(Dangling_Input_Signal),
	.CE(outRegCe[0]),
	.CLK(CLK),
	.D(sinRound[C_OUTPUT_WIDTH-1:0]),
	.Q(sinRegOut[C_OUTPUT_WIDTH-1:0]),
	.SCLR(SCLR),
	.SINIT(Dangling_Input_Signal),
	.SSET(Dangling_Input_Signal)
);

defparam sin_reg.C_HAS_ACLR = C_HAS_ACLR;
defparam sin_reg.C_HAS_AINIT = 0;
defparam sin_reg.C_HAS_ASET = 0;
defparam sin_reg.C_HAS_CE = 1;
defparam sin_reg.C_HAS_SCLR = C_HAS_SCLR;
defparam sin_reg.C_HAS_SINIT = 0;
defparam sin_reg.C_HAS_SSET = 0;
defparam sin_reg.C_WIDTH = C_OUTPUT_WIDTH;



endmodule 

`undef EFF
`undef c_signed
`undef c_unsigned
`undef c_fixed
`undef v2_parallel
`undef c_add
`undef c_sub
