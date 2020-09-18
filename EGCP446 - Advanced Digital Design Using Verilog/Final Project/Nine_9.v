module Nine_9(clk, reset,video_on, refr_tick,pix_x,pix_y,Nine_on,Nine_rgb);
    input clk, reset;
    input video_on, refr_tick;
    input [9:0] pix_x;
    input [9:0] pix_y;
    output Nine_on;
    output [2:0] Nine_rgb;

  
  //--------------------------------------------
   // Nine Logo
   //--------------------------------------------
   wire [3:0] Nine_rom_addr; 
	wire [4:0] Nine_rom_col;
   reg [31:0] Nine_rom_data;
   wire Nine_rom_bit,Nine_Logo_on, Logo_on ;
   //--------------------------------------------
   // Nine Logo Positioning
   //--------------------------------------------
   // Logo Position left, Top boundary
   localparam Nine_X_L = 300;
	localparam Nine_X_R = 331;
   localparam Nine_X_T = 10;
	localparam Nine_X_B = 25;
   
   localparam Nine_Logo_x = 32;
   localparam Nine_Logo_y = 16;

	 // Nine left, right boundary
   wire [9:0] Nine_x_l, Nine_x_r;
   // Nine top, bottom boundary
   wire [9:0] Nine_y_t, Nine_y_b;
   // reg to track left, top position
   reg [9:0] Nine_x_reg, Nine_y_reg;
   wire [9:0] Nine_x_next, Nine_y_next; 

	// body
   //--------------------------------------------
   // Nine Logo
   //--------------------------------------------
   always @*
   case (Nine_rom_addr)
      6'h0: Nine_rom_data = 32'b00000000000011111110000000000000; //   ****
      6'h1: Nine_rom_data = 33'b00000000000111100111110000000000; //  ******
      6'h2: Nine_rom_data = 32'b00000000001110000001110000000000; // ********
      6'h3: Nine_rom_data = 32'b00000000011100000000110000000000; // ********
      6'h4: Nine_rom_data = 32'b00000000011100000000110000000000; // ********
      6'h5: Nine_rom_data = 32'b00000000011110000011110000000000; // ********
      6'h6: Nine_rom_data = 32'b00000000011111100111110000000000; //  ******
      6'h7: Nine_rom_data = 32'b00000000011111111110000000000000; //   ****
	 6'h8: Nine_rom_data = 32'b00000000011100000000000000000000; //   ****
      6'h9: Nine_rom_data = 32'b00000000011100000000000000000000; //  ******
      6'hA: Nine_rom_data = 32'b00000000011100000000000000000000; // ********
      6'hB: Nine_rom_data = 32'b00000000011100000000000000000000; // ********
      6'hC: Nine_rom_data = 32'b00000000011100000000000000000000; // ********
      6'hD: Nine_rom_data = 32'b00000000001110000000110000000000; // ********
      6'hE: Nine_rom_data = 32'b00000000000111111111110000000000; //  ******
      6'hF: Nine_rom_data = 32'b00000000000011111111000000000000; //   ****

   endcase

    //------------------------------------------
	 // Register for Nine logo
	 //------------------------------------------
	  // registers
   always @(posedge clk, posedge reset)
      if (reset)
         begin
           
			Nine_y_reg <= 0;
            
         end
      else
         begin
            
		   	Nine_x_reg <= Nine_x_next;
		   	Nine_y_reg <= Nine_y_next;
            
         end


	//--------------------------------------------
   // Nine Logo
   //--------------------------------------------
   // boundary
   assign Nine_x_l = Nine_x_reg;
   assign Nine_y_t = Nine_y_reg;
   assign Nine_x_r = Nine_x_l + Nine_Logo_x - 1;
   assign Nine_y_b = Nine_y_t + Nine_Logo_y - 1;
   // pixel within logo
   assign Logo_on =
            (Nine_X_L<=pix_x) && (pix_x<=Nine_x_r) &&
            (Nine_X_T<=pix_y) && (pix_y<=Nine_y_b);

	  //assign Logo_on =
     //       (Nine_x_l<=Nine_X_L) && (pix_x<=Nine_x_r) &&
     //       (Nine_y_t<=Nine_X_T) && (pix_y<=Nine_y_b);
   // map current pixel location to ROM addr/col
   assign Nine_rom_addr = pix_y[3:0] - Nine_y_t[3:0];
   assign Nine_rom_col = pix_x[4:0] - Nine_x_l[4:0];
   assign Nine_rom_bit = Nine_rom_data[Nine_rom_col];
   // pixel within logo
   assign Nine_on = (Logo_on & Nine_rom_bit);
   assign Nine_rgb = 3'b101; 
   
   //  assign Nine_x_next = (refr_tick)?  Nine_x_reg + 1'b1:Nine_x_reg;
   //	 assign Nine_y_next = (refr_tick) ? Nine_y_reg + 1'b1:Nine_y_reg;
   assign Nine_x_next = (refr_tick) ?  Nine_x_reg: Nine_X_L;
   assign Nine_y_next = (refr_tick) ? Nine_y_reg : Nine_X_T ;



endmodule
