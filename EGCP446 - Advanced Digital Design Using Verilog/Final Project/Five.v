module Five_5(clk, reset,video_on,refr_tick, pix_x, pix_y,five_on,five_rgb);
    input clk, reset;
    input video_on, refr_tick;
    input [9:0] pix_x, pix_y;
    output five_on;
    output [2:0] five_rgb;

  //--------------------------------------------
   // Five Logo
   //--------------------------------------------
   wire [3:0] Five_rom_addr; 
	wire [4:0] Five_rom_col;
   reg [31:0] Five_rom_data;
   wire Five_rom_bit,Five_Logo_on, Logo_on ;
   //--------------------------------------------
   // Five Logo Positioning
   //--------------------------------------------
   // Logo Position left, Top boundary
   localparam Five_X_L = 300;
	localparam Five_X_R = 331;
   localparam Five_X_T = 10;
	localparam Five_X_B = 25;
   
   localparam Five_Logo_x = 32;
   localparam Five_Logo_y = 16;

	 // Five left, right boundary
   wire [9:0] Five_x_l, Five_x_r;
   // Five top, bottom boundary
   wire [9:0] Five_y_t, Five_y_b;
   // reg to track left, top position
   reg [9:0] Five_x_reg, Five_y_reg;
   wire [9:0] Five_x_next, Five_y_next; 

	// body
   //--------------------------------------------
   // Five Logo
   //--------------------------------------------
   always @*
   case (Five_rom_addr)
      6'h0: Five_rom_data = 32'b00000000111111111111111000000000; //   ****
      6'h1: Five_rom_data = 33'b00000000111111111111111000000000; //  ******
      6'h2: Five_rom_data = 32'b00000000000000000000111000000000; // ********
      6'h3: Five_rom_data = 32'b00000000000000000000111000000000; // ********
      6'h4: Five_rom_data = 32'b00000000000000000000111000000000; // ********
      6'h5: Five_rom_data = 32'b00000000000000000000111000000000; // ********
      6'h6: Five_rom_data = 32'b00000000000000000000111000000000; //  ******
      6'h7: Five_rom_data = 32'b00000000111111111111111000000000; //   ****
	 6'h8: Five_rom_data = 32'b00000000111111111111111000000000; //   ****
      6'h9: Five_rom_data = 32'b00000000111000000000000000000000; //  ******
      6'hA: Five_rom_data = 32'b00000000111000000000000000000000; // ********
      6'hB: Five_rom_data = 32'b00000000111000000000000000000000; // ********
      6'hC: Five_rom_data = 32'b00000000111000000000000000000000; // ********
      6'hD: Five_rom_data = 32'b00000000111000000000000000000000; // ********
      6'hE: Five_rom_data = 32'b00000000111111111111111000000000; //  ******
      6'hF: Five_rom_data = 32'b00000000111111111111111000000000; //   ****

   endcase

    //------------------------------------------
	 // Register for Five logo
	 //------------------------------------------
	  // registers
   always @(posedge clk, posedge reset)
      if (reset)
         begin
           
			Five_y_reg <= 0;
            
         end
      else
         begin
            
		   	Five_x_reg <= Five_x_next;
		   	Five_y_reg <= Five_y_next;
            
         end

	//--------------------------------------------
   // Five Logo
   //--------------------------------------------
   // boundary
   assign Five_x_l = Five_x_reg;
   assign Five_y_t = Five_y_reg;
   assign Five_x_r = Five_x_l + Five_Logo_x - 1;
   assign Five_y_b = Five_y_t + Five_Logo_y - 1;
   // pixel within logo
   assign Logo_on =
            (Five_X_L<=pix_x) && (pix_x<=Five_x_r) &&
            (Five_X_T<=pix_y) && (pix_y<=Five_y_b);

	  //assign Logo_on =
     //       (Five_x_l<=Five_X_L) && (pix_x<=Five_x_r) &&
     //       (Five_y_t<=Five_X_T) && (pix_y<=Five_y_b);
   // map current pixel location to ROM addr/col
   assign Five_rom_addr = pix_y[3:0] - Five_y_t[3:0];
   assign Five_rom_col = pix_x[4:0] - Five_x_l[4:0];
   assign Five_rom_bit = Five_rom_data[Five_rom_col];
   // pixel within logo
   assign five_on = (Logo_on & Five_rom_bit);
   assign five_rgb = 3'b101; 
   
   //  assign Five_x_next = (refr_tick)?  Five_x_reg + 1'b1:Five_x_reg;
   //	 assign Five_y_next = (refr_tick) ? Five_y_reg + 1'b1:Five_y_reg;
   assign Five_x_next = (refr_tick) ?  Five_x_reg: Five_X_L;
   assign Five_y_next = (refr_tick) ? Five_y_reg : Five_X_T ;

endmodule

