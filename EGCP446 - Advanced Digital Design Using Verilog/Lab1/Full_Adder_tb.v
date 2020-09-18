

module Full_Adder_Full_Adder_tb_v_tf();

    reg A;
    reg B;
    reg Cin;


    wire Sum;
    wire Cout;


    Full_Adder uut (
        .A(A), 
        .B(B), 
        .Cin(Cin), 
        .Sum(Sum), 
        .Cout(Cout)
        );

        initial begin
            A = 0;
            B = 0;
            Cin = 0;
		  #100;
		  A = 0;
		  B = 0;
		  Cin = 1;
		  #100;
		  A = 0;
		  B = 1;
		  Cin = 0;
		  #100;
		  A = 0;
		  B = 1;
		  Cin = 1;
		  #100;
		  A = 1;
		  B = 0;
		  Cin = 0;
		  #100;
		  A = 1;
		  B = 0;
		  Cin = 1;
		  #100;
		  A = 1;
		  B = 1;
		  Cin = 0;
		  #100;
		  A = 1;
		  B = 1;
		  Cin = 1;
        end

 


endmodule

