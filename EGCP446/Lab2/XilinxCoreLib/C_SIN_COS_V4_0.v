// $Header: /devl/xcs/repo/env/Databases/ip/src/com/xilinx/ip/sincos_v4_0/simulation/C_SIN_COS_V4_0.v,v 1.4 2002/03/29 16:01:56 janeh Exp $

`timescale 1ns/10ps

`define SINE_ONLY 0
`define COSINE_ONLY 1
`define SINE_AND_COSINE 2
`define DIST_ROM 0
`define BLOCK_ROM 1
`define allUKs {C_OUTPUT_WIDTH{1'bX}}
`define c_sdin 5

module C_SIN_COS_V4_0 (ACLR,CE,CLK,COSINE,ND,RDY,RFD,SCLR,SINE,THETA) ;

// ---- User defined diagram parameters --- //
parameter C_ENABLE_RLOCS = 0;
parameter C_HAS_ACLR = 0;
parameter C_HAS_CE = 0;
parameter C_HAS_CLK = 0;
parameter C_HAS_ND = 1;
parameter C_HAS_RDY = 1;
parameter C_HAS_RFD = 1;
parameter C_HAS_SCLR = 0;
parameter C_LATENCY = 0;
parameter C_MEM_TYPE = `DIST_ROM;
parameter C_NEGATIVE_COSINE = 0;
parameter C_NEGATIVE_SINE = 0;
parameter C_OUTPUTS_REQUIRED = `SINE_ONLY;
parameter C_OUTPUT_WIDTH = 16;
parameter C_PIPE_STAGES = 0;
parameter C_REG_INPUT = 0;
parameter C_REG_OUTPUT = 0;
parameter C_THETA_WIDTH = 4;
parameter hasOutputRegCe = (C_HAS_CE==1 || ((C_HAS_ACLR==1 || C_HAS_SCLR==1)  && C_LATENCY > 1))?1:0;
parameter latencyOutRegCe = (C_LATENCY>1)?C_LATENCY:2;
parameter latencyRdyPipeline = (C_LATENCY>0)?C_LATENCY:1;

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
input [C_THETA_WIDTH-1:0] THETA;
wire [C_THETA_WIDTH-1:0] THETA;

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
wire [C_OUTPUT_WIDTH-1:0] cos_outreg;
wire [C_OUTPUT_WIDTH-1:0] cos_pipe;
wire [C_OUTPUT_WIDTH-1:0] cos_pipeout;
wire delayedCe;
wire [latencyOutRegCe-2:0] hasOutRegCe1_open;
wire intND;
wire intRdy;
wire [latencyOutRegCe-2:0] outRegCeDangle;
reg outputRegCe;
wire [latencyRdyPipeline-1:0] rdyPipelineDangle;
wire [latencyRdyPipeline-1:0] rdy_pipeline_open;
wire [C_OUTPUT_WIDTH-1:0] sin_outreg;
wire [C_OUTPUT_WIDTH-1:0] sin_pipe;
wire [C_OUTPUT_WIDTH-1:0] sin_pipeout;

// ---- Declaration for Dangling inputs ----//
wire Dangling_Input_Signal = DANGLING_INPUT_CONSTANT;

// ------- User defined Verilog code -------//

//----- Verilog statement0 ----//
always @(delayedCe or CE)
		begin
			if (C_HAS_ACLR==1 || C_HAS_SCLR==1)
				begin
					if (C_HAS_CE==1 && (C_LATENCY > 1))
						outputRegCe <= CE && delayedCe;
					else if (C_LATENCY > 1)
						outputRegCe <= delayedCe;
					else if (C_HAS_CE)
						outputRegCe <= CE;
				end
			else if (C_HAS_CE==1)
				outputRegCe <= CE;
		end

//----- Verilog statement1 ----//
wire [C_OUTPUT_WIDTH-1 : 0] intSine = (C_REG_OUTPUT==1 ? sin_outreg : sin_pipeout);
assign SINE = (((C_OUTPUTS_REQUIRED == `SINE_ONLY) ||
	(C_OUTPUTS_REQUIRED == `SINE_AND_COSINE)) ? intSine : `allUKs);
wire [C_OUTPUT_WIDTH-1 : 0] intCosine = (C_REG_OUTPUT==1 ? cos_outreg : cos_pipeout);
assign COSINE = (((C_OUTPUTS_REQUIRED == `COSINE_ONLY) ||
	(C_OUTPUTS_REQUIRED == `SINE_AND_COSINE)) ? intCosine : `allUKs);
assign intND = (C_HAS_ND == 1 ? ND : 1'b1);
assign RFD = (C_HAS_RFD == 1 ? 1'b1 : 1'bX); 
wire intRdy2 = (C_HAS_RDY==1 && (C_LATENCY==0) ? intND : 1'bX);
assign RDY = (C_HAS_RDY==1 && (C_LATENCY>0) ? intRdy : intRdy2);


TRIG_TABLE_V4_0 trig_arrays
(
	.cos_table(cos_pipe[C_OUTPUT_WIDTH-1:0]),
	.sin_table(sin_pipe[C_OUTPUT_WIDTH-1:0]),
	.theta(THETA[C_THETA_WIDTH-1:0])
);

defparam trig_arrays.minusCos = C_NEGATIVE_COSINE;
defparam trig_arrays.minusSin = C_NEGATIVE_SINE;
defparam trig_arrays.output_width = C_OUTPUT_WIDTH;
defparam trig_arrays.theta_width = C_THETA_WIDTH;


PIPE_BHV_V4_0 sine_pipeline
(
	.ACLR(ACLR),
	.CE(CE),
	.CLK(CLK),
	.D(sin_pipe[C_OUTPUT_WIDTH-1:0]),
	.Q(sin_pipeout[C_OUTPUT_WIDTH-1:0]),
	.SCLR(SCLR)
);

defparam sine_pipeline.C_HAS_ACLR = C_HAS_ACLR*C_REG_OUTPUT;
defparam sine_pipeline.C_HAS_CE = C_HAS_CE;
defparam sine_pipeline.C_HAS_SCLR = C_HAS_SCLR*C_REG_OUTPUT;
defparam sine_pipeline.C_PIPE_STAGES = C_LATENCY-C_REG_OUTPUT;
defparam sine_pipeline.C_WIDTH = C_OUTPUT_WIDTH;


PIPE_BHV_V4_0 cosine_pipeline
(
	.ACLR(ACLR),
	.CE(CE),
	.CLK(CLK),
	.D(cos_pipe[C_OUTPUT_WIDTH-1:0]),
	.Q(cos_pipeout[C_OUTPUT_WIDTH-1:0]),
	.SCLR(SCLR)
);

defparam cosine_pipeline.C_HAS_ACLR = C_HAS_ACLR*C_REG_OUTPUT;
defparam cosine_pipeline.C_HAS_CE = C_HAS_CE;
defparam cosine_pipeline.C_HAS_SCLR = C_HAS_SCLR*C_REG_OUTPUT;
defparam cosine_pipeline.C_PIPE_STAGES = C_LATENCY-C_REG_OUTPUT;
defparam cosine_pipeline.C_WIDTH = C_OUTPUT_WIDTH;


C_REG_FD_V5_0 sin_output_reg
(
	.ACLR(ACLR),
	.AINIT(Dangling_Input_Signal),
	.ASET(Dangling_Input_Signal),
	.CE(outputRegCe),
	.CLK(CLK),
	.D(sin_pipeout[C_OUTPUT_WIDTH-1:0]),
	.Q(sin_outreg[C_OUTPUT_WIDTH-1:0]),
	.SCLR(SCLR),
	.SINIT(Dangling_Input_Signal),
	.SSET(Dangling_Input_Signal)
);

defparam sin_output_reg.C_HAS_ACLR = C_HAS_ACLR*C_REG_OUTPUT;
defparam sin_output_reg.C_HAS_CE = hasOutputRegCe;
defparam sin_output_reg.C_HAS_SCLR = C_HAS_SCLR*C_REG_OUTPUT;
defparam sin_output_reg.C_WIDTH = C_OUTPUT_WIDTH;


C_REG_FD_V5_0 cos_output_reg
(
	.ACLR(ACLR),
	.AINIT(Dangling_Input_Signal),
	.ASET(Dangling_Input_Signal),
	.CE(outputRegCe),
	.CLK(CLK),
	.D(cos_pipeout[C_OUTPUT_WIDTH-1:0]),
	.Q(cos_outreg[C_OUTPUT_WIDTH-1:0]),
	.SCLR(SCLR),
	.SINIT(Dangling_Input_Signal),
	.SSET(Dangling_Input_Signal)
);

defparam cos_output_reg.C_HAS_ACLR = C_HAS_ACLR*C_REG_OUTPUT;
defparam cos_output_reg.C_HAS_CE = hasOutputRegCe;
defparam cos_output_reg.C_HAS_SCLR = C_HAS_SCLR*C_REG_OUTPUT;
defparam cos_output_reg.C_WIDTH = C_OUTPUT_WIDTH;

C_SHIFT_FD_V5_0 hasOutRegCe1
(
	.ACLR(ACLR),
	.AINIT(Dangling_Input_Signal),
	.ASET(Dangling_Input_Signal),
	.CE(CE),
	.CLK(CLK),
	.D(outRegCeDangle[latencyOutRegCe-2:0]),
	.LSB_2_MSB(Dangling_Input_Signal),
	.P_LOAD(Dangling_Input_Signal),
	.Q(hasOutRegCe1_open[latencyOutRegCe-2:0]),
	.SCLR(SCLR),
	.SDIN(intND),
	.SDOUT(delayedCe),
	.SINIT(Dangling_Input_Signal),
	.SSET(Dangling_Input_Signal)
);

defparam hasOutRegCe1.C_FILL_DATA = `c_sdin;
defparam hasOutRegCe1.C_HAS_ACLR = C_HAS_ACLR*C_REG_OUTPUT;
defparam hasOutRegCe1.C_HAS_CE = C_HAS_CE;
defparam hasOutRegCe1.C_HAS_Q = 0;
defparam hasOutRegCe1.C_HAS_SCLR = C_HAS_SCLR*C_REG_OUTPUT;
defparam hasOutRegCe1.C_HAS_SDIN = 1;
defparam hasOutRegCe1.C_HAS_SDOUT = 1;
defparam hasOutRegCe1.C_SYNC_PRIORITY = 0;
defparam hasOutRegCe1.C_WIDTH = latencyOutRegCe-1;

C_SHIFT_FD_V5_0 rdy_pipeline
(
	.ACLR(ACLR),
	.AINIT(Dangling_Input_Signal),
	.ASET(Dangling_Input_Signal),
	.CE(CE),
	.CLK(CLK),
	.D(rdyPipelineDangle[latencyRdyPipeline-1:0]),
	.LSB_2_MSB(Dangling_Input_Signal),
	.P_LOAD(Dangling_Input_Signal),
	.Q(rdy_pipeline_open[latencyRdyPipeline-1:0]),
	.SCLR(SCLR),
	.SDIN(intND),
	.SDOUT(intRdy),
	.SINIT(Dangling_Input_Signal),
	.SSET(Dangling_Input_Signal)
);

defparam rdy_pipeline.C_FILL_DATA = `c_sdin;
defparam rdy_pipeline.C_HAS_ACLR = C_HAS_ACLR*C_REG_OUTPUT;
defparam rdy_pipeline.C_HAS_CE = C_HAS_CE;
defparam rdy_pipeline.C_HAS_LSB_2_MSB = 1;
defparam rdy_pipeline.C_HAS_Q = 0;
defparam rdy_pipeline.C_HAS_SCLR = C_HAS_SCLR*C_REG_OUTPUT;
defparam rdy_pipeline.C_HAS_SDIN = 1;
defparam rdy_pipeline.C_HAS_SDOUT = 1;
defparam rdy_pipeline.C_SYNC_PRIORITY = 0;
defparam rdy_pipeline.C_WIDTH = latencyRdyPipeline;



endmodule 

`undef SINE_ONLY
`undef COSINE_ONLY
`undef SINE_AND_COSINE
`undef DIST_ROM
`undef BLOCK_ROM
`undef allUKs
`undef c_sdin