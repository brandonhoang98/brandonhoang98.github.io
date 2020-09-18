module Seven_Segment(clk, reset, An, Disp);
    input clk, reset;
    output [3:0] An;
	 //output S_reset;
    output [7:0] Disp;


  
  
 reg [3:0] state_reg, state_next;
 parameter S0 = 4'b0000;
 parameter S1 = 4'b0001;
 parameter S2 = 4'b0010;
 parameter S3 = 4'b0011;
 parameter S4 = 4'b0100;
 parameter S5 = 4'b0101;
 parameter S6 = 4'b0110;
 parameter S7 = 4'b0111;
 parameter S8 = 4'b1000;
 parameter S9 = 4'b1001;


//Clk_divider c0 (.Clk(clk), .Reset(reset), .Slow_clk(s_clk));

 always @(posedge clk, posedge reset)
      if (reset)
      state_reg <= S0;  
      else
      state_reg <= state_next; 
	 
 always@(*)
 case (state_reg)
 
 S0: state_next = S1;
      	  	   
 S1: state_next = S2;
    	
 S2: state_next = S3;
	  
 S3: state_next = S4;
	  	
 S4: state_next = S5;
	  
 S5: state_next = S6;
 	 
 S6: state_next = S7;
	 
 S7: state_next = S8;
	  
 S8: state_next = S9;
	 
 S9: state_next = S0;
 
 default: state_next= S0;
			 
endcase

 assign  Disp	= (state_reg==S0) ? 8'b11000000:
                 (state_reg==S1) ? 8'b11111001:
			        (state_reg==S2) ? 8'b10100100:
			        (state_reg==S3) ? 8'b10110000:
			        (state_reg==S4) ? 8'b10011001:
			        (state_reg==S5) ? 8'b10010010:
					  (state_reg==S6) ? 8'b10000010:
					  (state_reg==S7) ? 8'b11111000:
					  (state_reg==S8) ? 8'b10000000:
					  (state_reg==S9) ? 8'b10011000:
					   8'b11000000;


 //assign S_reset = (state_reg==S9 && state_next==S0) ? 1'b1: 1'b0;

 assign An = 4'b0111;
endmodule
