// Author - Xilinx
// Creation - 1st Dec 2001
//
// Description 
//         
// Behavioural model for cic_v3_0
// Verilog Model
`timescale 1ns/10ps 

`define C_INTERPOLATING_FILTER 1
`define C_DECIMATING_FILTER 2
`define PROGRAMMABLE 1
`define FIXED 2

module C_CIC_V3_0
    (
       DIN,
       ND,
       CLK,
       RFD,
       RDY,
       LD_DIN,  // only used when the filter has a programmable rate change
       WE,    // only used when the filter has a programmable rate change
       DOUT
    );

    // NOTE: These parameters MUST be declared in alphabetical order
    parameter C_DATA_WIDTH             = 16;
    parameter C_DIFFERENTIAL_DELAY     = 1;
    parameter C_ENABLE_RLOCS           = 0;
    parameter C_FILTER_TYPE           = `C_INTERPOLATING_FILTER;
//  parameter C_INPUT_SAMPLE_RATE    = 1.0;  // not used in model
    parameter C_LATENCY          = 1; 
    parameter C_NUMBER_CHANNELS         = 1;
    parameter C_RESULT_WIDTH           = 22;
    parameter C_SAMPLE_RATE_CHANGE     = 4;
    parameter C_SAMPLE_RATE_CHANGE_MAX  = 64;
    parameter C_SAMPLE_RATE_CHANGE_MIN  = 4;
    parameter C_SAMPLE_RATE_CHANGE_TYPE = `FIXED;  // 1- programmable, 2- fixed
    parameter C_STAGES                 = 1;  
//  parameter C_SYSTEM_CLK           = 1.0;  // not used in model
  
// constants
    parameter INTEG_STAGE_DEPTH      = ( C_NUMBER_CHANNELS * C_STAGES );
    parameter COMB_STAGE_DEPTH      = ( C_NUMBER_CHANNELS * C_STAGES * C_DIFFERENTIAL_DELAY );
    parameter load_din_width       = //(( C_SAMPLE_RATE_CHANGE_TYPE == `FIXED) ? 1 :
                                     (( C_SAMPLE_RATE_CHANGE_MAX <= 3 ) ?  2 :
                                     (( C_SAMPLE_RATE_CHANGE_MAX <= 7 ) ?  3 :
                                     (( C_SAMPLE_RATE_CHANGE_MAX <= 15 ) ?  4 :
                                     (( C_SAMPLE_RATE_CHANGE_MAX <= 31 ) ?  5 :
                                     (( C_SAMPLE_RATE_CHANGE_MAX <= 63 ) ?  6 :
                                     (( C_SAMPLE_RATE_CHANGE_MAX <= 127 ) ?  7 :
                                     (( C_SAMPLE_RATE_CHANGE_MAX <= 255 ) ?  8 :
                                     (( C_SAMPLE_RATE_CHANGE_MAX <= 511 ) ?  9 :
                                     (( C_SAMPLE_RATE_CHANGE_MAX <= 1023 ) ?  10 :
                                     (( C_SAMPLE_RATE_CHANGE_MAX <= 2047 ) ?  11 :
                                     (( C_SAMPLE_RATE_CHANGE_MAX <= 4095 ) ?  12 :
                                     (( C_SAMPLE_RATE_CHANGE_MAX <= 8191 ) ?  13 :
                                     (( C_SAMPLE_RATE_CHANGE_MAX <= 16383 ) ? 14 :
                                     15)))))))))))));

// input/output ports
    input [C_DATA_WIDTH-1:0] DIN;
    input  ND;
    input  CLK;
    input  [ (load_din_width - 1):0]  LD_DIN;
    input  WE;
    output RFD;
    output RDY;
    output [C_RESULT_WIDTH-1:0] DOUT;
    reg    RFD;
    reg    RDY;
    reg    [C_RESULT_WIDTH-1:0] DOUT;

    reg    [C_RESULT_WIDTH-1:0] extdata;
    reg                         comb_rdy;
    reg    [C_RESULT_WIDTH-1:0] comb_dout;
    reg                         integ_rdy;
    reg    [C_RESULT_WIDTH-1:0] integ_dout;
    reg                         sampler_rdy;
    reg    [C_RESULT_WIDTH-1:0] sampler_dout;
  
// output delay register
    reg [C_RESULT_WIDTH-1:0] register_dout [(C_NUMBER_CHANNELS * C_LATENCY):1];
  
// declare an array of registers to hold all of the stages and channels results
    reg [C_RESULT_WIDTH-1:0] result [0:(INTEG_STAGE_DEPTH - 1)]; 
// variables to store each stages and channel for comb section
    reg [C_RESULT_WIDTH-1:0]  data [(COMB_STAGE_DEPTH - 1):0];
    reg [C_RESULT_WIDTH-1:0]  results [((C_STAGES * C_NUMBER_CHANNELS) - 1):0];
    reg [C_RESULT_WIDTH-1:0]  tempResult;
    reg [C_RESULT_WIDTH-1:0]  delay_comb_dout;
  
//  integer result [0:(INTEG_STAGE_DEPTH - 1)]; 
  
// track channel
    integer  channel;
    integer  delay_dout_pointer;
  
// initialization state variable
    reg                      init;

// variables to keep track of turning ON/OFF RFD signal
    integer count_rfd;
    integer i; 
    integer test_din_width;

// variable for reloadable sample rate change  
    reg [(load_din_width - 1) : 0] loadDinHoldReg;
    reg [(load_din_width - 1) : 0] loadDinReg;

/*-------------------------------------------------------------------------
  Initialize all variables
  -------------------------------------------------------------------------  */
    initial
    begin
      extdata = 0; 

    // inter-task communications variables
      comb_rdy     = 0;
      comb_dout   = 0;
      integ_rdy    = 0;
      integ_dout   = 0;
      sampler_rdy   = 0;
      sampler_dout   = 0; 
    
      for ( i = 1; i <= (C_NUMBER_CHANNELS * C_LATENCY); i = i + 1 ) register_dout[i] = { C_RESULT_WIDTH { 1'b0 } };
      delay_dout_pointer = 0;
    
    // clear the RFD counter and channel indicator
      count_rfd = 0;                
      channel = 1;
    
    // for the reloadable sample rate change
       loadDinHoldReg = C_SAMPLE_RATE_CHANGE;
       loadDinReg = C_SAMPLE_RATE_CHANGE;

    // call each task with the init = 1 -- taskes initialize internal variables
      init = 1;
      integrate(init, 1'b0, channel, extdata, integ_rdy, integ_dout);
      downsample(init, 1'b0, channel, extdata, sampler_rdy, sampler_dout);
      upsample(init, 1'b0, extdata, channel, sampler_rdy, sampler_dout);
      comb(init, 1'b0, channel, extdata, comb_rdy, comb_dout);
      init = 0; 

    // initialize the output Ports
      RFD <= 1'b1;
      RDY <= 1'b0;
      DOUT <= 0;
    end  // initial
  
/*------------------------------------------------------------------------------------------
  Main ALWAYS loop
  ------------------------------------------------------------------------------------------  */
    always @(posedge CLK)
    begin 

      if (C_FILTER_TYPE == `C_DECIMATING_FILTER)
        begin
          if((C_SAMPLE_RATE_CHANGE_TYPE == `PROGRAMMABLE) && (WE == 1'b1))
            begin
              loadDinHoldReg <= LD_DIN;
            end
      //    if(sampler_rdy == 1'b1)
      //      begin
      //        loadDinReg <= loadDinHoldReg;
      //      end
        end

    // IF ND is asserted then read the data in off the DIN Port and start the processing
      if (ND === 1'b1)
        begin   
      // IF RFD is NOT asserted then this is a WARNING case -- ignore the input
          if (RFD == 1'b0)
            begin
              $display ("WARNING in %m at time %dns: ND asserted when RFD is low -- input ignored.", $time);
            end
          else 
            // ND and RFD are asserted READ the data and handle the RFD signal
            begin  
              // read in the data off the input Port and sign extend to internal processing width
              extdata = {{C_RESULT_WIDTH-C_DATA_WIDTH{DIN[C_DATA_WIDTH-1]}}, DIN};  // sign extend DIN 
          
              if (C_FILTER_TYPE == `C_DECIMATING_FILTER)
                begin

                  integrate(init, ND, channel, extdata, integ_rdy, integ_dout);
                  downsample(init, ND, channel, integ_dout, sampler_rdy, sampler_dout);
                  comb(init, sampler_rdy, channel, sampler_dout, comb_rdy, comb_dout);  
                  
                  // set the output Port values
                  RDY <= comb_rdy;
                  if ( comb_rdy == 1'b1)
                    begin 
                      
                      // move the last value in the latency buffer to the DOUT Port
                      // then move all of the latency values down
                      delay_dout_pointer = (channel * C_LATENCY);
                      DOUT <= register_dout[delay_dout_pointer];  
                      for ( i = (C_LATENCY -1); i >= 0; i = i - 1)
                        begin
                          if ( i == 0 ) register_dout[delay_dout_pointer] <= comb_dout;
                          else  register_dout[delay_dout_pointer] <= register_dout[delay_dout_pointer - 1];
       
                          delay_dout_pointer = delay_dout_pointer - 1;
                        end                    
                    end
                    
                  // adjust the channel indicator
                  channel = channel + 1;
                  if ( channel > C_NUMBER_CHANNELS ) channel = 1;
                end
              else
                begin // is an interpoaltion filter then RFD is set NOT asserted
                  RFD <= 1'b0;
                      count_rfd = C_SAMPLE_RATE_CHANGE;
                end
              
          end   // check for RFD asserted
        end 

      if (C_FILTER_TYPE == `C_INTERPOLATING_FILTER) // INTERPOLATION FILTER
        begin                 
          // process the data
            comb(init, ND, channel, extdata, comb_rdy, comb_dout); 
       
          // The COMB filter has an additional register(s) delay befor going into the integrator section
          if ( comb_rdy == 1'b1 )
            begin
              // Move the DOUT data throught the latency buffer
              delay_dout_pointer = (channel * C_LATENCY);
              delay_comb_dout = register_dout[delay_dout_pointer];
              RDY  <= 1'b1;
              for ( i = (C_LATENCY -1); i >= 0; i = i - 1)
                begin
                  if ( i == 0 ) register_dout[delay_dout_pointer] <= comb_dout;
                  else  register_dout[delay_dout_pointer] <= register_dout[delay_dout_pointer - 1];
                  delay_dout_pointer = delay_dout_pointer - 1;
                end  
            end
       
          upsample(init, comb_rdy, channel, delay_comb_dout, sampler_rdy, sampler_dout);
          integrate(init, sampler_rdy, channel, sampler_dout, integ_rdy, integ_dout);
       
          // if ND and RFD are asserted then an input sample has been inserted and need to adjust the 
          // channel indicator 
          if (ND === 1'b1) 
            begin
              if (RFD == 1'b0)
                begin
                // adjust the channel indicator
                  channel = channel + 1;
                  if ( channel > C_NUMBER_CHANNELS ) channel = 1;
                end  
            end  
          
          // adjust the count on the RFD counter and then assert RFD if reached 0  
          if ( integ_rdy == 1'b1 )
            begin
              // move the last value in the latency buffer to the DOUT Port
              // then move all of the latency values down
              count_rfd = count_rfd - 1;
              if (count_rfd == 0)
                 RFD <= 1'b1;
              else
                RFD <= 1'b0;
              
              if ( integ_rdy == 1'b1) DOUT <= integ_dout;  
            end
          else
            begin
              RDY <= 1'b0;
            end
        end // check for interpolating filter
    else
      begin // must be a decimating filter and the RDY signal must be turned off
        if (ND === 1'b0) RDY <= 1'b0;
      end 
    end // always
  
/*---------------------------------------------------------------------------
  Integrator Section Task
  --------------------------------------------------------------------------  */
  task integrate;
    input                       init;
    input                       nd;
    input [31:0]                channel;
    input [C_RESULT_WIDTH-1:0]  data_in;
    output                      rdy;
    output [C_RESULT_WIDTH-1:0] data_out; 
  
    integer    result_pointer;

    begin 
    // initialize the results storage
      if (init == 1'b1)
        begin
          for (i=0; i < INTEG_STAGE_DEPTH; i=i+1)
            result[i] = 0;
            data_out = 0;
            rdy = 0;
        end 
      else  if (nd === 1'b1)
        begin 
        // has ND asserted -- process the incoming data
        // calculate the last stages array pointer index
          result_pointer = (channel * C_STAGES) - 1;    
      
        // set the DATA OUTPUT to the PRESENT value in the output register of the last stage of integrator
          data_out = result[result_pointer];
      
        // loop through each stage and calculate the new integrator result for that stage
          for ( i = (C_STAGES - 1); i >= 0; i = i-1)
            begin
              if ( i > 0 ) 
                result[result_pointer] = result[result_pointer] + result[result_pointer - 1];
              else
                begin 
                  result[result_pointer] = result[result_pointer] + data_in;
                end

            // decrement the pointer into the results array to point at the previous stage
              result_pointer = result_pointer - 1;
            end
      
          rdy = 1'b1;
        end
    else  // integrator ND signal is not asserted insure that the integ_rdy signal is off
      begin
        rdy = 1'b0;
      end
  end
  endtask 

  /* --------------------------------------------------------------------------
    COMB Section Task
     --------------------------------------------------------------------------  */

    // comb
  task comb;
    input                       init;
    input                       nd;
    input [31:0]                channel;
    input [C_RESULT_WIDTH-1:0]  data_in;
    output                      rdy;
    output [C_RESULT_WIDTH-1:0] data_out; 


    integer            result_pointer;
    integer            data_pointer; 
 
    integer    stageIndex;
    integer    diffDelayIndex;
    integer    channelIndex;

    begin
    // IF in initialization mode then clear the internal results storage
      if (init == 1'b1)
        begin  
          // clear the results array
          for (i=0; i < ( C_NUMBER_CHANNELS * C_STAGES ); i=i+1)
          begin
            results[i] = 0;
          end  

          // clear the data storage array
          for (i=0; i <= COMB_STAGE_DEPTH; i=i+1)
          begin
            data[i] = 0;
          end
      
          // clear the DOUT to start
          data_out = 0;
          rdy     = 0;
          tempResult = 0;
        end
      else 
      // process the input data
        begin  
          rdy = nd;
          if ((nd == 1'b1) && (RFD == 1'b1))  
            begin
            // determine the starting point for the results data storage array
            result_pointer = ((channel * C_STAGES) - 1);
            // determine the starting point in the differential data storage array
            data_pointer = ((channel * C_STAGES * C_DIFFERENTIAL_DELAY) - 1); 
         
            // loop through each stage and calculate the next stage values
            for ( stageIndex = (C_STAGES - 1); stageIndex >= 0; stageIndex = stageIndex - 1 )
              begin
            
                // calculate this stages next result -- use the previous stages output result and
                // subtract this sections data storage value. IF this is the first stage then the 
                // "previous stage" is the input data
                if ( stageIndex > 0 ) tempResult = results[ result_pointer - 1 ] - data[data_pointer];
                else  tempResult = data_in  - data[data_pointer]; 
                  
                // set the output to the last stages output result
                if (stageIndex == (C_STAGES - 1))  data_out = tempResult;
            
                // loop though and update the data storage values and results
                // move the information through each of the individual storages
                // adjust this stages data storage
                for ( diffDelayIndex = (C_DIFFERENTIAL_DELAY - 1); diffDelayIndex >= 0; diffDelayIndex = diffDelayIndex - 1)
                  begin
                    if ( diffDelayIndex == 0 ) 
                      begin 
                      // the first location in the DATA storage takes the previous stages result or
                      // IF it's the first stage then the input data
                        if ( stageIndex > 0 ) data[ data_pointer ] =  results[ result_pointer - 1 ];
                        else  data[ data_pointer ] =  data_in; // first stage, use data_in  
                      end
                    else 
                      // not the first differential data location move the data down 
                      begin 
                        data[ data_pointer ] = data[ data_pointer - 1 ];
                      end
            
                    // adjust the data_pointer and result_pointer to next stages data locations
                    data_pointer = data_pointer - 1;
                  end
  
                // move the results delay buffer through . The results buffers are set to a depth of the channel.
                results[result_pointer] = tempResult;
  
                // adjust the result_pointer
                result_pointer = result_pointer - 1;
              end // for loop -- stageIndex
            end
        end      // check for if nd is asserted
    end
  endtask // comb
    

/*--------------------------------------------------------------------------------
  Downsample task
  --------------------------------------------------------------------------------  */
  task downsample;
    input                       init;
    input                       nd;
    input [31:0]                channel;
    input [C_RESULT_WIDTH-1:0]  data_in;
    output                      rdy;
    output [C_RESULT_WIDTH-1:0] data_out; 

    integer count[C_NUMBER_CHANNELS : 1];

    begin
      if (init == 1'b1) 
        begin
          for ( i = 1; i <= C_NUMBER_CHANNELS; i = i + 1) count[i] = loadDinReg - 1;
          data_out = 0;
          rdy = 0;
        end
      else
        begin
         if (nd == 1'b1)
            begin
              //if (count[channel] == 0)
              if (count[channel] == loadDinReg - 1)
                begin
                  data_out = data_in;
                  rdy = 1'b1;
                  //count[channel] = C_SAMPLE_RATE_CHANGE - 1;
                  //count[channel] <= loadDinHoldReg - 1;
                  count[channel] = 0;
									if(channel == C_NUMBER_CHANNELS)
                    loadDinReg = loadDinHoldReg;
                end
              else
                begin
                  //count[channel] = count[channel] - 1;
                  count[channel] = count[channel] + 1;
                  rdy = 1'b0;
                end
            end
          else
            rdy = 1'b0;
        end 
    end
  endtask // downsample          
  
/*  ------------------------------------------------------------------------------------
  Upsample Task
  ------------------------------------------------------------------------------------  */
  task upsample; 
    input                       init;
    input                       nd;
    input [31:0]                channel;
    input [C_RESULT_WIDTH-1:0]  data_in;
    output                      rdy;
    output [C_RESULT_WIDTH-1:0] data_out; 

    integer count;

    begin
      if (init == 1'b1) 
        begin
          count = 0;
          data_out = 0;
          rdy = 0;
        end
      else
        begin
      // IF the ND signal is asserted then place the input data on the output of the up-sampler
          if ((nd == 1'b1) && (RFD == 1'b1))
            begin
              data_out = data_in;
              rdy = 1'b1;
              count = C_SAMPLE_RATE_CHANGE - 1;
            end         
      // IF the count hasn't reached 0 then need to insert more 0's into the next stage
          else if (count > 0)
            begin 
              if ( count == 1 ) RFD <= 1'b1;
              
              count = count - 1;
              rdy = 1'b1;
              data_out = { C_RESULT_WIDTH{1'b0 }};
            end
          // Don't need to insert 0's or data -- turn off the RDY signal
          else
            begin
              rdy = 1'b0;
            end
        end
    end
  endtask // upsample
endmodule          
