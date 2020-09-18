module Three_3(clk, reset,video_on, refr_tick,pix_x,pix_y,three_on,three_rgb);
    input clk, reset;
    input video_on, refr_tick;
    input [9:0] pix_x;
    input [9:0] pix_y;
    output three_on;
    output [2:0] three_rgb;

  
  //--------------------------------------------
   // Three Logo
   //--------------------------------------------
   wire [3:0] Three_rom_addr; 
	wire [4:0] Three_rom_col;
   reg [31:0] Three_rom_data;
   wire Three_rom_bit,Three_Logo_on, Logo_on ;
   //--------------------------------------------
   // Three Logo Positioning
   //--------------------------------------------
   // Logo Position left, Top boundary
   localparam Three_X_L = 300;
	localparam Three_X_R = 331;
   localparam Three_X_T = 10;
	localparam Three_X_B = 25;
   
   localparam Three_Logo_x = 32;
   localparam Three_Logo_y = 16;

	 // Three left, right boundary
   wire [9:0] Three_x_l, Three_x_r;
   // Three top, bottom boundary
   wire [9:0] Three_y_t, Three_y_b;
   // reg to track left, top position
   reg [9:0] Three_x_reg, Three_y_reg;
   wire [9:0] Three_x_next, Three_y_next; 

	// body
   //--------------------------------------------
   // Three Logo
   //--------------------------------------------
   always @*
   case (Three_rom_addr)
      6'h0: Three_rom_data = 32'b00000000011111111111110000000000; //   ****
      6'h1: Three_rom_data = 32'b00000000111111111111111000000000; //  ******
      6'h2: Three_rom_data = 32'b00000001111000000001111100000000; // ********
      6'h3: Three_rom_data = 32'b00000000000000000000111100000000; // ********
      6'h4: Three_rom_data = 32'b00000000000000000011111100000000; // ********
      6'h5: Three_rom_data = 32'b00000000000000011111111000000000; // ********
      6'h6: Three_rom_data = 32'b00000000000011111111100000000000; //  ******
      6'h7: Three_rom_data = 32'b00000000000011111110000000000000; //   ****
	  6'h8: Three_rom_data = 32'b00000000000011111110000000000000; //   ****
      6'h9: Three_rom_data = 32'b00000000000000011111000000000000; //  ******
      6'hA: Three_rom_data = 32'b00000000000000000111110000000000; // ********
      6'hB: Three_rom_data = 32'b00000000000000000001111100000000; // ********
      6'hC: Three_rom_data = 32'b00000000000000000000111100000000; // ********
      6'hD: Three_rom_data = 32'b00000001111000000000111100000000; // ********
      6'hE: Three_rom_data = 32'b00000000111111111111111000000000; //  ******
      6'hF: Three_rom_data = 32'b00000000011111111111110000000000; //   ****

   endcase

    //------------------------------------------
	 // Register for Three logo
	 //------------------------------------------
	  // registers
   always @(posedge clk, posedge reset)
      if (reset)
         begin
           
			Three_y_reg <= 0;
            
         end
      else
         begin
            
		   	Three_x_reg <= Three_x_next;
		   	Three_y_reg <= Three_y_next;
            
         end


	//--------------------------------------------
   // Three Logo
   //--------------------------------------------
   // boundary
   assign Three_x_l = Three_x_reg;
   assign Three_y_t = Three_y_reg;
   assign Three_x_r = Three_x_l + Three_Logo_x - 1;
   assign Three_y_b = Three_y_t + Three_Logo_y - 1;
   // pixel within logo
   assign Logo_on =
            (Three_X_L<=pix_x) && (pix_x<=Three_x_r) &&
            (Three_X_T<=pix_y) && (pix_y<=Three_y_b);

	  //assign Logo_on =
     //       (Three_x_l<=Three_X_L) && (pix_x<=Three_x_r) &&
     //       (Three_y_t<=Three_X_T) && (pix_y<=Three_y_b);
   // map current pixel location to ROM addr/col
   assign Three_rom_addr = pix_y[3:0] - Three_y_t[3:0];
   assign Three_rom_col = pix_x[4:0] - Three_x_l[4:0];
   assign Three_rom_bit = Three_rom_data[Three_rom_col];
   // pixel within logo
   assign three_on = (Logo_on & Three_rom_bit);
   assign three_rgb = 3'b101; 
   
   //  assign Three_x_next = (refr_tick)?  Three_x_reg + 1'b1:Three_x_reg;
   //	 assign Three_y_next = (refr_tick) ? Three_y_reg + 1'b1:Three_y_reg;
   assign Three_x_next = (refr_tick) ?  Three_x_reg: Three_X_L;
   assign Three_y_next = (refr_tick) ? Three_y_reg : Three_X_T ;



endmodule
