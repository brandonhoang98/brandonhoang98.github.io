module Four_4(clk, reset,video_on, refr_tick,pix_x,pix_y,Four_on,Four_rgb);
    input clk, reset;
    input video_on, refr_tick;
    input [9:0] pix_x;
    input [9:0] pix_y;
    output Four_on;
    output [2:0] Four_rgb;

  
  //--------------------------------------------
   // Four Logo
   //--------------------------------------------
   wire [3:0] Four_rom_addr; 
	wire [4:0] Four_rom_col;
   reg [31:0] Four_rom_data;
   wire Four_rom_bit,Four_Logo_on, Logo_on ;
   //--------------------------------------------
   // Four Logo Positioning
   //--------------------------------------------
   // Logo Position left, Top boundary
   localparam Four_X_L = 300;
	localparam Four_X_R = 331;
   localparam Four_X_T = 10;
	localparam Four_X_B = 25;
   
   localparam Four_Logo_x = 32;
   localparam Four_Logo_y = 16;

	 // Four left, right boundary
   wire [9:0] Four_x_l, Four_x_r;
   // Four top, bottom boundary
   wire [9:0] Four_y_t, Four_y_b;
   // reg to track left, top position
   reg [9:0] Four_x_reg, Four_y_reg;
   wire [9:0] Four_x_next, Four_y_next; 

	// body
   //--------------------------------------------
   // Four Logo
   //--------------------------------------------
   always @*
   case (Four_rom_addr)
      6'h0: Four_rom_data = 32'b00000000000000011111000000000000; //   ****
      6'h1: Four_rom_data = 33'b00000000000000111011000000000000; //  ******
      6'h2: Four_rom_data = 32'b00000000000011100011000000000000; // ********
      6'h3: Four_rom_data = 32'b00000000000111000011000000000000; // ********
      6'h4: Four_rom_data = 32'b00000000011100000011000000000000; // ********
      6'h5: Four_rom_data = 32'b00000000111000000011000000000000; // ********
      6'h6: Four_rom_data = 32'b00000011100000000011000000000000; //  ******
      6'h7: Four_rom_data = 32'b00000111111111111111111111000000; //   ****
	 6'h8: Four_rom_data = 32'b00000111111111111111111111000000; //   ****
      6'h9: Four_rom_data = 32'b00000000000000000011000000000000; //  ******
      6'hA: Four_rom_data = 32'b00000000000000000011000000000000; // ********
      6'hB: Four_rom_data = 32'b00000000000000000011000000000000; // ********
      6'hC: Four_rom_data = 32'b00000000000000000011000000000000; // ********
      6'hD: Four_rom_data = 32'b00000000000000000011000000000000; // ********
      6'hE: Four_rom_data = 32'b00000000000000000011000000000000; //  ******
      6'hF: Four_rom_data = 32'b00000000000000000011000000000000; //   ****

   endcase

    //------------------------------------------
	 // Register for Four logo
	 //------------------------------------------
	  // registers
   always @(posedge clk, posedge reset)
      if (reset)
         begin
           
			Four_y_reg <= 0;
            
         end
      else
         begin
            
		   	Four_x_reg <= Four_x_next;
		   	Four_y_reg <= Four_y_next;
            
         end


	//--------------------------------------------
   // Four Logo
   //--------------------------------------------
   // boundary
   assign Four_x_l = Four_x_reg;
   assign Four_y_t = Four_y_reg;
   assign Four_x_r = Four_x_l + Four_Logo_x - 1;
   assign Four_y_b = Four_y_t + Four_Logo_y - 1;
   // pixel within logo
   assign Logo_on =
            (Four_X_L<=pix_x) && (pix_x<=Four_x_r) &&
            (Four_X_T<=pix_y) && (pix_y<=Four_y_b);

	  //assign Logo_on =
     //       (Four_x_l<=Four_X_L) && (pix_x<=Four_x_r) &&
     //       (Four_y_t<=Four_X_T) && (pix_y<=Four_y_b);
   // map current pixel location to ROM addr/col
   assign Four_rom_addr = pix_y[3:0] - Four_y_t[3:0];
   assign Four_rom_col = pix_x[4:0] - Four_x_l[4:0];
   assign Four_rom_bit = Four_rom_data[Four_rom_col];
   // pixel within logo
   assign Four_on = (Logo_on & Four_rom_bit);
   assign Four_rgb = 3'b101; 
   
   //  assign Four_x_next = (refr_tick)?  Four_x_reg + 1'b1:Four_x_reg;
   //	 assign Four_y_next = (refr_tick) ? Four_y_reg + 1'b1:Four_y_reg;
   assign Four_x_next = (refr_tick) ?  Four_x_reg: Four_X_L;
   assign Four_y_next = (refr_tick) ? Four_y_reg : Four_X_T ;



endmodule
