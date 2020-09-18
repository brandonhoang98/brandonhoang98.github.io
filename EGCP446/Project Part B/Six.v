module Six_3(clk, reset,video_on, refr_tick,pix_x, pix_y,six_on,six_rgb);
    input clk, reset;
    input video_on, refr_tick;
    input [9:0] pix_x, pix_y;
    output six_on;
    output [2:0] six_rgb;

 
  //--------------------------------------------
   // Six Logo
   //--------------------------------------------
   wire [3:0] Six_rom_addr; 
	wire [4:0] Six_rom_col;
   reg [31:0] Six_rom_data;
   wire Six_rom_bit,Six_Logo_on, Logo_on ;
   //--------------------------------------------
   // Six Logo Positioning
   //--------------------------------------------
   // Logo Position left, Top boundary
   localparam Six_X_L = 300;
	localparam Six_X_R = 331;
   localparam Six_X_T = 10;
	localparam Six_X_B = 25;
   
   localparam Six_Logo_x = 32;
   localparam Six_Logo_y = 16;

	 // Six left, right boundary
   wire [9:0] Six_x_l, Six_x_r;
   // Six top, bottom boundary
   wire [9:0] Six_y_t, Six_y_b;
   // reg to track left, top position
   reg [9:0] Six_x_reg, Six_y_reg;
   wire [9:0] Six_x_next, Six_y_next; 

	// body
   //--------------------------------------------
   // Six Logo
   //--------------------------------------------
always @*
   case (Zero_rom_addr)
      6'h0: Zero_rom_data = 32'b00000000000011111111000000000000; //   ****
      6'h1: Zero_rom_data = 33'b00000000001111111111100000000000; //  ******
      6'h2: Zero_rom_data = 32'b00000000011111111111110000000000; // ********
      6'h3: Zero_rom_data = 32'b00000000111111000111111000000000; // ********
      6'h4: Zero_rom_data = 32'b00000001111110000011111100000000; // ********
      6'h5: Zero_rom_data = 32'b00000001111100000001111100000000; // ********
      6'h6: Zero_rom_data = 32'b00000011111100000000000000000000; //  ******
      6'h7: Zero_rom_data = 32'b00000011111100000000000000000000; //   ****
6'h8: Zero_rom_data = 32'b00000011111001111111000000000000; //   ****
      6'h9: Zero_rom_data = 32'b00000011111111111111111000000000; //  ******
      6'hA: Zero_rom_data = 32'b00000011111110000011111100000000; // ********
      6'hB: Zero_rom_data = 32'b00000011111100000011111100000000; // ********
      6'hC: Zero_rom_data = 32'b00000001111110000011111100000000; // ********
      6'hD: Zero_rom_data = 32'b00000001111111000111111100000000; // ********
      6'hE: Zero_rom_data = 32'b00000000001111111111100000000000; //  ******
      6'hF: Zero_rom_data = 32'b00000000000111111111000000000000; //   ****

   endcase

    //------------------------------------------
	 // Register for Six logo
	 //------------------------------------------
	  // registers
   always @(posedge clk, posedge reset)
      if (reset)
         begin
           
			Six_y_reg <= 0;
            
         end
      else
         begin
            
		   	Six_x_reg <= Six_x_next;
		   	Six_y_reg <= Six_y_next;
            
         end


	//--------------------------------------------
   // Six Logo
   //--------------------------------------------
   // boundary
   assign Six_x_l = Six_x_reg;
   assign Six_y_t = Six_y_reg;
   assign Six_x_r = Six_x_l + Six_Logo_x - 1;
   assign Six_y_b = Six_y_t + Six_Logo_y - 1;
   // pixel within logo
   assign Logo_on =
            (Six_X_L<=pix_x) && (pix_x<=Six_x_r) &&
            (Six_X_T<=pix_y) && (pix_y<=Six_y_b);

	  //assign Logo_on =
     //       (Six_x_l<=Six_X_L) && (pix_x<=Six_x_r) &&
     //       (Six_y_t<=Six_X_T) && (pix_y<=Six_y_b);
   // map current pixel location to ROM addr/col
   assign Six_rom_addr = pix_y[3:0] - Six_y_t[3:0];
   assign Six_rom_col = pix_x[4:0] - Six_x_l[4:0];
   assign Six_rom_bit = Six_rom_data[Six_rom_col];
   // pixel within logo
   assign six_on = (Logo_on & Six_rom_bit);
   assign six_rgb = 3'b101; 
   
   //  assign Six_x_next = (refr_tick)?  Six_x_reg + 1'b1:Six_x_reg;
   //	 assign Six_y_next = (refr_tick) ? Six_y_reg + 1'b1:Six_y_reg;
   assign Six_x_next = (refr_tick) ?  Six_x_reg: Six_X_L;
   assign Six_y_next = (refr_tick) ? Six_y_reg : Six_X_T ;

endmodule
