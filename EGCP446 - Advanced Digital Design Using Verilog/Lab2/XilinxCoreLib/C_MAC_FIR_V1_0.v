/***************************************
-- Author - Steve Zack
-- Creation - 11th June 01												
--
-- Description:
--         
-- Template of Verilog behavioural model for mac_fir_v1_0 
--
***************************************/

// !!! undef at the end if we add to this

`define c_signed 		0
`define c_unsigned 	1
`define c_antipodal 2

`define c_symmetric 		0
`define c_non_symmetric 1
`define c_neg_symmetric 2

`define c_single_rate 		  			0
`define c_polyphase_interpolating 1
`define c_polyphase_decimating	  2
`define c_hilbert_transform		  	3
`define c_interpolated 		  			4
`define c_half_band 			  			5
`define c_decimating_half_band 	  6
`define c_interpolating_half_band 7

`define c_no_reload 0
`define c_static 		1	  

`define c_sel_input_port_is_output	0
`define c_sel_input_port_is_input		1

`define c_data_buffer_type 6			// Block Dual Port RAM	   
`define c_coef_buffer_type 6			// Block Dual Port RAM	 
	
`define MAX_NUMBER_SAMPLES 9			// Maximum number of samples that can be stored in the input buffer FIFO
																	//	before the input buffer full flag goes active.  The buffer is actually
																	//	16 samples deep - this leaves overhead for any delays from when RFD
																	//	is disabled before the source stops sending data.	 	 
																	
`define MAC_RDY_TO_RFD_DELAY 1									// Number of clocks after RDY that RFD can go active if the buffer is not full 
	
`define all1s {C_RESULT_WIDTH{1'b1}}
`define all0s {C_RESULT_WIDTH{1'b0}}
`define allXs {C_RESULT_WIDTH{1'bx}}

`define TRUE	1
`define FALSE	0 

`define MAC_FIR_COMPUTE_LATENCY					9		// Processing delay through MAC FIR 
`define MAC_FIR_XTRA_SYMMETRIC_LATENCY	1

`timescale 1ns / 10ps	 

//**********************************************************
// This line is used in the ActiveHDL testbench
// module Verilog_Model	 
	
// This line is used in the SVG testbench 
module C_MAC_FIR_V1_0
//**********************************************************
	
    ( RESET,
	  	ND, 
	  	DIN,  
      CLK, 
      DOUT,
      DOUT_I, DOUT_Q,
      RFD, RDY, 
      COEF_LD,
      LD_DIN,
      LD_WE,
	  	SEL_I, SEL_O
	);
 	
	
	// NOTE: These parameters MUST be in ALPHABETICAL order
	parameter C_CHANNELS           = 1;	      
	parameter C_COEF_BUFFER_TYPE   = `c_coef_buffer_type;
	parameter C_COEF_INIT_FILE     = "netlist.mif";			 	 
	parameter C_COEF_TYPE          = `c_signed;
	parameter C_COEF_WIDTH         = 16;	  
	parameter C_DATA_BUFFER_TYPE   = `c_data_buffer_type;
	parameter C_DATA_TYPE          = `c_signed;
	parameter C_DATA_WIDTH         = 16;
	parameter C_DECIMATE_FACTOR    = 1;
  parameter C_ENABLE_RLOCS       = `FALSE;
	parameter C_FILTER_TYPE        = `c_single_rate; 	
	parameter C_INPUT_SAMPLE_RATE  = 1.0;						 	 						// Clock frequency in Mhz
	parameter C_INTERPOLATE_FACTOR = 1;	
	parameter C_LATENCY            = 24;  
	parameter C_NUM_COEF_SETS	   	 = 1;
	parameter C_REG_OUTPUT         = `TRUE;
	parameter C_RELOAD             = `c_no_reload; 
	parameter C_RELOAD_DELAY       = 1;
	parameter C_RESPONSE           = `c_non_symmetric;			
	parameter C_RESULT_WIDTH       = 36; 						 
	parameter C_SEL_I_DIR	      	 = `c_sel_input_port_is_input;	 	// When = 1, the SEL_I port is an input
  parameter C_SHAPE              = 0;
	parameter C_SYSTEM_CLOCK_RATE  = 100.0;						 							// Clock frequency in Mhz
	parameter C_TAPS               = 12;		   				 
	parameter C_USE_MODEL_FUNC     = `FALSE; 												// if 1 then use latency function, otherwise use C_LATENCY
	parameter C_ZPF                = 1;
 
	// Setup SEL_I port direction 
	`ifdef C_SEL_I_DIR 			
		parameter c_sel_input_direction_is_input  = 1;
	`else
		parameter c_sel_input_direction_is_input  = 0;
	`endif	
	
	// bits need to represent channel   
	parameter CHANNEL_WIDTH = ( (C_CHANNELS <= 2) ? 1 :
	                            	((C_CHANNELS <= 4) ? 2 : 
	                            		((C_CHANNELS <= 8) ? 3 : 4 ) ) ); 
	  
	// Interpolated filter: number of taps including zero packing factor
	parameter ZPF_TAPS = C_TAPS * C_ZPF; 
	
	// Number of computations that can be performed between input samples
	parameter CLOCKS_PER_SAMPLE = C_SYSTEM_CLOCK_RATE / C_INPUT_SAMPLE_RATE;	
	
	
	// Compute latency through MAC FIR (delay from ND being asserted to RDY being asserted)  
	parameter DECIMATING_FILTER    = (C_FILTER_TYPE == `c_polyphase_decimating || C_FILTER_TYPE == `c_decimating_half_band);
	parameter INTERPOLATING_FILTER = (C_FILTER_TYPE == `c_polyphase_interpolating || C_FILTER_TYPE == `c_interpolating_half_band);
	parameter MULT_PER_INTERP_SUBFILTER = ((C_TAPS % C_INTERPOLATE_FACTOR) == 0) ?
																						(C_TAPS / C_INTERPOLATE_FACTOR) :	 		// Number of taps is an integer multiple of interpolate factor 
											  										((C_TAPS / C_INTERPOLATE_FACTOR) + 1);		// Number of taps is NOT an integer multiple of interpolate factor 

	parameter NUMBER_TAPS_DIV_BY_2 = ((C_TAPS % 2) == 0) ?
										  								(C_TAPS / 2) : 		// Even number of taps 
										  								((C_TAPS / 2) + 1);	// Odd number of taps  												  
	
	// Maximum number of results that may need to be saved until they can be output on DOUT 
	parameter DEFAULT_DATA_BACKUP  = 1;
	parameter BACK_DATA = (C_USE_MODEL_FUNC) ? DEFAULT_DATA_BACKUP :
											  	  (DECIMATING_FILTER)     ? 2 * (C_LATENCY + 1) * C_DECIMATE_FACTOR :
											  		  (INTERPOLATING_FILTER)  ? 2 * (C_LATENCY + 1) * C_INTERPOLATE_FACTOR :
													  						    2 * (C_LATENCY + 1);
	
	// Number of coefs that must be provided during reloading
	parameter NUM_RELOAD_COEFS = (C_RESPONSE == `c_non_symmetric) ? (C_TAPS) : (C_TAPS + 1) / 2;	 
	
	// Input Ports
	input RESET;
	input ND;      
	input [C_DATA_WIDTH - 1 : 0] DIN;
	input CLK;   
	input COEF_LD;      
	input [C_COEF_WIDTH - 1 : 0] LD_DIN;
	input LD_WE;  	
	
	// Output Ports
	output [C_RESULT_WIDTH - 1 :0] DOUT;    
	output [C_DATA_WIDTH - 1 : 0] DOUT_I;    
	output [C_RESULT_WIDTH - 1 : 0] DOUT_Q;    
	output RDY;    
	output RFD;    
	output [CHANNEL_WIDTH - 1 : 0] SEL_O; 	
	
	// Select port can be an input OR an output, but it is NOT bidirectional 
	`ifdef C_SEL_I_DIR
		input [CHANNEL_WIDTH - 1 : 0] SEL_I;
	`else
		output [CHANNEL_WIDTH - 1 : 0] SEL_I; 		
	`endif
	

	// coefficients intialized from memory file or coefficient input
	reg [C_COEF_WIDTH - 1 : 0] coef_data [0 : C_TAPS - 1];
	reg [C_COEF_WIDTH - 1 : 0] tmp_coef_data;
	reg [C_COEF_WIDTH - 1 : 0] coef_data_abs_value [0 : C_TAPS - 1]; 	 // absolute value of coefficients
	reg coef_sign [0 : C_TAPS - 1];                     	 			 // coefficient sign
	
	// temp variable for incoming data
	reg [C_DATA_WIDTH - 1 : 0] tmp_x_data;  
	
	// integer array of filter data
	reg [C_DATA_WIDTH - 1 : 0]  sample_data_abs_value [0 : C_CHANNELS * C_TAPS - 1]; 		// absolute value of sample data
	reg data_sign [0 : C_CHANNELS * C_TAPS - 1];  											// sample data sign
	reg [C_DATA_WIDTH - 1 : 0]  zpf_sample_data_abs_value [0 : C_CHANNELS * ZPF_TAPS - 1]; 	// absolute value of interpolated filter data (with zeros inserted)
	reg  zpf_data_sign [0 : C_CHANNELS * ZPF_TAPS - 1]; 									// sample data sign for interpolated filters
	
	reg [C_RESULT_WIDTH - 1 :0] tmpDOUT [0 : BACK_DATA - 1];	 
	
	// variable to hold the I component of the Hilbert output
	reg [C_DATA_WIDTH - 1 : 0] hilbert_i_out[0 : BACK_DATA - 1];	   
	
	// Output regs
	reg [C_RESULT_WIDTH - 1 :0] DOUT;
	reg [C_DATA_WIDTH - 1 :0] DOUT_I;
	reg [C_RESULT_WIDTH - 1 :0] DOUT_Q;
	reg RFD;
	reg RDY;
	reg [CHANNEL_WIDTH - 1 : 0]SEL_O;
	reg prevRDY;   	   	
	
	`ifdef C_SEL_I_DIR
	`else
		reg [CHANNEL_WIDTH - 1 : 0]SEL_I;	// Only used if the SEL_I port is an output	  
	`endif

	
	// Define variables   
	integer i, j;
	integer c_taps_2;
	integer count_rfd;
	integer sel_i, sel_o;   
	integer load_counter;   
	integer new_data;
	integer count_rdy[0 : BACK_DATA - 1];	// number of cycles before each saved result can be output, and RDY asserted	
	integer c_pipe_stages;
	integer do_compute_result;
	integer sub_filter_number;
	integer rfd_latency; 									// number of cycles after ND that RFD can be asserted again
	integer reloading;   									// true if the filter is in the process of reloading
	integer reloading_one_cycle; 					// true if it is one cycle since COEF_LD was asserted
	integer interp_mults_per_subfilter;		// Maximum number of multiplies needed to compute an output
																				//	on a single subfilter of a Polyphase Interpolator 
	integer num_samples_input_buffer;			// Number of samples in the input buffer.
	integer read_input_buffer_counter;		// Counts clocks before the input buffer is read from 	
	integer rdy_delay_counter;						// Counts clocks before RDY can be asserted again 	
	integer rdy_to_rfd_delay_counter;			// Counts clocks from RDY until RFD can be asserted again 
	integer rdy_to_rfd_delay_counter_enable;	
	integer input_buffer_just_went_not_full; 
	integer clocks_to_process_data;		
	integer sample_latency_counter;				// Counts clocks from first sample received until data can be output 
	integer max_periodic_input_rate;			// Maximum processing rate of filter.  For interpolating filters, if 
																				//	the number of taps is NOT evenly divisible by the interpolation factor,
																				//	than the filter has extra taps added (with coefficients equal to zero)
																				//	so that each subfilter performs the same number of multiplies per data
																				//	sample.  This has the effect of reducing the maximum periodic input 
																				//	rate that can be sustained without RFD being disabled.																				

	
	//---------------------------------------------------------
	// initialise
	//---------------------------------------------------------

   	initial
  	begin		
		if (C_USE_MODEL_FUNC == 1)
		begin
			$display("\n*** ERROR: This model has not been set up to compute latency.  Please call Xilinx Support.\n");
			$stop;
		end
		else
			c_pipe_stages = C_LATENCY;   
		 
		// coefficient checks
		if(C_FILTER_TYPE == `c_half_band || C_FILTER_TYPE == `c_hilbert_transform)
			if(C_TAPS % 4 != 3)
			begin
			    $display("\n ERROR: for Halfband & Hilbert Transform filters the number of taps must be 3,7,11,15,19,... ");
			    $display( " -- Number of taps is set to %d  \n Exiting simulation... \n", C_TAPS);
			    $stop;
			end
		
		// read coefficients from the MIF file
		$readmemh(C_COEF_INIT_FILE, coef_data);         
		c_taps_2 = C_TAPS/2;   
		
		// Allocate to absolute value array and set the sign of each coefficient. Convert NRZ coefficients to signed
		for (i = 0; i < C_TAPS; i = i + 1)
		begin
			tmp_coef_data = coef_data[i];
			// Check if coefficient is negative by checking if the MSbit is a one 
			if( C_COEF_TYPE == `c_signed && tmp_coef_data[C_COEF_WIDTH - 1] === 1'b1)
			begin
				coef_data_abs_value[i] = ~tmp_coef_data + 1;
				coef_sign[i] = 1;
			end 
			else if (C_COEF_TYPE == `c_antipodal)	
			// Check if data is +1 or -1
			begin
				if (tmp_coef_data[0] === 1'b0)
					coef_sign[i] = 0;
				else
					coef_sign[i] = 1;		 
					
				coef_data_abs_value[i] = 1'b1;
			end	  
			// Coefficient value is positive
			else  
			begin
			    coef_data_abs_value[i] = tmp_coef_data;
			    coef_sign[i] = 0;
			end
		end
		
		// Clear the outputs asynchronously 
		RFD = 0; 
		RDY = 0; 
		if (C_FILTER_TYPE != `c_hilbert_transform)
        DOUT = { C_RESULT_WIDTH{1'b0} };
    else
    begin         
     		DOUT_I = { C_DATA_WIDTH{1'b0} };
        DOUT_Q = { C_RESULT_WIDTH{1'b0} };
    end
		
		// Initialize Select ports if present 
		sel_i = 0;
		sel_o = 0;
		`ifdef C_SEL_I_DIR 
		`else
			SEL_I <= { CHANNEL_WIDTH{1'b0} };		
		`endif
		 
		if ( C_CHANNELS > 1 )
		begin
		    sel_o = 0;
		    SEL_O <= 1'b0;
		end	
		
		reloading = `FALSE;
		reloading_one_cycle = `FALSE;
		
		// Compute delay between successive outputs of a Polyphase Interpolator filter
	    if ( C_FILTER_TYPE == `c_polyphase_interpolating )
	    begin  
			// Check if number of taps is an integer multiple of the interpolate factor 
			if ( (C_TAPS % C_INTERPOLATE_FACTOR) != 0 )		 
				interp_mults_per_subfilter = (C_TAPS / C_INTERPOLATE_FACTOR) + 1;	// Not an integer multiple 
			else
				interp_mults_per_subfilter = (C_TAPS / C_INTERPOLATE_FACTOR);		// Is an integer multiple 
		end		
		 
		// do all initialization common to startup and to reloading
		do_initialize;	
		
   	end 		//initial  

	//---------------------------------------------------------
	// always on posedge of clock
	//---------------------------------------------------------
	
	always @(posedge CLK)
	begin
		// Initialize outputs during reset 
 		if (RESET == 1'b1)
		begin
			SEL_O <= 0;
			`ifdef C_SEL_I_DIR 
			`else
					SEL_I <= { CHANNEL_WIDTH{1'b0} };		
			`endif
		end
	
//*******************************************************************************************************	
//********************************* handle the loading of the coefficients ******************************
//*******************************************************************************************************	
		if (C_RELOAD == `c_static && COEF_LD === 1'b1 )
		begin
			if (reloading == `TRUE)
			begin
			    $display("%m, %dns ERROR: Reloading is already in progress.  Please assert COEF_LD only after the current reload has been completed", $time);
			    $stop;
			end
			
			reloading = `TRUE;	
			if(RDY === 1'b1)
			begin
			    if ( C_CHANNELS > 1 )
			    begin
				    sel_o = (sel_o >= C_CHANNELS - 1) ? 0 : sel_o + 1;
				    SEL_O <= sel_o;
			    end	  
			end	 
			
			// do all initialization common to startup and to reloading
			do_initialize;	 
			
			if (LD_WE === 1'b1)
			begin
			    $display("%m, %dns ERROR: LD_WE must only be asserted the cycle after COEF_LD is asserted.", $time);
			    $stop;
			end
			RFD = 0;
	    end 
		  
	    // SEL_I and SEL_O are reset to 0 one cycle after COEF_LD is asserted
		else if (reloading == `TRUE && reloading_one_cycle == `FALSE)
		begin
	        reloading_one_cycle = `TRUE;
	        sel_i = 0;
			`ifdef C_SEL_I_DIR 
			`else
				SEL_I <= { CHANNEL_WIDTH{1'b0} };		
			`endif
	         
	        if ( C_CHANNELS > 1 )
	        begin
	            sel_o = 0;
	            SEL_O <= 1'b0;
	        end	 
			
	    end         
	
		if (C_RELOAD == `c_static && LD_WE === 1'b1 )
		begin
	        if (reloading == `FALSE)
	        begin
	            $display("%m, %dns ERROR: LD_WE must only be asserted when the filter is in the process of reloading.  Please assert COEF_LD to start the reload process.", $time);
	            $stop;
	        end	
			
	        if (load_counter >= NUM_RELOAD_COEFS)
	        begin
	            $display("%m, %dns ERROR: The required number of coefficients have already been provided.", $time);
	            $stop;
	        end
	        tmp_coef_data = LD_DIN;
			
			// Save the absolute value of the coefficient as well as its sign
	        if( C_COEF_TYPE == `c_signed && tmp_coef_data[C_COEF_WIDTH - 1] === 1'b1)
	        begin
	            coef_data_abs_value[load_counter] = ~tmp_coef_data + 1;
	            coef_sign[load_counter] = 1;
	        end 
			// Convert NRZ coefficients to signed
	        else if (C_COEF_TYPE == `c_antipodal)
	        begin
	            if (tmp_coef_data[0] === 1'b0)
	            	coef_sign[load_counter] = 0;
	            else
	            	coef_sign[load_counter] = 1;   
					
	            coef_data_abs_value[load_counter] = 1'b1;
	        end	
			// Coefficient is positive
	        else
	        begin
	            coef_data_abs_value[load_counter] = tmp_coef_data;
	            coef_sign[load_counter] = 0;
	        end	
			
	    	// For symmetric or negative symmetric coefficients, update the coefficient 
	        // mirror posn, and update the sign accordingly
	        if ( C_RESPONSE == `c_symmetric )
	        begin
	            coef_data_abs_value[C_TAPS - load_counter - 1]  = coef_data_abs_value[load_counter];
	            coef_sign[C_TAPS - load_counter - 1] = coef_sign[load_counter];
	        end
	        else if (C_RESPONSE == `c_neg_symmetric && (C_TAPS % 2 == 0 || load_counter < (C_TAPS - 1)/2))
	        begin
	            coef_data_abs_value[C_TAPS - load_counter - 1]  = coef_data_abs_value[load_counter];
	            coef_sign[C_TAPS - load_counter - 1] = (coef_sign[load_counter] + 1) % 2;
	        end	
			
	        load_counter = load_counter + 1;
	    	// All coefficients have been supplied.  RFD will be asserted in C_RELOAD_DELAY cycles
	        if ((load_counter) >= NUM_RELOAD_COEFS )
	            count_rfd = C_RELOAD_DELAY; 
	    end		// end static reload 
	
		if (reloading == `TRUE)
		begin
		    if (count_rfd > 0)
		    begin
				count_rfd = count_rfd - 1;
				// Filter reloading has completed, and the filter is ready to assert RFD
				if (count_rfd == 0)
				begin
				    reloading = `FALSE;
				    reloading_one_cycle = `FALSE;
				end
		    end
		end	 
		
//*******************************************************************************************************	
//*************** If the filter is NOT in the process of having the coefficients reloaded ***************		
//*******************************************************************************************************	  
	
		else  	
		begin
			// Initialze outputs if RESET is active 
	 		if (RESET == 1'b1)
			begin
	      RDY <= 0;
				RFD <= 0;

				if (C_FILTER_TYPE != `c_hilbert_transform)
	          DOUT <= { C_RESULT_WIDTH{1'b0} };
	      else
	      begin         
	       		DOUT_I <= { C_DATA_WIDTH{1'b0} };
	          DOUT_Q <= { C_RESULT_WIDTH{1'b0} };
	      end
			end
			
			// When RESET is NOT active 
			else
			begin			
				// For all results waiting to be output, decrement the number of cycles before RDY should be asserted
				for(i = 0; i < new_data; i = i + 1)
				    count_rdy[i] = (count_rdy[i] < 1) ? 0 : count_rdy[i] - 1;
				
				// Decrement the number of cycles before RFD should be asserted
				count_rfd = (count_rfd < 1) ? 0 : count_rfd - 1;  
				
				// Decrement the number of cycles before RDY should be asserted
				rdy_delay_counter = (rdy_delay_counter < 1) ? 0 : rdy_delay_counter - 1;	

				// Decrement the counter which tracks the latency of how many clocks the latency should be for the 
				//	next incoming sample
				sample_latency_counter = (sample_latency_counter < 1) ? 0 : sample_latency_counter - 1;
				
				
				// Count the number of cycles before RFD should be asserted.  The counter is initialized to 
				//	MAC_RDY_TO_RFD_DELAY when RDY is asserted.
				if ( rdy_to_rfd_delay_counter_enable == `TRUE )
					if ( rdy_to_rfd_delay_counter == 0 )
						rdy_to_rfd_delay_counter_enable = `FALSE;
					else
						rdy_to_rfd_delay_counter = rdy_to_rfd_delay_counter - 1;					

				// NOT a decimating filter 
				// Check if the input buffer is full 
				if ( num_samples_input_buffer < `MAX_NUMBER_SAMPLES )		
					if ( rdy_to_rfd_delay_counter == 0 )
						RFD <= 1;
					else
						RFD <= 0;
				else
					RFD <= 0;
				
				// New data is available and the core is ready to accept the data
				if (ND === 1'b1 && RFD === 1'b1)
				begin
				    //rfd count increments         
				    if (C_FILTER_TYPE == `c_polyphase_decimating || C_FILTER_TYPE == `c_decimating_half_band) 		// decimating filter
				    begin
							sub_filter_number = (sub_filter_number == C_DECIMATE_FACTOR) ? 1 : sub_filter_number + 1;	
													
							// C_DECIMATE_FACTOR data samples have been received
							if (sub_filter_number == C_DECIMATE_FACTOR)  
							begin
						    if (count_rfd > 0) // the subfilter is not yet ready
						    begin
						        do_compute_result = `FALSE;
						        RFD <= 0;
						    end
						    else
						    begin
						        count_rfd = rfd_latency;
						        sub_filter_number = 0;
						        do_compute_result = `TRUE;
						    end
				    	end
				    	else
				     		do_compute_result = `FALSE;	
				    end	
					
				    sel_i = (sel_i >= C_CHANNELS - 1) ? 0 : sel_i + 1;
						`ifdef C_SEL_I_DIR 
						`else
							SEL_I <= { CHANNEL_WIDTH{1'b0} };		
						`endif
					
						// Shift the new data into data memory & increment "num_samples_input_buffer" 
			      shift_data(DIN); 
						
						// Counts how many clocks should be added to the latency when the last sample needed to compute a result
						//	is received.
						sample_latency_counter = sample_latency_counter + clocks_to_process_data;

						// Increment the count of the number of samples stored in the input buffer.  This is only done
						//	when new data is received at the input port, NOT everytime bogus zeros are written in 
						//	(for interpolating filters).
						num_samples_input_buffer = num_samples_input_buffer + 1;
				
		        if (do_compute_result)
		        begin
		            compute_result(c_pipe_stages);	 
					
		      	    // For interpolating filters, stuff zeros into data memory, and compute the new results
		            if (C_FILTER_TYPE == `c_polyphase_interpolating || C_FILTER_TYPE == `c_interpolating_half_band)	 
		            begin
		                for (i = 1; i < C_INTERPOLATE_FACTOR; i = i + 1)
		                begin
			                shift_data( {C_DATA_WIDTH{1'b0}} );
			                compute_result(c_pipe_stages + (interp_mults_per_subfilter * i) );		
		                end
		    	    	end
		  	    end
				end 	// ND high and RFD high		
				
				// Decrement counter of samples left in input buffer and check if the input buffer just went
				//	from full to NOT full	
				if (num_samples_input_buffer > 0)
				begin	
					if (read_input_buffer_counter == 0)
					begin
						num_samples_input_buffer = num_samples_input_buffer - 1;
						
						// Check if input buffer just went from full to not full
						if ( num_samples_input_buffer >= `MAX_NUMBER_SAMPLES - 1 )
							input_buffer_just_went_not_full = `TRUE;
						else
							input_buffer_just_went_not_full = `FALSE;
					end
				
					// Simulate the reading of data from the input buffer	when there are samples in the buffer. 
					read_input_buffer_counter	= (read_input_buffer_counter == 0) ? max_periodic_input_rate - 1 : read_input_buffer_counter - 1;
				end
				
				// Check if the input buffer just went from full to NOT full 
				if ( input_buffer_just_went_not_full == `TRUE )
				begin
					rdy_to_rfd_delay_counter_enable = `TRUE;					
					rdy_to_rfd_delay_counter = `MAC_RDY_TO_RFD_DELAY;						
					input_buffer_just_went_not_full = `FALSE;
				end																				 
						
				// A result is ready to be output	
				if (rdy_delay_counter == 0)
				begin				
					if (count_rdy[0] == 0 && new_data > 0 )
					begin
						new_data = new_data - 1;
						for(i = 0; i < new_data ; i = i + 1)
						   count_rdy[i] = count_rdy[i + 1]; 
						  
						prevRDY = RDY;
						RDY <= 1; 
						
						// Initialize the counter that controls when RDY can be asserted again
				    if (C_FILTER_TYPE == `c_polyphase_decimating || C_FILTER_TYPE == `c_decimating_half_band) 		
								rdy_delay_counter = clocks_to_process_data * C_DECIMATE_FACTOR;
						else if (C_FILTER_TYPE == `c_polyphase_interpolating || C_FILTER_TYPE == `c_interpolating_half_band)
								rdy_delay_counter = MULT_PER_INTERP_SUBFILTER;
						else
								rdy_delay_counter = clocks_to_process_data;
					
						// place output on DOUT 
						if(C_FILTER_TYPE != `c_hilbert_transform)
						    DOUT <= tmpDOUT[new_data];         
						else
						begin
						    DOUT_I <= hilbert_i_out[new_data];
						    DOUT_Q <= tmpDOUT[new_data];                 
						end            
					end		// count_rdy = 0, new_data > 0
				end		// rdy_delay_counter = 0	
				
				// RDY should disabled
				else
				begin            
					prevRDY = RDY;
					RDY <= 0;  
					// If outputs are not registered, and RDY is low, set DOUT (or DOUT_I and DOUT_Q) to Xs
					if(C_REG_OUTPUT == 0)
					begin      
				    if(C_FILTER_TYPE != `c_hilbert_transform)
				        DOUT <= `allXs;
				    else
				    begin               
				        DOUT_I <= {C_DATA_WIDTH{1'bx}};
				        DOUT_Q <= `allXs;
				    end   
					end
				end		// rdy_delay_counter = 0 		
								
				// Update SEL_O the cycle after RDY is asserted
				if (prevRDY === 1'b1)
				begin
				    if ( C_CHANNELS > 1 )
				    begin
				        sel_o = (sel_o >= C_CHANNELS - 1)? 0: sel_o + 1;
				        SEL_O <= sel_o;
				    end	  
					
				end		
			end		// RESET not active 
		end 	// reloading
	end 	// always on posedge CLK

	//-------------------------------------------------------------
	// shift in the new input data
	//-------------------------------------------------------------
	task shift_data;
	
		input [C_DATA_WIDTH-1:0] datain;
		begin
				// For all filter types EXCEPT interpolated filters
		    if (   C_FILTER_TYPE == `c_single_rate 
		        || C_FILTER_TYPE == `c_half_band
		        || C_FILTER_TYPE == `c_polyphase_decimating
		        || C_FILTER_TYPE == `c_polyphase_interpolating
		        || C_FILTER_TYPE == `c_interpolating_half_band
		        || C_FILTER_TYPE == `c_decimating_half_band
		        || C_FILTER_TYPE == `c_hilbert_transform ) 
		    begin
		        // move data through only for the current sel_i channel
		        for ( j = C_TAPS - 1 ; j > 0; j = j - 1)
		        begin
		          sample_data_abs_value[(sel_i * C_TAPS) + j] = sample_data_abs_value[(sel_i * C_TAPS) + j - 1];   
		          data_sign[(sel_i * C_TAPS) + j] = data_sign[(sel_i * C_TAPS) + j - 1];   
		        end	   
				
		        // pull the new data into the right channel
		        if ( C_DATA_TYPE == `c_signed && datain[C_DATA_WIDTH - 1] === 1'b1 )
		        begin
			        sample_data_abs_value[sel_i * C_TAPS] = ~datain + 1;
			        data_sign[sel_i * C_TAPS] = 1;
		        end
		        else if (C_DATA_TYPE == `c_antipodal)
		        begin
			        if (datain == 1'b0)
			          data_sign[sel_i * C_TAPS] = 0;
			        else
			          data_sign[sel_i * C_TAPS] = 1;   
						
			        sample_data_abs_value[sel_i * C_TAPS] = 1'b1;            
		        end
		        else
		        begin
			        sample_data_abs_value[sel_i * C_TAPS] = datain;            
			        data_sign[sel_i * C_TAPS] = 0;
		        end
		    end	 
			
				// Interpolated FIR 
		    else if ( C_FILTER_TYPE == `c_interpolated ) 
		    begin
		        // move data through only for current sel_i channel
		        for ( j = ZPF_TAPS - 1; j > 0; j = j - 1)
		        begin
	  	          zpf_sample_data_abs_value[(sel_i * ZPF_TAPS) + j] = zpf_sample_data_abs_value[(sel_i * ZPF_TAPS) + j - 1];   
		            zpf_data_sign[(sel_i * ZPF_TAPS) + j] = zpf_data_sign[(sel_i * ZPF_TAPS) + j - 1];   
		        end
		
		        // Save the new data as an absolute value and a sign
		        if( C_DATA_TYPE == `c_signed && datain[C_DATA_WIDTH-1] === 1'b1)
		        begin
		            zpf_sample_data_abs_value[sel_i * ZPF_TAPS] = ~datain + 1;            
		            zpf_data_sign[sel_i * ZPF_TAPS] = 1;            
		        end
		        else if ( C_DATA_TYPE == `c_antipodal )
		        begin
		          if (datain == 1'b0)
		           		zpf_data_sign[sel_i * ZPF_TAPS] = 0;            
		         	else
		           		zpf_data_sign[sel_i * ZPF_TAPS] = 1; 
						   
		         	zpf_sample_data_abs_value[sel_i * ZPF_TAPS] = 1'b1;            
		       	end
		      	else
		        begin
			        zpf_sample_data_abs_value[sel_i * ZPF_TAPS] = datain;            
			        zpf_data_sign[sel_i * ZPF_TAPS] = 0;            
		        end
		    end		// Interpolated FIR data shift 
		end	 		
	endtask 	//shift_data


	//-------------------------------------------------------------
	// compute the new result for the current sel_o channel.
	//-------------------------------------------------------------
	task compute_result;	  
	
		input [31:0] pipeline_length;
		reg [C_RESULT_WIDTH - 1 : 0] new_result;
		reg [C_RESULT_WIDTH - 1 : 0] tmp_result;
		integer x_is_signed;		 
		
		begin
		    // calculate DOUT for current sel_o channel
		    new_result = 0;
		    for ( j = 0; j <= C_TAPS - 1; j = j + 1)
		    begin
				if (C_FILTER_TYPE == `c_interpolated)
				begin
					tmp_x_data  = zpf_sample_data_abs_value[(sel_i * ZPF_TAPS) + (j * C_ZPF)];
					x_is_signed = zpf_data_sign[(sel_i * ZPF_TAPS) + (j * C_ZPF)];
				end
				else
			    begin
			        tmp_x_data  = sample_data_abs_value[(sel_i * C_TAPS) + j];
			        x_is_signed = data_sign[(sel_i * C_TAPS) + j];
			    end	
				
		        tmp_result = tmp_x_data * coef_data_abs_value[j];
		        if ( (x_is_signed == 1 && coef_sign[j] == 1'b0) ||
		             (x_is_signed == 0 && coef_sign[j] == 1'b1) )              
		        begin
		            tmp_result = ~tmp_result + 1;
		        end                   
		        new_result = new_result + tmp_result;
			end		   
			
		    // Save the new result in the result array
		    for (j = (BACK_DATA - 1); j > 0; j = j - 1)
		    begin
		        tmpDOUT[j] = tmpDOUT[j - 1];               
		        hilbert_i_out[j] = hilbert_i_out[j - 1];
		    end	
			
		    tmpDOUT[0]  = new_result;	
			
				// Compute new result for I channel of Hilbert filter 
		    tmp_x_data  = sample_data_abs_value[(sel_i * C_TAPS) - 1 + (C_TAPS + 1)/2]; 
		    x_is_signed = data_sign[(sel_i * C_TAPS) - 1 + (C_TAPS + 1)/2];	 
			
		    if (x_is_signed == 1)
		        hilbert_i_out[0] = ~tmp_x_data + 1;
		    else
		        hilbert_i_out[0] = tmp_x_data;
		
		    // Save the number of cycles before the result is placed on the output.  The "- clocks_to_process_data"  
				//	factor is needed because the 'sample_latency_counter' is reloaded with a new value (in "shift_data")
				//	before the "compute_result" task is called.

				count_rdy[new_data] = pipeline_length + sample_latency_counter - clocks_to_process_data;

		    new_data = new_data + 1;
	  	end												  
	endtask 	// compute_result 
   
	//-------------------------------------------------------------
	// All initialization required at startup, and at reloading	   
	//-------------------------------------------------------------
	task do_initialize;				
	
	    begin
	        // Set the input data array to zero or one (for Antipodal filters)
	        for (i = 0; i <= (C_CHANNELS * C_TAPS) - 1; i = i + 1)
	        begin
		        if (C_DATA_TYPE === `c_antipodal)
		            sample_data_abs_value[i] = 1'b1;
		        else 
		            sample_data_abs_value[i] = 0;	
					
		        data_sign[i] = 0;
	        end			  
		  
	        // For Interpolated FIRs, set the input data array to zero or one (for Antipodal filters)
	        for (i = 0; i <= (C_CHANNELS * ZPF_TAPS) - 1; i = i + 1)
	        begin
		        if (C_DATA_TYPE === `c_antipodal)
		            zpf_sample_data_abs_value[i] = 1'b1;
		        else 
		            zpf_sample_data_abs_value[i] = 0; 
					
		        zpf_data_sign[i] = 0;
	        end  
	
	        for (i = 0; i < BACK_DATA; i = i + 1)
	        begin
	            tmpDOUT[i] = 0;
	            hilbert_i_out[i] = 0;
	            count_rdy[i] = 0;	   
	        end	
						
					clocks_to_process_data = C_TAPS;
					if ( (C_RESPONSE == `c_symmetric) || (C_RESPONSE == `c_neg_symmetric) )
							clocks_to_process_data = (C_TAPS / 2) + 1;	
					
		      new_data = 0;
		      prevRDY = 0;
					rfd_latency = compute_rfd_latency(C_FILTER_TYPE);	
	        count_rfd = 0;
					num_samples_input_buffer = 0;	 
					rdy_delay_counter = 0; 
					rdy_to_rfd_delay_counter = 0;
					rdy_to_rfd_delay_counter_enable = `FALSE;
					input_buffer_just_went_not_full = `FALSE;
					sample_latency_counter = 0;						
	        load_counter = 0;
	        do_compute_result = `TRUE;
					
					
	        if (C_FILTER_TYPE == `c_polyphase_interpolating || C_FILTER_TYPE == `c_interpolating_half_band)
					begin
							if ( (C_TAPS % C_INTERPOLATE_FACTOR) == 0 )
									max_periodic_input_rate = C_TAPS;
							else
									max_periodic_input_rate	= C_TAPS + (C_INTERPOLATE_FACTOR - (C_TAPS % C_INTERPOLATE_FACTOR));
					end
					else
							max_periodic_input_rate = clocks_to_process_data;
					
					read_input_buffer_counter = max_periodic_input_rate;
															
	        if (C_FILTER_TYPE == `c_polyphase_decimating || C_FILTER_TYPE == `c_decimating_half_band)
							sub_filter_number = 0; 	
					
			end					   	
	endtask		// do_initialize

	//---------------------------------------------------------
	// Compute RFD latency - the number of cycles after ND that RFD will be asserted again
	//---------------------------------------------------------
	function integer compute_rfd_latency;	  
	
	    input [31:0] filter_type;
	    integer rfd_latency; 
			
	    begin
	     	if ( C_FILTER_TYPE == `c_single_rate ) 
						if ( (C_RESPONSE == `c_symmetric) || (C_RESPONSE == `c_neg_symmetric) )
	       				rfd_latency = clocks_to_process_data + `MAC_FIR_COMPUTE_LATENCY + `MAC_FIR_XTRA_SYMMETRIC_LATENCY;
						else
	       				rfd_latency = clocks_to_process_data + `MAC_FIR_COMPUTE_LATENCY;
				   
	     	else if ( (C_FILTER_TYPE == `c_polyphase_interpolating || C_FILTER_TYPE == `c_interpolating_half_band) && (rfd_latency < C_INTERPOLATE_FACTOR) ) 
	       		rfd_latency = C_INTERPOLATE_FACTOR;
				   
	     	if (C_FILTER_TYPE == `c_polyphase_decimating || C_FILTER_TYPE == `c_decimating_half_band)
	       		compute_rfd_latency = rfd_latency;
	     	else
	       		compute_rfd_latency = rfd_latency - 1;
	    end
    endfunction

endmodule  // end of mac_fir behavioural model			 

//-------------------------------------------------------
`undef c_signed 	
`undef c_unsigned 	
`undef c_antipodal

`undef c_symmetric 	
`undef c_non_symmetric 
`undef c_neg_symmetric 

`undef c_single_rate 		  
`undef c_polyphase_interpolating 
`undef c_polyphase_decimating	  
`undef c_hilbert_transform		  
`undef c_interpolated 		  
`undef c_half_band 			  
`undef c_decimating_half_band 	  
`undef c_interpolating_half_band 

`undef c_no_reload 
`undef c_static 	  

`undef c_data_buffer_type 			   
`undef c_coef_buffer_type 		 
	
`undef MAX_NUMBER_SAMPLES 																	
`undef MAC_RDY_TO_RFD_DELAY	

