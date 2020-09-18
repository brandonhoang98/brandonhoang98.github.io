// $Header: $

/*

FUNCTION	: Digital Clock Manager

*/

`timescale  1 ps / 1 ps

module DCM (
	CLK0, CLK180, CLK270, CLK2X, CLK2X180, CLK90,
	CLKDV, CLKFX, CLKFX180, LOCKED, PSDONE, STATUS,
	CLKFB, CLKIN, DSSEN, PSCLK, PSEN, PSINCDEC, RST);

parameter CLKDV_DIVIDE = 2.0;
parameter CLKFX_DIVIDE = 1;
parameter CLKFX_MULTIPLY = 4;
parameter CLKIN_DIVIDE_BY_2 = "FALSE";
parameter CLKIN_PERIOD = 0.0;			// non-simulatable
parameter CLKOUT_PHASE_SHIFT = "NONE";
parameter CLK_FEEDBACK = "1X";
parameter DESKEW_ADJUST = "SYSTEM_SYNCHRONOUS";	// non-simulatable
parameter DFS_FREQUENCY_MODE = "LOW";
parameter DLL_FREQUENCY_MODE = "LOW";
parameter DSS_MODE = "NONE";			// non-simulatable
parameter DUTY_CYCLE_CORRECTION = "TRUE";
parameter FACTORY_JF = 16'hC080;		// non-simulatable
parameter MAXPERCLKIN = 1000000;		// simulation parameter
parameter MAXPERPSCLK = 100000000;		// simulation parameter
parameter PHASE_SHIFT = 0;
parameter SIM_CLKIN_CYCLE_JITTER = 300;		// simulation parameter
parameter SIM_CLKIN_PERIOD_JITTER = 1000;	// simulation parameter
parameter STARTUP_WAIT = "FALSE";		// non-simulatable

input CLKFB, CLKIN, DSSEN;
input PSCLK, PSEN, PSINCDEC, RST;

output CLK0, CLK180, CLK270, CLK2X, CLK2X180, CLK90;
output CLKDV, CLKFX, CLKFX180, LOCKED, PSDONE;
output [7:0] STATUS;

reg CLK0, CLK180, CLK270, CLK2X, CLK2X180, CLK90;
reg CLKDV, CLKFX, CLKFX180;

wire clkfb_in, clkin_in, dssen_in;
wire psclk_in, psen_in, psincdec_in, rst_in;
wire clk0_out;
reg clk2x_out, clkdv_out;
reg clkfx_out, locked_out, psdone_out, ps_overflow_out, ps_lock;

reg [1:0] clkfb_type;
reg [8:0] divide_type;
reg clkin_type;
reg [1:0] ps_type;
reg [3:0] deskew_adjust_mode;
reg dfs_mode_type;
reg dll_mode_type;
reg clk1x_type;
reg [9:0] ps_in;

reg lock_period, lock_delay, lock_clkin, lock_clkfb;
reg [1:0] lock_out;
reg lock_fb, lock_ps;
reg fb_delay_found;
reg clock_stopped;

wire clkin_div;

reg clkin_ps;
reg clkin_fb;

time FINE_SHIFT_RANGE;
time ps_delay;
time clkin_edge;
time clkin_div_edge;
time clkin_ps_edge;
time delay_edge;
time clkin_period [2:0];
time period;
time period_div;
time period_orig;
time period_ps;
time clkout_delay;
time fb_delay;
time period_fx, remain_fx;
time period_dv_high, period_dv_low;
time cycle_jitter, period_jitter;

reg clkin_window, clkfb_window;
reg clkin_5050;
reg [2:0] rst_reg;
reg [12:0] numerator, denominator, gcd;
reg [23:0] i, n, d, p;

reg notifier;

initial begin
    #1;
    if ($realtime == 0) begin
	$display ("Simulator Resolution Error : Simulator resolution is set to a value greater than 1 ps.");
	$display ("In order to simulate the DCM, the simulator resolution must be set to 1ps or smaller.");
	$finish;
    end
end

initial begin
    case (CLKDV_DIVIDE)
	1.5  : divide_type <= 'd3;
	2.0  : divide_type <= 'd4;
	2.5  : divide_type <= 'd5;
	3.0  : divide_type <= 'd6;
	3.5  : divide_type <= 'd7;
	4.0  : divide_type <= 'd8;
	4.5  : divide_type <= 'd9;
	5.0  : divide_type <= 'd10;
	5.5  : divide_type <= 'd11;
	6.0  : divide_type <= 'd12;
	6.5  : divide_type <= 'd13;
	7.0  : divide_type <= 'd14;
	7.5  : divide_type <= 'd15;
	8.0  : divide_type <= 'd16;
	9.0  : divide_type <= 'd18;
	10.0 : divide_type <= 'd20;
	11.0 : divide_type <= 'd22;
	12.0 : divide_type <= 'd24;
	13.0 : divide_type <= 'd26;
	14.0 : divide_type <= 'd28;
	15.0 : divide_type <= 'd30;
	16.0 : divide_type <= 'd32;
	default : begin
	    $display("Attribute Syntax Error : The attribute CLKDV_DIVIDE on DCM instance %m is set to %0.1f.  Legal values for this attribute are 1.5, 2.0, 2.5, 3.0, 3.5, 4.0, 4.5, 5.0, 5.5, 6.0, 6.5, 7.0, 7.5, 8.0, 9.0, 10.0, 11.0, 12.0, 13.0, 14.0, 15.0, or 16.0.", CLKDV_DIVIDE);
	    $finish;
	end
    endcase

    if ((CLKFX_DIVIDE <= 0) || (32 < CLKFX_DIVIDE)) begin
	$display("Attribute Syntax Error : The attribute CLKFX_DIVIDE on DCM instance %m is set to %d.  Legal values for this attribute are 1 ... 32.", CLKFX_DIVIDE);
	$finish;
    end

    if ((CLKFX_MULTIPLY <= 1) || (32 < CLKFX_MULTIPLY)) begin
	$display("Attribute Syntax Error : The attribute CLKFX_MULTIPLY on DCM instance %m is set to %d.  Legal values for this attribute are 2 ... 32.", CLKFX_MULTIPLY);
	$finish;
    end

    case (CLKIN_DIVIDE_BY_2)
	"false" : clkin_type <= 0;
	"FALSE" : clkin_type <= 0;
	"true"  : clkin_type <= 1;
	"TRUE"  : clkin_type <= 1;
	default : begin
	    $display("Attribute Syntax Error : The attribute CLKIN_DIVIDE_BY_2 on DCM instance %m is set to %s.  Legal values for this attribute are TRUE or FALSE.", CLKIN_DIVIDE_BY_2);
	    $finish;
	end
    endcase

    case (CLKOUT_PHASE_SHIFT)
	"NONE"     : begin
			 ps_in <= 256;
			 ps_type <= 0;
		     end
	"none"     : begin
			 ps_in <= 256;
			 ps_type <= 0;
		     end
	"FIXED"    : begin
			 ps_in <= PHASE_SHIFT + 256;
			 ps_type <= 1;
		     end
	"fixed"    : begin
			 ps_in <= PHASE_SHIFT + 256;
			 ps_type <= 1;
		     end
	"VARIABLE" : begin
			 ps_in <= PHASE_SHIFT + 256;
			 ps_type <= 2;
		     end
	"variable" : begin
			 ps_in <= PHASE_SHIFT + 256;
			 ps_type <= 2;
		     end
	default : begin
	    $display("Attribute Syntax Error : The attribute CLKOUT_PHASE_SHIFT on DCM instance %m is set to %s.  Legal values for this attribute are NONE, FIXED or VARIABLE.", CLKOUT_PHASE_SHIFT);
	    $finish;
	end
    endcase

    case (CLK_FEEDBACK)
	"none" : clkfb_type <= 0;
	"NONE" : clkfb_type <= 0;
	"1x"   : clkfb_type <= 1;
	"1X"   : clkfb_type <= 1;
	"2x"   : clkfb_type <= 2;
	"2X"   : clkfb_type <= 2;
	default : begin
	    $display("Attribute Syntax Error : The attribute CLK_FEEDBACK on DCM instance %m is set to %s.  Legal values for this attribute are NONE, 1X or 2X.", CLK_FEEDBACK);
	    $finish;
	end
    endcase

    case (DESKEW_ADJUST)
	"source_synchronous" : deskew_adjust_mode <= 8;
	"SOURCE_SYNCHRONOUS" : deskew_adjust_mode <= 8;
	"system_synchronous" : deskew_adjust_mode <= 11;
	"SYSTEM_SYNCHRONOUS" : deskew_adjust_mode <= 11;
	"0"		     : deskew_adjust_mode <= 0;
	"1"		     : deskew_adjust_mode <= 1;
	"2"		     : deskew_adjust_mode <= 2;
	"3"		     : deskew_adjust_mode <= 3;
	"4"		     : deskew_adjust_mode <= 4;
	"5"		     : deskew_adjust_mode <= 5;
	"6"		     : deskew_adjust_mode <= 6;
	"7"		     : deskew_adjust_mode <= 7;
	"8"		     : deskew_adjust_mode <= 8;
	"9"		     : deskew_adjust_mode <= 9;
	"10"		     : deskew_adjust_mode <= 10;
	"11"		     : deskew_adjust_mode <= 11;
	"12"		     : deskew_adjust_mode <= 12;
	"13"		     : deskew_adjust_mode <= 13;
	"14"		     : deskew_adjust_mode <= 14;
	"15"		     : deskew_adjust_mode <= 15;
	default : begin
	    $display("Attribute Syntax Error : The attribute DESKEW_ADJUST on DCM instance %m is set to %s.  Legal values for this attribute are SOURCE_SYNCHRONOUS, SYSTEM_SYNCHRONOUS or 0 ... 15.", DESKEW_ADJUST);
	    $finish;
	end
    endcase

    case (DFS_FREQUENCY_MODE)
	"high" : dfs_mode_type <= 1;
	"HIGH" : dfs_mode_type <= 1;
	"low"  : dfs_mode_type <= 0;
	"LOW"  : dfs_mode_type <= 0;
	default : begin
	    $display("Attribute Syntax Error : The attribute DFS_FREQUENCY_MODE on DCM instance %m is set to %s.  Legal values for this attribute are HIGH or LOW.", DFS_FREQUENCY_MODE);
	    $finish;
	end
    endcase

    period_jitter <= SIM_CLKIN_PERIOD_JITTER;
    cycle_jitter <= SIM_CLKIN_CYCLE_JITTER;

    case (DLL_FREQUENCY_MODE)
	"high" : dll_mode_type <= 1;
	"HIGH" : dll_mode_type <= 1;
	"low"  : dll_mode_type <= 0;
	"LOW"  : dll_mode_type <= 0;
	default : begin
	    $display("Attribute Syntax Error : The attribute DLL_FREQUENCY_MODE on DCM instance %m is set to %s.  Legal values for this attribute are HIGH or LOW.", DLL_FREQUENCY_MODE);
	    $finish;
	end
    endcase

    case (DSS_MODE)
	"none" : ;
	"NONE" : ;
	default : begin
	    $display("Attribute Syntax Error : The attribute DSS_MODE on DCM instance %m is set to %s.  Legal values for this attribute is NONE.", DSS_MODE);
	    $finish;
	end
    endcase

    case (DUTY_CYCLE_CORRECTION)
	"false" : clk1x_type <= 0;
	"FALSE" : clk1x_type <= 0;
	"true"  : clk1x_type <= 1;
	"TRUE"  : clk1x_type <= 1;
	default : begin
	    $display("Attribute Syntax Error : The attribute DUTY_CYCLE_CORRECTION on DCM instance %m is set to %s.  Legal values for this attribute are TRUE or FALSE.", DUTY_CYCLE_CORRECTION);
	    $finish;
	end
    endcase

    if ((PHASE_SHIFT < -255) || (PHASE_SHIFT > 255)) begin
	$display("Attribute Syntax Error : The attribute PHASE_SHIFT on DCM instance %m is set to %d.  Legal values for this attribute are -255 ... 255.", PHASE_SHIFT);
	$display("Error : PHASE_SHIFT = %d is not -255 ... 255.", PHASE_SHIFT);
	$finish;
    end

    case (STARTUP_WAIT)
	"false" : ;
	"FALSE" : ;
	"true"  : ;
	"TRUE"  : ;
	default : begin
	    $display("Attribute Syntax Error : The attribute STARTUP_WAIT on DCM instance %m is set to %s.  Legal values for this attribute are TRUE or FALSE.", STARTUP_WAIT);
	    $finish;
	end
    endcase
end

//
// fx parameters
//

initial begin
    gcd = 1;
    for (i = 2; i <= CLKFX_MULTIPLY; i = i + 1) begin
	if (((CLKFX_MULTIPLY % i) == 0) && ((CLKFX_DIVIDE % i) == 0))
	    gcd = i;
    end
    numerator = CLKFX_MULTIPLY / gcd;
    denominator = CLKFX_DIVIDE / gcd;
end

//
// input wire delays
//

buf b_clkin (clkin_in, CLKIN);
buf b_clkfb (clkfb_in, CLKFB);
buf b_dssen (dssen_in, DSSEN);
buf b_psclk (psclk_in, PSCLK);
buf b_psen (psen_in, PSEN);
buf b_psincdec (psincdec_in, PSINCDEC);
buf b_rst (rst_in, RST);
buf b_locked (LOCKED, locked_out);
buf b_psdone (PSDONE, psdone_out);
buf b_ps_overflow (STATUS[0], ps_overflow_out);
buf b_clkin_lost (STATUS[1], clkin_lost_out);
buf b_clkfx_lost (STATUS[2], clkfx_lost_out);

dcm_clock_divide_by_2 i_clock_divide_by_2 (clkin_in, clkin_type, clkin_div, rst_in);

dcm_maximum_period_check #(MAXPERCLKIN, "CLKIN") i_max_clkin (clkin_in);
dcm_maximum_period_check #(MAXPERPSCLK, "PSCLK") i_max_psclk (psclk_in);

dcm_clock_lost i_clkin_lost (clkin_in, clkin_lost_out);
dcm_clock_lost i_clkfx_lost (CLKFX, clkfx_lost_out);

always @(clkin_div) begin
    clkin_ps <= #(ps_delay) clkin_div;
end

always @(clkin_ps or lock_fb) begin
    clkin_fb <= #(period_ps) clkin_ps & lock_fb;
end

always @(posedge clkin_div) begin
    clkin_div_edge <= $time;
    if (($time - clkin_div_edge) <= (1.5 * period_div))
	period_div <= $time - clkin_div_edge;
    else if ((period_div == 0) && (clkin_div_edge != 0))
	period_div <= $time - clkin_div_edge;
end

always @(posedge clkin_ps) begin
    clkin_ps_edge <= $time;
#0;
    if (($time - clkin_ps_edge) <= (1.5 * period_ps))
	period_ps <= $time - clkin_ps_edge;
    else if ((period_ps == 0) && (clkin_ps_edge != 0))
	period_ps <= $time - clkin_ps_edge;
end

always @(posedge clkin_ps) begin
    lock_ps <= lock_period;
    lock_fb <= lock_ps;
end

always @(period or fb_delay)
    clkout_delay <= period - fb_delay;

//
// generate master reset signal
//

always @(posedge clkin_in) begin
    rst_reg[0] <= rst_in;
    rst_reg[1] <= rst_reg[0] & rst_in;
    rst_reg[2] <= rst_reg[1] & rst_reg[0] & rst_in;
end

always @(negedge rst_in) begin
    if ((rst_reg[2] & rst_reg[1] & rst_reg[0]) == 0)
	$display("Timing Violation Error : RST on instance %m must be asserted for 3 CLKIN clock cycles.");
end

initial begin
    clk2x_out <= 0;
    clkdv_out <= 0;
    clkin_5050 <= 0;
    clkfb_window <= 0;
    clkfx_out <= 0;
    clkin_div_edge <= 0;
    clkin_period[0] <= 0;
    clkin_period[1] <= 0;
    clkin_period[2] <= 0;
    clkin_ps_edge <= 0;
    clkin_window <= 0;
    clkout_delay <= 0;
    clock_stopped <= 1;
    fb_delay  <= 0;
    fb_delay_found <= 0;
    lock_clkfb <= 0;
    lock_clkin <= 0;
    lock_delay <= 0;
    lock_fb <= 0;
    lock_out <= 2'b00;
    lock_period <= 0;
    lock_ps <= 0;
    locked_out <= 0;
    period <= 0;
    period_div <= 0;
    period_fx <= 0;
    period_orig <= 0;
    period_ps <= 0;
    psdone_out <= 0;
    ps_delay <= 0;
    ps_lock <= 0;
    ps_overflow_out <= 0;
    rst_reg <= 3'b000;
end

always @(rst_in) begin
    clkin_5050 <= 0;
    clkfb_window <= 0;
    clkin_div_edge <= 0;
    clkin_period[0] <= 0;
    clkin_period[1] <= 0;
    clkin_period[2] <= 0;
    clkin_ps_edge <= 0;
    clkin_window <= 0;
    clkout_delay <= 0;
    clock_stopped <= 1;
    fb_delay <= 0;
    fb_delay_found <= 0;
    lock_clkfb <= 0;
    lock_clkin <= 0;
    lock_delay <= 0;
    lock_fb <= 0;
    lock_out <= 2'b00;
    lock_period <= 0;
    lock_ps <= 0;
    locked_out <= 0;
    period_div <= 0;
    period_fx <= 0;
    period_ps <= 0;
    ps_delay <= 0;
    ps_lock <= 0;
    ps_overflow_out <= 0;
    case (CLKOUT_PHASE_SHIFT)
	"NONE"     : ps_in <= 256;
	"none"     : ps_in <= 256;
	"FIXED"    : ps_in <= PHASE_SHIFT + 256;
	"fixed"    : ps_in <= PHASE_SHIFT + 256;
	"VARIABLE" : ps_in <= PHASE_SHIFT + 256;
	"variable" : ps_in <= PHASE_SHIFT + 256;
    endcase
end

//
// phase shift parameters
//

always @(posedge lock_period) begin
    if (ps_type == 2'b01)
	FINE_SHIFT_RANGE = 10000;
    else if (ps_type == 2'b10)
	FINE_SHIFT_RANGE = 5000;
    ps_delay = (ps_in * period_div / 256);
    if (PHASE_SHIFT > 0) begin
	if ((ps_in * period_orig / 256) > period_orig + FINE_SHIFT_RANGE) begin
	    $display("Timing Violation Error : FINE_SHIFT_RANGE on instance %m exceeds %1.3f ns.  PHASE_SHIFT * PERIOD / 256 = %d * %1.3f / 256 = %1.3f.", FINE_SHIFT_RANGE / 1000.0, PHASE_SHIFT, period_orig / 1000.0, PHASE_SHIFT * period_orig / 256 / 1000.0);
	      $finish;
	end
    end
    else if (PHASE_SHIFT < 0) begin
	if ((period_orig > FINE_SHIFT_RANGE) &&
	    ((ps_in * period_orig / 256) < period_orig - FINE_SHIFT_RANGE)) begin
	    $display("Timing Violation Error : FINE_SHIFT_RANGE on instance %m exceeds %1.3f ns.  PHASE_SHIFT * PERIOD / 256 = %d * %1.3f / 256 = %1.3f.", FINE_SHIFT_RANGE / 1000.0, PHASE_SHIFT, period_orig / 1000.0, -(PHASE_SHIFT) * period_orig / 256 / 1000.0);
	      $finish;
	end
    end
end

always @(posedge psclk_in) begin
    if (ps_type == 2'b10)
	if (psen_in)
	    if (ps_lock == 1)
		  $display("Timing Violation Warning : Please wait for PSDONE signal before adjusting the Phase Shift.");
	    else
	    if (psincdec_in == 1) begin
		if (ps_in == 511)
		    ps_overflow_out = 1;
		else if (((ps_in + 1) * period_orig / 256) > period_orig + FINE_SHIFT_RANGE)
		    ps_overflow_out = 1;
		else begin
		    ps_in = ps_in + 1;
		    ps_delay = (ps_in * period_div / 256);
		    ps_overflow_out = 0;
		end
		ps_lock = 1;
	    end
	    else if (psincdec_in == 0) begin
		if (ps_in == 1)
		    ps_overflow_out = 1;
		else if ((period_orig > FINE_SHIFT_RANGE) &&
		     (((ps_in - 1) * period_orig / 256) < period_orig - FINE_SHIFT_RANGE))
		      ps_overflow_out = 1;
		else begin
		    ps_in = ps_in - 1;
		    ps_delay = (ps_in * period_div / 256);
		    ps_overflow_out = 0;
		end
		ps_lock = 1;
	    end
end

always @(posedge ps_lock) begin
    @(posedge clkin_ps)
    @(posedge psclk_in)
    @(posedge psclk_in)
    @(posedge psclk_in)
	psdone_out <= 1;
    @(posedge psclk_in)
	psdone_out <= 0;
	ps_lock <= 0;
end

//
// determine clock period
//

always @(posedge clkin_div) begin
    clkin_edge <= $time;
    clkin_period[2] <= clkin_period[1];
    clkin_period[1] <= clkin_period[0];
    if (clkin_edge != 0)
	clkin_period[0] <= $time - clkin_edge;
end

always @(negedge clkin_div) begin
    if (lock_period == 1'b0) begin
	if ((clkin_period[0] != 0) &&
		(clkin_period[0] - cycle_jitter <= clkin_period[1]) &&
		(clkin_period[1] <= clkin_period[0] + cycle_jitter) &&
		(clkin_period[1] - cycle_jitter <= clkin_period[2]) &&
		(clkin_period[2] <= clkin_period[1] + cycle_jitter)) begin
	    lock_period <= 1;
	    period_orig <= (clkin_period[0] +
			    clkin_period[1] +
			    clkin_period[2]) / 3;
	    period <= clkin_period[0];
	end
    end
    else if (lock_period == 1'b1) begin
	if (100000000 < (clkin_period[0] / 1000)) begin
	    $display("Timing Violation Error : CLKIN stopped toggling on instance %m exceeds %d ms.  Current CLKIN Period = %1.3f ns.", 100, clkin_period[0] / 1000.0);
	    lock_period <= 0;
	    @(negedge rst_reg[2]);
	end
	else if ((period_orig * 2 < clkin_period[0]) && clock_stopped == 1'b0) begin
	    clkin_period[0] = clkin_period[1];
	    clock_stopped = 1'b1;
	end
	else if ((clkin_period[0] < period_orig - period_jitter) ||
		(period_orig + period_jitter < clkin_period[0])) begin
	    $display("Timing Violation Error : Input Clock Period Jitter on instance %m exceeds %1.3f ns.  Locked CLKIN Period = %1.3f.  Current CLKIN Period = %1.3f.", period_jitter / 1000.0, period_orig / 1000.0, clkin_period[0] / 1000.0);
	    lock_period <= 0;
	    @(negedge rst_reg[2]);
	end
	else if ((clkin_period[0] < clkin_period[1] - cycle_jitter) ||
		(clkin_period[1] + cycle_jitter < clkin_period[0])) begin
	    $display("Timing Violation Error : Input Clock Cycle-Cycle Jitter on instance %m exceeds %1.3f ns.  Previous CLKIN Period = %1.3f.  Current CLKIN Period = %1.3f.", cycle_jitter / 1000.0, clkin_period[1] / 1000.0, clkin_period[0] / 1000.0);
	    lock_period <= 0;
	    @(negedge rst_reg[2]);
	end
	else begin
	    period <= clkin_period[0];
	    clock_stopped = 1'b0;
	end
    end
end

//
// determine clock delay
//

always @(posedge lock_period) begin
    if (lock_period && clkfb_type != 0) begin
	if (clkfb_type == 1) begin
	    @(posedge CLK0)
		delay_edge = $time;
	end
	else if (clkfb_type == 2) begin
	    @(posedge CLK2X)
		delay_edge = $time;
	end
	@(posedge clkfb_in)
	fb_delay = ($time - delay_edge) % period_orig;
    end
    fb_delay_found = 1;
end

//
// determine feedback lock
//

always @(posedge clkfb_in) begin
    #0  clkfb_window <= 1;
    #cycle_jitter clkfb_window <= 0;
end

always @(posedge clkin_fb) begin
    #0  clkin_window <= 1;
    #cycle_jitter clkin_window <= 0;
end

always @(posedge clkin_fb) begin
    #1
    if (clkfb_window && fb_delay_found)
	lock_clkin <= 1;
    else
	lock_clkin <= 0;
end

always @(posedge clkfb_in) begin
    #1
    if (clkin_window && fb_delay_found)
	lock_clkfb <= 1;
    else
	lock_clkfb <= 0;
end

always @(negedge clkin_fb) begin
    lock_delay <= lock_clkin || lock_clkfb;
end

//
// generate lock signal
//

always @(posedge clkin_ps) begin
    if (clkfb_type == 0)
	lock_out[0] <= lock_period;
    else
	lock_out[0] <= lock_period & lock_delay & lock_fb;
    lock_out[1] <= lock_out[0];
    locked_out <= lock_out[1];
end

//
// generate the clk1x_out
//

always @(posedge clkin_ps) begin
    clkin_5050 <= 1;
    #(period / 2)
    clkin_5050 <= 0;
end

assign clk0_out = (clk1x_type) ? clkin_5050 : clkin_ps;

//
// generate the clk2x_out
//

always @(posedge clkin_ps) begin
    clk2x_out <= 1;
    #(period / 4)
    clk2x_out <= 0;
    if (lock_out[0]) begin
	#(period / 4)
	clk2x_out <= 1;
	#(period / 4)
	clk2x_out <= 0;
    end
    else begin
	#(period / 2);
    end
end

//
// generate the clkdv_out
//

always @(period) begin
    if (dll_mode_type == 1'b1) begin
	period_dv_high = (period / 2) * (divide_type / 2);
	period_dv_low = (period / 2) * (divide_type / 2 + divide_type % 2);
    end
    else begin
	period_dv_high = (period * divide_type) / 4;
	period_dv_low = (period * divide_type) / 4;
    end
end

always @(posedge clkin_ps) begin
    if (lock_out[0]) begin
	clkdv_out = 1'b1;
	#(period_dv_high);
	clkdv_out = 1'b0;
	#(period_dv_low);
	clkdv_out = 1'b1;
	#(period_dv_high);
	clkdv_out = 1'b0;
	#(period_dv_low - period / 2);
    end
end

//
// generate fx output signal
//

always @(lock_period or period or denominator or numerator) begin
    if (lock_period == 1'b1) begin
	period_fx = (period * denominator) / (numerator * 2);
	remain_fx = (period * denominator) % (numerator * 2);
    end
end

always @(posedge clkin_ps) begin
    if (lock_out[0] == 1) begin
	clkfx_out = 1'b1;
	for (p = 0; p < (numerator * 2 - 1); p = p + 1) begin
	    #(period_fx);
	    if (p < remain_fx)
		#1;
	    clkfx_out = !clkfx_out;
	end
	if (period_fx > (period / 2)) begin
	    #(period_fx - (period / 2));
	end
	if (clkin_lost_out == 1'b1) begin
	    @(negedge rst_reg[2]);
	end
    end
end

//
// generate all output signal
//

always @(clk0_out) begin
    CLK0 <= #(clkout_delay) clk0_out && (clkfb_type != 2'b00);
end

always @(clk0_out) begin
    CLK90 <= #(clkout_delay + period / 4) clk0_out && !dll_mode_type && (clkfb_type != 2'b00);
end

always @(clk0_out) begin
    CLK180 <= #(clkout_delay + period / 2) clk0_out && (clkfb_type != 2'b00);
end

always @(clk0_out) begin
    CLK270 <= #(clkout_delay + (3 * period) / 4) clk0_out && !dll_mode_type && (clkfb_type != 2'b00);
end

always @(clk2x_out) begin
    CLK2X <= #(clkout_delay) clk2x_out && !dll_mode_type && (clkfb_type != 2'b00);
end

always @(clk2x_out) begin
    CLK2X180 <= #(clkout_delay + period / 4) clk2x_out && !dll_mode_type && (clkfb_type != 2'b00);
end

always @(clkdv_out) begin
    CLKDV <= #(clkout_delay) clkdv_out && (clkfb_type != 2'b00);
end

always @(clkfx_out) begin
    CLKFX <= #(clkout_delay) clkfx_out;
end

always @(clkfx_out) begin
    CLKFX180 <= #(clkout_delay) ~clkfx_out;
end

specify
	(CLKIN => LOCKED) = (0, 0);
	(PSCLK => PSDONE) = (0, 0);

	$setuphold (posedge PSCLK, posedge PSEN, 0, 0, notifier);
	$setuphold (posedge PSCLK, negedge PSEN, 0, 0, notifier);
	$setuphold (posedge PSCLK, posedge PSINCDEC, 0, 0, notifier);
	$setuphold (posedge PSCLK, negedge PSINCDEC, 0, 0, notifier);

	$period (posedge CLKIN, 1111, notifier);
	$period (posedge PSCLK, 1111, notifier);
	$width (posedge CLKIN, 0, 0, notifier);
	$width (negedge CLKIN, 0, 0, notifier);
	$width (posedge PSCLK, 0, 0, notifier);
	$width (negedge PSCLK, 0, 0, notifier);
	$width (posedge RST, 0, 0, notifier);

	specparam PATHPULSE$ = 0;
endspecify

endmodule

//////////////////////////////////////////////////////

module dcm_clock_divide_by_2 (clock, clock_type, clock_out, rst);
input clock;
input clock_type;
input rst;
output clock_out;

reg clock_out;
reg clock_div2;
reg [2:0] rst_reg;

initial begin
    clock_out <= 1'b0;
    clock_div2 <= 1'b0;
end

always @(posedge clock) begin
    clock_div2 <= ~clock_div2;
end

always @(posedge clock) begin
    rst_reg[0] <= rst;
    rst_reg[1] <= rst_reg[0] & rst;
    rst_reg[2] <= rst_reg[1] & rst_reg[0] & rst;
end

always @(clock_div2 or clock or rst) begin
    if ((clock_type == 1'b0) && (rst == 1'b0))
	clock_out <= clock;
    else if ((clock_type == 1'b1) && (rst == 1'b0))
	clock_out <= clock_div2;
    else if (rst == 1'b1) begin
	clock_out <= 1'b0;
	@(negedge rst_reg[2]);
    end
end

endmodule

module dcm_maximum_period_check (clock);
parameter clock_name = "";
parameter maximum_period = 0;
input clock;

time clock_edge;
time clock_period;

initial begin
    clock_edge <= 0;
    clock_period <= 0;
end

always @(posedge clock) begin
    clock_edge[0] <= $time;
    clock_period <= $time - clock_edge[0];
    if (clock_period > maximum_period) begin
	$display("Timing Violation Error : Input clock period of, %1.3f ns, on the %s port of instance %m exceeds allotted value of %1.3f ns at simulation time %1.3f ns.", clock_period/1000.0, clock_name, maximum_period/1000.0, $time/1000.0);
    end
end
endmodule

module dcm_clock_lost (clock, lost);
input clock;
output lost;
reg lost;

time clock_edge;
reg [63:0] period;
reg clock_low, clock_high;
reg clock_posedge, clock_negedge;

initial begin
    clock_edge <= 0;
    clock_high <= 0;
    clock_low <= 0;
    lost <= 1;
    period <= 0;
end

always @(posedge clock) begin
    clock_edge <= $time;
    if (period != 0 && (($time - clock_edge) <= (1.5 * period)))
	period <= $time - clock_edge;
    else if (period != 0 && (($time - clock_edge) > (1.5 * period)))
	period <= 0;
    else if ((period == 0) && (clock_edge != 0))
	period <= $time - clock_edge;
end

always @(posedge clock) begin
    clock_low   <= 1'b0;
    clock_high  <= 1'b1;
    if (period != 0)
	lost <= 1'b0;
    clock_posedge <= 1'b0;
    #((period * 9.1) / 10)
    if ((clock_low != 1'b1) && (clock_posedge != 1'b1))
	lost <= 1;
end

always @(posedge clock) begin
    clock_negedge <= 1'b1;
end

always @(negedge clock) begin
    clock_posedge <= 1'b1;
end

always @(negedge clock) begin
    clock_high  <= 1'b0;
    clock_low   <= 1'b1;
    if (period != 0)
	lost <= 1'b0;
    clock_negedge <= 1'b0;
    #((period * 9.1) / 10)
    if ((clock_high != 1'b1) && (clock_negedge != 1'b1))
	lost <= 1;
end

endmodule
