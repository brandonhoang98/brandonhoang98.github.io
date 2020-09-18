module top1(clk,reset,Q);
    input clk,reset;
    output [3:0] Q;
    wire clk1;

    ClockDivider CD1(clk, reset, clk1);
    moore M1(clk1, reset, Q);

endmodule
