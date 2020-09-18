// Xilinx Verilog netlist produced by netgen application (version G.26)
// Command      : -intstyle ise -w -ofmt verilog -sim full_adder.ngd full_adder_translate.v 
// Input file   : full_adder.ngd
// Output file  : full_adder_translate.v
// Design name  : full_adder
// # of Modules : 1
// Xilinx       : C:/XilinxISE6
// Device       : 3s50pq208-4

// This verilog netlist is a simulation model and uses simulation 
// primitives which may not represent the true implementation of the 
// device, however the netlist is functionally correct and should not 
// be modified. This file cannot be synthesized and should only be used 
// with supported simulation tools.

`timescale 1 ns/1 ps

module full_adder (
  a, b, cin, cout, sum
);
  input a;
  input b;
  input cin;
  output cout;
  output sum;
  wire cout_OBUF;
  wire a_IBUF;
  wire b_IBUF;
  wire sum_OBUF;
  wire cin_IBUF;
  wire \cout_OBUF.GTS.TRI ;
  wire GTS = glbl.GTS;
  wire \sum_OBUF.GTS.TRI ;
  wire \NlwInverterSignal_cout_OBUF.GTS.TRI/CTL ;
  wire \NlwInverterSignal_sum_OBUF.GTS.TRI/CTL ;
  defparam \Mxor_sum_Xo<1>1 .INIT = 8'h96;
  X_LUT3 \Mxor_sum_Xo<1>1  (
    .ADR0(cin_IBUF),
    .ADR1(b_IBUF),
    .ADR2(a_IBUF),
    .O(sum_OBUF)
  );
  defparam cout1.INIT = 8'hE8;
  X_LUT3 cout1 (
    .ADR0(b_IBUF),
    .ADR1(cin_IBUF),
    .ADR2(a_IBUF),
    .O(cout_OBUF)
  );
  X_BUF a_IBUF_0 (
    .I(a),
    .O(a_IBUF)
  );
  X_BUF b_IBUF_1 (
    .I(b),
    .O(b_IBUF)
  );
  X_BUF cin_IBUF_2 (
    .I(cin),
    .O(cin_IBUF)
  );
  X_BUF cout_OBUF_3 (
    .I(cout_OBUF),
    .O(\cout_OBUF.GTS.TRI )
  );
  X_BUF sum_OBUF_4 (
    .I(sum_OBUF),
    .O(\sum_OBUF.GTS.TRI )
  );
  X_IPAD a_5 (
    .PAD(a)
  );
  X_IPAD b_6 (
    .PAD(b)
  );
  X_IPAD cin_7 (
    .PAD(cin)
  );
  X_OPAD cout_8 (
    .PAD(cout)
  );
  X_OPAD sum_9 (
    .PAD(sum)
  );
  X_TRI \cout_OBUF.GTS.TRI_10  (
    .I(\cout_OBUF.GTS.TRI ),
    .CTL(\NlwInverterSignal_cout_OBUF.GTS.TRI/CTL ),
    .O(cout)
  );
  X_TRI \sum_OBUF.GTS.TRI_11  (
    .I(\sum_OBUF.GTS.TRI ),
    .CTL(\NlwInverterSignal_sum_OBUF.GTS.TRI/CTL ),
    .O(sum)
  );
  X_INV \NlwInverterBlock_cout_OBUF.GTS.TRI/CTL  (
    .I(GTS),
    .O(\NlwInverterSignal_cout_OBUF.GTS.TRI/CTL )
  );
  X_INV \NlwInverterBlock_sum_OBUF.GTS.TRI/CTL  (
    .I(GTS),
    .O(\NlwInverterSignal_sum_OBUF.GTS.TRI/CTL )
  );
endmodule

