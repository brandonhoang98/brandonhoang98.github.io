/*********************************************************************************

$Id: SYNC_FIFO_V1_0.v,v 1.1 2001/05/24 22:50:48 haotao Exp $
**********************************************************************************

* Synchronous Fifo  - Verilog Behavioral Model
*****************************************************************************
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
*        ****************************
*        ** Copyright Xilinx, Inc. **
*        ** All rights reserved.   **
*        ****************************
*
*************************************************************************

Filename:     sync_fifo_v1_0.v

Description :  Synchronous FIFO behavioral model


History:
                       8/18/00   First Version
                       8/24/00   Add polarity control for handshaking
                                 Changed Asynchronous reset AINIT to synchronous
                                 reset SINIT
                       9/13/00   Change DATA_COUNT assignment
                       9/14/00   Create fcounter_max to hold the DATA_COUNT value
                                 to all 1 value when FULL is asserted.
                       9/15/00   Modification to DATA_COUNT selection
                       9/18/00   Initialize outputs.
                       9/22/00   Update MEM_BLK module
                       10/18/00  Fix start up value for optional outputs
                       10/24/00  Put parameters in alphabetically order to match VEO
                       10/25/00  Change module name to UPPER CASE
                       10/27/00  Add Xilinx Header

***********************************************************************************/

module SYNC_FIFO_V1_0 (  CLK,
                      SINIT,
                      DIN,
                      WR_EN,
                      RD_EN,
                      DOUT,
                      FULL,
                      EMPTY,
                      RD_ACK,
                      WR_ACK,
                      RD_ERR,
                      WR_ERR,
                      DATA_COUNT 
                       );



  parameter  c_dcount_width          =  9 ; //  width of the dcount . Adjustable by customer
  parameter  c_enable_rlocs          =  0; // 
  parameter  c_has_dcount            =  1 ; // 
  parameter  c_has_rd_ack            =  1; // 
  parameter  c_has_rd_err            =  1; // 
  parameter  c_has_wr_ack            =  1; // 
  parameter  c_has_wr_err            =  1; // 
  parameter  c_memory_type           =  0; //
  parameter  c_ports_differ          =  0; //
  parameter  c_rd_ack_low            =  0; //
  parameter  c_rd_err_low            =  0  ; //   
  parameter  c_read_data_width       =  16  ; //  
  parameter  c_read_depth            =  0  ; //
  parameter  c_write_data_width      =  16 ; //
  parameter  c_write_depth           =  16 ;  //
  parameter  c_wr_ack_low            =  1 ; // 
  parameter  c_wr_err_low            =  1 ; // 




parameter addr_max      = (c_write_depth == 16 ? 4:
                          (c_write_depth == 32 ? 5:
                          (c_write_depth == 64 ? 6 :
                          (c_write_depth == 128 ? 7 :
                          (c_write_depth == 256 ? 8 :
                          (c_write_depth == 512 ? 9 :
                          (c_write_depth == 1024 ? 10 :
                          (c_write_depth == 2048 ? 11 :
                          (c_write_depth == 4096 ? 12 :
                          (c_write_depth == 8192 ? 13 :
                          (c_write_depth == 16384 ? 14 :
                          (c_write_depth == 32768 ? 15 :
                          (c_write_depth == 65536 ? 16 : 6)))))))))))));




input                       CLK;      // CLK Signal.
input                       SINIT;     // High Asserted Reset signal.
input [(c_write_data_width-1):0]       DIN;  // Data Into FIFO.
input                       WR_EN;     // Write into FIFO Signal.
input                       RD_EN;    // Read From FIFO Signal.

output [(c_read_data_width-1):0]      DOUT;   // FIFO Data out.
output                      FULL;  // FIFO Full indicating signal.
output                      EMPTY; // FIFO Empty indicating signal.
output                      RD_ACK ; // Read Acknowledge signal
output                      WR_ACK ; // Write Acknowledge signal
output                      RD_ERR ; // Rejection of RD_EN active on prior clock edge
output                      WR_ERR ; // Rejection of WR_EN active on prior clock edge
output [(c_dcount_width-1):0]        DATA_COUNT ;


reg                FULL;
reg                EMPTY;
wire               RD_ACK_internal ;
wire               WR_ACK_internal ;
wire               RD_ERR_internal ;
wire               WR_ERR_internal ;
wire [(c_dcount_width-1):0] DATA_COUNT_int ;
reg [(c_dcount_width-1):0] DATA_COUNT ;

integer k ;



reg                rd_ack_int ;
reg                rd_err_int ;
reg                wr_ack_int ;
reg                wr_err_int ;

integer            N ;

reg    [addr_max:0]       fcounter;    // counter indicates num of data in FIFO
reg    [addr_max:0]       fcounter_max ; // value of fcounter OR with MSB of fcounter       
reg    [(addr_max-1):0]   rd_ptr;      // current read pointer.
reg    [(addr_max-1):0]   wr_ptr;      // current write pointer.
wire   [(c_write_data_width-1):0]    memory_dataout; // Data Out from the  MemBlk
wire   [(c_write_data_width-1):0]    memory_datain ;  // Data into the  MemBlk

wire   write_allow = (WR_EN && (!FULL)) ;
wire   read_allow = (RD_EN && (!EMPTY)) ;

assign DOUT     = memory_dataout;  
assign memory_datain = DIN;

// assign DATA_COUNT_int  = fcounter_max[(addr_max-1) : (addr_max - c_dcount_width)] ;
assign RD_ACK_internal = (c_rd_ack_low == 0 )  ? rd_ack_int : (!rd_ack_int) ;
assign WR_ACK_internal = (c_wr_ack_low == 0 )  ? wr_ack_int : (!wr_ack_int) ;
assign RD_ERR_internal = (c_rd_err_low == 0 )  ? rd_err_int : (!rd_err_int) ;
assign WR_ERR_internal = (c_wr_err_low == 0 )  ? wr_err_int : (!wr_err_int) ;

// assign DATA_COUNT = (c_has_dcount == 0 ) ? {c_dcount_width{1'bX}} : DATA_COUNT_int ;
assign RD_ACK     = (c_has_rd_ack == 0 ) ? 1'bX : RD_ACK_internal ;
assign WR_ACK     = (c_has_wr_ack == 0 ) ? 1'bX : WR_ACK_internal ;
assign RD_ERR     = (c_has_rd_err == 0 ) ? 1'bX : RD_ERR_internal ;
assign WR_ERR     = (c_has_wr_err == 0 ) ? 1'bX : WR_ERR_internal ;     


    MEM_BLK # (addr_max, c_write_data_width, c_write_depth)  memblk(.clk(CLK),
                                                                         .write_en(write_allow),
                                                                         .read_en(read_allow),
                                                                         .rd_addr(rd_ptr),
                                                                         .wr_addr(wr_ptr),
                                                                         .data_in(memory_datain),
                                                                         .data_out(memory_dataout),
                                                                         .rst(SINIT)
                                                                          ) ;

// Outputs initialization

    initial begin

        wr_ack_int = 0 ;

        rd_ack_int = 0 ;

        rd_err_int = 0 ; 

        wr_err_int = 0 ; 
        
        FULL = 0 ;
        EMPTY = 1 ;  

        for (k = 0; k <= c_dcount_width; k = k + 1)
            DATA_COUNT[k] = 0 ;
    end

// DATA_COUNT assignment

always @(fcounter_max)
begin
  if  ((c_has_dcount == 1) && (c_dcount_width <= addr_max ) ) 
     DATA_COUNT = fcounter_max[(addr_max-1) : (addr_max - c_dcount_width)];
end

always @(fcounter) 
begin 
  if ((c_has_dcount == 1) && (c_dcount_width ==  addr_max + 1 ))  
     DATA_COUNT = fcounter;
end 



// Handshaking signals

// Read Ack logic

always @(posedge CLK )
begin
    if (SINIT) 
        rd_ack_int <= 0 ;
    else
        rd_ack_int <= RD_EN && (! EMPTY);
end 

// Write Ack logic

always @(posedge CLK ) 
begin 
    if (SINIT)   
       wr_ack_int <= 0 ; 
    else 
       wr_ack_int <= WR_EN && (! FULL );
end 

// Read Error handshake signal logic

always @(posedge CLK )
begin
    if (SINIT)
       rd_err_int <= 0 ;
    else
       rd_err_int <= RD_EN &&  EMPTY;
end

// Write Error handshake signal logic 

always @(posedge CLK ) 
begin
    if (SINIT)
       wr_err_int <= 0 ; 
    else    
       wr_err_int <= WR_EN &&  FULL; 
end 

always @(fcounter)
begin

for (N = 0 ; N<= addr_max ; N = N + 1)
    fcounter_max[N] = fcounter[addr_max] || fcounter[N] ;


end 



// Control circuitry for FIFO. If SINIT signal is asserted
// all the counters are set to 0. IF write only the write counter
// is incremented else if read only read counter is incremented
// else if both, read and write counters are incremented.
// fcounter indicates the num of items in the fifo. Write only
// increments  the fcounter, read only decrements the counter and
// read && write doen't change the counter value.


// Read Counter

always @(posedge CLK )
begin
   if (SINIT) 
      rd_ptr <= 0;
   else begin
      if (read_allow == 1'b1) begin
         if ( rd_ptr == (c_write_depth -1 ))  // Need to support any arbitrary depth
            rd_ptr <= 0 ;
         else
            rd_ptr <= rd_ptr + 1 ;
      end
   end
end

// Write Counter
 
always @(posedge CLK )
begin
   if (SINIT) 
      wr_ptr <= 0;
   else begin 
      if (write_allow == 1'b1) begin
         if  ( wr_ptr == (c_write_depth -1 )) // Need to support any arbitrary depth
             wr_ptr <= 0 ;
         else
             wr_ptr <= wr_ptr + 1 ;
      end 
   end   
end 

// Fifo Content Counter

always @(posedge CLK )
begin
   if (SINIT) 
      fcounter <= 0;
   else begin
      case ({write_allow, read_allow})
         2'b00 : fcounter <= fcounter ;
         2'b01 : fcounter <= fcounter - 1 ;
         2'b10 : fcounter <= fcounter + 1 ;
         2'b11 : fcounter <= fcounter ;
      endcase
   end
end 


 


// EMPTY signal indicates FIFO Empty Status. When SINIT is active, EMPTY is   
// asserted indicating the FIFO is empty. After the First Data is
// put into the FIFO the signal is deasserted.


always @(posedge CLK )
begin

  if (SINIT)
     EMPTY <= 1'b1;

  else begin

     if ( ( (fcounter==1) && RD_EN && (!WR_EN)) || ( (fcounter == 0) && (!WR_EN) ) )

          EMPTY <= 1'b1;
 
     else 

          EMPTY <= 1'b0;
  end
end
 



// FULL Flag logic


always @(posedge CLK )
begin
 
  if (SINIT)
 
    FULL <= 1'b0;
 
  else begin
 
    if (((fcounter == c_write_depth) && (!RD_EN) ) || ((fcounter == c_write_depth-1) && WR_EN && (!RD_EN)))
       
       FULL <= 1'b1;
 
    else 
    
       FULL <= 1'b0;
    
  end
end
       
endmodule




module MEM_BLK( clk,
                     write_en,
                     read_en,
                     wr_addr,
                     rd_addr,
                     data_in,
                     data_out,
                     rst
                   );

parameter addr_value = 4  ;
parameter data_width = 16 ;
parameter mem_depth      = 16 ;


input                    clk;       // input clk.
input                    write_en;    // Write Signal to put datainto fifo.
input                    read_en ;
input  [(addr_value-1):0]  wr_addr;   // Write Address.
input  [(addr_value-1):0]  rd_addr;   // Read Address.
input  [(data_width-1):0]   data_in;   // DataIn in to Memory Block
input                    rst ;

output [(data_width-1):0]   data_out;  // Data Out from the Memory Block(FIFO)

reg  [(data_width-1):0] data_out;  

reg    [(data_width-1):0] FIFO[0:(mem_depth-1)];


initial begin
data_out = 0 ;
end




always @(posedge clk)
begin
   if (rst == 1'b1)
      data_out <= 0 ; 
   else
      begin
        if (read_en == 1'b1) 
          data_out  <= FIFO[rd_addr];
      end
end

always @(posedge clk)
begin
   if(write_en ==1'b1)
      FIFO[wr_addr] <= data_in;
end

endmodule


