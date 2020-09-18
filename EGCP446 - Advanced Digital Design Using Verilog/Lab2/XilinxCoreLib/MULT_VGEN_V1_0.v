// ************************************************************************
//  Copyright (C) 1998 - Xilinx, Inc.
// ************************************************************************
//--------------------------------------------------------------------
// Design unit  : mult_vgen_v1_0                                    --
//                (entity, architecture and configuration)          --
//                                                                  --
// File name    : MULT_VGEN_V1_0.v                                  --
//                                                                  --
// Purpose      :  Verilog Behavioural description of               --
//                 a Virtex Multiplier                              --
//                                                                  --
//                                                                  --
//                                                                  --
// Limitations  : A = 2-64 bits, B = 2-64 bits and P = 4-128 bits   --
//                                                                  --
// Library      : WORK                                              --
//                                                                  --
// Dependencies : None                                              --
//                                                                  --
// Author       : Stuart Nisbet, Xilinx                             --
//                                                                  --
// Simulator    : Modeltec                                          --
//                                                                  --
//--------------------------------------------------------------------
// Revision list                                                    --
// Version Author Date           Description                        --
// V1		SN	  19/05/99	    Virtex Multiplier                   --
//                                                                  --
//--------------------------------------------------------------------


// `timescale 1 ns/1 ps

`define C_REG 0
`define C_NO_REG 1
`define C_SET 0
`define C_SIGNED 0
`define C_UNSIGNED 1
`define C_CLEAR 1
`define C_DONT_CARE 2
`define C_OVERRIDE 0
`define C_NO_OVERRIDE 1
`define C_RISING_EDGE 0
`define C_FALLING_EDGE 1
`define true  1'b1
`define false 1'b0
`define TRUE  1'b1
`define FALSE 1'b0

module MULT_VGEN_V1_0
( 
        A, 	   
		B, 	   
		CLK,    
		CE,     
		ACLR,   
		ASET,   
		SCLR,   
		SSET,   
        P      
		);

//-----------------------------
//-- GENERIC   DECLARATIONS  --
//-----------------------------
parameter C_A_WIDTH	      = 4;             
parameter C_B_WIDTH	      = 4;             
parameter C_HAS_ACLR      = `false;      
parameter C_HAS_ASET      = `false;      
parameter C_HAS_CE        = `false;       
parameter C_HAS_SCLR      = `false;      
parameter C_HAS_SSET      = `false;      
parameter C_OUTPUT_REG    = `C_REG;   
parameter C_PIPELINED     = `C_REG;      
parameter C_SYNC_ENABLE   = 0;           
parameter C_SYNC_PRIORITY = 1;           
parameter C_TYPE          = `C_SIGNED; 

parameter TDEL          = 1;              //1 TIMESCALE DELAY    
parameter AINIT_VAL     = {C_A_WIDTH+C_B_WIDTH{"0"}};  
parameter SINIT_VAL     = {C_A_WIDTH+C_B_WIDTH{"0"}};  

//-----------------------------
//-- PORT   DECLARATIONS     --
//-----------------------------
input  [(C_A_WIDTH-1):0]  A;
input  [(C_B_WIDTH-1):0]  B;
input  CLK;
input  CE;
input  ACLR;
input  ASET;
input  SCLR;
input  SSET;
output [((C_A_WIDTH+C_B_WIDTH)-1):0] P;

reg [((C_A_WIDTH+C_B_WIDTH)-1):0] P;

//----------------------------
//-- STAGE    DECLARATIONS  --
//----------------------------
wire [((C_A_WIDTH+C_B_WIDTH)-1):0] QP_OUTPUT;    
wire [((C_A_WIDTH+C_B_WIDTH)-1):0] QP_BOTH;      
wire [((C_A_WIDTH+C_B_WIDTH)-1):0] QP_PIPELINED;
wire [((C_A_WIDTH+C_B_WIDTH)-1):0] STAGE1;
wire [((C_A_WIDTH+C_B_WIDTH)-1):0] STAGE2;
wire [((C_A_WIDTH+C_B_WIDTH)-1):0] STAGE3;
wire [((C_A_WIDTH+C_B_WIDTH)-1):0] STAGE4;
wire [((C_A_WIDTH+C_B_WIDTH)-1):0] STAGE5;
wire [((C_A_WIDTH+C_B_WIDTH)-1):0] STAGE6;

//--------------------------------
//-- MULTIPLIER   DECLARATIONS  --
//--------------------------------
reg [((C_A_WIDTH+C_B_WIDTH)-1):0] PP; 
reg [(C_A_WIDTH+C_B_WIDTH) :0] CARRY; 
reg [((C_A_WIDTH+C_B_WIDTH)-1):0] SUM;
reg [((C_A_WIDTH+C_B_WIDTH)-1):0] PRODUCT;
reg [((C_A_WIDTH+C_B_WIDTH)-1):0] DP_BOTH;      
reg [((C_A_WIDTH+C_B_WIDTH)-1):0] DP_PIPELINED;

integer WIDTH;
integer PP_BIT;   
integer BIT;
integer PP_S1;   
integer PP_S2;   
integer PP_S3;   

//--------------------------------
//--  FUNCTION    DECLARATIONS  --
//--------------------------------
integer PIPE_COUNT;   
 
// --***********************************************************--
// --                                                           --
// --              HIERARCHICAL REGISTERS                       --
// --                                                           --
// --***********************************************************--

           C_REG_FD_V1_0 #(AINIT_VAL, 1, C_HAS_ACLR, 0, C_HAS_ASET,
                      C_HAS_CE, C_HAS_SCLR, 0, C_HAS_SSET,
                      SINIT_VAL, C_SYNC_ENABLE, C_SYNC_PRIORITY,(C_A_WIDTH+C_B_WIDTH))
           REG_OUTPUT (.D(PRODUCT),          //  Input value
                       .CLK(CLK),            //  Clock input
             	       .CE(CE),              //  Clock Enable
             	       .ACLR(ACLR),          //  Asynch clear.
             	       .ASET(ASET),          //  Asynch set.
             	       .AINIT(AINIT),        //  Asynch init.
             	       .SCLR(SCLR),          //  Synch clear.
             	       .SSET(SSET),          //  Synch set.
             	       .SINIT(SINIT),        //  Synch init.
             	       .Q(QP_OUTPUT)
                        ); 
   
           C_REG_FD_V1_0 #(AINIT_VAL, 1, C_HAS_ACLR, 0, C_HAS_ASET,
                      C_HAS_CE, C_HAS_SCLR, 0, C_HAS_SSET,
                      SINIT_VAL, C_SYNC_ENABLE, C_SYNC_PRIORITY,(C_A_WIDTH+C_B_WIDTH))
           REG_BOTH   (.D(DP_BOTH),          //  Input value
                       .CLK(CLK),            //  Clock input
             	       .CE(CE),              //  Clock Enable
             	       .ACLR(ACLR),          //  Asynch clear.
             	       .ASET(ASET),          //  Asynch set.
             	       .AINIT(AINIT),        //  Asynch init.
             	       .SCLR(SCLR),          //  Synch clear.
             	       .SSET(SSET),          //  Synch set.
             	       .SINIT(SINIT),        //  Synch init.
             	       .Q(QP_BOTH)
                        );
                        
           C_REG_FD_V1_0 #(AINIT_VAL, 1, C_HAS_ACLR, 0, C_HAS_ASET,
                      C_HAS_CE, C_HAS_SCLR, 0, C_HAS_SSET,
                      SINIT_VAL, C_SYNC_ENABLE, C_SYNC_PRIORITY,(C_A_WIDTH+C_B_WIDTH))
        REG_PIPELINED (.D(DP_PIPELINED),     //  Input value
                       .CLK(CLK),            //  Clock input
             	       .CE(CE),              //  Clock Enable
             	       .ACLR(ACLR),          //  Asynch clear.
             	       .ASET(ASET),          //  Asynch set.
             	       .AINIT(AINIT),        //  Asynch init.
             	       .SCLR(SCLR),          //  Synch clear.
             	       .SSET(SSET),          //  Synch set.
             	       .SINIT(SINIT),        //  Synch init.
             	       .Q(QP_PIPELINED)
                        ); 
                        
           C_REG_FD_V1_0 #(AINIT_VAL, 1, C_HAS_ACLR, 0, C_HAS_ASET,
                      C_HAS_CE, C_HAS_SCLR, 0, C_HAS_SSET,
                      SINIT_VAL, C_SYNC_ENABLE, C_SYNC_PRIORITY,(C_A_WIDTH+C_B_WIDTH))
           REG_STAGE1 (.D(PRODUCT),          //  Input value
                       .CLK(CLK),            //  Clock input
             	       .CE(CE),              //  Clock Enable
             	       .ACLR(ACLR),          //  Asynch clear.
             	       .ASET(ASET),          //  Asynch set.
             	       .AINIT(AINIT),        //  Asynch init.
             	       .SCLR(SCLR),          //  Synch clear.
             	       .SSET(SSET),          //  Synch set.
             	       .SINIT(SINIT),        //  Synch init.
             	       .Q(STAGE1)
                        );

           C_REG_FD_V1_0 #(AINIT_VAL, 1, C_HAS_ACLR, 0, C_HAS_ASET,
                      C_HAS_CE, C_HAS_SCLR, 0, C_HAS_SSET,
                      SINIT_VAL, C_SYNC_ENABLE, C_SYNC_PRIORITY,(C_A_WIDTH+C_B_WIDTH))
           REG_STAGE2 (.D(STAGE1),           //  Input value
                       .CLK(CLK),            //  Clock input
             	       .CE(CE),              //  Clock Enable
             	       .ACLR(ACLR),          //  Asynch clear.
             	       .ASET(ASET),          //  Asynch set.
             	       .AINIT(AINIT),        //  Asynch init.
             	       .SCLR(SCLR),          //  Synch clear.
             	       .SSET(SSET),          //  Synch set.
             	       .SINIT(SINIT),        //  Synch init.
             	       .Q(STAGE2)
                        );
                        
           C_REG_FD_V1_0 #(AINIT_VAL, 1, C_HAS_ACLR, 0, C_HAS_ASET,
                      C_HAS_CE, C_HAS_SCLR, 0, C_HAS_SSET,
                      SINIT_VAL, C_SYNC_ENABLE, C_SYNC_PRIORITY,(C_A_WIDTH+C_B_WIDTH))
           REG_STAGE3 (.D(STAGE2),           //  Input value
                       .CLK(CLK),            //  Clock input
             	       .CE(CE),              //  Clock Enable
             	       .ACLR(ACLR),          //  Asynch clear.
             	       .ASET(ASET),          //  Asynch set.
             	       .AINIT(AINIT),        //  Asynch init.
             	       .SCLR(SCLR),          //  Synch clear.
             	       .SSET(SSET),          //  Synch set.
             	       .SINIT(SINIT),        //  Synch init.
             	       .Q(STAGE3)
                        );
                        
           C_REG_FD_V1_0 #(AINIT_VAL, 1, C_HAS_ACLR, 0, C_HAS_ASET,
                      C_HAS_CE, C_HAS_SCLR, 0, C_HAS_SSET,
                      SINIT_VAL, C_SYNC_ENABLE, C_SYNC_PRIORITY,(C_A_WIDTH+C_B_WIDTH))
           REG_STAGE4 (.D(STAGE3),           //  Input value
                       .CLK(CLK),            //  Clock input
             	       .CE(CE),              //  Clock Enable
             	       .ACLR(ACLR),          //  Asynch clear.
             	       .ASET(ASET),          //  Asynch set.
             	       .AINIT(AINIT),        //  Asynch init.
             	       .SCLR(SCLR),          //  Synch clear.
             	       .SSET(SSET),          //  Synch set.
             	       .SINIT(SINIT),        //  Synch init.
             	       .Q(STAGE4)
                        );
                        
           C_REG_FD_V1_0 #(AINIT_VAL, 1, C_HAS_ACLR, 0, C_HAS_ASET,
                      C_HAS_CE, C_HAS_SCLR, 0, C_HAS_SSET,
                      SINIT_VAL, C_SYNC_ENABLE, C_SYNC_PRIORITY,(C_A_WIDTH+C_B_WIDTH))
           REG_STAGE5 (.D(STAGE4),           //  Input value
                       .CLK(CLK),            //  Clock input
             	       .CE(CE),              //  Clock Enable
             	       .ACLR(ACLR),          //  Asynch clear.
             	       .ASET(ASET),          //  Asynch set.
             	       .AINIT(AINIT),        //  Asynch init.
             	       .SCLR(SCLR),          //  Synch clear.
             	       .SSET(SSET),          //  Synch set.
             	       .SINIT(SINIT),        //  Synch init.
             	       .Q(STAGE5)
                        );
                        
           C_REG_FD_V1_0 #(AINIT_VAL, 1, C_HAS_ACLR, 0, C_HAS_ASET,
                      C_HAS_CE, C_HAS_SCLR, 0, C_HAS_SSET,
                      SINIT_VAL, C_SYNC_ENABLE, C_SYNC_PRIORITY,(C_A_WIDTH+C_B_WIDTH))
           REG_STAGE6 (.D(STAGE5),           //  Input value
                       .CLK(CLK),            //  Clock input
             	       .CE(CE),              //  Clock Enable
             	       .ACLR(ACLR),          //  Asynch clear.
             	       .ASET(ASET),          //  Asynch set.
             	       .AINIT(AINIT),        //  Asynch init.
             	       .SCLR(SCLR),          //  Synch clear.
             	       .SSET(SSET),          //  Synch set.
             	       .SINIT(SINIT),        //  Synch init.
             	       .Q(STAGE6)
                        );

//-----------------
//-- INITIALIZE  --
//-----------------
 initial
 begin
        PIPE;
     DP_BOTH = {(C_A_WIDTH+C_B_WIDTH){1'b0}};
DP_PIPELINED = {(C_A_WIDTH+C_B_WIDTH){1'b0}}; 
     PRODUCT = {(C_A_WIDTH+C_B_WIDTH){1'b0}};
          PP = {(C_A_WIDTH+C_B_WIDTH){1'b0}}; 
       CARRY = {(C_A_WIDTH+C_B_WIDTH+1){1'b0}}; 
         SUM = {(C_A_WIDTH+C_B_WIDTH){1'b0}};
       WIDTH = (C_A_WIDTH+C_B_WIDTH);
 end // initial

// Calculate multiplier value and add 2ns combinatorial delay. 
always  
begin

#TDEL
  //-----------------------------
  //-- SIGNED MULTIPLICATION --
  //-----------------------------
      if (C_TYPE === `C_SIGNED) 
       begin        
           //-- Stay in this loop until the mult has been calculated 
           //-- Keep adding all the  Partial Product Sums.       
           //-- while PP_BIT < C_B_WIDTH loop
           for  (PP_BIT=0; PP_BIT<=(C_B_WIDTH-1); PP_BIT=PP_BIT+1) 
            begin
                
                  if (B[PP_BIT] === 1'b1)
                   begin
                   //Generate the PP  
                     for  (PP_S1=0; PP_S1<=(PP_BIT-1); PP_S1=PP_S1+1) 
                           PP[PP_S1] = 1'b0; 
                           
                     for  (PP_S2=PP_BIT; PP_S2<= ((C_A_WIDTH+PP_BIT)-1) ; PP_S2=PP_S2+1) 
                           PP[PP_S2] = A[PP_S2-PP_BIT]; 
                              
                     for  (PP_S3=(C_A_WIDTH+PP_BIT); PP_S3<=((C_A_WIDTH+C_B_WIDTH)-1); PP_S3=PP_S3+1) 
                           PP[PP_S3] = A[C_A_WIDTH-1];    
                   end 
                  else if (B[PP_BIT] === 1'b0)        
                   PP = {(C_A_WIDTH+C_B_WIDTH){1'b0}};
                  else                                
                   PP = {(C_A_WIDTH+C_B_WIDTH){1'bx}};
                        
                  if (PP_BIT === (C_B_WIDTH-1)) 
                    CARRY[0] = 1'b1;
                  else 
                    CARRY[0] = 1'b0;
                                       
                   
                   if (PP_BIT === (C_B_WIDTH-1))
                    begin 
                        for (BIT=0; BIT<=(WIDTH-1); BIT=BIT+1)
                         begin   
                          CARRY[BIT+1] = (SUM[BIT] && !(PP[BIT])) || (SUM[BIT] && CARRY[BIT])
                                           || (!(PP[BIT]) && CARRY[BIT]);
                          SUM[BIT]     = (SUM[BIT] && (PP[BIT]) && !(CARRY[BIT])) ||
                                         (!(SUM[BIT]) && !(PP[BIT]) && !(CARRY[BIT])) ||
                                         (!(SUM[BIT]) && (PP[BIT]) && CARRY[BIT]) ||
                                         (SUM[BIT] && !(PP[BIT]) && CARRY[BIT]);
                         end 
                    end    
                   else
                    begin    
                        for (BIT=0; BIT<=(WIDTH-1); BIT=BIT+1)
                         begin   
                           CARRY[BIT+1]  = (SUM[BIT] && PP[BIT]) || (SUM[BIT] && CARRY[BIT])
                                            || (PP[BIT] && CARRY[BIT]);
                           SUM[BIT]      = (SUM[BIT] && !(PP[BIT]) && !(CARRY[BIT])) ||
                                           (!(SUM[BIT]) && PP[BIT] && !(CARRY[BIT])) ||
                                           (!(SUM[BIT]) && !(PP[BIT]) && CARRY[BIT]) ||
                                           (SUM[BIT] && PP[BIT] && CARRY[BIT]);
                         end 
                    end
            end
        end 
 
  //-----------------------------
  //-- UNSIGNED MULTIPLICATION --
  //-----------------------------
    if (C_TYPE === `C_UNSIGNED) 
       begin
          //-- Stay in this loop until the mult has been calculated 
          //-- Keep adding all the  Partial Product Sums.       
          //-- while PP_BIT < C_B_WIDTH loop
          for  (PP_BIT=0; PP_BIT<=(C_B_WIDTH-1); PP_BIT=PP_BIT+1) 
           begin
                if (B[PP_BIT] === 1'b1)
                 begin
                  //Generate the PP  
                    for  (PP_S1=0; PP_S1<=(PP_BIT-1); PP_S1=PP_S1+1) 
                          PP[PP_S1] = 1'b0; 
                          
                    for  (PP_S2=PP_BIT; PP_S2<= ((C_A_WIDTH+PP_BIT)-1) ; PP_S2=PP_S2+1) 
                          PP[PP_S2] = A[PP_S2-PP_BIT]; 
                             
                    for  (PP_S3=(C_A_WIDTH+PP_BIT); PP_S3<=((C_A_WIDTH+C_B_WIDTH)-1); PP_S3=PP_S3+1) 
                          PP[PP_S3] = 1'b0;    
                  end 
                else if (B[PP_BIT] === 1'b0)        
                 PP = {(C_A_WIDTH+C_B_WIDTH){1'b0}};
                else                                
                 PP = {(C_A_WIDTH+C_B_WIDTH){1'bx}};
                 
                 //Generate the SUM
                 for (BIT=0; BIT<=(WIDTH-1); BIT=BIT+1)
                  begin   
                    CARRY[BIT+1]  = (SUM[BIT] && PP[BIT]) || (SUM[BIT] && CARRY[BIT])
                                     || (PP[BIT] && CARRY[BIT]);
                    SUM[BIT]      = (SUM[BIT] && !(PP[BIT]) && !(CARRY[BIT])) ||
                                    (!(SUM[BIT]) && PP[BIT] && !(CARRY[BIT])) ||
                                    (!(SUM[BIT]) && !(PP[BIT]) && CARRY[BIT]) ||
                                    (SUM[BIT] && PP[BIT] && CARRY[BIT]);
                  end 
           end 
       end 

       PRODUCT = SUM;
       
       //------------------------------------------------------------
       //-- SET DP_PIPELINED IF THERE IS ONLY ONE STAGE            --
       //-- I.E. COMBINATORIAL CALC. FOLLOWED BY REGISTER          --
       //------------------------------------------------------------
         if (PIPE_COUNT === 1) 
            DP_PIPELINED = PRODUCT;

        //------------------------------------------
        //-- COMBINATORIAL BEHAVIOURAL DELAY      --
        //------------------------------------------
        #TDEL  
         
        if (C_PIPELINED === `C_NO_REG && C_OUTPUT_REG === `C_NO_REG) 
             P = PRODUCT;
        
       // -- wait for next input change     
       @(A or B)
            
       PP = {(C_A_WIDTH+C_B_WIDTH){1'b0}}; 
       CARRY = {(C_A_WIDTH+C_B_WIDTH+1){1'b0}}; 
       SUM = {(C_A_WIDTH+C_B_WIDTH){1'b0}};
end

// Register input settings       
always   
begin

  //------------------------------------------------------------
  //-- SET DP_PIPELINED AND DP_BOTH (PIPELINED AND OUTPUT)    --
  //-- REGISTER SETTINGS I.E. SELECT THE CORRECT STAGE COUNT  --
  //------------------------------------------------------------
     case(PIPE_COUNT)
      1 :        DP_BOTH = STAGE1;
      2 :  begin DP_BOTH = STAGE2;
                 DP_PIPELINED = STAGE1;
           end      
      3 :  begin DP_BOTH = STAGE3;
                 DP_PIPELINED = STAGE2;
           end      
      4 :  begin DP_BOTH = STAGE4;
                 DP_PIPELINED = STAGE3;
           end      
      5 :  begin DP_BOTH = STAGE5;
                 DP_PIPELINED = STAGE4;
           end      
      6 :  begin DP_BOTH = STAGE6;
                 DP_PIPELINED = STAGE5;
           end      
      default : $display("INVALID");
     endcase 
     
  @(STAGE1 or STAGE2 or STAGE3 or STAGE4 or STAGE5 or STAGE6); 
    
end

// Register output settings       
always   
begin

  //--------------------
  //-- Select output  --
  //--------------------
  if (C_PIPELINED === `C_REG || C_OUTPUT_REG === `C_REG)
 	begin
     //------------------------------
     //-- REGISTER CLOCKED OUTPUTS --
     //------------------------------
        if (C_PIPELINED === `C_REG && C_OUTPUT_REG === `C_REG)
          begin  
            if (C_B_WIDTH !== 2)
             P = QP_BOTH;
            else    
             $display("Can't have 2-stages of registers in a 2-bit multiplier");
          end   
        else if (C_PIPELINED === `C_REG && C_OUTPUT_REG === `C_NO_REG)
          begin  
            if (C_B_WIDTH !== 2)
             P = QP_PIPELINED;
            else    
             $display("Can't have a pipelined register in a 2-bit multiplier");
          end   
        else if (C_PIPELINED === `C_NO_REG && C_OUTPUT_REG === `C_REG)
             P = QP_OUTPUT;
     end 
     
  @(QP_OUTPUT or QP_PIPELINED or QP_BOTH); 
    
end
     
  // -- --------------------------------------------------------
  // -- TASK : to calculate the number of PIPELINE stages     --
  // -- required to  produce the correct multiplication       --
  // -- --------------------------------------------------------
    task PIPE;
      integer VALUE, FINALVALUE, MULT;  
    begin
       
     VALUE = 0;
     FINALVALUE = 0;   
     MULT = C_B_WIDTH;
      
      while (MULT > 1) 
      begin  
         VALUE = VALUE + 1;
         MULT  = MULT/2;
      end
      
      if (C_B_WIDTH == (1'b1 << VALUE)) 
         FINALVALUE = VALUE;
      else 
         FINALVALUE = VALUE + 1;
      
      if (FINALVALUE < 2) 
         PIPE_COUNT = FINALVALUE;
      else
         PIPE_COUNT = FINALVALUE-1; 
    
    end     
    endtask

endmodule

`undef C_REG
`undef C_NO_REG
`undef C_SET
`undef C_SIGNED
`undef C_UNSIGNED
`undef C_CLEAR
`undef C_DONT_CARE
`undef C_OVERRIDE
`undef C_NO_OVERRIDE
`undef C_RISING_EDGE
`undef C_FALLING_EDGE


//////////////////////////////END//////////////////////////
