// $Header: /devl/xcs/repo/env/Databases/CAEInterfaces/verunilibs/s/ROM16X1.v,v 1.8 2003/01/21 01:55:43 wloo Exp $

/*

FUNCTION	: ROM 16x1

*/

`timescale  100 ps / 10 ps


module ROM16X1 (O, A0, A1, A2, A3);

    parameter INIT = 16'h0000;

    output O;

    input  A0, A1, A2, A3;

    wire [3:0] adr;
    wire dout;

    reg  mem [0:15];
    reg  [4:0] count;

    buf b1 (adr[3], A3);
    buf b2 (adr[2], A2);
    buf b3 (adr[1], A1);
    buf b4 (adr[0], A0);
    buf b5 (O, dout);

    initial begin
	for(count = 0; count < 16; count = count + 1)
	    mem[count] = INIT[count];
    end

    assign dout = mem[adr];

    specify
	(A3 => O) = (0, 0);
	(A2 => O) = (0, 0);
	(A1 => O) = (0, 0);
	(A0 => O) = (0, 0);
    endspecify

endmodule

