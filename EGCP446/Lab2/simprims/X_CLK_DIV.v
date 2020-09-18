// $Header: /devl/xcs/repo/env/Databases/CAEInterfaces/versclibs/data/X_CLK_DIV.v,v 1.6 2003/05/06 02:54:57 wloo Exp $

/* Programmable Clock divider 
   August 27, 2001
   April 22, 2002 Changed CDRST to sensitive to negative edge of CLKIN
   May 1,2003 LSS Added 1 clock cycle delay to startup 
*/

`timescale 100 ps / 10 ps

module X_CLK_DIV (CLKDV,CDRST,CLKIN);

parameter DIVIDE_BY = 2;
parameter DIVIDER_DELAY = 0;

input CDRST,CLKIN;
output CLKDV;
integer CLOCK_DIVIDER;
integer RESET_WAIT_COUNT;
integer START_WAIT_COUNT;
integer DELAY_RESET;
integer DELAY_START;
integer STARTUP;
integer NO_BITS_REMAINING;
reg CLKDV;
reg CDRST_i;
reg notifier;

initial begin
 CLOCK_DIVIDER = 0;
 RESET_WAIT_COUNT = 0;
 START_WAIT_COUNT = 0;
 DELAY_RESET = 0;
 NO_BITS_REMAINING = 0;
 DELAY_START = DIVIDER_DELAY;
 CLKDV = 1'b0;
 STARTUP = 1;
end

always @(negedge CLKIN)
begin
CDRST_i = CDRST;
end

always @(posedge CLKIN)
begin

if (CDRST_i && (CLKDV == 1'b1) && (STARTUP == 1))
begin
CLKDV = 1'b0;
CLOCK_DIVIDER = 0;
DELAY_START = DIVIDER_DELAY;
end
 
if (CDRST_i && (CLKDV == 1'b1) && (STARTUP == 0))
 begin
	NO_BITS_REMAINING = ((DIVIDE_BY/2 + 1) - CLOCK_DIVIDER);
	DELAY_RESET = 1 ;
	DELAY_START = DIVIDER_DELAY ;
 end

if (DELAY_RESET == 1)		
	begin
	RESET_WAIT_COUNT = RESET_WAIT_COUNT + 1;
		 if (RESET_WAIT_COUNT == NO_BITS_REMAINING)
 		 begin
			CLKDV = 1'b0;
			DELAY_RESET = 0;
			RESET_WAIT_COUNT = 0;
			STARTUP = 1;
			CLOCK_DIVIDER = 0;
		 end
	end


if (CDRST_i == 1'b0 && DELAY_START == 1) 
 begin
 START_WAIT_COUNT = START_WAIT_COUNT + 1;
	if (START_WAIT_COUNT == DIVIDE_BY)
	begin
	START_WAIT_COUNT = 0;
	DELAY_START  = 0;
	end
 end


if (CDRST_i == 1'b0 && DELAY_START == 0 && DELAY_RESET == 0) 
 begin
	if ((CLOCK_DIVIDER == 0) && (STARTUP == 1))
	begin
	CLKDV = 1'b1;
	end

 CLOCK_DIVIDER = CLOCK_DIVIDER + 1;
	if ((CLOCK_DIVIDER == 0) && (STARTUP == 1))
	begin
	CLKDV = 1'b1;
	end
	if (CLOCK_DIVIDER == (DIVIDE_BY/2 + 1)) 
	begin
	STARTUP = 0;
	CLOCK_DIVIDER = 1;
	CLKDV = ~CLKDV;
	end
 end

end


specify

	$width (posedge CLKIN, 0:0:0, 0, notifier);
	$width (negedge CLKIN, 0:0:0, 0, notifier);
	$width (posedge CDRST, 0:0:0, 0, notifier);
	$period (posedge CLKIN, 0:0:0, notifier);
	specparam PATHPULSE$ = 0;

endspecify


endmodule
