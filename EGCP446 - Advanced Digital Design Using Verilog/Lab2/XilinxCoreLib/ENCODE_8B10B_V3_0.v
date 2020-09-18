/* ************************************************************************
 * $Id: ENCODE_8B10B_V3_0.v,v 1.2 2002/03/29 15:56:19 janeh Exp $
 * ************************************************************************
 * 8b/10b Encoder - Verilog Behavioral Model
 * ************************************************************************
 *                                                                     
 * This File is owned and controlled by Xilinx and must be used solely
 * for design, simulation, implementation and creation of design files
 * limited to Xilinx devices or technologies. Use with non-Xilinx      
 * devices or technologies is expressly prohibited and immediately     
 * terminates your license.                                            
 *                                                                    
 * Xilinx products are not intended for use in life support           
 * appliances, devices, or systems. Use in such applications is       
 * expressly prohibited.                                              
 *                                                                   
 *
 *       ****************************
 *       ** Copyright Xilinx, Inc. **
 *       ** All rights reserved.   **
 *       ****************************
 *
 * NOTICE:
 * This byte oriented DC balanced 8b/10b partitioned block
 * transmission code may contain material covered by patents
 * owned by other third parties including International Business
 * Machines Corporation.  By providing this core as one possible
 * implementation of this standard, Xilinx is making no representation
 * that the provided implementation of this standard is free
 * from any claims of infringement by any third party.  Xilinx 
 * expressly disclaims any warranty with respect to the adequacy 
 * of the implementation, including, but not limited to any warranty 
 * or representation that the implementation is free from claims of
 * any third party.  Furthermore, Xilinx is providing this core as
 * a courtesy to you and suggests that you contact all third parties
 * including IBM to obtain the necessary rights to use this implementation.
 * 
 * ************************************************************************
 * filename:    ENCODE_8B10B_V3_0.v
 *
 * Description: The Verilog behavioral model for the 8b/10b Encoder     
 *                      
 *
 * ************************************************************************
 *  STRUCTURE:
 *        >>> ENCODE_8B10B_V3_0.V <<<
 *                     |
 *                     +- encode_8b10b_v3_0_base.v
 *
 * ************************************************************************
 */


 /*************************************************************************
 * Set the timescale value for this core
 *************************************************************************/
`timescale 1ns/10ps
 

 /*************************************************************************
 * Declare top-level module
 *************************************************************************/
module ENCODE_8B10B_V3_0
  (
    DIN, KIN, CLK, CE, FORCE_CODE, FORCE_DISP, DISP_IN, 
    DOUT, DISP_OUT, KERR, ND, 
    DIN_B, KIN_B, CLK_B, CE_B, FORCE_CODE_B, FORCE_DISP_B, DISP_IN_B, 
    DOUT_B, DISP_OUT_B, KERR_B, ND_B
  );


/*************************************************************************
 * Parameter Declarations
 *************************************************************************/
  parameter c_enable_rlocs      = 1;   //-- Enable relative placement
  parameter c_encode_type       = 0;   //-- 0 slice, 1 blockRAM, 2 LUTRAM
  parameter c_force_code_disp   = 0;   //-- Force code disparity
  parameter c_force_code_disp_b = 0;   //-- Force code disparity B
  parameter c_force_code_val    = "0101010101";  //-- Force code value
  parameter c_force_code_val_b  = "0101010101";  //-- Force code Value B
  parameter c_has_bports        = 0;   //-- 1 if second encoder
  parameter c_has_ce            = 1;   //-- 1 if ce port present
  parameter c_has_ce_b          = 0;   //-- 1 if ce_b port present
  parameter c_has_disp_in       = 1;   //-- 1 if force_disp port present
  parameter c_has_disp_in_b     = 0;   //-- 1 if force_disp_b port present
  parameter c_has_disp_out      = 1;   //-- 1 if disp_out port present
  parameter c_has_disp_out_b    = 0;   //-- 1 if disp_out_b port present
  parameter c_has_force_code    = 1;   //-- 1 if FORce_CODE port present
  parameter c_has_force_code_b  = 0;   //-- 1 if FORce_CODE_b port present
  parameter c_has_kerr          = 1;   //-- 1 if kerr port present
  parameter c_has_kerr_b        = 0;   //-- 1 if kerr_b port present
  parameter c_has_nd            = 1;   //-- 1 if nd port present
  parameter c_has_nd_b          = 0;   //-- 1 if nd_b port present


/*************************************************************************
 * Input and Output Declarations
 *************************************************************************/
  input [7:0] DIN;
  input KIN;
  input CLK;
  input CE;
  input FORCE_CODE;
  input FORCE_DISP;
  input DISP_IN;
  output [9:0] DOUT;
  output DISP_OUT;
  output KERR;
  output ND;

  input [7:0] DIN_B;
  input KIN_B;
  input CLK_B;
  input CE_B;
  input FORCE_CODE_B;
  input FORCE_DISP_B;
  input DISP_IN_B;
  output [9:0] DOUT_B;
  output DISP_OUT_B;
  output KERR_B;
  output ND_B;

   
/*************************************************************************
 * Internal regs (for always blocks) and wires (for assign statements)
 *************************************************************************/
  wire [9:0] int_dout_b;
  wire int_disp_out_b;
  wire int_kerr_b;
  wire int_nd_b;



/*************************************************************************
 * Instantiate lower level components.
 *************************************************************************/

/********instantiate encode_8b10b_v3_0_base for "A" encoder*****************/
encode_8b10b_v3_0_base 
  #(
    c_force_code_disp,
    c_force_code_val,
    c_has_ce,
    c_has_disp_in,
    c_has_disp_out,
    c_has_force_code,
    c_has_kerr,
    c_has_nd
  )
  first_encoder 
  (
    .din(DIN), .kin(KIN), .force_disp(FORCE_DISP), 
    .force_code(FORCE_CODE), .disp_in(DISP_IN), .ce(CE), 
    .clk(CLK), .dout(DOUT), .kerr(KERR), 
    .disp_out(DISP_OUT), .nd(ND)
  );


/********instantiate encode_8b10b_v3_0_base for "B" encoder*****************/
encode_8b10b_v3_0_base 
  #(
      c_force_code_disp_b,
      c_force_code_val_b,
      c_has_ce_b,
      c_has_disp_in_b,
      c_has_disp_out_b,
      c_has_force_code_b,
      c_has_kerr_b,
      c_has_nd_b
  )
  second_encoder
    (
      .din(DIN_B), .kin(KIN_B), .force_disp(FORCE_DISP_B), 
      .force_code(FORCE_CODE_B), .disp_in(DISP_IN_B), .ce(CE_B), 
      .clk(CLK_B), .dout(int_dout_b), .kerr(int_kerr_b), 
      .disp_out(int_disp_out_b), .nd(int_nd_b)
    );
  

/********connect "B" output ports if c_has_bports is active*************/
assign DOUT_B=(c_has_bports)?int_dout_b:10'b XXXXXXXXXX;
assign KERR_B=(c_has_bports)?int_kerr_b:1'b X;
assign DISP_OUT_B=(c_has_bports)?int_disp_out_b:1'b X;
assign ND_B=(c_has_bports)?int_nd_b:1'b X;

  
endmodule












/*************************************************************************
 * Declare Base module (single encoder)
 *************************************************************************/


module encode_8b10b_v3_0_base
  (
    din, kin, clk, ce, force_code, force_disp, disp_in, dout, disp_out, kerr, nd
  );


/*************************************************************************
 * Parameter Declarations
 *************************************************************************/
parameter c_force_code_disp = 0;
parameter c_force_code_val = "1010101010";
parameter c_has_ce = 1;
parameter c_has_disp_in = 1;
parameter c_has_disp_out = 1;
parameter c_has_force_code = 1;
parameter c_has_kerr = 1;
parameter c_has_nd = 1;


/*************************************************************************
 * Input and Output Declarations
 *************************************************************************/
input [7:0] din;
input kin;
input clk;
input ce;
input force_code;
input force_disp;
input disp_in;
output [9:0] dout;
output disp_out;
output kerr;
output nd;

reg [9:0] dout;  //dout needs to be defined as a reg
reg nd;          //nd needs to be defined as a reg


/*************************************************************************
 * Parameters set as constants
 *************************************************************************/
parameter [9:0] D_10_2 = 10'b 0101010101 ;
parameter [9:0] D_21_5 = 10'b 1010101010 ;
parameter yes = 1'b 1 ;
parameter no = 1'b 0 ;
parameter pos = 1'b 1 ;
parameter neg = 1'b 0 ;
parameter reg_size = 10;


/*************************************************************************
 * Internal regs (for always blocks) and wires (for assign statements)
 *************************************************************************/
reg [5:0] b6 ;
reg [3:0] b4 ;
reg pdes6 ;
reg pdes4 ;
wire k28 ;
wire l13 ;
wire l31 ;
wire a7 ;
//reg disp_in = neg ;
//reg disp_run = neg ;
//reg ce_int = 1'b 1 ;
reg disp_in_int;   
reg disp_run;
reg ce_int;

wire a;
wire b;
wire c;
wire d;
wire e;
wire [4:0] b5;
wire [2:0] b3;

reg k_invalid  ;


/*************************************************************************
 * Function Declarations
 *************************************************************************/


/*************************************************************************
 * to_bits function : 
 *      converts string of reg_size to bits
 *      (reg_size is declared as a constant parameter above)
 *************************************************************************/
function [reg_size-1 : 0] to_bits;
  input [reg_size*8 : 1] instring;
  integer i;
  integer non_null_string;
  begin
    non_null_string = 0;
    for(i = reg_size; i > 0; i = i - 1)
      begin // Is the string empty?
        if(instring[(i*8)] == 0 && 
           instring[(i*8)-1] == 0 && 
           instring[(i*8)-2] == 0 && 
           instring[(i*8)-3] == 0 && 
           instring[(i*8)-4] == 0 && 
           instring[(i*8)-5] == 0 && 
           instring[(i*8)-6] == 0 && 
           instring[(i*8)-7] == 0 &&
           non_null_string == 0)
          non_null_string = 0; // Use the return value to flag a non-empty string
        else
          non_null_string = 1; // Non-null character!
      end
    if(non_null_string == 0) // String IS empty! Just return the value to be all '0's
      begin
        for(i = reg_size; i > 0; i = i - 1)
        to_bits[i-1] = 0;
      end
    else
      begin
        for(i = reg_size; i > 0; i = i - 1)
	  begin // Is this character a '0'? (ASCII = 48 = 00110000)
            if(instring[(i*8)] == 0 && 
               instring[(i*8)-1] == 0 && 
               instring[(i*8)-2] == 1 && 
               instring[(i*8)-3] == 1 && 
               instring[(i*8)-4] == 0 && 
               instring[(i*8)-5] == 0 && 
               instring[(i*8)-6] == 0 && 
               instring[(i*8)-7] == 0)
	      to_bits[i-1] = 0;
                // Or is it a '1'? 
            else if(instring[(i*8)] == 0 && 
                    instring[(i*8)-1] == 0 && 
                    instring[(i*8)-2] == 1 && 
                    instring[(i*8)-3] == 1 && 
                    instring[(i*8)-4] == 0 && 
                    instring[(i*8)-5] == 0 && 
                    instring[(i*8)-6] == 0 && 
                    instring[(i*8)-7] == 1)		
                   to_bits[i-1] = 1;
                // Or is it a ' '? (a null char - in which case insert a '0')
            else if(instring[(i*8)] == 0 && 
                    instring[(i*8)-1] == 0 && 
                    instring[(i*8)-2] == 0 && 
                    instring[(i*8)-3] == 0 && 
                    instring[(i*8)-4] == 0 && 
                    instring[(i*8)-5] == 0 && 
                    instring[(i*8)-6] == 0 && 
                    instring[(i*8)-7] == 0)		
                   to_bits[i-1] = 0;
            else
              begin
                $display("Error in module %m at time %dns: non-binary digit bit %d in string \"%s\"\nExiting simulation...", $time, i, instring);
                $finish;
              end
          end
      end 
  end
endfunction


/*************************************************************************
 * Create aliases for the din port
 *************************************************************************/
assign a = din[0];
assign b = din[1];
assign c = din[2];
assign d = din[3];
assign e = din[4];
assign b5[4:0] = din[4:0];
assign b3[2:0] = din[7:5];

   
/*************************************************************************
 * Map internal signals to proper port names
 *************************************************************************/
assign disp_out = (c_has_disp_out)? disp_run : 1'bx ;
assign kerr = (c_has_kerr)? k_invalid : 1'bx ;


/*************************************************************************
 * Initialize the outputs for simulation purposes
 *************************************************************************/
initial
begin
	dout = to_bits(c_force_code_val) ;
	disp_run = c_force_code_disp ;
 	k_invalid = 1'b0 ;
	nd = 1'b0 ;	

        ce_int = !(c_has_ce == 1);
   
end

/*************************************************************************
 * ce_int is '1' if c_has_ce is FALSE
 *************************************************************************/
always @(ce)
  begin: ce_process
    if (c_has_ce)
      ce_int = ce ;
    else
      ce_int = 1'b 1;
  end

   
/*************************************************************************
 * Calculate some intermediate terms
 *************************************************************************/
assign k28 = ((kin == 1'b 1 ) && (b5 == 5'b 11100)) ;
assign l13 = (((a ^ b) & !(c | d)) | ((c ^ d) & !(a | b))) ;
assign l31 = (((a ^ b) & (c & d)) | ((c ^ d) & (a & b))) ;
assign a7 = (kin | ((l31 & d & !(e) & disp_in_int) | (l13 & !(d) & e & !(disp_in_int)))) ;	

   
/*************************************************************************
 * Check for invalid K codes
 *************************************************************************/
always @(posedge clk)
  begin
    if (ce_int)
      begin
        if (c_has_force_code && force_code)
          k_invalid = no;
        else if (b5 == 5'b 11100)
          k_invalid = no;
        else if (b3 != 3'b 111)
          k_invalid = kin;
        else if ((b5 != 5'b 10111) && (b5 != 5'b 11011) && (b5 != 5'b 11101) && (b5 != 5'b 11110))
          k_invalid = kin;
        else
          k_invalid = no;
      end
  end


/*************************************************************************
 * Determine the 6-bit part of the symbol from the first 5 bits
 *************************************************************************/
always @(b5 or k28 or disp_in_int)
  begin
    if (k28)						//--K.28
      if (disp_in_int == neg)
        b6 = 6'b 111100;
      else
        b6 = 6'b 000011;
    else
      case (b5)
        5'b 00000: 			//--D.0
			if (disp_in_int == pos) b6 = 6'b 000110 ;
			else b6 = 6'b 111001 ;
	5'b 00001:				//--D.1
			if (disp_in_int == pos) b6 = 6'b 010001 ;
			else b6 = 6'b 101110 ;
	5'b 00010: 			//--D.2
			if (disp_in_int == pos) b6 = 6'b 010010 ;
			else b6 = 6'b 101101 ;
	5'b 00011: b6 = 6'b 100011 ;	//--D.3
	5'b 00100:				//--D.4
			if (disp_in_int == pos) b6 = 6'b 010100 ;
			else b6 = 6'b 101011 ;
	5'b 00101: b6 = 6'b 100101 ;	//--D.5
	5'b 00110: b6 = 6'b 100110 ;	//--D.6
	5'b 00111:				//--D.7	
			if (disp_in_int == neg) b6 = 6'b 000111 ;
			else b6 = 6'b 111000 ;

	5'b 01000:				//--D.8
			if (disp_in_int == pos) b6 = 6'b 011000 ;
			else b6 = 6'b 100111 ;
	5'b 01001: b6 = 6'b 101001 ;	//--D.9
	5'b 01010: b6 = 6'b 101010 ;	//--D.10 --was "101001"
	5'b 01011: b6 = 6'b 001011 ;	//--D.11
	5'b 01100: b6 = 6'b 101100 ;	//--D.12
	5'b 01101: b6 = 6'b 001101 ;	//--D.13
	5'b 01110: b6 = 6'b 001110 ;	//--D.14
	5'b 01111: 			//--D.15
			if (disp_in_int == pos) b6 = 6'b 000101 ;
			else b6 = 6'b 111010 ;

	5'b 10000:				//--D.16
			if (disp_in_int == neg) b6 = 6'b 110110 ;
			else b6 = 6'b 001001 ;
	5'b 10001: b6 = 6'b 110001 ;	//--D.17
	5'b 10010: b6 = 6'b 110010 ;	//--D.18
	5'b 10011: b6 = 6'b 010011 ;	//--D.19
	5'b 10100: b6 = 6'b 110100 ;	//--D.20
	5'b 10101: b6 = 6'b 010101 ;	//--D.21
	5'b 10110: b6 = 6'b 010110 ;	//--D.22
	5'b 10111:				//--D/K.23
			if (disp_in_int == neg) b6 = 6'b 010111 ;
			else b6 = 6'b 101000 ;

	5'b 11000:				//--D.24
			if (disp_in_int == pos) b6 = 6'b 001100 ;
			else b6 = 6'b 110011 ;
	5'b 11001: b6 = 6'b 011001 ;	//--D.25
	5'b 11010: b6 = 6'b 011010 ;	//--D.26
	5'b 11011:				//--D/K.27
			if (disp_in_int == neg) b6 = 6'b 011011 ;
			else b6 = 6'b 100100 ;
	5'b 11100: b6 = 6'b 011100 ;	//--D.28
	5'b 11101:				//--D/K.29
			if (disp_in_int == neg) b6 = 6'b 011101 ;
			else b6 = 6'b 100010 ;
	5'b 11110:				//--D/K.30
			if (disp_in_int == neg) b6 = 6'b 011110 ;
			else b6 = 6'b 100001 ;
	5'b 11111:				//--D.31
			if (disp_in_int == neg) b6 = 6'b 110101 ;
			else b6 = 6'b 001010 ;
	default: b6 = "UUUUUU";
      endcase
  end


/*************************************************************************
 * Determine the running disparity after the 6b code has been generated
 *************************************************************************/
always @(b5 or k28 or disp_in_int)
  begin
    if (k28)
      pdes6 = !(disp_in_int) ;
    else
      case (b5)
	5'b 00000:  pdes6 = !(disp_in_int) ;
	5'b 00001:  pdes6 = !(disp_in_int) ;
	5'b 00010:  pdes6 = !(disp_in_int) ;
	5'b 00011:  pdes6 = disp_in_int ;
	5'b 00100:  pdes6 = !(disp_in_int) ;
	5'b 00101:  pdes6 = disp_in_int ;
	5'b 00110:  pdes6 = disp_in_int ;
	5'b 00111:  pdes6 = disp_in_int ;		//-- changed 8/02/2000
	5'b 01000:  pdes6 = !(disp_in_int) ;		//-- changed 8/02/2000
	5'b 01001:  pdes6 = disp_in_int ;
	5'b 01010:  pdes6 = disp_in_int ;
	5'b 01011:  pdes6 = disp_in_int ;
	5'b 01100:  pdes6 = disp_in_int ;
	5'b 01101:  pdes6 = disp_in_int ;
	5'b 01110:  pdes6 = disp_in_int ;
	5'b 01111:  pdes6 = !(disp_in_int) ;
	5'b 10000:  pdes6 = !(disp_in_int) ;
	5'b 10001:  pdes6 = disp_in_int ;
	5'b 10010:  pdes6 = disp_in_int ;
	5'b 10011:  pdes6 = disp_in_int ;
	5'b 10100:  pdes6 = disp_in_int ;
	5'b 10101:  pdes6 = disp_in_int ;
	5'b 10110:  pdes6 = disp_in_int ;
	5'b 10111:  pdes6 = !(disp_in_int) ;
	5'b 11000:  pdes6 = !(disp_in_int) ;
	5'b 11001:  pdes6 = disp_in_int ;
	5'b 11010:  pdes6 = disp_in_int ;
	5'b 11011:  pdes6 = !(disp_in_int) ;
	5'b 11100:  pdes6 = disp_in_int ;
	5'b 11101:  pdes6 = !(disp_in_int) ;
	5'b 11110:  pdes6 = !(disp_in_int) ;
	5'b 11111:  pdes6 = !(disp_in_int) ;
	default:    pdes6 = disp_in_int;
      endcase
  end


/*************************************************************************
 * Determine the 4-bit part of the symbol from the last 3 bits
 *************************************************************************/
always @(b3 or k28 or pdes6 or a7)
  begin
    case (b3)
      3'b 000: 		        //--D/K.x.0
			if (pdes6 == pos) b4 = 4'b 0010 ;
			else b4 = 4'b 1101 ;
      3'b 001:			//--D/K.x.1
			if (k28 && (pdes6 == neg)) b4 = 4'b 0110 ;
			else b4 = 4'b 1001 ;
      3'b 010:				//--D/K.x.2
			if (k28 && (pdes6 == neg)) b4 = 4'b 0101 ;
			else b4 = 4'b 1010 ;
      3'b 011:			//--D/K.x.3
			if (pdes6 == neg) b4 = 4'b 0011 ;
			else b4 = 4'b 1100 ;
      3'b 100:			//--D/K.x.4
			if (pdes6 == pos) b4 = 4'b 0100 ;
			else b4 = 4'b 1011 ;
      3'b 101:			//--D/K.x.5
			if (k28 && (pdes6 == neg)) b4 = 4'b 1010 ;
			else b4 = 4'b 0101 ;
      3'b 110:			//--D/K.x.6
			if (k28 && (pdes6 == neg)) b4 = 4'b 1001 ;
			else b4 = 4'b 0110 ;
      3'b 111:			//--D.x.P7
			if (a7 != 1'b 1)
			  if (pdes6 == neg) b4 = 4'b 0111 ;
			  else b4 = 4'b 1000 ;
			else 				//--D/K.y.A7
			  if (pdes6 == neg) b4 = 4'b 1110 ;
			  else b4 = 4'b 0001 ;
      default:          b4 = 4'b XXXX;
    endcase
end


/*************************************************************************
 * Determine the running disparity after the 4b code has been generated
 *************************************************************************/
always @(b3 or pdes6)
  begin
    case (b3)
      3'b 000: pdes4 = !(pdes6) ;
      3'b 001: pdes4 = pdes6 ;
      3'b 010: pdes4 = pdes6 ;
      3'b 011: pdes4 = pdes6 ;
      3'b 100: pdes4 = !(pdes6) ;
      3'b 101: pdes4 = pdes6 ;
      3'b 110: pdes4 = pdes6 ;
      3'b 111: pdes4 = !(pdes6) ;
      default: pdes4 = pdes6;
    endcase
  end


/*************************************************************************
 * Update the running disparity on the clock
 *************************************************************************/
always @(posedge clk)
  begin
    if (ce_int)
      if ((c_has_force_code) && (force_code))
	if (c_force_code_disp)
          disp_run = 1'b 1 ;
        else
          disp_run = 1'b 0 ;
      else
        disp_run = pdes4 ;
  end


/*************************************************************************
 * Override the input disparity if required
 *************************************************************************/
always @(force_disp or disp_in or disp_run)
  begin
    if (c_has_disp_in && force_disp)
      disp_in_int = disp_in ;
    else
      disp_in_int = disp_run ;
  end


/*************************************************************************
 * Update the outputs on the clock
 *************************************************************************/
always @(posedge clk)
  begin
    if ((c_has_force_code) && (force_code))
      begin
//      dout = D_10_2 ;
        dout = to_bits(c_force_code_val);
      end
    else if (ce_int)
      dout = {b4, b6} ;
  end


/*************************************************************************
 * Update the ND output
 *************************************************************************/
always @(posedge clk)
  begin
    if (c_has_nd)
      if ((c_has_force_code) & (force_code))
	nd =1'b0;
      else
        nd = ce_int;
    else
	nd = 1'bx ;	
  end


endmodule






 

