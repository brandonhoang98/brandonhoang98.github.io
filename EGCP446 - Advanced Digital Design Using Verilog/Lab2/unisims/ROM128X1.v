// $Header: /devl/xcs/repo/env/Databases/CAEInterfaces/verunilibs/s/ROM128X1.v,v 1.8 2003/01/21 01:55:43 wloo Exp $

/*

FUNCTION	: ROM 128x1

*/

`timescale  100 ps / 10 ps


module ROM128X1 (O, A0, A1, A2, A3, A4, A5, A6);

    parameter INIT = 128'h00000000000000000000000000000000;

    output O;

    input  A0, A1, A2, A3, A4, A5, A6;

    wire dout;
    wire [6:0] adr;

    reg mem [0:127];
    reg  [15:0] count;

    buf b0 (adr[6], A6);
    buf b1 (adr[5], A5);
    buf b2 (adr[4], A4);
    buf b3 (adr[3], A3);
    buf b4 (adr[2], A2);
    buf b5 (adr[1], A1);
    buf b6 (adr[0], A0);
    buf b7 (O, dout);

    initial begin
	for(count = 0; count < 128; count = count + 1)
	    mem[count] = INIT[count];
    end

    assign dout = mem[adr];

    specify
	(A6 => O) = (0, 0);
	(A5 => O) = (0, 0);
	(A4 => O) = (0, 0);
	(A3 => O) = (0, 0);
	(A2 => O) = (0, 0);
	(A1 => O) = (0, 0);
	(A0 => O) = (0, 0);
    endspecify

endmodule

