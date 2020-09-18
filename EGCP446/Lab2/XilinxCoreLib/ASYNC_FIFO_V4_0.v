// ************************************************************************
// $Id: ASYNC_FIFO_V4_0.v,v 1.4 2002/03/29 15:53:06 janeh Exp $
// ************************************************************************
//  Copyright 2000 - Xilinx, Inc.
//  All rights reserved.
// ************************************************************************
//-- Filename: async_fifo_v4_0.v
//-- Author : Xilinx, Inc.
//-- Creation ; Sept. 7th, 1999
//-- Description: This file contains the verilog behavioral model for the asynchornous fifo core.
//***********************************************************************//
// Structure:
//   ASYNC_FIFO_V4_0
//     memory_v4
//      memories
//     fifoctlr_ns_v4
//      other modules
//***********************************************************************//

`timescale 1ns/10ps

`define true 1
`define false 0



`define width 6

`define c_enable_rlocs	 0
`define c_data_width		 16
`define c_read_data_width	 16
`define c_ports_differ	0
`define c_fifo_depth 		 63
`define c_has_almost_full 	 1
`define c_has_almost_empty	 1
`define c_has_wr_count          1
`define c_has_rd_count          1
`define c_wr_count_width        6
`define c_rd_count_width        6
`define c_has_rd_ack	          1
`define c_rd_ack_low	          0
`define c_has_rd_err	          1
`define c_rd_err_low	          0
`define c_has_wr_ack	          1
`define c_wr_ack_low	          0
`define c_has_wr_err	          1
`define c_wr_err_low	          0
`define c_use_blockmem          1





/****************************************************************************/
/* Top Level async_fifo */
/****************************************************************************/


/* ***************************************************************************
 * Module 
 * **************************************************************************/
module ASYNC_FIFO_V4_0 (DIN, WR_EN, WR_CLK, RD_EN, RD_CLK, AINIT, DOUT, FULL, EMPTY, ALMOST_FULL, ALMOST_EMPTY, WR_COUNT, RD_COUNT, RD_ACK, RD_ERR, WR_ACK, WR_ERR);


/* Functions */

function log2roundup;
	input data_value ;
	integer lower_limit;
	integer upper_limit;
	integer i;
	begin
		lower_limit=4;
		upper_limit=16;
		for (i=lower_limit-1; i<=upper_limit; i=i+1) begin
		  if (data_value <=0) begin
			log2roundup=0;
		  end
		  else if (data_value > (1 << i)) begin
			log2roundup = i + 1;
 		  end
		end	
	end
endfunction
/* End Functions */

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

parameter depth_of_mem = C_FIFO_DEPTH +1;
parameter address_width = (depth_of_mem == 16 ? 4:
			  (depth_of_mem == 32 ? 5:
			  (depth_of_mem == 64 ? 6 :
			  (depth_of_mem == 128 ? 7 :
			  (depth_of_mem == 256 ? 8 :
			  (depth_of_mem == 512 ? 9 :
			  (depth_of_mem == 1024 ? 10 :
			  (depth_of_mem == 2048 ? 11 :
			  (depth_of_mem == 4096 ? 12 :
			  (depth_of_mem == 8192 ? 13 :
			  (depth_of_mem == 16384 ? 14 :
			  (depth_of_mem == 32768 ? 15 :
			  (depth_of_mem == 65536 ? 16 : 6)))))))))))));


wire [address_width-1 :0] read_address;
wire [address_width-1 : 0] write_address;
wire qualified_read_enable;
wire qualified_write_request;

wire #1 WR_EN_DLY = WR_EN ;		//Delay WR_EN so a 1ns setup is enforced (CR124109)
wire #1 RD_EN_DLY = RD_EN ;		//Delay RD_EN so a 1ns setup is enforced (CR124109) 


	memory_v4	#(C_USE_BLOCKMEM,
		C_ENABLE_RLOCS,
		address_width, 		
		address_width, 		
		C_FIFO_DEPTH+1,
		C_FIFO_DEPTH+1, 	
		C_DATA_WIDTH,
		C_DATA_WIDTH    	
		)
	mem	(.d(DIN),
		.wa(write_address),
		.we(qualified_write_request),
		.wclk(WR_CLK),
		.re(qualified_read_enable),
		.rclk(RD_CLK),
		.ra(read_address),
		.q(DOUT)
		);
     
	fifoctlr_ns_v4	#(
		 	address_width,			
			address_width,			
			address_width,			
			C_ENABLE_RLOCS,
			C_HAS_ALMOST_FULL,
			C_HAS_ALMOST_EMPTY,
			C_HAS_WR_COUNT,
			C_WR_COUNT_WIDTH,
			C_HAS_RD_COUNT,
			C_RD_COUNT_WIDTH,
			C_HAS_RD_ACK,
			C_RD_ACK_LOW,
			C_HAS_RD_ERR,
			C_RD_ERR_LOW,
			C_HAS_WR_ACK,
			C_WR_ACK_LOW,
			C_HAS_WR_ERR,
			C_WR_ERR_LOW
			)
      control		(.fifo_reset_in(AINIT),
			.read_clock_in(RD_CLK),
			.write_clock_in(WR_CLK),
			.read_request_in(RD_EN_DLY),
			.write_request_in(WR_EN_DLY),
			.read_enable_out(qualified_read_enable), 
			.write_enable_out(qualified_write_request),
			.full_flag_out(FULL),
			.empty_flag_out(EMPTY),
			.almost_full_out(ALMOST_FULL),
			.almost_empty_out(ALMOST_EMPTY),
			.read_addr_out(read_address),
			.write_addr_out(write_address),
			.wrsync_count_out(WR_COUNT),
			.rdsync_count_out(RD_COUNT),
			.read_ack(RD_ACK),
			.read_error(RD_ERR),
			.write_ack(WR_ACK),
			.write_error(WR_ERR)
			);
		


endmodule
/* End Top Level async_fifo */









/* ***************************************************************************
 * Module 
 * **************************************************************************/
/*  Fifo Control Module. fifoctlr_ns.v */
module fifoctlr_ns_v4 (fifo_reset_in, read_clock_in, write_clock_in, read_request_in,
		write_request_in,  read_enable_out, write_enable_out, full_flag_out, 
		empty_flag_out, almost_full_out, almost_empty_out, read_addr_out, 
		write_addr_out, wrsync_count_out, rdsync_count_out, read_ack, 
		read_error, write_ack, write_error);


parameter width			=6;
parameter wr_width		=6;
parameter rd_width		=6;
parameter c_enable_rlocs	=1;
parameter c_has_almost_full	=1;
parameter c_has_almost_empty	=1;
parameter c_has_wrsync_dcount	=1;
parameter wrsync_dcount_width	=6;
parameter c_has_rdsync_dcount	=1;
parameter rdsync_dcount_width	=6;
parameter c_has_rd_ack		=1;
parameter c_rd_ack_low		=0;
parameter c_has_rd_error	=1;
parameter c_rd_error_low	=0;
parameter c_has_wr_ack		=1;
parameter c_wr_ack_low		=0;
parameter c_has_wr_error	=1;
parameter c_wr_error_low	=0;


input fifo_reset_in;
input read_clock_in;
input write_clock_in;
input read_request_in;
input write_request_in;
output read_enable_out;
output write_enable_out;
output full_flag_out;
output empty_flag_out;
output almost_full_out;
output almost_empty_out;
output [rd_width-1 : 0] read_addr_out;
output [wr_width-1 : 0] write_addr_out;
output [wrsync_dcount_width-1 : 0] wrsync_count_out;
output [rdsync_dcount_width-1  : 0] rdsync_count_out;
output read_ack;
output read_error;
output write_ack;
output write_error;

parameter no	= 0;
parameter yes	=1;

parameter greater_width = (wr_width > rd_width ) ? wr_width : rd_width;

wire gnd = 0;
wire vcc = 1;
wire reset;
wire rd_clk;
wire wr_clk;
wire rd_en;
wire rd_en_ram;
wire wr_en;
wire wr_en_ram;
wire full_flag;
wire almost_full;
wire rdsync_full_flag;
wire cond_full;
wire cond_full_less1;
wire cond_full_less2;
wire  empty_flag;
wire almost_empty;
wire cond_empty;
wire cond_empty_plus1;
wire cond_empty_plus2;
//wire wrsync_empty_pulse;    //removed 9-26-00 by jogden for CR 126807
wire [rd_width-1 : 0] rd_addr_bin;
wire [rd_width-1 : 0] rd_last_bin;
wire [rd_width-1 : 0] rd_last_gray;
wire [width-1 : 0] rd_last_trunc;
wire [width-1 : 0] rd_dly1_gray;
wire [width-1 : 0] rd_dly2_gray;
wire [rd_width-1 : 0] wrsync_rd_last_gray;
wire [rd_width-1 : 0] wrsync_rd_last_bin;
wire [wr_width-1 : 0] wr_addr_bin;
wire [wr_width-1 : 0] wr_last_bin;
wire [wr_width-1 : 0] wr_last_gray;
wire [width-1 : 0] wr_last_trunc;

wire [width-1 : 0] wr_dly1_gray;
wire [wr_width-1 : 0] rdsync_wr_last_gray;
wire [wr_width-1 : 0] rdsync_wr_last_bin;
wire [rdsync_dcount_width-1 : 0] rdsync_data_count;
wire [wrsync_dcount_width-1 : 0] wrsync_data_count;

wire fflag_comb;
wire eflag_comb;

wire read_error_low;
wire read_error_high;
wire read_ack_high;
wire read_ack_low;
wire almost_empty_temp;
wire write_error_low;
wire write_error_high;
wire write_ack_high;
wire write_ack_low;
wire almost_full_temp;
wire [wrsync_dcount_width-1 : 0] wrsync_data_count_temp;
wire [rdsync_dcount_width-1 : 0] rdsync_data_count_temp;
wire read_error;
wire write_error;
wire read_ack;
wire write_ack;


/*  Fifoctlr_ns functions */
parameter ascii_zero 		= 8'b00110000;
parameter ascii_one 		= 8'b00110001;
parameter zeros_width 		= {width{ascii_zero}}; 
parameter ones_width 		= {width{ascii_one}};
parameter gray_tc_width 	= {ascii_one,{(width-1){ascii_zero}}}; 
parameter tc_less1_width 	= {ascii_one,{(width-2){ascii_zero}},ascii_one}; 
parameter tc_less2_width 	= {{2{ascii_one}},{(width-3){ascii_zero}},ascii_one};
parameter tc_less3_width 	= {{3{ascii_one}},{(width-4){ascii_zero}},ascii_one};

/* End Fifoctlr_ns functions */


assign reset 		= fifo_reset_in;
assign rd_clk 		= read_clock_in;
assign wr_clk 		= write_clock_in;
assign read_enable_out 	= rd_en_ram;
assign write_enable_out = wr_en_ram;	
assign full_flag_out 	= full_flag;
assign empty_flag_out 	= empty_flag;
assign almost_full_out 	= almost_full;
assign almost_empty_out = almost_empty;
assign read_addr_out 	= rd_addr_bin;
assign write_addr_out 	= wr_addr_bin;
assign rdsync_count_out	= rdsync_data_count;	
assign wrsync_count_out = wrsync_data_count;


integer i;

assign rd_last_trunc = rd_last_gray[rd_width-1 : rd_width-width];
assign wr_last_trunc = wr_last_gray[wr_width-1 : wr_width-width];

and_a_notb_v4 #(c_enable_rlocs)
   rd_en_and (.a_in(read_request_in),
	      .b_in(empty_flag),
	      .and_out(rd_en)
	      );

and_a_notb_v4 #(c_enable_rlocs)
   rd_en_to_ram (.a_in(read_request_in),
		.b_in(empty_flag),
		.and_out(rd_en_ram)
		);
/*
----------------------------------------------------------------
--  Generate read handshake signals (ACK/ERROR) if requested
----------------------------------------------------------------	
*/

//	if (c_has_rd_error == 1 &&  c_rd_error_low == 0) begin  //rd_error_hi
		and_fd_v4 #("0",
			c_enable_rlocs)
		  rd_err_fd_hi (.a_in(read_request_in),
				.b_in(empty_flag),
				.clk(rd_clk),
				.rst(reset),
				.q_out(read_error_high)
				);
//	end //if rd_error_hi

//	if (c_has_rd_error == 1 && c_rd_error_low == 1)  begin //rd_error_lo
		nand_fd_v4 #("1",
			c_enable_rlocs)
		 rd_err_fd_lo (.a_in(read_request_in),
				.b_in(empty_flag),
				.clk(rd_clk),
				.rst(reset),
				.q_out(read_error_low)
				);
//	end //if rd_error_lo



//	if (c_has_rd_ack == 1 && c_rd_ack_low == 0) begin //rd_ack_hi
		and_a_notb_fd_v4 #("0",
				c_enable_rlocs)
		   rd_ack_fd_hi (.a_in(read_request_in),
				.b_in(empty_flag),
				.clk(rd_clk),
				.rst(reset),
				.q_out(read_ack_high)
				);
//	end // if 

//	if (c_has_rd_ack == 1 && c_rd_ack_low == 1) begin //rd_ack_lo
		nand_a_notb_fd_v4 #("1",		//CR124696

				c_enable_rlocs)
			rd_ack_fd_lo(.a_in(read_request_in),
				.b_in(empty_flag),
				.clk(rd_clk),
				.rst(reset),
				.q_out(read_ack_low)
				);
//	end //if rd_ack_lo





/*
----------------------------------------------------------------
--                                                            --
--  Generation of Read address pointers.  The primary one is  --
--  binary (rd_addr_bin), and the Gray-code derivatives are   --
--  generated via pipelining the binary-to-Gray-code result.  --
--  The initial values are important, so they're in sequence. --
--  Gray-code addresses are used so that the registered       --
--  Full and Empty flags are always clean, and never in an    --
--  unknown state due to the asynchonous relationship of the  --
--  Read and Write clocks.  In the worst case scenario, Full  --
--  and Empty would simply stay active one cycle longer, but  --
--  it would not generate an error or give false values.      --
--                                                            --
----------------------------------------------------------------
*/


	bcount_up_ainit_v4 #(rd_width,
			zeros_width, //changed to rd_width
			c_enable_rlocs
			)
	  rd_addr_counter (.init(reset),
			.cen(rd_en),
			.clk(rd_clk),
			.cnt(rd_addr_bin)
			);
 


	binary_to_gray_v4 #(rd_width,
			 gray_tc_width, //gray_tc_string(rd_width),
			c_enable_rlocs
			)
	   rd_last_gray_reg(.rst(reset),
				.clk(rd_clk),
				.cen(rd_en),
				.bin(rd_addr_bin),
				.gray(rd_last_gray)
				);
/*
---------------------------------------------------------------
--                                                           --
--  Empty flag is set on reset (initial), or when gray       --
--  code counters are equal, or when there is one word in    --
--  the FIFO, and a Read operation will be performed on the  --
--  next read clock					     --
--                                                           --
---------------------------------------------------------------
*/

	empty_flag_reg_v4 #(width,
			c_enable_rlocs)
	 empty_flag_logic (.rst(reset),
			.flag_clk(rd_clk),
			.flag_ce1(read_request_in),
			.flag_ce2(empty_flag),
			.reg_clk(wr_clk),
			.reg_ce ( wr_en),		
			.a_in(rd_last_trunc),
			.b_in(wr_last_trunc),
			.dlyd_out(wr_dly1_gray),
			.flag_out(empty_flag),
			.to_almost_logic(eflag_comb )       	
			);


/*
---------------------------------------------------------------
--                                                           --
--  Almost Empty flag is set on reset (initial). Or when the --
--  read gray code counter (rd_last_gray) is equal or one    --
--  behind the last write gray code address(wr_lasy_gray,    --
--  wr_dly1_gray). Or when the rd_last_gray is equal to      --
--  wr_dly2_gray and a read operation is about to be per-    --
--  formed. (Note that the next two process and              --
--  wr_dly2_gray_grey represent the overhead for this 	     --
--  function 			                             --
--                                                           --
---------------------------------------------------------------
*/

//	if (c_has_almost_empty == 1) begin //almost_empty_gen
		almst_empty_v4 #(width,
				c_enable_rlocs)
		  almst_empty_logic(.rst(reset),
					.flag_clk(rd_clk),
					.flag_ce(vcc),
					.reg_clk(wr_clk),
					.reg_ce(wr_en),
					.a_in(rd_last_trunc),
					.b_in(wr_dly1_gray),
					.rqst_in(read_request_in),
					.flag_comb_in(eflag_comb),
					.flag_q_in(empty_flag),
					.flag_out(almost_empty_temp)
					);
//	end //if almost_empty_gen
/*
----------------------------------------------------------------
--  wr_en <= (write_request_in AND NOT full_flag);
----------------------------------------------------------------
*/

	and_a_notb_v4 #(c_enable_rlocs)
	 wr_en_and (.a_in(write_request_in),
		    .b_in(full_flag),
		    .and_out(wr_en)
		   );
/*
----------------------------------------------------------------
--  wr_en_ram <= (write_request_in AND NOT full_flag);
--  This is a shadow of wr_en to reduce fanout for performance
----------------------------------------------------------------
*/

	and_a_notb_v4 #(c_enable_rlocs)
	   wr_en_to_ram (.a_in(write_request_in),
			.b_in(full_flag),
			.and_out(wr_en_ram)
			);
/*----------------------------------------------------------------
--  Generate write handshake signals (ACK/ERROR) if requested
----------------------------------------------------------------	
*/

//	if (c_has_wr_error == 1 && c_wr_error_low == 0) begin
		and_fd_v4 #("0",
			c_enable_rlocs)
		wr_error_fd_hi (.a_in(write_request_in),
				.b_in(full_flag),
				.clk(wr_clk),
				.rst(reset),
				.q_out(write_error_high)
				);
//	end // if
//	if (c_has_wr_error == 1 && c_wr_error_low == 1) begin // wr_eror_lo
		nand_fd_v4 #("1",
			c_enable_rlocs)
		  wr_error_fd_lo (.a_in(write_request_in),
				.b_in(full_flag),
				.clk(wr_clk),
				.rst(reset),
				.q_out(write_error_low)
				);
//	end // if wr_error_lo

//	if (c_has_wr_ack == 1 && c_wr_ack_low == 0)  begin //wr_ack_hi
		and_a_notb_fd_v4 #("0",
				c_enable_rlocs)
			wr_ack_fd_hi (.a_in(write_request_in),
				   .b_in(full_flag),
			  	   .clk(wr_clk),
				   .rst(reset),
				   .q_out(write_ack_high)
				);
//	end //if wr_ack_hi

//	if (c_has_wr_ack == 1 && c_wr_ack_low == 1)  begin  //wr_ack_lo
		nand_a_notb_fd_v4 #("1",			//CR124696
				c_enable_rlocs)
		  wr_ack_fd_lo (.a_in(write_request_in),
				.b_in(full_flag),
				.clk(wr_clk),
				.rst(reset),
				.q_out(write_ack_low)
				);
//	end // if wr_ack_lo

 
	bcount_up_ainit_v4 #(wr_width,
			zeros_width, //zero_string, //(wr_width),
			c_enable_rlocs)
	  wr_addr_counter (.init(reset),
				.cen(wr_en),
				.clk(wr_clk),
				.cnt(wr_addr_bin)
			);

	binary_to_gray_v4 #(wr_width,
			gray_tc_width, //gray_tc_string(wr_width),
			c_enable_rlocs)
		wr_last_gray_reg (.rst(reset),
				.clk(wr_clk),
				.cen(wr_en),
				.bin(wr_addr_bin),
				.gray(wr_last_gray)
				);

/*
---------------------------------------------------------------
--                                                           --
--  Full flag is set on reset (initial, but it is cleared    --
--  on the first valid write clock edge after reset is       --
--  de-asserted), or when Gray-code counters are one away    --
--  from being equal (the Write Gray-code address is equal   --
--  to the Last Read Gray-code address), or when the Next    --
--  Write Gray-code address is equal to the Last Read Gray-  --
--  code address, and a Write operation is about to be       --
--  performed.                                               --
--                                                           --
---------------------------------------------------------------
*/

	reg_ainit_v4 #(width,
		tc_less1_width, //gray_tc_less1(width),
		c_enable_rlocs)
	 rd_dly1_gray_reg (.rst(reset),
				.clk(rd_clk),
				.cen(rd_en),
				.din(rd_last_trunc),
				.qout(rd_dly1_gray)
				);
/*
---------------------------------------------------------------
--                                                           --
--  Almost Full flag is set on reset (initial, but it is     --
--  cleared on the first valid write clock edge after reset  --
--  is de-asserted). Or when the write Gray-code address     --
--  (wr_last_gray) is equal one behind the Last Read Gray-   --
--  code address(rd_dly1_gray, rd_dly2_gray). Or when the    --
--  write_last_gray is equal to rd_dly3_gray and a Write     --
--  operation is about to be performed. Note that the next   --
--  two process and rd_dly3_grag_reg represent the overhead  --
--  for this function.                                       --
--                                                           --
---------------------------------------------------------------
*/

//	if (c_has_almost_full == 1) begin //gen_almost_full
		almst_full_v4 #(width,
				c_enable_rlocs)
		  almst_full_logic (.rst(reset),
					.flag_clk(wr_clk),
					.flag_ce(vcc),
					.reg_clk(rd_clk),
					.reg_ce(rd_en),
					.a_in(wr_last_trunc),
					.b_in(rd_dly2_gray),
					.rqst_in(write_request_in),
					.flag_comb_in(fflag_comb),
					.flag_q_in(full_flag),
					.flag_out(almost_full_temp)
					);
//	end //if gen_almost_full

		full_flag_reg_v4 #(width,
				c_enable_rlocs)
		  full_flag_logic (.rst(reset),
					.flag_clk(wr_clk),
					.flag_ce1(write_request_in),
					.flag_ce2(full_flag),
					.reg_clk(rd_clk),
					.reg_ce(rd_en),
					.a_in(wr_last_trunc),
					.b_in(rd_dly1_gray),
					.dlyd_out(rd_dly2_gray),
					.flag_out(full_flag),
					.to_almost_logic(fflag_comb)
					);





/*
----------------------------------------------------------------
--                                                            --
--  Generation of data_count output.  data_count reflects how --
--  full FIFO is, based on how far the Write pointer is ahead --
--  of the Read pointer. data_count will lag true FIFO state  --
--  by a couple of clock cycles, if the enables are inactive  --
--  for a few cycles data_count will converge to match FIFO's --
--  data_count could be made synchronous to either clock      --
--  domain. The following code uses the write clock domain    --
--							      --
----------------------------------------------------------------
*/

//	if (c_has_wrsync_dcount == 1)  begin

reg_ainit_v4 #(wr_width,
	    ones_width, //ones_string_wr, //(wr_width),
	    c_enable_rlocs)
  wr_last_bin_reg  (.rst(reset),
		.clk(wr_clk),
		.cen(wr_en),
		.din(wr_addr_bin),
		.qout(wr_last_bin)
		);

reg_ainit_v4 #(rd_width,
	    gray_tc_width, // gray_tc_string(rd_width),
	    c_enable_rlocs)
 wrsync_rd_last_gray_reg (.rst(reset),
			   .clk(wr_clk),
			  .cen(vcc),
			  .din(rd_last_gray),
			  .qout(wrsync_rd_last_gray)
			 );

gray_to_binary_v4 #(rd_width,
		ones_width,		
		c_enable_rlocs)
 wrsync_rd_last_bin_reg (.bin_reg(wrsync_rd_last_bin),
			.grey_reg(wrsync_rd_last_gray),
			.reset(reset),
			.clk(wr_clk)
			);

/* ***************************************************************************
 * This block removed 09/26/00 by jogden to fix CR 126807 where empty flag
 *  was causing wr_count to reset.
 * **************************************************************************/
//pulse_reg_v4 wrsync_empty_pulse_fd (.sclr_in(wr_en),
//				.sset_in(empty_flag),
//				.clk(wr_clk),
//				.rst(reset),
//				.q_out(wrsync_empty_pulse)
//				);

count_sub_reg_v4 #(greater_width, 
		wr_width,
		rd_width,
		wrsync_dcount_width,
		c_enable_rlocs)
  wrsync_data_count_sub (.a_in(wr_last_bin),
			 .b_in(wrsync_rd_last_bin),
			 .clk(wr_clk),
			 .rst_a(reset),
 			 //.rst_b(wrsync_empty_pulse),
 			 .rst_b(gnd),  //Connection removed 9-26-00
                                       //by jogden to fix CR 126807
                                       //regarding empty_pulse 
                                       //resetting wrsync_data_count
			 .q_out(wrsync_data_count_temp)
			 );


//	end //if 
//------------------------------------------------------------//
//                                                            //
//  Generation of data_count output.  data_count reflects how //
//  full FIFO is, based on how far the Write pointer is ahead //
//  of the Read pointer. data_count will lag true FIFO state  //
//  by a couple of clock cycles, if the enables are inactive  //
//  for a few cycles data_count will converge to match FIFO's //
//  data_count could be made synchronous to either clock      //
//  domain. The following code uses the read clock domain     //
//							      //
//------------------------------------------------------------//




reg_ainit_v4 #(rd_width,
	    ones_width, 
	    c_enable_rlocs)
  rd_last_bin_reg  (.rst(reset),
		.clk(rd_clk),
		.cen(rd_en),
		.din(rd_addr_bin),
		.qout(rd_last_bin)
		);


reg_ainit_v4 #(wr_width,
	    gray_tc_width, 
	    c_enable_rlocs)
 rdsync_wr_last_gray_reg (.rst(reset),
			   .clk(rd_clk),
			  .cen(vcc),
			  .din(wr_last_gray),
			  .qout(rdsync_wr_last_gray)
			 );

gray_to_binary_v4 #(wr_width,
		ones_width, 
		c_enable_rlocs)
  rdsync_wr_last_bin_reg (.bin_reg(rdsync_wr_last_bin),
			  .grey_reg(rdsync_wr_last_gray),
			  .reset(reset),
			  .clk(rd_clk)
			 );
count_sub_reg_v4 #(greater_width, 
		wr_width,
		rd_width,
		rdsync_dcount_width,
		c_enable_rlocs)
 rdsync_data_count_sub(.a_in(rdsync_wr_last_bin),
			.b_in(rd_last_bin),
			.clk(rd_clk),
			.rst_a(reset),
			.rst_b(reset),
			.q_out(rdsync_data_count_temp)
			);

//------------------------------------------------------------//
//                                                            //
//  The four conditions decoded with special carry logic are  //
//  cond_empty, cond_empty_plus1, cond_full, cond_full_less1. //
//  These are used to determine the next state of the         //
//  Full/Empty flags.                                         //
//                                                            //
//  When the Write/Read Gray-code addresses are equal, the    //
//  FIFO is Empty, and cond_empty (combinatorial) is asserted.//
//  When the Write Gray-code address is equal to the Next     //
//  Read Gray-code address (1 word in the FIFO), then the     //
//  FIFO potentially could be going Empty (if rd_en is        //
//  asserted, which is used in the logic that generates the   //
//  registered version of Empty(empty_flag)).                 //
//                                                            //
//  Similarly, when the Write Gray-code address is equal to   //
//  the Last Read Gray-code address, the FIFO is full.  To    //
//  have utilized the full address space (512 addresses)      //
//  would have required extra logic to determine Full/Empty   //
//  on equal addresses, and this would have slowed down the   //
//  overall performance.  Lastly, when the Next Write Gray-   //
//  code address is equal to the Last Read Gray-code address  //
//  the FIFO is Almost Full, with only one word left, and     //
//  it is conditional on write_enable being asserted.         //
//                                                            //
//------------------------------------------------------------//


assign read_error = (c_has_rd_error == 0 )? 1'bX :c_rd_error_low? read_error_low : read_error_high;
assign read_ack = (c_has_rd_ack == 0 )? 1'bX :c_rd_ack_low? read_ack_low : read_ack_high;
assign almost_empty = (c_has_almost_empty == 0 )? 1'bX	: almost_empty_temp;
assign write_error = (c_has_wr_error == 0 )? 1'bX : c_wr_error_low? write_error_low : write_error_high;
assign write_ack = (c_has_wr_ack == 0 )? 1'bX : c_wr_ack_low ? write_ack_low : write_ack_high;
assign almost_full = (c_has_almost_full == 0 )? 1'bX : almost_full_temp;
assign wrsync_data_count = (c_has_wrsync_dcount == 0)? {wrsync_dcount_width{1'bX}} : wrsync_data_count_temp;
assign rdsync_data_count = (c_has_rdsync_dcount == 0)? {rdsync_dcount_width{1'bX}} :rdsync_data_count_temp;

endmodule 
/*  End Fifo Control Module. fifoctlr_ns.v */













/* ***************************************************************************
 * Module Memory
 * **************************************************************************/

module memory_v4 (d, wa, ra, we, wclk, re, rclk, q);

parameter use_blockmem 		=1;	//= c_use_blockmem;
parameter c_enable_rlocs	=0;	//= 0;
parameter address_width 	=6;	//= width;
parameter rd_addr_width 	=6;	//= width;
parameter depth         	=64; 	//= c_fifo_depth +1;
parameter rd_depth        	=64; 	//= c_fifo_depth +1;
parameter data_width    	=16;	//= c_data_width;
parameter rd_data_width    	=16;	//= c_data_width;


input [data_width-1 : 0] d;
input [address_width-1 : 0] wa;
input [rd_addr_width-1 : 0] ra;
input we;
input wclk;
input re;
input rclk;
output [rd_data_width-1 : 0] q;


wire port_enabled;
wire [data_width-1 : 0] sourceless;
wire [address_width-1 : 0] sourceless_addr;
wire [rd_data_width-1 : 0] sourceless_dib;
wire sourceless_net;
wire [data_width-1 : 0] spo_dummy;
wire [data_width-1 : 0] qspo_dummy;
wire [data_width-1 : 0] dpo_dummy;
wire [data_width-1 : 0] doa_dummy_a;
wire [data_width-1 : 0] doa_dummy_b;
wire qspo_rst_dummy;
wire qdpo_rst_dummy;
wire qspo_srst_dummy;
wire qdpo_srst_dummy;
wire [rd_data_width-1 : 0] dob_bmem_a;
wire [rd_data_width-1 : 0] dob_bmem_b;
wire [rd_data_width-1 : 0] q_dist_mem;



   
parameter zero = 8'b00110000;  //ascii 0

parameter default_data = {data_width{zero}};
parameter default_rd_data = {rd_data_width{zero}};

assign sourceless_net = 0;
assign port_enabled = 1;
assign sourceless_dib = {data_width-1{zero}};
assign sourceless_addr = {address_width{zero}};


/* ***************************************************************************
 * Modified 9/26/00 by jogden
 *   Changed the block memory to blkmemdp_v4_0
 * **************************************************************************/
   wire 		   unconnected_port;
   wire [data_width-1 : 0] unconnected_douta;
   wire [rd_data_width-1 : 0] unconnected_dinb;
   wire 		   unconnected_ena;
   wire 		   unconnected_nda;
   wire 		   unconnected_ndb;
   wire 		   unconnected_sinita;
   wire 		   unconnected_sinitb;
   wire 		   unconnected_web;

   assign unconnected_dinb = {rd_data_width{zero}};
   assign unconnected_ena = 1'b1;
   assign unconnected_sinita = 1'b0;
   assign unconnected_sinitb = 1'b0;
   assign unconnected_web = 1'b0;
   

BLKMEMDP_V4_0 #(
	        address_width,      //c_addra_width
	        rd_addr_width,      //c_addrb_width
		default_data,       //c_default_data
		depth,              //c_depth_a
		rd_depth,           //c_depth_b
		0,                  //c_enable_rlocs
		1,                  //c_has_default_data
		1,                  //c_has_dina
		0,                  //c_has_dinb
		0,                  //c_has_douta
		1,                  //c_has_doutb
		0,                  //c_has_ena
		1,                  //c_has_enb
		0,                  //c_has_limit_data_pitch
		0,                  //c_has_nda
		0,                  //c_has_ndb
		0,                  //c_has_rdya
		0,                  //c_has_rdyb
		0,                  //c_has_rfda
		0,                  //c_has_rfdb
		0,                  //c_has_sinita
		0,                  //c_has_sinitb
		1,                  //c_has_wea
		0,                  //c_has_web
		18,                 //c_limit_data_pitch
                "null.mif" ,
		0,                  //c_pipe_stages_a
		0,                  //c_pipe_stages_b
		0,                  //c_reg_inputsa
		0,                  //c_reg_inputsb
		default_data,       //c_sinita_value
		default_data,       //c_sinitb_value
		data_width,         //c_width_a
		rd_data_width,      //c_width_b
		2,                  //c_write_modea
		2                   //c_write_modeb
               )
	bmem_a		(.ADDRA(wa),
        		.ADDRB(ra),
        		.CLKA(wclk),
        		.CLKB(rclk),
       			.DINA(d),
        		.DINB(sourceless_dib),
        		.DOUTA(unconnected_douta),
			.DOUTB(dob_bmem_a),
        		.ENA(unconnected_ena),
        		.ENB(re),
                        .NDA(unconnected_nda),
			.NDB(unconnected_ndb),
			.RDYA(unconnected_port),
			.RDYB(unconnected_port),
			.RFDA(unconnected_port),
			.RFDB(unconnected_port),
			.SINITA(unconnected_sinita),
			.SINITB(unconnected_sinitb),
        		.WEA(we),
        		.WEB(unconnected_web)
			);
   
/*
blkmem1: IF (use_blockmem AND (address_width >= rd_addr_width)) GENERATE
*/
/*
   C_MEM_DP_BLOCK_V1_0	#(
            		address_width,
           		rd_addr_width,
            		1,
            		1,
           		default_data, 
           		depth,
			rd_depth,
			1,
            		1,
            		0,
            		1,
            		1,
            		0,
           		1,
            		1,
            		1,
            		0,
            		0,
            		1,
            		1,		
            		"null.mif",
            		2,
            		0,
            		0,
            		1,
            		1,
            		1,
            		1,
            		data_width,
            		rd_data_width
			)
	bmem_a		(.ADDRA(wa),
        		.ADDRB(ra),
       			.DIA(d),
        		.DIB(sourceless_dib),
        		.CLKA(wclk),
        		.CLKB(rclk),
        		.WEA(we),
        		.WEB(sourceless_net), 
        		.ENA(port_enabled),
        		.ENB(re),
        		.RSTA(sourceless_net),
        		.RSTB(sourceless_net),
        		.DOA(doa_dummy_a),
			.DOB(dob_bmem_a)
			);

*/

/*
blkmen2:IF (use_blockmem AND (address_width < rd_addr_width)) GENERATE
--Swap all the ports (because depth of A port must be >= depth of B port)? 
--Only needed for the non-symmetric data port case
*/

/*
   
   C_MEM_DP_BLOCK_V1_0	#(
            		address_width,
           		rd_addr_width,
            		1,
            		1,
           		default_rd_data, 
           		rd_depth,
			depth,
			1,
            		1,
            		0,
            		1,
            		1,
            		0,
           		1,
            		1,
            		1,
            		0,
            		0,
            		1,
            		1,		
            		"null.mif",
            		2,
            		0,
            		0,
            		1,
            		1,
            		1,
            		1,
            		rd_data_width,
            		data_width
			)
	bmem_b		(.ADDRA(ra),
        		.ADDRB(wa),
       			.DIA(sourceless_dib),
        		.DIB(d),
        		.CLKA(rclk),
        		.CLKB(wclk),
        		.WEA(sourceless_net),
        		.WEB(we), 
        		.ENA(re),
        		.ENB(port_enabled),
        		.RSTA(sourceless_net),
        		.RSTB(sourceless_net),
        		.DOA(dob_bmem_b),
			.DOB(doa_dummy_b)
			);
*/


/* ***************************************************************************
 * END OF BLOCK MEMORY MODIFICATION (by jogden 9/26/00)
 * **************************************************************************/

   

   
   C_DIST_MEM_V5_0	#(
                        address_width, //C_ADDR_WIDTH
			default_data, //C_DEFAULT_DATA
			2,	//C_DEFAULT_DATA_RADIX
			depth,  //C_DEPTH
			1,      //C_ENABLE_RLOCS
			0,      //C_GENERATE_MIF
			1,      //C_HAS_CLK
			1,  	//C_HAS_D
			0,      //C_HAS_DPO
			1,      //C_HAS_DPRA
			0,  	//C_HAS_I_CE
			1,      //C_HAS_QDPO
			1,      //C_HAS_QDPO_CE
			1,      //C_HAS_QDPO_CLK
			0,  	//C_HAS_QDPO_RST
			0,      //C_HAS_QDPO_SRST --new in V4
			1,  	//C_HAS_QSPO
			1,      //C_HAS_QSPO_CE
			0,  	//C_HAS_QSPO_RST
			0,      //C_HAS_QSPO_SRST --new in V4
			0,  	//C_HAS_RD_EN
			0,      //C_HAS_SPO
			0,      //C_HAS_SPRA
			1,      //C_HAS_WE
			0,      //C_LATENCY --new in V4
			"",	//C_MEM_INIT_FILE
			//2,      //C_MEM_INIT_RADIX  --removed in V4
			2,      //C_MEM_TYPE
			0,      //C_MUX_TYPE
			0,//1,      //C_QUALIFY_WE
			0,      //C_QCE_JOINED
			0,      //C_READ_MIF
			0,      //C_REG_A_D_INPUTS
			0,      //C_REG_DPRA_INPUT
			0,      //C_SYNC_ENABLE --new in V4
			data_width //C_WIDTH
			//2      //C_RAM32_FIX --new in V4
			)
	dist_mem	(
			//Inputs
                        .A(wa),		        //spec_size
			.CLK(wclk),			
			.D(d),			//C_WIDTH
			.DPRA(ra),		//C_ADDR_WIDTH
			.I_CE(sourceless_net),		
			.QDPO_CE(re),
			.QDPO_CLK(rclk),		
			.QDPO_RST(qdpo_rst_dummy), //new in V4
                        .QDPO_SRST(qdpo_srst_dummy), //new in V4
			.QSPO_CE(sourceless_net),	
			.QSPO_RST(qspo_rst_dummy), //new in V4
                        .QSPO_SRST(qspo_srst_dummy), //new in V4
			.RD_EN(sourceless_net),		
			.SPRA(sourceless_addr),	//C_ADDR_WIDTH
			.WE(we),			
			//Outputs
			.DPO(dpo_dummy),	//C_WIDTH
			.SPO(spo_dummy),	//C_WIDTH
			.QDPO(q_dist_mem),	//C_WIDTH
			.QSPO(qspo_dummy)       //C_WIDTH
			);



assign q = use_blockmem ? (address_width >= rd_addr_width ? dob_bmem_a : dob_bmem_b) : q_dist_mem;


endmodule
               /* End Memory Module */







/* ***************************************************************************
 * Module bcount up
 * **************************************************************************/
     /* Binary Counter Module. bcount_up_ainit.v */
module bcount_up_ainit_v4	(init, cen, clk, cnt);


parameter cnt_size	= 6;
parameter init_val	="000000";
parameter c_enable_rlocs=1;

wire gnd = 1'b0;
wire vcc = 1'b1;
parameter no	=0;
parameter yes	=1;
wire unused_1 = 1'b0;
wire unused_2 = 1'b0;
wire unused_3 = 1'b0;
wire unused_4 = 1'b0;
wire [cnt_size-1 : 0] dummy_val;


input init;
input cen;
input clk;
output [cnt_size-1 : 0] cnt;

C_COUNTER_BINARY_V4_0 #(init_val,//C_AINIT_VAL
			"1",//C_COUNT_BY
		0,//C_COUNT_MODE
			init_val,//C_COUNT_TO
			c_enable_rlocs,//C_ENABLE_RLOCS
			no,//C_HAS_ACLR
			yes,//C_HAS_AINIT
			no,//C_HAS_ASET
			yes,//C_HAS_CE
			no,//C_HAS_IV
			no,//C_HAS_L
			no,//C_HAS_LOAD
			no,//C_HAS_Q_THRESH0
			no,//C_HAS_Q_THRESH1
			no,//C_HAS_SCLR
			no,//C_HAS_SINIT
			no,//C_HAS_SSET
			no,//C_HAS_THRESH0
			no,//C_HAS_THRESH1
			no,//C_HAS_UP
			0,//C_LOAD_ENABLE
			0,//C_LOAD_LOW
			1,//C_PIPE_STAGES
			0,//C_RESTRICT_COUNT
			init_val,//C_SINIT_VAL
			1,//C_SYNC_ENABLE
			1,//C_SYNC_PRIORITY
			init_val,//C_THRESH0_VALUE
			init_val,//C_THRESH1_VALUE
			0,//C_THRESH_EARLY
			cnt_size//C_WIDTH
			)

	count_bin	(
			.CLK(clk),
			.UP(vcc),
			.CE(cen),
			.LOAD(gnd),
			.L(dummy_val),
			.IV(dummy_val),
			.ACLR(gnd),
			.ASET(gnd),
			.AINIT(init),
			.SCLR(gnd),
			.SSET(gnd),
			.SINIT(gnd),
			.THRESH0(unused_1),
			.Q_THRESH0(unused_2),
			.THRESH1(unused_3),
			.Q_THRESH1(unused_4),
                        .Q(cnt)
			);

endmodule


/* ***************************************************************************
 * Module Behavioral description of binary_to_gray
 * **************************************************************************/
module binary_to_gray_v4 (rst, clk, cen, bin, gray);

parameter reg_size = 6;
parameter init_val = "";
parameter c_enable_rlocs = 1;

input rst;
input clk;
input cen;
input [reg_size-1:0] bin;
output [reg_size-1:0] gray;

reg [reg_size-1:0] AIV;
reg [reg_size-1:0] gray;


initial 
begin
	AIV = to_bits(init_val);
end
	

always @(posedge clk or posedge rst)
begin
if (rst == 1'b1)
		gray =  AIV;
else if (cen == 1'b1)
	begin : loop
	integer i;
		for (i=0; i<=reg_size-1; i=i+1)
		if (i == reg_size-1)	
			gray[i] = bin[i];
		else
			gray[i] = bin[i+1] ^ bin[i];		
	end
end

	
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
					$display("Error in module %m at time %dns: non-binary digit in string \"%s\"\nExiting simulation...", $time, instring);
					$finish;
				end
			end
		end 
	end
	endfunction

endmodule
/* End Behavioral Description of Binary To Gray Module */


/* ***************************************************************************
 * Module Equality Comparator Module (eq_compare.v)
 * **************************************************************************/
module eq_compare_v4 (a, b, eq);

parameter c_width	=6;
parameter c_enable_rlocs=1;

input [c_width-1 : 0] a;
input [c_width-1 : 0] b;
output eq;

wire gnd = 1'b0;
wire vcc = 1'b1;
parameter no	=0;
parameter yes	=1;
parameter zero=1'b0;
parameter dummy_val={c_width-1{zero}};


wire dummy_out_1;
wire dummy_out_2;
wire dummy_out_3;
wire dummy_out_4;
wire dummy_out_5;
wire dummy_out_6;
wire dummy_out_7;
wire dummy_out_8;
wire dummy_out_9;
wire dummy_out_10;
wire dummy_out_11;

C_COMPARE_V4_0 #( "",     //C_AINIT_VAL
		no,	  //C_B_CONSTANT
		dummy_val,		//C_B_VALUE
		1,			//C_DATA_TYPE
		c_enable_rlocs,		//C_ENABLE_RLOCS
		no,			//C_HAS_ACLR
		no,			//C_HAS_ASET
		yes,			//C_HAS_A_EQ_B
		no,			//C_HAS_A_GE_B
		no,			//C_HAS_A_GT_B
		no,			//C_HAS_A_LE_B
		no,			//C_HAS_A_LT_B
		no,			//C_HAS_A_NE_B
		no,			//C_HAS_CE
		no,			//C_HAS_QA_EQ_B
		no,			//C_HAS_QA_GE_B
		no,			//C_HAS_QA_GT_B
		no,			//C_HAS_QA_LE_B
		no,			//C_HAS_QA_LT_B
		no,			//C_HAS_QA_NE_B
		no,			//C_HAS_SCLR
		no,			//C_HAS_SSET
		1,			//C_PIPE_STAGES
		1,			//C_SYNC_ENABLE
		1,			//C_SYNC_PRIORITY
		c_width)		//C_WIDTH

  eq_comp	(.A(a),
		.B(b),
		.A_EQ_B(eq),
		.CLK(gnd),
		.CE(gnd),
		.ACLR(gnd),
		.ASET(gnd),
		.SCLR(gnd),
		.SSET(gnd),
		.A_GT_B(dummy_out_1),
		.A_GE_B(dummy_out_2),
		.A_LT_B(dummy_out_3),
		.A_LE_B(dummy_out_4),
		.A_NE_B(dummy_out_5),
		.QA_GT_B(dummy_out_6),
		.QA_GE_B(dummy_out_7),
		.QA_LT_B(dummy_out_8),
		.QA_LE_B(dummy_out_9),
		.QA_EQ_B(dummy_out_10),
		.QA_NE_B(dummy_out_11)
		);

endmodule
/* End Equality Comparator Module */


/* ***************************************************************************
 * Module reg_ainit.v
 * **************************************************************************/
module reg_ainit_v4 (rst, clk, cen, din, qout);

parameter reg_size	=6;
parameter init_val	="000000";
parameter c_enable_rlocs=1;

input rst;
input clk;
input cen;
input [reg_size-1 : 0] din;
output [reg_size-1 :0] qout;

parameter no	=0;
parameter yes	=1;
wire gnd = 1'b0;
wire vcc = 1'b1;

C_REG_FD_V4_0 #(init_val,      //C_AINIT_VAL
		c_enable_rlocs,//C_ENABLE_RLOCS
		no,            //C_HAS_ACLR
		yes,           //C_HAS_AINIT
		no,            //C_HAS_ASET
		yes,           //C_HAS_CE
		no,            //C_HAS_SCLR
		no,            //C_HAS_SINIT
		no,            //C_HAS_SSET
		init_val,      //C_SINIT_VAL
		1,             //C_SYNC_ENABLE
		1,             //C_SYNC_PRIORITY
		reg_size)      //C_WIDTH
   reg_fd	(.D(din),
		.Q(qout),
		.CLK(clk),
		.CE(cen),
		.ACLR(gnd),
		.ASET(gnd),
		.AINIT(rst),
		.SCLR(gnd),
		.SSET(gnd),
		.SINIT(gnd)
		);
endmodule
/* End reg_ainit.v */





/* ***************************************************************************
 * Module 
 * **************************************************************************/
/* Behavioral Model of and_a_notb */
module and_a_notb_v4 (a_in, b_in, and_out);

parameter c_enable_rlocs	=1;
input a_in;
input b_in;
output and_out;

assign and_out = a_in & !b_in;

endmodule
/* End Behavioral of and_a_notb */


/* ***************************************************************************
 * Module 
 * **************************************************************************/
/* and_a_notb_fd */
module and_a_notb_fd_v4 (a_in, b_in, clk, rst, q_out);

parameter init_val	="0";
parameter c_enable_rlocs	= 1;

input a_in;
input b_in;
input clk;
input rst;
output q_out;

parameter no	=0;
parameter yes	=1;

wire vcc = 1'b1;
wire fake_in =0;
wire fake_out;
wire [1 : 0] and_in;

assign and_in = {b_in, a_in};

C_GATE_BIT_V4_0 #(init_val,     //C_AINIT_VAL
		 c_enable_rlocs,//C_ENABLE_RLOCS
		  0,            //C_GATE_TYPE
		  no,           //C_HAS_ACLR
		  yes,          //C_HAS_AINIT
		  no,           //C_HAS_ASET
		  no,           //C_HAS_CE
		  no,           //C_HAS_O
		  yes,          //C_HAS_Q
		  no,           //C_HAS_SCLR
		  no,           //C_HAS_SINIT
		  no,           //C_HAS_SSET
		  2,            //C_INPUTS
		  "10",         //C_INPUT_INV_MASK
		  1,  		//C_PIPE_STAGES
		  "0", 	        //C_SINIT_VAL
		  0,            //C_SYNC_ENABLE	
		  1             //C_SYNC_PRIORITY	
		)
  and_fd	(.I(and_in),
		.O(fake_out),
		.CLK(clk),
		.Q(q_out),
		.CE(vcc),
		.AINIT(rst),
		.ASET(fake_in),
		.ACLR(fake_in),
		.SINIT(fake_in),
		.SSET(fake_in),
		.SCLR(fake_in)
		);

endmodule
/* End and_a_notb_fd */

	
/* ***************************************************************************
 * Module 
 * **************************************************************************/
/* nand_a_notb_fd */
module nand_a_notb_fd_v4 (a_in, b_in, clk, rst, q_out);

parameter init_val	="0";
parameter no	=0;
parameter yes	=1;

input a_in;
input b_in;
input clk;
input rst;
output q_out;

wire vcc =1;
wire fake_in =0;
wire fake_out;
wire [1 : 0] nand_in;

assign nand_in = {b_in, a_in};

C_GATE_BIT_V4_0 #(init_val,//C_AINIT_VAL
		  yes,     //C_ENABLE_RLOCS
		  1,       //C_GATE_TYPE
		  no,      //C_HAS_ACLR
		  yes,     //C_HAS_AINIT
		  no,      //C_HAS_ASET
		  no,      //C_HAS_CE
		  no,      //C_HAS_O
		  yes,     //C_HAS_Q
		  no,      //C_HAS_SCLR
		  no,      //C_HAS_SINIT
		  no,      //C_HAS_SSET
		  2,       //C_INPUTS
		  "10",    // C_INPUT_INV_MASK
		  1,       //C_PIPE_STAGES
		  "0",     //C_SINIT_VAL
		  0,       //C_SYNC_ENABLE
		  1        //C_SYNC_PRIORITY
		 )
  nand_fd	(.I(nand_in),
		.O(fake_out),
		.CLK(clk),
		.Q(q_out),
		.CE(vcc),
		.AINIT(rst),
		.ASET(fake_in),
		.ACLR(fake_in),
		.SINIT(fake_in),
		.SSET(fake_in),
		.SCLR(fake_in)
		);
endmodule
/* end nand_a_notb_fd */

	
/* ***************************************************************************
 * Module 
 * **************************************************************************/
/* Behavioral Model of and_a_b_notc */
module and_a_b_notc_v4 (a_in, b_in, c_in, and_out);

input a_in;
input b_in;
input c_in;
output and_out;


wire and_out = a_in & b_in & !c_in;

endmodule
/* End Behavioral of end and_a_b_notc */

	
/* ***************************************************************************
 * Module 
 * **************************************************************************/
/* Behavioral Model of and_a_b_c_notd */
module and_a_b_c_notd_v4 (a_in, b_in, c_in, d_in, and_out);

input a_in;
input b_in;
input c_in;
input d_in;
output and_out;

wire and_out = a_in & b_in & c_in & !d_in;

endmodule
/* End Behavioral Model of and_a_b_c_notd */

/* ***************************************************************************
 * Module 
 * **************************************************************************/
	/* or_fd */
module or_fd_v4 (a_in, b_in, clk, rst, q_out);

parameter init_val	="0";

input a_in;
input b_in;
input clk;
input rst;
output q_out;

parameter no	=0;
parameter yes	=1;

wire vcc = 1'b1;
wire fake_in =0;
wire fake_out;
wire [1 : 0] or_in;

assign or_in = {b_in, a_in};

C_GATE_BIT_V4_0 #(init_val,//C_AINIT_VAL
		  yes,       //C_ENABLE_RLOCS
		  2,         //C_GATE_TYPE
		  no,        //C_HAS_ACLR
		  yes,       //C_HAS_AINIT
		  no,        //C_HAS_ASET
		  no,        //C_HAS_CE
		  no,        //C_HAS_O
		  yes,       //C_HAS_Q
		  no,        //C_HAS_SCLR
		  no,        //C_HAS_SINIT
		  no,        //C_HAS_SSET
		  2,         //C_INPUTS
		  "00",      //C_INPUT_INV_MASK
		  1,         //C_PIPE_STAGES
		  "0",       //C_SINIT_VAL
		  0,         //C_SYNC_ENABLE
		  1          //C_SYNC_PRIORITY
		  )
 or_fd   	(.I(or_in),
		.O(fake_out),
		.CLK(clk),
		.Q(q_out),
		.CE(vcc),
		.AINIT(rst),
		.ASET(fake_in),
		.ACLR(fake_in),
		.SINIT(fake_in),
		.SSET(fake_in),
		.SCLR(fake_in)
		);
endmodule
/* end or_fd */


/* ***************************************************************************
 * Module 
 * **************************************************************************/
/* and_fd */
module and_fd_v4 (a_in, b_in, clk, rst, q_out);

parameter init_val	="0";
parameter c_enable_rlocs	=1;

input a_in;
input b_in;
input clk;
input rst;
output q_out;

parameter no	=0;
parameter yes	=1;

wire vcc = 1'b1;
wire fake_in =0;
wire fake_out;
wire [1 : 0] and_in;

assign and_in = {b_in, a_in};

C_GATE_BIT_V4_0 #(init_val,       //C_AINIT_VAL
		  c_enable_rlocs, //C_ENABLE_RLOCS
		  0,              //C_GATE_TYPE
		  no,             //C_HAS_ACLR
		  yes,            //C_HAS_AINIT
		  no,             //C_HAS_ASET
		  no,             //C_HAS_CE
		  no,             //C_HAS_O
		  yes,            //C_HAS_Q
		  no,             //C_HAS_SCLR
		  no,             //C_HAS_SINIT
		  no,             //C_HAS_SSET
		  2,              //C_INPUTS
		  "00",           //C_INPUT_INV_MASK 
		  1,              //C_PIPE_STAGES
		  "0",            //C_SINIT_VAL
		   0,             //C_SYNC_ENABLE
		  1              //C_SYNC_PRIORITY
		 )
 and_fd   	(.I(and_in),
		.O(fake_out),
		.CLK(clk),
		.Q(q_out),
		.CE(vcc),
		.AINIT(rst),
		.ASET(fake_in),
		.ACLR(fake_in),
		.SINIT(fake_in),
		.SSET(fake_in),
		.SCLR(fake_in)
		);

endmodule
/* end and_fd */


/* ***************************************************************************
 * Module 
 * **************************************************************************/
/* nand_fd */
module nand_fd_v4 (a_in, b_in, clk, rst, q_out);

parameter init_val	="0";
parameter c_enable_rlocs	=1;

input a_in;
input b_in;
input clk;
input rst;
output q_out;

parameter no	=0;
parameter yes	=1;

wire vcc= 1'b1;
wire fake_in=0;
wire fake_out;
wire [1 : 0] nand_in;

assign nand_in = {b_in, a_in};


C_GATE_BIT_V4_0 #(init_val,      //C_AINIT_VAL
		  c_enable_rlocs,//C_ENABLE_RLOCS
		  1,             //C_GATE_TYPE
		  no,            //C_HAS_ACLR
		  yes,           //C_HAS_AINIT
		  no,            //C_HAS_ASET
		  no,            //C_HAS_CE
		  no,            //C_HAS_O
		  yes,           //C_HAS_Q
		  no,            //C_HAS_SCLR
		  no,            //C_HAS_SINIT
		  no,            //C_HAS_SSET
		  2,             //C_INPUTS
		  "00",          //C_INPUT_INV_MASK
		  1,             //C_PIPE_STAGES
		  "0",           //C_SINIT_VAL
		  0,             //C_SYNC_ENABLE
		  1              //C_SYNC_PRIORITY
		 )
 nand_fd   	(.I(nand_in),
		.O(fake_out),
		.CLK(clk),
		.Q(q_out),
		.CE(vcc),
		.AINIT(rst),
		.ASET(fake_in),
		.ACLR(fake_in),
		.SINIT(fake_in),
		.SSET(fake_in),
		.SCLR(fake_in)
		);
   
endmodule
/* end nand_fd */



/* ***************************************************************************
 * Module 
 * **************************************************************************/
/* almost_reg */
module almost_reg_v4 (a_in, b_in, c_in, d_in, clk, rst, q_out);

parameter init_val	="0";

input a_in;
input b_in;
input c_in;
input d_in;
input clk;
input rst;
output q_out;

and_a_b_v4 and_gate (.a_in(c_in),
		.b_in(d_in),
		.and_out(and_out)
		);

or3_fd_v4 #(init_val)
 or3_reg (.a_in(a_in),
	.b_in(b_in),
	.c_in(and_out),
	.clk(clk),
	.rst(rst),
	.q_out(q_out)
	);

endmodule
/* end almost_reg */



/* ***************************************************************************
 * Module 
 * **************************************************************************/
/* and_a_b.v */
module and_a_b_v4 (a_in, b_in, and_out);

input a_in;
input b_in;
output and_out;

parameter no	=0;
parameter yes	=1;
wire fake_in = 0;
wire fake_out;
wire [1: 0] and_in = {a_in, b_in};

C_GATE_BIT_V4_0 #("0",   //C_AINIT_VAL
		  0,     //C_ENABLE_RLOCS
		  0,     //C_GATE_TYPE
		  no,    //C_HAS_ACLR
		  no,    //C_HAS_AINIT
		  no,    //C_HAS_ASET
		  no,    //C_HAS_CE
		  yes,   //C_HAS_O
		  no,    //C_HAS_Q
		  no,    //C_HAS_SCLR
		  no,    //C_HAS_SINIT
		  no,    //C_HAS_SSET
		  2,     //C_INPUTS
		  "00",  //C_INPUT_INV_MASK
		  0,     //C_PIPE_STAGES
		  "0",   //C_SINIT_VAL
		  0,     //C_SYNC_ENABLE
		  1)     //C_SYNC_PRIORITY

 and_a_b	(.I(and_in),
		.O(and_out),
		.CLK(fake_in),
		.Q(fake_out),
		.CE(fake_in),
		.AINIT(fake_in),
		.ASET(fake_in),
		.ACLR(fake_in),
		.SINIT(fake_in),
		.SSET(fake_in),
		.SCLR(fake_in)
		);

endmodule
/* End and_a_b.v */



/* ***************************************************************************
 * Module 
 * **************************************************************************/
/* or3_fd */
module or3_fd_v4 (a_in, b_in, c_in, clk, rst, q_out);

parameter init_val	="0";

input a_in;
input b_in;
input c_in;
input clk;
input rst;
output q_out;

parameter no	=0;
parameter yes	=1;

wire vcc = 1'b1;
wire fake_in =0;
wire fake_out;
wire [2 : 0] or_in;

assign or_in = {a_in, b_in, c_in};


C_GATE_BIT_V4_0 #(init_val,//C_AINIT_VAL
		  yes,     //C_ENABLE_RLOCS
		  2,       //C_GATE_TYPE
		  no,      //C_HAS_ACLR
		  yes,     //C_HAS_AINIT
		  no,      //C_HAS_ASET
		  no,      //C_HAS_CE
		  no,      //C_HAS_O
		  yes,     //C_HAS_Q
		  no,      //C_HAS_SCLR
		  no,      //C_HAS_SINIT
		  no,      //C_HAS_SSET
		  3,       //C_INPUTS
		  "000",   //C_INPUT_INV_MASK
		  1,       //C_PIPE_STAGES
		  "0",     //C_SINIT_VAL
		  0,       //C_SYNC_ENABLE
		  1        //C_SYNC_PRIORITY
		)
 or3_fd   	(.I(or_in),
		.O(fake_out),
		.CLK(clk),
		.Q(q_out),
		.CE(vcc),
		.AINIT(rst),
		.ASET(fake_in),
		.ACLR(fake_in),
		.SINIT(fake_in),
		.SSET(fake_in),
		.SCLR(fake_in)
		);
   
endmodule
/* end or3_fd */




	
/* ***************************************************************************
 * Module 
 * **************************************************************************/
/*count_sub_reg */
module count_sub_reg_v4 (a_in, b_in, clk, rst_a, rst_b, q_out);

parameter width		=6;
parameter a_width	=6;
parameter b_width	=6;
parameter q_width	=2;
parameter c_enable_rlocs=1;

input [a_width-1 : 0] a_in;
input [b_width-1 : 0] b_in;
input clk;
input rst_a;
input rst_b;
output [q_width-1 : 0] q_out;

parameter no	=0;
parameter yes	=1;
parameter zero	=1'b0;
parameter zerostring	={(width+1){zero}};
parameter initstring	={q_width{zero}};

parameter a_pad	=width-a_width;
parameter b_pad	=width-b_width;

wire dummy_in =0;
wire [q_width-1 : 0] load_0;
wire load_1;
wire load_2;
wire load_3;
wire load_4;
wire load_5;
wire load_6;
wire reset;
wire [width : 0] a;
wire [width : 0] b;
wire [q_width-1 : 0] addsub_out;
wire gnd = 1'b0;
wire vcc = 1'b1;
wire [q_width-1 : 0] q_out = addsub_out;

integer i;

assign a = {vcc, a_in} ;
assign b = {gnd, b_in};

 C_ADDSUB_V4_0 #(1, 		
		initstring, 	
		1,  		
		width +1, 	
		no,    		
		no,		
		no,		
		1,		
		zerostring, 	
		width +1,
		c_enable_rlocs,
		no,  		
		no,
		yes,
		no, 		
		no,
		no,
		no,
		no,
		no,
		no,
		no,
		no,
		no,
		yes, 		
		no,
		no,
		no,
		no,
		no,
		no,
		no,
		width-1,
                1,              // Add this for C_LATENCY in version 3, robertle
		width-q_width,
		width+1,
		1,
		initstring,
		1,
		1) 		
  count_sub_reg		(.A(a),
		.B(b),
		.Q(addsub_out),
		.S(load_0),
		.CLK(clk),
		.ADD(dummy_in),
		.OVFL(load_1),
		.Q_OVFL(load_2),
		.C_IN(dummy_in),
		.C_OUT(load_3),
		.Q_C_OUT(load_4),
		.B_IN(dummy_in),
		.B_OUT(load_5),
		.Q_B_OUT(load_6),
		.CE(dummy_in),
		.BYPASS(dummy_in),
		.A_SIGNED(dummy_in),
		.B_SIGNED(dummy_in),
		.ACLR(dummy_in),
		.ASET(dummy_in),
		.AINIT(reset),
		.SCLR(dummy_in),
		.SSET(dummy_in),
		.SINIT(dummy_in)
		);

or_a_b_v4 or_gate (.a_in(rst_a),
		.b_in(rst_b),
		.or_out(reset)
		);
endmodule
/* end count_sub_reg */


/* ***************************************************************************
 * Module 
 * **************************************************************************/
/* Behvioral Model of or_a_b.v */
module or_a_b_v4 (a_in, b_in, or_out);

input a_in;
input b_in;
output or_out;

wire or_out = a_in | b_in;

endmodule
/* End Behavioral of or_a_b.v */


/* ***************************************************************************
 * This block removed 09/26/00 by jogden to fix CR 126807 where empty flag
 *  was causing wr_count to reset.
 * **************************************************************************/

 /* pulse_reg  */

//module pulse_reg_v4 (sclr_in, sset_in, clk, rst, q_out);
//
//input sclr_in;
//input sset_in;
//input clk;
//input rst;
//output q_out;
//
//wire gnd = 1'b0;
//wire vcc = 1'b1;
//parameter no	=0;
//parameter yes	=1;
//wire sclr;
//wire [0:0] reg_out;
//wire b_tmp = reg_out[0];
//wire q_out = reg_out[0];
//
//and_a_b_v4 and_gate (.a_in(sclr_in),
//		.b_in(b_tmp),
//		.and_out(sclr)
//		);
//
//C_REG_FD_V4_0		#("0",
//			no,
//			no,
//			yes,
//			no,
//			no,
//			yes,
//			no,
//			yes,
//			"0",
//			1,	
//			1,	
//			1
//			)
//  reg_fd		(.D(reg_out),
//			.Q(reg_out),
//			.CLK(clk),
//			.CE(vcc),
//			.ACLR(gnd),
//			.ASET(gnd),
//			.AINIT(rst),
//			.SCLR(sclr),
//			.SSET(sset_in),
//			.SINIT(gnd)
//			);
//endmodule

/* end pulse_reg */


/* ***************************************************************************
 * Module 
 * **************************************************************************/
/* xor_gate_bit */
module xor_gate_bit_v4 (a, xor_out);

parameter input_width	= 6;
input [input_width-1 : 0] a;
output xor_out;

parameter zero	=1'b0;
parameter zerostring	={input_width{zero}};	

wire sourceless_net =0;
wire dummy_load_0;


C_GATE_BIT_V4_0 #("0",//C_AINIT_VAL
		0,    //C_ENABLE_RLOCS
		4,    //C_GATE_TYPE
		0,    //C_HAS_ACLR
		0,    //C_HAS_AINIT
		0,    //C_HAS_ASET
		0,    //C_HAS_CE
		1,    //C_HAS_O
		0,    //C_HAS_Q
		0,    //C_HAS_SCLR
		0,    //C_HAS_SINIT
		0,    //C_HAS_SSET
		input_width, //C_INPUTS
		zerostring,  //C_INPUT_INV_MASK
		0,    //C_PIPE_STAGES
		"0",  //C_SINIT_VAL
		0,    //C_SYNC_ENABLE
		1     //C_SYNC_PRIORITY
		)
  xor_mod	(.I(a),
		.CLK(sourceless_net),
		.CE(sourceless_net),
		.AINIT(sourceless_net),
		.ASET(sourceless_net),
		.ACLR(sourceless_net),
		.SINIT(sourceless_net),
		.SSET(sourceless_net),
		.SCLR(sourceless_net),
		.Q(dummy_load_0),
		.O(xor_out)
		);
   
endmodule
/* end xor_gate_bit */


/* ***************************************************************************
 * Module 
 * **************************************************************************/
/* Behavioral Model of gray_to_binary */
module gray_to_binary_v4 (bin_reg, grey_reg, reset, clk);

parameter num_of_bits = 6;
parameter init_val = "";
parameter c_enable_rlocs = 1;

input reset;
input clk;
input [num_of_bits-1:0] grey_reg;
output [num_of_bits-1:0] bin_reg;

reg [num_of_bits-1 : 0] AIV;
reg [num_of_bits-1 : 0] bin_reg;
reg [num_of_bits-1 : 0] bin_reg_d;
reg temp;

initial 
	begin
	AIV = to_bits(init_val);
	end

always @(grey_reg)
	begin : temp_loop
	integer i;
		for (i=num_of_bits-1; i>=0; i=i-1)
		if (i == num_of_bits-1)
			begin
			temp = grey_reg[i];
			bin_reg_d[i] = temp;
			end
		else
			begin
  			temp = grey_reg[i] ^ temp;             
			bin_reg_d[i] = temp;
			end
	end
	
	

always @(posedge clk or posedge reset)
begin
	if (reset == 1)
		bin_reg =  AIV;
	else
		bin_reg = bin_reg_d;	
end

	
function [num_of_bits - 1 : 0] to_bits;
	input [num_of_bits*8 : 1] instring;
	integer i;
	integer non_null_string;
	begin
		non_null_string = 0;
		for(i = num_of_bits; i > 0; i = i - 1)
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
			for(i = num_of_bits; i > 0; i = i - 1)
				to_bits[i-1] = 0;
		end
		else
		begin
			for(i = num_of_bits; i > 0; i = i - 1)
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
					$display("Error in module %m at time %dns: non-binary digit in string \"%s\"\nExiting simulation...", $time, instring);
					$finish;
				end
			end
		end 
	end
	endfunction
endmodule
/* End Behavioral of gray_to_binary */


/* ***************************************************************************
 * Module 
 * **************************************************************************/
/* full_flag */
module full_flag_reg_v4 (rst, flag_clk, flag_ce1, flag_ce2, reg_clk, reg_ce, a_in, b_in, dlyd_out, flag_out, to_almost_logic);

parameter addr_width	=6;
parameter c_enable_rlocs=0;

input rst;
input flag_clk;
input flag_ce1;
input flag_ce2;		
input reg_clk	;
input reg_ce	;
input [addr_width-1 : 0]  a_in;
input [addr_width-1 : 0] b_in;
output [addr_width-1 : 0] dlyd_out;
output flag_out	;
output to_almost_logic;


wire gnd = 0;
wire pwr =1;
wire flag_d;
reg flag_q;
reg [addr_width-1 : 0] b_dlyd;

wire flag_ce;
integer i;


assign dlyd_out = b_dlyd;
assign #1 flag_out = flag_q;
assign to_almost_logic = flag_d;
assign flag_ce = flag_ce1 || flag_ce2;
assign flag_d = ( ( (a_in== b_in)&&(flag_q == 1) ) || ((a_in == b_dlyd)&&(flag_q == 0)) ) ? 1 : 0;

initial
begin
 	flag_q <= 1'b1;
end

always @(posedge rst or posedge flag_clk)
begin
	if (rst == 1)
		flag_q <= 1'b1;
	else
		flag_q <= (flag_ce) ? flag_d : flag_q;
end


always @(posedge rst or posedge reg_clk)
begin
	if (rst == 1) 
	begin
	  for (i=0; i <= addr_width-1; i=i+1) 
		begin
		b_dlyd[i] <= (i==0 || i==1 || i==addr_width-1) ?  1 : 0;
	  	end //for
	end
	else
	  b_dlyd <= (reg_ce ) ? b_in : b_dlyd;
end
endmodule
/* end full_flag */


/* ***************************************************************************
 * Module 
 * **************************************************************************/
/* empty_flag */
module empty_flag_reg_v4 (rst, flag_clk, flag_ce1, flag_ce2, reg_clk, reg_ce, a_in, b_in, dlyd_out, flag_out, to_almost_logic);

parameter addr_width	=6;
parameter c_enable_rlocs=0;

input rst;
input flag_clk;
input flag_ce1;
input flag_ce2;		
input reg_clk	;
input reg_ce	;
input [addr_width-1 : 0]  a_in;
input [addr_width-1 : 0] b_in;
output [addr_width-1 : 0] dlyd_out;
output flag_out	;
output to_almost_logic;


wire flag_d;
reg flag_q;
reg [addr_width-1 : 0] b_dlyd;

wire flag_ce;
integer i;

assign dlyd_out = b_dlyd;
assign #1 flag_out = flag_q;
assign to_almost_logic = flag_d;
assign flag_ce = flag_ce1 || flag_ce2;
assign flag_d = ( ( (a_in== b_in)&&(flag_q == 1) ) || ((a_in == b_dlyd)&&(flag_q == 0)) ) ? 1 : 0;

initial
begin
 	flag_q <= 1'b1;
end

always @(posedge rst or posedge flag_clk)
begin
	if (rst == 1)
		flag_q <= 1'b1;
	else
	flag_q <= (flag_ce) ? flag_d : flag_q;
end


always @(posedge rst or posedge reg_clk)
begin
	if (rst == 1)
	begin
	  for (i=0; i <= addr_width-1; i=i+1) 
		begin
		b_dlyd[i] <= (i==0 || i==addr_width-1) ?  1 : 0;
	  	end //for
	end
	else
	  b_dlyd <= (reg_ce ) ? b_in : b_dlyd;
end
endmodule
/* end empty_flag */


/* ***************************************************************************
 * Module 
 * **************************************************************************/
/* almst_full flag */
module almst_full_v4 (rst, flag_clk, flag_ce, reg_clk, reg_ce, a_in, b_in, rqst_in, flag_comb_in, flag_q_in, flag_out);

parameter addr_width	= 6;
parameter c_enable_rlocs = 0;

input rst;
input flag_clk;
input flag_ce;
input reg_clk;
input reg_ce;
input [addr_width-1 : 0] a_in;
input [addr_width-1 : 0] b_in;
input rqst_in;
input flag_comb_in;
input flag_q_in;
output flag_out;


wire flag_d;
reg flag_q;
reg [addr_width-1 : 0] b_dlyd;

wire comp_mux;
wire rqst_mux;
wire comb_or;

assign #1 flag_out = flag_q;

integer i;

assign comp_mux = ( ( (a_in == b_in) && (flag_q_in== 1) ) || ( (a_in == b_dlyd ) && (flag_q_in== 0 ) ) ) ? 1: 0;
assign rqst_mux = ( (comp_mux==1) && ((rqst_in==1) || (flag_q_in==1)) ) ? 1 : 0;
assign comb_or = ( (rqst_mux==1) || (flag_comb_in==1) ) ? 1: 0;
assign flag_d = comb_or;

initial
begin
 	flag_q <= 1'b1;
end

always @(posedge rst or posedge flag_clk) 
begin
	if (rst == 1)
		flag_q <= 1'b1;
	else
		flag_q <= (flag_ce == 1) ? flag_d : flag_q;
end

always @(posedge rst or posedge reg_clk) 
begin
	if (rst == 1) 
	begin
		for (i=0; i<=addr_width-1; i=i+1) 
		begin
		b_dlyd[i] <= (i==1 || i==addr_width-1) ? 1 : 0;
		end //for
	end
	else
		b_dlyd <= (reg_ce == 1) ? b_in : b_dlyd;
end
endmodule
/* end almst_full flag */

	
/* ***************************************************************************
 * Module 
 * **************************************************************************/
/* almst_empty flag */
module almst_empty_v4 (rst, flag_clk, flag_ce, reg_clk, reg_ce, a_in, b_in, rqst_in, flag_comb_in, flag_q_in, flag_out);

parameter addr_width	= 6;
parameter c_enable_rlocs = 0;

input rst;
input flag_clk;
input flag_ce;
input reg_clk;
input reg_ce;
input [addr_width-1 : 0] a_in;
input [addr_width-1 : 0] b_in;
input rqst_in;
input flag_comb_in;
input flag_q_in;
output flag_out;


wire flag_d;
reg flag_q;
reg [addr_width-1 : 0] b_dlyd;

wire comp_mux;
wire rqst_mux;
wire comb_or;

integer i;

assign #1 flag_out = flag_q;

assign comp_mux = ( ( (a_in == b_in) && (flag_q_in== 1) ) || ( (a_in == b_dlyd ) && (flag_q_in== 0 ) ) ) ? 1: 0;
assign rqst_mux = ( (comp_mux==1) && ((rqst_in==1) || (flag_q_in==1)) ) ? 1 : 0;
assign comb_or = ( (rqst_mux==1) || (flag_comb_in==1) ) ? 1: 0;
assign flag_d = comb_or;

initial
begin
 	flag_q <= 1'b1;
end

always @(posedge rst or posedge flag_clk) 
begin
	if (rst == 1) 
		flag_q <= 1'b1;
	else 
		flag_q <= (flag_ce == 1) ? flag_d : flag_q;
end

always @(posedge rst or posedge reg_clk) 
begin
	if (rst == 1)
	begin
		for (i=0; i<=addr_width-1; i=i+1) 
		begin
		b_dlyd[i] <= (i==0 || i==1 || i==addr_width-1) ? 1 : 0;
		end //for
	end
	else
		b_dlyd <= (reg_ce == 1) ? b_in : b_dlyd;
end
endmodule
/* end almst_empty flag */


