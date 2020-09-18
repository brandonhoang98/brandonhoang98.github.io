
/*

FUNCTION	: Input Output BUFFER

*/

`timescale  100 ps / 10 ps

`celldefine

module IOBUFE_S (O, IO, I, E);

    output O;

    inout  IO;

    input  I, E;

    bufif1 E1 (IO, I, E);
    buf B1 (O, IO);

    specify
	(IO *> O) = (1,1);
	(I *> IO) = (1,1);
	(E *> IO) = (1,1);
    endspecify

endmodule

`endcelldefine
