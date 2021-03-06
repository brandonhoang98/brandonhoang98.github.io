/* Clock divider CLK_DIV10 
   August 10, 2001
*/

`timescale 100 ps / 10 ps

module CLK_DIV10 (CLKDV,CLKIN);

parameter DIVIDE_BY = 10;

input CLKIN;
output CLKDV;
reg CLKDV;
integer CLOCK_DIVIDER;

initial begin
 CLOCK_DIVIDER = 0;
 CLKDV = 1'b0;
end

always @(posedge CLKIN)
begin
 CLOCK_DIVIDER = CLOCK_DIVIDER + 1;
	if (CLOCK_DIVIDER == (DIVIDE_BY/2 + 1)) 
	begin
	CLOCK_DIVIDER = 1;
	CLKDV = ~CLKDV;
	end
end

endmodule
