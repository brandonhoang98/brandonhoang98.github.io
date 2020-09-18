`timescale 1ns/10ps

`define TRUE  1'b1
`define FALSE 1'b0

`define FORWARD_DCT 0
`define INVERSE_DCT 1
`define IEEE_1180_1990_IDCT 2

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

/*************************************************************************
 * Declare top-level module
 *************************************************************************/
module C_DA_2D_DCT_V2_0
	(
	 CLK,
	 DIN,
	 DOUT,
	 ND,
	 RDY,
	 RFD,
	 RST
	);			 
	
/*************************************************************************
 * Parameter, Input Port, and Output Port Declarations 
 *************************************************************************/	  
 
/*************************************************************************
 * Definition of Parameters
 *************************************************************************/
	parameter C_CLKS_PER_SAMPLE       = 11;	   
	parameter C_COEFF_WIDTH           = 9;
	parameter C_COL_LATENCY           = 15;
	parameter C_DATA_TYPE             = `SIGNED_VALUE;
 	parameter C_DATA_WIDTH            = 10;
	parameter C_ENABLE_RLOCS          = `FALSE; 	
 	parameter C_ENABLE_SYMMETRY       = `TRUE;
	parameter C_HAS_RESET             = `FALSE;	
	parameter C_INTERNAL_WIDTH        = 15;
 	parameter C_LATENCY               = 95;
	parameter C_MEM_TYPE              = `BLOCK_MEMORY;
	parameter C_OPERATION             = `FORWARD_DCT;
	parameter C_PRECISION_CONTROL     = `ROUND;	
	parameter C_RESULT_WIDTH          = 12; 
	parameter C_ROW_LATENCY           = 14;
 	parameter C_SHAPE                 = `NO_CONTROL; 

																		
/*************************************************************************
 * Parameters used as constants
 *************************************************************************/	
	parameter points = 8;
	parameter log2_points = 3;
	parameter full_internal_width = C_DATA_WIDTH + C_DATA_TYPE + C_COEFF_WIDTH + log2_points;
	parameter full_result_width = full_internal_width + C_COEFF_WIDTH + log2_points;
	parameter internal_width = ((C_PRECISION_CONTROL == `FULL_PRECISION) ? full_internal_width : C_INTERNAL_WIDTH);
	parameter result_width = ((C_PRECISION_CONTROL == `FULL_PRECISION) ? full_result_width : C_RESULT_WIDTH);
  parameter operation = ((C_OPERATION == `FORWARD_DCT) ? 0 : 1);
  parameter modified_internal_width = ((C_OPERATION == `IEEE_1180_1990_IDCT) ? 19 : internal_width);
  parameter modified_result_width = ((C_OPERATION == `IEEE_1180_1990_IDCT) ? 16 : result_width);

	
/*************************************************************************
 * Definition of Ports:
 *************************************************************************/	
	input CLK;
	input [C_DATA_WIDTH - 1 : 0] DIN;
	input ND;
	input RST;
		
	output [result_width - 1 : 0] DOUT;
	output RDY;
	output RFD;	  
	
/*************************************************************************
 * Input and Output reg Declarations 
 *************************************************************************/	
 	reg  [result_width - 1 : 0] DOUT;
	reg  RDY;
	wire RFD;	  

   // The following is required keep the systhesis tool from trying to 
   // synthesize this module 

   // synopsys_translate_off 


/*************************************************************************
 * Internal regs, wires, and integers
 *************************************************************************/
  wire [modified_internal_width - 1 : 0] rowdout;
	wire rowrdy;
	wire columnrfd;
	wire columnrdy;
	wire [modified_result_width - 1 : 0] columndout;
	
 	reg [internal_width - 1 : 0] clipped_rowdout;
	reg [internal_width - 1: 0] columndin;
	reg columnnd;
	
	reg sat_columnrdy;
	reg [result_width - 1 : 0] sat_columndout;
	reg [internal_width - 1 : 0] internal_reg [2 * points * points - 1 : 0];
	
	reg goingFull;
	reg readData;
	reg waitForBinFull;
	reg finishedBin;
	
	integer	index;	 
	integer	transpose_index;
	
	integer rstClockCounter;
	integer	read_counter;
	integer	write_counter;	
		
	
/*************************************************************************
 * Instantation of Lower-Level Files 
 *************************************************************************/	
	C_DA_1D_DCT_V2_1 # (
                      C_CLKS_PER_SAMPLE, 
                      C_COEFF_WIDTH,          
                      C_DATA_TYPE,            
                      C_DATA_WIDTH,         
                      C_ENABLE_RLOCS,     
                      C_ENABLE_SYMMETRY,     
                      C_HAS_RESET,            
                      C_ROW_LATENCY,             
                      operation,            
                      points,               
                      C_PRECISION_CONTROL,    
                      modified_internal_width       
                     )
             row_dct ( 
                      .CLK(CLK),
                      .DIN(DIN),
                      .DOUT(rowdout),
                      .ND(ND),
                      .RDY(rowrdy),
                      .RFD(RFD),
                      .RST(RST)
                     );
								
  C_DA_1D_DCT_V2_1 # ( 
                      C_CLKS_PER_SAMPLE, 
                      C_COEFF_WIDTH,          
                      `SIGNED_VALUE,            
                      internal_width,         
                      C_ENABLE_RLOCS,     
                      C_ENABLE_SYMMETRY,     
                      C_HAS_RESET,            
                      C_COL_LATENCY,             
                      operation,            
                      points,               
                      C_PRECISION_CONTROL,    
                      modified_result_width      
                     )
          column_dct (
                      .CLK(CLK),	
                      .DIN(columndin),
                      .DOUT(columndout),
                      .ND(columnnd),
                      .RDY(columnrdy),
                      .RFD(columnrfd),
                      .RST(RST)
                     );				   

/*************************************************************************
 * Clip Functions
 *************************************************************************/
  function [(internal_width - 1) : 0] row_clip;
  input [(modified_internal_width - 1) : 0] data_in;
  begin
	  if(data_in[(modified_internal_width - 1): (internal_width - 1)] != {(modified_internal_width - internal_width + 1){1'b0}}
			 && data_in[(modified_internal_width - 1): (internal_width - 1)] != {(modified_internal_width - internal_width + 1){1'b1}})
		begin	 
			if (data_in[modified_internal_width - 1] == 0)
				row_clip = {1'b0, {(internal_width - 1){1'b1}}};
			else
				row_clip = {1'b1, {(internal_width - 1){1'b0}}};
		end		
	  else
      row_clip = data_in[(internal_width - 1) : 0];
	end
  endfunction

  function [(result_width - 1) : 0] column_clip;
  input [(modified_result_width - 1) : 0] data_in;
  begin
    if(data_in[(modified_result_width - 1) : (result_width - 1)] != {(modified_result_width - result_width + 1){1'b0}} 
			&& data_in[(modified_result_width - 1) : (result_width - 1)] != {(modified_result_width - result_width + 1){1'b1}})
		begin
			if (data_in[modified_result_width - 1] == 0)
				column_clip = {1'b0, {(result_width - 1){1'b1}}};
			else
				column_clip = {1'b1, {(result_width - 1){1'b0}}};
		end		
		else
      column_clip = data_in[(result_width - 1) : 0];
  end
  endfunction


/*************************************************************************
 * Initial Blocks
 *************************************************************************/
	initial	
	begin
		for(index = 0; index < (2 * points * points); index = index + 1) 
			internal_reg[index] = {internal_width{1'b0}};  
			
		clipped_rowdout = {internal_width{1'b0}};
		columndin = {internal_width{1'b0}};
		columnnd = 1'b0;
		RDY = 1'b0;
		DOUT = {result_width{1'b0}};
	
		goingFull = 1'b0;
		readData = 1'b0;
		waitForBinFull = 1'b1;
		finishedBin = 1'b0;
		
		index = 0;
		transpose_index = 0;
	
		rstClockCounter = 0;
		read_counter = 0;
		write_counter = 0;	 
	end
	
/*************************************************************************
 * Always Blocks
 *************************************************************************/	
  /** decode that the WRITE counter has "111111" on its 6 LSBx and that the
	 * rowRDY signal is asserted. **/
	always @ (write_counter)
	begin
		if ((write_counter == (points * points - 1)) || (write_counter == (2 * points * points - 1)))
		  goingFull = 1'b1;
		else
		  goingFull = 1'b0;
	end

  /** decode that the READ counter has "111111" on its 6 LSBs **/
	always @ (read_counter)
	begin
		if ((read_counter == (points * points - 1)) || (read_counter == (2 * points * points - 1)))
      finishedBin = 1'b1;
		else
		  finishedBin = 1'b0;
  end	
	
  /** IEEE standard for row output **/
  always @ (rowdout)
	begin
    if(C_OPERATION == `IEEE_1180_1990_IDCT)
      clipped_rowdout = row_clip(rowdout);
		else
      clipped_rowdout = rowdout;
	end
	
	/** IEEE standard for column output **/
  always @ (columnrdy or columndout or sat_columnrdy or sat_columndout)
	begin
		if(C_OPERATION != `IEEE_1180_1990_IDCT)
		begin
			RDY = columnrdy;
			DOUT = columndout;
		end
	
		else
		begin
			RDY = sat_columnrdy;
      DOUT = sat_columndout;
		end
	end		

	/* always block w/ clock */
	always @ (posedge CLK)
	begin
		
		if((C_HAS_RESET == `TRUE) && (RST == 1'b1))
		begin
			clipped_rowdout = {internal_width{1'b0}};
			columndin = {internal_width{1'b0}};
			columnnd = 1'b0;
			RDY <= 1'b0;
			DOUT <= {result_width{1'b0}};

			index = 0;
			transpose_index = 0;
    	
			for(index = 0; index < (2 * points * points); index = index + 1)
				internal_reg[index] = {internal_width{1'b0}};
				
			goingFull = 1'b0;
			readData = 1'b0;
			waitForBinFull = 1'b1;
			finishedBin = 1'b0;
			
			rstClockCounter = 0;
			read_counter = 0;
			write_counter = 0;
		end
	
		/* the main logic condition */
		else			
		begin
      
			/** no flow control needed the DCT can process the data faster than the
			 * number points needed (combined) **/
			if ((C_CLKS_PER_SAMPLE < points || rstClockCounter < points) && readData == 1'b1)
        	columnnd = 1'b1;
			else if (readData == 1'b0 || rstClockCounter >= points)
          columnnd = 1'b0;
  	
			/** need to flow control the input data to the column DCT **/
			if (C_CLKS_PER_SAMPLE >= points)
			begin
	      if(readData == 1'b1)
					rstClockCounter <= rstClockCounter + 1;
				
				if(rstClockCounter == C_CLKS_PER_SAMPLE - 1 || readData == 1'b0)
					rstClockCounter <= 0;	
			end
			
		  /** write to memory **/
			if (rowrdy == 1'b1) 
			begin
				internal_reg[write_counter] = clipped_rowdout; 
				write_counter <= write_counter + 1;  
				if (write_counter == (2 * points * points - 1))
					write_counter <= 0;     
			end

   		/** reading from memory **/
			if (readData == 1'b1 && columnnd == 1'b1)
			begin 
        transpose_index = (read_counter % 8) * 8 + ((read_counter % 64) / 8) + 64 * (read_counter / 64);
	      columndin = internal_reg[transpose_index];
        read_counter <= read_counter + 1; 
        if (read_counter == (2 * points * points - 1))
          read_counter <= 0;    
      end

			/** waitForBinFull register **/ 
			if (((readData == 1) && (finishedBin == 1) && (goingFull == 0)) || ((goingFull == 0) && (waitForBinFull == 1)))
				waitForBinFull <= 1'b1;
			else
				waitForBinFull <= 1'b0;
				
			/** readData register **/ 
			if (((readData == 1) && (finishedBin == 0)) || ((readData == 1) && (finishedBin == 1) && (goingFull == 1)) || ((goingFull ==1) && (waitForBinFull == 1)))
				readData <= 1'b1;
			else
				readData <= 1'b0; 
			
			if(C_OPERATION == `IEEE_1180_1990_IDCT)
			begin
				sat_columnrdy <= columnrdy;
			 	sat_columndout <= column_clip(columndout);
			end
													
		end
	end

  // synopsys_translate_on 

   // synthesis attribute GENERATOR_DEFAULT of C_DA_2D_DCT_V2_0 is "generatecore com.xilinx.ip.da_2d_dct_v2_0.C_DA_2D_DCT_V2_0" 
   // The follwing are required by XST 
   // box_type "black_box"  
   // synthesis attribute box_type of C_DA_2D_DCT_V2_0 is "black_box"

endmodule	// C_DA_2D_DCT_V2_0

`undef TRUE
`undef FALSE

`undef FORWARD_DCT
`undef INVERSE_DCT 
`undef IEEE_1180_1990_IDCT 

`undef SIGNED_VALUE
`undef UNSIGNED_VALUE 

`undef FULL_PRECISION
`undef ROUND
`undef TRUNCATE

`undef BLOCK_MEMORY
`undef DIST_MEMORY 

`undef NO_CONTROL 
`undef ROW_ORIENTATION 
`undef COL_ORIENTATION 
