// $Header: /devl/xcs/repo/env/Databases/CAEInterfaces/verunilibs/s/GT.v,v 1.23 2003/05/22 00:29:05 wloo Exp $
//**************************************************************
//  Copyright (c) 2002 Xilinx Inc.  All Rights Reserved
//  File Name    : GT.v
//  Module Name  : GT
//  Function     : Gigabit Transceiver
//  Site         : GT
//  Spec Version : 1.2
//  Generated by : write_verilog
//**************************************************************

`timescale 1 ps / 1 ps 

module GT (
	CHBONDDONE,
	CHBONDO,
	CONFIGOUT,
	RXBUFSTATUS,
	RXCHARISCOMMA,
	RXCHARISK,
	RXCHECKINGCRC,
	RXCLKCORCNT,
	RXCOMMADET,
	RXCRCERR,
	RXDATA,
	RXDISPERR,
	RXLOSSOFSYNC,
	RXNOTINTABLE,
	RXREALIGN,
	RXRECCLK,
	RXRUNDISP,
	TXBUFERR,
	TXKERR,
	TXN,
	TXP,
	TXRUNDISP,

	BREFCLK,
	BREFCLK2,
	CHBONDI,
	CONFIGENABLE,
	CONFIGIN,
	ENCHANSYNC,
	ENMCOMMAALIGN,
	ENPCOMMAALIGN,
	LOOPBACK,
	POWERDOWN,
	REFCLK,
	REFCLK2,
	REFCLKSEL,
	RXN,
	RXP,
	RXPOLARITY,
	RXRESET,
	RXUSRCLK,
	RXUSRCLK2,
	TXBYPASS8B10B,
	TXCHARDISPMODE,
	TXCHARDISPVAL,
	TXCHARISK,
	TXDATA,
	TXFORCECRCERR,
	TXINHIBIT,
	TXPOLARITY,
	TXRESET,
	TXUSRCLK,
	TXUSRCLK2
);

parameter ALIGN_COMMA_MSB = "FALSE";
parameter CHAN_BOND_LIMIT = 16;
parameter CHAN_BOND_MODE = "OFF";
parameter CHAN_BOND_OFFSET = 8;
parameter CHAN_BOND_ONE_SHOT = "FALSE";
parameter CHAN_BOND_SEQ_1_1 = 11'b00000000000;
parameter CHAN_BOND_SEQ_1_2 = 11'b00000000000;
parameter CHAN_BOND_SEQ_1_3 = 11'b00000000000;
parameter CHAN_BOND_SEQ_1_4 = 11'b00000000000;
parameter CHAN_BOND_SEQ_2_1 = 11'b00000000000;
parameter CHAN_BOND_SEQ_2_2 = 11'b00000000000;
parameter CHAN_BOND_SEQ_2_3 = 11'b00000000000;
parameter CHAN_BOND_SEQ_2_4 = 11'b00000000000;
parameter CHAN_BOND_SEQ_2_USE = "FALSE";
parameter CHAN_BOND_SEQ_LEN = 1;
parameter CHAN_BOND_WAIT = 8;
parameter CLK_COR_INSERT_IDLE_FLAG = "FALSE";
parameter CLK_COR_KEEP_IDLE = "FALSE";
parameter CLK_COR_REPEAT_WAIT = 1;
parameter CLK_COR_SEQ_1_1 = 11'b00000000000;
parameter CLK_COR_SEQ_1_2 = 11'b00000000000;
parameter CLK_COR_SEQ_1_3 = 11'b00000000000;
parameter CLK_COR_SEQ_1_4 = 11'b00000000000;
parameter CLK_COR_SEQ_2_1 = 11'b00000000000;
parameter CLK_COR_SEQ_2_2 = 11'b00000000000;
parameter CLK_COR_SEQ_2_3 = 11'b00000000000;
parameter CLK_COR_SEQ_2_4 = 11'b00000000000;
parameter CLK_COR_SEQ_2_USE = "FALSE";
parameter CLK_COR_SEQ_LEN = 1;
parameter CLK_CORRECT_USE = "TRUE";
parameter COMMA_10B_MASK = 10'b1111111000;
parameter CRC_END_OF_PKT = "K29_7";
parameter CRC_FORMAT = "USER_MODE";
parameter CRC_START_OF_PKT = "K27_7";
parameter DEC_MCOMMA_DETECT = "TRUE";
parameter DEC_PCOMMA_DETECT = "TRUE";
parameter DEC_VALID_COMMA_ONLY = "TRUE";
parameter MCOMMA_10B_VALUE = 10'b1100000000;
parameter MCOMMA_DETECT = "TRUE";
parameter PCOMMA_10B_VALUE = 10'b0011111000;
parameter PCOMMA_DETECT = "TRUE";
parameter REF_CLK_V_SEL = 0;
parameter RX_BUFFER_USE = "TRUE";
parameter RX_CRC_USE = "FALSE";
parameter RX_DATA_WIDTH = 2;
parameter RX_DECODE_USE = "TRUE";
parameter RX_LOS_INVALID_INCR = 1;
parameter RX_LOS_THRESHOLD = 4;
parameter RX_LOSS_OF_SYNC_FSM = "TRUE";
parameter SERDES_10B = "FALSE";
parameter TERMINATION_IMP = 50;
parameter TX_BUFFER_USE = "TRUE";
parameter TX_CRC_FORCE_VALUE = 8'b11010110;
parameter TX_CRC_USE = "FALSE";
parameter TX_DATA_WIDTH = 2;
parameter TX_DIFF_CTRL = 500;
parameter TX_PREEMPHASIS = 0;

output CHBONDDONE;
output [3:0] CHBONDO;
output CONFIGOUT;
output [1:0] RXBUFSTATUS;
output [3:0] RXCHARISCOMMA;
output [3:0] RXCHARISK;
output RXCHECKINGCRC;
output [2:0] RXCLKCORCNT;
output RXCOMMADET;
output RXCRCERR;
output [31:0] RXDATA;
output [3:0] RXDISPERR;
output [1:0] RXLOSSOFSYNC;
output [3:0] RXNOTINTABLE;
output RXREALIGN;
output RXRECCLK;
output [3:0] RXRUNDISP;
output TXBUFERR;
output [3:0] TXKERR;
output TXN;
output TXP;
output [3:0] TXRUNDISP;

input BREFCLK;
input BREFCLK2;
input [3:0] CHBONDI;
input CONFIGENABLE;
input CONFIGIN;
input ENCHANSYNC;
input ENMCOMMAALIGN;
input ENPCOMMAALIGN;
input [1:0] LOOPBACK;
input POWERDOWN;
input REFCLK;
input REFCLK2;
input REFCLKSEL;
input RXN;
input RXP;
input RXPOLARITY;
input RXRESET;
input RXUSRCLK;
input RXUSRCLK2;
input [3:0] TXBYPASS8B10B;
input [3:0] TXCHARDISPMODE;
input [3:0] TXCHARDISPVAL;
input [3:0] TXCHARISK;
input [31:0] TXDATA;
input TXFORCECRCERR;
input TXINHIBIT;
input TXPOLARITY;
input TXRESET;
input TXUSRCLK;
input TXUSRCLK2;

reg ALIGN_COMMA_MSB_BINARY;
reg [4:0] CHAN_BOND_LIMIT_BINARY;
reg [1:0] CHAN_BOND_MODE_BINARY;
reg [3:0] CHAN_BOND_OFFSET_BINARY;
reg CHAN_BOND_ONE_SHOT_BINARY;
reg CHAN_BOND_SEQ_2_USE_BINARY;
reg [1:0] CHAN_BOND_SEQ_LEN_BINARY;
reg [3:0] CHAN_BOND_WAIT_BINARY;
reg CLK_COR_INSERT_IDLE_FLAG_BINARY;
reg CLK_COR_KEEP_IDLE_BINARY;
reg [4:0] CLK_COR_REPEAT_WAIT_BINARY;
reg CLK_COR_SEQ_2_USE_BINARY;
reg [1:0] CLK_COR_SEQ_LEN_BINARY;
reg CLK_CORRECT_USE_BINARY;
reg [7:0] CRC_END_OF_PKT_BINARY;
reg [1:0] CRC_FORMAT_BINARY;
reg [7:0] CRC_START_OF_PKT_BINARY;
reg DEC_MCOMMA_DETECT_BINARY;
reg DEC_PCOMMA_DETECT_BINARY;
reg DEC_VALID_COMMA_ONLY_BINARY;
reg MCOMMA_DETECT_BINARY;
reg PCOMMA_DETECT_BINARY;
reg REF_CLK_V_SEL_BINARY;
reg RX_BUFFER_USE_BINARY;
reg RX_CRC_USE_BINARY;
reg [1:0] RX_DATA_WIDTH_BINARY;
reg RX_DECODE_USE_BINARY;
reg [2:0] RX_LOS_INVALID_INCR_BINARY;
reg [2:0] RX_LOS_THRESHOLD_BINARY;
reg RX_LOSS_OF_SYNC_FSM_BINARY;
reg SERDES_10B_BINARY;
reg TERMINATION_IMP_BINARY;
reg TX_BUFFER_USE_BINARY;
reg TX_CRC_USE_BINARY;
reg [1:0] TX_DATA_WIDTH_BINARY;
reg [2:0] TX_DIFF_CTRL_BINARY;
reg [1:0] TX_PREEMPHASIS_BINARY;

tri0 GSR = glbl.GSR;

reg notifier;

wire CHBONDDONE_OUT;
wire [3:0] CHBONDO_OUT;
wire CONFIGOUT_OUT;
wire [1:0] RXBUFSTATUS_OUT;
wire [3:0] RXCHARISCOMMA_OUT;
wire [3:0] RXCHARISK_OUT;
wire RXCHECKINGCRC_OUT;
wire [2:0] RXCLKCORCNT_OUT;
wire RXCOMMADET_OUT;
wire RXCRCERR_OUT;
wire [31:0] RXDATA_OUT;
wire [3:0] RXDISPERR_OUT;
wire [1:0] RXLOSSOFSYNC_OUT;
wire [3:0] RXNOTINTABLE_OUT;
wire RXREALIGN_OUT;
wire RXRECCLK_OUT;
wire [3:0] RXRUNDISP_OUT;
wire TXBUFERR_OUT;
wire [3:0] TXKERR_OUT;
// wire TXN_OUT;
// wire TXP_OUT;
wire [3:0] TXRUNDISP_OUT;
wire BREFCLK_IN;
wire BREFCLK2_IN;
wire [3:0] CHBONDI_IN;
wire CONFIGENABLE_IN;
wire CONFIGIN_IN;
wire ENCHANSYNC_IN;
wire ENMCOMMAALIGN_IN;
wire ENPCOMMAALIGN_IN;
wire [1:0] LOOPBACK_IN;
wire POWERDOWN_IN;
wire REFCLK_IN;
wire REFCLK2_IN;
wire REFCLKSEL_IN;
wire RXN_IN;
wire RXP_IN;
wire RXPOLARITY_IN;
wire RXRESET_IN;
wire RXUSRCLK_IN;
wire RXUSRCLK2_IN;
wire [3:0] TXBYPASS8B10B_IN;
wire [3:0] TXCHARDISPMODE_IN;
wire [3:0] TXCHARDISPVAL_IN;
wire [3:0] TXCHARISK_IN;
wire [31:0] TXDATA_IN;
wire TXFORCECRCERR_IN;
wire TXINHIBIT_IN;
wire TXPOLARITY_IN;
wire TXRESET_IN;
wire TXUSRCLK_IN;
wire TXUSRCLK2_IN;

initial begin
	case (ALIGN_COMMA_MSB)
		"FALSE" : ALIGN_COMMA_MSB_BINARY <= 0;
		"TRUE" : ALIGN_COMMA_MSB_BINARY <= 1;
		default : begin
			$display("Attribute Syntax Error : The Attribute ALIGN_COMMA_MSB on GT instance %m is set to %s.  Legal values for this attribute are TRUE or FALSE.", ALIGN_COMMA_MSB);
			$finish;
		end
	endcase

	case (CHAN_BOND_LIMIT)
		1 : CHAN_BOND_LIMIT_BINARY <= 5'b00001;
		2 : CHAN_BOND_LIMIT_BINARY <= 5'b00010;
		3 : CHAN_BOND_LIMIT_BINARY <= 5'b00011;
		4 : CHAN_BOND_LIMIT_BINARY <= 5'b00100;
		5 : CHAN_BOND_LIMIT_BINARY <= 5'b00101;
		6 : CHAN_BOND_LIMIT_BINARY <= 5'b00110;
		7 : CHAN_BOND_LIMIT_BINARY <= 5'b00111;
		8 : CHAN_BOND_LIMIT_BINARY <= 5'b01000;
		9 : CHAN_BOND_LIMIT_BINARY <= 5'b01001;
		10 : CHAN_BOND_LIMIT_BINARY <= 5'b01010;
		11 : CHAN_BOND_LIMIT_BINARY <= 5'b01011;
		12 : CHAN_BOND_LIMIT_BINARY <= 5'b01100;
		13 : CHAN_BOND_LIMIT_BINARY <= 5'b01101;
		14 : CHAN_BOND_LIMIT_BINARY <= 5'b01110;
		15 : CHAN_BOND_LIMIT_BINARY <= 5'b01111;
		16 : CHAN_BOND_LIMIT_BINARY <= 5'b10000;
		17 : CHAN_BOND_LIMIT_BINARY <= 5'b10001;
		18 : CHAN_BOND_LIMIT_BINARY <= 5'b10010;
		19 : CHAN_BOND_LIMIT_BINARY <= 5'b10011;
		20 : CHAN_BOND_LIMIT_BINARY <= 5'b10100;
		21 : CHAN_BOND_LIMIT_BINARY <= 5'b10101;
		22 : CHAN_BOND_LIMIT_BINARY <= 5'b10110;
		23 : CHAN_BOND_LIMIT_BINARY <= 5'b10111;
		24 : CHAN_BOND_LIMIT_BINARY <= 5'b11000;
		25 : CHAN_BOND_LIMIT_BINARY <= 5'b11001;
		26 : CHAN_BOND_LIMIT_BINARY <= 5'b11010;
		27 : CHAN_BOND_LIMIT_BINARY <= 5'b11011;
		28 : CHAN_BOND_LIMIT_BINARY <= 5'b11100;
		29 : CHAN_BOND_LIMIT_BINARY <= 5'b11101;
		30 : CHAN_BOND_LIMIT_BINARY <= 5'b11110;
		31 : CHAN_BOND_LIMIT_BINARY <= 5'b11111;
		default : begin
			$display("Attribute Syntax Error : The Attribute CHAN_BOND_LIMIT on GT instance %m is set to %d.  Legal values for this attribute are 1 to 31.", CHAN_BOND_LIMIT);
			$finish;
		end
	endcase

	case (CHAN_BOND_MODE)
		"OFF" : CHAN_BOND_MODE_BINARY <= 2'b00;
		"MASTER" : CHAN_BOND_MODE_BINARY <= 2'b01;
		"SLAVE_1_HOP" : CHAN_BOND_MODE_BINARY <= 2'b10;
		"SLAVE_2_HOPS" : CHAN_BOND_MODE_BINARY <= 2'b11;
		default : begin
			$display("Attribute Syntax Error : The Attribute CHAN_BOND_MODE on GT instance %m is set to %s.  Legal values for this attribute are OFF, MASTER, SLAVE_1_HOP or SLAVE_2_HOPS.", CHAN_BOND_MODE);
			$finish;
		end
	endcase

	case (CHAN_BOND_OFFSET)
		0 : CHAN_BOND_OFFSET_BINARY <= 4'b0000;
		1 : CHAN_BOND_OFFSET_BINARY <= 4'b0001;
		2 : CHAN_BOND_OFFSET_BINARY <= 4'b0010;
		3 : CHAN_BOND_OFFSET_BINARY <= 4'b0011;
		4 : CHAN_BOND_OFFSET_BINARY <= 4'b0100;
		5 : CHAN_BOND_OFFSET_BINARY <= 4'b0101;
		6 : CHAN_BOND_OFFSET_BINARY <= 4'b0110;
		7 : CHAN_BOND_OFFSET_BINARY <= 4'b0111;
		8 : CHAN_BOND_OFFSET_BINARY <= 4'b1000;
		9 : CHAN_BOND_OFFSET_BINARY <= 4'b1001;
		10 : CHAN_BOND_OFFSET_BINARY <= 4'b1010;
		11 : CHAN_BOND_OFFSET_BINARY <= 4'b1011;
		12 : CHAN_BOND_OFFSET_BINARY <= 4'b1100;
		13 : CHAN_BOND_OFFSET_BINARY <= 4'b1101;
		14 : CHAN_BOND_OFFSET_BINARY <= 4'b1110;
		15 : CHAN_BOND_OFFSET_BINARY <= 4'b1111;
		default : begin
			$display("Attribute Syntax Error : The Attribute CHAN_BOND_OFFSET on GT instance %m is set to %d.  Legal values for this attribute are 0 to 15.", CHAN_BOND_OFFSET);
			$finish;
		end
	endcase

	case (CHAN_BOND_ONE_SHOT)
		"FALSE" : CHAN_BOND_ONE_SHOT_BINARY <= 0;
		"TRUE" : CHAN_BOND_ONE_SHOT_BINARY <= 1;
		default : begin
			$display("Attribute Syntax Error : The Attribute CHAN_BOND_ONE_SHOT on GT instance %m is set to %s.  Legal values for this attribute are TRUE or FALSE.", CHAN_BOND_ONE_SHOT);
			$finish;
		end
	endcase

	case (CHAN_BOND_SEQ_2_USE)
		"FALSE" : CHAN_BOND_SEQ_2_USE_BINARY <= 0;
		"TRUE" : CHAN_BOND_SEQ_2_USE_BINARY <= 1;
		default : begin
			$display("Attribute Syntax Error : The Attribute CHAN_BOND_SEQ_2_USE on GT instance %m is set to %s.  Legal values for this attribute are TRUE or FALSE.", CHAN_BOND_SEQ_2_USE);
			$finish;
		end
	endcase

	case (CHAN_BOND_SEQ_LEN)
		1 : CHAN_BOND_SEQ_LEN_BINARY <= 2'b01;
		2 : CHAN_BOND_SEQ_LEN_BINARY <= 2'b10;
		3 : CHAN_BOND_SEQ_LEN_BINARY <= 2'b11;
		4 : CHAN_BOND_SEQ_LEN_BINARY <= 2'b00;
		default : begin
			$display("Attribute Syntax Error : The Attribute CHAN_BOND_SEQ_LEN on GT instance %m is set to %d.  Legal values for this attribute are 1 to 4.", CHAN_BOND_SEQ_LEN);
			$finish;
		end
	endcase

	case (CHAN_BOND_WAIT)
		1 : CHAN_BOND_WAIT_BINARY <= 4'b0001;
		2 : CHAN_BOND_WAIT_BINARY <= 4'b0010;
		3 : CHAN_BOND_WAIT_BINARY <= 4'b0011;
		4 : CHAN_BOND_WAIT_BINARY <= 4'b0100;
		5 : CHAN_BOND_WAIT_BINARY <= 4'b0101;
		6 : CHAN_BOND_WAIT_BINARY <= 4'b0110;
		7 : CHAN_BOND_WAIT_BINARY <= 4'b0111;
		8 : CHAN_BOND_WAIT_BINARY <= 4'b1000;
		9 : CHAN_BOND_WAIT_BINARY <= 4'b1001;
		10 : CHAN_BOND_WAIT_BINARY <= 4'b1010;
		11 : CHAN_BOND_WAIT_BINARY <= 4'b1011;
		12 : CHAN_BOND_WAIT_BINARY <= 4'b1100;
		13 : CHAN_BOND_WAIT_BINARY <= 4'b1101;
		14 : CHAN_BOND_WAIT_BINARY <= 4'b1110;
		15 : CHAN_BOND_WAIT_BINARY <= 4'b1111;
		default : begin
			$display("Attribute Syntax Error : The Attribute CHAN_BOND_WAIT on GT instance %m is set to %d.  Legal values for this attribute are 1 to 15.", CHAN_BOND_WAIT);
			$finish;
		end
	endcase

	case (CLK_COR_INSERT_IDLE_FLAG)
		"FALSE" : CLK_COR_INSERT_IDLE_FLAG_BINARY <= 0;
		"TRUE" : CLK_COR_INSERT_IDLE_FLAG_BINARY <= 1;
		default : begin
			$display("Attribute Syntax Error : The Attribute CLK_COR_INSERT_IDLE_FLAG on GT instance %m is set to %s.  Legal values for this attribute are TRUE or FALSE.", CLK_COR_INSERT_IDLE_FLAG);
			$finish;
		end
	endcase

	case (CLK_COR_KEEP_IDLE)
		"FALSE" : CLK_COR_KEEP_IDLE_BINARY <= 0;
		"TRUE" : CLK_COR_KEEP_IDLE_BINARY <= 1;
		default : begin
			$display("Attribute Syntax Error : The Attribute CLK_COR_KEEP_IDLE on GT instance %m is set to %s.  Legal values for this attribute are TRUE or FALSE.", CLK_COR_KEEP_IDLE);
			$finish;
		end
	endcase

	case (CLK_COR_REPEAT_WAIT)
		0 : CLK_COR_REPEAT_WAIT_BINARY <= 5'b00000;
		1 : CLK_COR_REPEAT_WAIT_BINARY <= 5'b00001;
		2 : CLK_COR_REPEAT_WAIT_BINARY <= 5'b00010;
		3 : CLK_COR_REPEAT_WAIT_BINARY <= 5'b00011;
		4 : CLK_COR_REPEAT_WAIT_BINARY <= 5'b00100;
		5 : CLK_COR_REPEAT_WAIT_BINARY <= 5'b00101;
		6 : CLK_COR_REPEAT_WAIT_BINARY <= 5'b00110;
		7 : CLK_COR_REPEAT_WAIT_BINARY <= 5'b00111;
		8 : CLK_COR_REPEAT_WAIT_BINARY <= 5'b01000;
		9 : CLK_COR_REPEAT_WAIT_BINARY <= 5'b01001;
		10 : CLK_COR_REPEAT_WAIT_BINARY <= 5'b01010;
		11 : CLK_COR_REPEAT_WAIT_BINARY <= 5'b01011;
		12 : CLK_COR_REPEAT_WAIT_BINARY <= 5'b01100;
		13 : CLK_COR_REPEAT_WAIT_BINARY <= 5'b01101;
		14 : CLK_COR_REPEAT_WAIT_BINARY <= 5'b01110;
		15 : CLK_COR_REPEAT_WAIT_BINARY <= 5'b01111;
		16 : CLK_COR_REPEAT_WAIT_BINARY <= 5'b10000;
		17 : CLK_COR_REPEAT_WAIT_BINARY <= 5'b10001;
		18 : CLK_COR_REPEAT_WAIT_BINARY <= 5'b10010;
		19 : CLK_COR_REPEAT_WAIT_BINARY <= 5'b10011;
		20 : CLK_COR_REPEAT_WAIT_BINARY <= 5'b10100;
		21 : CLK_COR_REPEAT_WAIT_BINARY <= 5'b10101;
		22 : CLK_COR_REPEAT_WAIT_BINARY <= 5'b10110;
		23 : CLK_COR_REPEAT_WAIT_BINARY <= 5'b10111;
		24 : CLK_COR_REPEAT_WAIT_BINARY <= 5'b11000;
		25 : CLK_COR_REPEAT_WAIT_BINARY <= 5'b11001;
		26 : CLK_COR_REPEAT_WAIT_BINARY <= 5'b11010;
		27 : CLK_COR_REPEAT_WAIT_BINARY <= 5'b11011;
		28 : CLK_COR_REPEAT_WAIT_BINARY <= 5'b11100;
		29 : CLK_COR_REPEAT_WAIT_BINARY <= 5'b11101;
		30 : CLK_COR_REPEAT_WAIT_BINARY <= 5'b11110;
		31 : CLK_COR_REPEAT_WAIT_BINARY <= 5'b11111;
		default : begin
			$display("Attribute Syntax Error : The Attribute CLK_COR_REPEAT_WAIT on GT instance %m is set to %d.  Legal values for this attribute are 0 to 31.", CLK_COR_REPEAT_WAIT);
			$finish;
		end
	endcase

	case (CLK_COR_SEQ_2_USE)
		"FALSE" : CLK_COR_SEQ_2_USE_BINARY <= 0;
		"TRUE" : CLK_COR_SEQ_2_USE_BINARY <= 1;
		default : begin
			$display("Attribute Syntax Error : The Attribute CLK_COR_SEQ_2_USE on GT instance %m is set to %s.  Legal values for this attribute are TRUE or FALSE.", CLK_COR_SEQ_2_USE);
			$finish;
		end
	endcase

	case (CLK_COR_SEQ_LEN)
		1 : CLK_COR_SEQ_LEN_BINARY <= 2'b01;
		2 : CLK_COR_SEQ_LEN_BINARY <= 2'b10;
		3 : CLK_COR_SEQ_LEN_BINARY <= 2'b11;
		4 : CLK_COR_SEQ_LEN_BINARY <= 2'b00;
		default : begin
			$display("Attribute Syntax Error : The Attribute CLK_COR_SEQ_LEN on GT instance %m is set to %d.  Legal values for this attribute are 1 to 4.", CLK_COR_SEQ_LEN);
			$finish;
		end
	endcase

	case (CLK_CORRECT_USE)
		"FALSE" : CLK_CORRECT_USE_BINARY <= 0;
		"TRUE" : CLK_CORRECT_USE_BINARY <= 1;
		default : begin
			$display("Attribute Syntax Error : The Attribute CLK_CORRECT_USE on GT instance %m is set to %s.  Legal values for this attribute are TRUE or FALSE.", CLK_CORRECT_USE);
			$finish;
		end
	endcase

	case (CRC_END_OF_PKT)
		"K28_0" : CRC_END_OF_PKT_BINARY <= 8'b00011100;
		"K28_1" : CRC_END_OF_PKT_BINARY <= 8'b00111100;
		"K28_2" : CRC_END_OF_PKT_BINARY <= 8'b01011100;
		"K28_3" : CRC_END_OF_PKT_BINARY <= 8'b01111100;
		"K28_4" : CRC_END_OF_PKT_BINARY <= 8'b10011100;
		"K28_5" : CRC_END_OF_PKT_BINARY <= 8'b10111100;
		"K28_6" : CRC_END_OF_PKT_BINARY <= 8'b11011100;
		"K28_7" : CRC_END_OF_PKT_BINARY <= 8'b11111100;
		"K23_7" : CRC_END_OF_PKT_BINARY <= 8'b11110111;
		"K27_7" : CRC_END_OF_PKT_BINARY <= 8'b11111011;
		"K29_7" : CRC_END_OF_PKT_BINARY <= 8'b11111101;
		"K30_7" : CRC_END_OF_PKT_BINARY <= 8'b11111110;
		default : begin
			$display("Attribute Syntax Error : The Attribute CRC_END_OF_PKT on GT instance %m is set to %s.  Legal values for this attribute are K28_0, K28_1, K28_2, K28_3, K28_4, K28_5, K28_6, K28_7, K23_7, K27_7, K29_7 or K30_7.", CRC_END_OF_PKT);
			$finish;
		end
	endcase

	case (CRC_FORMAT)
		"USER_MODE" : CRC_FORMAT_BINARY <= 2'b00;
		"ETHERNET" : CRC_FORMAT_BINARY <= 2'b01;
		"INFINIBAND" : CRC_FORMAT_BINARY <= 2'b10;
		"FIBRE_CHAN" : CRC_FORMAT_BINARY <= 2'b11;
		default : begin
			$display("Attribute Syntax Error : The Attribute CRC_FORMAT on GT instance %m is set to %s.  Legal values for this attribute are USER_MODE, ETHERNET, INFINIBAND or FIBRE_CHAN.", CRC_FORMAT);
			$finish;
		end
	endcase

	case (CRC_START_OF_PKT)
		"K28_0" : CRC_START_OF_PKT_BINARY <= 8'b00011100;
		"K28_1" : CRC_START_OF_PKT_BINARY <= 8'b00111100;
		"K28_2" : CRC_START_OF_PKT_BINARY <= 8'b01011100;
		"K28_3" : CRC_START_OF_PKT_BINARY <= 8'b01111100;
		"K28_4" : CRC_START_OF_PKT_BINARY <= 8'b10011100;
		"K28_5" : CRC_START_OF_PKT_BINARY <= 8'b10111100;
		"K28_6" : CRC_START_OF_PKT_BINARY <= 8'b11011100;
		"K28_7" : CRC_START_OF_PKT_BINARY <= 8'b11111100;
		"K23_7" : CRC_START_OF_PKT_BINARY <= 8'b11110111;
		"K27_7" : CRC_START_OF_PKT_BINARY <= 8'b11111011;
		"K29_7" : CRC_START_OF_PKT_BINARY <= 8'b11111101;
		"K30_7" : CRC_START_OF_PKT_BINARY <= 8'b11111110;
		default : begin
			$display("Attribute Syntax Error : The Attribute CRC_START_OF_PKT on GT instance %m is set to %s.  Legal values for this attribute are K28_0, K28_1, K28_2, K28_3, K28_4, K28_5, K28_6, K28_7, K23_7, K27_7, K29_7 or K30_7.", CRC_START_OF_PKT);
			$finish;
		end
	endcase

	case (DEC_MCOMMA_DETECT)
		"FALSE" : DEC_MCOMMA_DETECT_BINARY <= 0;
		"TRUE" : DEC_MCOMMA_DETECT_BINARY <= 1;
		default : begin
			$display("Attribute Syntax Error : The Attribute DEC_MCOMMA_DETECT on GT instance %m is set to %s.  Legal values for this attribute are TRUE or FALSE.", DEC_MCOMMA_DETECT);
			$finish;
		end
	endcase

	case (DEC_PCOMMA_DETECT)
		"FALSE" : DEC_PCOMMA_DETECT_BINARY <= 0;
		"TRUE" : DEC_PCOMMA_DETECT_BINARY <= 1;
		default : begin
			$display("Attribute Syntax Error : The Attribute DEC_PCOMMA_DETECT on GT instance %m is set to %s.  Legal values for this attribute are TRUE or FALSE.", DEC_PCOMMA_DETECT);
			$finish;
		end
	endcase

	case (DEC_VALID_COMMA_ONLY)
		"FALSE" : DEC_VALID_COMMA_ONLY_BINARY <= 0;
		"TRUE" : DEC_VALID_COMMA_ONLY_BINARY <= 1;
		default : begin
			$display("Attribute Syntax Error : The Attribute DEC_VALID_COMMA_ONLY on GT instance %m is set to %s.  Legal values for this attribute are TRUE or FALSE.", DEC_VALID_COMMA_ONLY);
			$finish;
		end
	endcase

	case (MCOMMA_DETECT)
		"FALSE" : MCOMMA_DETECT_BINARY <= 0;
		"TRUE" : MCOMMA_DETECT_BINARY <= 1;
		default : begin
			$display("Attribute Syntax Error : The Attribute MCOMMA_DETECT on GT instance %m is set to %s.  Legal values for this attribute are TRUE or FALSE.", MCOMMA_DETECT);
			$finish;
		end
	endcase

	case (PCOMMA_DETECT)
		"FALSE" : PCOMMA_DETECT_BINARY <= 0;
		"TRUE" : PCOMMA_DETECT_BINARY <= 1;
		default : begin
			$display("Attribute Syntax Error : The Attribute PCOMMA_DETECT on GT instance %m is set to %s.  Legal values for this attribute are TRUE or FALSE.", PCOMMA_DETECT);
			$finish;
		end
	endcase

	case (REF_CLK_V_SEL)
		0 : REF_CLK_V_SEL_BINARY <= 0;
		1 : REF_CLK_V_SEL_BINARY <= 1;
		default : begin
			$display("Attribute Syntax Error : The Attribute REF_CLK_V_SEL on GT instance %m is set to %d.  Legal values for this attribute are  0 or 1.", REF_CLK_V_SEL);
			$finish;
		end
	endcase

	case (RX_BUFFER_USE)
		"FALSE" : RX_BUFFER_USE_BINARY <= 0;
		"TRUE" : RX_BUFFER_USE_BINARY <= 1;
		default : begin
			$display("Attribute Syntax Error : The Attribute RX_BUFFER_USE on GT instance %m is set to %s.  Legal values for this attribute are TRUE or FALSE.", RX_BUFFER_USE);
			$finish;
		end
	endcase

	case (RX_CRC_USE)
		"FALSE" : RX_CRC_USE_BINARY <= 0;
		"TRUE" : RX_CRC_USE_BINARY <= 1;
		default : begin
			$display("Attribute Syntax Error : The Attribute RX_CRC_USE on GT instance %m is set to %s.  Legal values for this attribute are TRUE or FALSE.", RX_CRC_USE);
			$finish;
		end
	endcase

	case (RX_DATA_WIDTH)
		1 : RX_DATA_WIDTH_BINARY <= 2'b01;
		2 : RX_DATA_WIDTH_BINARY <= 2'b10;
		4 : RX_DATA_WIDTH_BINARY <= 2'b00;
		default : begin
			$display("Attribute Syntax Error : The Attribute RX_DATA_WIDTH on GT instance %m is set to %d.  Legal values for this attribute are 1, 2 or 4.", RX_DATA_WIDTH);
			$finish;
		end
	endcase

	case (RX_DECODE_USE)
		"FALSE" : RX_DECODE_USE_BINARY <= 0;
		"TRUE" : RX_DECODE_USE_BINARY <= 1;
		default : begin
			$display("Attribute Syntax Error : The Attribute RX_DECODE_USE on GT instance %m is set to %s.  Legal values for this attribute are TRUE or FALSE.", RX_DECODE_USE);
			$finish;
		end
	endcase

	case (RX_LOS_INVALID_INCR)
		1 : RX_LOS_INVALID_INCR_BINARY <= 3'b000;
		2 : RX_LOS_INVALID_INCR_BINARY <= 3'b001;
		4 : RX_LOS_INVALID_INCR_BINARY <= 3'b010;
		8 : RX_LOS_INVALID_INCR_BINARY <= 3'b011;
		16 : RX_LOS_INVALID_INCR_BINARY <= 3'b100;
		32 : RX_LOS_INVALID_INCR_BINARY <= 3'b101;
		64 : RX_LOS_INVALID_INCR_BINARY <= 3'b110;
		128 : RX_LOS_INVALID_INCR_BINARY <= 3'b111;
		default : begin
			$display("Attribute Syntax Error : The Attribute RX_LOS_INVALID_INCR on GT instance %m is set to %d.  Legal values for this attribute are 1, 2, 4, 8, 16, 32, 64 or 128.", RX_LOS_INVALID_INCR);
			$finish;
		end
	endcase

	case (RX_LOS_THRESHOLD)
		4 : RX_LOS_THRESHOLD_BINARY <= 3'b000;
		8 : RX_LOS_THRESHOLD_BINARY <= 3'b001;
		16 : RX_LOS_THRESHOLD_BINARY <= 3'b010;
		32 : RX_LOS_THRESHOLD_BINARY <= 3'b011;
		64 : RX_LOS_THRESHOLD_BINARY <= 3'b100;
		128 : RX_LOS_THRESHOLD_BINARY <= 3'b101;
		256 : RX_LOS_THRESHOLD_BINARY <= 3'b110;
		512 : RX_LOS_THRESHOLD_BINARY <= 3'b111;
		default : begin
			$display("Attribute Syntax Error : The Attribute RX_LOS_THRESHOLD on GT instance %m is set to %d.  Legal values for this attribute are 4, 8, 16, 32, 64, 128, 256 or 512.", RX_LOS_THRESHOLD);
			$finish;
		end
	endcase

	case (RX_LOSS_OF_SYNC_FSM)
		"FALSE" : RX_LOSS_OF_SYNC_FSM_BINARY <= 0;
		"TRUE" : RX_LOSS_OF_SYNC_FSM_BINARY <= 1;
		default : begin
			$display("Attribute Syntax Error : The Attribute RX_LOSS_OF_SYNC_FSM on GT instance %m is set to %s.  Legal values for this attribute are TRUE or FALSE.", RX_LOSS_OF_SYNC_FSM);
			$finish;
		end
	endcase

	case (SERDES_10B)
		"FALSE" : SERDES_10B_BINARY <= 0;
		"TRUE" : SERDES_10B_BINARY <= 1;
		default : begin
			$display("Attribute Syntax Error : The Attribute SERDES_10B on GT instance %m is set to %s.  Legal values for this attribute are TRUE or FALSE.", SERDES_10B);
			$finish;
		end
	endcase

	case (TERMINATION_IMP)
		50 : TERMINATION_IMP_BINARY <= 0;
		75 : TERMINATION_IMP_BINARY <= 1;
		default : begin
			$display("Attribute Syntax Error : The Attribute TERMINATION_IMP on GT instance %m is set to %d.  Legal values for this attribute are  50 or 75.", TERMINATION_IMP);
			$finish;
		end
	endcase

	case (TX_BUFFER_USE)
		"FALSE" : TX_BUFFER_USE_BINARY <= 0;
		"TRUE" : TX_BUFFER_USE_BINARY <= 1;
		default : begin
			$display("Attribute Syntax Error : The Attribute TX_BUFFER_USE on GT instance %m is set to %s.  Legal values for this attribute are TRUE or FALSE.", TX_BUFFER_USE);
			$finish;
		end
	endcase

	case (TX_CRC_USE)
		"FALSE" : TX_CRC_USE_BINARY <= 0;
		"TRUE" : TX_CRC_USE_BINARY <= 1;
		default : begin
			$display("Attribute Syntax Error : The Attribute TX_CRC_USE on GT instance %m is set to %s.  Legal values for this attribute are TRUE or FALSE.", TX_CRC_USE);
			$finish;
		end
	endcase

	case (TX_DATA_WIDTH)
		1 : TX_DATA_WIDTH_BINARY <= 2'b01;
		2 : TX_DATA_WIDTH_BINARY <= 2'b10;
		4 : TX_DATA_WIDTH_BINARY <= 2'b00;
		default : begin
			$display("Attribute Syntax Error : The Attribute TX_DATA_WIDTH on GT instance %m is set to %d.  Legal values for this attribute are 1, 2 or 4.", TX_DATA_WIDTH);
			$finish;
		end
	endcase

	case (TX_DIFF_CTRL)
		400 : TX_DIFF_CTRL_BINARY <= 3'b010;
		500 : TX_DIFF_CTRL_BINARY <= 3'b000;
		600 : TX_DIFF_CTRL_BINARY <= 3'b001;
		700 : TX_DIFF_CTRL_BINARY <= 3'b011;
		800 : TX_DIFF_CTRL_BINARY <= 3'b110;
		default : begin
			$display("Attribute Syntax Error : The Attribute TX_DIFF_CTRL on GT instance %m is set to %d.  Legal values for this attribute are 400, 500, 600, 700 or 800.", TX_DIFF_CTRL);
			$finish;
		end
	endcase

	case (TX_PREEMPHASIS)
		0 : TX_PREEMPHASIS_BINARY <= 2'b00;
		1 : TX_PREEMPHASIS_BINARY <= 2'b01;
		2 : TX_PREEMPHASIS_BINARY <= 2'b10;
		3 : TX_PREEMPHASIS_BINARY <= 2'b11;
		default : begin
			$display("Attribute Syntax Error : The Attribute TX_PREEMPHASIS on GT instance %m is set to %d.  Legal values for this attribute are 0 to 3.", TX_PREEMPHASIS);
			$finish;
		end
	endcase

end

buf B_CHBONDDONE (CHBONDDONE, CHBONDDONE_OUT);
buf B_CHBONDO0 (CHBONDO[0], CHBONDO_OUT[0]);
buf B_CHBONDO1 (CHBONDO[1], CHBONDO_OUT[1]);
buf B_CHBONDO2 (CHBONDO[2], CHBONDO_OUT[2]);
buf B_CHBONDO3 (CHBONDO[3], CHBONDO_OUT[3]);
buf B_CONFIGOUT (CONFIGOUT, CONFIGOUT_OUT);
buf B_RXBUFSTATUS0 (RXBUFSTATUS[0], RXBUFSTATUS_OUT[0]);
buf B_RXBUFSTATUS1 (RXBUFSTATUS[1], RXBUFSTATUS_OUT[1]);
buf B_RXCHARISCOMMA0 (RXCHARISCOMMA[0], RXCHARISCOMMA_OUT[0]);
buf B_RXCHARISCOMMA1 (RXCHARISCOMMA[1], RXCHARISCOMMA_OUT[1]);
buf B_RXCHARISCOMMA2 (RXCHARISCOMMA[2], RXCHARISCOMMA_OUT[2]);
buf B_RXCHARISCOMMA3 (RXCHARISCOMMA[3], RXCHARISCOMMA_OUT[3]);
buf B_RXCHARISK0 (RXCHARISK[0], RXCHARISK_OUT[0]);
buf B_RXCHARISK1 (RXCHARISK[1], RXCHARISK_OUT[1]);
buf B_RXCHARISK2 (RXCHARISK[2], RXCHARISK_OUT[2]);
buf B_RXCHARISK3 (RXCHARISK[3], RXCHARISK_OUT[3]);
buf B_RXCHECKINGCRC (RXCHECKINGCRC, RXCHECKINGCRC_OUT);
buf B_RXCLKCORCNT0 (RXCLKCORCNT[0], RXCLKCORCNT_OUT[0]);
buf B_RXCLKCORCNT1 (RXCLKCORCNT[1], RXCLKCORCNT_OUT[1]);
buf B_RXCLKCORCNT2 (RXCLKCORCNT[2], RXCLKCORCNT_OUT[2]);
buf B_RXCOMMADET (RXCOMMADET, RXCOMMADET_OUT);
buf B_RXCRCERR (RXCRCERR, RXCRCERR_OUT);
buf B_RXDATA0 (RXDATA[0], RXDATA_OUT[0]);
buf B_RXDATA1 (RXDATA[1], RXDATA_OUT[1]);
buf B_RXDATA2 (RXDATA[2], RXDATA_OUT[2]);
buf B_RXDATA3 (RXDATA[3], RXDATA_OUT[3]);
buf B_RXDATA4 (RXDATA[4], RXDATA_OUT[4]);
buf B_RXDATA5 (RXDATA[5], RXDATA_OUT[5]);
buf B_RXDATA6 (RXDATA[6], RXDATA_OUT[6]);
buf B_RXDATA7 (RXDATA[7], RXDATA_OUT[7]);
buf B_RXDATA8 (RXDATA[8], RXDATA_OUT[8]);
buf B_RXDATA9 (RXDATA[9], RXDATA_OUT[9]);
buf B_RXDATA10 (RXDATA[10], RXDATA_OUT[10]);
buf B_RXDATA11 (RXDATA[11], RXDATA_OUT[11]);
buf B_RXDATA12 (RXDATA[12], RXDATA_OUT[12]);
buf B_RXDATA13 (RXDATA[13], RXDATA_OUT[13]);
buf B_RXDATA14 (RXDATA[14], RXDATA_OUT[14]);
buf B_RXDATA15 (RXDATA[15], RXDATA_OUT[15]);
buf B_RXDATA16 (RXDATA[16], RXDATA_OUT[16]);
buf B_RXDATA17 (RXDATA[17], RXDATA_OUT[17]);
buf B_RXDATA18 (RXDATA[18], RXDATA_OUT[18]);
buf B_RXDATA19 (RXDATA[19], RXDATA_OUT[19]);
buf B_RXDATA20 (RXDATA[20], RXDATA_OUT[20]);
buf B_RXDATA21 (RXDATA[21], RXDATA_OUT[21]);
buf B_RXDATA22 (RXDATA[22], RXDATA_OUT[22]);
buf B_RXDATA23 (RXDATA[23], RXDATA_OUT[23]);
buf B_RXDATA24 (RXDATA[24], RXDATA_OUT[24]);
buf B_RXDATA25 (RXDATA[25], RXDATA_OUT[25]);
buf B_RXDATA26 (RXDATA[26], RXDATA_OUT[26]);
buf B_RXDATA27 (RXDATA[27], RXDATA_OUT[27]);
buf B_RXDATA28 (RXDATA[28], RXDATA_OUT[28]);
buf B_RXDATA29 (RXDATA[29], RXDATA_OUT[29]);
buf B_RXDATA30 (RXDATA[30], RXDATA_OUT[30]);
buf B_RXDATA31 (RXDATA[31], RXDATA_OUT[31]);
buf B_RXDISPERR0 (RXDISPERR[0], RXDISPERR_OUT[0]);
buf B_RXDISPERR1 (RXDISPERR[1], RXDISPERR_OUT[1]);
buf B_RXDISPERR2 (RXDISPERR[2], RXDISPERR_OUT[2]);
buf B_RXDISPERR3 (RXDISPERR[3], RXDISPERR_OUT[3]);
buf B_RXLOSSOFSYNC0 (RXLOSSOFSYNC[0], RXLOSSOFSYNC_OUT[0]);
buf B_RXLOSSOFSYNC1 (RXLOSSOFSYNC[1], RXLOSSOFSYNC_OUT[1]);
buf B_RXNOTINTABLE0 (RXNOTINTABLE[0], RXNOTINTABLE_OUT[0]);
buf B_RXNOTINTABLE1 (RXNOTINTABLE[1], RXNOTINTABLE_OUT[1]);
buf B_RXNOTINTABLE2 (RXNOTINTABLE[2], RXNOTINTABLE_OUT[2]);
buf B_RXNOTINTABLE3 (RXNOTINTABLE[3], RXNOTINTABLE_OUT[3]);
buf B_RXREALIGN (RXREALIGN, RXREALIGN_OUT);
buf B_RXRECCLK (RXRECCLK, RXRECCLK_OUT);
buf B_RXRUNDISP0 (RXRUNDISP[0], RXRUNDISP_OUT[0]);
buf B_RXRUNDISP1 (RXRUNDISP[1], RXRUNDISP_OUT[1]);
buf B_RXRUNDISP2 (RXRUNDISP[2], RXRUNDISP_OUT[2]);
buf B_RXRUNDISP3 (RXRUNDISP[3], RXRUNDISP_OUT[3]);
buf B_TXBUFERR (TXBUFERR, TXBUFERR_OUT);
buf B_TXKERR0 (TXKERR[0], TXKERR_OUT[0]);
buf B_TXKERR1 (TXKERR[1], TXKERR_OUT[1]);
buf B_TXKERR2 (TXKERR[2], TXKERR_OUT[2]);
buf B_TXKERR3 (TXKERR[3], TXKERR_OUT[3]);
// buf B_TXN (TXN, TXN_OUT);
// buf B_TXP (TXP, TXP_OUT);
buf B_TXRUNDISP0 (TXRUNDISP[0], TXRUNDISP_OUT[0]);
buf B_TXRUNDISP1 (TXRUNDISP[1], TXRUNDISP_OUT[1]);
buf B_TXRUNDISP2 (TXRUNDISP[2], TXRUNDISP_OUT[2]);
buf B_TXRUNDISP3 (TXRUNDISP[3], TXRUNDISP_OUT[3]);

buf B_BREFCLK (BREFCLK_IN, BREFCLK);
buf B_BREFCLK2 (BREFCLK2_IN, BREFCLK2);
buf B_CHBONDI0 (CHBONDI_IN[0], CHBONDI[0]);
buf B_CHBONDI1 (CHBONDI_IN[1], CHBONDI[1]);
buf B_CHBONDI2 (CHBONDI_IN[2], CHBONDI[2]);
buf B_CHBONDI3 (CHBONDI_IN[3], CHBONDI[3]);
buf B_CONFIGENABLE (CONFIGENABLE_IN, CONFIGENABLE);
buf B_CONFIGIN (CONFIGIN_IN, CONFIGIN);
buf B_ENCHANSYNC (ENCHANSYNC_IN, ENCHANSYNC);
buf B_ENMCOMMAALIGN (ENMCOMMAALIGN_IN, ENMCOMMAALIGN);
buf B_ENPCOMMAALIGN (ENPCOMMAALIGN_IN, ENPCOMMAALIGN);
buf B_LOOPBACK0 (LOOPBACK_IN[0], LOOPBACK[0]);
buf B_LOOPBACK1 (LOOPBACK_IN[1], LOOPBACK[1]);
buf B_POWERDOWN (POWERDOWN_IN, POWERDOWN);
buf B_REFCLK (REFCLK_IN, REFCLK);
buf B_REFCLK2 (REFCLK2_IN, REFCLK2);
buf B_REFCLKSEL (REFCLKSEL_IN, REFCLKSEL);
buf B_RXN (RXN_IN, RXN);
buf B_RXP (RXP_IN, RXP);
buf B_RXPOLARITY (RXPOLARITY_IN, RXPOLARITY);
buf B_RXRESET (RXRESET_IN, RXRESET);
buf B_RXUSRCLK (RXUSRCLK_IN, RXUSRCLK);
buf B_RXUSRCLK2 (RXUSRCLK2_IN, RXUSRCLK2);
buf B_TXBYPASS8B10B0 (TXBYPASS8B10B_IN[0], TXBYPASS8B10B[0]);
buf B_TXBYPASS8B10B1 (TXBYPASS8B10B_IN[1], TXBYPASS8B10B[1]);
buf B_TXBYPASS8B10B2 (TXBYPASS8B10B_IN[2], TXBYPASS8B10B[2]);
buf B_TXBYPASS8B10B3 (TXBYPASS8B10B_IN[3], TXBYPASS8B10B[3]);
buf B_TXCHARDISPMODE0 (TXCHARDISPMODE_IN[0], TXCHARDISPMODE[0]);
buf B_TXCHARDISPMODE1 (TXCHARDISPMODE_IN[1], TXCHARDISPMODE[1]);
buf B_TXCHARDISPMODE2 (TXCHARDISPMODE_IN[2], TXCHARDISPMODE[2]);
buf B_TXCHARDISPMODE3 (TXCHARDISPMODE_IN[3], TXCHARDISPMODE[3]);
buf B_TXCHARDISPVAL0 (TXCHARDISPVAL_IN[0], TXCHARDISPVAL[0]);
buf B_TXCHARDISPVAL1 (TXCHARDISPVAL_IN[1], TXCHARDISPVAL[1]);
buf B_TXCHARDISPVAL2 (TXCHARDISPVAL_IN[2], TXCHARDISPVAL[2]);
buf B_TXCHARDISPVAL3 (TXCHARDISPVAL_IN[3], TXCHARDISPVAL[3]);
buf B_TXCHARISK0 (TXCHARISK_IN[0], TXCHARISK[0]);
buf B_TXCHARISK1 (TXCHARISK_IN[1], TXCHARISK[1]);
buf B_TXCHARISK2 (TXCHARISK_IN[2], TXCHARISK[2]);
buf B_TXCHARISK3 (TXCHARISK_IN[3], TXCHARISK[3]);
buf B_TXDATA0 (TXDATA_IN[0], TXDATA[0]);
buf B_TXDATA1 (TXDATA_IN[1], TXDATA[1]);
buf B_TXDATA2 (TXDATA_IN[2], TXDATA[2]);
buf B_TXDATA3 (TXDATA_IN[3], TXDATA[3]);
buf B_TXDATA4 (TXDATA_IN[4], TXDATA[4]);
buf B_TXDATA5 (TXDATA_IN[5], TXDATA[5]);
buf B_TXDATA6 (TXDATA_IN[6], TXDATA[6]);
buf B_TXDATA7 (TXDATA_IN[7], TXDATA[7]);
buf B_TXDATA8 (TXDATA_IN[8], TXDATA[8]);
buf B_TXDATA9 (TXDATA_IN[9], TXDATA[9]);
buf B_TXDATA10 (TXDATA_IN[10], TXDATA[10]);
buf B_TXDATA11 (TXDATA_IN[11], TXDATA[11]);
buf B_TXDATA12 (TXDATA_IN[12], TXDATA[12]);
buf B_TXDATA13 (TXDATA_IN[13], TXDATA[13]);
buf B_TXDATA14 (TXDATA_IN[14], TXDATA[14]);
buf B_TXDATA15 (TXDATA_IN[15], TXDATA[15]);
buf B_TXDATA16 (TXDATA_IN[16], TXDATA[16]);
buf B_TXDATA17 (TXDATA_IN[17], TXDATA[17]);
buf B_TXDATA18 (TXDATA_IN[18], TXDATA[18]);
buf B_TXDATA19 (TXDATA_IN[19], TXDATA[19]);
buf B_TXDATA20 (TXDATA_IN[20], TXDATA[20]);
buf B_TXDATA21 (TXDATA_IN[21], TXDATA[21]);
buf B_TXDATA22 (TXDATA_IN[22], TXDATA[22]);
buf B_TXDATA23 (TXDATA_IN[23], TXDATA[23]);
buf B_TXDATA24 (TXDATA_IN[24], TXDATA[24]);
buf B_TXDATA25 (TXDATA_IN[25], TXDATA[25]);
buf B_TXDATA26 (TXDATA_IN[26], TXDATA[26]);
buf B_TXDATA27 (TXDATA_IN[27], TXDATA[27]);
buf B_TXDATA28 (TXDATA_IN[28], TXDATA[28]);
buf B_TXDATA29 (TXDATA_IN[29], TXDATA[29]);
buf B_TXDATA30 (TXDATA_IN[30], TXDATA[30]);
buf B_TXDATA31 (TXDATA_IN[31], TXDATA[31]);
buf B_TXFORCECRCERR (TXFORCECRCERR_IN, TXFORCECRCERR);
buf B_TXINHIBIT (TXINHIBIT_IN, TXINHIBIT);
buf B_TXPOLARITY (TXPOLARITY_IN, TXPOLARITY);
buf B_TXRESET (TXRESET_IN, TXRESET);
buf B_TXUSRCLK (TXUSRCLK_IN, TXUSRCLK);
buf B_TXUSRCLK2 (TXUSRCLK2_IN, TXUSRCLK2);

GT_SWIFT gt_swift_1 (
	.ALIGN_COMMA_MSB (ALIGN_COMMA_MSB_BINARY),
	.BREFCLK (BREFCLK_IN),
	.BREFCLK2 (BREFCLK2_IN),
	.CHAN_BOND_LIMIT (CHAN_BOND_LIMIT_BINARY),
	.CHAN_BOND_MODE (CHAN_BOND_MODE_BINARY),
	.CHAN_BOND_OFFSET (CHAN_BOND_OFFSET_BINARY),
	.CHAN_BOND_ONE_SHOT (CHAN_BOND_ONE_SHOT_BINARY),
	.CHAN_BOND_SEQ_1_1 (CHAN_BOND_SEQ_1_1),
	.CHAN_BOND_SEQ_1_2 (CHAN_BOND_SEQ_1_2),
	.CHAN_BOND_SEQ_1_3 (CHAN_BOND_SEQ_1_3),
	.CHAN_BOND_SEQ_1_4 (CHAN_BOND_SEQ_1_4),
	.CHAN_BOND_SEQ_2_1 (CHAN_BOND_SEQ_2_1),
	.CHAN_BOND_SEQ_2_2 (CHAN_BOND_SEQ_2_2),
	.CHAN_BOND_SEQ_2_3 (CHAN_BOND_SEQ_2_3),
	.CHAN_BOND_SEQ_2_4 (CHAN_BOND_SEQ_2_4),
	.CHAN_BOND_SEQ_2_USE (CHAN_BOND_SEQ_2_USE_BINARY),
	.CHAN_BOND_SEQ_LEN (CHAN_BOND_SEQ_LEN_BINARY),
	.CHAN_BOND_WAIT (CHAN_BOND_WAIT_BINARY),
	.CHBONDDONE (CHBONDDONE_OUT),
	.CHBONDI (CHBONDI_IN),
	.CHBONDO (CHBONDO_OUT),
	.CLK_CORRECT_USE (CLK_CORRECT_USE_BINARY),
	.CLK_COR_INSERT_IDLE_FLAG (CLK_COR_INSERT_IDLE_FLAG_BINARY),
	.CLK_COR_KEEP_IDLE (CLK_COR_KEEP_IDLE_BINARY),
	.CLK_COR_REPEAT_WAIT (CLK_COR_REPEAT_WAIT_BINARY),
	.CLK_COR_SEQ_1_1 (CLK_COR_SEQ_1_1),
	.CLK_COR_SEQ_1_2 (CLK_COR_SEQ_1_2),
	.CLK_COR_SEQ_1_3 (CLK_COR_SEQ_1_3),
	.CLK_COR_SEQ_1_4 (CLK_COR_SEQ_1_4),
	.CLK_COR_SEQ_2_1 (CLK_COR_SEQ_2_1),
	.CLK_COR_SEQ_2_2 (CLK_COR_SEQ_2_2),
	.CLK_COR_SEQ_2_3 (CLK_COR_SEQ_2_3),
	.CLK_COR_SEQ_2_4 (CLK_COR_SEQ_2_4),
	.CLK_COR_SEQ_2_USE (CLK_COR_SEQ_2_USE_BINARY),
	.CLK_COR_SEQ_LEN (CLK_COR_SEQ_LEN_BINARY),
	.COMMA_10B_MASK (COMMA_10B_MASK),
	.CONFIGENABLE (CONFIGENABLE_IN),
	.CONFIGIN (CONFIGIN_IN),
	.CONFIGOUT (CONFIGOUT_OUT),
	.CRC_END_OF_PKT (CRC_END_OF_PKT_BINARY),
	.CRC_FORMAT (CRC_FORMAT_BINARY),
	.CRC_START_OF_PKT (CRC_START_OF_PKT_BINARY),
	.DEC_MCOMMA_DETECT (DEC_MCOMMA_DETECT_BINARY),
	.DEC_PCOMMA_DETECT (DEC_PCOMMA_DETECT_BINARY),
	.DEC_VALID_COMMA_ONLY (DEC_VALID_COMMA_ONLY_BINARY),
	.ENCHANSYNC (ENCHANSYNC_IN),
	.ENMCOMMAALIGN (ENMCOMMAALIGN_IN),
	.ENPCOMMAALIGN (ENPCOMMAALIGN_IN),
	.GSR (GSR),
	.LOOPBACK (LOOPBACK_IN),
	.MCOMMA_10B_VALUE (MCOMMA_10B_VALUE),
	.MCOMMA_DETECT (MCOMMA_DETECT_BINARY),
	.PCOMMA_10B_VALUE (PCOMMA_10B_VALUE),
	.PCOMMA_DETECT (PCOMMA_DETECT_BINARY),
	.POWERDOWN (POWERDOWN_IN),
	.REFCLK (REFCLK_IN),
	.REFCLK2 (REFCLK2_IN),
	.REFCLKSEL (REFCLKSEL_IN),
	.REF_CLK_V_SEL (REF_CLK_V_SEL_BINARY),
	.RXBUFSTATUS (RXBUFSTATUS_OUT),
	.RXCHARISCOMMA (RXCHARISCOMMA_OUT),
	.RXCHARISK (RXCHARISK_OUT),
	.RXCHECKINGCRC (RXCHECKINGCRC_OUT),
	.RXCLKCORCNT (RXCLKCORCNT_OUT),
	.RXCOMMADET (RXCOMMADET_OUT),
	.RXCRCERR (RXCRCERR_OUT),
	.RXDATA (RXDATA_OUT),
	.RXDISPERR (RXDISPERR_OUT),
	.RXLOSSOFSYNC (RXLOSSOFSYNC_OUT),
	.RXN (RXN_IN),
	.RXNOTINTABLE (RXNOTINTABLE_OUT),
	.RXP (RXP_IN),
	.RXPOLARITY (RXPOLARITY_IN),
	.RXREALIGN (RXREALIGN_OUT),
	.RXRECCLK (RXRECCLK_OUT),
	.RXRESET (RXRESET_IN),
	.RXRUNDISP (RXRUNDISP_OUT),
	.RXUSRCLK (RXUSRCLK_IN),
	.RXUSRCLK2 (RXUSRCLK2_IN),
	.RX_BUFFER_USE (RX_BUFFER_USE_BINARY),
	.RX_CRC_USE (RX_CRC_USE_BINARY),
	.RX_DATA_WIDTH (RX_DATA_WIDTH_BINARY),
	.RX_DECODE_USE (RX_DECODE_USE_BINARY),
	.RX_LOSS_OF_SYNC_FSM (RX_LOSS_OF_SYNC_FSM_BINARY),
	.RX_LOS_INVALID_INCR (RX_LOS_INVALID_INCR_BINARY),
	.RX_LOS_THRESHOLD (RX_LOS_THRESHOLD_BINARY),
	.SERDES_10B (SERDES_10B_BINARY),
	.TERMINATION_IMP (TERMINATION_IMP_BINARY),
	.TXBUFERR (TXBUFERR_OUT),
	.TXBYPASS8B10B (TXBYPASS8B10B_IN),
	.TXCHARDISPMODE (TXCHARDISPMODE_IN),
	.TXCHARDISPVAL (TXCHARDISPVAL_IN),
	.TXCHARISK (TXCHARISK_IN),
	.TXDATA (TXDATA_IN),
	.TXFORCECRCERR (TXFORCECRCERR_IN),
	.TXINHIBIT (TXINHIBIT_IN),
	.TXKERR (TXKERR_OUT),
	.TXN (TXN),
	.TXP (TXP),
	.TXPOLARITY (TXPOLARITY_IN),
	.TXRESET (TXRESET_IN),
	.TXRUNDISP (TXRUNDISP_OUT),
	.TXUSRCLK (TXUSRCLK_IN),
	.TXUSRCLK2 (TXUSRCLK2_IN),
	.TX_BUFFER_USE (TX_BUFFER_USE_BINARY),
	.TX_CRC_FORCE_VALUE (TX_CRC_FORCE_VALUE),
	.TX_CRC_USE (TX_CRC_USE_BINARY),
	.TX_DATA_WIDTH (TX_DATA_WIDTH_BINARY),
	.TX_DIFF_CTRL (TX_DIFF_CTRL_BINARY),
	.TX_PREEMPHASIS (TX_PREEMPHASIS_BINARY)
);

specify
	(RXUSRCLK *> CHBONDO) = (0, 0);
	(RXUSRCLK2 *> RXBUFSTATUS) = (0, 0);
	(RXUSRCLK2 *> RXCHARISCOMMA) = (0, 0);
	(RXUSRCLK2 *> RXCHARISK) = (0, 0);
	(RXUSRCLK2 *> RXCLKCORCNT) = (0, 0);
	(RXUSRCLK2 *> RXDATA) = (0, 0);
	(RXUSRCLK2 *> RXDISPERR) = (0, 0);
	(RXUSRCLK2 *> RXLOSSOFSYNC) = (0, 0);
	(RXUSRCLK2 *> RXNOTINTABLE) = (0, 0);
	(RXUSRCLK2 *> RXRUNDISP) = (0, 0);
	(RXUSRCLK2 => CHBONDDONE) = (0, 0);
	(RXUSRCLK2 => RXCHECKINGCRC) = (0, 0);
	(RXUSRCLK2 => RXCOMMADET) = (0, 0);
	(RXUSRCLK2 => RXCRCERR) = (0, 0);
	(RXUSRCLK2 => RXREALIGN) = (0, 0);
	(TXUSRCLK2 *> TXKERR) = (0, 0);
	(TXUSRCLK2 *> TXRUNDISP) = (0, 0);
	(TXUSRCLK2 => CONFIGOUT) = (0, 0);
	(TXUSRCLK2 => TXBUFERR) = (0, 0);
endspecify
endmodule
