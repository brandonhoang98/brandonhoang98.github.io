// ************************************************************************
// $Id: C_DA_1D_DCT_V2_1.V
// ************************************************************************
// Copyright 2001 - Xilinx Inc.
// All rights reserved.
// ************************************************************************
// Filename: C_DA_1D_DCT_V2_1.v
// Creation : May 9th, 2001
// Description: Verilog Behavioral Model for 1D DCT operation
// 
// Algorithm : Calculates the 1D DCT coefficients. DCT Points range from 8
//             to 32. There is double buffering at the input, to allow
//             continuous usage of DCT engine.
// 
// Equations: Even DCT                                               
//                                                                   
//                        N-1                                        
//  X(k) = sqrt(2/N) * SUM { c_k * x(n) * cos((pi*(2n+1)k) /(2*N)) } 
//                        n=0                                        
//                                 where k = 0,1, ... ,N-1            
//                                                                   
// Even IDCT                                                         
//                        N-1                                        
//  x(n) = sqrt(2/N) * SUM { c_k * X(k) * cos((pi*(2n+1)k) /(2*N)) } 
//                        k=0                                        
//                                 where n = 0,1, ... ,N-1            
//                                                                   
//           NOTE :  c_k = 1/sqrt(2) for k=0                         
//                       = 1         for k=1,2,..,N-1                
//                                                                   
// *******************************************************************
// Last Change :
//              10th Jun 2001: Added RST pin to the core
//
// *********************************************************************


`timescale 1ns/10ps

`define true  1'b1
`define false 1'b0

`define FORWARD_DCT 0
`define INVERSE_DCT 1
`define FORWARD_INVERSE_DCT 2

`define SIGNED_VALUE 0
`define UNSIGNED_VALUE 1

`define FULL_PRECISION 0
`define TRUNCATE 1
`define ROUND 2

`define BLOCK_MEMORY 0
`define DIST_MEMORY 1

`define NO_CONTROL 0
`define ROW_ORIENTATION 1
`define COL_ORIENTATION 2


module C_DA_1D_DCT_V2_1
  (
    CLK,
    DIN,
    DOUT,
    ND,
    RDY,
    RFD,
    RST
    );

  parameter C_CLKS_PER_SAMPLE       = 8; //cps (clocks required for processing each data set
  parameter C_COEFF_WIDTH           = 8; //range 8 to 24
  parameter C_DATA_TYPE             = `SIGNED_VALUE;
  parameter C_DATA_WIDTH            = 8; //range 8 to 24
  parameter C_ENABLE_RLOCS          = `false;
  parameter C_ENABLE_SYMMETRY       = `false;
  parameter C_HAS_RESET             = `false;

  parameter C_LATENCY               = 15; //delay between the last data read
                                         // and 1st DCT coef outputted
                                         // This value is passed from the core
                                         // implementation
  
  parameter C_OPERATION             = `FORWARD_DCT;
  parameter C_POINTS                = 8; //range 8 to 32
  parameter C_PRECISION_CONTROL     = `FULL_PRECISION;
  parameter C_RESULT_WIDTH          = 19; // C_DATA_WIDTH + C_COEFF_WIDTH + log2(C_POINTS) +C_DATA_TYPE
  parameter C_SHAPE                 = `NO_CONTROL; // not supported

  parameter log2_c_points = (( C_POINTS <=  4) ? 2 :
                             ( C_POINTS <=  8) ? 3 :
                             ( C_POINTS <= 16) ? 4 :
                             ( C_POINTS <= 32) ? 5 : 6);

  parameter sqrt_c_points  = ((C_POINTS ==  4 ? 2.00000000000000 :
                              (C_POINTS ==  5 ? 2.23606797749978 :
                              (C_POINTS ==  6 ? 2.44948974278317 :
                              (C_POINTS ==  7 ? 2.64575131106459 :
                              (C_POINTS ==  8 ? 2.82842712474611 :
                              (C_POINTS ==  9 ? 3.00000000000000 :
                              (C_POINTS == 10 ? 3.16227766016837 :
                              (C_POINTS == 11 ? 3.31662479035539 :
                              (C_POINTS == 12 ? 3.46410161513775 :
                              (C_POINTS == 13 ? 3.60555127546398 :
                              (C_POINTS == 14 ? 3.74165738677394 :
                              (C_POINTS == 15 ? 3.87298334620741 :
                              (C_POINTS == 16 ? 4.00000000000000 :
                              (C_POINTS == 17 ? 4.12310562561766 :
                              (C_POINTS == 18 ? 4.24264068711928 :
                              (C_POINTS == 19 ? 4.35889894354067 :
                              (C_POINTS == 20 ? 4.47213595499957 :
                              (C_POINTS == 21 ? 4.58257569495584 :
                              (C_POINTS == 22 ? 4.69041575982342 :
                              (C_POINTS == 23 ? 4.79583152331271 :
                              (C_POINTS == 24 ? 4.89897948556635 :
                              (C_POINTS == 25 ? 5.00000000000000 :
                              (C_POINTS == 26 ? 5.09901951359278 :
                              (C_POINTS == 27 ? 5.19615242270663 :
                              (C_POINTS == 28 ? 5.29150262212918 :
                              (C_POINTS == 29 ? 5.38516480713450 :
                              (C_POINTS == 30 ? 5.47722557505166 :
                              (C_POINTS == 31 ? 5.56776436283002 :
                              (C_POINTS == 32 ? 5.65685424949244 :
                                                8.00000000000000)))))))))))))))))))))))))))))) ;
  parameter sqrt_2 = 1.414213562;
  parameter c_pi = 3.141592654;

  parameter data_width = (C_DATA_TYPE == `SIGNED_VALUE) ? C_DATA_WIDTH : C_DATA_WIDTH + 1;
  parameter full_precision_width = data_width + C_COEFF_WIDTH + log2_c_points;

  parameter result_width  = ((C_PRECISION_CONTROL == `FULL_PRECISION) ? full_precision_width:C_RESULT_WIDTH);

  parameter effective_datawidth = C_DATA_WIDTH + (((C_OPERATION == `FORWARD_DCT)&&(C_ENABLE_SYMMETRY == 1)) ? 1 : 0);
  // bitsatatime(baat) is the next lower integer of the (data_w + 1_or_0 + cps -1)/cps
  parameter baat = (effective_datawidth + C_CLKS_PER_SAMPLE - 1) / C_CLKS_PER_SAMPLE;
  
  //adding (baat-1) to get the next higher integer when dividing C_DATA_WIDTH by baat
  parameter clks_to_read_sample = (effective_datawidth + (baat - 1))/baat; 

  //added for VCS
  parameter diff_width = (C_PRECISION_CONTROL == `FULL_PRECISION)?(full_precision_width - result_width) :(full_precision_width - result_width);

  // the check between c_points and data_width allows the RFD to remain high
  // for cases when points are greater than datawidth and so the processing
  // will always take lesser clocks than are available and so the RFD can
  // remain high at all times
//  parameter NUMBER_CLOCKS = ((clks_to_read_sample <= C_POINTS)?  ((C_POINTS >= data_width) ? C_POINTS :(C_POINTS + C_ENABLE_SYMMETRY)) : clks_to_read_sample);
  parameter NUMBER_CLOCKS = ((clks_to_read_sample <= C_POINTS)? C_POINTS : clks_to_read_sample); 

  input CLK;
  input [C_DATA_WIDTH - 1: 0] DIN;
  input ND;
  input RST;

  output [result_width - 1 : 0] DOUT;
  output RDY;
  output RFD;

  reg [result_width - 1 : 0] DOUT;
  reg RDY;
  reg RFD;


  // The following is required keep the systhesis tool from trying to 
  // synthesize this module 

  // synopsys_translate_off 


  // some internal signals which drive RFD, RDY and IDCT ports
  reg internalRFD;
  reg internalRDY;
  reg internalIDCT;

  // some register array to delay the output and RDY signals
  reg [result_width - 1 : 0] doutDelay [C_LATENCY - 1 : 0];
  reg rdyDelay [C_LATENCY - 1 : 0];
  
  // array to store the DCT result, which is assigned to the
  // output port sequentially.
  reg [result_width - 1 : 0] dout_reg [C_POINTS - 1 : 0];

  // register to store the full precision output
  reg [full_precision_width -  1 : 0]  dout_tmp [C_POINTS - 1 : 0];
  
  // 2 sets of register at the input to store the input
  reg [data_width - 1 : 0] data [C_POINTS - 1 : 0];
  reg [data_width - 1 : 0] data_2 [C_POINTS - 1 : 0];

  // some variables for storing elements of basis function for
  // computing the dct and idct 
  reg [C_COEFF_WIDTH - 1 : 0] dct_coeff[C_POINTS * C_POINTS - 1 : 0];
  reg [C_COEFF_WIDTH - 1 : 0] idct_coeff[C_POINTS * C_POINTS - 1 : 0];
  integer int_dct_idct_coeff[C_POINTS * C_POINTS - 1 : 0];

  // some counter variables for input data reading, rdy, rfd and 
  // output result writing 
  integer load_counter, result_counter;
  //integer rdy_counter;
  //integer rfd_counter;
  integer processing, i, k;
  
  //some flags to indicate the end of reading C_POINTS data into the
  // 1st register, 2nd register and to indicate the end of computation
  // of DCT coefficients.
  integer read1_done, read2_done, result_done, first_set;

  // some variables for computing results
  reg [full_precision_width - 1: 0] partial_product;
  reg [full_precision_width - 1: 0] sum;
  integer index1, index2;

  // some variable for initial block
  real angle, dct_idct_coeff, cosine_value;

  parameter theta_bits = 64;
  parameter scale = (1 << (C_COEFF_WIDTH - 1)); 
  reg [theta_bits -1 : 0] theta_in_bits;


  // function to perform signed multiplication for DCT
  function [(full_precision_width - 1) : 0] signed_mult;
  input [(data_width -1) : 0] MULTIPLICANT;
  input [(C_COEFF_WIDTH - 1): 0] MULTIPLIER;
  reg [(full_precision_width - 1): 0] tmp_multiplicant;
  reg [(full_precision_width - 1): 0] tmp_multiplier;

  begin
    //sign extend multiplicant and multiplier input
    tmp_multiplicant = {{(full_precision_width - data_width){MULTIPLICANT[data_width - 1]}},MULTIPLICANT};
    tmp_multiplier = {{(full_precision_width - C_COEFF_WIDTH){MULTIPLIER[C_COEFF_WIDTH - 1]}},MULTIPLIER};
    signed_mult = tmp_multiplicant * tmp_multiplier;

  end
  endfunction

  // FUNCTION TO CALCULATE THE COSINE OF A VECTORED REAL NUMBER..
  function [63:0] cos;
    input [(theta_bits - 1):0] vector;
    
    real term, theta, partial_sum, full_cycles;
    integer n, loop;
      
    begin
      term = 1.0;
      partial_sum = 1.0;
      n = 0;
      theta = $bitstoreal(vector);

      //performing a modulo operation on real valued cosine_angle
      //to limit it to +PI to -PI.
      full_cycles = theta/(2.0*c_pi);

      // getting the remainder when theta_degrees is divided by 360
      theta = theta - ($itor($rtoi(full_cycles))*2.0*c_pi);

      for (loop=0; loop < 100; loop = loop + 1)
      begin
        n = n + 2;
        term = (-term)*theta*theta/((n-1)*n);
        partial_sum = partial_sum + term;
      end
      cos = $realtobits(partial_sum);
      end
  endfunction

  // Function to pad appropriate bits to the input
  // by considering the data_type classification
  function [data_width : 0] input_conditioning;
    input[(C_DATA_WIDTH - 1) : 0 ] datain;
    input data_type;

    begin
      if(data_type == `UNSIGNED_VALUE)
        input_conditioning = {1'b0 , datain};
      else //data_type == `SIGNED_VALUE
        input_conditioning = datain;
    end
  endfunction
  
  // Function to trim the coefficients for DCT to C_COEFF_WIDTH
 // function [C_COEFF_WIDTH - 1: 0] trim_coeff;
//
//    input[31:0] input_data;
//
//    begin  
//      trim_coeff = input_data[(32  - 1):(32 - C_COEFF_WIDTH)];
//      if (input_data[31 - C_COEFF_WIDTH] == 1'b1)  // always ROUND the coefs
//      begin
//        trim_coeff = trim_coeff + 1;
//      end
//    end
//  endfunction

  // Function to trim the DCT results to C_RESULT_WIDTH
  function [(result_width - 1): 0] trim_result;

    input[(full_precision_width - 1):0] result_data;

    reg [diff_width: 0] half ;
    reg [diff_width: 0] fractional_part;

    integer i;

    begin  


 /*     if(C_PRECISION_CONTROL == `FULL_PRECISION)
      begin
        trim_result = result_data;
      end
      else if(C_PRECISION_CONTROL == `TRUNCATE)
      begin
        trim_result = result_data[(full_precision_width - 1): full_precision_width - result_width];
      end
*/
      trim_result = result_data[(full_precision_width - 1): diff_width];

      if((C_PRECISION_CONTROL == `ROUND) && (full_precision_width > result_width) && (full_precision_width > 0))
      begin

        //half = {(full_precision_width - result_width){1'b0}};

        for (i=0; i < diff_width; i = i+1)
        begin
          half[i] = 1'b0;
          fractional_part[i] = result_data[i];
          if(i == (diff_width -1))
          begin
            half[i] = 1'b1;
          end
        end

        half[diff_width] = result_data[full_precision_width -1]; //extra check
        fractional_part[diff_width] = result_data[full_precision_width -1]; //extra
          
        trim_result = result_data[(full_precision_width - 1): diff_width];

        if (result_data[full_precision_width - 1] == 1'b0) 
        begin 
          if (fractional_part >= half)
          begin
            trim_result = trim_result + 1;
          end
        end
        else if (result_data[full_precision_width - 1] == 1'b1)
        begin
          if  (fractional_part > half)
          begin
            trim_result = trim_result + 1;
          end
        end


        // It is SIGNED number and to check for saturation use sign comparison
        // sign comparison indicates any possible overflow or underflow
        // and so we revert back to the original number (or to
        // maxpositive/maxnegative number, since here only 1 is added
        // maxpositive/maxnegative number shall be same as the original truncated
        // number
        if((trim_result[result_width -1] == 1'b1) &&(result_data[full_precision_width - 1] == 1'b0))
        begin
          trim_result = result_data[(full_precision_width - 1): full_precision_width - result_width];
        end

      end
    end
  endfunction

  initial
  begin
    
    // assigning the type of operation to a signal
    // currently IDCT is not supported. But in later releases
    // its functionality will be incorporated in reloading
    // appropriate coefficients and dynamically toggle the 
    // functionality of the core between DCT and IDCT.
    case (C_OPERATION)
      `FORWARD_DCT : internalIDCT = 0;
      `INVERSE_DCT : internalIDCT = 1;
      default: internalIDCT = 0;
    endcase
  
    //initializing a few counters
    load_counter = 0;
    //rdy_counter = C_POINTS;
    //rfd_counter = 0;
    result_counter = 0;
    
    // initializing a few data input and result output register array
    for ( i = 0 ; i < C_POINTS ; i= i+ 1)
    begin
      dout_tmp[i] = {full_precision_width{1'b0}};
      data[i] = {data_width{1'b0}};
      data_2[i] = {data_width{1'b0}};
      dout_reg[i] = {result_width{1'b0}};
    end

    // initializing a few arrays used for appropriate delaying.
    for ( i = 0; i < C_LATENCY ; i = i + 1)
    begin
      rdyDelay[i] = 1'b0;
      doutDelay[i] = {result_width{1'b0}};
    end

    internalRFD = 1'b0; //1'b1
    internalRDY = 1'b0;
    RDY = 1'b0;
    RFD = 1'b0;  //1'b1
    DOUT = {result_width{1'b0}};

    //initializing a few flags
    read1_done  = 0;
    read2_done  = 0;
    result_done = 0;
    first_set = 1;

    // calculating the coefs values
    for (k = 0 ; k < C_POINTS;k= k+1)
    begin
      for ( i = 0; i < C_POINTS; i = i +1)
        begin
         angle = (($itor(i) + (1.0/2.0)) / $itor(C_POINTS)) * c_pi *$itor(k);
         theta_in_bits = $realtobits(angle);
        cosine_value = $bitstoreal(cos(theta_in_bits));
         dct_idct_coeff = $itor(scale) * (1/sqrt_c_points)* cosine_value * ( k == 0 ? 1 : sqrt_2);

        // adjusting for ROUNDING off the coefficients
        if(dct_idct_coeff >= 0) 
          dct_idct_coeff = dct_idct_coeff + 0.5;
        else 
          dct_idct_coeff = dct_idct_coeff - 0.5;

         int_dct_idct_coeff[k * C_POINTS + i] = $rtoi(dct_idct_coeff);
        //dct_coeff[k * C_POINTS + i] = trim_coeff(int_dct_idct_coeff[k * C_POINTS + i]);
        dct_coeff[k * C_POINTS + i] = int_dct_idct_coeff[k * C_POINTS + i];
        //trim_coeff($rtoi(dct_idct_coeff));
        //idct_coeff[i * C_POINTS + k] = trim_coeff(int_dct_idct_coeff[k * C_POINTS + i]);
        idct_coeff[i * C_POINTS + k] = int_dct_idct_coeff[k * C_POINTS + i]; 
        //trim_coeff($rtoi(dct_idct_coeff));
       end
    end

  end //initial

  always @(posedge CLK )
  begin
    if((C_HAS_RESET == `true) && (RST == 1'b1))
    begin
      load_counter = 0;

      for ( i = 0 ; i < C_POINTS ; i= i+ 1)
      begin
        dout_tmp[i] = {full_precision_width{1'b0}};
        data[i] = {data_width{1'b0}};
        data_2[i] = {data_width{1'b0}};
        dout_reg[i] = {result_width{1'b0}};
      end
  
      // initializing a few arrays used for appropriate delaying.
      for ( i = 0; i < C_LATENCY ; i = i + 1)
      begin
        rdyDelay[i] = 1'b0;
        doutDelay[i] = {result_width{1'b0}};
      end
  
      internalRFD = 1'b0;
      internalRDY = 1'b0;
      RDY = 1'b0;
      RFD = 1'b0;
      DOUT = {result_width{1'b0}};
  
      //initializing a few flags
      read1_done  = 0;
      read2_done  = 0;
      result_done = 0;
      first_set = 1;
      result_counter = 0;

    end

    else  //else no RST found
    begin
      if((ND == 1'b1) && (RFD == 1'b1))
      begin
        
        if(read1_done == 0) // accept new data if old data already
                           // moved to the 2nd register bank
        begin
          data[load_counter] = input_conditioning(DIN,C_DATA_TYPE);
          
          // NOTE: load_counter on the timing diagram would
          // show that it increments one clock earlier, but
          // the sequence of statements here in the code
          // ensures that there is no incorrect assignment to
          // the data register.

          load_counter  = load_counter + 1;
          if(load_counter == C_POINTS)
          begin
            read1_done = 1;
            load_counter = 0;
          end
        end
      end

      // Here the transfer to the 2nd set of input registers
      // occurs. By using non-blocking assignment here, the
      // transfer would actually have any significance on the 
      // result calculation in the next clock cycle.

      if ((read1_done == 1) && ((result_done == 1) || (first_set == 1)))
      begin
        for(i=0;i<C_POINTS;i=i+1)
        begin
          data_2[i] = data[i];
        end
        first_set <= 0; //1st set complete
        read2_done = 1;
        result_done <= 0; 
      end
      else if((read1_done == 0) && (result_done == 1))
      begin
        read2_done = 0;
      end

      if((read2_done == 1) && (read1_done == 1))
      begin
          
        /************************************************************
         * Start of block to compute the results
         ************************************************************/
        for(index1 = 0; index1 < C_POINTS ; index1 = index1 + 1)
        begin
          sum = {full_precision_width {1'b0}};
          for(index2 = 0; index2 < C_POINTS ; index2 = index2 + 1)
          begin
            if(internalIDCT == 0)
              partial_product =  signed_mult(data_2[index2], dct_coeff[index1*C_POINTS + index2]);
            else
              partial_product =  signed_mult(data_2[index2], idct_coeff[index1*C_POINTS + index2]);

            sum = sum + partial_product;
          end
          dout_tmp[index1] = sum;
        end 

        for ( i = 0; i < C_POINTS ; i = i + 1)
        begin
          dout_reg[i] = trim_result(dout_tmp[i]);
        end
      /************************************************************
       * End of block : results computed
       ************************************************************/
  
      end

      if ((read1_done == 1) && ((result_done == 1) || (first_set == 1)))
      begin
        read1_done = 0; // so new input can be taken in
                         // in 'data' register from next clk
      end

      /***********************************************************
       * Start of block for RFD generation
       **********************************************************/

      if((first_set == 1) || (C_POINTS == NUMBER_CLOCKS) || (data_width < C_POINTS))
        internalRFD = 1;
      else //if(read2_done == 1)
      begin
        if(read1_done == 0)
          internalRFD = 1;
        else
          internalRFD = 0;
      end
      RFD = internalRFD;
      /***********************************************************
       * End of block for RFD generation
       **********************************************************/

      // Generate the output DOUT and RDY
      DOUT <= doutDelay[C_LATENCY - 2]; // -1
      RDY <= rdyDelay[C_LATENCY - 2 ];  //-1
      for ( i = 1; i < C_LATENCY - 1 ; i = i + 1) //-0
      begin
        rdyDelay[i] <= rdyDelay[i-1];
        doutDelay[i] <= doutDelay[i-1];
      end

      /**********************************************************
       * Start of block to pipeline the result to the DOUT port
       ************************************************************/
      if (read2_done == 1) //((result_done != 1) && (read2_done == 1))
      begin
        result_counter = result_counter + 1;

        if(result_counter >= C_POINTS )  //==
        begin
          if(result_counter == C_POINTS)
            internalRDY = 1'b1;
          else
            internalRDY = 1'b0;
          rdyDelay[0] <= internalRDY;


          if(result_counter == NUMBER_CLOCKS )
          begin
            result_done = 1;
            result_counter = 0;
          end
          doutDelay[0] <= dout_reg[C_POINTS - 1];
        end
        else
        begin
          doutDelay[0] <= dout_reg[result_counter - 1];
          internalRDY = 1'b1;
          rdyDelay[0] <= internalRDY;
        end
      end
      else
      begin
        internalRDY = 1'b0;
        rdyDelay[0] <= internalRDY;
        result_counter = 0;
      end

      /**********************************************************
       * End of block to pipeline the result to the DOUT port
       ************************************************************/

    end //!rst
  end//always



   // synopsys_translate_on 

   // synthesis attribute GENERATOR_DEFAULT of C_DA_1D_DCT_V2_1 is "generatecore com.xilinx.ip.da_1d_dct_v2_1.c_da_1d_dct_v2_1" 
   // The follwing are required by XST 
   // box_type "black_box"  
   // synthesis attribute box_type of C_DA_1D_DCT_V2_1 is "black_box" 

endmodule
