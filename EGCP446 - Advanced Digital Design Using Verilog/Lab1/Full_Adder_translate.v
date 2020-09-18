// Xilinx Verilog netlist produced by netgen application (version G.26)
// Command      : -intstyle ise -w -ofmt verilog -sim Full_Adder.ngd Full_Adder_translate.v 
// Input file   : Full_Adder.ngd
// Output file  : Full_Adder_translate.v
// Design name  : Full_Adder
// # of Modules : 1
// Xilinx       : C:/XilinxISE6
// Device       : 3s50pq208-4

// This verilog netlist is a simulation model and uses simulation 
// primitives which may not represent the true implementation of the 
// device, however the netlist is functionally correct and should not 
// be modified. This file cannot be synthesized and should only be used 
// with supported simulation tools.

`timescale 1 ns/1 ps

module Full_Adder (
  A, B, Cin, Cout, Sum
);
  input A;
  input B;
  input Cin;
  output Cout;
  output Sum;
  wire Cout_OBUF;
  wire A_IBUF;
  wire B_IBUF;
  wire Sum_OBUF;
  wire Cin_IBUF;
  wire \Cout_OBUF.GTS.TRI ;
  wire GTS = glbl.GTS;
  wire \Sum_OBUF.GTS.TRI ;
  wire \NlwInverterSignal_Cout_OBUF.GTS.TRI/CTL ;
  wire \NlwInverterSignal_Sum_OBUF.GTS.TRI/CTL ;
  defparam Cout1.INIT = 8'hE8;
  X_LUT3 Cout1 (
    .ADR0(B_IBUF),
    .ADR1(Cin_IBUF),
    .ADR2(A_IBUF),
    .O(Cout_OBUF)
  );
  defparam HA2_Mxor_s_Result1.INIT = 8'h96;
  X_LUT3 HA2_Mxor_s_Result1 (
    .ADR0(Cin_IBUF),
    .ADR1(B_IBUF),
    .ADR2(A_IBUF),
    .O(Sum_OBUF)
  );
  X_BUF A_IBUF_0 (
    .I(A),
    .O(A_IBUF)
  );
  X_BUF B_IBUF_1 (
    .I(B),
    .O(B_IBUF)
  );
  X_BUF Cin_IBUF_2 (
    .I(Cin),
    .O(Cin_IBUF)
  );
  X_BUF Cout_OBUF_3 (
    .I(Cout_OBUF),
    .O(\Cout_OBUF.GTS.TRI )
  );
  X_BUF Sum_OBUF_4 (
    .I(Sum_OBUF),
    .O(\Sum_OBUF.GTS.TRI )
  );
  X_IPAD A_5 (
    .PAD(A)
  );
  X_IPAD B_6 (
    .PAD(B)
  );
  X_IPAD Cin_7 (
    .PAD(Cin)
  );
  X_OPAD Cout_8 (
    .PAD(Cout)
  );
  X_OPAD Sum_9 (
    .PAD(Sum)
  );
  X_TRI \Cout_OBUF.GTS.TRI_10  (
    .I(\Cout_OBUF.GTS.TRI ),
    .CTL(\NlwInverterSignal_Cout_OBUF.GTS.TRI/CTL ),
    .O(Cout)
  );
  X_TRI \Sum_OBUF.GTS.TRI_11  (
    .I(\Sum_OBUF.GTS.TRI ),
    .CTL(\NlwInverterSignal_Sum_OBUF.GTS.TRI/CTL ),
    .O(Sum)
  );
  X_INV \NlwInverterBlock_Cout_OBUF.GTS.TRI/CTL  (
    .I(GTS),
    .O(\NlwInverterSignal_Cout_OBUF.GTS.TRI/CTL )
  );
  X_INV \NlwInverterBlock_Sum_OBUF.GTS.TRI/CTL  (
    .I(GTS),
    .O(\NlwInverterSignal_Sum_OBUF.GTS.TRI/CTL )
  );
endmodule

