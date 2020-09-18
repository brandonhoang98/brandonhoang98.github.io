// Listing 13.5
module pong_graph_animate
   (
    input wire clk, reset,
    input wire video_on,
    input wire [1:0] btn,
	input wire [3:0] sel,
    input wire [9:0] pix_x, pix_y,
    output reg [2:0] graph_rgb
   );

   // constant and signal declaration
   // x, y coordinates (0,0) to (639,479)
   localparam MAX_X = 640;
   localparam MAX_Y = 480;
   wire refr_tick;
   //--------------------------------------------
   // vertical stripe as a wall
   //--------------------------------------------
   // wall left, right boundary
   localparam WALL_X_L = 32;
   localparam WALL_X_R = 35;
   //--------------------------------------------
   // right vertical bar
   //--------------------------------------------
   // bar left, right boundary
   localparam BAR_X_L = 600;
   localparam BAR_X_R = 603;
   // bar top, bottom boundary
   wire [9:0] bar_y_t, bar_y_b;
   localparam BAR_Y_SIZE = 72;
   // register to track top boundary  (x position is fixed)
   reg [9:0] bar_y_reg, bar_y_next;
   // bar moving velocity when a button is pressed
   localparam BAR_V = 4;
   //--------------------------------------------
   // square ball
   //--------------------------------------------
   localparam BALL_SIZE = 8;
   // ball left, right boundary
   wire [9:0] ball_x_l, ball_x_r;
   // ball top, bottom boundary
   wire [9:0] ball_y_t, ball_y_b;
   // reg to track left, top position
   reg [9:0] ball_x_reg, ball_y_reg;
   wire [9:0] ball_x_next, ball_y_next;
   // reg to track ball speed
   reg [9:0] x_delta_reg, x_delta_next;
   reg [9:0] y_delta_reg, y_delta_next;
   // ball velocity can be pos or neg)
   localparam BALL_V_P = 2;
   localparam BALL_V_N = -2;
   //--------------------------------------------
   // round ball
   //--------------------------------------------
   wire [2:0] rom_addr, rom_col;
   reg [7:0] rom_data;
   wire rom_bit;
   

	

   //--------------------------------------------
   // object output signals
   //--------------------------------------------
   wire wall_on, bar_on, sq_ball_on, Score_on,rd_ball_on, Zero_Logo_on,One_Logo_on, Two_Logo_on, Three_Logo_on, Four_Logo_on, Five_Logo_on, Six_Logo_on, Seven_Logo_on, Eight_Logo_on, Nine_Logo_on;
   wire [2:0] wall_rgb, bar_rgb, ball_rgb, Zero_rgb, One_rgb, Two_rgb,Three_rgb, Four_rgb, Five_rgb, Six_rgb, Seven_rgb, Eight_rgb, Nine_rgb, Score_rgb;

   // body
   //--------------------------------------------
   // round ball image ROM
   //--------------------------------------------
   always @*
   case (rom_addr)
      3'h0: rom_data = 8'b00111100; //   ****
      3'h1: rom_data = 8'b01111110; //  ******
      3'h2: rom_data = 8'b11111111; // ********
      3'h3: rom_data = 8'b11111111; // ********
      3'h4: rom_data = 8'b11111111; // ********
      3'h5: rom_data = 8'b11111111; // ********
      3'h6: rom_data = 8'b01111110; //  ******
      3'h7: rom_data = 8'b00111100; //   ****
   endcase
 
 // Selector for numbers
 Zero_0 Z0 (.clk(clk), .reset(reset),.video_on(video_on), .refr_tick(refr_tick), .pix_x(pix_x),.pix_y(pix_y), .zero_on(Zero_Logo_on),.zero_rgb(Zero_rgb));
 One_1 Z1 (.clk(clk), .reset(reset),.video_on(video_on), .refr_tick(refr_tick), .pix_x(pix_x),.pix_y(pix_y), .one_on(One_Logo_on),.one_rgb(One_rgb));
 Two_2 Z2 (.clk(clk), .reset(reset),.video_on(video_on), .refr_tick(refr_tick), .pix_x(pix_x),.pix_y(pix_y), .two_on(Two_Logo_on),.two_rgb(Two_rgb));
 Three_3 Z3 (.clk(clk), .reset(reset),.video_on(video_on), .refr_tick(refr_tick), .pix_x(pix_x),.pix_y(pix_y), .three_on(Three_Logo_on),.three_rgb(Three_rgb));
 Four_4 Z4 (.clk(clk), .reset(reset),.video_on(video_on), .refr_tick(refr_tick), .pix_x(pix_x),.pix_y(pix_y), .Four_on(Four_Logo_on),.Four_rgb(Four_rgb));
 Five_5 Z5 (.clk(clk), .reset(reset),.video_on(video_on), .refr_tick(refr_tick), .pix_x(pix_x),.pix_y(pix_y), .five_on(Five_Logo_on),.five_rgb(Five_rgb));
 Six_6 Z6 (.clk(clk), .reset(reset),.video_on(video_on), .refr_tick(refr_tick), .pix_x(pix_x),.pix_y(pix_y), .six_on(Six_Logo_on),.six_rgb(Six_rgb));
 Seven_7 Z7 (.clk(clk), .reset(reset),.video_on(video_on), .refr_tick(refr_tick), .pix_x(pix_x),.pix_y(pix_y), .Seven_on(Seven_Logo_on),.Seven_rgb(Seven_rgb));
 Eight_8 Z8 (.clk(clk), .reset(reset),.video_on(video_on), .refr_tick(refr_tick), .pix_x(pix_x),.pix_y(pix_y), .eight_on(Eight_Logo_on),.eight_rgb(Eight_rgb));
 Nine_9 Z9 (.clk(clk), .reset(reset),.video_on(video_on), .refr_tick(refr_tick), .pix_x(pix_x),.pix_y(pix_y), .Nine_on(Nine_Logo_on),.Nine_rgb(Nine_rgb));
 
 /////
   


 
   assign Score_on = (sel==4'b0000) ? Zero_Logo_on:
                     (sel==4'b0001) ? One_Logo_on:
					 (sel==4'b0010) ? Two_Logo_on:
					 (sel==4'b0011) ? Three_Logo_on:
					 (sel==4'b0100) ? Four_Logo_on:
					 (sel==4'b0101) ? Five_Logo_on:
					 (sel==4'b0110) ? Six_Logo_on:
					 (sel==4'b0111) ? Seven_Logo_on:
					 (sel==4'b1000) ? Eight_Logo_on:
					 (sel==4'b1001) ? Nine_Logo_on :
					 Zero_Logo_on;
					 
     assign  Score_rgb	= (sel==4'b0000) ? Zero_rgb:
                     (sel==4'b0001) ? One_rgb:
					 (sel==4'b0010) ? Two_rgb:
					 (sel==4'b0011) ? Three_rgb:
					 (sel==4'b0100) ? Four_rgb:
					 (sel==4'b0101) ? Five_rgb:
					 (sel==4'b0110) ? Six_rgb:
					 (sel==4'b0111) ? Seven_rgb:
					 (sel==4'b1000) ? Eight_rgb:
					 (sel==4'b1001) ? Nine_rgb :
					 Zero_rgb;				 
   
  // registers
   always @(posedge clk, posedge reset)
      if (reset)
         begin
            bar_y_reg <= 0;
            ball_x_reg <= 0;
            ball_y_reg <= 0;
			
            x_delta_reg <= 10'h004;
            y_delta_reg <= 10'h004;
         end
      else
         begin
            bar_y_reg <= bar_y_next;
            ball_x_reg <= ball_x_next;
            ball_y_reg <= ball_y_next;
		   	
            x_delta_reg <= x_delta_next;
            y_delta_reg <= y_delta_next;
         end

   // refr_tick: 1-clock tick asserted at start of v-sync
   //            i.e., when the screen is refreshed (60 Hz)
   assign refr_tick = (pix_y==481) && (pix_x==0);

   //--------------------------------------------
   // (wall) left vertical strip
   //--------------------------------------------
   // pixel within wall
   assign wall_on = (WALL_X_L<=pix_x) && (pix_x<=WALL_X_R);
   // wall rgb output
   assign wall_rgb = 3'b001; // blue
   //--------------------------------------------
   // right vertical bar
   //--------------------------------------------
   // boundary
   assign bar_y_t = bar_y_reg;
   assign bar_y_b = bar_y_t + BAR_Y_SIZE - 1;
   // pixel within bar
   assign bar_on = (BAR_X_L<=pix_x) && (pix_x<=BAR_X_R) &&
                   (bar_y_t<=pix_x) && (pix_y<=bar_y_b);
   // bar rgb output
   assign bar_rgb = 3'b010; // green
   // new bar y-position
   always @*
   begin
      bar_y_next = bar_y_reg; // no move
      if (refr_tick)
         if (btn[1] & (bar_y_b < (MAX_Y-1-BAR_V)))
            bar_y_next = bar_y_reg + BAR_V; // move down
         else if (btn[0] & (bar_y_t > BAR_V))
            bar_y_next = bar_y_reg - BAR_V; // move up
   end

   //--------------------------------------------
   // square ball
   //--------------------------------------------
   // boundary
   assign ball_x_l = ball_x_reg;
   assign ball_y_t = ball_y_reg;
   assign ball_x_r = ball_x_l + BALL_SIZE - 1;
   assign ball_y_b = ball_y_t + BALL_SIZE - 1;
   // pixel within ball
   assign sq_ball_on =
            (ball_x_l<=pix_x) && (pix_x<=ball_x_r) &&
            (ball_y_t<=pix_y) && (pix_y<=ball_y_b);
   // map current pixel location to ROM addr/col
   assign rom_addr = pix_y[2:0] - ball_y_t[2:0];
   assign rom_col = pix_x[2:0] - ball_x_l[2:0];
   assign rom_bit = rom_data[rom_col];
   // pixel within ball
   assign rd_ball_on = sq_ball_on & rom_bit;
   // ball rgb output
   assign ball_rgb = 3'b100;   // red
   // new ball position
   assign ball_x_next = (refr_tick) ? ball_x_reg+x_delta_reg :
                        ball_x_reg ;
   assign ball_y_next = (refr_tick) ? ball_y_reg+y_delta_reg :
                        ball_y_reg ;
   // new ball velocity
   always @*
   begin
      x_delta_next = x_delta_reg;
      y_delta_next = y_delta_reg;
      if (ball_y_t < 1) // reach top
         y_delta_next = BALL_V_P;
      else if (ball_y_b > (MAX_Y-1)) // reach bottom
         y_delta_next = BALL_V_N;
      else if (ball_x_l <= WALL_X_R) // reach wall
         x_delta_next = BALL_V_P;    // bounce back
      else if ((BAR_X_L<=ball_x_r) && (ball_x_r<=BAR_X_R) &&
               (bar_y_t<=ball_y_b) && (ball_y_t<=bar_y_b))
         // reach x of right bar and hit, ball bounce back
         x_delta_next = BALL_V_N;
   end
   //--------------------------------------------
   // rgb multiplexing circuit
   //--------------------------------------------
   always @*
      if (~video_on)
         graph_rgb = 3'b000; // blank
      else
         if (wall_on)
            graph_rgb = wall_rgb;
         else if (bar_on)
            graph_rgb = bar_rgb;
         else if (rd_ball_on)
            graph_rgb = ball_rgb;
		 else if (Score_on)
		    graph_rgb = Score_rgb;
         else
            graph_rgb = 3'b110; // yellow background

endmodule
