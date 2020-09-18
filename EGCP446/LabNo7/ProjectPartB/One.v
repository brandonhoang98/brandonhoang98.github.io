module One_1(clk, reset,video_on, refr_tick,pix_x,pix_y,one_on,one_rgb);
    input clk, reset;
    input video_on, refr_tick;
    input [9:0] pix_x;
    input [9:0] pix_y;
    output one_on;
    output [2:0] one_rgb;

  
  //--------------------------------------------
   // One Logo
   //--------------------------------------------
   wire [3:0] One_rom_addr; 
	wire [4:0] One_rom_col;
   reg [31:0] One_rom_data;
   wire One_rom_bit,One_Logo_on, Logo_on ;
   //--------------------------------------------
   // One Logo Positioning
   //--------------------------------------------
   // Logo Position left, Top boundary
   localparam One_X_L = 300;
	localparam One_X_R = 331;
   localparam One_X_T = 10;
	localparam One_X_B = 25;
   
   localparam One_Logo_x = 32;
   localparam One_Logo_y = 16;

	 // One left, right boundary
   wire [9:0] One_x_l, One_x_r;
   // One top, bottom boundary
   wire [9:0] One_y_t, One_y_b;
   // reg to track left, top position
   reg [9:0] One_x_reg, One_y_reg;
   wire [9:0] One_x_next, One_y_next; 

	// body
   //--------------------------------------------
   // One Logo
   //--------------------------------------------
   always @*
   case (One_rom_addr)
      6'h0: One_rom_data = 32'b00000000000000000001100000000000; //   ****
      6'h1: One_rom_data = 33'b00000000000000000001100000000000; //  ******
      6'h2: One_rom_data = 32'b00000000000000000001100000000000; // ********
      6'h3: One_rom_data = 32'b00000000000000000001100000000000; // ********
      6'h4: One_rom_data = 32'b00000000000000000001100000000000; // ********
      6'h5: One_rom_data = 32'b00000000000000000001100000000000; // ********
      6'h6: One_rom_data = 32'b00000000000000000001100000000000; //  ******
      6'h7: One_rom_data = 32'b00000000000000000000000000000000; //   ****
	   6'h8: One_rom_data = 32'b00000000000000000000000000000000; //   ****
      6'h9: One_rom_data = 32'b00000000000000000001100000000000; //  ******
      6'hA: One_rom_data = 32'b00000000000000000001100000000000; // ********
      6'hB: One_rom_data = 32'b00000000000000000001100000000000; // ********
      6'hC: One_rom_data = 32'b00000000000000000001100000000000; // ********
      6'hD: One_rom_data = 32'b00000000000000000001100000000000; // ********
      6'hE: One_rom_data = 32'b00000000000000000001100000000000; //  ******
      6'hF: One_rom_data = 32'b00000000000000000001100000000000; //   ****

   endcase

    //------------------------------------------
	 // Register for One logo
	 //------------------------------------------
	  // registers
   always @(posedge clk, posedge reset)
      if (reset)
         begin
           
			One_y_reg <= 0;
            
         end
      else
         begin
            
		   	One_x_reg <= One_x_next;
		   	One_y_reg <= One_y_next;
            
         end


	//--------------------------------------------
   // One Logo
   //--------------------------------------------
   // boundary
   assign One_x_l = One_x_reg;
   assign One_y_t = One_y_reg;
   assign One_x_r = One_x_l + One_Logo_x - 1;
   assign One_y_b = One_y_t + One_Logo_y - 1;
   // pixel within logo
   assign Logo_on =
            (One_X_L<=pix_x) && (pix_x<=One_x_r) &&
            (One_X_T<=pix_y) && (pix_y<=One_y_b);

	  //assign Logo_on =
     //       (One_x_l<=One_X_L) && (pix_x<=One_x_r) &&
     //       (One_y_t<=One_X_T) && (pix_y<=One_y_b);
   // map current pixel location to ROM addr/col
   assign One_rom_addr = pix_y[3:0] - One_y_t[3:0];
   assign One_rom_col = pix_x[4:0] - One_x_l[4:0];
   assign One_rom_bit = One_rom_data[One_rom_col];
   // pixel within logo
   assign one_on = (Logo_on & One_rom_bit);
   assign one_rgb = 3'b101; 
   
   //  assign One_x_next = (refr_tick)?  One_x_reg + 1'b1:One_x_reg;
   //	 assign One_y_next = (refr_tick) ? One_y_reg + 1'b1:One_y_reg;
   assign One_x_next = (refr_tick) ?  One_x_reg: One_X_L;
   assign One_y_next = (refr_tick) ? One_y_reg : One_X_T ;



endmodule
