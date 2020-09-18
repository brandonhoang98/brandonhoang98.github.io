module Zero_0(clk, reset,video_on,refr_tick, pix_x, pix_y,zero_on,zero_rgb);
    input clk, reset;
    input video_on, refr_tick;
    input [9:0] pix_x, pix_y;
    output zero_on;
    output [2:0] zero_rgb;

  //--------------------------------------------
   // Zero Logo
   //--------------------------------------------
   wire [3:0] Zero_rom_addr; 
	wire [4:0] Zero_rom_col;
   reg [31:0] Zero_rom_data;
   wire Zero_rom_bit,Zero_Logo_on, Logo_on ;
   //--------------------------------------------
   // Zero Logo Positioning
   //--------------------------------------------
   // Logo Position left, Top boundary
   localparam Zero_X_L = 300;
	localparam Zero_X_R = 331;
   localparam Zero_X_T = 10;
	localparam Zero_X_B = 25;
   
   localparam Zero_Logo_x = 32;
   localparam Zero_Logo_y = 16;

	 // Zero left, right boundary
   wire [9:0] Zero_x_l, Zero_x_r;
   // Zero top, bottom boundary
   wire [9:0] Zero_y_t, Zero_y_b;
   // reg to track left, top position
   reg [9:0] Zero_x_reg, Zero_y_reg;
   wire [9:0] Zero_x_next, Zero_y_next; 

	// body
   //--------------------------------------------
   // Zero Logo
   //--------------------------------------------
   always @*
   case (Zero_rom_addr)
      6'h0: Zero_rom_data = 32'b00000000000011111111000000000000; //   ****
      6'h1: Zero_rom_data = 33'b00000000000011111111000000000000; //  ******
      6'h2: Zero_rom_data = 32'b00000000001100000000110000000000; // ********
      6'h3: Zero_rom_data = 32'b00000000001100000000110000000000; // ********
      6'h4: Zero_rom_data = 32'b00000000001100000000110000000000; // ********
      6'h5: Zero_rom_data = 32'b00000000001100000000110000000000; // ********
      6'h6: Zero_rom_data = 32'b00000000001100000000110000000000; //  ******
      6'h7: Zero_rom_data = 32'b00000000001100000000110000000000; //   ****
	   6'h8: Zero_rom_data = 32'b00000000000000000000000000000000; //   ****
      6'h9: Zero_rom_data = 32'b00000000001100000000110000000000; //  ******
      6'hA: Zero_rom_data = 32'b00000000001100000000110000000000; // ********
      6'hB: Zero_rom_data = 32'b00000000001100000000110000000000; // ********
      6'hC: Zero_rom_data = 32'b00000000001100000000110000000000; // ********
      6'hD: Zero_rom_data = 32'b00000000001100000000110000000000; // ********
      6'hE: Zero_rom_data = 32'b00000000000011111111000000000000; //  ******
      6'hF: Zero_rom_data = 32'b00000000000011111111000000000000; //   ****

   endcase

    //------------------------------------------
	 // Register for Zero logo
	 //------------------------------------------
	  // registers
   always @(posedge clk, posedge reset)
      if (reset)
         begin
           
			Zero_y_reg <= 0;
            
         end
      else
         begin
            
		   	Zero_x_reg <= Zero_x_next;
		   	Zero_y_reg <= Zero_y_next;
            
         end


	//--------------------------------------------
   // Zero Logo
   //--------------------------------------------
   // boundary
   assign Zero_x_l = Zero_x_reg;
   assign Zero_y_t = Zero_y_reg;
   assign Zero_x_r = Zero_x_l + Zero_Logo_x - 1;
   assign Zero_y_b = Zero_y_t + Zero_Logo_y - 1;
   // pixel within logo
   assign Logo_on =
            (Zero_X_L<=pix_x) && (pix_x<=Zero_x_r) &&
            (Zero_X_T<=pix_y) && (pix_y<=Zero_y_b);

	  //assign Logo_on =
     //       (Zero_x_l<=Zero_X_L) && (pix_x<=Zero_x_r) &&
     //       (Zero_y_t<=Zero_X_T) && (pix_y<=Zero_y_b);
   // map current pixel location to ROM addr/col
   assign Zero_rom_addr = pix_y[3:0] - Zero_y_t[3:0];
   assign Zero_rom_col = pix_x[4:0] - Zero_x_l[4:0];
   assign Zero_rom_bit = Zero_rom_data[Zero_rom_col];
   // pixel within logo
   assign zero_on = (Logo_on & Zero_rom_bit);
   assign zero_rgb = 3'b101; 
   
   //  assign Zero_x_next = (refr_tick)?  Zero_x_reg + 1'b1:Zero_x_reg;
   //	 assign Zero_y_next = (refr_tick) ? Zero_y_reg + 1'b1:Zero_y_reg;
   assign Zero_x_next = (refr_tick) ?  Zero_x_reg: Zero_X_L;
   assign Zero_y_next = (refr_tick) ? Zero_y_reg : Zero_X_T ;


endmodule
