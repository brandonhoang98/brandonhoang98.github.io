// Xilinx Verilog netlist produced by netgen application (version G.26)
// Command      : -intstyle ise -w -ofmt verilog -sim multiplexer.ngd multiplexer_translate.v 
// Input file   : multiplexer.ngd
// Output file  : multiplexer_translate.v
// Design name  : multiplexer
// # of Modules : 1
// Xilinx       : C:/XilinxISE6
// Device       : 3s50pq208-4

// This verilog netlist is a simulation model and uses simulation 
// primitives which may not represent the true implementation of the 
// device, however the netlist is functionally correct and should not 
// be modified. This file cannot be synthesized and should only be used 
// with supported simulation tools.

`timescale 1 ns/1 ps

module multiplexer (
  cbin, x, op, y, fout, s
);
  input cbin;
  input x;
  input op;
  input y;
  output fout;
  output s;
  wire fout_OBUF;
  wire cbin_IBUF;
  wire s_OBUF;
  wire x_IBUF;
  wire op_IBUF;
  wire y_IBUF;
  wire \fout_OBUF.GTS.TRI ;
  wire GTS = glbl.GTS;
  wire \s_OBUF.GTS.TRI ;
  wire \NlwInverterSignal_fout_OBUF.GTS.TRI/CTL ;
  wire \NlwInverterSignal_s_OBUF.GTS.TRI/CTL ;
  defparam Mxor_s_Result1.INIT = 8'h96;
  X_LUT3 Mxor_s_Result1 (
    .ADR0(y_IBUF),
    .ADR1(x_IBUF),
    .ADR2(cbin_IBUF),
    .O(s_OBUF)
  );
  defparam Mmux_fout_Result1.INIT = 16'h8EE8;
  X_LUT4 Mmux_fout_Result1 (
    .ADR0(cbin_IBUF),
    .ADR1(y_IBUF),
    .ADR2(op_IBUF),
    .ADR3(x_IBUF),
    .O(fout_OBUF)
  );
  X_BUF cbin_IBUF_0 (
    .I(cbin),
    .O(cbin_IBUF)
  );
  X_BUF x_IBUF_1 (
    .I(x),
    .O(x_IBUF)
  );
  X_BUF op_IBUF_2 (
    .I(op),
    .O(op_IBUF)
  );
  X_BUF y_IBUF_3 (
    .I(y),
    .O(y_IBUF)
  );
  X_BUF fout_OBUF_4 (
    .I(fout_OBUF),
    .O(\fout_OBUF.GTS.TRI )
  );
  X_BUF s_OBUF_5 (
    .I(s_OBUF),
    .O(\s_OBUF.GTS.TRI )
  );
  X_IPAD cbin_6 (
    .PAD(cbin)
  );
  X_IPAD x_7 (
    .PAD(x)
  );
  X_IPAD op_8 (
    .PAD(op)
  );
  X_IPAD y_9 (
    .PAD(y)
  );
  X_OPAD fout_10 (
    .PAD(fout)
  );
  X_OPAD s_11 (
    .PAD(s)
  );
  X_TRI \fout_OBUF.GTS.TRI_12  (
    .I(\fout_OBUF.GTS.TRI ),
    .CTL(\NlwInverterSignal_fout_OBUF.GTS.TRI/CTL ),
    .O(fout)
  );
  X_TRI \s_OBUF.GTS.TRI_13  (
    .I(\s_OBUF.GTS.TRI ),
    .CTL(\NlwInverterSignal_s_OBUF.GTS.TRI/CTL ),
    .O(s)
  );
  X_INV \NlwInverterBlock_fout_OBUF.GTS.TRI/CTL  (
    .I(GTS),
    .O(\NlwInverterSignal_fout_OBUF.GTS.TRI/CTL )
  );
  X_INV \NlwInverterBlock_s_OBUF.GTS.TRI/CTL  (
    .I(GTS),
    .O(\NlwInverterSignal_s_OBUF.GTS.TRI/CTL )
  );
endmodule

