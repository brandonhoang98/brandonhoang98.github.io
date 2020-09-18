module Two_2(clk, reset,video_on, refr_tick,pix_x,pix_y,two_on,two_rgb);
    input clk, reset;
    input video_on, refr_tick;
    input [9:0] pix_x;
    input [9:0] pix_y;
    output two_on;
    output [2:0] two_rgb;

  
  //--------------------------------------------
   // Two Logo
   //--------------------------------------------
   wire [3:0] Two_rom_addr; 
	wire [4:0] Two_rom_col;
   reg [31:0] Two_rom_data;
   wire Two_rom_bit,Two_Logo_on, Logo_on ;
   //--------------------------------------------
   // Two Logo Positioning
   //--------------------------------------------
   // Logo Position left, Top boundary
   localparam Two_X_L = 300;
	localparam Two_X_R = 331;
   localparam Two_X_T = 10;
	localparam Two_X_B = 25;
   
   localparam Two_Logo_x = 32;
   localparam Two_Logo_y = 16;

	 // Two left, right boundary
   wire [9:0] Two_x_l, Two_x_r;
   // Two top, bottom boundary
   wire [9:0] Two_y_t, Two_y_b;
   // reg to track left, top position
   reg [9:0] Two_x_reg, Two_y_reg;
   wire [9:0] Two_x_next, Two_y_next; 

	// body
   //--------------------------------------------
   // Two Logo
   //--------------------------------------------
   always @*
   case (Two_rom_addr)
      6'h0: Two_rom_data = 32'b00000000000111111110000000000000; //   ****
      6'h1: Two_rom_data = 32'b00000000011111111111100000000000; //  ******
      6'h2: Two_rom_data = 32'b00000001110000000001110000000000; // ********
      6'h3: Two_rom_data = 32'b00000001100000000001110000000000; // ********
      6'h4: Two_rom_data = 32'b0000000000000000001110000000000; // ********
      6'h5: Two_rom_data = 32'b00000000000000000111000000000000; // ********
      6'h6: Two_rom_data = 32'b00000000000000001110000000000000; //  ******
      6'h7: Two_rom_data = 32'b00000000000000011100000000000000; //   ****
	  6'h8: Two_rom_data = 32'b00000000000000111000000000000000; //   ****
      6'h9: Two_rom_data = 32'b00000000000001110000000000000000; //  ******
      6'hA: Two_rom_data = 32'b000000000001110000000000000000000; // ********
      6'hB: Two_rom_data = 32'b00000000001110000000000000000000; // ********
      6'hC: Two_rom_data = 32'b00000000011100000000000000000000; // ********
      6'hD: Two_rom_data = 32'b00000000111000000000000000000000; // ********
      6'hE: Two_rom_data = 32'b00000001111111111111111000000000; //  ******
      6'hF: Two_rom_data = 32'b00000001111111111111111000000000; //   ****

   endcase

    //------------------------------------------
	 // Register for Two logo
	 //------------------------------------------
	  // registers
   always @(posedge clk, posedge reset)
      if (reset)
         begin
           
			Two_y_reg <= 0;
            
         end
      else
         begin
            
		   	Two_x_reg <= Two_x_next;
		   	Two_y_reg <= Two_y_next;
            
         end


	//--------------------------------------------
   // Two Logo
   //--------------------------------------------
   // boundary
   assign Two_x_l = Two_x_reg;
   assign Two_y_t = Two_y_reg;
   assign Two_x_r = Two_x_l + Two_Logo_x - 1;
   assign Two_y_b = Two_y_t + Two_Logo_y - 1;
   // pixel within logo
   assign Logo_on =
            (Two_X_L<=pix_x) && (pix_x<=Two_x_r) &&
            (Two_X_T<=pix_y) && (pix_y<=Two_y_b);

	  //assign Logo_on =
     //       (Two_x_l<=Two_X_L) && (pix_x<=Two_x_r) &&
     //       (Two_y_t<=Two_X_T) && (pix_y<=Two_y_b);
   // map current pixel location to ROM addr/col
   assign Two_rom_addr = pix_y[3:0] - Two_y_t[3:0];
   assign Two_rom_col = pix_x[4:0] - Two_x_l[4:0];
   assign Two_rom_bit = Two_rom_data[Two_rom_col];
   // pixel within logo
   assign two_on = (Logo_on & Two_rom_bit);
   assign two_rgb = 3'b101; 
   
   //  assign Two_x_next = (refr_tick)?  Two_x_reg + 1'b1:Two_x_reg;
   //	 assign Two_y_next = (refr_tick) ? Two_y_reg + 1'b1:Two_y_reg;
   assign Two_x_next = (refr_tick) ?  Two_x_reg: Two_X_L;
   assign Two_y_next = (refr_tick) ? Two_y_reg : Two_X_T ;



endmodule
