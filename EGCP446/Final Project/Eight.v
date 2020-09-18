module Eight_8(clk, reset,video_on,refr_tick, pix_x, pix_y,eight_on,eight_rgb);
    input clk, reset;
    input video_on, refr_tick;
    input [9:0] pix_x, pix_y;
    output eight_on;
    output [2:0] eight_rgb;

  //--------------------------------------------
   // Eight Logo
   //--------------------------------------------
   wire [3:0] Eight_rom_addr; 
	wire [4:0] Eight_rom_col;
   reg [31:0] Eight_rom_data;
   wire Eight_rom_bit,Eight_Logo_on, Logo_on ;
   //--------------------------------------------
   // Eight Logo Positioning
   //--------------------------------------------
   // Logo Position left, Top boundary
   localparam Eight_X_L = 300;
	localparam Eight_X_R = 331;
   localparam Eight_X_T = 10;
	localparam Eight_X_B = 25;
   
   localparam Eight_Logo_x = 32;
   localparam Eight_Logo_y = 16;

	 // Eight left, right boundary
   wire [9:0] Eight_x_l, Eight_x_r;
   // Eight top, bottom boundary
   wire [9:0] Eight_y_t, Eight_y_b;
   // reg to track left, top position
   reg [9:0] Eight_x_reg, Eight_y_reg;
   wire [9:0] Eight_x_next, Eight_y_next; 

	// body
   //--------------------------------------------
   // Eight Logo
   //--------------------------------------------
   always @*
   case (Eight_rom_addr)
      6'h0: Eight_rom_data = 32'b00000000000111111111100000000000; //   ****
      6'h1: Eight_rom_data = 33'b00000000001111111111110000000000; //  ******
      6'h2: Eight_rom_data = 32'b00000000001110000001110000000000; // ********
      6'h3: Eight_rom_data = 32'b00000000001110000001110000000000; // ********
      6'h4: Eight_rom_data = 32'b00000000001110000001110000000000; // ********
      6'h5: Eight_rom_data = 32'b00000000001110000001110000000000; // ********
      6'h6: Eight_rom_data = 32'b00000000001110000001110000000000; //  ******
      6'h7: Eight_rom_data = 32'b00000000000111111111100000000000; //   ****
	 6'h8: Eight_rom_data = 32'b00000000000111111111100000000000; //   ****
      6'h9: Eight_rom_data = 32'b00000000001110000001110000000000; //  ******
      6'hA: Eight_rom_data = 32'b00000000001110000001110000000000; // ********
      6'hB: Eight_rom_data = 32'b00000000001110000001110000000000; // ********
      6'hC: Eight_rom_data = 32'b00000000001110000001110000000000; // ********
      6'hD: Eight_rom_data = 32'b00000000001110000001110000000000; // ********
      6'hE: Eight_rom_data = 32'b00000000001111111111110000000000; //  ******
      6'hF: Eight_rom_data = 32'b00000000000111111111100000000000; //   ****

   endcase

    //------------------------------------------
	 // Register for Eight logo
	 //------------------------------------------
	  // registers
   always @(posedge clk, posedge reset)
      if (reset)
         begin
           
			Eight_y_reg <= 0;
            
         end
      else
         begin
            
		   	Eight_x_reg <= Eight_x_next;
		   	Eight_y_reg <= Eight_y_next;
            
         end


	//--------------------------------------------
   // Eight Logo
   //--------------------------------------------
   // boundary
   assign Eight_x_l = Eight_x_reg;
   assign Eight_y_t = Eight_y_reg;
   assign Eight_x_r = Eight_x_l + Eight_Logo_x - 1;
   assign Eight_y_b = Eight_y_t + Eight_Logo_y - 1;
   // pixel within logo
   assign Logo_on =
            (Eight_X_L<=pix_x) && (pix_x<=Eight_x_r) &&
            (Eight_X_T<=pix_y) && (pix_y<=Eight_y_b);

	  //assign Logo_on =
     //       (Eight_x_l<=Eight_X_L) && (pix_x<=Eight_x_r) &&
     //       (Eight_y_t<=Eight_X_T) && (pix_y<=Eight_y_b);
   // map current pixel location to ROM addr/col
   assign Eight_rom_addr = pix_y[3:0] - Eight_y_t[3:0];
   assign Eight_rom_col = pix_x[4:0] - Eight_x_l[4:0];
   assign Eight_rom_bit = Eight_rom_data[Eight_rom_col];
   // pixel within logo
   assign eight_on = (Logo_on & Eight_rom_bit);
   assign eight_rgb = 3'b101; 
   
   //  assign Eight_x_next = (refr_tick)?  Eight_x_reg + 1'b1:Eight_x_reg;
   //	 assign Eight_y_next = (refr_tick) ? Eight_y_reg + 1'b1:Eight_y_reg;
   assign Eight_x_next = (refr_tick) ?  Eight_x_reg: Eight_X_L;
   assign Eight_y_next = (refr_tick) ? Eight_y_reg : Eight_X_T ;


endmodule
