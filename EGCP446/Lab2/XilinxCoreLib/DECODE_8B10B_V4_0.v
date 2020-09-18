/**************************************************************************
 * $Id: DECODE_8B10B_V4_0.v,v 1.2 2002/03/29 15:56:12 janeh Exp $
 **************************************************************************
 * 8b/10b Decoder - Verilog Behavioral Model
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
 *        ****************************
 *        ** Copyright Xilinx, Inc. **
 *        ** All rights reserved.   **
 *        ****************************
 *
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
 *************************************************************************/


 /************************************************************************
  * Set the timescale for this core
  ************************************************************************/

`timescale 1ns/10ps
 
/*************************************************************************
 * Filename:    DECODE_8B10B_V4_0.v
 * 
 * Description: The Verilog behavioral model for the top-level 8b/10b Decoder
 * 
 * ***********************************************************************
 * /

 

 /************************************************************************
  * Port Declaration
  ************************************************************************/
module DECODE_8B10B_V4_0
  (
     /********************************************************************
      * Mandatory Pins
      *  clk  : Clock Input
      *  din  : Encoded Symbol Input
      *  dout : Data Output, decoded data byte
      *  kout : Command Output
      ********************************************************************/
      CLK,
      DIN,
      DOUT,
      KOUT,

     /********************************************************************
      * Optional Pins
      *  ce         : Clock Enable
      *  ce_b       : Clock Enable (B port)
      *  clk_b      : Clock Input (B port)
      *  din_b      : Encoded Symbol Input (B port)
      *  disp_in    : Disparity Input (running disparity in)
      *  disp_in_b  : Disparity Input (running disparity in) 
      *  sinit      : Synchronous Initialization. Resets core to known state.
      *  sinit_b    : Synchronous Initialization. Resets core to known state. (B port)
      *  code_err   : Code Err_or, indicates that input symbol did not correspond
      *                to a valid member of the code set.
      *  code_err_b : Code Err_or, indicates that input symbol did not correspond
      *                to a valid member of the code set. (B port)
      *  disp_err   : Disparity Err_or
      *  disp_err_b : Disparity Err_or (B port)
      *  dout_b     : Data Output, decoded data byte (B port)
      *  kout_b     : Command Output (B port)
      *  nd         : New Data
      *  nd_b       : New Data (B port)
      *  run_disp   : Running Disparity
      *  run_disp_b : Running Disparity (B port)
      *  sym_disp   : Symbol Disparity
      *  sym_disp_b : Symbol Disparity (B port)
      ********************************************************************/
      CE,
      CE_B,
      CLK_B,
      DIN_B,
      DISP_IN,
      DISP_IN_B,
      SINIT,
      SINIT_B,
      CODE_ERR,
      CODE_ERR_B,
      DISP_ERR,
      DISP_ERR_B,
      DOUT_B,
      KOUT_B,
      ND,
      ND_B,
      RUN_DISP,
      RUN_DISP_B,
      SYM_DISP,
      SYM_DISP_B
   );
   

  /********************************************************************
    * Generic Parameters
    * 
    *  c_decode_type      : Implementation: 0=Slice based, 1=BlockRam, 2=LutRam
    *  c_enable_rlocs     : Enable Relative PLacement (T=1,F=0)
    *  c_has_bports       : 1 indicates second decoder should be generated
    *  c_has_ce           : 1 indicates ce port is present
    *  c_has_ce_b         : 1 indicates ce_b port is present (if c_has_bports=1)
    *  c_has_code_err     : 1 indicates code_err port is present
    *  c_has_code_err_b   : 1 indicates code_err_b port is present (if c_has_bports=1)
    *  c_has_disp_err     : 1 indicates disp_err port is present
    *  c_has_disp_err_b   : 1 indicates disp_err_b port is present (if c_has_bports=1)
    *  c_has_disp_in      : 1 indicates disp_in port is present
    *  c_has_disp_in_b    : 1 indicates disp_in_b port is present (if c_has_bports=1)
    *  c_has_nd           : 1 indicates nd port is present
    *  c_has_nd_b         : 1 indicates nd_b port is present (if c_has_bports=1)
    *  c_has_run_disp     : 1 indicates run_disp port is present
    *  c_has_run_disp_b   : 1 indicates run_disp_b port is present (if c_has_bports=1)
    *  c_has_sinit        : 1 indicates sinit port is present
    *  c_has_sinit_b      : 1 indicates sinit_b port is present (if c_has_bports=1)
    *  c_has_sym_disp     : 1 indicates sym_disp port is present
    *  c_has_sym_disp_b   : 1 indicates sym_disp_b port is present (if c_has_bports=1)
    *  c_sinit_dout       : 8-bit binary string, dout value when sinit is active
    *  c_sinit_dout_b     : 8-bit binary string, dout_b value when sinit_b is active
    *  c_sinit_kout       : controls kout output when sinit is active
    *  c_sinit_kout_b     : controls kout_b output when sinit_b is active
    *  c_sinit_run_disp   : Initializes run_disp value to positive(1) or negative(0)
    *  c_sinit_run_disp_b : Initializes run_disp_b value to positive(1) or negative(0)
    ********************************************************************/
  parameter c_decode_type    = 1; 
  parameter c_enable_rlocs   = 0;
  parameter c_has_bports     = 0;
  parameter c_has_ce         = 0;
  parameter c_has_ce_b       = 0;
  parameter c_has_code_err   = 1;
  parameter c_has_code_err_b = 0;
  parameter c_has_disp_err   = 1;
  parameter c_has_disp_err_b = 0;
  parameter c_has_disp_in    = 0; 
  parameter c_has_disp_in_b  = 0; 
  parameter c_has_nd         = 0;
  parameter c_has_nd_b       = 0;
  parameter c_has_run_disp   = 0;
  parameter c_has_run_disp_b = 0;
  parameter c_has_sinit      = 0; 
  parameter c_has_sinit_b    = 0;
  parameter c_has_sym_disp   = 0; 
  parameter c_has_sym_disp_b = 0; 
  parameter c_sinit_dout       = "00000000";
  parameter c_sinit_dout_b     = "00000000";
  parameter c_sinit_kout       = 0; 
  parameter c_sinit_kout_b     = 0; 
  parameter c_sinit_run_disp   = 0; 
  parameter c_sinit_run_disp_b = 0;

  
 /********************************************************************
  * Mandatory Pins
  *  clk  : Clock Input
  *  din  : Encoded Symbol Input    
  *  dout : Data Output, decoded data byte
  *  kout : Command Output
  ********************************************************************/
  input CLK;
  input [9:0] DIN;
  output [7:0] DOUT;
  output KOUT;

 /********************************************************************
  * Optional Pins
  *  ce         : Clock Enable
  *  ce_b       : Clock Enable (B port)
  *  clk_b      : Clock Input (B port)
  *  din_b      : Encoded Symbol Input (B port)
  *  disp_in    : Disparity Input (running disparity in)
  *  disp_in_b  : Disparity Input (running disparity in) 
  *  sinit      : Synchronous Initialization. Resets core to known state.
  *  sinit_b    : Synchronous Initialization. Resets core to known state. (B port)
  *  code_err   : Code Err_or, indicates that input symbol did not correspond
  *                to a valid member of the code set.
  *  code_err_b : Code Err_or, indicates that input symbol did not correspond
  *                to a valid member of the code set. (B port)
  *  disp_err   : Disparity Err_or
  *  disp_err_b : Disparity Err_or (B port)
  *  dout_b     : Data Output, decoded data byte (B port)
  *  kout_b     : Command Output (B port)
  *  nd         : New Data
  *  nd_b       : New Data (B port)
  *  run_disp   : Running Disparity
  *  run_disp_b : Running Disparity (B port)
  *  sym_disp   : Symbol Disparity
  *  sym_disp_b : Symbol Disparity (B port)
  ********************************************************************/
  input CE;
  input CE_B;
  input CLK_B;
  input [9:0] DIN_B;
  input DISP_IN;
  input DISP_IN_B;
  input SINIT;
  input SINIT_B;
  output CODE_ERR;
  output CODE_ERR_B;
  output DISP_ERR; 
  output DISP_ERR_B;
  output [7:0] DOUT_B;
  output KOUT_B; 
  output ND;   
  output ND_B;  
  output RUN_DISP;
  output RUN_DISP_B;
  output [1:0] SYM_DISP; 
  output [1:0] SYM_DISP_B;  


 /************************************************************************
  * internal signals (conditionally exposed)
  ************************************************************************/
wire int_code_err_b;
wire int_disp_err_b;
wire [7:0] int_dout_b;
wire int_kout_b;
wire [1:0] int_sym_disp_b;
wire int_run_disp_b;
wire int_nd_b;



 /************************************************************************
  * Instantiate first decoder
  ************************************************************************/
decode_8b10b_v4_0_base
  #(
      c_has_ce,
      c_has_code_err,
      c_has_disp_err,
      c_has_disp_in,
      c_has_nd,
      c_has_run_disp,
      c_has_sinit,
      c_has_sym_disp,
      c_sinit_dout,
      c_sinit_kout,
      c_sinit_run_disp
   )
   
   first_decoder
   (
      .clk(CLK),
      .din(DIN),
      .dout(DOUT),
      .kout(KOUT),

      .ce(CE),
      .disp_in(DISP_IN),
      .sinit(SINIT),
      .code_err(CODE_ERR),
      .disp_err(DISP_ERR),
      .nd(ND),
      .run_disp(RUN_DISP),
      .sym_disp(SYM_DISP)
   );


 /************************************************************************
  * Instantiate second decoder
  ************************************************************************/
decode_8b10b_v4_0_base
  #(
      c_has_ce_b,
      c_has_code_err_b,
      c_has_disp_err_b,
      c_has_disp_in_b,
      c_has_nd_b,
      c_has_run_disp_b,
      c_has_sinit_b,
      c_has_sym_disp_b,
      c_sinit_dout_b,
      c_sinit_kout_b,
      c_sinit_run_disp_b
   )
   
   second_decoder
   (
     .clk(CLK_B),
     .din(DIN_B),
     .dout(int_dout_b), 
     .kout(int_kout_b),

     .ce(CE_B),
     .disp_in(DISP_IN_B), 
     .sinit(SINIT_B),
     .code_err(int_code_err_b),
     .disp_err(int_disp_err_b), 
     .nd(int_nd_b),
     .run_disp(int_run_disp_b), 
     .sym_disp(int_sym_disp_b) 
   );



 /************************************************************************
  * Tie internal signals to output pins only if C_HAS_BPORTS
  ************************************************************************/
  assign CODE_ERR_B = (c_has_bports)?int_code_err_b:1'b x;  
  assign DISP_ERR_B = (c_has_bports)?int_disp_err_b:1'b x;  
  assign DOUT_B = (c_has_bports)?int_dout_b:8'b x;  
  assign KOUT_B = (c_has_bports)?int_kout_b:1'b x;  
  assign SYM_DISP_B = (c_has_bports)?int_sym_disp_b:2'b x;  
  assign RUN_DISP_B = (c_has_bports)?int_run_disp_b:1'b x;  
  assign ND_B = (c_has_bports)?int_nd_b:1'b x;  

endmodule



 
 /*************************************************************************
 * Filename:    decode_8b10b_v4_0_base.v
 *
 * Description: The Verilog behavioral model for the single 8b/10b Decoder     
 * 
 * ***********************************************************************/
                      
module decode_8b10b_v4_0_base
  (
     /********************************************************************
      * Mandatory Pins
      *  clk  : Clock Input
      *  din  : Encoded Symbol Input
      *  dout : Data Output, decoded data byte
      *  kout : Command Output
      ********************************************************************/
      clk,
      din,
      dout,
      kout,

     /********************************************************************
      * Optional Pins
      *  ce         : Clock Enable
      *  disp_in    : Disparity Input (running disparity in)
      *  sinit      : Synchronous Initialization. Resets core to known state.
      *  code_err   : Code Err_or, indicates that input symbol did not correspond
      *                to a valid member of the code set.
      *  disp_err   : Disparity Err_or
      *  nd         : New Data
      *  run_disp   : Running Disparity
      *  sym_disp   : Symbol Disparity
      ********************************************************************/
      ce,
      disp_in,
      sinit,
      code_err,
      disp_err,
      nd,
      run_disp,
      sym_disp
  );

 
  /********************************************************************
    * Generic Parameters
    *  c_has_ce           : 1 indicates ce port is present
    *  c_has_code_err     : 1 indicates code_err port is present
    *  c_has_disp_err     : 1 indicates disp_err port is present
    *  c_has_disp_in      : 1 indicates disp_in port is present
    *  c_has_nd           : 1 indicates nd port is present
    *  c_has_run_disp     : 1 indicates run_disp port is present
    *  c_has_sinit        : 1 indicates sinit port is present
    *  c_has_sym_disp     : 1 indicates sym_disp port is present
    *  c_sinit_dout       : 8-bit binary string, dout value when sinit is active
    *  c_sinit_kout       : controls kout output when sinit is active
    *  c_sinit_run_disp   : Initializes run_disp value to positive(1) or negative(0)
    ********************************************************************/
  parameter c_has_ce         = 0;
  parameter c_has_code_err   = 1;
  parameter c_has_disp_err   = 1;
  parameter c_has_disp_in    = 0; 
  parameter c_has_nd         = 0;
  parameter c_has_run_disp   = 0;
  parameter c_has_sinit      = 0; 
  parameter c_has_sym_disp   = 0; 
  parameter c_sinit_dout       = "00000000";
  parameter c_sinit_kout       = 0; 
  parameter c_sinit_run_disp   = 0; 
 
 /********************************************************************
  * Mandatory Pins
  *  clk  : Clock Input
  *  din  : Encoded Symbol Input    
  *  dout : Data Output, decoded data byte
  *  kout : Command Output
  ********************************************************************/
  input clk;
  input [9:0] din;
  output [7:0] dout;
  output kout;

 /********************************************************************
  * Optional Pins
  *  ce         : Clock Enable
  *  disp_in    : Disparity Input (running disparity in)
  *  sinit      : Synchronous Initialization. Resets core to known state.
  *  code_err   : Code Err_or, indicates that input symbol did not correspond
  *                to a valid member of the code set.
  *  disp_err   : Disparity Err_or
  *  nd         : New Data
  *  run_disp   : Running Disparity
  *  sym_disp   : Symbol Disparity
  ********************************************************************/
  input    ce;
  input    disp_in;
  input    sinit;
  output    code_err;
  output    disp_err;
  output    nd;
  output    run_disp;
  output    [1:0] sym_disp;


 /********************************************************************
  * IO ports that must also be declared as reg's
  ********************************************************************/
  reg [7:0] dout;
  reg kout;
  reg disp_err;
  reg run_disp;

 /********************************************************************
  * Constants for disparity:
  *  00 = Zero Disparity
  *  01 = Disparity Err_or
  *  10 = Negative Disparity
  *  11 = Positive Disparity
  ********************************************************************/
  parameter zero = 2'b10;	//2'b00;
  parameter invalid = 2'b11;	//2'b01;
  parameter neg = 2'b00;	//2'b10;
  parameter pos = 2'b01;	//2'b11;

 /********************************************************************
  * Constant Declarations
  ********************************************************************/
  parameter yes = 1'b 1;
  parameter no  = 1'b 0;
  parameter [4:0] defaultb5 = 5'b 11111;
  parameter [2:0] defaultb3 = 3'b 111;
  parameter true = 1'b 1;
  parameter false = 1'b 0;
  parameter reg_size = 8; //number of bits of dout port

 /********************************************************************
  * Internal net declarations
  ********************************************************************/
  reg   disp_last;
  wire  ce_int      ;
  reg   nd_int       ;
  //reg   code_fault   ;
  reg   [1:0] b6_disp    ;//disparity = zero, invalid, pos, neg
  reg   [1:0] b4_disp    ;//disparity = zero, invalid, pos, neg
  wire  disp_in_int    ;
  reg   b6_err     ;
  reg   b4_err     ;
  reg   [4:0] b5  ;
  reg   [7:5] b3  ;
  reg   k   ;
  wire  k28 ;
  reg [1:0] sym_disp_int;

  wire   [5:0] b6 ;
  wire   [3:0] b4 ;
  wire   a  ;
  wire   b  ;
  wire   c  ;
  wire   d  ;
  wire   e  ;
  wire   i  ;
  wire   f  ;
  wire   g  ;
  wire   h  ;
  wire   j  ;

 /********************************************************************
  * Wires for calculating code_error
  ********************************************************************/
reg P04;
reg P13;
reg P22;
reg P31;
reg P40;
wire fghj;
wire eifgh;
wire sK28;
wire e_i;
wire ighj;
wire i_ghj;
wire Kx7;
wire INVR6;
wire PDBR6;
wire NDBR6;
wire PDUR6;
wire PDBR4;
wire NDRR4;
wire NDUR6;
wire PDRR6;
wire NDBR4; 
wire PDRR4; 
wire fgh;
wire invby_a;
wire invby_b;
wire invby_c;
wire invby_d;
wire invby_e;
wire invby_f;
wire invby_g;
wire invby_h;
wire INVBY; 

reg code_err_i; 



   
 /********************************************************************
  * Declare Functions
  ********************************************************************/


 /********************************************************************
  * to_bits function:
  *  Converts binary string (where each 1 or 0 is stored as ASCII)
  *  of length reg_size-1 and converts it into an actual binary value
  ********************************************************************/
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


 /********************************************************************
  * calc_sym_disp function:
  *  Calculates symbol disparity for sinit cases
  ********************************************************************/
function [1:0] calc_sym_disp;
  input [reg_size*8 : 1] sinit_dout;
  input sinit_run_disp;
  reg [1:0] tmp_sym_disp;
  begin
    case (sinit_dout)
      "00000000" : tmp_sym_disp = (sinit_run_disp ? pos : neg);
      "01001010" : tmp_sym_disp = (sinit_run_disp ? zero : zero);
      "10110101" : tmp_sym_disp = (sinit_run_disp ? zero : zero);
      default    : tmp_sym_disp = zero;
    endcase
     calc_sym_disp = tmp_sym_disp;    
  end
endfunction


 /********************************************************************
  * calc_run_disp_init_val function:
  *  Calculates the internal running disparity for sinit cases where
  *  the sinit_dout and sinit_run_disp are known
  ********************************************************************/   
function calc_run_disp_init_val;
  input [reg_size*8 : 1] sinit_dout;
  input sinit_run_disp;
  reg tmp_run_disp_init_val;
  begin
    case (sinit_dout)
      "00000000" : tmp_run_disp_init_val = (sinit_run_disp ? 1'b0 : 1'b1);
      "01001010" : tmp_run_disp_init_val = (sinit_run_disp ? 1'b1 : 1'b0);
      "10110101" : tmp_run_disp_init_val = (sinit_run_disp ? 1'b1 : 1'b0);
      default    : tmp_run_disp_init_val = 1'b0;
    endcase
      calc_run_disp_init_val = tmp_run_disp_init_val;     
  end
endfunction

 
 
 /****End Functions****************************************************/


   
 /********************************************************************
  * Set initial values
  ********************************************************************/   
initial
  begin
     dout         = to_bits(c_sinit_dout);
     kout         = c_sinit_kout ? 1'b1 : 1'b0;
     nd_int       = 1'b0;
     //code_fault   = 1'b0;
     sym_disp_int = calc_sym_disp(c_sinit_dout, c_sinit_run_disp);
     disp_last    = calc_run_disp_init_val(c_sinit_dout, c_sinit_run_disp);
  end   

   
 /********************************************************************
  * Create Aliases for some nets
  ********************************************************************/   
assign b6 = din[5:0];
assign b4 = din[9:6];
assign a = din[0];
assign b = din[1];
assign c = din[2];
assign d = din[3];
assign e = din[4];
assign i = din[5];
assign f = din[6];
assign g = din[7];
assign h = din[8];
assign j = din[9];


 /********************************************************************
  * Conditionally Tie Optional ports to internal signals
  ********************************************************************/   

/****Internal Clock Enable********************************************/
assign ce_int =     (c_has_ce) 
                    ? ce 
                    : 1'b 1;

/****Symbol Disparity*************************************************/
assign sym_disp =   (c_has_sym_disp) 
                    ? sym_disp_int 
                    : 2'b XX;

/****New Data*********************************************************/
assign nd =         (c_has_nd) 
                    ? nd_int 
                    : 1'b X;

/****Code Err_or*******************************************************/
assign code_err =   (c_has_code_err) 
                    ? code_err_i 
                    : 1'b X;

/****Running Disparity************************************************/
always @(sym_disp_int or disp_last)
begin
  if (c_has_run_disp) 
    if (sym_disp_int[1]==1'b 0)  //**V2**1)
      run_disp = sym_disp_int[0];
    else
      run_disp = disp_last;
  else 
    run_disp = 1'b X ;
end

/****Disparity Err_or**************************************************/
always @(sym_disp_int or disp_last)
begin
  if (c_has_disp_err)
    if (sym_disp_int[1]==1'b 0)  //**V2**1)
      if (sym_disp_int[0]==disp_last)
        disp_err = 1'b 1;
      else
        disp_err = 1'b 0;
    else 
      disp_err = sym_disp_int[0];
  else
    disp_err = 1'b X;
end

/****Disp_Last (the internal running disparity, not externally visible)*/
always @(posedge clk)
begin
  if (c_has_run_disp || c_has_disp_err)
    if (c_has_sinit && sinit==1'b 1)
      disp_last <= calc_run_disp_init_val(c_sinit_dout, c_sinit_run_disp);
    else
      if (ce_int == 1'b 1)
        if (c_has_disp_in)
          disp_last <= disp_in;
        else
          if (sym_disp_int[1] == 1'b 0)   //**V2**1)
            disp_last <= sym_disp_int[0];
          else
            disp_last <= disp_last;
      else
        disp_last <= disp_last;
  else
    disp_last <= 1'b X;
end


 /********************************************************************
  * Calculate sym_disp_int value
  * sym_disp_int is disparity for last din symbol point
  *     00: Input symbol had zero disparity
  *     01: Input symbol had a disparity err_or in one or both sub-block
  *     10: Input symbol had negative disparity
  *     11: Input symbol had positive disparity
  ********************************************************************/   
always @(posedge clk)
begin
  if (c_has_sym_disp || c_has_run_disp || c_has_disp_err)
   if (ce_int)
    
    if (c_has_sinit && sinit)
      sym_disp_int <= calc_sym_disp(c_sinit_dout, c_sinit_run_disp);
    else
      if           // coded byte has negative disparity 
      (
        (b6_disp == zero && b4_disp == neg) ||
        (b6_disp == neg && b4_disp == zero)
      )
        sym_disp_int <= neg;
      else
        if      // coded byte has positive disparity
        (
          (b6_disp == zero && b4_disp == pos) ||
          (b6_disp == pos && b4_disp == zero)
        )
          sym_disp_int <= pos;
        else 
          if        // coded byte has disparity of zero
          (
            (b6_disp == zero && b4_disp == zero) ||
            (b6_disp == pos && b4_disp == neg) ||
            (b6_disp == neg && b4_disp == pos)
          )            
            sym_disp_int <= zero;
          else
            sym_disp_int <= invalid;
end


 /********************************************************************
  * Set the value of k28 signal
  ********************************************************************/   
assign  k28 = !((c | d | e | i) | !(h ^ j)) ;



 /********************************************************************
  * Do the 6B/5B conversion
  ********************************************************************/   
always @(b6)
 begin
  case (b6)
    6'b 000110 : b5 = 5'b 00000;  // D.0
    6'b 111001 : b5 = 5'b 00000;  // D.0
    6'b 010001 : b5 = 5'b 00001;  // D.1
    6'b 101110 : b5 = 5'b 00001;  // D.1
    6'b 010010 : b5 = 5'b 00010;  // D.2
    6'b 101101 : b5 = 5'b 00010;  // D.2
    6'b 100011 : b5 = 5'b 00011;  // D.3
    6'b 010100 : b5 = 5'b 00100;  // D.4
    6'b 101011 : b5 = 5'b 00100;  // D.4
    6'b 100101 : b5 = 5'b 00101;  // D.5
    6'b 100110 : b5 = 5'b 00110;  // D.6
    6'b 000111 : b5 = 5'b 00111;  // D.7
    6'b 111000 : b5 = 5'b 00111;  // D.7
    6'b 011000 : b5 = 5'b 01000;  // D.8
    6'b 100111 : b5 = 5'b 01000;  // D.8
    6'b 101001 : b5 = 5'b 01001;  // D.9
    6'b 101010 : b5 = 5'b 01010;  // D.10
    6'b 001011 : b5 = 5'b 01011;  // D.11
    6'b 101100 : b5 = 5'b 01100;  // D.12
    6'b 001101 : b5 = 5'b 01101;  // D.13
    6'b 001110 : b5 = 5'b 01110;  // D.14
    6'b 000101 : b5 = 5'b 01111;  // D.15
    6'b 111010 : b5 = 5'b 01111;  // D.15

    6'b 110110 : b5 = 5'b 10000;  // D.16
    6'b 001001 : b5 = 5'b 10000;  // D.16
    6'b 110001 : b5 = 5'b 10001;  // D.17
    6'b 110010 : b5 = 5'b 10010;  // D.18
    6'b 010011 : b5 = 5'b 10011;  // D.19
    6'b 110100 : b5 = 5'b 10100;  // D.20
    6'b 010101 : b5 = 5'b 10101;  // D.21
    6'b 010110 : b5 = 5'b 10110;  // D.22
    6'b 010111 : b5 = 5'b 10111;  // D/K.23
    6'b 101000 : b5 = 5'b 10111;  // D/K.23
    6'b 001100 : b5 = 5'b 11000;  // D.24
    6'b 110011 : b5 = 5'b 11000;  // D.24
    6'b 011001 : b5 = 5'b 11001;  // D.25
    6'b 011010 : b5 = 5'b 11010;  // D.26
    6'b 011011 : b5 = 5'b 11011;  // D/K.27
    6'b 100100 : b5 = 5'b 11011;  // D/K.27
    6'b 011100 : b5 = 5'b 11100;  // D.28
    6'b 111100 : b5 = 5'b 11100;  // K.28
    6'b 000011 : b5 = 5'b 11100;  // K.28
    6'b 011101 : b5 = 5'b 11101;  // D/K.29
    6'b 100010 : b5 = 5'b 11101;  // D/K.29
    6'b 011110 : b5 = 5'b 11110;  // D.30
    6'b 100001 : b5 = 5'b 11110;  // D.30
    6'b 110101 : b5 = 5'b 11111;  // D.31
    6'b 001010 : b5 = 5'b 11111;  // D.31
    default    : b5 = defaultb5;  // CODE VIOLATION!
  endcase
 end




 /********************************************************************
  * Disparity for the 6B block
  ********************************************************************/   
always @(b6)
 begin
  case (b6)
    6'b 000000 : begin
                   b6_disp = neg ;   // invalid ;
                   b6_err  = true ;
                 end
    6'b 000001 : begin 
                   b6_disp = neg ;   // invalid ;
                   b6_err  = true ;
                 end
    6'b 000010 : begin 
                   b6_disp = neg ;   // invalid ;
                   b6_err  = true ;
                 end
    6'b 000011 : begin 
                   b6_disp = neg ;   // K.28
                   b6_err  = false ;
                 end
    6'b 000100 : begin 
                   b6_disp = neg ;   // invalid ;
                   b6_err  = true ;
                 end
    6'b 000101 : begin 
                   b6_disp = neg ;   // D.15
                   b6_err  = false ;
                 end
    6'b 000110 : begin 
                   b6_disp = neg ;   // D.0
                   b6_err  = false; //CHANGED FROM true DUE TO CR 130235;
                 end
    6'b 000111 : begin 
                   b6_disp = zero ;  // D.7
                   b6_err  = false ;
                 end
    6'b 001000 : begin 
                   b6_disp = neg ;   // invalid ;
                   b6_err  = true ;
                 end
    6'b 001001 : begin 
                   b6_disp = neg ;   // D.16
                   b6_err  = false ;
                 end
    6'b 001010 : begin 
                   b6_disp = neg ;   // D.31
                   b6_err  = false ;
                 end
    6'b 001011 : begin 
                   b6_disp = zero ;  // D.11
                   b6_err  = false ;
                 end
    6'b 001100 : begin 
                   b6_disp = neg ;   // D.24
                   b6_err  = false ;
                 end
    6'b 001101 : begin 
                   b6_disp = zero ;  // D.13
                   b6_err  = false ;
                 end
    6'b 001110 : begin 
                   b6_disp = zero ;  // D.14
                   b6_err  = false ;
                 end
    6'b 001111 : begin 
                   b6_disp = pos ;   // invlaid ;
                   b6_err  = true ;
                 end
    6'b 010000 : begin 
                   b6_disp = neg ;   // invalid ;
                   b6_err  = true ;
                 end
    6'b 010001 : begin 
                   b6_disp = neg ;   // D.1
                   b6_err  = false ;
                 end
    6'b 010010 : begin 
                   b6_disp = neg ;   // D.2
                   b6_err  = false ;
                 end
    6'b 010011 : begin 
                   b6_disp = zero ;  // D.19
                   b6_err  = false ;
                 end
    6'b 010100 : begin 
                   b6_disp = neg ;   // D.4
                   b6_err  = false ;
                 end
    6'b 010101 : begin 
                   b6_disp = zero ;  // D.21
                   b6_err  = false ;
                 end
    6'b 010110 : begin 
                   b6_disp = zero ;  // D.22
                   b6_err  = false ;
                 end
    6'b 010111 : begin 
                   b6_disp = pos ;   // D.23
                   b6_err  = false ;
                 end
    6'b 011000 : begin 
                   b6_disp = neg ;   // D.8
                   b6_err  = false ;
                 end
    6'b 011001 : begin 
                   b6_disp = zero ;  // D.25
                   b6_err  = false ;
                 end
    6'b 011010 : begin 
                   b6_disp = zero ;  // D.26
                   b6_err  = false ;
                 end
    6'b 011011 : begin 
                   b6_disp = pos ;   // D.27
                   b6_err  = false ;
                 end
    6'b 011100 : begin 
                   b6_disp = zero ;  // D.28
                   b6_err  = false ;
                 end
    6'b 011101 : begin 
                   b6_disp = pos ;   // D.29
                   b6_err  = false ;
                 end
    6'b 011110 : begin 
                   b6_disp = pos ;   // D.30
                   b6_err  = false ;
                 end
    6'b 011111 : begin 
                   b6_disp = pos ;   // invalid ;
                   b6_err  = true ;
                 end
    6'b 100000 : begin 
                   b6_disp = neg ;   // invalid ;
                   b6_err  = true ;
                 end
    6'b 100001 : begin 
                   b6_disp = neg ;   // D.30 ;
                   b6_err  = false ;
                 end
    6'b 100010 : begin 
                   b6_disp = neg ;   // D.29 ;
                   b6_err  = false ;
                 end
    6'b 100011 : begin 
                   b6_disp = zero ;  // D.3
                   b6_err  = false ;
                 end
    6'b 100100 : begin 
                   b6_disp = neg ;   // D.27
                   b6_err  = false ;
                 end
    6'b 100101 : begin 
                   b6_disp = zero ;  // D.5
                   b6_err  = false ;
                 end
    6'b 100110 : begin 
                   b6_disp = zero ;  // D.6
                   b6_err  = false ;
                 end
    6'b 100111 : begin 
                   b6_disp = pos ;   // D.8
                   b6_err  = false; //CHANGED FROM true DUE TO CR 130235;
                 end
    6'b 101000 : begin 
                   b6_disp = neg ;   // D.23
                   b6_err  = false ;
                 end
    6'b 101001 : begin 
                   b6_disp = zero ;  // D.9
                   b6_err  = false ;
                 end
    6'b 101010 : begin 
                   b6_disp = zero ;  // D.10
                   b6_err  = false ;
                 end
    6'b 101011 : begin 
                   b6_disp = pos ;   // D.4
                   b6_err  = false ;
                 end
    6'b 101100 : begin 
                   b6_disp = zero ;  // D.12
                   b6_err  = false ;
                 end
    6'b 101101 : begin 
                   b6_disp = pos ;   // D.2
                   b6_err  = false ;
                 end
    6'b 101110 : begin 
                   b6_disp = pos ;   // D.1
                   b6_err  = false ;
                 end
    6'b 101111 : begin 
                   b6_disp = pos ;   // invalid ;
                   b6_err  = true ;
                 end
    6'b 110000 : begin 
                   b6_disp = neg ;   // invalid ;
                   b6_err  = true ;
                 end
    6'b 110001 : begin 
                   b6_disp = zero ;  // D.17
                   b6_err  = false ;
                 end
    6'b 110010 : begin 
                   b6_disp = zero ;  // D.18
                   b6_err  = false ;
                 end
    6'b 110011 : begin 
                   b6_disp = pos; //CHANGED FROM neg DUE TO CR 130235;   // D.24
                   b6_err  = false ;
                 end
    6'b 110100 : begin 
                   b6_disp = zero ;  // D.20
                   b6_err  = false ;
                 end
    6'b 110101 : begin 
                   b6_disp = pos ;   // D.31
                   b6_err  = false ;
                 end
    6'b 110110 : begin 
                   b6_disp = pos ;   // D.16
                   b6_err  = false ;
                 end
    6'b 110111 : begin 
                   b6_disp = pos ;   // invalid ;
                   b6_err  = true ;
                 end
    6'b 111000 : begin 
                   b6_disp = zero ;  // D.7
                   b6_err  = false ;
                 end
    6'b 111001 : begin 
                   b6_disp = pos ;   // D.0
                   b6_err  = false ;
                 end
    6'b 111010 : begin 
                   b6_disp = pos ;   // D.15
                   b6_err  = false ;
                 end
    6'b 111011 : begin 
                   b6_disp = pos ;   // invalid ;
                   b6_err  = true ;
                 end
    6'b 111100 : begin 
                   b6_disp = pos ;   // K.28
                   b6_err  = false ;
                 end
    6'b 111101 : begin 
                   b6_disp = pos ;   // invalid ;
                   b6_err  = true ;
                 end
    6'b 111110 : begin 
                   b6_disp = pos ;   // invalid ;     
                   b6_err  = true ;
                 end
    6'b 111111 : begin 
                   b6_disp = pos ;   // invalid ;
                   b6_err  = true ;
                 end
    default    : begin 
                   b6_disp = zero ;
                   b6_err = true ;
                 end
  endcase
 end




 /********************************************************************
  * Do the 3B/4B conversion
  ********************************************************************/   
always @(b4 or k28)
 begin
  case (b4)
    4'b 0010 : b3 = 3'b 000;      // D/K.x.0
    4'b 1101 : b3 = 3'b 000;      // D/K.x.0
    4'b 1001 : 
               if (k28 == 1'b 0)
                 b3 = 3'b 001;      // D/K.x.1
               else
                 b3 = 3'b 110;      // K28.6
    4'b 0110 : 
               if (k28 == 1'b 1)
                 b3 = 3'b 001;      // K.28.1
               else 
                 b3 = 3'b 110;      // D/K.x.6
    4'b 1010 : 
               if (k28 == 1'b 0)
                 b3 = 3'b 010;      // D/K.x.2
               else
                 b3 = 3'b 101;      // K28.5
    4'b 0101 : 
               if (k28 == 1'b 1)
                 b3 = 3'b 010;      // K28.2
               else
                 b3 = 3'b 101;      // D/K.x.5
    4'b 0011 : b3 = 3'b 011;      // D/K.x.3
    4'b 1100 : b3 = 3'b 011;      // D/K.x.3
    4'b 0100 : b3 = 3'b 100;      // D/K.x.4
    4'b 1011 : b3 = 3'b 100;      // D/K.x.4
    4'b 0111 : b3 = 3'b 111;      // D.x.7
    4'b 1000 : b3 = 3'b 111;      // D.x.7
    4'b 1110 : b3 = 3'b 111;      // D/K.x.7
    4'b 0001 : b3 = 3'b 111;      // D/K.x.7
    default  : b3 = defaultb3;  // CODE VIOLATION!
  endcase
 end




 /********************************************************************
  * Disparity for the 4B block
  ********************************************************************/   
always @(b4)
 begin

  case(b4)
    4'b 0000 : begin 
                 b4_disp = neg ;
                 b4_err  = true ;
               end
    4'b 0001 : begin 
                 b4_disp = neg ;
                 b4_err  = false ;
               end
    4'b 0010 : begin 
                 b4_disp = neg ;
                 b4_err  = false ;
               end
    4'b 0011 : begin 
                 b4_disp = zero ;
                 b4_err  = false ;
               end
    4'b 0100 : begin 
                 b4_disp = neg ;
                 b4_err  = false ;
               end
    4'b 0101 : begin 
                 b4_disp = zero ;
                 b4_err  = false ;
               end
    4'b 0110 : begin 
                 b4_disp = zero ;
                 b4_err  = false ;
               end
    4'b 0111 : begin 
                 b4_disp = pos ;
                 b4_err  = false ;
               end
    4'b 1000 : begin 
                 b4_disp = neg ;
                 b4_err  = false ;
               end
    4'b 1001 : begin 
                 b4_disp = zero ;
                 b4_err  = false ;
               end
    4'b 1010 : begin 
                 b4_disp = zero ;
                 b4_err  = false ;
               end
    4'b 1011 : begin 
                 b4_disp = pos ;
                 b4_err  = false ;
               end
    4'b 1100 : begin 
                 b4_disp = zero ;
                 b4_err  = false ;
               end
    4'b 1101 : begin 
                 b4_disp = pos ;
                 b4_err  = false ;
               end
    4'b 1110 : begin 
                 b4_disp = pos ;
                 b4_err  = false ;
               end
    4'b 1111 : begin 
                 b4_disp = pos ;
                 b4_err  = true ;
               end
    default  : begin 
                 b4_disp = zero ;
                 b4_err = true ;
               end
  endcase


 end



 /********************************************************************
  * Decode the K codes
  ********************************************************************/   
always @(c or d or e or i or g or h or j)
  k = (c & d & e & i) | !(c | d | e | i) | 
       ((e ^ i) & ((i & g & h & j) | 
                   !(i | g | h | j))) ;




 /********************************************************************
  *  Updated the outputs on the clock
  ********************************************************************/
   
/****Update dout, kout and code_fault outputs*************************/
always @(posedge clk)
    if (ce_int)
      if ((c_has_sinit) && (sinit)) 
        begin
          dout       <= to_bits(c_sinit_dout);
          kout       <= c_sinit_kout ? 1'b1 : 1'b0;
          code_err_i <= 1'b 0 ;
        end
      else
        begin
          dout       <= {b3, b5} ;
          kout       <= k ;
          code_err_i <= INVBY;
	end 
/*          if (b6_err || b4_err) 
*            code_fault = 1'b 1 ;
*          else if ((b6_disp != zero) && (b6_disp==b4_disp))
*            code_fault = 1'b 1;
*          else
*            code_fault = 1'b 0 ;
*      end
*/

 
/****Update the New Data output***************************************/
always @(posedge clk)
  if (ce_int && c_has_sinit && sinit)
    nd_int <= 1'b 0;
  else
    nd_int <= ce_int;

/*********************************************************************/
// Calculate code_error (uses notation from IBM spec)
/*********************************************************************/
 
always @(din)
  case (din[3:0])
    4'b 0000 :
      begin
	 P04 = 1'b1;
	 P13 = 1'b0;
	 P22 = 1'b0;
	 P31 = 1'b0;
	 P40 = 1'b0;
      end
    4'b 0001 :
      begin
	 P04 = 1'b0;
	 P13 = 1'b1;
	 P22 = 1'b0;
	 P31 = 1'b0;
	 P40 = 1'b0;
      end
    4'b 0010 :
      begin
	 P04 = 1'b0;
	 P13 = 1'b1;
	 P22 = 1'b0;
	 P31 = 1'b0;
	 P40 = 1'b0;
      end
    4'b 0011 :
      begin
	 P04 = 1'b0;
	 P13 = 1'b0;
	 P22 = 1'b1;
	 P31 = 1'b0;
	 P40 = 1'b0;
      end
    4'b 0100 :
      begin
	 P04 = 1'b0;
	 P13 = 1'b1;
	 P22 = 1'b0;
	 P31 = 1'b0;
	 P40 = 1'b0;
      end
    4'b 0101 :
      begin
	 P04 = 1'b0;
	 P13 = 1'b0;
	 P22 = 1'b1;
	 P31 = 1'b0;
	 P40 = 1'b0;
      end
    4'b 0110 :
      begin
	 P04 = 1'b0;
	 P13 = 1'b0;
	 P22 = 1'b1;
	 P31 = 1'b0;
	 P40 = 1'b0;
      end
    4'b 0111 :
      begin
	 P04 = 1'b0;
	 P13 = 1'b0;
	 P22 = 1'b0;
	 P31 = 1'b1;
	 P40 = 1'b0;
      end
    4'b 1000 :
      begin
	 P04 = 1'b0;
	 P13 = 1'b1;
	 P22 = 1'b0;
	 P31 = 1'b0;
	 P40 = 1'b0;
      end
    4'b 1001 :
      begin
	 P04 = 1'b0;
	 P13 = 1'b0;
	 P22 = 1'b1;
	 P31 = 1'b0;
	 P40 = 1'b0;
      end
    4'b 1010 :
      begin
	 P04 = 1'b0;
	 P13 = 1'b0;
	 P22 = 1'b1;
	 P31 = 1'b0;
	 P40 = 1'b0;
      end
    4'b 1011 :
      begin
	 P04 = 1'b0;
	 P13 = 1'b0;
	 P22 = 1'b0;
	 P31 = 1'b1;
	 P40 = 1'b0;
      end
    4'b 1100 :
      begin
	 P04 = 1'b0;
	 P13 = 1'b0;
	 P22 = 1'b1;
	 P31 = 1'b0;
	 P40 = 1'b0;
      end
    4'b 1101 :
      begin
	 P04 = 1'b0;
	 P13 = 1'b0;
	 P22 = 1'b0;
	 P31 = 1'b1;
	 P40 = 1'b0;
      end
    4'b 1110 :
      begin
	 P04 = 1'b0;
	 P13 = 1'b0;
	 P22 = 1'b0;
	 P31 = 1'b1;
	 P40 = 1'b0;
      end
    4'b 1111 :
      begin
	 P04 = 1'b0;
	 P13 = 1'b0;
	 P22 = 1'b0;
	 P31 = 1'b0;
	 P40 = 1'b1;
      end
    default : 
      begin
	 P04 = 1'b0;
	 P13 = 1'b0;
	 P22 = 1'b0;
	 P31 = 1'b0;
	 P40 = 1'b0;
      end
  endcase	 


assign fghj = (f & g & h & j) | (!f & !g & !h & !j);
assign eifgh = (e & i & f & g & h) | (!e & !i & !f & !g & !h);
assign sK28 = (c & d & e & i) | (!c & !d & !e & !i);
assign e_i = (e & !i) | (!e & i);
assign ighj = (i & g & h & j) | (!i & !g & !h & !j);
assign i_ghj = (!i & g & h & j) | (i & !g & !h & !j);
assign Kx7 = e_i & ighj;
assign INVR6 = P40 | P04 | (P31 & e & i) | (P13 & !e & !i);
assign PDBR6 = (P31 & (e | i)) | (P22 & e & i) | P40;
assign NDBR6 = (P13 & (!e | !i)) | (P22 & !e & !i) | P04;
assign PDUR6 = PDBR6 | (d & e & i);
assign PDBR4 = (f & g & (h | j)) | ((f | g) & h & j);
assign NDRR4 = PDBR4 | (f & g);
assign NDUR6 =  NDBR6 | (!d & !e & !i);
assign PDRR6 = NDBR6 | (!a & !b & !c);
assign fgh = (f & g & h) | (!f & !g & !h);
assign NDBR4 = (!f & !g & (!h | !j)) | ((!f | !g) & !h & !j);
assign PDRR4 = NDBR4 | (!f & !g);

assign invby_a = INVR6;
assign invby_b = fghj;
assign invby_c = eifgh;
assign invby_d = (!sK28 & i_ghj);
assign invby_e = (sK28 & fgh);
assign invby_f = (Kx7 & !PDBR6 & !NDBR6);
assign invby_g = (PDUR6 & NDRR4);
assign invby_h = (NDUR6 & PDRR4);

assign INVBY = invby_a | invby_b | invby_c | invby_d | invby_e | invby_f | invby_g | invby_h;

 /********************************************************************
  * End of code_error calculation
  ********************************************************************/
   
   
endmodule








 
 
 
 
