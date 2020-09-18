module top2(clk,btn,reset,up,Q);
    input clk,btn,reset,up;
    output [1:0] Q;
    wire clk1;

    debounce D1(clk,btn,clk1);
    mealy M1(clk1, reset, up, Q);


endmodule
