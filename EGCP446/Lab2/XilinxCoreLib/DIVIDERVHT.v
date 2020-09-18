//  All rights reserved.
// ************************************************************************
// Checked out 19th Oct 1998
//
//  Description:
//  pipelined Divider
//  
//  $Header: /devl/xcs/repo/env/Databases/ip/src/com/xilinx/ip/sdivider_v2_0/simulation/DIVIDERVHT.v,v 1.2 2001/05/24 22:44:56 haotao Exp $

module DIVIDERVHT (
      DIVIDEND,   
      DIVISOR,  
      QUOT,     
      REMD,     
      C  
      );
                         
`define true  1'b1
`define false 1'b0
`define TRUE  1'b1
`define FALSE 1'b0


// Parameter declarations

parameter DIVCLK_SEL       = 1;
parameter DIVIDEND_WIDTH   = 8;
parameter DIVISOR_WIDTH    = 8;
parameter FRACTIONAL_B     = 0;
parameter FRACTIONAL_WIDTH = 8;
parameter SIGNED_B         = 0;


// required constants
parameter latency_max =  DIVIDEND_WIDTH + FRACTIONAL_WIDTH + DIVCLK_SEL + 4;
parameter bus_latency =  (FRACTIONAL_B=== 1) ? DIVIDEND_WIDTH + FRACTIONAL_WIDTH : DIVIDEND_WIDTH;

//Port declarations
input  [(DIVIDEND_WIDTH-1):0]  DIVIDEND;
input  [(DIVISOR_WIDTH-1):0]    DIVISOR;
output [(DIVIDEND_WIDTH-1):0]  QUOT;
output [(FRACTIONAL_WIDTH-1):0] REMD;
input                      C;
   

// unsigned ranges
integer U_DIVIDEND_WIDTH;
integer U_DIVISOR_WIDTH;
integer u_bus_latency;


reg [(DIVIDEND_WIDTH-1):0]     QUOT;
reg [(FRACTIONAL_WIDTH-1):0]    REMD;


integer roc_clock_count;
integer dividend_neg,divisor_neg;
integer quotient_neg,remainder_neg; 
integer clock_counter;
integer latency;
   
// arrays to account for latency

reg [DIVIDEND_WIDTH-1:0] quotient_d[latency_max:0];
reg [FRACTIONAL_WIDTH-1:0] remainder_d[latency_max:0];

reg [DIVIDEND_WIDTH-1:0] vdividend;
reg [DIVISOR_WIDTH-1:0] vdivisor;  
reg [bus_latency-1:0] vquotient;
reg [FRACTIONAL_WIDTH-1:0] vremainder,vremainder_temp;
reg [DIVIDEND_WIDTH-1:0] vdividend_temp;
reg [DIVISOR_WIDTH:0] vdivisor_temp,vtemp,vtemp_new;
reg restore;   
   
// for loop control

integer i,j; 


initial
begin
   // initialise constants
   clock_counter = 0;
   roc_clock_count = 1;
   latency = pipe_depth(DIVIDEND_WIDTH,FRACTIONAL_WIDTH,DIVCLK_SEL,SIGNED_B,FRACTIONAL_B);
   // unsigned values
   if(SIGNED_B === 1) begin
      U_DIVIDEND_WIDTH = DIVIDEND_WIDTH-1;
      U_DIVISOR_WIDTH    = DIVISOR_WIDTH-1;
      if(FRACTIONAL_B=== 1) begin
         u_bus_latency   = bus_latency-2;
      end
      else begin
         u_bus_latency   = bus_latency-1;
      end
   end
   else begin
      U_DIVIDEND_WIDTH = DIVIDEND_WIDTH;
      U_DIVISOR_WIDTH    = DIVISOR_WIDTH;
      u_bus_latency   = bus_latency;
      
   end

   // zero out at start

   for (i = 0; i < latency; i = i + 1) begin
      quotient_d[i]  = {(DIVIDEND_WIDTH){1'b0}};
      remainder_d[i] = {(FRACTIONAL_WIDTH){1'b0}};
   end

end // initial

always @(posedge C) 
begin 
   if (C === 1'bx) begin
      // everything set to X
      for (i = 0; i < latency; i = i + 1) begin
         quotient_d[i]   = {(DIVIDEND_WIDTH){1'bx}};
         remainder_d[i]  = {(FRACTIONAL_WIDTH){1'bx}};
      end
   end
   else begin
      if(roc_clock_count != 0) begin
         //take account of reset time
         roc_clock_count = roc_clock_count -1;
      end
      else
      begin
         // increment the clock counter
         clock_counter = clock_counter +1;
      end

      if ((clock_counter % DIVCLK_SEL) == 0)
         clock_counter = 0;
     
      // main part of the divisor process
      // check first that there is no errors on the input
      if( ^DIVIDEND === {1'bx} ||   
          ^DIVISOR === {1'bx} ) begin
         vquotient = {(bus_latency){1'bx}};
         vremainder = {(FRACTIONAL_WIDTH){1'bx}};
      end
      else begin
         // initialise variables and signed booleans
         dividend_neg = `FALSE;
         divisor_neg  = `FALSE;
         vdividend     = DIVIDEND;
         vdivisor      = DIVISOR;
             
         // check whether the dividend is negative and convert to positive
         if(   SIGNED_B === 1 && 
               (vdividend[DIVIDEND_WIDTH -1] === 1'b1)) begin
            dividend_neg = `TRUE;
            vdividend = ~vdividend+1;
         end
             
         // check whether the divisor is negative and convert to positive
         if(   SIGNED_B === 1 && 
               (vdivisor[DIVISOR_WIDTH -1] === 1'b1)) begin
            divisor_neg = `TRUE;
            vdivisor = ~vdivisor+1;
         end

         // quotient is negative if XOR
         if ((dividend_neg == `TRUE && divisor_neg == `FALSE)
            || (dividend_neg == `FALSE && divisor_neg == `TRUE))
            quotient_neg = `TRUE;
         else
            quotient_neg = `FALSE;                  
    
         // remainder is negative if
         if (dividend_neg == `TRUE)
            remainder_neg = `TRUE;
         else
            remainder_neg = `FALSE; 
    
         
         vdividend_temp[DIVIDEND_WIDTH -1:0] 
            = vdividend[DIVIDEND_WIDTH - 1:0];
         vdivisor_temp[DIVISOR_WIDTH -1:0] 
            = vdivisor[DIVISOR_WIDTH - 1:0];
                     
         // set extra top bit of the divisor to zero        
         vdivisor_temp[DIVISOR_WIDTH] = 1'b0;
         vdivisor_temp[U_DIVISOR_WIDTH] = 1'b0;
         // initialise vtemp to 0
         vtemp = {(DIVISOR_WIDTH){1'b0}};

         // main loop for the quotient remainder calculation 
         for (i = 0; i< u_bus_latency; i = i+1) begin                     
            restore = vtemp[U_DIVISOR_WIDTH];
            // shift the result
            vtemp[DIVISOR_WIDTH : 1] = vtemp[DIVISOR_WIDTH -1 : 0];
            // add in the lowest bit of the dividend
            if ((U_DIVIDEND_WIDTH - 1 -i) >= 0) 
               vtemp[0] = vdividend_temp[U_DIVIDEND_WIDTH-1-i];                                      
            else
               vtemp[0] = 1'b0;
               
            if (restore === 1'b1) begin
               // add vtemp to vdivsor_temp
               vtemp_new = vtemp + vdivisor_temp;
            end                       
            else begin
               // subtract the divisor from vtemp
               vtemp_new = vtemp - vdivisor_temp;
            end                          
        
            vtemp = vtemp_new;
            vquotient[u_bus_latency -1 -i] = ~(vtemp[U_DIVISOR_WIDTH]);
         end // quotient remainder calculation loop


         // calculate the remainder
         if(FRACTIONAL_B === 0) begin
            if( vtemp[U_DIVISOR_WIDTH] === 1'b1) begin
               // remainder is result plus divisor 
               vremainder_temp = vtemp + vdivisor_temp;
            end
            else
               vremainder_temp[DIVISOR_WIDTH-1:0] = vtemp[DIVISOR_WIDTH -1:0];

            vremainder[DIVISOR_WIDTH -1:0] = vremainder_temp[DIVISOR_WIDTH-1:0];
         end // FRACTIONAL_B = 0
                               
         if(SIGNED_B === 1) begin
            vquotient[bus_latency -1] = 1'b0;
            vremainder[FRACTIONAL_WIDTH - 1] = 1'b0;
            if(FRACTIONAL_B === 1) begin
               vquotient[bus_latency - 2] = 1'b0;
            end
         end 
          
         if(remainder_neg == `TRUE)
            vremainder = ~vremainder+1;

      end

   end // if anyX                
     
   // move the values through the latency array by one stage
   for(i = latency -2; i>=0;i = i-1) begin
      quotient_d[i+1] = quotient_d[i];
      remainder_d[i+1] = remainder_d[i];
   end


   if(FRACTIONAL_B === 1) begin
      if (SIGNED_B === 0) begin
         remainder_d[0] = vquotient[FRACTIONAL_WIDTH-1 : 0];
      end
      else begin
         vremainder[FRACTIONAL_WIDTH-2: 0] = vquotient[FRACTIONAL_WIDTH-2:0];
            if( ^DIVIDEND === {1'bx} ||   
                  ^DIVISOR === {1'bx} ) 
               begin
            vremainder[FRACTIONAL_WIDTH-1] = 1'bx;
         end
         else begin  
            vremainder[FRACTIONAL_WIDTH-1] = 1'b0;
         end
         if(quotient_neg == `TRUE)
            vremainder = ~vremainder+1;
         remainder_d[0] = vremainder;
      end
   end
   else begin
      remainder_d[0] = vremainder;     
   end

   // add in the newest results
   if(FRACTIONAL_B === 1 && SIGNED_B === 1) begin
      quotient_d[0] = vquotient[bus_latency -2 : bus_latency-1-DIVIDEND_WIDTH];
      if(quotient_neg == `TRUE)
         quotient_d[0] = ~quotient_d[0]+1;
   end
   else begin
      quotient_d[0] = vquotient[bus_latency -1 : bus_latency-DIVIDEND_WIDTH];
      if(quotient_neg == `TRUE)
         quotient_d[0] = ~quotient_d[0]+1;
   end

   // put the results out to the ports
   QUOT = quotient_d[latency - 1];
   REMD = remainder_d[latency - 1];

end

// function to calculate latency


function integer pipe_depth;
input [31:0] n,f,div_clk,signed_b,fract;
integer temp;  
begin
   if(signed_b === 0) begin
      case (div_clk) 
         1: temp = n+3;
         default : temp = n+4;
      endcase
   end
   else begin
      case (div_clk) 
         1: temp = n-1 + 3 + 2; 
         default : temp = n-1 + 4 + div_clk + 1;
      endcase
   end
   if(fract === 0)
      pipe_depth = temp;
   else begin
      if(signed_b === 0) 
         pipe_depth = temp + f;
      else
         pipe_depth = temp + f-1;
   end
end
endfunction


endmodule

//////////////////////////////END//////////////////////////
