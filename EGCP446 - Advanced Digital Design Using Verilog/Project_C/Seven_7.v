module Seven_7(clk, reset,video_on, refr_tick,pix_x,pix_y,Seven_on,Seven_rgb);
    input clk, reset;
    input video_on, refr_tick;
    input [9:0] pix_x;
    input [9:0] pix_y;
    output Seven_on;
    output [2:0] Seven_rgb;

  
  //--------------------------------------------
   // Seven Logo
   //--------------------------------------------
   wire [3:0] Seven_rom_addr; 
	wire [4:0] Seven_rom_col;
   reg [31:0] Seven_rom_data;
   wire Seven_rom_bit,Seven_Logo_on, Logo_on ;
   //--------------------------------------------
   // Seven Logo Positioning
   //--------------------------------------------
   // Logo Position left, Top boundary
   localparam Seven_X_L = 300;
	localparam Seven_X_R = 331;
   localparam Seven_X_T = 10;
	localparam Seven_X_B = 25;
   
   localparam Seven_Logo_x = 32;
   localparam Seven_Logo_y = 16;

	 // Seven left, right boundary
   wire [9:0] Seven_x_l, Seven_x_r;
   // Seven top, bottom boundary
   wire [9:0] Seven_y_t, Seven_y_b;
   // reg to track left, top position
   reg [9:0] Seven_x_reg, Seven_y_reg;
   wire [9:0] Seven_x_next, Seven_y_next; 

	// body
   //--------------------------------------------
   // Seven Logo
   //--------------------------------------------
   always @*							    
   case (Seven_rom_addr)
      6'h0: Seven_rom_data = 32'b00000011111111111111111000000000; //   ****
      6'h1: Seven_rom_data = 33'b00000011111111111111111000000000; //  ******
      6'h2: Seven_rom_data = 32'b00000001110000000000000000000000; // ********
      6'h3: Seven_rom_data = 32'b00000000111000000000000000000000; // ********
      6'h4: Seven_rom_data = 32'b00000000011100000000000000000000; // ********
      6'h5: Seven_rom_data = 32'b00000000001110000000000000000000; // ********
      6'h6: Seven_rom_data = 32'b00000000000111000000000000000000; //  ******
      6'h7: Seven_rom_data = 32'b00000000000011100000000000000000; //   ****
	 6'h8: Seven_rom_data = 32'b00000000000001110000000000000000; //   ****
      6'h9: Seven_rom_data = 32'b00000000000000111000000000000000; //  ******
      6'hA: Seven_rom_data = 32'b00000000000000011100000000000000; // ********
      6'hB: Seven_rom_data = 32'b00000000000000001110000000000000; // ********
      6'hC: Seven_rom_data = 32'b00000000000000000111000000000000; // ********
      6'hD: Seven_rom_data = 32'b00000000000000000011100000000000; // ********
      6'hE: Seven_rom_data = 32'b00000000000000000001110000000000; //  ******
      6'hF: Seven_rom_data = 32'b00000000000000000000111000000000; //   ****

   endcase

    //------------------------------------------
	 // Register for Seven logo
	 //------------------------------------------
	  // registers
   always @(posedge clk, posedge reset)
      if (reset)
         begin
           
			Seven_y_reg <= 0;
            
         end
      else
         begin
            
		   	Seven_x_reg <= Seven_x_next;
		   	Seven_y_reg <= Seven_y_next;
            
         end


	//--------------------------------------------
   // Seven Logo
   //--------------------------------------------
   // boundary
   assign Seven_x_l = Seven_x_reg;
   assign Seven_y_t = Seven_y_reg;
   assign Seven_x_r = Seven_x_l + Seven_Logo_x - 1;
   assign Seven_y_b = Seven_y_t + Seven_Logo_y - 1;
   // pixel within logo
   assign Logo_on =
            (Seven_X_L<=pix_x) && (pix_x<=Seven_x_r) &&
            (Seven_X_T<=pix_y) && (pix_y<=Seven_y_b);

	  //assign Logo_on =
     //       (Seven_x_l<=Seven_X_L) && (pix_x<=Seven_x_r) &&
     //       (Seven_y_t<=Seven_X_T) && (pix_y<=Seven_y_b);
   // map current pixel location to ROM addr/col
   assign Seven_rom_addr = pix_y[3:0] - Seven_y_t[3:0];
   assign Seven_rom_col = pix_x[4:0] - Seven_x_l[4:0];
   assign Seven_rom_bit = Seven_rom_data[Seven_rom_col];
   // pixel within logo
   assign Seven_on = (Logo_on & Seven_rom_bit);
   assign Seven_rgb = 3'b101; 
   
   //  assign Seven_x_next = (refr_tick)?  Seven_x_reg + 1'b1:Seven_x_reg;
   //	 assign Seven_y_next = (refr_tick) ? Seven_y_reg + 1'b1:Seven_y_reg;
   assign Seven_x_next = (refr_tick) ?  Seven_x_reg: Seven_X_L;
   assign Seven_y_next = (refr_tick) ? Seven_y_reg : Seven_X_T ;



endmodule
