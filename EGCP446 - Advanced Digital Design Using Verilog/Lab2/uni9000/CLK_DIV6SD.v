/* Clock divider with divider delay 
   August 10, 2001
   May 1,2003 LSS Added 1 clock cycle delay to startup 
*/

`timescale 100 ps / 10 ps

module CLK_DIV6SD (CLKDV,CLKIN);

parameter DIVIDE_BY = 6;
parameter DIVIDER_DELAY = 1;

input CLKIN;
output CLKDV;
reg CLKDV;

integer CLOCK_DIVIDER;
integer START_WAIT_COUNT;
integer DELAY_START;

initial begin
 CLOCK_DIVIDER = 0;
 START_WAIT_COUNT = 0;
 DELAY_START = DIVIDER_DELAY;
 CLKDV = 1'b0;
end

always @(posedge CLKIN)
begin

if (DELAY_START == 1) 
 begin
 START_WAIT_COUNT = START_WAIT_COUNT + 1;
	if (START_WAIT_COUNT == DIVIDE_BY)
	begin
	START_WAIT_COUNT = 0;
	DELAY_START  = 0;
	end
 end

if (DELAY_START == 0) 
 begin
 CLOCK_DIVIDER = CLOCK_DIVIDER + 1;
	if (CLOCK_DIVIDER == (DIVIDE_BY/2 + 1)) 
	begin
	CLOCK_DIVIDER = 1;
	CLKDV = ~CLKDV;
	end
 end

end

endmodule
