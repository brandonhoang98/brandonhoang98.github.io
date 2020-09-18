/* Clock divide with synchronous reset and divider delay
   August 10, 2001
   April 22, 2002 Changed CDRST to active to negative edge of CLKIN
   May 1,2003 LSS Added 1 clock cycle delay to startup 
*/

`timescale 100 ps / 10 ps

module CLK_DIV2RSD (CLKDV,CDRST,CLKIN);

parameter DIVIDE_BY = 2;
parameter DIVIDER_DELAY = 1;

input CDRST,CLKIN;
output CLKDV;
reg CLKDV;
reg CDRST_i;

integer CLOCK_DIVIDER;
integer RESET_WAIT_COUNT;
integer START_WAIT_COUNT;
integer DELAY_RESET;
integer DELAY_START;
integer STARTUP;
integer NO_BITS_REMAINING;

initial begin
 CLOCK_DIVIDER = 0;
 RESET_WAIT_COUNT = 0;
 START_WAIT_COUNT = 0;
 DELAY_RESET = 0;
 DELAY_START = DIVIDER_DELAY;
 NO_BITS_REMAINING = 0;
 STARTUP = 1;
 CLKDV = 1'b0;
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
	DELAY_START = DIVIDER_DELAY;
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
	if ((CLOCK_DIVIDER ==  0) && (STARTUP == 1))
	begin
	CLKDV = 1'b1;
	end
 	CLOCK_DIVIDER = CLOCK_DIVIDER + 1;
	if (CLOCK_DIVIDER == (DIVIDE_BY/2 + 1)) 
	begin
	STARTUP = 0;
	CLOCK_DIVIDER = 1;
	CLKDV = ~CLKDV;
	end
 end

end

endmodule
