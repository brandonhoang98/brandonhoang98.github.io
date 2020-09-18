// $Header: /devl/xcs/repo/env/Databases/ip/src/com/xilinx/ip/vfft32_v3_0/simulation/C_SIN_COS_V2_0.v,v 1.1 2003/05/13 11:03:05 cc Exp $


// Edits:	Reordered parameters into alphabetical order &
//		Converted port names into upper case
//		Changed name of this file from sin_cos_v2_0.v to C_SIN_COS_V2_0.v
//		to match the instantiation template in the .veo file.
 	




`define SINE_ONLY 0
`define COSINE_ONLY 1
`define SINE_AND_COSINE 2
`define DIST_ROM 0
`define BLOCK_ROM 1
`define allUKs {C_OUTPUT_WIDTH{1'bx}}


module C_SIN_COS_V2_0 (THETA, SINE, COSINE, ND, RFD, RDY, CLK, CE, ACLR, SCLR);

//	parameter C_THETA_WIDTH 	= 4;
//        parameter C_OUTPUT_WIDTH 	= 8;
//	parameter C_OUTPUTS_REQUIRED 	= `SINE_AND_COSINE;
//        parameter C_MEM_TYPE 		= `BLOCK_ROM;
//        parameter C_PIPE_STAGES 	= 1;
//        parameter C_HAS_ND 		= 1;
//        parameter C_HAS_RFD 		= 1;
//        parameter C_HAS_RDY 		= 1;
//        parameter C_REG_INPUT 		= 1;
//	parameter C_REG_OUTPUT 		= 1;
//        parameter C_HAS_CLK 		= 0;
//	parameter C_HAS_CE		= 0;		 
//	parameter C_HAS_ACLR		= 0;
//	parameter C_HAS_SCLR		= 1;
//       parameter C_ENABLE_RLOCS	= 0;

// Re-ordered parameters into alphabetical order

        parameter C_ENABLE_RLOCS	= 0;
	parameter C_HAS_ACLR		= 0;
	parameter C_HAS_CE		= 0;		 
        parameter C_HAS_CLK 		= 0;
        parameter C_HAS_ND 		= 1;
        parameter C_HAS_RFD 		= 1;
        parameter C_HAS_RDY 		= 1;
	parameter C_HAS_SCLR		= 1;
        parameter C_MEM_TYPE 		= `BLOCK_ROM;
	parameter C_OUTPUTS_REQUIRED 	= `SINE_AND_COSINE;
        parameter C_OUTPUT_WIDTH 	= 8;
        parameter C_PIPE_STAGES 	= 1;
        parameter C_REG_INPUT 		= 1;
	parameter C_REG_OUTPUT 		= 1;
	parameter C_THETA_WIDTH 	= 4;





//	input [C_THETA_WIDTH-1 : 0] theta;
//	output [C_OUTPUT_WIDTH-1 : 0] sine;	
//	output [C_OUTPUT_WIDTH-1 : 0] cosine;
//	input nd;
//	output rfd;
//	output rdy;
//	input clk;
//	input ce;
//	input aclr;
//	input sclr;

// Converting all port names into upper case

	input [C_THETA_WIDTH-1 : 0] THETA;
	output [C_OUTPUT_WIDTH-1 : 0] SINE;	
	output [C_OUTPUT_WIDTH-1 : 0] COSINE;
	input ND;
	output RFD;
	output RDY;
	input CLK;
	input CE;
	input ACLR;
	input SCLR;

	wire [C_THETA_WIDTH-1 : 0] theta_int;
	wire [C_OUTPUT_WIDTH-1 : 0] sin_pipe;
	wire [C_OUTPUT_WIDTH-1 : 0] cos_pipe;
	wire [C_OUTPUT_WIDTH-1 : 0] sin_pipeout;
	wire [C_OUTPUT_WIDTH-1 : 0] cos_pipeout;
	wire [C_OUTPUT_WIDTH-1 : 0] sin_outreg;
	wire [C_OUTPUT_WIDTH-1 : 0] cos_outreg;

	wire [C_OUTPUT_WIDTH-1 : 0] intSine = (C_REG_OUTPUT==1 ? sin_outreg : sin_pipeout);
	wire [C_OUTPUT_WIDTH-1 : 0] SINE = (((C_OUTPUTS_REQUIRED == `SINE_ONLY) || (C_OUTPUTS_REQUIRED == `SINE_AND_COSINE)) ? intSine : `allUKs);
	wire [C_OUTPUT_WIDTH-1 : 0] intCosine = (C_REG_OUTPUT==1 ? cos_outreg : cos_pipeout);
	wire [C_OUTPUT_WIDTH-1 : 0] COSINE = (((C_OUTPUTS_REQUIRED == `COSINE_ONLY) || (C_OUTPUTS_REQUIRED == `SINE_AND_COSINE)) ? intCosine : `allUKs);

	wire intND = (C_HAS_ND == 1 ? ND : 1'b1);
	wire RFD = (C_HAS_RFD == 1 ? 1'b1 : 1'bX); 
	wire intRdy;
	wire intRdy2 = (C_HAS_RDY==1 && (C_PIPE_STAGES+C_REG_INPUT+C_REG_OUTPUT==0) ? intND : 1'bX);
	wire RDY = (C_HAS_RDY==1 && (C_PIPE_STAGES+C_REG_INPUT+C_REG_OUTPUT>0) ? intRdy : intRdy2);
	wire [C_PIPE_STAGES+C_REG_INPUT+C_REG_OUTPUT-1 : 0] open;


	integer tablesize, i;

initial
begin
  tablesize = 2;
  for (i=1; i<C_THETA_WIDTH; i=i+1)
  begin
    tablesize = tablesize * 2;
  end
end

trig_table #(
             C_THETA_WIDTH,
             C_OUTPUT_WIDTH
            ) 
  trig_arrays(
              THETA,
              sin_pipe,
              cos_pipe
             );

PIPELINE_V2_0 #(
           "",
           0,
           0,
           0,
           C_HAS_CE,
           0,
           0,
           0,
           C_PIPE_STAGES+C_REG_INPUT,
           "",
           0,
           1,
           C_OUTPUT_WIDTH
          )
  sine_pipeline(
                sin_pipe,
                CLK,
                CE,
                1'b0,
                1'b0,
                1'b0,
                1'b0,
                1'b0,
                1'b0,
                sin_pipeout
               );
               
C_REG_FD_V2_0 #(
                "",
                1,
                C_HAS_ACLR,
                0,
                0,
                C_HAS_CE,
                C_HAS_SCLR,
                0,
                0,
                "",
                0,
                0,
                C_OUTPUT_WIDTH
               )
  sin_outputreg(
                sin_pipeout,
                CLK,
                CE,
                ACLR,
                1'b0,
                1'b0,
                SCLR,
                1'b0,
                1'b0,
                sin_outreg
               );
             

PIPELINE_V2_0 #(
           "",
           0,
           0,
           0,
           C_HAS_CE,
           0,
           0,
           0,
           C_PIPE_STAGES+C_REG_INPUT,
           "",
           0,
           1,
           C_OUTPUT_WIDTH
          )
cosine_pipeline(
                cos_pipe,
                CLK,
                CE,
                1'b0,
                1'b0,
                1'b0,
                1'b0,
                1'b0,
                1'b0,
                cos_pipeout
               );
               
C_REG_FD_V2_0 #(
                "",
                1,
                C_HAS_ACLR,
                0,
                0,
                C_HAS_CE,
                C_HAS_SCLR,
                0,
                0,
                "",
                0,
                0,
                C_OUTPUT_WIDTH
               )
  cos_outputreg(
                cos_pipeout,
                CLK,
                CE,
                ACLR,
                1'b0,
                1'b0,
                SCLR,
                1'b0,
                1'b0,
                cos_outreg
               );

C_SHIFT_FD_V2_0 #(
                  "",
                  1,
                  0,
                  C_HAS_ACLR,
                  0,
                  0,
                  C_HAS_CE,
                  0,
                  1,
                  0,
                  C_HAS_SCLR,
                  1,
                  1,
                  0,
                  0,
                  0,
                  "",
                  0,
                  0,
                  C_PIPE_STAGES+C_REG_INPUT+C_REG_OUTPUT
                 )
  rdy_pipeline(
               1'b0,
               intND,
               {C_PIPE_STAGES+C_REG_INPUT+C_REG_OUTPUT{1'b0}},
               1'b0,
               CLK,
               CE,
               ACLR,
               1'b0,
               1'b0,
               SCLR,
               1'b0,
               1'b0,
               intRdy,
               open
              );

endmodule


module trig_table(theta, sin_table, cos_table);

parameter theta_width = 10;
parameter output_width = 8;
parameter tablesize = 1 << theta_width;
parameter pi = 3.14159265358979323846;
parameter scale = 1 << (output_width-1);
parameter delta_angle = 2.0*pi/tablesize;

input [theta_width-1 : 0] theta;
output [output_width-1 : 0] sin_table;
output [output_width-1 :0 ] cos_table;
reg [output_width-1 : 0] sin_table;
reg [output_width-1 :0 ] cos_table;
real angle;
//output [bitwidth-1 : 0] sin_table[0:tablesize-1];
//output [bitwidth-1 : 0] cos_table[0:tablesize-1];
reg [output_width-1 :0] sin_array[0:tablesize-1];
reg [output_width-1 :0] cos_array[0:tablesize-1];
integer i;
integer sin_int, cos_int;

initial
begin
  angle = 0;
  for (i=0; i<tablesize; i=i+1)
  begin
    sin_int = scale * sin($realtobits(angle));
    
    if (sin_int == scale)
      sin_array[i] = sin_int - 1;
    else
      sin_array[i] = sin_int;
    cos_int = scale * cos($realtobits(angle));
    if (cos_int == scale)
      cos_array[i] = cos_int - 1;
    else
      cos_array[i] = cos_int;
      
    angle = angle + delta_angle;
  end
end

always @(theta)
begin
  sin_table <= sin_array[theta];
  cos_table <= cos_array[theta];
end


// Functions ****************************************

function real sin;
input [63:0] vector;

real term, sum, theta;
integer n, loop;
  
begin
 theta = $bitstoreal(vector);
 term = theta;
 sum = theta;
 n = 1;

 for (loop=0; loop < 100; loop = loop + 1)
 begin
   n = n + 2;
   term = -term*theta*theta/((n-1)*n);
   sum = sum + term;
 end
 sin = sum;
end
endfunction

function real cos;
input [63:0] vector;

real term, sum, theta;
integer n, loop;
  
begin
 term = 1.0;
 sum = 1.0;
 n = 0;
 theta = $bitstoreal(vector);

 for (loop=0; loop < 100; loop = loop + 1)
 begin
   n = n + 2;
   term = (-term)*theta*theta/((n-1)*n);
   sum = sum + term;
 end
 cos = sum;
end
endfunction

endmodule

















