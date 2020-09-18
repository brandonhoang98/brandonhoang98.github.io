/****************************************************************************
 *
 * $RCSfile: ASYNC_FIFO_V5_0.v,v $ $Revision: 1.2 $ $Date: 2003/03/04 15:33:36 $
 *
 ****************************************************************************
 *
 * Asynchronous FIFO v5_0 - Verilog Behavioral Model
 *
 ****************************************************************************
 *                                                                       
 * Copyright(C) 2002 by Xilinx, Inc. All rights reserved.
 * This text contains proprietary, confidential
 * information of Xilinx, Inc., is distributed
 * under license from Xilinx, Inc., and may be used,
 * copied and/or disclosed only pursuant to the terms
 * of a valid license agreement with Xilinx, Inc. This copyright
 * notice must be retained as part of this text at all times.
 *
 ***************************************************************************-
 *
 * Filename: ASYNC_FIFO_V5_0.v
 *
 * Description: 
 *  The behavioral model for the asynchronous fifo.
 *                      
 ***************************************************************************/



`timescale 1ns/10ps


/*************************************************************************
 * Declare top-level module 
 *************************************************************************/
module ASYNC_FIFO_V5_0(DIN, WR_EN, WR_CLK, RD_EN, RD_CLK, AINIT, DOUT, FULL, EMPTY, ALMOST_FULL, ALMOST_EMPTY, WR_COUNT, RD_COUNT, RD_ACK, RD_ERR, WR_ACK, WR_ERR);


/*************************************************************************
 * Definition of Ports
 * DIN         : Input data bus for the fifo.
 * DOUT        : Output data bus for the fifo.
 * AINIT       : Asynchronous Reset for the fifo.
 * WR_EN       : Write enable signal.
 * WR_CLK      : Write Clock.
 * FULL        : Full signal.
 * ALMOST_FULL : One space left.
 * WR_ACK      : Last write acknowledged.
 * WR_ERR      : Last write rejected.
 * WR_COUNT    : Number of data words in fifo(synchronous to WR_CLK)
 * Rd_EN       : Read enable signal.
 * RD_CLK      : Read Clock.
 * EMPTY       : Empty signal.
 * ALMOST_EMPTY: One sapce left
 * RD_ACK      : Last read acknowledged.
 * RD_ERR      : Last read rejected.
 * RD_COUNT    : Number of data words in fifo(synchronous to RD_CLK)
 *************************************************************************/

parameter C_DATA_WIDTH		= 8;
parameter C_ENABLE_RLOCS	= 0;
parameter C_FIFO_DEPTH 		= 511;
parameter C_HAS_ALMOST_EMPTY	= 1;
parameter C_HAS_ALMOST_FULL 	= 1;
parameter C_HAS_RD_ACK	        = 1;
parameter C_HAS_RD_COUNT        = 1;
parameter C_HAS_RD_ERR	        = 1;
parameter C_HAS_WR_ACK	        = 1;
parameter C_HAS_WR_COUNT        = 1;
parameter C_HAS_WR_ERR	        = 1;
parameter C_RD_ACK_LOW	        = 0;
parameter C_RD_COUNT_WIDTH      = 6;
parameter C_RD_ERR_LOW	        = 0;
parameter C_USE_BLOCKMEM        = 1;
parameter C_WR_ACK_LOW	        = 0;
parameter C_WR_COUNT_WIDTH      = 6;
parameter C_WR_ERR_LOW	        = 0;


input  [C_DATA_WIDTH-1 : 0] DIN;
input  WR_EN;
input  WR_CLK;
input  RD_EN;
input  RD_CLK;
input  AINIT;
output [C_DATA_WIDTH-1 : 0] DOUT;		
output FULL;
output EMPTY;
output ALMOST_FULL;
output ALMOST_EMPTY;
output [C_WR_COUNT_WIDTH-1 : 0] WR_COUNT;
output [C_RD_COUNT_WIDTH-1 : 0] RD_COUNT;
output RD_ACK;
output RD_ERR;
output WR_ACK;
output WR_ERR;
   
/*************************************************************************
 * Parameters used as constants
 *************************************************************************/
//length of the list which will simulate a FIFO
parameter listlength = C_FIFO_DEPTH*(C_DATA_WIDTH+1);   

//depth of the FIFO seen by the counter
parameter counter_depth = C_FIFO_DEPTH + 1;

//depth of the actual FIFO...due to structual implementation
parameter depth = C_FIFO_DEPTH;

//shift amount for WR_COUNT calculation
//parameter wr_shamt = C_FIFO_DEPTH - C_WR_COUNT_WIDTH;

//shift amount for RD_COUNT calculation
//parameter rd_shamt = C_FIFO_DEPTH - C_WR_COUNT_WIDTH;

/*************************************************************************
  * Internal regs (for always blocks) and wires (for assign statements)
 *************************************************************************/
reg [listlength:0] list;       //list to be used as a fifo

reg full_i;                    //internal FULL signal
reg almost_full_i;             //internal AMOST_FULL signal

reg empty_i;                   //internal EMPTY signal
reg almost_empty_i;            //internal ALMOST_EMPTY signal

reg [C_DATA_WIDTH-1:0] dout_i; //internal DOUT bus

reg wr_ack_i;                  //internal WR_ACK signal
reg wr_err_i;                  //internal WR_ERR signal
reg rd_ack_i;                  //internal RD_ACK signal
reg rd_err_i;                  //internal RD_ERR signal

reg [C_WR_COUNT_WIDTH-1:0] wr_count_i;  //internal WR_COUNT signal
reg [C_RD_COUNT_WIDTH-1:0] rd_count_i;  //internal RD_COUNT signal

wire [31:0] wr_shamt;           //write shift amount
wire [31:0] rd_shamt;           //rd_shamt

reg wr_pulse;                  //pulse asserted at posedge of WR_CLK
reg rd_pulse;                  //pulse asserted at posedge of RD_CLK

reg [C_FIFO_DEPTH-1:0] wr_point;    //write pointer
reg [C_FIFO_DEPTH-1:0] rd_point;    //read pointer

reg [C_FIFO_DEPTH-1:0] wr_point_rc; //write pointer latched by RD_CLK
reg [C_FIFO_DEPTH-1:0] rd_point_wc; //read pointer latched by WR_CLK

reg [C_FIFO_DEPTH-1:0] wr_point_rc2; //write pointer latched by RD_CLK
reg [C_FIFO_DEPTH-1:0] rd_point_wc2; //read pointer latched by WR_CLK

reg [C_DATA_WIDTH-1:0] one;
reg [C_DATA_WIDTH-1:0] two;
reg [C_DATA_WIDTH-1:0] three;
reg [31:0] size;
reg [31:0] size2;
wire [31:0] sizewire;
reg [C_DATA_WIDTH-1:0] data;
reg clk;
reg clk2;
reg clk2_i; 
reg clk2_ii;
   
/*************************************************************************
 * binary :
 *  Calculates how many bits are needed to represent the input number
 *************************************************************************/
  function [31:0] binary;
    input [31:0] inval;
    integer power;
    integer bits;
  begin  
    power = 1;
    bits  = 0;
    while (power <= inval)
    begin
      power = power * 2;
      bits  = bits + 1;      
    end // loop
    binary = bits;
  end
  endfunction
  
/************************************************************************
 * returns number of entries in the list
 *************************************************************************/
  function [31:0] listsize;
    input [((C_DATA_WIDTH+1)*C_FIFO_DEPTH):0] inarray;
    reg condition;
    integer i;
    integer j;
  begin
    condition = 1'b0;
    i = 0;
    j = 0;
    while (condition == 1'b0)
    begin
      j = (C_DATA_WIDTH+1)*i;
      if(inarray[j] == 1'b0)
        condition  = 1'b1;
      i = i + 1;
    end // loop
    listsize = (i-1);
  end
  endfunction //space
      
/************************************************************************
 * Add entry to the end of the list
 *************************************************************************/
  function [((C_DATA_WIDTH+1)*C_FIFO_DEPTH):0] addlist;
    input [((C_DATA_WIDTH+1)*C_FIFO_DEPTH):0] inarray;
    input [C_DATA_WIDTH-1:0] inword;
    reg [((C_DATA_WIDTH+1)*C_FIFO_DEPTH):0] temp;
    integer i;
    integer j;
  begin
    temp = 1'b0;
    i = listsize(inarray);
    j = (i*(C_DATA_WIDTH+1));
    temp[C_DATA_WIDTH:0] = {inword, 1'b1};
    temp = temp << j; 
    addlist = temp | inarray;
  end
  endfunction //addlist

/************************************************************************
 * Read from head of the list
 *************************************************************************/
  function [C_DATA_WIDTH-1:0] readlist;
    input [((C_DATA_WIDTH+1)*C_FIFO_DEPTH):0] inarray;
  begin
    readlist = inarray[C_DATA_WIDTH:1];
  end
  endfunction //readlist  

/************************************************************************
 * Remove entry  from head of the list
 *************************************************************************/
  function [((C_DATA_WIDTH+1)*C_FIFO_DEPTH):0] removelist;
    input [((C_DATA_WIDTH+1)*C_FIFO_DEPTH):0] inarray;
  begin
    removelist = inarray >> (C_DATA_WIDTH+1);
  end
  endfunction //removelist
    

/*************************************************************************
 * Initial Blocks
 *************************************************************************/
  initial
  begin
   list = 0;
   dout_i = 0;
  end

/*************************************************************************
 * Assign Statements
 *************************************************************************/
assign DOUT        = dout_i;
assign FULL        = full_i;
assign EMPTY       = empty_i;
assign ALMOST_FULL  = almost_full_i;
assign ALMOST_EMPTY = almost_empty_i;
assign WR_ACK       = wr_ack_i;
assign WR_ERR       = wr_err_i;
assign RD_ACK       = rd_ack_i;
assign RD_ERR       = rd_err_i;
assign WR_COUNT     = wr_count_i;
assign RD_COUNT     = rd_count_i;

assign wr_shamt     = (binary(C_FIFO_DEPTH) - C_WR_COUNT_WIDTH);
assign rd_shamt     = (binary(C_FIFO_DEPTH) - C_RD_COUNT_WIDTH);

/*************************************************************************
 * Generate read and write pulse signals
 *************************************************************************/
/********wr_pulse generator*************/
  always @(posedge WR_CLK)
  begin
    wr_pulse <= #1 1'b1;
    wait (wr_pulse) wr_pulse <= 1'b0;
  end // wr_pulse generator

/********wr_pulse generator*************/
  always @(posedge RD_CLK)
  begin
    rd_pulse <= #1 1'b1;
    wait (rd_pulse) rd_pulse <= 1'b0;
  end // rd_pulse generator

/*************************************************************************
 * Read and Write from FIFO (implemented by a list)
 *************************************************************************/
/*******access the list for read or write**************/ 
  always @(posedge wr_pulse or posedge rd_pulse or posedge AINIT)
  begin
    //reset fifo
    if (AINIT == 1'b1)
    begin
      list   <= 0;
    //  dout_i <= 0;
    end

    //write to fifo
    else if ((wr_pulse == 1'b1) && (WR_EN == 1'b1) && (listsize(list) != depth) && (wr_ack_i == !C_WR_ACK_LOW))
      list <= addlist(list,DIN);

    //read from fifo
    else if ((rd_pulse == 1'b1) && (RD_EN == 1'b1) && (listsize(list) != 0) && (rd_ack_i == !C_RD_ACK_LOW))
    begin
      dout_i <= readlist(list);
      list   <= removelist(list);
    end
  end //read and write from list


/********WR_CLK synchronous signal manipulations*****************************/
  always @(posedge WR_CLK or posedge AINIT)
  begin
    //asynchronous reset condition
    if (AINIT == 1'b1)
    begin
      full_i        <= 1'b1;
      almost_full_i <= 1'b1;
      wr_ack_i      <= C_WR_ACK_LOW;
      wr_err_i      <= C_WR_ERR_LOW;
      wr_point      <= 0;
    end // reset condition
   
    //signal control (FULL, AMOST_FULL, WR_ACK, WR_ERR)
    else
    begin

      size2 <= listsize(list);    
      
      //de-assert FULL and ALMOST FULL signals coming out of reset
      full_i        <= 1'b0;
      almost_full_i <= 1'b0;
        
      //control FULL and ALMOST_FULL signals
      //(depth-2) entries in the FIFO
      if (listsize(list) == (depth - 2))   
      begin
        
        //writing to FIFO
        if (WR_EN == 1'b1)
          begin
          almost_full_i <= 1'b1; 
          full_i        <= 1'b0;
          wr_ack_i      <= !C_WR_ACK_LOW;
          wr_err_i      <= C_WR_ERR_LOW;
          wr_point      <= (wr_point + 1) % counter_depth;
        end

        //not writing to FIFO
        else
        begin
          almost_full_i <= 1'b0;
          full_i        <= 1'b0;
        end
      end
    
      //(depth-1) entries in the FIFO
      if (listsize(list) == (depth - 1))
      begin

        //Writing to FIFO : assert WR_ACK
        if (WR_EN == 1'b1)
        begin
          almost_full_i <= 1'b1;
          full_i        <= 1'b1;
          wr_ack_i  <= !C_WR_ACK_LOW;
          wr_err_i  <= C_WR_ERR_LOW;
          wr_point  <= (wr_point + 1) % counter_depth;
        end

        //Not writing to FIFO
        else
        begin
          almost_full_i <= 1'b1;
          full_i        <= 1'b0;
          wr_ack_i  <= C_WR_ACK_LOW;
          wr_err_i  <= C_WR_ERR_LOW;
        end

      end //(depth-1) entries in the FIFO 

      //(depth) entries in the FIFO (fifo full when there's one
      //empty space, structural model implementation)
      else if (listsize(list) == (depth))
      begin
        almost_full_i <= 1'b1;
        full_i        <= 1'b1;

        //Attemted write when FIFO is full : assert WR_ERR
        if (WR_EN == 1'b1)
        begin
          wr_ack_i  <= C_WR_ACK_LOW;
          wr_err_i  <= !C_WR_ERR_LOW;
        end

        //not writing to FIFO
        else
        begin
          wr_ack_i  <= C_WR_ACK_LOW;
          wr_err_i  <= C_WR_ERR_LOW;
        end

      end //(depth) entries in the FIFO
     
      //All other # of entries in the FIFO
      else
      begin
        //Writing to FIFO : assert WR_ACK
        if (WR_EN == 1'b1)
        begin  
          wr_ack_i  <= !C_WR_ACK_LOW;
          wr_err_i  <= C_WR_ERR_LOW;
          wr_point  <= (wr_point + 1) % counter_depth;
        end
 
        //Not writing to FIFO
        else
        begin
          wr_ack_i  <= C_WR_ACK_LOW;
          wr_err_i  <= C_WR_ERR_LOW;
        end

      end //All other # of entries
    
      //Over-ride above logic if FIFO is already FULL
      if (full_i == 1'b1)
      begin
        if (WR_EN == 1'b1)
        begin
          wr_ack_i  <= C_WR_ACK_LOW;
          wr_err_i  <= !C_WR_ERR_LOW;
          wr_point  <= wr_point;
        end
        else
        begin
          wr_ack_i  <= C_WR_ACK_LOW;
          wr_err_i  <= C_WR_ERR_LOW;
          wr_point  <= wr_point;
        end
     
        if (listsize(list) != depth)
          full_i     <= 1'b0;
  
   //     if (listsize(list) != depth - 1)
   //       almost_full_i <= 1'b1;
         
      end // FIFO already full

    end //FULL and ALMOST_FULL control

  end //WR_CLK sync

/***********RD_CLK synchronous signal manipulations***************/
  always @(posedge RD_CLK or posedge AINIT)
  begin
    //asynchronous reset condition
    if (AINIT == 1'b1)
    begin
      empty_i        <= 1'b1;
      almost_empty_i <= 1'b1;
      rd_ack_i       <= C_RD_ACK_LOW;
      rd_err_i       <= C_RD_ERR_LOW;
      rd_point       <= 0;
    end
   
    //signal control (EMPTY, AMOST_EMPTY)
    else
    begin

      size <= listsize(list);

      //control EMPTY and ALMOST_EMPTY signals
      // (0) entries in the FIFO
      if (listsize(list) == 0)
      begin
        almost_empty_i <= 1'b1;
        empty_i        <= 1'b1;

        //reading from empty FIFO
        if (RD_EN == 1'b1)
        begin
          rd_ack_i  <= C_RD_ACK_LOW;
          rd_err_i  <= !C_RD_ERR_LOW;
        end
  
        //not reading from empty FIFO
        else
        begin
          rd_ack_i  <= C_RD_ACK_LOW;
          rd_err_i  <= C_RD_ERR_LOW;
        end
        
      end //(0) entries in the FIFO

      //(1) entry in the FIFO
      else if (listsize(list) == 1)
      begin

        //reading from 1entry FIFO
        if (RD_EN == 1'b1)
        begin
          almost_empty_i <= 1'b1;
          empty_i        <= 1'b1;
          rd_ack_i       <= !C_RD_ACK_LOW;
          rd_err_i       <= C_RD_ERR_LOW;
          rd_point       <= (rd_point + 1) % counter_depth;
        end

        //not reading from 1 entry FIFO
        else
        begin
          almost_empty_i <= 1'b1;
          empty_i        <= 1'b0;
          rd_ack_i       <= C_RD_ACK_LOW;
          rd_err_i       <= C_RD_ERR_LOW;
        end

      end //(1) entry in the FIFO 

      //(2) entries in the FIFO
      else if (listsize(list) == 2)
      begin

        //reading from 1entry FIFO
        if (RD_EN == 1'b1)
        begin
          almost_empty_i <= 1'b1;
          empty_i        <= 1'b0;
          rd_ack_i       <= !C_RD_ACK_LOW;
          rd_err_i       <= C_RD_ERR_LOW;
          rd_point       <= (rd_point + 1) % counter_depth;
        end

        //not reading from 2 entry FIFO
        else
        begin
          almost_empty_i <= 1'b0;
          empty_i        <= 1'b0;
          rd_ack_i       <= C_RD_ACK_LOW;
          rd_err_i       <= C_RD_ERR_LOW;
        end

      end //(2) entry in the FIFO 

      //all other # of entries in FIFO
      else
      begin
        almost_empty_i <= 1'b0;
        empty_i        <= 1'b0;

        //reading from other entry FIFO
        if (RD_EN == 1'b1)
        begin
          rd_ack_i  <= !C_RD_ACK_LOW;
          rd_err_i  <= C_RD_ERR_LOW;
          rd_point  <= (rd_point + 1) % counter_depth;
        end

        //not reading from other entry FIFO
        else
        begin
          rd_ack_i  <= C_RD_ACK_LOW;
          rd_err_i  <= C_RD_ERR_LOW;
        end

      end //other # entries in FIFO

      //Over-ride above logic if FIFO is already EMPTY
      if (empty_i == 1'b1)
      begin
        if (RD_EN == 1'b1)
        begin
          rd_ack_i  <= C_RD_ACK_LOW;
          rd_err_i  <= !C_RD_ERR_LOW;
          rd_point  <= rd_point;
        end
        else
        begin
          rd_ack_i  <= C_RD_ACK_LOW;
          rd_err_i  <= C_RD_ERR_LOW;
          rd_point  <= rd_point;
        end

        if (listsize(list) != 0)
          empty_i   <= 1'b0;

      //  if (listsize(list) == 1)
      //    almost_empty_i <= 1'b1;

      end // FIFO already empty

    end //EMPTY and ALMOST_EMPTY control

  end //RD_CLK sync


/***********WR_COUNT generator*************/
  always @(posedge WR_CLK or posedge AINIT)
  begin

    //Reset condition
    if (AINIT == 1'b1)
    begin
      wr_count_i  <= 0;
      rd_point_wc <= 0;
      rd_point_wc2<= 0;
    end // reset
    
    //WR_COUNT calculation
    else
    begin
      //latch read pointer with WR_CLK
      rd_point_wc <= rd_point;
      rd_point_wc2<= rd_point_wc;
      
      if (wr_point >= rd_point_wc2)
        wr_count_i  <= (wr_point - rd_point_wc2) >> wr_shamt; 
      else
        wr_count_i  <= ((depth+1) - rd_point_wc2 + wr_point) >> wr_shamt;

    end // WR_COUNT calculation

  end // WR_COUNT generator   

/**********RD_COUNT generator**************/
  always @(posedge RD_CLK or posedge AINIT)
  begin

    //Reset condition
    if (AINIT == 1'b1)
    begin
      rd_count_i  <= 0;
      wr_point_rc <= 0;
      wr_point_rc2<= 0;
    end // reset
    
    //RD_COUNT calculation
    else
    begin
      //latch write pointer with RD_CLK
      wr_point_rc  <= wr_point;
      wr_point_rc2 <= wr_point_rc;

      if (wr_point_rc2 >= rd_point)
        rd_count_i  <= (wr_point_rc2 - rd_point) >> rd_shamt; 
      else
        rd_count_i  <= ((depth+1) - rd_point + wr_point_rc2) >> rd_shamt;

    end // RD_COUNT calculation

  end // RD_COUNT generator
  
endmodule // module name
