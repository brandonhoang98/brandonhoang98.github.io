//******************************************************************************

//******************************************************************************

`timescale 1ns/10ps

module VFFT32_V3_0 (CLK, CE, RESET, START, FWD_INV, MRD, MWR, XN_RE, XN_IM, OVFLO, DONE, EDONE, IO, EIO, BUSY, XK_RE, XK_IM);

parameter BUTTERFLY_PRECISION = 16;
parameter C_FAMILY_INT = 0;
parameter DATA_MEMORY = "";
parameter MEMORY_ARCHITECTURE = 3;
parameter MULT_TYPE = 0;
parameter PHASE_FACTOR_PRECISION = 16;
parameter SCALING_SCHEDULE_MEM1 = "";
parameter SCALING_SCHEDULE_MEM2 = "";



input CLK;
input CE;
input RESET;
input START;
input FWD_INV;
input MRD;
input MWR;
input [BUTTERFLY_PRECISION-1:0] XN_RE;
input [BUTTERFLY_PRECISION-1:0] XN_IM;

output OVFLO;
output DONE;
output EDONE;
output IO;
output EIO;
output BUSY;
output [BUTTERFLY_PRECISION-1:0] XK_RE;
output [BUTTERFLY_PRECISION-1:0] XK_IM;

// The following is required to keep the synthesis tool from trying to 
// synthesize this module

// synopsys_translate_off

wire [BUTTERFLY_PRECISION-1:0] xk_re_tms;
wire [BUTTERFLY_PRECISION-1:0] xk_im_tms;
wire [BUTTERFLY_PRECISION-1:0] xk_re_sms;
wire [BUTTERFLY_PRECISION-1:0] xk_im_sms;

wire [4:0] address;
wire [1:0] rank_number;
wire [4:0] user_ld_addr;
wire usr_loading_addr;
wire bfly_res_avail;
wire e_bfly_res_avail;
wire wea_x;
wire wea_y;
wire web_x;
wire web_y;
wire ena_x;
wire ena_y;
wire [4:0] wr_addr;
wire [4:0] rd_addrb_x;
wire [4:0] rd_addrb_y;
wire xbar_y;
wire [BUTTERFLY_PRECISION-1:0] xk_r;
wire [BUTTERFLY_PRECISION-1:0] xk_i;

wire [BUTTERFLY_PRECISION-1:0]to_bfly_re;
wire [BUTTERFLY_PRECISION-1:0]to_bfly_im;
wire [BUTTERFLY_PRECISION-1:0]to_bfly_re_tms;
wire [BUTTERFLY_PRECISION-1:0]to_bfly_im_tms;
wire [BUTTERFLY_PRECISION-1:0]to_bfly_re_sms;
wire [BUTTERFLY_PRECISION-1:0]to_bfly_im_sms;

wire [BUTTERFLY_PRECISION-1:0] y0r;  
wire [BUTTERFLY_PRECISION-1:0] y0i;  
wire [BUTTERFLY_PRECISION-1:0] y1r;  
wire [BUTTERFLY_PRECISION-1:0] y1i;  
wire [BUTTERFLY_PRECISION-1:0] y2r;  
wire [BUTTERFLY_PRECISION-1:0] y2i;  
wire [BUTTERFLY_PRECISION-1:0] y3r; 
wire [BUTTERFLY_PRECISION-1:0] y3i;  
wire [PHASE_FACTOR_PRECISION-1:0] wr;
wire [PHASE_FACTOR_PRECISION-1:0] wi;
wire result_avail; 
wire e_result_available; 
wire result_available; 
wire e_result_ready; 
wire result_ready; 
wire ce_phase_factors;
wire e_done_int;
wire done_int;
wire writing_result;
wire reading_result;

wire [4:0] addra_dmem;
wire [4:0] addrb_dmem;
wire [1:0] data_sel;
wire we_dmem;
wire we_dmem_dms;
wire d_a_dmem_dms_sel;
wire [4:0] addrb_dmem_dms;
wire [4:0] addrb_dmem_tms;
wire wex_dmem_tms;
wire wey_dmem_tms;

wire dummy_addr;
wire done_int_temp;
wire edone_int_temp;
wire done_tms_dms;
wire done_sms;
wire edone_sms;
wire inv_fft = 1'b0;

wire [4:0] addra_x_dmem;
wire [4:0] addra_y_dmem;
wire initial_data_load_x;
wire [1:0] address_select;
wire ext_to_xbar_y_temp_out;
wire io_pulse;
wire address_select_dms_out; 
wire reset_io_out;
wire io_out;
wire eio_out;
wire eio_pulse_out;

wire result_rdy; 

vfft32_mem_address_v2_0 # (5, MEMORY_ARCHITECTURE)
	
mem_addr_gen   (.clk(CLK),
		.ce(CE),
		.reset(RESET),
		.start(START),
		.mwr(MWR),
		.io_pulse(io_pulse),
		.io(io_out),
		.address(address),
		.rank_number(rank_number),
		.user_ld_addr(user_ld_addr),	
		.busy_usr_loading_addr(usr_loading_addr),
		.initial_data_load_x(initial_data_load_x));

vfft32_mem_ctrl_v2_0 # ( 5, PHASE_FACTOR_PRECISION, BUTTERFLY_PRECISION, MEMORY_ARCHITECTURE, DATA_MEMORY)

mem_ctrl_gen   (.clk(CLK),
		.ce(CE),
		.start(START),
		.reset(RESET),
		.mwr(MWR),
		.mrd(MRD),
		.usr_loading_addr(usr_loading_addr),
		.address(address),
		.usr_load_addr(user_ld_addr),
		.initial_data_load_x(initial_data_load_x),
		.rank_number(rank_number),
		.bfly_res_avail(bfly_res_avail),
		.e_bfly_res_avail(e_bfly_res_avail),
		.done_int(done_int),
		.e_done_int(e_done_int),
		.result_avail(result_available),
		.xbar_y(xbar_y),
		.ext_to_xbar_y_temp_out(ext_to_xbar_y_temp_out),
		.io(io_out),
		.io_pulse(io_pulse),
		.eio_pulse_out(eio_pulse_out),
		.eio(eio_out),
		.reset_io_out(reset_io_out),
		.we_dmem(we_dmem),
		.we_dmem_dms(we_dmem_dms),
		.wex_dmem_tms(wex_dmem_tms),
		.wey_dmem_tms(wey_dmem_tms),
		.d_a_dmem_dms_sel(d_a_dmem_dms_sel),
		.wea_x(wea_x),
		.wea_y(wea_y),
		.web_x(web_x),
		.web_y(web_y),
		.ena_x(ena_x),
		.ena_y(ena_y),
		.data_sel(data_sel),
		.writing_result(writing_result),
		.reading_result(reading_result),
		.wr_addr(wr_addr),
                .address_select(address_select),
                .address_select_dms_out(address_select_dms_out),  
		.addra_dmem(addra_dmem),
		.addra_x_dmem(addra_x_dmem),
		.addra_y_dmem(addra_y_dmem),
		.addrb_dmem(addrb_dmem),
		.addrb_dmem_dms(addrb_dmem_dms),
		.addrb_dmem_tms(addrb_dmem_tms),
		.rd_addrb_x(rd_addrb_x),
		.rd_addrb_y(rd_addrb_y));

//tms_dms_working_mem_gen: IF ((MEMORY_ARCHITECTURE =3)OR //(MEMORY_ARCHITECTURE=2) ) GENERATE 

vfft32_working_memory_v2_0 # ( BUTTERFLY_PRECISION, 5, MEMORY_ARCHITECTURE, DATA_MEMORY)

working_mem_gen (.clk(CLK),
		.reset(RESET),
		.start(START),
		.xbar_y(xbar_y),
		.ext_to_xbar_y_temp_out(ext_to_xbar_y_temp_out),
		.dia_r(xk_r),
		.dia_i(xk_i),
		.ena_x(ena_x),
		.wea_x(wea_x),
		.wex_dmem_tms(wex_dmem_tms),
		.wey_dmem_tms(wey_dmem_tms),
		.addra(wr_addr),
		.addra_dmem(addra_dmem),
		.addra_x_dmem(addra_x_dmem),
		.addra_y_dmem(addra_y_dmem),
		.xn_re(XN_RE),
		.xn_im(XN_IM),
		.web_x(web_x),
		.we_dmem_dms(we_dmem_dms),
		.d_a_dmem_dms_sel(d_a_dmem_dms_sel),
		.usr_loading_addr(usr_loading_addr),
		.addrb_dmem_dms(addrb_dmem_dms),
		.addrb_dmem_tms(addrb_dmem_tms),
                .address_select(address_select), 
                .address_select_dms(address_select_dms_out), 
		.ena_y(ena_y),
		.wea_y(wea_y),
		.web_y(web_y),
		.mem_outr(to_bfly_re_tms),
		.mem_outi(to_bfly_im_tms));

assign to_bfly_re = (MEMORY_ARCHITECTURE == 3) ? to_bfly_re_tms : (MEMORY_ARCHITECTURE == 2) ? to_bfly_re_tms : (MEMORY_ARCHITECTURE == 1) ? to_bfly_re_sms : 0;

assign to_bfly_im = (MEMORY_ARCHITECTURE == 3) ? to_bfly_im_tms : (MEMORY_ARCHITECTURE == 2) ? to_bfly_im_tms : (MEMORY_ARCHITECTURE == 1) ? to_bfly_im_sms : 0;


//END GENERATE tms_dms_working_mem_gen;

//sms_working_mem_gen: IF (MEMORY_ARCHITECTURE =1) GENERATE


vfft32_input_working_result_memory_v2_0 # (BUTTERFLY_PRECISION, 5, BUTTERFLY_PRECISION, DATA_MEMORY)

i_w_r_mem      (.clk(CLK),
		.reset(RESET),
		.ce(CE),
		.fwd_inv(FWD_INV),
		.dia_r(xk_r),
		.dia_i(xk_i),
		.xn_re(XN_RE),
		.xn_im(XN_IM),
		.ena(ena_x),
		.wea(wea_x),
		.addra(wr_addr),
		.addra_dmem(addra_dmem),
		.xn_r(xn_re), 
		.xn_i(xn_im), 
		.data_sel(data_sel),
		.y0r(y0r),
		.y0i(y0i),
		.y1r(y1r),
		.y1i(y1i),
		.y2r(y2r),
		.y2i(y2i),
		.y3r(y3r),
		.y3i(y3i),
		.we_dmem(we_dmem),
		.web(web_x),
		.addrb(rd_addrb_x),
		.addrb_dmem(addrb_dmem),
		.result_avail(result_available), 
		.writing_result(writing_result),
		.reading_result(reading_result),
		.mem_outr(to_bfly_re_sms), 
		.mem_outi(to_bfly_im_sms), 
		.xk_result_out_re(xk_re_sms),
		.xk_result_out_im(xk_im_sms));

assign XK_RE = (MEMORY_ARCHITECTURE == 3) ? xk_re_tms : (MEMORY_ARCHITECTURE == 2) ? xk_re_tms : (MEMORY_ARCHITECTURE == 1) ? xk_re_sms : 0;

assign XK_IM = (MEMORY_ARCHITECTURE == 3) ? xk_im_tms : (MEMORY_ARCHITECTURE == 2) ? xk_im_tms : (MEMORY_ARCHITECTURE == 1) ? xk_im_sms : 0;

//END GENERATE sms_working_mem_gen;

vfft32_bfly_buf_fft_v2_0 # (BUTTERFLY_PRECISION, PHASE_FACTOR_PRECISION, MEMORY_ARCHITECTURE, SCALING_SCHEDULE_MEM1, SCALING_SCHEDULE_MEM2)

bfly_buf_fft_gen (.clk(CLK),
		.ce(CE),
		.start(START),
		.reset(RESET),
		.conj(inv_fft),
		.fwd_inv(FWD_INV),
		.rank_number(rank_number),
		.dr(to_bfly_re),
		.di(to_bfly_im),
		.xkr(xk_r),
		.xki(xk_i),
		.wr(wr),
		.wi(wi),
                .done(DONE),
		.result_avail(result_available),
		.e_result_avail(e_result_available),
		.e_result_ready(e_result_ready),
		.bfly_res_avail(bfly_res_avail),
		.e_bfly_res_avail(e_bfly_res_avail),
		.ce_phase_factors(ce_phase_factors),
		.ovflo(OVFLO),
		.y0r(y0r),
		.y0i(y0i),
		.y1r(y1r),
		.y1i(y1i),
		.y2r(y2r),
		.y2i(y2i),
		.y3r(y3r),
		.y3i(y3i));


vfft32_phase_factors_v2_0 # (PHASE_FACTOR_PRECISION)
	

phase_factor_gen (.clk(CLK),
		  .ce(ce_phase_factors), 
		  .start(START),
		  .reset(RESET),
		  .fwd_inv(FWD_INV),
		  .rank_number(rank_number),
		  .wr(wr),
		  .wi(wi));

//tms_result_mem_gen: IF ((MEMORY_ARCHITECTURE =3) OR (MEMORY_ARCHITECTURE=2)) //GENERATE


vfft32_result_memory_v2_0 # (BUTTERFLY_PRECISION,  5, DATA_MEMORY, MEMORY_ARCHITECTURE)

result_mem_gen (.clk(CLK),
		.ce(CE),
		.mrd(MRD),
		.reset(RESET),
		.fwd_inv(FWD_INV),
		.y0r(y0r),
		.y0i(y0i),
		.y1r(y1r),
		.y1i(y1i),
		.y2r(y2r),
		.y2i(y2i),
		.y3r(y3r),
		.y3i(y3i),
		.e_result_avail(e_result_available),
		.e_result_ready(e_result_ready),
		.reset_io(reset_io_out),
		.eio_out(eio_out),
		.result_ready(result_ready_tms),
		.xk_result_re(xk_re_tms),
		.xk_result_im(xk_im_tms));




//END GENERATE tms_result_mem_gen;

vfft32_hand_shaking_v2_0 # (MEMORY_ARCHITECTURE)
	
hand_shaking_gen (.clk(CLK),
		.ce(CE), 
		.start(START),
		.reset(RESET),
		.result_avail(result_available),
		.eio_pulse_out(eio_pulse_out),
		.busy(BUSY),
		.done(done_int),
		.edone(e_done_int));

assign result_rdy = result_ready;


assign done_int_temp = done_int;
assign edone_int_temp = e_done_int;


//done_gen: IF ((MEMORY_ARCHITECTURE = 3) OR (MEMORY_ARCHITECTURE=2)) GENERATE
  
vfft32_delay_wrapper_v2_0 # (1, 1, 1)
			
done_delay_tms_dms                     (.addr(dummy_addr),
					.data(done_int_temp),
					.clk(CLK),
					.reset(RESET),
					.start(START),
					.delayed_data(done_tms_dms));

assign DONE = (MEMORY_ARCHITECTURE == 3) ? done_tms_dms : (MEMORY_ARCHITECTURE == 2) ? done_tms_dms : (MEMORY_ARCHITECTURE == 1) ? done_sms : 0;

assign EDONE = (MEMORY_ARCHITECTURE == 3) ? e_done_int : (MEMORY_ARCHITECTURE == 2) ? e_done_int : (MEMORY_ARCHITECTURE == 1) ? edone_sms : 0;


vfft32_delay_wrapper_v2_0 # (1, 3, 1)
			
done_delay_sms                         (.addr(dummy_addr),
					.data(done_int_temp),
					.clk(CLK),
					.reset(RESET),
					.start(START),
					.delayed_data(done_sms));
 
vfft32_delay_wrapper_v2_0 # (1, 3, 1)
			
edone_delay_sms                        (.addr(dummy_addr),
					.data(edone_int_temp),
					.clk(CLK),
					.reset(RESET),
					.start(START),
					.delayed_data(edone_sms));

 

assign IO = io_out;
assign EIO = eio_out;


// synopsys_translate_on
 
 // synthesis attribute GENERATOR_DEFAULT of VFFT32_v3_0 is
 // "generatecore com.xilinx.ip.vfft32_v3_0.vfft32_v3_0"
 // The following are required by XST
 // box_type "black_box"
 // synthesis attribute box_type of VFFT32_v3_0 is "black_box"


endmodule

//******************************************************************************

//******************************************************************************

//******************************************************************************

//******************************************************************************

module vfft32_mem_address_v2_0 (clk, ce, reset, start, mwr, io_pulse, io, address, rank_number, user_ld_addr, busy_usr_loading_addr, initial_data_load_x);

parameter points_power = 5;
parameter memory_configuration = 3;

input clk;
input ce;
input reset;
input start;
input mwr;
input io_pulse;
input io;
output [points_power-1:0] address;
output [1:0] rank_number;
output [points_power-1:0] user_ld_addr;
output busy_usr_loading_addr; 
output initial_data_load_x;

parameter init_value = "00000";
parameter usr_ld_init_value = "00000"; 

parameter init_value_1 = "00";
parameter count_by_value = "00001";
parameter count_by_value_1 = "01";
parameter thresh_0_value = "11111";
parameter thresh_0_value_dms = "11111";
parameter two_string = "10";
parameter two_string_thresh0 = "10"; 

wire usr_loading_addr_temp;
wire usr_loading_addr;
reg start_signal;
reg start_wire;

wire reset_usr_ldng_addr;
wire reset_usr_ldng_addr_0;
wire reset_usr_ldng_addr_0_c;
wire reset_usr_ldng_addr_d;
wire usr_loading_addr_e;
wire usr_loading_addr_f;
wire usr_loading_addr_g;

reg [points_power-1:0] user_ld_addr_t;
reg [points_power-1:0] user_ld_addr_d;
reg [points_power-1:0] user_ld_addr_s;
reg [points_power-1:0] user_ld_addr;

wire reset_data_ld_x;
wire reset_data_ld_x1;
reg mwr_or_io_pulse;
reg reset_ula;
wire delayed_io_pulse_out;
wire initial_data_load_x;
wire initial_data_load_x1;

wire dummy_in = 1'b0;

wire open_thresh0;
wire open_thresh1;
wire open_q_thresh1;

reg open_q_thresh0_sms;
reg open_q_thresh0_dms;
reg open_q_thresh0_tms;

wire open_q_thresh0;

wire open_thresh0_a;
wire open_q_thresh0_a;
wire open_thresh1_a;
wire open_q_thresh1_a;

wire open_thresh0_b;
wire open_q_thresh0_b;
wire open_thresh1_b;
wire open_q_thresh1_b;


wire logic_1 = 1'b1;

wire [4:0] zero;
wire [4:0] one;
wire [1:0] zero_1;
wire [1:0] one_1;

assign zero = 5'b0;
assign one = 5'b1;
assign zero_1 = 2'b0;
assign one_1 = 2'b1;

wire open_thresh0_1;
wire open_q_thresh0_1;
wire open_thresh1_1;
wire open_q_thresh1_1;

wire open_thresh0_1_a;
wire open_q_thresh0_1_a;
wire open_thresh1_1_a;
wire open_q_thresh1_1_a;


reg [1:0] unused_count;
reg [1:0] ce_every_three;
reg [1:0] counter;

wire mwr_reg; 
reg start_or_mwr;
reg usr_loading_addr_0;
wire reset_sig;
wire usr_loading_addr_tms;
wire usr_loading_addr_dms;
wire usr_loading_addr_sms;

assign busy_usr_loading_addr = (memory_configuration == 3) ? usr_loading_addr_tms : (memory_configuration == 2) ? usr_loading_addr_dms : (memory_configuration == 1) ? usr_loading_addr_sms :1'b0;


assign usr_loading_addr_temp = (memory_configuration == 3) ? usr_loading_addr_tms : (memory_configuration == 2) ? usr_loading_addr_dms : (memory_configuration == 1) ? usr_loading_addr_sms :1'b0;

assign usr_loading_addr = usr_loading_addr_temp;

always @ (posedge start)

begin

start_signal = 1'b1;

end

always @ (posedge clk)

begin

if (start_signal)

start_wire = 1'b1;

else

start_wire = 1'b0;

end


vfft32_addr_gen_v2_0 #   (5,
                 memory_configuration)
			
rd_wr_adgen                    (.clk(clk),
				.ce(ce),
				.reset(reset),
				.start(start),
                                .io_pulse(io_pulse),
                                .delayed_io_pulse_out(delayed_io_pulse_out),
				.address(address),
				.rank_number(rank_number));


// TMS 

always @ (mwr or start)

begin

start_or_mwr = mwr || start;

end   



always @ (posedge clk)

begin

if (start_or_mwr)

counter = 0;

else if (counter <= 1)

counter = counter + 1;

else counter = 0;

end

always @ (posedge clk)

begin

if (counter == 2)

ce_every_three = 1;

else

ce_every_three = 0;

end
         

always @ (posedge clk)

begin

if (reset)

user_ld_addr_t = 0;

else if (start_or_mwr)

user_ld_addr_t = 0;

else if (~busy_usr_loading_addr)

user_ld_addr_t = 0;

else if (memory_configuration == 3)

begin

if (ce_every_three == 1)

#2 user_ld_addr_t = user_ld_addr_t + 1;

end

end

always @ (posedge clk)

begin

if (reset)

unused_count = 0;

else if (~ce)

unused_count = 0;

else if (start_or_mwr)

unused_count = 0;

else if (memory_configuration == 3)

#2 unused_count = unused_count + 1;

end

always @ (posedge clk)

begin

if (start_or_mwr)

#1 open_q_thresh0_tms = 0;

else if (user_ld_addr_t == 31)

#1 open_q_thresh0_tms = 1;

else

#1 open_q_thresh0_tms = 0;

end


assign open_q_thresh0 = (memory_configuration == 3) ? open_q_thresh0_tms : (memory_configuration == 2) ? open_q_thresh0_dms : (memory_configuration == 1) ? open_q_thresh0_sms : 0;

vfft32_flip_flop_v2_0 reg_q_thresh0          (.d(open_q_thresh0),
					.clk(clk),
					.ce(ce),
					.reset(reset), 
					.q(reset_usr_ldng_addr_0_c));

assign reset_usr_ldng_addr_0 = (memory_configuration == 3) ? reset_usr_ldng_addr_0_c : 1'b0;

vfft32_flip_flop_v2_0    reg_q_thresh0_again   (.d(reset_usr_ldng_addr_0),
					.clk(clk),
					.ce(ce),
					.reset(reset), 
					.q(reset_data_ld_x1));					

assign reset_data_ld_x = (memory_configuration == 3) ? reset_data_ld_x1 : 1'b0;


vfft32_srflop_v2_0       inital_data_ld_x_gen    (.clk(clk),
					.ce(ce),
					.set(mwr),
					.reset(reset_data_ld_x), 
					.q(initial_data_load_x1));

assign initial_data_load_x = (memory_configuration == 3) ? initial_data_load_x1 : 1'b0;

   
vfft32_srflop_v2_0      usr_loading_addr_gen_1   (.clk(clk),
					.ce(ce),
					.set(mwr),
					.reset(reset), 
					.q(usr_loading_addr_e));


assign usr_loading_addr_tms = (memory_configuration == 3) ? usr_loading_addr_e : 1'b0;


//always @ (posedge clk)

//begin

//if (memory_configuration == 3)

//usr_loading_addr = usr_loading_addr_e;

//else 

//usr_loading_addr = 0;

//end


//DMS





always @ (posedge clk)

begin

if (user_ld_addr_d == 5'b11111)

#1 open_q_thresh0_dms = 1;

else

open_q_thresh0_dms = 0;

end


always @ (posedge clk)

begin

if (reset)

user_ld_addr_d = 0;

else if (mwr_or_io_pulse == 1)

user_ld_addr_d = 0;

else if (~ce)

user_ld_addr_d = 0;

else if (memory_configuration == 2)

user_ld_addr_d = user_ld_addr_d + 1;

end

always @ (mwr or io_pulse)

begin: dms1

mwr_or_io_pulse = mwr || io_pulse;

end

always @ (delayed_io_pulse_out or open_q_thresh0)

begin: dms2

#1 reset_ula = delayed_io_pulse_out || open_q_thresh0;

end

vfft32_srflop_v2_0   usr_loading_addr_gen_2      (.clk(clk),
					.ce(ce),
					.set(mwr_or_io_pulse),
					.reset(open_q_thresh0), 
					.q(usr_loading_addr_f));


assign usr_loading_addr_dms = (memory_configuration == 2) ? usr_loading_addr_0 : 1'b0;

always @ (usr_loading_addr_f or io)

begin: dms3

usr_loading_addr_0 = usr_loading_addr_f || io;

end





//SMS MODE

always @ (posedge clk)

begin

if (reset)

user_ld_addr_s = 0;

else if (~ce)

user_ld_addr_s = 0;

else if (mwr)

user_ld_addr_s = 0;

else if (memory_configuration == 1)

user_ld_addr_s = user_ld_addr_s + 1;

end


always @ (posedge clk)

begin

if (memory_configuration == 1)

#2 user_ld_addr = user_ld_addr_s;

else if (memory_configuration == 2)

#2 user_ld_addr = user_ld_addr_d;

else if (memory_configuration == 3)

#2 user_ld_addr = user_ld_addr_t;

end


vfft32_srflop_v2_0   usr_loading_addr_gen_3      (.clk(clk),
					.ce(ce),
					.set(mwr),
					.reset(reset_sig), 
					.q(usr_loading_addr_g));


always @ (posedge clk)

begin

if (user_ld_addr_s == 5'b11111)

#1 open_q_thresh0_sms = 1;

else

open_q_thresh0_sms = 0;

end


assign usr_loading_addr_sms = (memory_configuration == 1) ? usr_loading_addr_g : 1'b0;

assign reset_sig = open_q_thresh0_sms & (!mwr);


endmodule

//******************************************************************************

//******************************************************************************


module vfft32_mem_ctrl_v2_0  (clk, ce, start, reset, mwr, mrd, usr_loading_addr, address, usr_load_addr,	initial_data_load_x, rank_number, bfly_res_avail, e_bfly_res_avail, e_done_int, done_int,	result_avail, xbar_y, 	ext_to_xbar_y_temp_out,	io, eio, io_pulse, eio_pulse_out, reset_io_out,			we_dmem, we_dmem_dms, wex_dmem_tms, wey_dmem_tms, d_a_dmem_dms_sel, wea_x, 		wea_y, 	web_x, 	web_y, ena_x, ena_y, data_sel,	address_select, 	address_select_dms_out, reading_result, writing_result, wr_addr, 	addra_dmem, addra_x_dmem, addra_y_dmem,	addrb_dmem, addrb_dmem_dms, 		addrb_dmem_tms,	rd_addrb_x, rd_addrb_y);

parameter points_power = 5;
parameter W_WIDTH =16;
parameter B = 16;
parameter memory_configuration =3;
parameter data_memory = "distributed_memory";

input clk;
input ce;
input start;
input reset;
input mwr;
input mrd;
input usr_loading_addr;
input [points_power-1:0] address;
input [points_power-1:0] usr_load_addr;
input initial_data_load_x;
input [1:0] rank_number;
input bfly_res_avail;
input e_bfly_res_avail;
input e_done_int;
input done_int;
input result_avail;

output xbar_y;
output [0:0] ext_to_xbar_y_temp_out;
output io;
output eio;
output io_pulse;
output eio_pulse_out;
output reset_io_out;
output we_dmem;
output we_dmem_dms;
output wex_dmem_tms;
output wey_dmem_tms;
output d_a_dmem_dms_sel;
output wea_x; 
output wea_y;
output web_x;
output web_y;
output ena_x;
output ena_y;
output [1:0] data_sel;
output [1:0] address_select;
output [0:0] address_select_dms_out;
output reading_result;
output writing_result;
output [points_power-1:0] wr_addr; 
output [points_power-1:0] addra_dmem;
output [points_power-1:0] addra_x_dmem;
output [points_power-1:0] addra_y_dmem;
output [points_power-1:0] addrb_dmem;
output [points_power-1:0] addrb_dmem_dms;
output [points_power-1:0] addrb_dmem_tms;
output [points_power-1:0] rd_addrb_x;
output [points_power-1:0] rd_addrb_y; 

wire [points_power-1:0] addra_x_dmem1;
wire [points_power-1:0] addra_y_dmem1;
wire [points_power-1:0] rd_addrb_x1;
wire [points_power-1:0] rd_addrb_y1; 
wire wex_dmem_tms1;
wire wey_dmem_tms1;
wire web_x2;
wire we_dmem2;
wire we_dmem_dms3;

reg eio_int3;
reg [1:0] count_rank_number;
reg [1:0] c_rank_number;
reg mrd_sclr;

parameter ainit_val = "1";

//parameter delay_by_value	: INTEGER := bfly32_latency(W_WIDTH, B) +9 -3; //parameter butterfly_latency : INTEGER := bfly_latency(W_WIDTH, B);
parameter start_to_bfly_input_latency = 3; 
parameter bfly_res_avail_latency = 16; 

parameter init_value = "000000";
parameter count_by_value = "000001";
parameter string_31 = "11111";
parameter ainit_val_bank = "0";

parameter ninety_six = "1100000";

parameter one_string_1 = "00001";
parameter ainit_val_1 = "00000";
parameter sinit_val_1 = "00000";
parameter thirty_one_1 = "11111";
parameter string_29 = "11101";
parameter string_28 = "11100";


wire final_rank;
wire bank;
wire bank1;  
wire switch_banks;
wire switch_banks1;
reg switch_bank_temp;
wire not_bank;
wire not_bank1;
wire delay_addr;
wire ena_x;
wire ena_y;
wire web_x;
wire web_y;
wire xbar_y;
wire wea_x;
wire wea_y;

wire dummy_in = 1'b0;


wire [points_power-1:0] open_q_0_tms;
wire [points_power-1:0] open_q_0_dms;
wire [points_power-1:0] open_q_0_sms;
wire [points_power-1:0] open_q_1_tms;
wire aeqb;
wire aneb;
wire altb;
wire agtb;
wire aleb;
wire ageb;
wire qaeqb;
wire qaneb;
wire qaltb;
wire qagtb;
wire qaleb;
wire qageb;

wire [points_power-1:0] dummy_mux_inputs;

wire xbar_y_temp;
wire [3:0] delay_addr_value;
wire bfly_res_avail_flag;
wire e_bfly_res_avail_flag;

wire int_ena_x;
wire int_ena_y;
wire int_web_x;
wire int_web_y;
wire int_ena_x1;
wire int_ena_y1;
wire int_web_x1;
wire int_web_y1;

wire last_bfly_in_rank;
wire last_bfly_in_rank1;
wire ext_to_xbar_y;
wire ext_to_xbar_y1;
wire not_ext_to_xbar_y;
wire not_ext_to_xbar_y1;
wire ext_to_xbar_y_temp;
//wire ext_to_xbar_y_temp1;

wire open_thresh0;
wire open_q_thresh0;
wire open_thresh1;
wire open_q_thresh1;

wire logic_1 = 1'b1;
wire zero = "000000";
wire one = "000001";
wire [4:0] thirty_one = "11111";

wire dummy_addr;
wire temp_int_ena_x;
wire temp_int_ena_y;
wire temp_int_ena_x1;
wire temp_int_ena_y1;


wire zero_96 = "0000000";
wire one_96 = "0000001";
wire open_thresh0_96;
wire open_q_thresh0_96;
wire open_thresh1_96;
wire open_q_thresh1_96;
reg count96_tc;
wire mwr_or_start_or_count96_tc;
wire mwr_or_start_or_count96_tc1;
reg [6:0] count96;
wire ce_96;
wire ce_961;
wire delayed_ext_to_xbar_y_temp;
wire [points_power-1:0]delayed_usr_load_addr;
wire [1:0] address_select_int;
wire count95_tc;
wire count95_tc1;
wire fake_out;

wire reading_result_flag;
reg reading_result_temp;
wire reading_result_temp2;
wire writing_result_internal;
wire writing_result_internal2;
wire writing_result_int;
wire writing_result_int2;
wire writing_result_int_temp;

wire usr_loading_addr_temp;
reg [points_power-1:0] result_wr_addr;
wire [points_power-1:0] bfly_or_result_wr_rd_addr;
wire [points_power-1:0] bfly_rd_or_user_ld_addr;
wire [points_power-1:0] open_q_0_1;
wire one_1 = "00001";
wire zero_1 = "00000";
wire open_thresh0_2;
wire open_q_thresh0_2;
wire open_thresh1_2;
wire open_q_thresh1_2;
wire open_thresh0_3;
wire open_thresh1_3;
wire open_q_thresh1_3; 
reg disable_read_enable;
wire [points_power-1:0] open_mux_ad;

wire [1:0] bfly_or_rd_wr_result_sel; 
reg [points_power-1:0] result_wr_addr_scrambled;
wire [points_power-1:0] result_wr_addr_scrambled_delayed;
wire [points_power-1:0] result_wr_addr_scrambled_delayed2;

reg [points_power-1:0] result_read_addr;

wire e_done_int_z;
wire done_int_z;
wire e_done_int_z2;
wire done_int_z2;

wire e_writing_result_int;
wire e_writing_result_int2;
wire web_x_temp;
wire web_x_temp2;
wire e_done_int_z_temp;
wire done_int_z_temp;
wire e_done_int_z_32;
wire done_int_z_32;
wire e_done_int_z_322;
wire done_int_z_322;

wire [points_power-1:0]addra_dmem2;
wire [points_power-1:0]addra_dmem3;
wire [points_power-1:0]addrb_dmem2;
wire [points_power-1:0]addrb_dmem3;
//reg addr_bit;

wire e_bfly_res_avail_temp;
wire reset_wea_x;
reg reset_wea_x1;
wire reset_wea_x2;
wire reset_wea_x_int; 
wire web_x_pre_reg;
reg [1:0] data_addr_sel;
reg done_int_sclr;
wire addr_sel;
wire [points_power-1:0] wr_addr_int;
wire [points_power-1:0] open_addrb_sms;
wire wea_x_int;
wire wea_x_int2;
wire we_dmem_int;
wire we_dmem_int2;

wire write_to_x;
wire write_to_y;
wire write_to_x1;
wire write_to_y1;

wire sclr_sig_0;
wire sclr_sig_01;
wire clr_sig;
wire clr_sig1;

reg [points_power-1:0] count_31;

reg e_last_bfly_in_rank;
wire e_last_bfly_in_rank3;
wire [4:0] twenty_eight; 
wire e_last_bfly_in_rank_temp;
wire io_temp;
wire io_temp3;
wire eio_pulse;
wire eio_temp;
wire reset_eio;
wire reset_io;
wire eio_reset_temp;
wire eio_reset_temp_x;
wire eio_reset_temp3;
wire io_reset_temp;
wire io_reset_temp3;
wire temp_eio_int;
reg eio_int;
wire eio_int_x;
wire io_pulse_temp;
wire io_pulse_temp3; 
wire address_select_dms;
wire address_select_dms_temp;
wire address_select_dms_temp3;
wire [points_power-1:0] delayed_address;
wire e_bfly_res_avail_flag_dms;
wire e_bfly_res_avail_flag_dms3;
wire reset_io_16_temp;
wire reset_io_16_temp3;
wire reset_io_16;
wire hold_off_we_16;
reg hold_off_we_163;

wire [points_power-1:0] usr_load_addr_tms;
wire [points_power-1:0] delayed_usr_load_addr_tms;



assign wr_addr = wr_addr_int;

//delay_addr_value = get_delay_addr(W_WIDTH);

assign delay_addr = (W_WIDTH == 2) ? 0110 : (2 < W_WIDTH <= 4) ? 0111 : (4 < W_WIDTH <= 8) ? 1000 : (8 < W_WIDTH <= 16) ? 1001 : (16 < W_WIDTH <= 32) ? 1010 : 1010;

vfft32_delay_wrapper_v2_0 # (4, bfly_res_avail_latency, 5)
			
delay_address  (.addr(delay_addr_value),
		.data(address),
		.clk(clk),
		.reset(reset),
		.start(start),
		.delayed_data(wr_addr_int));


vfft32_srflop_v2_0 bfly_res_avail_flag_gen (.clk(clk),
				.ce(ce),
				.set(bfly_res_avail),
				.reset(start),
				.q(bfly_res_avail_flag));

vfft32_srflop_v2_0 e_bfly_res_avail_flag_gen (.clk(clk),
				.ce(ce),
				.set(e_bfly_res_avail),
				.reset(start),
				.q(e_bfly_res_avail_flag));


vfft32_delay_wrapper_v2_0 # (4, bfly_res_avail_latency, 5)
			
delay_usr_ld_addr   (.addr(delay_addr_value),
		.data(usr_load_addr),
		.clk(clk),
		.reset(reset),
		.start(start),
		.delayed_data(delayed_usr_load_addr));


vfft32_delay_wrapper_v2_0 # (4, bfly_res_avail_latency, 1)
			
delayed_ext_to_xbar_y_temp_gen  (.addr(delay_addr_value),
		.data(ext_to_xbar_y_temp),
		.clk(clk),
		.reset(reset),
		.start(start),
		.delayed_data(delayed_ext_to_xbar_y_temp));

//Tripple Memory Space Config Memory Control


assign ena_x = (memory_configuration == 1) ? e_bfly_res_avail_flag : int_ena_x;
assign ena_y = (memory_configuration == 3) ? int_ena_y : 1'b0;

assign temp_int_ena_x = (memory_configuration == 3) ? int_ena_x : (memory_configuration == 2) ? int_ena_x : 1'b0;

assign web_x = (memory_configuration == 3) ? int_web_x : (memory_configuration == 2) ? usr_loading_addr :  (memory_configuration == 1) ?  web_x2 : 1'b0;

assign web_y = (memory_configuration == 3) ? int_web_y : 1'b0;

assign ext_to_xbar_y_temp = (memory_configuration == 3) ? ext_to_xbar_y : 1'b0;
assign ext_to_xbar_y_temp_out = (memory_configuration == 3) ? ext_to_xbar_y_temp : 1'b0;

 C_MUX_BUS_V2_0 #("",
                  1,
                  0,
                  0,
                  0,
                  0,
                  0,
                  1,
                  0,
                  0,
                  0,
                  0,
                  2,
                  0,
                  1,
                  "",
                  0,
                  1,
                  points_power)    
			
mem_or_ext_x     ( .MA (address), 
		   .MB (usr_load_addr), 
		   .MC (dummy_mux_inputs),
		   .MD (dummy_mux_inputs),
		   .ME (dummy_mux_inputs),
		   .MF (dummy_mux_inputs),
		   .MG (dummy_mux_inputs),
	           .MH (dummy_mux_inputs),
		   .S  (int_web_x),
		   .CLK (dummy_in),
		   .CE 	(dummy_in), 		   
                   .EN 	(dummy_in),  
		   .ASET (dummy_in), 
		   .ACLR (dummy_in),
		   .AINIT (dummy_in),		   
                   .SSET (dummy_in), 		   
                   .SCLR (dummy_in),
		   .SINIT (dummy_in),	
		   .O (rd_addrb_x1),
		   .Q (open_q_0_tms));

assign rd_addrb_x = (memory_configuration == 3) ? rd_addrb_x1 : 1'b0;


C_MUX_BUS_V2_0 #("",
                  1,
                  0,
                  0,
                  0,
                  0,
                  0,
                  1,
                  0,
                  0,
                  0,
                  0,
                  2,
                  0,
                  1,
                  "",
                  0,
                  1,
                  points_power) 


mem_or_ext_y     ( .MA (address), 
		   .MB (usr_load_addr), 
		   .MC (dummy_mux_inputs),
		   .MD (dummy_mux_inputs),
		   .ME (dummy_mux_inputs),
		   .MF (dummy_mux_inputs),
		   .MG (dummy_mux_inputs),
	           .MH (dummy_mux_inputs),
		   .S  (int_web_y),
		   .CLK (dummy_in),
		   .CE 	(dummy_in), 		   
                   .EN 	(dummy_in),  
		   .ASET (dummy_in), 
		   .ACLR (dummy_in),
		   .AINIT (dummy_in),		   
                   .SSET (dummy_in), 		   
                   .SCLR (dummy_in),
		   .SINIT (dummy_in),	
		   .O (rd_addrb_y1),
		   .Q (open_q_1_tms));

assign rd_addrb_y = (memory_configuration == 3) ? rd_addrb_y1 : 1'b0;


assign xbar_y = (memory_configuration == 3) ? bank : 1'b0;


vfft32_and_a_notb_v2_0 ena_x_gen   (.a_in(e_bfly_res_avail_flag),
			            .b_in(bank),
			            .and_out(int_ena_x1));


assign int_ena_x = (memory_configuration == 3) ? int_ena_x1 : (memory_configuration == 2) ? e_bfly_res_avail_flag : 1'b0;


vfft32_delay_wrapper_v2_0 # (1, 96, 1)
			
delayed_ext_to_xbar_y_temp_gen1 (.addr(dummy_addr),
		                 .data(temp_int_ena_x),
		                 .clk(clk),
		                 .reset(reset),
		                 .start(start),
		                 .delayed_data(temp_int_ena_y1));

assign temp_int_ena_y = (memory_configuration == 3) ? temp_int_ena_y1 : 1'b0;


vfft32_and_a_b_v2_0 ena_y_gen    (.a_in(temp_int_ena_y),
			          .b_in(bank),
			          .and_out(int_ena_y1));


assign int_ena_y = (memory_configuration == 3) ? int_ena_y1 : 1'b0;

vfft32_flip_flop_ainit_sclr_v2_0 #    (ainit_val)
			   
ext_to_xbar_y_gen         (.d(not_ext_to_xbar_y),
			   .clk(clk),
			   .ce(mwr_or_start_or_count96_tc), 
			   .ainit(reset),
			   .sclr(dummy_in),
			   .q(ext_to_xbar_y1));

assign ext_to_xbar_y = (memory_configuration == 3) ? ext_to_xbar_y1 : 1'b0;



vfft32_nand_a_b_v2_0 not_ext_to_xbar_y_gen (.a_in(ext_to_xbar_y),
				            .b_in(ext_to_xbar_y),
				            .nand_out(not_ext_to_xbar_y1));

assign not_ext_to_xbar_y = (memory_configuration == 3) ? not_ext_to_xbar_y1 : 1'b0;

vfft32_and_a_b_v2_0 web_y_gen      (.a_in(ext_to_xbar_y),
			            .b_in(usr_loading_addr),
			            .and_out(int_web_y1));

assign int_web_y = (memory_configuration == 3) ? int_web_y1 : 1'b0;

vfft32_and_a_notb_v2_0 web_x_gen   (.a_in(usr_loading_addr),
			            .b_in(ext_to_xbar_y),
			            .and_out(int_web_x1)); 

assign int_web_x = (memory_configuration == 3) ? int_web_x1 : (memory_configuration == 2) ? usr_loading_addr : (memory_configuration == 1) ? web_x2 : 1'b0;

assign wea_x = (memory_configuration == 1) ? wea_x_int : int_ena_x;
assign wea_y = (memory_configuration == 3) ? int_ena_y : 1'b0;

always @ (posedge clk)

begin

if (sclr_sig_0)

count96 = 0;

else if (~ce_96)

count96 = 0;

else 

begin

if (memory_configuration == 3)

count96 = count96 + 1;

else count96 = 0;

end

end


vfft32_or_a_b_v2_0 sclr_sig_0_gen   (.a_in(e_bfly_res_avail),
			             .b_in(count95_tc),
			             .or_out(sclr_sig_01));

assign sclr_sig_0 = (memory_configuration == 3) ? sclr_sig_01 : 1'b0;


vfft32_srflop_v2_0 ce_96_gen  (.clk(clk),
		               .ce(ce),
		               .set(e_bfly_res_avail), 
		               .reset(reset),
		               .q(ce_961));

assign ce_96 = (memory_configuration == 3) ? ce_961 : 1'b0;


always @ (count96)

begin

if (memory_configuration == 3)

count96_tc = count96[5] && count96[6];

end

vfft32_or_a_b_c_v2_0 ce_for_ext_toxbary (.a_in(mwr),
			                 .b_in(e_bfly_res_avail), 
			                 .c_in(count95_tc), 
			                 .or_out(mwr_or_start_or_count96_tc1));

assign mwr_or_start_or_count96_tc = (memory_configuration == 3) ? mwr_or_start_or_count96_tc1 : 1'b0;


C_GATE_BIT_V2_0 # (0,
                   0,
                   0,
                   0,
                   0,
                   0,
                   0,
                   1,
                   0,
                   0,
                   0,
                   0,
                   7,
                   "0100000",
                   0,
                   "0",
                   0,
                   1)
      	
  decode_95 (
          	.I(count96),
		.O(count95_tc1),
		.CLK(dummy_in),
		.Q(fake_out),
		.CE(dummy_in), 	
		.AINIT(dummy_in), 
		.ASET(dummy_in), 	
		.ACLR(dummy_in), 	
		.SINIT(dummy_in),
		.SSET(dummy_in),	
		.SCLR(dummy_in)
		);

assign count95_tc = (memory_configuration == 3) ? count95_tc1 : 1'b0;


C_COMPARE_V2_0 # 
(
"",
1,
string_31,
1,
 1,
 0,
 0,
 1,
 0,
 0,
 0,
 0,
 0,
 0,
 0,
 0,
 0,
 0,
 0,
 0,
 0,
 0,
 1,
 0,
 1,
 5)   




		compare_address_31 (.A(address),
				    .B(thirty_one),
				    .CLK(clk),
				    .CE(dummy_in),
				    .ACLR(dummy_in),
				    .ASET(dummy_in),
				    .SCLR(dummy_in), 
				    .SSET(dummy_in),
				    .A_EQ_B(last_bfly_in_rank1),  
				    .A_NE_B(aneb),
				    .A_LT_B(altb),	
				    .A_GT_B(agtb),	
				    .A_LE_B(aleb),	
				    .A_GE_B(ageb),	
				    .QA_EQ_B(qaeqb), 					    
                                    .QA_NE_B(qaneb),	
				    .QA_LT_B(qaltb),	
				    .QA_GT_B(qagtb),	
				    .QA_LE_B(qaleb),	
				    .QA_GE_B(qageb));

assign last_bfly_in_rank = (memory_configuration == 3) ? last_bfly_in_rank1 : 1'b0;

always @ (last_bfly_in_rank or rank_number)

begin

if (memory_configuration == 3)

switch_bank_temp = last_bfly_in_rank && rank_number[1];

end



vfft32_flip_flop_sclr_v2_0 delay_one_switch_bank (.d(switch_bank_temp),
				                  .clk(clk),
				                  .ce(ce),
				                  .sclr(start),
				                  .q(switch_banks1));

assign switch_banks = (memory_configuration == 3) ? switch_banks1: 1'b0;


vfft32_flip_flop_ainit_sclr_v2_0 # (ainit_val_bank)
					
              bank_gen (.d(not_bank),
			.clk(clk),
			.ce(switch_banks),
			.ainit(reset),
			.sclr(start),
			.q(bank1));

assign bank = (memory_configuration == 3) ? bank1: 1'b0;

vfft32_nand_a_b_v2_0 not_bank_gen (.a_in(bank),
			           .b_in(bank),
			           .nand_out(not_bank1));

assign not_bank = (memory_configuration == 3) ? not_bank1 : 1'b0;


vfft32_and_a_notb_v2_0 write_to_x_gen(.a_in(initial_data_load_x), 
			 .b_in(ext_to_xbar_y),
			 .and_out(write_to_x1));

assign write_to_x = (memory_configuration == 3) ? write_to_x1 : 1'b0;

vfft32_or_a_b_v2_0 wex_gen (.a_in(write_to_x),
		.b_in(e_bfly_res_avail_flag),
		.or_out(wex_dmem_tms1)); 

assign wex_dmem_tms = (memory_configuration == 3) ? wex_dmem_tms1 : 1'b0;

assign write_to_y = delayed_ext_to_xbar_y_temp;

vfft32_or_a_b_v2_0 wey_gen (.a_in(write_to_y),
		.b_in(e_bfly_res_avail_flag),
		.or_out(wey_dmem_tms1)); 

assign wey_dmem_tms = (memory_configuration == 3) ? wey_dmem_tms1 : 1'b0;


assign addrb_dmem_tms = (memory_configuration == 3) ? address : 1'b0;
assign usr_loading_addr_temp = usr_loading_addr;
assign address_select_int[1] = (memory_configuration == 3) ? initial_data_load_x : 1'b0;
assign address_select_int[0] = (memory_configuration == 3) ? ext_to_xbar_y_temp : 1'b0; 
assign address_select = (memory_configuration == 3) ? address_select_int : 1'b0;


vfft32_delay_wrapper_v2_0 # (1, 1, points_power)
			
d_usr_load_addr_tms             (.addr(dummy_addr),
		                 .data(usr_load_addr),
		                 .clk(clk),
		                 .reset(reset),
		                 .start(start),
		                 .delayed_data(usr_load_addr_tms));

vfft32_delay_wrapper_v2_0 # (1, 1, points_power)
			
delay_usr_load_addr_tms         (.addr(dummy_addr),
		                 .data(delayed_usr_load_addr),
		                 .clk(clk),
		                 .reset(reset),
		                 .start(start),
		                 .delayed_data(delayed_usr_load_addr_tms));


 C_MUX_BUS_V2_0 #("",
                  1,
                  0,
                  0,
                  0,
                  0,
                  0,
                  1,
                  0,
                  0,
                  0,
                  0,
                  3,
                  0,
                  2,
                  "",
                  0,
                  1,
                  points_power) 
	
wr_or_usr_ld_addr_x ( .MA (delayed_usr_load_addr_tms), 
		      .MB (wr_addr_int), 
		      .MC (usr_load_addr_tms),
		      .MD (dummy_mux_inputs),
		      .ME (dummy_mux_inputs),
		      .MF (dummy_mux_inputs),
		      .MG (dummy_mux_inputs),
	              .MH (dummy_mux_inputs),
		      .S  (address_select_int),
		      .CLK (dummy_in),
		      .CE 	(dummy_in), 		   
                      .EN 	(dummy_in),  
		      .ASET (dummy_in), 
		      .ACLR (dummy_in),
		      .AINIT (dummy_in),		   
                      .SSET (dummy_in), 		   
                      .SCLR (dummy_in),
		      .SINIT (dummy_in),	
		      .O (addra_x_dmem1),
		      .Q (open_q_0_dms));

assign addra_x_dmem = (memory_configuration == 3) ? addra_x_dmem1 : 1'b0;



 C_MUX_BUS_V2_0 #("",
                  1,
                  0,
                  0,
                  0,
                  0,
                  0,
                  1,
                  0,
                  0,
                  0,
                  0,
                  2,
                  0,
                  1,
                  "",
                  0,
                  1,
                  points_power) 
		
wr_or_usr_ld_addr_y ( .MA (wr_addr_int), 
		      .MB (delayed_usr_load_addr), 
		      .MC (usr_load_addr),
		      .MD (dummy_mux_inputs),
		      .ME (dummy_mux_inputs),
		      .MF (dummy_mux_inputs),
		      .MG (dummy_mux_inputs),
	              .MH (dummy_mux_inputs),
		      .S  (ext_to_xbar_y_temp),
		      .CLK (dummy_in),
		      .CE (dummy_in), 		   
                      .EN (dummy_in),  
		      .ASET (dummy_in), 
		      .ACLR (dummy_in),
		      .AINIT (dummy_in),		   
                      .SSET (dummy_in), 		   
                      .SCLR (dummy_in),
		      .SINIT (dummy_in),	
		      .O (addra_y_dmem1),
		      .Q (open_q_0_dms));

assign addra_y_dmem = (memory_configuration == 3) ? addra_y_dmem1 : 1'b0;


//tms ends here!!


//sms begins here


assign reading_result_flag = (memory_configuration == 1) ? reading_result_temp : 1'b0;
assign reading_result = (memory_configuration == 1) ? reading_result_temp : 1'b0;
assign e_bfly_res_avail_temp = (memory_configuration == 1) ? e_bfly_res_avail : 1'b0;
assign reset_wea_x_int = (memory_configuration == 1) ? reset_wea_x1 : 1'b0;
assign writing_result_int_temp = (memory_configuration == 1) ? writing_result_internal : 1'b0;
assign data_sel = (memory_configuration == 1) ? data_addr_sel : 1'b0;



vfft32_flip_flop_sclr_v2_0 wea_x_gen  (.d(logic_1),
			   .clk(clk),
		           .ce(e_bfly_res_avail),
			   .reset(reset),
			   .sclr(reset_wea_x_int),
			   .q(wea_x_int2));

always @ (posedge clk)

begin

if (reset_wea_x == 1)

reset_wea_x1 = 1;

else

reset_wea_x1 = 0;

end

assign wea_x_int = (memory_configuration == 1) ? wea_x_int2 : 1'b0;


vfft32_delay_wrapper_v2_0 # (1, 64, 1)
			
reset_wea_x_gen  (.addr(dummy_addr),
		.data(e_bfly_res_avail_temp),
		.clk(clk),
		.reset(reset),
		.start(start),
		.delayed_data(reset_wea_x2));

assign reset_wea_x = (memory_configuration == 1) ? reset_wea_x2 : 1'b0;

assign writing_result = writing_result_internal;

always @ (posedge clk)

begin

if (e_done_int)

result_wr_addr = 0;

else if (~ce)

result_wr_addr = 0;

else 

begin

if (memory_configuration == 1)

result_wr_addr = result_wr_addr + 1;

end

end


always @ (result_wr_addr)

begin: for_loop

integer addr_bit;

for (addr_bit = points_power-1; addr_bit >= 0; addr_bit = addr_bit-1)

result_wr_addr_scrambled[addr_bit] = result_wr_addr[points_power-1-addr_bit];	

end


vfft32_delay_wrapper_v2_0 # (1, 3, points_power)
			
delay_result_wr_addr_scr  (.addr(dummy_addr),
		.data(result_wr_addr_scrambled),
		.clk(clk),
		.reset(reset),
		.start(start),
		.delayed_data(result_wr_addr_scrambled_delayed2));

assign result_wr_addr_scrambled_delayed = (memory_configuration == 1) ? result_wr_addr_scrambled_delayed2 : 1'b0;


always @ (posedge clk)

begin

if (reset)

result_read_addr = 0;

else if (~ce)

result_read_addr = 0;

else if (mrd == 1)

result_read_addr = 0;

else 

begin

if (memory_configuration == 1)

result_read_addr = result_read_addr + 1;

end

end




//flip_flop_sclr_v reading_result_gen      (.d(logic_1),
//					  .clk(clk),
//					  .ce(mrd_sclr),
//					  .reset(reset),
//					  .sclr(clr_sig), 						 //
 //                                         .q(reading_result_temp));



always @ (posedge clk)

begin

if (mrd == 1)

mrd_sclr = 1;

else

mrd_sclr = 0;

end


always @ (posedge clk)

begin

if (reset)

reading_result_temp = 0;

else if (clr_sig == 1)

reading_result_temp = 0;

else if (mrd == 1)

begin 

if (memory_configuration == 1)

#1 reading_result_temp = 1;

end

end


//assign reading_result_temp = (memory_configuration == 1) ? //reading_result_temp2 : 1'b0;


assign clr_sig = disable_read_enable &&  (!mrd);

always @ (posedge clk)

begin

if (result_read_addr == 31)

#1 disable_read_enable = 1;

else 

disable_read_enable = 0;

end

vfft32_flip_flop_sclr_v2_0 writing_result_gen  (.d(logic_1),
				                .clk(clk),
				                .ce(e_done_int), 					               
                                                .reset(reset),
				                .sclr(done_int_sclr), 
				                .q(writing_result_internal2));

always @ (posedge clk)

begin

if (done_int == 1)

done_int_sclr = 1;

else

done_int_sclr = 0;

end


assign writing_result_internal = (memory_configuration == 1) ? writing_result_internal2 : 1'b0;


vfft32_delay_wrapper_v2_0 # (1, 3, 1)
			
writing_result_delayed_gen  (.addr(dummy_addr),
		             .data(writing_result_int_temp),
		             .clk(clk),
		             .reset(reset),
		             .start(start),
		             .delayed_data(writing_result_int2));

assign writing_result_int = (memory_configuration == 1) ? writing_result_int2 : 1'b0;

vfft32_flip_flop_sclr_v2_0 delay_1_done_int_gen   (.d(done_int),
				                   .clk(clk),
				                   .ce(ce), 						 
                                                   .reset(reset),
				                   .sclr(dummy_in), 
				                   .q(done_int_z2));

assign done_int_z = (memory_configuration == 1) ? done_int_z2 : 1'b0;


vfft32_flip_flop_sclr_v2_0 delay_1_e_done_int_gen  (.d(e_done_int),
				                    .clk(clk),
				                    .ce(ce), 						 
                                                    .reset(reset),
				                    .sclr(dummy_in), 
				                    .q(e_done_int_z2));

assign e_done_int_z = (memory_configuration == 1) ? e_done_int_z2 : 1'b0;

assign e_done_int_z_temp = e_done_int_z;
assign done_int_z_temp = done_int_z;

vfft32_delay_wrapper_v2_0 # (1, 32, 1)
			
delayed_e_done_int_z_gen   ( .addr(dummy_addr),
		             .data(e_done_int_z_temp),
		             .clk(clk),
		             .reset(reset),
		             .start(start),
		             .delayed_data(e_done_int_z_322));

assign e_done_int_z_32 = (memory_configuration == 1) ? e_done_int_z_322 : 1'b0;


vfft32_delay_wrapper_v2_0 # (1, 32, 1)
			
delayed_done_int_z_gen     (.addr(dummy_addr),
		            .data(done_int_z_temp),
		            .clk(clk),
		            .reset(reset),
		            .start(start),
		            .delayed_data(done_int_z_322));

assign done_int_z_32 = (memory_configuration == 1) ? done_int_z_322 : 1'b0;

vfft32_flip_flop_sclr_v2_0 e_writing_result_int_gen  (.d(logic_1),
				        .clk(clk),
				        .ce(e_done_int), 						 
                                        .reset(reset),
				        .sclr(done_int), 
				        .q(e_writing_result_int2));

assign e_writing_result_int = (memory_configuration == 1) ? e_writing_result_int2 : 1'b0;

assign bfly_or_rd_wr_result_sel[1] = reading_result_temp;
assign bfly_or_rd_wr_result_sel[0] = writing_result_internal; 


vfft32_or_a_b_v2_0	web_gen_temp   (.a_in(usr_loading_addr),
			.b_in(writing_result_int), //check simulation
			.or_out(web_x_temp2));

assign web_x_temp = (memory_configuration == 1) ? web_x_temp2 : 1'b0;

vfft32_and_a_notb_v2_0 web_gen    (.a_in(web_x_temp),
		       .b_in(reading_result_temp),
		       .and_out(web_x2)); 

//assign web_x = (memory_configuration == 1) ? web_x2 : 1'b0;

always @ (usr_loading_addr)

begin

if (memory_configuration == 1)

data_addr_sel[0] = usr_loading_addr;
 
end
                                    
always @ (writing_result_int or reading_result_temp)

begin

data_addr_sel[1] = writing_result_int && (!reading_result_temp);

end


assign addr_sel = reading_result_temp;

C_MUX_BUS_V2_0 #("",
                  1,
                  0,
                  0,
                  0,
                  0,
                  0,
                  1,
                  0,
                  0,
                  0,
                  0,
                  3,
                  0,
                  2,
                  "",
                  0,
                  1,
                  points_power)			

mux_wr_usr_ld_wr_sc ( .MA (wr_addr_int), 
		      .MB (usr_load_addr), 
		      .MC (result_wr_addr_scrambled_delayed),
		      .MD (dummy_mux_inputs),
		      .ME (dummy_mux_inputs),
		      .MF (dummy_mux_inputs),
		      .MG (dummy_mux_inputs),
	              .MH (dummy_mux_inputs),
		      .S  (data_addr_sel),
		      .CLK (dummy_in),
		      .CE (dummy_in), 		   
                      .EN (dummy_in),  
		      .ASET (dummy_in), 
		      .ACLR (dummy_in),
		      .AINIT (dummy_in),		   
                      .SSET (dummy_in), 		   
                      .SCLR (dummy_in),
		      .SINIT (dummy_in),	
		      .O (addra_dmem2),
		      .Q (open_mux_ad));

assign addra_dmem = (memory_configuration == 1) ? addra_dmem2 : (memory_configuration == 2) ? addra_dmem3 : 1'b0;



 C_MUX_BUS_V2_0 #("",
                  1,
                  0,
                  0,
                  0,
                  0,
                  0,
                  1,
                  0,
                  0,
                  0,
                  0,
                  2,
                  0,
                  1,
                  "",
                  0,
                  1,
                  points_power)					

mux_addr_rd_addr_uns ( .MA (address), 
		      .MB (result_read_addr), 
		      .MC (dummy_mux_inputs),
		      .MD (dummy_mux_inputs),
		      .ME (dummy_mux_inputs),
		      .MF (dummy_mux_inputs),
		      .MG (dummy_mux_inputs),
	              .MH (dummy_mux_inputs),
		      .S  (addr_sel),
		      .CLK (dummy_in),
		      .CE (dummy_in), 		   
                      .EN (dummy_in),  
		      .ASET (dummy_in), 
		      .ACLR (dummy_in),
		      .AINIT (dummy_in),		   
                      .SSET (dummy_in), 		   
                      .SCLR (dummy_in),
		      .SINIT (dummy_in),	
		      .O (addrb_dmem2),
		      .Q (open_addrb_sms));

assign addrb_dmem = (memory_configuration == 1) ? addrb_dmem2 : (memory_configuration == 2) ? addrb_dmem3 : 1'b0;

vfft32_or_a_b_c_v2_0 we_dmem_int_gen      (.a_in(wea_x_int),
			       .b_in(usr_loading_addr),
                               .c_in(writing_result_int),
			       .or_out(we_dmem_int2));

assign we_dmem_int = (memory_configuration == 1) ? we_dmem_int2 : 1'b0;


vfft32_and_a_notb_v2_0 we_dmem_gen      (.a_in(we_dmem_int),
			     .b_in(reading_result_temp),
			     .and_out(we_dmem2));

assign we_dmem = (memory_configuration == 1) ? we_dmem2 : 1'b0;


// sms mode ends here!!




//dms mode begins here!

 
C_MUX_BUS_V2_0 #("",
                  1,
                  0,
                  0,
                  0,
                  0,
                  0,
                  1,
                  0,
                  0,
                  0,
                  0,
                  2,
                  0,
                  1,
                  "",
                  0,
                  1,
                  points_power)					

wr_or_usr_ld_addr   ( .MA (wr_addr_int), 
		      .MB (usr_load_addr), 
		      .MC (dummy_mux_inputs),
		      .MD (dummy_mux_inputs),
		      .ME (dummy_mux_inputs),
		      .MF (dummy_mux_inputs),
		      .MG (dummy_mux_inputs),
	              .MH (dummy_mux_inputs),
		      .S  (usr_loading_addr_temp),
		      .CLK (dummy_in),
		      .CE (dummy_in), 		   
                      .EN (dummy_in),  
		      .ASET (dummy_in), 
		      .ACLR (dummy_in),
		      .AINIT (dummy_in),		   
                      .SSET (dummy_in), 		   
                      .SCLR (dummy_in),
		      .SINIT (dummy_in),	
		      .O (addra_dmem3),
		      .Q (open_q_0_dms));


//srflop hold_off_we_16_gen      (.clk(clk),
//				.ce(ce),
//				.set(reset_io),
//				.reset(reset_io_16),
//				.q(hold_off_we_163));
//

always @ (posedge clk)

begin

if (reset)

hold_off_we_163 = 0;

else if (~ce)

hold_off_we_163 = 0;

else if (reset_io_16)

hold_off_we_163 = 0;

else if (reset_io)

hold_off_we_163 = 1;

end

assign hold_off_we_16 = (memory_configuration == 2) ? hold_off_we_163 : 1'b0;

vfft32_delay_wrapper_v2_0 #  (1, 14, 1)				


reset_io_16_gen (.addr(dummy_addr),
		 .data(io_reset_temp),
		 .clk(clk),
		 .reset(reset),
		 .start(io_pulse_temp),
		 .delayed_data(reset_io_16_temp3));

assign reset_io_16_temp = (memory_configuration == 2) ? reset_io_16_temp3 : 1'b0;


assign reset_io_16 = reset_io_16_temp;


vfft32_and_a_notb_v2_0  we_dmem_and   (.a_in(e_bfly_res_avail_flag),
			   .b_in(hold_off_we_16),
			   .and_out(e_bfly_res_avail_flag_dms3));

assign e_bfly_res_avail_flag_dms = (memory_configuration == 2) ? e_bfly_res_avail_flag_dms3 : 1'b0;

vfft32_or_a_b_v2_0 we_dmem_dms_gen  (.a_in(usr_loading_addr),
			 .b_in(e_bfly_res_avail_flag_dms), 						 
                        .or_out(we_dmem_dms3));

assign we_dmem_dms = (memory_configuration == 2) ? we_dmem_dms3 : 1'b0;


assign addrb_dmem_dms = (memory_configuration == 2) ? address : 1'b0;


always @ (posedge clk)

begin

if (reset)

count_31 = 0;

else if (~ce)

count_31 = 0;

else if (start)

count_31 = 0;

else if (memory_configuration == 2)

count_31 = count_31 + 1;

end


always @ (posedge clk)

begin

if (count_31 == 31)

#4 e_last_bfly_in_rank = 1;

else

#3 e_last_bfly_in_rank = 0;

end

		
assign e_last_bfly_in_rank_temp = e_last_bfly_in_rank;
assign io = io_temp;
assign eio_temp = eio_pulse;
assign eio_pulse_out = eio_pulse;
assign reset_eio = eio_reset_temp;
assign reset_io = io_reset_temp;
assign reset_io_out = reset_io;

assign eio = eio_int;
assign temp_eio_int = eio_int;

always @ (posedge clk)

begin

if (reset)

count_rank_number = 0;

else if (~ce)

count_rank_number = 0;

else if (start)

count_rank_number = 0;

else if (mrd)

count_rank_number = 0;

else if (e_last_bfly_in_rank == 1)

count_rank_number = count_rank_number + 1;
 
end


always @ (posedge clk)

begin

if (count_rank_number == 1)

#2 c_rank_number = 1;

else if (count_rank_number == 2)

#2 c_rank_number = 2;

else

#2 c_rank_number = 0;

end



assign #1 eio_pulse = (memory_configuration == 2) ? ((e_last_bfly_in_rank == 1) ? (c_rank_number[1] == 1) ? 1 : 0 : 0) : 0;


always @ (posedge clk)

begin

if (reset)

eio_int = 0;

else if (reset_eio)

#1 eio_int = 0;

else if (memory_configuration == 2)

begin

if (eio_pulse)

#1 eio_int = 1;

end

end


vfft32_delay_wrapper_v2_0  # (1, 32, 1) 				


eio_flag_reset_gen (.addr(dummy_addr),
		    .data(eio_temp),
		    .clk(clk),
		    .reset(reset),
		    .start(start),
		    .delayed_data(eio_reset_temp3));

assign eio_reset_temp_x = (memory_configuration == 2) ? eio_reset_temp3 : 1'b0;

assign eio_reset_temp = (eio_reset_temp_x == 1'b1) ? 1'b1 : 1'b0;


vfft32_delay_wrapper_v2_0  # (1, 2, 1) 				


io_gen             (.addr(dummy_addr),
		    .data(temp_eio_int),
		    .clk(clk),
		    .reset(reset),
		    .start(start),
		    .delayed_data(io_temp3));

assign io_temp = (memory_configuration == 2) ? io_temp3 : 1'b0;


vfft32_delay_wrapper_v2_0  # (1, 2, 1) 				


io_pulse_gen       (.addr(dummy_addr),
		    .data(eio_temp),
		    .clk(clk),
		    .reset(reset),
		    .start(start),
		    .delayed_data(io_pulse_temp3));

assign io_pulse_temp = (memory_configuration == 2) ? io_pulse_temp3 : 1'b0;


assign io_pulse = io_pulse_temp;


vfft32_delay_wrapper_v2_0  # (1, 2, 1) 				


io_reset_gen       (.addr(dummy_addr),
		    .data(eio_reset_temp),
		    .clk(clk),
		    .reset(reset),
		    .start(start),
		    .delayed_data(io_reset_temp3));

assign io_reset_temp = (memory_configuration == 2) ? io_reset_temp3 : 1'b0;


vfft32_srflop_v2_0 set_delayed_addr        (.clk(clk),
				.ce(ce),
				.set(reset_eio),
				.reset(start),  
				.q(address_select_dms_temp3));

assign address_select_dms_temp = (memory_configuration == 2) ? address_select_dms_temp3 : 1'b0;


assign address_select_dms = address_select_dms_temp;
assign address_select_dms_out = address_select_dms;

endmodule

//******************************************************************************

//******************************************************************************

module vfft32_working_memory_v2_0  (clk, reset, start, xbar_y, ext_to_xbar_y_temp_out, dia_r,	dia_i,	ena_x, wea_x, wex_dmem_tms, wey_dmem_tms, addra, addra_dmem,			addra_x_dmem, addra_y_dmem, xn_re, ,xn_im, web_x, we_dmem_dms, usr_loading_addr, 		d_a_dmem_dms_sel, address_select_dms, addrb_dmem_dms, addrb_dmem_tms,	address_select,	ena_y, wea_y, web_y, mem_outr,  mem_outi);

parameter B = 12;
parameter POINTS_POWER = 5;
parameter memory_architecture = 3;
parameter data_memory =  ""; 

input clk;
input reset;
input start;
input xbar_y;
input [0:0]ext_to_xbar_y_temp_out;
input [B-1:0] dia_r;
input [B-1:0] dia_i;
input ena_x;
input wea_x;
input wex_dmem_tms;
input ena_y;
input wea_y;
input wey_dmem_tms;
input [POINTS_POWER-1:0] addra;
input [POINTS_POWER-1:0] addra_dmem;
input [POINTS_POWER-1:0] addrb_dmem_dms;
input [POINTS_POWER-1:0] addrb_dmem_tms;
input [POINTS_POWER-1:0] addra_x_dmem;
input [POINTS_POWER-1:0] addra_y_dmem;
input [B-1:0] xn_re;
input [B-1:0] xn_im;
input web_x;
input web_y;
input we_dmem_dms;
input usr_loading_addr;
input d_a_dmem_dms_sel;
input [0:0]address_select_dms;
input [1:0] address_select;
output [B-1:0] mem_outr;
output [B-1:0] mem_outi;

wire [B-1:0] mem_outr_a;
wire [B-1:0] mem_outi_a;
wire [B-1:0] mem_outr_b;
wire [B-1:0] mem_outi_b;
wire [B-1:0] mem_outr1;
wire [B-1:0] mem_outi1;
wire [B-1:0] mem_outr_dms;
wire [B-1:0] mem_outi_dms;
wire [B-1:0] mem_outr_tms;
wire [B-1:0] mem_outi_tms;
reg [B-1:0] mem_outr_out;
reg [B-1:0] mem_outi_out;
 

parameter bfly_res_avail_latency = 16;

wire dummy_in = 1'b0;
wire [B-1:0] dummy_mux_inputs_1;
assign  dummy_mux_inputs_1 = 1'b0;

wire [B-1:0]open_q_2;
wire [B-1:0]open_q_3;
wire [B-1:0]open_q_re;
wire [B-1:0]open_q_im;

wire logic_1 = 1'b1;
wire logic_0 = 1'b0;

wire [B-1:0]x_to_bfly_r;
wire [B-1:0]x_to_bfly_i;
wire [B-1:0]y_to_bfly_r;
wire [B-1:0]y_to_bfly_i;

wire [B-1:0]x_to_bfly_r_a;
wire [B-1:0]x_to_bfly_i_a;
wire [B-1:0]y_to_bfly_r_a;
wire [B-1:0]y_to_bfly_i_a;

wire [B-1:0]x_to_bfly_r_b;
wire [B-1:0]x_to_bfly_i_b;
wire [B-1:0]y_to_bfly_r_b;
wire [B-1:0]y_to_bfly_i_b;

wire [B-1:0]x_to_bfly_r1;
wire [B-1:0]x_to_bfly_i1;
wire [B-1:0]y_to_bfly_r1;
wire [B-1:0]y_to_bfly_i1;

wire xbar_y_temp;

wire d_a_dmem_dms_sel_temp;
wire [B-1:0]dib_r;
wire [B-1:0]dib_i;
wire [B-1:0]d_re;
wire [B-1:0]d_im;
wire [B-1:0]d_re1;
wire [B-1:0]d_im1;

wire [B-1:0]open_dib_r;
wire [B-1:0]open_dib_i;

wire [B-1:0]delayed_xn_re;
wire [B-1:0]delayed_xn_im;
wire [B-1:0]delayed_xn_re1;
wire [B-1:0]delayed_xn_im1;

wire [B-1:0]d_re_x;
wire [B-1:0]d_im_x;
wire [B-1:0]d_re_y;
wire [B-1:0]d_im_y;
wire [B-1:0]d_re_x1;
wire [B-1:0]d_im_x1;
wire [B-1:0]d_re_y1;
wire [B-1:0]d_im_y1;


wire dummy_addr;
reg not_ext_to_xbar_y_temp_out;
wire usr_loading_addr_temp;

assign d_a_dmem_dms_sel_temp = d_a_dmem_dms_sel;

assign dib_r = xn_re;
assign dib_i = xn_im;


//tms mode

always @ (ext_to_xbar_y_temp_out)

begin

if (memory_architecture == 3)

not_ext_to_xbar_y_temp_out =  !(ext_to_xbar_y_temp_out);

end

assign xbar_y_temp = (memory_architecture == 3) ? xbar_y : 0;

vfft32_delay_wrapper_v2_0 # (1, bfly_res_avail_latency, B)


			delay_xn_re   (.addr(dummy_addr),
					.data(xn_re),
					.clk(clk),
					.reset(reset),
					.start(start),
					.delayed_data(delayed_xn_re));

//assign delayed_xn_re = (memory_architecture == 3) ? delayed_xn_re1 : 1'b0;

vfft32_delay_wrapper_v2_0 # (1, bfly_res_avail_latency, B)


			delay_xn_im   (.addr(dummy_addr),
					.data(xn_im),
					.clk(clk),
					.reset(reset),
					.start(start),
					.delayed_data(delayed_xn_im));

//assign delayed_xn_im = (memory_architecture == 3) ? delayed_xn_im1 : 1'b0;


C_MUX_BUS_V2_0 #   

("",                             
1,
0,
0,
0,
0,
0,
1,
0,
0,
0,
0,
3,
0, // c_lut_based
2,
"",
0,
1,
B)
			

xn_or_dia_r_x                          (.MA(delayed_xn_re), 
					.MB(dia_r),
					.MC(xn_re), 
					.MD(dummy_mux_inputs_1),
					.ME(dummy_mux_inputs_1),
					.MF(dummy_mux_inputs_1),
					.MG(dummy_mux_inputs_1),
					.MH(dummy_mux_inputs_1),
					.S(address_select),
		  			.CLK(dummy_in), 
		  			.CE(dummy_in),  
		 			.EN(dummy_in),  
		  			.ASET(dummy_in),  
		  			.ACLR(dummy_in),
		  			.AINIT(dummy_in),  
		  			.SSET(dummy_in),  
		  			.SCLR(dummy_in), 
		  			.SINIT(dummy_in),	
					.O(d_re_x),
					.Q(open_q_re));


//assign d_re_x = (memory_architecture == 3) ? d_re_x1 : 1'b0;

C_MUX_BUS_V2_0 #   

("",                             
1,
0,
0,
0,
0,
0,
1,
0,
0,
0,
0,
3,
0, // c_lut_based
2,
"",
0,
1,
B)
		
xn_or_dia_i_x                          (.MA(delayed_xn_im), 
					.MB(dia_i),
					.MC(xn_im), 
					.MD(dummy_mux_inputs_1),
					.ME(dummy_mux_inputs_1),
					.MF(dummy_mux_inputs_1),
					.MG(dummy_mux_inputs_1),
					.MH(dummy_mux_inputs_1),
					.S(address_select),
		  			.CLK(dummy_in), 
		  			.CE(dummy_in),  
		 			.EN(dummy_in),  
		  			.ASET(dummy_in),  
		  			.ACLR(dummy_in),
		  			.AINIT(dummy_in),  
		  			.SSET(dummy_in),  
		  			.SCLR(dummy_in), 
		  			.SINIT(dummy_in),	
					.O(d_im_x),
					.Q(open_q_im));

//assign d_im_x = (memory_architecture == 3) ? d_im_x1 : 1'b0;



C_MUX_BUS_V2_0 #   

("",                             
1,
0,
0,
0,
0,
0,
1,
0,
0,
0,
0,
2,
0, // c_lut_based
1,
"",
0,
1,
B)
		
xn_or_dia_i_y                          (.MA(dia_i), 
					.MB(delayed_xn_im),
					.MC(dummy_mux_inputs_1), 
					.MD(dummy_mux_inputs_1),
					.ME(dummy_mux_inputs_1),
					.MF(dummy_mux_inputs_1),
					.MG(dummy_mux_inputs_1),
					.MH(dummy_mux_inputs_1),
					.S(ext_to_xbar_y_temp_out),
		  			.CLK(dummy_in), 
		  			.CE(dummy_in),  
		 			.EN(dummy_in),  
		  			.ASET(dummy_in),  
		  			.ACLR(dummy_in),
		  			.AINIT(dummy_in),  
		  			.SSET(dummy_in),  
		  			.SCLR(dummy_in), 
		  			.SINIT(dummy_in),	
					.O(d_im_y),
					.Q(open_q_im));


//assign d_im_y = (memory_architecture == 3) ? d_im_y1 : 1'b0;


C_MUX_BUS_V2_0 #   

("",                             
1,
0,
0,
0,
0,
0,
1,
0,
0,
0,
0,
2,
0, // c_lut_based
1,
"",
0,
1,
B)
			
xn_or_dia_r_y                          (.MA(dia_r), 
					.MB(delayed_xn_re),
					.MC(dummy_mux_inputs_1), 
					.MD(dummy_mux_inputs_1),
					.ME(dummy_mux_inputs_1),
					.MF(dummy_mux_inputs_1),
					.MG(dummy_mux_inputs_1),
					.MH(dummy_mux_inputs_1),
					.S(ext_to_xbar_y_temp_out),
		  			.CLK(dummy_in), 
		  			.CE(dummy_in),  
		 			.EN(dummy_in),  
		  			.ASET(dummy_in),  
		  			.ACLR(dummy_in),
		  			.AINIT(dummy_in),  
		  			.SSET(dummy_in),  
		  			.SCLR(dummy_in), 
		  			.SINIT(dummy_in),	
					.O(d_re_y),
					.Q(open_q_re));

//assign d_re_y = (memory_architecture == 3) ? d_re_y1 : 1'b0;


//data_memory="block_mem"

vfft32_mem_wkg_r_i_v2_0 # (B, POINTS_POWER)

mem_x_re_imag (.addra(addra_x_dmem), 
		 .wea(wex_dmem_tms), 
		 .ena(logic_1), 
		 .dia_r(d_re_x), 
		 .dia_i(d_im_x), 
		 .reset(reset),
		 .clk(clk),
		 .addrb(addrb_dmem_tms), 
		 .web(logic_0), 
		 .enb(logic_1),
		 .dib_r(open_dib_r),
		 .dib_i(open_dib_i), 
		 .dob_r(x_to_bfly_r_a),
		 .dob_i(x_to_bfly_i_a));



vfft32_mem_wkg_r_i_v2_0 # (B, POINTS_POWER)
	
mem_y_re_imag (	.addra(addra_y_dmem), 
		.wea(wey_dmem_tms), 
		.ena(logic_1), 
		.dia_r(d_re_y), 
		.dia_i(d_im_y), 
		.reset(reset),
		.clk(clk),
		.addrb(addrb_dmem_tms), 
		.web(logic_0), 
		.enb(logic_1),
		.dib_r(open_dib_r),
		.dib_i(open_dib_i), 
		.dob_r(y_to_bfly_r_a),
		.dob_i(y_to_bfly_i_a));



vfft32_dmem_wkg_r_i_v2_0 # (B, POINTS_POWER)

dmem_x_re_imag (.a(addra_x_dmem),
		.we(wex_dmem_tms),
		.d_re(d_re_x),
		.d_im(d_im_x),
		.clk(clk),
		.dpra(addrb_dmem_tms),
		.qdpo_re(x_to_bfly_r_b),
		.qdpo_im(x_to_bfly_i_b));

vfft32_dmem_wkg_r_i_v2_0 # (B, POINTS_POWER)

dmem_y_re_imag (.a(addra_y_dmem),
		.we(wey_dmem_tms),
		.d_re(d_re_y),
		.d_im(d_im_y),
		.clk(clk),
		.dpra(addrb_dmem_tms),
		.qdpo_re(y_to_bfly_r_b),
		.qdpo_im(y_to_bfly_i_b));


assign x_to_bfly_r = (memory_architecture == 3) ? ((data_memory == "distributed_mem") ? x_to_bfly_r_b : ((data_memory == "block_mem") ? x_to_bfly_r_a : 1'b0)) : (1'b0);

assign x_to_bfly_i = (memory_architecture == 3) ? ((data_memory == "distributed_mem") ? x_to_bfly_i_b : ((data_memory == "block_mem") ? x_to_bfly_i_a : 1'b0)) : (1'b0);


assign y_to_bfly_r = (memory_architecture == 3) ? ((data_memory == "distributed_mem") ? y_to_bfly_r_b : ((data_memory == "block_mem") ? y_to_bfly_r_a : 1'b0)) : (1'b0);

assign y_to_bfly_i = (memory_architecture == 3) ? ((data_memory == "distributed_mem") ? y_to_bfly_i_b : ((data_memory == "block_mem") ? y_to_bfly_i_a : 1'b0)) : (1'b0);


C_MUX_BUS_V2_0 #   

("",                             
1,
0,
0,
0,
0,
0,
1,
0,
0,
0,
0,
2,
0, // c_lut_based
1,
"",
0,
1,
B)
		

x_or_y_to_bfly_r                       (.MA(x_to_bfly_r), 
					.MB(y_to_bfly_r),
					.MC(dummy_mux_inputs_1), 
					.MD(dummy_mux_inputs_1),
					.ME(dummy_mux_inputs_1),
					.MF(dummy_mux_inputs_1),
					.MG(dummy_mux_inputs_1),
					.MH(dummy_mux_inputs_1),
					.S(xbar_y_temp),
		  			.CLK(dummy_in), 
		  			.CE(dummy_in),  
		 			.EN(dummy_in),  
		  			.ASET(dummy_in),  
		  			.ACLR(dummy_in),
		  			.AINIT(dummy_in),  
		  			.SSET(dummy_in),  
		  			.SCLR(dummy_in), 
		  			.SINIT(dummy_in),	
					.O(mem_outr_tms),
					.Q(open_q_2));


C_MUX_BUS_V2_0 #   

("",                             
1,
0,
0,
0,
0,
0,
1,
0,
0,
0,
0,
2,
0, // c_lut_based
1,
"",
0,
1,
B)
			

x_or_y_to_bfly_i	               (.MA(x_to_bfly_i), 
					.MB(y_to_bfly_i),
					.MC(dummy_mux_inputs_1), 
					.MD(dummy_mux_inputs_1),
					.ME(dummy_mux_inputs_1),
					.MF(dummy_mux_inputs_1),
					.MG(dummy_mux_inputs_1),
					.MH(dummy_mux_inputs_1),
					.S(xbar_y_temp),
		  			.CLK(dummy_in), 
		  			.CE(dummy_in),  
		 			.EN(dummy_in),  
		  			.ASET(dummy_in),  
		  			.ACLR(dummy_in),
		  			.AINIT(dummy_in),  
		  			.SSET(dummy_in),  
		  			.SCLR(dummy_in), 
		  			.SINIT(dummy_in),	
					.O(mem_outi_tms),
					.Q(open_q_3));


//END GENERATE tms_wkg_mem_gen;

//dms_wkg_mem_gen: IF (memory_architecture = 2) GENERATE


assign usr_loading_addr_temp = usr_loading_addr;

C_MUX_BUS_V2_0 #   

("",                             
1,
0,
0,
0,
0,
0,
1,
0,
0,
0,
0,
2,
0, // c_lut_based
1,
"",
0,
1,
B)
		
		xn_or_dia_r            (.MA(dia_r), 
					.MB(xn_re),
					.MC(dummy_mux_inputs_1), 
					.MD(dummy_mux_inputs_1),
					.ME(dummy_mux_inputs_1),
					.MF(dummy_mux_inputs_1),
					.MG(dummy_mux_inputs_1),
					.MH(dummy_mux_inputs_1),
					.S(usr_loading_addr_temp),
		  			.CLK(dummy_in), 
		  			.CE(dummy_in),  
		 			.EN(dummy_in),  
		  			.ASET(dummy_in),  
		  			.ACLR(dummy_in),
		  			.AINIT(dummy_in),  
		  			.SSET(dummy_in),  
		  			.SCLR(dummy_in), 
		  			.SINIT(dummy_in),	
					.O(d_re1),
					.Q(open_q_re));

assign d_re = (memory_architecture == 2) ? d_re1 : 1'b0;


C_MUX_BUS_V2_0 #   

("",                             
1,
0,
0,
0,
0,
0,
1,
0,
0,
0,
0,
2,
0, // c_lut_based
1,
"",
0,
1,
B)
		xn_or_dia_i	       (.MA(dia_i), 
					.MB(xn_im),
					.MC(dummy_mux_inputs_1), 
					.MD(dummy_mux_inputs_1),
					.ME(dummy_mux_inputs_1),
					.MF(dummy_mux_inputs_1),
					.MG(dummy_mux_inputs_1),
					.MH(dummy_mux_inputs_1),
					.S(usr_loading_addr_temp),
		  			.CLK(dummy_in), 
		  			.CE(dummy_in),  
		 			.EN(dummy_in),  
		  			.ASET(dummy_in),  
		  			.ACLR(dummy_in),
		  			.AINIT(dummy_in),  
		  			.SSET(dummy_in),  
		  			.SCLR(dummy_in), 
		  			.SINIT(dummy_in),	
					.O(d_im1),
					.Q(open_q_im));

assign d_im = (memory_architecture == 2) ? d_im1 : 1'b0;


//dmem_gen: IF (data_memory="distributed_mem") GENERATE

vfft32_dmem_wkg_r_i_v2_0 # (B, POINTS_POWER)

dmem_x_re_imag_2 (.a(addra_dmem),
		.we(we_dmem_dms),
		.d_re(d_re),
		.d_im(d_im),
		.clk(clk),
		.dpra(addrb_dmem_dms),
		.qdpo_re(mem_outr_a),
		.qdpo_im(mem_outi_a));

assign mem_outr_dms = (memory_architecture == 2) ? ((data_memory == "distributed_mem") ? mem_outr_a : ((data_memory == "block_mem") ? mem_outr_b : 1'b0)) : (1'b0);

assign mem_outi_dms = (memory_architecture == 2) ? ((data_memory == "distributed_mem") ? mem_outi_a : ((data_memory == "block_mem") ? mem_outi_b : 1'b0)) : (1'b0);


always @ (mem_outr_dms or mem_outr_tms or mem_outi_dms or mem_outi_tms)

begin

if (memory_architecture == 2)

begin

mem_outr_out = mem_outr_dms;
mem_outi_out = mem_outi_dms;

end

else if (memory_architecture == 3)

begin

mem_outr_out = mem_outr_tms;
mem_outi_out = mem_outi_tms;

end

end

//bmem_gen: IF (data_memory="block_mem") GENERATE

vfft32_mem_wkg_r_i_v2_0 # (B, POINTS_POWER)

mem_x_re_imag_2 (.addra(addra_dmem), 
		 .wea(we_dmem_dms), 
		 .ena(logic_1), 
		 .dia_r(d_re), 
		 .dia_i(d_im), 
		 .reset(reset),
		 .clk(clk),
		 .addrb(addrb_dmem_dms), 
		 .web(logic_0), 
		 .enb(logic_1),
		 .dib_r(open_dib_r), 
		 .dib_i(open_dib_i), 
		 .dob_r(mem_outr_b), 
		 .dob_i(mem_outi_b)); 


assign mem_outr = mem_outr_out;
assign mem_outi = mem_outi_out;


endmodule

//******************************************************************************

//******************************************************************************

//******************************************************************************

//******************************************************************************


module vfft32_input_working_result_memory_v2_0 (clk, ce, reset, fwd_inv, y0r, y0i, y1r, y1i, y2r, y2i, y3r, y3i, dia_r, dia_i, xn_re, xn_im, ena, wea, addra, addra_dmem, xn_r, xn_i, data_sel, we_dmem, web, addrb, addrb_dmem, result_avail, reading_result, writing_result, mem_outr, mem_outi, xk_result_out_re, xk_result_out_im);


parameter result_width = 5;
parameter points_power = 5;
parameter B = 12;
parameter data_memory = ""; 

input clk;
input ce;
input reset;
input fwd_inv;
input [B-1:0] y0r;
input [B-1:0] y0i;
input [B-1:0] y1r;
input [B-1:0] y1i;
input [B-1:0] y2r;
input [B-1:0] y2i;
input [B-1:0] y3r;
input [B-1:0] y3i;
input [B-1:0] dia_r;
input [B-1:0] dia_i;
input [B-1:0] xn_re;
input [B-1:0] xn_im;
input ena;
input wea;
input [points_power-1:0] addra;
input [points_power-1:0] addra_dmem;
input [B-1:0] xn_r;
input [B-1:0] xn_i;
input [1:0] data_sel;
input we_dmem;
input web;
input [points_power-1:0] addrb;
input [points_power-1:0] addrb_dmem;
input result_avail;
input reading_result;
input writing_result;

output [B-1:0] mem_outr;
output [B-1:0] mem_outi;

output [B-1:0] xk_result_out_re;
output [B-1:0] xk_result_out_im;

parameter zero_data = 1'b0;
parameter default_data = {result_width{zero_data}};
parameter one_string = 2'b1;
parameter three	= 2'b11;
parameter ainit_val = 2'b0;
parameter sinit_val = 2'b0;
parameter ainit_val_ascii = 8'b00110000;
parameter sinit_val_ascii = 8'b00110000;


//parameter one_string_1 = 5'b1;
//parameter thirty_one = 5'b11111;
//parameter ainit_val_1 = 5'b0;
//parameter sinit_val_1 = 5'b0;

wire [B-1:0] dummy_mux_inputs;
wire [B-1:0] open_qr;
wire [B-1:0] open_qi;
wire [B-1:0] open_q_r;
wire [B-1:0] open_q_i;

wire [B-1:0] dib_r;
wire [B-1:0] dib_i;
wire logic_1 = 1'b1;
wire logic_0 = 1'b0;
wire dummy_in = 1'b0;

wire writing_result_temp;

wire [B-1:0] mem_outr_int;
wire [B-1:0] mem_outi_int;
wire [B-1:0] mem_outr_int_b;
wire [B-1:0] mem_outi_int_b;
wire [B-1:0] mem_outr_int_d;
wire [B-1:0] mem_outi_int_d;

wire [B-1:0] y0r_delayed;
wire [B-1:0] y0i_delayed;
wire [B-1:0] y1r_delayed;
wire [B-1:0] y1i_delayed;
wire [B-1:0] y2r_delayed;
wire [B-1:0] y2i_delayed;
wire [B-1:0] y3r_delayed;
wire [B-1:0] y3i_delayed;

wire writing_result_delayed_internal;
wire result_avail_delayed_internal;

wire writing_result_internal;
wire result_avail_internal;

wire writing_result_delayed_int;
wire result_avail_delayed_int;
wire result_avail_delayed;

wire dummy_addr;  

wire [result_width-1:0] fft4_result_re;
wire [result_width-1:0] fft4_result_im;

wire [result_width-1:0] fft4_result_re_preconj;
wire [result_width-1:0] fft4_result_im_preconj;

wire open_thresh0;
wire open_q_thresh0;
wire open_thresh1;
wire open_q_thresh1;

reg [1:0] d_select;
wire open_q_r_1;
wire open_q_i_1;

wire [points_power-1:0] one_1 = 1;
wire [points_power-1:0] zero_1 = 0;
wire [1:0] zero = 2'b0;
wire [1:0] one = 2'b1;

wire [B-1:0] fft4_result_re_z;
wire [B-1:0] fft4_result_im_z;

wire [B-1:0] xk_result_out_re_temp;
wire [B-1:0] xk_result_out_im_temp;

wire [B-1:0] d_re;
wire [B-1:0] d_im;

wire [result_width-1:0] open_mux_qr;
wire [result_width-1:0] open_mux_qi;

wire [B-1:0] open_dib_r;
wire [B-1:0] open_dib_i;

assign writing_result_temp = writing_result;
assign result_avail_delayed = result_avail_delayed_int;
assign writing_result_internal = writing_result;
assign result_avail_internal = result_avail;


assign mem_outr = mem_outr_int;
assign mem_outi = mem_outi_int;

vfft32_delay_wrapper_v2_0 #   (1,
		               2,
		               result_width)
	
delay_y0r_gen                          (.addr(dummy_addr),
					.data(y0r),
					.clk(clk),
					.reset(reset),
					.start(dummy_in),
					.delayed_data(y0r_delayed));

vfft32_delay_wrapper_v2_0 #   (1,
		     2,
		     result_width)
	
delay_y0i_gen                          (.addr(dummy_addr),
					.data(y0i),
					.clk(clk),
					.reset(reset),
					.start(dummy_in),
					.delayed_data(y0i_delayed));

vfft32_delay_wrapper_v2_0 #   (1,
		               2,
		               result_width)
	
delay_y1r_gen                          (.addr(dummy_addr),
					.data(y1r),
					.clk(clk),
					.reset(reset),
					.start(dummy_in),
					.delayed_data(y1r_delayed));

vfft32_delay_wrapper_v2_0 #   (1,
		               2,
		               result_width)
	
delay_y1i_gen                          (.addr(dummy_addr),
					.data(y1i),
					.clk(clk),
					.reset(reset),
					.start(dummy_in),
					.delayed_data(y1i_delayed));

vfft32_delay_wrapper_v2_0 #   (1,
		               4,
		               result_width)


delay_y2r_gen                          (.addr(dummy_addr),
					.data(y2r),
					.clk(clk),
					.reset(reset),
					.start(dummy_in),
					.delayed_data(y2r_delayed));

vfft32_delay_wrapper_v2_0 #   (1,
		               4,
		               result_width)
	
delay_y2i_gen                          (.addr(dummy_addr),
					.data(y2i),
					.clk(clk),
					.reset(reset),
					.start(dummy_in),
					.delayed_data(y2i_delayed));

vfft32_delay_wrapper_v2_0 #   (1,
		               4,
		               result_width)
	
delay_y3r_gen                          (.addr(dummy_addr),
					.data(y3r),
					.clk(clk),
					.reset(reset),
					.start(dummy_in),
					.delayed_data(y3r_delayed));

vfft32_delay_wrapper_v2_0 #   (1,
		               4,
		               result_width)
	
delay_y3i_gen                          (.addr(dummy_addr),
					.data(y3i),
					.clk(clk),
					.reset(reset),
					.start(dummy_in),
					.delayed_data(y3i_delayed));


always @ (posedge clk)

begin

if (reset)

#2 d_select = 0;

else if (~ce)

#2 d_select = 0;

else if (result_avail)

#2 d_select = 0;

else

#2 d_select = d_select + 1;

end


 C_MUX_BUS_V2_0  # 
(
"",
1,
0,
0,
0,
0,
0,
1,
0,
0,
0,
0,
4,
0,
2,
"",
0,
1,
result_width
)  
			
		mux_y0_y3r            ( .MA(y0r_delayed),
					.MB(y1r_delayed),
					.MC(y2r_delayed),
					.MD(y3r_delayed),
					.ME(dummy_mux_inputs),
					.MF(dummy_mux_inputs),
					.MG(dummy_mux_inputs),
					.MH(dummy_mux_inputs),
					.S(d_select),
		  			.CLK(dummy_in), 
		  			.CE(dummy_in),  
		  			.EN(dummy_in),  
		  			.ASET(dummy_in), 
		  			.ACLR(dummy_in), 
		  			.AINIT(dummy_in), 
		  			.SSET(dummy_in), 
		  			.SCLR(dummy_in), 
		  			.SINIT(dummy_in),	
					.O(fft4_result_re_preconj),
					.Q(open_qr));
C_MUX_BUS_V2_0  # 
(
"",
1,
0,
0,
0,
0,
0,
1,
0,
0,
0,
0,
4,
0,
2,
"",
0,
1,
result_width
)  

			
mux_y0_y3i                            ( .MA(y0i_delayed),
					.MB(y1i_delayed),
					.MC(y2i_delayed),
					.MD(y3i_delayed),
					.ME(dummy_mux_inputs),
					.MF(dummy_mux_inputs),
					.MG(dummy_mux_inputs),
					.MH(dummy_mux_inputs),
					.S(d_select),
		  			.CLK(dummy_in), 
		  			.CE(dummy_in),  
		  			.EN(dummy_in),  
		  			.ASET(dummy_in), 
		  			.ACLR(dummy_in), 
		  			.AINIT(dummy_in), 
		  			.SSET(dummy_in), 
		  			.SCLR(dummy_in), 
		  			.SINIT(dummy_in),	
					.O(fft4_result_im_preconj),
					.Q(open_qr));




vfft32_conj_reg_v2_0 #  (result_width)
			

conj_res_mem_inputs                            (.clk(clk),
						.ce(ce),
						.fwd_inv(fwd_inv),
						.dr(fft4_result_re_preconj),
						.di(fft4_result_im_preconj),
						.qr(fft4_result_re),
						.qi(fft4_result_im));



//assign d_select = data_sel;


C_MUX_BUS_V2_0  # 
(
"",
1,
0,
0,
0,
0,
0,
1,
0,
0,
0,
0,
3,
0,
2,
"",
0,
1,
B //in vhdl it is result_width
)  

mux_fftres_xn_diar                    ( .MA(dia_r),
					.MB(xn_re),
					.MC(fft4_result_re_z),
					.MD(dummy_mux_inputs),
					.ME(dummy_mux_inputs),
					.MF(dummy_mux_inputs),
					.MG(dummy_mux_inputs),
					.MH(dummy_mux_inputs),
					.S(data_sel),
		  			.CLK(dummy_in), 
		  			.CE(dummy_in),  
		  			.EN(dummy_in),  
		  			.ASET(dummy_in), 
		  			.ACLR(dummy_in), 
		  			.AINIT(dummy_in), 
		  			.SSET(dummy_in), 
		  			.SCLR(dummy_in), 
		  			.SINIT(dummy_in),	
					.O(d_re),
					.Q(open_mux_qr));


C_MUX_BUS_V2_0  # 
(
"",
1,
0,
0,
0,
0,
0,
1,
0,
0,
0,
0,
3,
0,
2,
"",
0,
1,
B  //in vhdl it is result_width
)  

mux_fftres_xn_diai                    ( .MA(dia_i),
					.MB(xn_im),
					.MC(fft4_result_im_z),
					.MD(dummy_mux_inputs),
					.ME(dummy_mux_input),
					.MF(dummy_mux_input),
					.MG(dummy_mux_input),
					.MH(dummy_mux_input),
					.S(data_sel),
		  			.CLK(dummy_in), 
		  			.CE(dummy_in),  
		  			.EN(dummy_in),  
		  			.ASET(dummy_in), 
		  			.ACLR(dummy_in), 
		  			.AINIT(dummy_in), 
		  			.SSET(dummy_in), 
		  			.SCLR(dummy_in), 
		  			.SINIT(dummy_in),	
					.O(d_im),
					.Q(open_mux_qi));  


vfft32_dmem_wkg_r_i_v2_0 # (B, points_power)

dmem_re_im (.a(addra_dmem),
            .we(we_dmem),
            .d_re(d_re),
            .d_im(d_im),
            .clk(clk),
            .dpra(addrb_dmem),
            .qdpo_re(mem_outr_int_d),
            .qdpo_im(mem_outi_int_d));

assign mem_outr_int = (data_memory == "distributed_mem") ? mem_outr_int_d : (data_memory == "block_mem") ? mem_outr_int_b : 0;
assign mem_outi_int = (data_memory == "distributed_mem") ? mem_outi_int_d : (data_memory == "block_mem") ? mem_outi_int_b : 0;

//always @ (mem_outr_int_d or mem_outr_int_b)

//begin

//if (data_memory == "distributed_mem")

//begin

//mem_outr_int = mem_outr_int_d;

//mem_outi_int = mem_outi_int_d;

//end

//else if (data_memory == "block_mem")

//begin

//mem_outr_int = mem_outr_int_b;

//mem_outi_int = mem_outi_int_b;

//end

//end

vfft32_mem_wkg_r_i_v2_0 # (B, points_power)

bmem_re_imag (.addra(addra_dmem),
              .wea(we_dmem),
              .ena(logic_1),
              .dia_r(d_re),
              .dia_i(d_im),
              .reset(reset),
              .clk(clk),
              .addrb(addrb_dmem),
              .web(logic_0),
              .enb(logic_1),
              .dib_r(open_dib_r),
              .dib_i(open_dib_i),
              .dob_r(mem_outr_int_b),
              .dob_i(mem_outi_int_b));


C_REG_FD_V2_0 # ("0",
                 1,
                 0,
                 1,
                 0,
                 1,
                 0,
                 0,
                 0,
                 "0",
                 0,
                 1,
                 B)

result_gen_re            (.D(mem_outr_int),
			  .CLK(clk),
			  .CE(reading_result),
			  .ACLR(dummy_in), 
			  .ASET(dummy_in),
			  .AINIT(reset), 
			  .SCLR(dummy_in),
			  .SSET(dummy_in),
			  .SINIT(dummy_in),
			  .Q(xk_result_out_re_temp)); 


assign xk_result_out_re = mem_outr_int;
assign xk_result_out_im = mem_outi_int;

C_REG_FD_V2_0 # (ainit_val_ascii,
                 1,
                 0,
                 1,
                 0,
                 1,
                 0,
                 0,
                 0,
                 sinit_val_ascii,
                 0,
                 1,
                 B)

result_gen_im            (.D(mem_outi_int),
			  .CLK(clk),
			  .CE(reading_result),
			  .ACLR(dummy_in), 
			  .ASET(dummy_in),
			  .AINIT(reset), 
			  .SCLR(dummy_in),
			  .SSET(dummy_in),
			  .SINIT(dummy_in),
			  .Q(xk_result_out_im_temp)); 


C_REG_FD_V2_0 # (ainit_val_ascii,
                 1,
                 0,
                 1,
                 0,
                 1,
                 0,
                 0,
                 0,
                 sinit_val_ascii,
                 0,
                 1,
                 result_width) //vhdl has it B

fft4_result_re_z_gen     (.D(fft4_result_re),
			  .CLK(clk),
			  .CE(ce),
			  .ACLR(dummy_in), 
			  .ASET(dummy_in),
			  .AINIT(reset), 
			  .SCLR(dummy_in),
			  .SSET(dummy_in),
			  .SINIT(dummy_in),
			  .Q(fft4_result_re_z)); 


//always @ (fft4_result_re)

//begin

//if (reset)

//fft4_result_re_z = 0;

//else if (~ce)

//fft4_result_re_z = 0;

//else

//#clock_period fft4_result_re_z = fft4_result_re;

//end



C_REG_FD_V2_0 # (ainit_val_ascii,
                 1,
                 0,
                 1,
                 0,
                 1,
                 0,
                 0,
                 0,
                 sinit_val_ascii,
                 0,
                 1,
                 result_width) //vhdl has it B

fft4_result_im_z_gen     (.D(fft4_result_im),
			  .CLK(clk),
			  .CE(ce),
			  .ACLR(dummy_in), 
			  .ASET(dummy_in),
			  .AINIT(reset), 
			  .SCLR(dummy_in),
			  .SSET(dummy_in),
			  .SINIT(dummy_in),
			  .Q(fft4_result_im_z)); 

//always @ (fft4_result_im)

//begin

//if (reset)

//fft4_result_im_z = 0;

//else if (~ce)

//fft4_result_im_z = 0;

//else

//#clock_period fft4_result_im_z = fft4_result_im;

//end


vfft32_delay_wrapper_v2_0 #   (1,
		               32,
		               1)
	
delay_result_avail_gen                 (.addr(dummy_addr),
					.data(result_avail_internal),
					.clk(clk),
					.reset(reset),
					.start(dummy_in),
					.delayed_data(result_avail_delayed_int));

vfft32_delay_wrapper_v2_0 #   (1,
		               2,
		               1)
	

delay_writing_result                   (.addr(dummy_addr),
					.data(writing_result_internal),
					.clk(clk),
					.reset(reset),
					.start(dummy_in),
					.delayed_data(writing_result_delayed_int));


endmodule

//******************************************************************************

//******************************************************************************

//******************************************************************************

//******************************************************************************

module vfft32_result_memory_v2_0 (clk, ce, reset, mrd, fwd_inv, y0r, y0i, y1r, y1i, y2r, y2i, y3r, y3i, e_result_avail, e_result_ready, reset_io, eio_out, result_ready, xk_result_re, xk_result_im);


//parameter distributed_mem = 1;
//parameter block_mem = 2;
parameter result_width = 12;
parameter points_power = 5;
parameter data_memory = "";
parameter memory_architecture = 3;
 

input clk;
input ce;
input reset;
input mrd;
input fwd_inv;
input [result_width-1:0] y0r;
input [result_width-1:0] y0i;
input [result_width-1:0] y1r;
input [result_width-1:0] y1i;
input [result_width-1:0] y2r;
input [result_width-1:0] y2i;
input [result_width-1:0] y3r;
input [result_width-1:0] y3i;
input e_result_avail;
input e_result_ready;
input reset_io;
input eio_out;
output result_ready;
output [result_width-1:0]xk_result_re;
output [result_width-1:0]xk_result_im;

wire [result_width-1:0] xk_result_re1;
wire [result_width-1:0] xk_result_re2;
wire [result_width-1:0] xk_result_im1;
wire [result_width-1:0] xk_result_im2;

parameter zero_data = 1'b0;
parameter default_data = {result_width{zero_data}};
parameter one_string = 2'b1;
parameter three	= 2'b11;
parameter ainit_val = 2'b0;
parameter sinit_val = 2'b0;

parameter one_string_1 = 5'b1;
parameter thirty_one = 5'b11111;
parameter ainit_val_1 = 5'b0;
parameter sinit_val_1 = 5'b0;

wire [result_width-1:0] dr_mem;
wire [result_width-1:0] di_mem;
reg [1:0] d_select;
wire [points_power-1:0] result_read_addr;
reg [points_power-1:0] result_wr_addr;
reg [points_power-1:0] result_wr_addr_scrambled;
reg [points_power-1:0] result_wr_addr_scrambled1;
wire [points_power-1:0] result_wr_addr_scrambled_delayed;

wire read_enable;
reg disable_read_enable;

wire logic_1 = 1'b1;
wire logic_0 = 1'b0;
wire [points_power-1:0] one_1 = 1;
wire [points_power-1:0] zero_1 = 0;
wire [1:0] zero = 2'b0;
wire [1:0] one = 2'b1;

wire [result_width-1:0] open_qr;
wire [result_width-1:0] open_qi;
wire dummy_in = 1'b0;
wire [result_width-1:0] dummy_mux_input;
wire open_thresh0_2; 
wire open_q_thresh0_2;
wire open_thresh1_2;
wire open_q_thresh1_2;

wire [points_power-1:0] unused_addra;
wire [result_width-1:0] unused_dib;
wire [result_width-1:0] unused_dib_i;
wire [result_width-1:0] open_doa_r;
wire [result_width-1:0] open_doa_i;

wire open_thresh0;
wire open_q_thresh0;
wire open_thresh1;
wire open_q_thresh1;

wire open_thresh0_3;
wire open_thresh1_3;
wire open_q_thresh1_3;
reg [points_power-1:0] rd_addr_unscrambled;

wire [result_width-1:0] y2r_delayed;
wire [result_width-1:0] y2i_delayed;
wire [result_width-1:0] y3r_delayed;
wire [result_width-1:0] y3i_delayed;

wire dummy_addr = 0;

wire [points_power-1:0] dummy_spra;
wire [result_width-1:0] open_spo_re;
wire [result_width-1:0] open_qspo_re;
wire [result_width-1:0] open_dpo_re;
wire [result_width-1:0] open_spo_im;
wire [result_width-1:0] open_qspo_im;
wire [result_width-1:0] open_dpo_im;

wire [result_width-1:0] dr_mem_int;
wire [result_width-1:0] di_mem_int;
wire result_ready_int;
wire e_result_ready_temp;
reg mrd_or_reset_io;
wire we_dms;
wire eio_out_reg;

wire disable_read_enable_and_not_mrd;


assign result_ready = result_ready_int;
assign e_result_ready_temp = e_result_ready;

vfft32_delay_wrapper_v2_0 #   (1,
		               2,
		               result_width)
	
delay_y2r_gen                          (.addr(dummy_addr),
					.data(y2r),
					.clk(clk),
					.reset(reset),
					.start(dummy_in),
					.delayed_data(y2r_delayed));

vfft32_delay_wrapper_v2_0 #   (1,
		               2,
		               result_width)
	
delay_y2i_gen                          (.addr(dummy_addr),
					.data(y2i),
					.clk(clk),
					.reset(reset),
					.start(dummy_in),
					.delayed_data(y2i_delayed));

vfft32_delay_wrapper_v2_0 #   (1,
		               2,
		               result_width)
	
delay_y3r_gen                          (.addr(dummy_addr),
					.data(y3r),
					.clk(clk),
					.reset(reset),
					.start(dummy_in),
					.delayed_data(y3r_delayed));

vfft32_delay_wrapper_v2_0 #   (1,
		               2,
		               result_width)
	
delay_y3i_gen                          (.addr(dummy_addr),
					.data(y3i),
					.clk(clk),
					.reset(reset),
					.start(dummy_in),
					.delayed_data(y3i_delayed));


 C_MUX_BUS_V2_0  # 
(
"",
1,
0,
0,
0,
0,
0,
1,
0,
0,
0,
0,
4,
0,
2,
"",
0,
1,
result_width
)  
			
		mux_y0_y3r            ( .MA(y0r),
					.MB(y1r),
					.MC(y2r_delayed),
					.MD(y3r_delayed),
					.ME(dummy_mux_input),
					.MF(dummy_mux_input),
					.MG(dummy_mux_input),
					.MH(dummy_mux_input),
					.S(d_select),
		  			.CLK(dummy_in), 
		  			.CE(dummy_in),  
		  			.EN(dummy_in),  
		  			.ASET(dummy_in), 
		  			.ACLR(dummy_in), 
		  			.AINIT(dummy_in), 
		  			.SSET(dummy_in), 
		  			.SCLR(dummy_in), 
		  			.SINIT(dummy_in),	
					.O(dr_mem_int),
					.Q(open_qr));
C_MUX_BUS_V2_0  # 
(
"",
1,
0,
0,
0,
0,
0,
1,
0,
0,
0,
0,
4,
0,
2,
"",
0,
1,
result_width
)  

			
mux_y0_y3i                            ( .MA(y0i),
					.MB(y1i),
					.MC(y2i_delayed),
					.MD(y3i_delayed),
					.ME(dummy_mux_input),
					.MF(dummy_mux_input),
					.MG(dummy_mux_input),
					.MH(dummy_mux_input),
					.S(d_select),
		  			.CLK(dummy_in), 
		  			.CE(dummy_in),  
		  			.EN(dummy_in),  
		  			.ASET(dummy_in), 
		  			.ACLR(dummy_in), 
		  			.AINIT(dummy_in), 
		  			.SSET(dummy_in), 
		  			.SCLR(dummy_in), 
		  			.SINIT(dummy_in),	
					.O(di_mem_int),
					.Q(open_qi));




vfft32_conj_reg_v2_0 #  (result_width)
			

conj_res_mem_inputs                            (.clk(clk),
						.ce(ce),
						.fwd_inv(fwd_inv),
						.dr(dr_mem_int),
						.di(di_mem_int),
						.qr(dr_mem),
						.qi(di_mem));


always @ (posedge clk)

begin

if (reset)

#2 d_select = 0;

else if (~ce)

#2 d_select = 0;

else if (e_result_avail)

#2 d_select = 0;

else 

begin

if (d_select <= 2)

#2 d_select = d_select + 1;

else

#2 d_select = 0;

end

end



vfft32_delay_wrapper_v2_0 # (1,
                             2,
		             1)
			


result_ready_gen                       (.addr(dummy_addr),
					.data(e_result_ready_temp),
					.clk(clk),
					.reset(reset),
					.start(dummy_in),
					.delayed_data(result_ready_int));


//bmem: IF (data_memory = "block_mem") GENERATE


C_MEM_DP_BLOCK_V1_0 # 
 
( points_power,
  points_power,
  1,
  1,
  default_data, 
  32,
  32,
  1,
  1,
  0,
  1,
  1,
  0,
  1,
  1,
  1,
  1,
  1,
  1,
  1,
  0,
  2,
  0,
  0,
  1,
  1,
  1,
  1,
  result_width,
  result_width)
			

result_mem_r_b                 (.ADDRA(result_wr_addr_scrambled_delayed),  
				.ADDRB(rd_addr_unscrambled), 
				.DIA(dr_mem), 
				.DIB(unused_dib), 
				.CLKA(clk),
				.CLKB(clk),
				.WEA(we_dms), 				   
                                .WEB(logic_0), 
				.ENA(logic_1),  
				.ENB(read_enable), 
				.RSTA(reset),
				.RSTB(reset),
				.DOA(open_doa_r),
				.DOB(xk_result_re1));


C_MEM_DP_BLOCK_V1_0 # 
 
(points_power,
  points_power,
  1,
  1,
  default_data, 
  32,
  32,
  1,
  1,
  0,
  1,
  1,
  0,
  1,
  1,
  1,
  1,
  1,
  1,
  1,
  "null.mif",
  2,
  0,
  0,
  1,
  1,
  1,
  1,
  result_width,
  result_width)
			

result_mem_i_b                 (.ADDRA(result_wr_addr_scrambled_delayed),  
				.ADDRB(rd_addr_unscrambled), 
				.DIA(di_mem), 
				.DIB(unused_dib_i), 
				.CLKA(clk),
				.CLKB(clk),
				.WEA(we_dms), 				   
                                .WEB(logic_0), 
				.ENA(logic_1),  
				.ENB(read_enable), 
				.RSTA(reset),
				.RSTB(reset),
				.DOA(open_doa_i),
				.DOB(xk_result_im1));


//dmem : IF (data_memory = "distributed_mem") GENERATE

 C_DIST_MEM_V2_0 #
 (
points_power,
"0",
 1,
 32,
 1,
 0,           
 1,
 1,
 1,
 1,
 0,
 1, 
 1,
 1,
 0,    
 1,
 0,
 0,   
 0,
 1,
 0,
 1,
 0,
 1, 
 2, 
 0, 
 1,
 0,
 0,
 0,
 0,
 0,
 result_width)
  

result_mem_r_d (.A(result_wr_addr_scrambled_delayed), 
              .D(dr_mem),
              .DPRA(rd_addr_unscrambled),
              .SPRA(dummy_spra),
              .CLK(clk),
              .WE(we_dms),
              .I_CE(logic_1),
              .RD_EN(dummy_in),
              .QSPO_CE(logic_1),
              .QSPO_RST(dummy_in), 
              .QDPO_RST(dummy_in),
              .DPO(dummy_mux_input),
              .SPO(dummy_mux_input),
	      .QSPO(dummy_mux_input),
              .QDPO_CE(read_enable),
              .QDPO_CLK(clk),
	      .QDPO(xk_result_re2)
              );

assign xk_result_re = (data_memory == "distributed_mem") ? xk_result_re2 : (data_memory == "block_mem") ? xk_result_re1 : 1'b0;



C_DIST_MEM_V2_0 #
 (
points_power,
"0",
 1,
 32,
 1,
 0,           
 1,
 1,
 0,
 1,
 0,
 1, 
 1,
 1,
 0,    
 0,
 0,
 0,   
 0,
 0,
 0,
 1,
 0,
 1, 
 2, 
 0, 
 1,
 0,
 0,
 0,
 0,
 0,
 result_width)
  
 result_mem_i_d (.A(result_wr_addr_scrambled_delayed), 
              .D(di_mem),
              .DPRA(rd_addr_unscrambled),
              .SPRA(dummy_spra),
              .CLK(clk),
              .WE(we_dms),
              .I_CE(logic_1),
              .RD_EN(dummy_in),
              .QSPO_CE(logic_1),
              .QSPO_RST(dummy_in), 
              .QDPO_RST(dummy_in), 
              .DPO(open_dpo_im),
              .SPO(open_spo_im),
	      .QSPO(open_qspo_im),
              .QDPO_CE(read_enable),
              .QDPO_CLK(clk),
	      .QDPO(xk_result_im2)
              );

assign xk_result_im = (data_memory == "distributed_mem") ? xk_result_im2 : (data_memory == "block_mem") ? xk_result_im1 : 1'b0;


always @ (posedge clk)

begin

if (reset)

result_wr_addr = 0;

else if (~ce)

result_wr_addr = 0;

else if (e_result_avail)

result_wr_addr = 0;

else 

#2 result_wr_addr = result_wr_addr+ 1;

end

//integer addr_bit;

//assign result_wr_addr_scrambled[addr_bit] = (0 < addr_bit <= points_power-1) ? //result_wr_addr[points_power-1-addr_bit] : 1'b0;

always @ (result_wr_addr)

begin: for_loop

integer addr_bit;

for (addr_bit = points_power-1; addr_bit >=0; addr_bit=addr_bit-1)

result_wr_addr_scrambled[addr_bit] = result_wr_addr[points_power-1-addr_bit];

end


//always @ (result_wr_addr_scrambled1)

//begin

//#2 result_wr_addr_scrambled = result_wr_addr_scrambled1;

//end

vfft32_delay_wrapper_v2_0 # (1,
		             2,
		             points_power)


delay_result_wr_addr_scrambled_gen   (.addr(dummy_addr),
				      .data(result_wr_addr_scrambled),
				      .clk(clk),
				      .reset(reset),
				      .start(dummy_in),                                                             
.delayed_data(result_wr_addr_scrambled_delayed));

vfft32_and_a_notb_v2_0   dis_en_gen        (.a_in(disable_read_enable),
				.b_in(mrd),
				.and_out(disable_read_enable_and_not_mrd));



vfft32_srflop_v2_0 read_enable_gen                 (.clk(clk),
					.ce(ce),
					.set(mrd),
				        .reset(disable_read_enable_and_not_mrd), 	       
                                        .q(read_enable));


always @ (posedge clk)

begin

if (reset)

rd_addr_unscrambled = 0;

else if (~ce)

rd_addr_unscrambled = 0;

else if (mrd)

rd_addr_unscrambled = 0;

else if (memory_architecture == 3)

#2 rd_addr_unscrambled = rd_addr_unscrambled + 1;

end


assign we_dms = (memory_architecture == 3) ? result_ready_int : (memory_architecture == 2) ? eio_out_reg : 1'b0;


always @ (posedge clk)

begin

if (reset)

rd_addr_unscrambled = 0;

else if (~ce)

rd_addr_unscrambled = 0;

else if (mrd_or_reset_io)

rd_addr_unscrambled = 0;

else if (memory_architecture == 2)

#2 rd_addr_unscrambled = rd_addr_unscrambled + 1;

end


always @ (posedge clk)

begin

if (rd_addr_unscrambled == 30)

disable_read_enable = 1;

else

disable_read_enable = 0;

end

		
always @ (mrd or reset_io)

begin

if (memory_architecture == 2)

mrd_or_reset_io = mrd || reset_io;

end


//assign we_dms = (memory_architecture == 2) ? eio_out_reg : 0; 

vfft32_flip_flop_v2_0 eio_reg      (.d(eio_out),
			.clk(clk),
			.ce(ce),
			.reset(reset),
			.q(eio_out_reg1));

assign eio_out_reg = (memory_architecture == 2) ? eio_out_reg1 : 0; 


endmodule

//******************************************************************************

//******************************************************************************

//******************************************************************************

//******************************************************************************


module vfft32_bfly_buf_fft_v2_0 (clk, ce, start, reset, conj, fwd_inv, rank_number, dr, di, xkr, xki, wr, wi, done, e_result_avail, e_result_ready, result_avail, bfly_res_avail, e_bfly_res_avail, ce_phase_factors, ovflo, y0r, y0i, y1r, y1i, y2r, y2i, y3r, y3i);

parameter B = 12;
parameter W_WIDTH = 12;
parameter memory_configuration = 3;
parameter mem_init_file = "000000";
parameter mem_init_file_2 = "000000";

input clk;
input reset;
input ce;
input conj;
input start;
input fwd_inv;
input [1:0] rank_number;
input [B-1:0] dr;
input [B-1:0] di;
input [W_WIDTH-1:0] wr;
input [W_WIDTH-1:0] wi;
input done;

output [B-1:0] xkr;
output [B-1:0] xki;
output e_result_avail;
output e_result_ready;
output result_avail;
output bfly_res_avail;
output e_bfly_res_avail;
output ce_phase_factors;
output ovflo;
output [B-1:0] y0r;
output [B-1:0] y0i;
output [B-1:0] y1r;
output [B-1:0] y1i;
output [B-1:0] y2r;
output [B-1:0] y2i;
output [B-1:0] y3r;
output [B-1:0] y3i;

//reg [3:0] delay_addr;

parameter butterfly_latency = 6; 
parameter start_to_bfly_input_latency  = 3; 
parameter bfly_res_avail_latency = 17; 
parameter bfly_scale_delay_by = 16;
parameter  init_value = "00000";
parameter  count_by_value = "0000001";
parameter  thresh_0_value = "0000000";
parameter five = "101";
parameter ascii_zero = 8'b00110000;

wire [3:0] logic_0_temp;
wire [3:0] logic_1_temp;

wire start_fft4_temp;
wire start_fft4;
wire open_sclr;


wire [B-1:0] bfly_y0r;
wire [B-1:0] bfly_y0i;
wire [B-1:0] bfly_y1r;
wire [B-1:0] bfly_y1i;
wire  bfly_res_select;

wire not_bfly_res_select;
wire mux_select;

wire [B-1:0] xkr_mux;
wire [B-1:0] xki_mux;



wire [B-1:0] fft4_x0r;
wire [B-1:0] fft4_x1r;
wire [B-1:0] fft4_x2r;
wire [B-1:0] fft4_x3r;
wire [B-1:0] fft4_x0i;
wire [B-1:0] fft4_x1i;
wire [B-1:0] fft4_x2i;
wire [B-1:0] fft4_x3i;

reg [3:0] delay_addr_value;
reg [3:0] early_delay_addr;

wire fft_delay_addr;
wire start_temp;
wire bfly_res_avail_temp ;
wire e_bfly_res_avail_temp;
wire e_result_avail_temp;
wire result_avail_temp;
wire start_double_buf_temp;
wire start_double_buf;

wire e_start_double_buf_temp;
wire e_start_double_buf;

wire zero_count;


wire thirty_two_clocks;

wire dummy_in = 1'b0;

wire [B-1:0] dummy_mux_inputs;
wire [B-1:0] open_q_r;
wire [B-1:0] open_q_i;
wire dummy_addr = 1'b0;

wire logic_0 = 1'b0;
wire logic_1 = 1'b1;

wire open_q_thresh0;
wire open_thresh1;
wire open_q_thresh1;

wire [4:0] zero	= 4'b0;
wire [6:0] one = 6'b1;
reg [6:0] count;

wire [6:0] ninety_five = 7'b1011111;

wire [1:0] three;

wire set_signal;
wire counter_ainit;
wire temp_counter_ainit;
wire to_ff_d;
wire to_ainit_logic;
wire load_signal;


wire ce_phase_factors_tmp;


wire [1:0] scale_factor;
wire [1:0] scale_factor_fft4;
wire [1:0] scale_rank3_by;
wire [1:0] scale_rank4_by;

wire [1:0] open_dpo;
wire [1:0] open_qdpo;
wire [1:0] open_qspo;

wire [3:0] dummy_mem_addr;
wire [1:0] dummy_data;
wire [3:0] dummy_dpra;

wire [2:0] bfly_rank_number;
wire [3:0] bfly_rank_number_padded; 

wire [1:0] bfly_rank_number_tmp;
wire [1:0] open_dpo_1;
wire [1:0] open_qdpo_1;
wire [1:0] open_qspo_1;

wire fft4_sca_mem_addr;
wire [3:0] fft4_sca_mem_addr_padded;

wire ce0;		
wire ce1;
wire cex0;		
wire cex1;
wire [1:0] cex1x0;

wire [1:0] open_di;
wire [1:0] open_x0i;
wire [1:0] open_x0i_3;
wire [1:0] open_x0i_4;

wire [3:0] dummy_mem_addr_2;
wire [3:0] dummy_dpra_2;

wire open_thresh0;

wire [6:0] zero_7 = 7'b0;

parameter string_zero_7 = "0000000";

wire aneb;
wire altb;
wire agtb;
wire aleb;
wire ageb;
wire qaeqb;
wire qaneb;
wire qaltb;
wire qagtb;
wire qaleb;
wire qageb;

wire [B-1:0] post_conj_reg_bfly_y0r;
wire [B-1:0] post_conj_reg_bfly_y0i;
wire [B-1:0] post_conj_reg_bfly_y1r;
wire [B-1:0] post_conj_reg_bfly_y1i;



assign mux_select = bfly_res_select;
assign start_temp = start;
assign bfly_res_avail = bfly_res_avail_temp;
assign e_bfly_res_avail = e_bfly_res_avail_temp;

assign three = 2'b11;
assign e_result_avail = e_result_avail_temp;
assign result_avail = result_avail_temp;
assign e_result_ready = count[6];

assign start_fft4 = start_fft4_temp;
assign start_double_buf = start_double_buf_temp;
assign e_start_double_buf = e_start_double_buf_temp;

assign ce_phase_factors = ce_phase_factors_tmp;


assign fft4_sca_mem_addr_padded[3] = 0;
assign fft4_sca_mem_addr_padded[2] = 0;
assign fft4_sca_mem_addr_padded[1] = 0;
assign fft4_sca_mem_addr_padded[0] = start; 



assign logic_0_temp = 4'b0;
assign logic_1_temp = 4'b1;



C_DIST_MEM_V2_0 # 
(4,
"0",
1,
3,
1,
0,
1,
0,
0,
0,
0,
0,
0,
0,
0,
0,
0,
0,
0,
1,
0,
0,
mem_init_file,
1,
0,
0,
0,
0,
0,
1,
0,
0,
2)
	

scal_prof_mem         ( .A(bfly_rank_number_padded), 
			.D(dummy_data),
			.DPRA(dummy_dpra),
			.SPRA(dummy_mem_addr),
			.CLK(clk),
			.WE(dummy_in),
			.I_CE(dummy_in),
			.RD_EN(logic_1),
			.QSPO_CE(dummy_in), 
			.QDPO_CE(dummy_in),
			.QDPO_CLK(dummy_in),
			.QSPO_RST(dummy_in), 
			.QDPO_RST(dummy_in),
			.SPO(scale_factor),
			.DPO(open_dpo),
			.QSPO(open_qspo),
			.QDPO(open_qdpo));


vfft32_delay_wrapper_v2_0 # (1, bfly_scale_delay_by, 2)
		
bfly_rank_number_gen                   (.addr(dummy_addr),
					.data(rank_number),
					.clk(clk),
					.reset(reset),
					.start(start),
					.delayed_data(bfly_rank_number_tmp));


assign bfly_rank_number_padded[3] = 0;
assign bfly_rank_number_padded[2] = 0;
assign bfly_rank_number_padded[1] = bfly_rank_number_tmp[1];
assign bfly_rank_number_padded[0] = bfly_rank_number_tmp[0];



C_DIST_MEM_V2_0 # 
(4,
"0",
1,
2,
1,
0,
1,
1,
0,
1,
0,
1,
0,
0,
0,
1,
0,
0,
0,
0,
0,
1,
mem_init_file_2,
1,
2,
0,
0,
0,
0,
1,
0,
0,
2)
		

fft4_sca_prof_mem     ( .A(logic_0_temp), 
			.D(dummy_data),
			.DPRA(logic_1_temp),
			.SPRA(dummy_mem_addr_2),
			.CLK(clk),
			.WE(logic_0),
			.I_CE(dummy_in),
			.RD_EN(logic_1),
			.QSPO_CE(logic_1), 
			.QDPO_CE(logic_1),
			.QDPO_CLK(clk),
			.QSPO_RST(dummy_in), 
			.QDPO_RST(dummy_in),
			.SPO(open_qspo_1),
			.DPO(open_qdpo_1),
			.QSPO(scale_rank3_by),
			.QDPO(scale_rank4_by));




vfft32_state_machine_v2_0 # (2)
	
state_mc           (.clk(clk),
		    .ce(logic_1), 
		    .start(start),
		    .reset(reset),
		    .s(cex1x0));

assign cex1 = cex1x0[0];
assign cex0 = cex1x0[1];


vfft32_and_a_b_v2_0 gen_ce0             ( .a_in(logic_1), 
					  .b_in(cex0),
					  .and_out(ce0));

vfft32_and_a_b_v2_0 gen_ce1            (.a_in(logic_1), 
					.b_in(cex1),
					.and_out(ce1));

vfft32_butterfly_32_v2_0 #( B, W_WIDTH, memory_configuration)
			
bfly                                   (.clk(clk),
					.ce(ce),
					.start(start),
					.reset(reset),
					.conj(conj),
					.dr(dr),
					.di(di),
					.scale_factor(scale_factor),
                                        .done(done),
					.ce_phase_factors(ce_phase_factors_tmp),
					.y0r(bfly_y0r),
					.y0i(bfly_y0i),
					.y1r(bfly_y1r),
					.y1i(bfly_y1i),
					.ovflo(ovflo),
					.wi(wi),
					.wr(wr)
					);



vfft32_flip_flop_sclr_sset_v2_0  bfly_res_seq  (.d(not_bfly_res_select),
					        .clk(clk),
					        .ce(ce),
					        .reset(start),
					        .sclr(dummy_in),
					        .sset(e_bfly_res_avail_temp),
					        .q(bfly_res_select));

vfft32_nand_a_b_v2_0 inv_gen       (.a_in(bfly_res_select),
			            .b_in(bfly_res_select),
			            .nand_out(not_bfly_res_select)); 

 C_MUX_BUS_V2_0 #("",
                  1,
                  0,
                  0,
                  0,
                  0,
                  0,
                  1,
                  0,
                  0,
                  0,
                  0,
                  2,
                  0,
                  1,
                  "",
                  0,
                  1,
                  B)    
                  

 bfly_res_mux_r   (.MA (bfly_y1r), 
		   .MB (bfly_y0r), 
		   .MC (dummy_mux_inputs),
		   .MD (dummy_mux_inputs),
		   .ME (dummy_mux_inputs),
		   .MF (dummy_mux_inputs),
		   .MG (dummy_mux_inputs),
	           .MH (dummy_mux_inputs),
		   .S  (mux_select),
		   .CLK (dummy_in),
		   .CE 	(dummy_in), 		   
                   .EN 	(dummy_in),  
		   .ASET (dummy_in), 
		   .ACLR (dummy_in),
		   .AINIT (dummy_in),		   
                   .SSET (dummy_in), 		   
                   .SCLR (dummy_in),
		   .SINIT (dummy_in),	
		   .O (xkr_mux),
		   .Q (open_q_r));



 C_MUX_BUS_V2_0 #("",
                  1,
                  0,
                  0,
                  0,
                  0,
                  0,
                  1,
                  0,
                  0,
                  0,
                  0,
                  2,
                  0,
                  1,
                  "",
                  0,
                  1,
                  B)    
                  

 bfly_res_mux_i   (.MA (bfly_y1i), 
		   .MB (bfly_y0i), 
		   .MC (dummy_mux_inputs),
		   .MD (dummy_mux_inputs),
		   .ME (dummy_mux_inputs),
		   .MF (dummy_mux_inputs),
		   .MG (dummy_mux_inputs),
	           .MH (dummy_mux_inputs),
		   .S  (mux_select),
		   .CLK (dummy_in),
		   .CE 	(dummy_in), 		   
                   .EN 	(dummy_in),  
		   .ASET (dummy_in), 
		   .ACLR (dummy_in),
		   .AINIT (dummy_in),		   
                   .SSET (dummy_in), 		   
                   .SCLR (dummy_in),
		   .SINIT (dummy_in),	
		   .O (xki_mux),
		   .Q (open_q_i));




assign xkr = xkr_mux;
assign xki = xki_mux;


vfft32_conj_reg_v2_0 # (B)
		
conj_reg_y0                    (.clk(clk), 
				.ce(ce),
				.fwd_inv(fwd_inv),
				.dr(bfly_y0r),
				.di(bfly_y0i),
				.qr(post_conj_reg_bfly_y0r),
				.qi(post_conj_reg_bfly_y0i));

vfft32_conj_reg_v2_0 # (B)
		
conj_reg_y1                    (.clk(clk), 
				.ce(ce),
				.fwd_inv(fwd_inv),
				.dr(bfly_y1r),
				.di(bfly_y1i),
				.qr(post_conj_reg_bfly_y1r),
				.qi(post_conj_reg_bfly_y1i));


vfft32_delay_wrapper_v2_0 # (1, 34, 1)
		
start_double_buf_gen                    (.addr(dummy_addr),
					.data(bfly_res_avail_temp),
					.clk(cex0),
					.reset(reset),
					.start(start),
					.delayed_data(start_double_buf_temp));



vfft32_delay_wrapper_v2_0 # (1, 30, 1)
		
e_start_double_buf_gen                 (.addr(dummy_addr),
					.data(e_bfly_res_avail_temp),
					.clk(cex1),
					.reset(reset),
					.start(start),
					.delayed_data(e_start_double_buf_temp));




vfft32_bfly_buffer_v2_0 # (B, memory_configuration)
				

double_buf_re ( .by0(post_conj_reg_bfly_y0r), 
		.by1(post_conj_reg_bfly_y1r), 
		.clk(ce_phase_factors_tmp), 
		.reset(reset),
		.start(start_double_buf), 
		.e_start(e_start_double_buf),
		.fft4y0(fft4_x0r),
		.fft4y1(fft4_x1r),
		.fft4y2(fft4_x2r),
		.fft4y3(fft4_x3r));
						
vfft32_bfly_buffer_v2_0 # (B, memory_configuration)
				

double_buf_im ( .by0(post_conj_reg_bfly_y0i), 
		.by1(post_conj_reg_bfly_y1i), 
		.clk(ce_phase_factors_tmp), 
		.reset(reset),
		.start(start_double_buf), 
		.e_start(e_start_double_buf),
		.fft4y0(fft4_x0i),
		.fft4y1(fft4_x1i),
		.fft4y2(fft4_x2i),
		.fft4y3(fft4_x3i));


vfft32_fft4_32_v2_0	# (B) 
		

last_2_ranks_fft4                      (.clk(clk),
					.reset(reset),
					.start(start_fft4),
					.ce(ce),
					.conj(fwd_inv), 
					.scale_rank3_by(scale_rank3_by),
					.scale_rank4_by(scale_rank4_by),
					.x0r(fft4_x0r),
					.x0i(fft4_x0i),
					.x1r(fft4_x1r),
					.x1i(fft4_x1i),
					.x2r(fft4_x2r),
					.x2i(fft4_x2i),
					.x3r(fft4_x3r),
					.x3i(fft4_x3i),
					.y0r(y0r), 
					.y0i(y0i), 
					.y1r(y1r), 
					.y1i(y1i), 
					.y2r(y2r), 
					.y2i(y2i), 
					.y3r(y3r), 
					.y3i(y3i));


 


always @ (ce)

case (W_WIDTH)


2: delay_addr_value = 4'b0110;

3: delay_addr_value = 4'b0111;
4: delay_addr_value = 4'b0111;

5: delay_addr_value = 4'b1000;
6: delay_addr_value = 4'b1000;
7: delay_addr_value = 4'b1000;
8: delay_addr_value = 4'b1000;

 9: delay_addr_value = 4'b1001;
10: delay_addr_value = 4'b1001;
11: delay_addr_value = 4'b1001;
12: delay_addr_value = 4'b1001;
13: delay_addr_value = 4'b1001;
14: delay_addr_value = 4'b1001;
15: delay_addr_value = 4'b1001;
16: delay_addr_value = 4'b1001;

17: delay_addr_value = 4'b1010;
18: delay_addr_value = 4'b1010;
19: delay_addr_value = 4'b1010;
20: delay_addr_value = 4'b1010;
21: delay_addr_value = 4'b1010;
22: delay_addr_value = 4'b1010;
23: delay_addr_value = 4'b1010;
24: delay_addr_value = 4'b1010;
25: delay_addr_value = 4'b1010;
26: delay_addr_value = 4'b1010;
27: delay_addr_value = 4'b1010;
28: delay_addr_value = 4'b1010;
29: delay_addr_value = 4'b1010;
30: delay_addr_value = 4'b1010;
31: delay_addr_value = 4'b1010;
32: delay_addr_value = 4'b1010;
default: delay_addr_value = 4'b0110;

endcase


always @ (ce)

case (W_WIDTH)

2: early_delay_addr = 4'b0101;

3: early_delay_addr = 4'b0110;
4: early_delay_addr = 4'b0110;

5: early_delay_addr = 4'b0111;
6: early_delay_addr = 4'b0111;
7: early_delay_addr = 4'b0111;
8: early_delay_addr = 4'b0111;

 9: early_delay_addr = 4'b1000;
10: early_delay_addr = 4'b1000;
11: early_delay_addr = 4'b1000;
12: early_delay_addr = 4'b1000;
13: early_delay_addr = 4'b1000;
14: early_delay_addr = 4'b1000;
15: early_delay_addr = 4'b1000;
16: early_delay_addr = 4'b1000;

17: early_delay_addr = 4'b1001;
18: early_delay_addr = 4'b1001;
19: early_delay_addr = 4'b1001;
20: early_delay_addr = 4'b1001;
21: early_delay_addr = 4'b1001;
22: early_delay_addr = 4'b1001;
23: early_delay_addr = 4'b1001;
24: early_delay_addr = 4'b1001;
25: early_delay_addr = 4'b1001;
26: early_delay_addr = 4'b1001;
27: early_delay_addr = 4'b1001;
28: early_delay_addr = 4'b1001;
29: early_delay_addr = 4'b1001;
30: early_delay_addr = 4'b1001;
31: early_delay_addr = 4'b1001;
32: early_delay_addr = 4'b1001;

default: early_delay_addr = 4'b1001;

endcase


vfft32_delay_wrapper_v2_0 # (4, bfly_res_avail_latency, 1)
		
blfy_res_avail_gen                     (.addr(delay_addr_value),
					.data(start_temp),
					.clk(clk),
					.reset(reset),
					.start(start),
				        .delayed_data(bfly_res_avail_temp));




vfft32_delay_wrapper_v2_0 # (4, bfly_res_avail_latency -1, 1)
		
e_blfy_res_avail_gen                   (.addr(early_delay_addr),
					.data(start_temp),
					.clk(clk),
					.reset(reset),
					.start(start),
					.delayed_data(e_bfly_res_avail_temp));



vfft32_delay_wrapper_v2_0 # (1, bfly_res_avail_latency + 31 + 32 + 4, 1)
		
fft4_startgen                          (.addr(dummy_addr),
					.data(start_temp),
					.clk(clk),
					.reset(reset),
					.start(start),
					.delayed_data(start_fft4_temp));



assign fft_delay_addr = 0;


vfft32_delay_wrapper_v2_0 # (1, 11, 1)
		
e_result_avail_gen                     (.addr(fft_delay_addr),
					.data(start_fft4_temp),
					.clk(clk),
					.reset(reset),
					.start(start),
					.delayed_data(e_result_avail_temp));



vfft32_delay_wrapper_v2_0 # (1, 2, 1)
		
result_avail_gen                     (.addr(fft_delay_addr),
					.data(e_result_avail_temp),
					.clk(clk),
					.reset(reset),
					.start(start),
					.delayed_data(result_avail_temp));


vfft32_srflop_v2_0 sr_result_avail_temp (.clk(clk),
			     .ce(ce),
			     .set(start),
			     .reset(e_result_avail_temp),
			     .q(temp_counter_ainit));

vfft32_and_a_notb_v2_0 ainit_logic         (.a_in(temp_counter_ainit),
				            .b_in(e_result_avail_temp),
				            .and_out(counter_ainit));
 


always @ (posedge clk)

begin

if (~ce)

count = 0;

else if (counter_ainit)

count = 0;

else 

begin

if (count > 0)

#2 count = count - 1;

else

#2 count = 95;

end

end


C_COMPARE_V2_0 # 
("",
1,
string_zero_7,
1,
1,
0,
0,
1,
0,
0,
0,
0,
0,
0,
0,
0,
0,
0,
0,
0,
0,
0,
1,
0,
1,
7)

			zero_count_gen (.A(count),
					.B(zero_7),
					.CLK(clk),
					.CE(dummy_in),
					.ACLR(dummy_in),
					.ASET(dummy_in),
					.SCLR(start), 
					.SSET(dummy_in),
					.A_EQ_B(zero_count), 
					.A_NE_B(aneb),
					.A_LT_B(altb),	
					.A_GT_B(agtb),	
					.A_LE_B(aleb),	
					.A_GE_B(ageb),	
					.QA_EQ_B(qaeqb),
					.QA_NE_B(qaneb),	
					.QA_LT_B(qaltb),	
					.QA_GT_B(qagtb),	
					.QA_LE_B(qaleb),	
					.QA_GE_B(qageb)	
					);





vfft32_and_a_notb_v2_0  load_logic   (.a_in(zero_count),
				      .b_in(counter_ainit),
				      .and_out(load_signal));


endmodule


//******************************************************************************

//******************************************************************************



//******************************************************************************

//******************************************************************************

//`timescale 1 ns/10ps

	
module vfft32_phase_factors_v2_0 (clk, reset, start, ce, fwd_inv, rank_number, wr, wi);

parameter  W_WIDTH = 16;

input clk;
input reset;
input start;
input ce;
input fwd_inv;
input [1:0] rank_number;
output [W_WIDTH-1:0] wr;
output [W_WIDTH-1:0] wi;

wire [4:0] w_addr_cos;
wire [3:0] w_addr_cos1; //was [4:0]
wire [4:0] w_addr_sin;
wire [W_WIDTH-1:0] sine;
wire [W_WIDTH-1:0] cosine;

wire logic0 = 1'b0;
wire logic_1 = 1'b1;
wire dummy_in = 1'b0;

wire open_rfd = 1'b0;
wire open_rdy = 1'b0;
wire open_aclr = 1'b0;
wire open_rfd_s = 1'b0;
wire open_rdy_s = 1'b0;
wire open_aclr_s = 1'b0; 

wire [W_WIDTH-1:0] open_sine; 
wire [W_WIDTH-1:0] open_cosine; 

 
assign w_addr_cos[3:0] = w_addr_cos1;

assign w_addr_cos[4] = 0;
 
vfft32_phase_factor_adgen_v2_0  # (W_WIDTH)
 
w_address (.clk(clk),
            .reset(reset),
            .start(start),
            .ce(ce),
            .fwd_inv(fwd_inv),
            .rank_number(rank_number),
            .w_addr_cos(w_addr_cos1),
            .w_addr_sine(w_addr_sin)   
           );


C_SIN_COS_V2_0 # (0,
                  1,
                  1,
                  0,
                  1,
                  1,
                  1,
                  0,
                  0,
                  1,
                  W_WIDTH,
                  0,
                  1,
                  0,
                  5
                   )

sincos_cosine          (.THETA(w_addr_cos),
			.SINE(open_sine),
			.COSINE(cosine),
			.ND(dummy_in),
			.RFD(open_rfd),
			.RDY(open_rdy),
			.CLK(clk),
			.CE(ce),
			.ACLR(reset),
			.SCLR(open_aclr)
                       );
 
C_SIN_COS_V2_0 # (0,
                  1,
                  1,
                  0,
                  1,
                  1,
                  1,
                  1,
                  0,
                  0,
                  W_WIDTH,
                  0,
                  1,
                  0,
                  5
                   )

sincos_neg_cosine      (.THETA(w_addr_sin),
			.SINE(sine),
			.COSINE(open_cosine),
			.ND(dummy_in),
			.RFD(open_rfd_s),
			.RDY(open_rdy_s),
			.CLK(clk),
			.CE(ce),
			.ACLR(reset),
			.SCLR(open_aclr_s)
                       );

assign wr = cosine;
assign wi = sine;


endmodule

//******************************************************************************

//******************************************************************************







//******************************************************************************

//******************************************************************************


module vfft32_hand_shaking_v2_0 (clk, ce, reset, start, result_avail, eio_pulse_out, busy, done, edone);

parameter memory_architecture = 1;

input clk;
input ce;
input reset;
input start;
input result_avail;
input eio_pulse_out;
output busy;
output done;
output edone;

reg done_internal;
wire done_internal_x;
wire dummy_addr;
wire dummy_in;
wire logic_1 = 1'b1;
//wire result_avail_temp;
reg  result_avail_temp;
wire tms_busy_clr = 1'b0;
wire [6:0] zero_96 = 7'b0;
wire [6:0] one_96 = 7'b1;
wire open_thresh0_96;
wire open_q_thresh0_96;
wire open_thresh1_96;
wire open_q_thresh1_96;
reg count96_tc;
reg [6:0] count96;
wire ce_96;
wire ce_96_tms;

wire edone_internal;
wire busy_sms;
wire busy_tms_dms;

wire fake_out;
wire edone_decode95;
wire edone_decode95_tms;
wire edone_temp;
wire edone_temp_tms;
wire done_temp1;
reg done_temp;
wire done;
wire edone;
wire eio_pulse_out;
wire done_sms_busy;

parameter init_value = "000000";

assign edone_internal = result_avail;
//assign result_avail_temp = result_avail;


always @ (posedge clk)

begin

if (result_avail == 1)

result_avail_temp = 1;

else

result_avail_temp = 0;

end


vfft32_delay_wrapper_v2_0 # (1, 30, 1) //was (1, 32, 1)
				
                         done_int_gen  (.addr(dummy_addr),
					.data(result_avail_temp),
					.clk(clk),
					.reset(reset),
					.start(start),
					.delayed_data(done_internal_x));

always @ (posedge clk)

begin

if (done_internal_x)

done_internal = 1;

else

done_internal = 0;

end

assign edone = (memory_architecture == 1) ? edone_internal : (memory_architecture == 2) ? eio_pulse_out : (memory_architecture == 3) ? edone_temp : 0;


assign done = (memory_architecture == 1) ? done_internal : done_temp;



always @ (posedge clk)

begin

if (reset)

count96 = 0;

else if (count96_tc)

count96 = 0;

else if (~ce_96)

count96 = 0;

else if (done_internal)

count96 = 0;

else 

begin

if (memory_architecture == 3)

#2 count96 = count96 + 1;

else

#2 count96 = 0;

end

end


vfft32_srflop_v2_0 ce_96_gen       (.clk (clk),
			.ce (ce),
			.set (done_internal),
			.reset (reset),
			.q (ce_96_tms));

assign ce_96 = (memory_architecture == 3) ? ce_96_tms : 0;

always @ (count96)

begin

if (memory_architecture == 3)

count96_tc = count96[5] &&  count96[6];

end

C_GATE_BIT_V2_0 #

("0",
  0,
  0,
  0,
  0,
  0,
  0,
  1,
  0,
  0,
  0,
  0,
  7,
  "0100000",
  0,
  "0",
  0,
  1)

decode_95 (     .I (count96),
		.O (edone_decode95_tms),
		.CLK (dummy_in),
		.Q (fake_out),
		.CE (dummy_in), 	
		.AINIT (dummy_in), 
		.ASET (dummy_in), 	
		.ACLR (dummy_in), 	
		.SINIT (dummy_in),
		.SSET (dummy_in),	
		.SCLR (dummy_in)
		);

  
assign edone_decode95 = (memory_architecture == 3) ? edone_decode95_tms : 0;

vfft32_or_a_b_v2_0 edone_gen       (.a_in (edone_internal),
			   .b_in (edone_decode95),
			   .or_out (edone_temp_tms));

assign edone_temp = (memory_architecture == 3) ? edone_temp_tms : (memory_architecture == 2) ? eio_pulse_out : 0;


vfft32_delay_wrapper_v2_0 #   (1, 32, 1)
				
done_gen                               (.addr(dummy_addr),
					.data(edone_temp),
					.clk(clk),
					.reset(reset),
					.start(start),
					.delayed_data(done_temp1));

always @ (done_temp1)

begin

if (done_temp1 == 1)

done_temp = 1;

else

done_temp = 0;

end


vfft32_flip_flop_sclr_v2_0   busy_gen_tms_dms    (.d(logic_1),
				        .clk(clk),
				        .ce(start),
				        .reset(reset),
				        .sclr(tms_busy_clr), 
				        .q(busy_tms_dms));



vfft32_delay_wrapper_v2_0 # (1, 3, 1)
			
done_busy                         (.addr(dummy_addr),
					.data(done),
					.clk(clk),
					.reset(reset),
					.start(start),
					.delayed_data(done_sms_busy));


vfft32_flip_flop_sclr_v2_0   busy_gen_sms    (.d(logic_1),
				    .clk(clk),
				    .ce(start),
				    .reset(reset),
				    .sclr(done_sms_busy), 
				    .q(busy_sms));




assign busy = (memory_architecture == 1) ? busy_sms : busy_tms_dms;

endmodule

//******************************************************************************

//******************************************************************************

//******************************************************************************

//******************************************************************************


module vfft32_delay_wrapper_v2_0 (addr, data, clk, start, reset, delayed_data);

parameter ADDR_WIDTH = 4;
parameter DEPTH = 16;
parameter DATA_WIDTH = 16;


input [ADDR_WIDTH-1:0]addr;	
input [DATA_WIDTH-1:0]data;
input clk;
input reset;
input start;
output [DATA_WIDTH-1:0]delayed_data;

parameter ainit_val = 8'b00110000;
parameter sinit_val = 8'b00110000;
parameter zero = 1'b0;
parameter default_data = {DATA_WIDTH{zero}};
wire dummy_in;

assign dummy_in = 1'b0;

vfft32_shift_ram_v2_0 # (ADDR_WIDTH,
                         ainit_val,
                         default_data,
                         1,
                         DEPTH,
                         1,
                         0,
                         0,
                         1,
                         0,
                         0,
                         0,
                         0,
                         1,
                         0,
                         0,
                         1,
                         0,
                         0,
                         0,
                         "",
                         0,
                         1,
                         DATA_WIDTH,
                         ((DEPTH/16+1))*16,
                         1) 
  	
delay_element ( .A(addr),
	        .D(data),
		.CLK(clk),
                .CE(dummy_in),
		.ACLR(reset),
                .ASET(dummy_in),
                .AINIT(dummy_in),
                .SCLR(dummy_in), 
                .SSET(dummy_in),
		.SINIT(start),
		.Q(delayed_data)
              );
endmodule

//******************************************************************************

//******************************************************************************

//******************************************************************************

//******************************************************************************


module vfft32_bfly_buffer_v2_0 (by0, by1, clk, reset, start, e_start, fft4y0, fft4y1, fft4y2, fft4y3);

parameter bfly_width = 12;
parameter memory_configuration = 3;

input clk;
input reset;
input start;
input e_start;
input [bfly_width-1:0] by0;
input [bfly_width-1:0] by1;

output [bfly_width-1:0] fft4y0;
output [bfly_width-1:0] fft4y1;
output [bfly_width-1:0] fft4y2;
output [bfly_width-1:0] fft4y3;

parameter one_string = "01";
parameter ainit_val = "00";
parameter sinit_val = "00";
parameter ascii_zero = 8'b00110000;

wire [1:0] zero = 2'b0;
wire [1:0] one = 2'b1;


wire ce0;		
wire ce1;
wire cex0;		
wire cex1;
wire [1:0] cex1x0;

wire [bfly_width-1:0] by1_2z;
wire [bfly_width-1:0] by1_1z;
wire [bfly_width-1:0] reg_by0;

wire [bfly_width-1:0] fft4y2_int;

wire [bfly_width-1:0] a;
wire [bfly_width-1:0] b;
wire [bfly_width-1:0] c;
wire [bfly_width-1:0] d;
wire [bfly_width-1:0] e;
wire [bfly_width-1:0] f;
wire [bfly_width-1:0] c_1z;

wire [bfly_width-1:0] e_2z;


wire logic_0 = 1'b0;
wire logic_1 = 1'b1;

wire dummy_addr	= 1'b0;
wire dummy_in = 1'b0;

wire [bfly_width-1:0] dummy_mux_inputs;
wire [bfly_width-1:0] open_o;
wire [bfly_width-1:0] open_o_d;
wire [bfly_width-1:0] open_o_e;

wire mux_select;


wire [bfly_width-1:0] open_di;
wire [bfly_width-1:0] open_x0i;
wire [bfly_width-1:0] open_x0i_ffty0;
wire [bfly_width-1:0] open_x0i_ffty1;
wire [bfly_width-1:0] open_x0i_ffty2;
wire [bfly_width-1:0] open_x0i_ffty3;


wire buf_clk;

wire [1:0] count;

wire open_thresh0;
wire open_q_thresh0;
wire open_thresh1;
wire open_q_thresh1;

wire nc = 1'b0;

assign open_di = 1'b0;

assign a = by0;
assign b = by1;

assign buf_clk = ce0;

assign #1 mux_select = count[1];


C_COUNTER_BINARY_V2_0 # (ainit_val,
                         one_string,
                         0,           
                         "1111111111111111", 
                         1,
                         1,
                         1,
                         0,
                         1,
                         1,
                         0,
                         0,
                         0,
                         0,
                         0,
                         0,
                         0,
                         0,
                         0,
                         0, 
                         1,
                         0,
                         0,
                         0,
                         sinit_val,
                         1,
                         1,
                         "1111111111111111",
                         "1111111111111111",
                         2)

mux_sel_gen              (.CLK(clk),
			  .UP(logic_1),
			  .CE(logic_1),
			  .LOAD(dummy_in),
			  .L(zero),
			  .IV (one),
			  .ACLR(e_start), 
			  .ASET(dummy_in),
			  .AINIT(reset),
			  .SCLR(dummy_in), 			            
                          .SINIT(dummy_in),
			  .SSET(dummy_in),
			  .THRESH0(open_thresh0),
			  .Q_THRESH0(open_q_thresh0),   
		  	  .THRESH1(open_thresh1),  
		  	  .Q_THRESH1(open_q_thresh1),
			  .Q (count));

 C_MUX_BUS_V2_0 #("",
                  1,
                  0,
                  0,
                  0,
                  0,
                  0,
                  0,
                  1,
                  0,
                  0,
                  0,
                  2,
                  0,
                  1,
                  "",
                  0,
                  1,
                  bfly_width)    			

   mux1          ( .MA (a), 
		   .MB (c), 
		   .MC (dummy_mux_inputs),
		   .MD (dummy_mux_inputs),
		   .ME (dummy_mux_inputs),
		   .MF (dummy_mux_inputs),
		   .MG (dummy_mux_inputs),
	           .MH (dummy_mux_inputs),
		   .S  (mux_select),
		   .CLK (clk),
		   .CE 	(dummy_in), 		   
                   .EN 	(dummy_in),  
		   .ASET (dummy_in), 
		   .ACLR (dummy_in),
		   .AINIT (dummy_in),		   
                   .SSET (dummy_in), 		   
                   .SCLR (dummy_in),
		   .SINIT (dummy_in),	
		   .O (open_o_d),
		   .Q (d));

C_MUX_BUS_V2_0 #("",
                  1,
                  0,
                  0,
                  0,
                  0,
                  0,
                  0,
                  1,
                  0,
                  0,
                  0,
                  2,
                  0,
                  1,
                  "",
                  0,
                  1,
                  bfly_width)    					

   mux2          ( .MA (c), 
		   .MB (a), 
		   .MC (dummy_mux_inputs),
		   .MD (dummy_mux_inputs),
		   .ME (dummy_mux_inputs),
		   .MF (dummy_mux_inputs),
		   .MG (dummy_mux_inputs),
	           .MH (dummy_mux_inputs),
		   .S  (mux_select),
		   .CLK (clk),
		   .CE 	(dummy_in), 		   
                   .EN 	(dummy_in),  
		   .ASET (dummy_in), 
		   .ACLR (dummy_in),
		   .AINIT (dummy_in),		   
                   .SSET (dummy_in), 		   
                   .SCLR (dummy_in),
		   .SINIT (dummy_in),	
		   .O (open_o_e),
		   .Q (e));


vfft32_delay_wrapper_v2_0 # (1, 2, bfly_width)
				
c_gen (.addr(dummy_addr),
	   .data(by1),
	   .clk(clk),
	   .reset(reset),
	   .start(start),
	   .delayed_data(c));


vfft32_delay_wrapper_v2_0 # (1, 3, bfly_width)
				
f_gen (.addr(dummy_addr),
	   .data(d),
	   .clk(clk),
	   .reset(reset),
	   .start(start),
	   .delayed_data(f));


vfft32_state_machine_v2_0 # (2)
	state_mc   (.clk(clk),
		    .ce(logic_1), 
		    .start(e_start),
		    .reset(reset),
		    .s(cex1x0));


C_REG_FD_V2_0 # 
(
ascii_zero,
1,
0,
0,
0,
1,
0,
0,
0,
ascii_zero,
0,
1,
bfly_width)

	ffty0_gen	       (.D(f),
			  	.CLK(clk),
			  	.CE(ce1),
			  	.ACLR(dummy_in), 
			  	.ASET(nc),
			  	.AINIT(nc), 
			  	.SCLR(nc),
			  	.SSET(nc),
			  	.SINIT(nc),
			  	.Q(fft4y0));

C_REG_FD_V2_0 # 
(
ascii_zero,
1,
0,
0,
0,
1,
0,
0,
0,
ascii_zero,
0,
1,
bfly_width)



ffty1_gen	               (.D(f),
			  	.CLK(clk),
			  	.CE(ce0),
			  	.ACLR(dummy_in), 
			  	.ASET(nc),
			  	.AINIT(nc), 
			  	.SCLR(nc),
			  	.SSET(nc),
			  	.SINIT(nc),
			  	.Q(fft4y1));



C_REG_FD_V2_0 # 
(
ascii_zero,
1,
0,
0,
0,
0,
0,
0,
0,
ascii_zero,
0,
1,
bfly_width)

			
ffty2_gen 	               (.D(e_2z),
			  	.CLK(clk),
			  	.CE(ce0),
			  	.ACLR(dummy_in), 
			  	.ASET(dummy_in),
			  	.AINIT(nc), 
			  	.SCLR(dummy_in),
			  	.SSET(dummy_in),
			  	.SINIT(dummy_in),
			  	.Q(fft4y2));



C_REG_FD_V2_0 # 
(
ascii_zero,
1,
0,
0,
0,
1,
0,
0,
0,
ascii_zero,
0,
1,
bfly_width)

	ffty3_gen	       (.D(e),
			  	.CLK(clk),
			  	.CE(ce1),
			  	.ACLR(dummy_in), 
			  	.ASET(nc),
			  	.AINIT(nc), 
			  	.SCLR(nc),
			  	.SSET(nc),
			  	.SINIT(nc),
			  	.Q(fft4y3));


vfft32_delay_wrapper_v2_0 # (1, 2, bfly_width)
				
e_2z_gen (.addr(dummy_addr),
	   .data(e),
	   .clk(clk),
	   .reset(reset),
	   .start(start),
	   .delayed_data(e_2z));


assign ce0 = cex1x0[0];
assign ce1 = cex1x0[1];


endmodule

//******************************************************************************

//******************************************************************************

//******************************************************************************

//******************************************************************************

	
module vfft32_butterfly_32_v2_0 (clk, ce, start, reset, conj, dr, di, scale_factor, done, ce_phase_factors, y0r, y0i, y1r, y1i, wi, wr, ovflo);

parameter B = 12;
parameter W_WIDTH = 12;
parameter memory_architecture = 1;
	
input clk;
input ce;
input start;
input reset;
input conj;
input [B-1:0] dr;
input [B-1:0] di;
input [1:0] scale_factor;
input done;
input [W_WIDTH-1:0] wi;  
input [W_WIDTH-1:0] wr;  

output ce_phase_factors;
output [B-1:0] y0r;	
output [B-1:0] y0i;
output [B-1:0] y1r;
output [B-1:0] y1i;	
output ovflo;

wire conji;
reg ce0;	
reg ce1;
wire cex0;	
wire cex1;
reg start_butterfly_32;	
		
wire [B-1:0] x0r; 
wire [B-1:0] x0i; 
wire [B-1:0] int_x0r; 
wire [B-1:0] int_x0i; 
wire [B-1:0] x1r; 
wire [B-1:0] x1i; 

wire [W_WIDTH-1:0] w_logic0;
wire [W_WIDTH-1:0] w_logic_minus_j;
wire [W_WIDTH-1:0] w_logic1; 
wire [2-1:0] cex1x0;

wire [W_WIDTH-1:0] wr_delay3; 
wire [W_WIDTH-1:0] wi_delay3; 


assign w_logic0 [0] = 1'b0;
assign w_logic0 [W_WIDTH-1:1] = W_WIDTH-1'b0;
assign w_logic1 [0] = 1'b1;                                    
assign w_logic1 [W_WIDTH-1:1] = W_WIDTH-1'b0;	
assign w_logic_minus_j [W_WIDTH-1:1] = W_WIDTH-1'b1;
assign w_logic_minus_j [0] = 1'b1;

wire logic0 = 1'b0;

wire int_cex1 = cex1x0[0];  
wire int_cex0 = cex1x0[1];

wire dummy_addr = 1'b0;




vfft32_state_machine_v2_0 # (2)

state_mc  (.clk(clk),
	   .ce(ce),
	   .start(start),
	   .reset(reset),
	   .s(cex1x0)
           );

vfft32_flip_flop_sclr_v2_0 register_cex1 (.d(int_cex1),
		              .ce(ce),
		              .clk(clk),
		              .reset(reset),
		              .sclr(start),
		              .q(cex1)
                               );

vfft32_flip_flop_sclr_v2_0 register_cex0 (.d(int_cex0),
		              .ce(ce),
		              .clk(clk),
		              .reset(reset),
		              .sclr(start),
		              .q(cex0)
                               );


vfft32_complex_reg_conj_v2_0 # (B)
  
  x0_reg       (.clk(clk),
		.ce(ce0),
		.conj(conji),
		.dr(dr),
		.di(di),
		.qr(x0r),
		.qi(x0i)
	        );

vfft32_complex_reg_conj_v2_0 # (B)
  
  x1_reg       (.clk(clk),
		.ce(ce1),
		.conj(conji),
		.dr(dr),
		.di(di),
		.qr(x1r),
		.qi(x1i)
	        );



//delay the omegas by 3 clocks so they line up with input samples 
// correctly at butterfly inputs

vfft32_delay_wrapper_v2_0 #  (1,
		              2,
		              W_WIDTH)

delay3_wr      (.addr(dummy_addr),
		.data(wr),
		.clk(start_butterfly_32),
		.reset(reset),
		.start(start),
		.delayed_data(wr_delay3)
                );


vfft32_delay_wrapper_v2_0 #  (1,
		   2,
		   W_WIDTH)

delay3_wi      (.addr(dummy_addr),
		.data(wi),
		.clk(start_butterfly_32),
		.reset(reset),
		.start(start),
		.delayed_data(wi_delay3)
                );
	
vfft32_butterfly_v2_0 # (B,
		         W_WIDTH,
                         memory_architecture)
	

  b0           (.clk(clk),				
                .ce(ce),					
                .start_bf(start_butterfly_32),
		.start(start),
		.reset(logic0),
		.scale_factor(scale_factor),
                .done(done),
		.x0r(x0r),
		.x0i(x0i),	
		.x1r(x1r),
		.x1i(x1i),	
		.y0r(y0r),
		.y0i(y0i), 	
		.y1r(y1r),
		.y1i(y1i),
		.ovflo(ovflo),
		.wr(wr_delay3), 
		.wi(wi_delay3) 
	         );
	
			

always @ (ce or cex0)

begin: loop1

#1 start_butterfly_32 = ce && cex0;

end

always @ (ce or cex0)

begin: loop2

#1 ce0 = ce && cex0;

end


always @ (ce or cex1)

begin: loop3

#1 ce1 = ce && cex1;

end


assign conji = conj;					
wire ce_phase_factors = start_butterfly_32;

endmodule


//******************************************************************************

//******************************************************************************





//******************************************************************************

//******************************************************************************


module vfft32_butterfly_v2_0 (clk, ce, start_bf, start, reset, scale_factor, x0r, x0i, x1r, x1i, done, y0r, y0i, y1r, y1i, ovflo, wi, wr);

parameter B = 12;
parameter W_WIDTH = 12;
parameter memory_architecture = 1;

input [B-1:0] x0r;
input [B-1:0] x0i;
input [B-1:0] x1r;
input [B-1:0] x1i;
input clk;
input ce;
input start;
input reset;
input start_bf;
input [1:0] scale_factor;
input done;

output [B-1:0] y0r;
output [B-1:0] y0i;
output [B-1:0] y1r;
output [B-1:0] y1i;
output ovflo;

input [W_WIDTH-1:0]wi;
input [W_WIDTH-1:0]wr; 

parameter ainit_val = "0000000";
parameter sinit_val = "0000000";

parameter max_complex_mult_latency = 6;
parameter max_bfly_latency = 7;
parameter delay_upper_arm_by = 6;
parameter xmul_full_pr_width = {B + W_WIDTH + 3};

parameter  diff_with_0_scaling = xmul_full_pr_width - (B+2) ; 
parameter latency_thro_mult_vgen = 1; // mult_latency(W_WIDTH);

parameter latency_thro_comp_mult = 1; //cmplx_mult_latency(W_WIDTH, B+1);
parameter result = B + W_WIDTH-1 - 1;
parameter diff0	= result - B;
parameter upperarm_diff0 = 0;

//assign a_slower = ((prod_a_mult_latency == greatest_mult_latency)) ? 1'b1 : //1'b0;
//assign b_slower = ((prod_b_mult_latency == greatest_mult_latency)) ? 1'b1 : //1'b0;


//parameter delay_faster_mult_by = 1; //{{b_slower * diff_in_latency_a} + //{a_slower * diff_in_latency_b}};



wire [B+1:0] int_y0r;
wire [B+1:0] int_y0i;
//wire [b_width:0] br_plus_bi;

wire [B:0]  y0r_pre_delay;
wire [B:0]  y0i_pre_delay;

wire [result:0] p_re_temp_0scaled;
wire [result:0] p_im_temp_0scaled;

wire [result+1:0] p_re_temp_1scaled;
wire [result+1:0] p_im_temp_1scaled;

wire [result+2:0] p_re_temp_2scaled;
wire [result+2:0] p_im_temp_2scaled;

wire [B+1:0]  y0r_pre_delay_s_ext;
wire [B+1:0]  y0i_pre_delay_s_ext;

wire [B + 1 + W_WIDTH +1:0] p_re_full_precision;
wire [B + 1 + W_WIDTH +1:0] p_im_full_precision;
wire [B + 1:0] p_re_truncated;
wire [B + 1:0] p_im_truncated;

wire logic0 = 1'b0;
wire logic1 = 1'b1;
wire nc = 1'b0;
wire dummy_in = 1'b0;
wire [B:0] sub_to_mult_r;
wire [B:0] sub_to_mult_i;
wire ce_bf;
wire open_sclr= 1'b0;

wire open_ovfl;
wire open_c_out;
wire open_b_out;
wire open_q_ovfl;
wire open_q_c_out;
wire open_q_b_out;
wire [B:0] open_s;

wire open_ovfl_1;
wire open_c_out_1;
wire open_b_out_1;
wire open_q_ovfl_1;
wire open_q_c_out_1;
wire open_q_b_out_1;
wire [B:0] open_s_1;

wire open_ovfl_2;
wire open_c_out_2;
wire open_b_out_2;
wire open_q_ovfl_2;
wire open_q_c_out_2;
wire open_q_b_out_2;
wire [B:0] open_s_2;

wire open_ovfl_3;
wire open_c_out_3;
wire open_b_out_3;
wire open_q_ovfl_3;
wire open_q_c_out_3;
wire open_q_b_out_3;
wire [B:0] open_s_3;

//wire [1:0] mux_select;
wire [B-1:0] dummy_mux_inputs;

wire [B-1:0] y0r_scale0;
wire [B-1:0] y0i_scale0;
wire [B-1:0] y1r_scale0;
wire [B-1:0] y1i_scale0;
wire [B-1:0] y0r_scale1;
wire [B-1:0] y0i_scale1;
wire [B-1:0] y1r_scale1;
wire [B-1:0] y1i_scale1;
wire [B-1:0] y0r_scale2;
wire [B-1:0] y0i_scale2;
wire [B-1:0] y1r_scale2;
wire [B-1:0] y1i_scale2;

wire [B-1:0] open_q_r;
wire [B-1:0] open_q_i;

wire dummy_addr;
wire ovflo_0;
wire ovflo_1;
wire ovflo_2;

wire [B-1:0] ovflo_0_temp_re_or_im;
wire [B-1:0] ovflo_1_temp_re_or_im;
wire [B-1:0] ovflo_2_temp_re_or_im;
wire [B-1:0] ovflo_temp;
reg ovflo_temp_set;
wire [B-1:0] open_q_ovflo;
wire dummy_mux_inputs_ovflo;
//wire open_sclr;

reg [xmul_full_pr_width-1:result+1] ovflo_0_int; 
reg [xmul_full_pr_width-1:result+2] ovflo_1_int;
reg [xmul_full_pr_width-1:result+3] ovflo_2_int;

reg [xmul_full_pr_width-1:result+2] or_out_0;
reg [xmul_full_pr_width-1:result+3] or_out_1;
reg [xmul_full_pr_width-1:result+4] or_out_2;

reg [xmul_full_pr_width-1:result+1] ovflo_0_int_im;
reg [xmul_full_pr_width-1:result+2] ovflo_1_int_im;
reg [xmul_full_pr_width-1:result+3] ovflo_2_int_im;

reg [xmul_full_pr_width-1:result+2] or_out_0_im;
reg [xmul_full_pr_width-1:result+3] or_out_1_im;
reg [xmul_full_pr_width-1:result+4] or_out_2_im;

wire ovflo_0_re_or_im;	
wire ovflo_1_re_or_im;	
wire ovflo_2_re_or_im;	
 
wire ovflo_0_re;
wire ovflo_0_im;

wire ovflo_1_re;
wire ovflo_1_im;

wire ovflo_2_re;
wire ovflo_2_im;

wire done_or_start;
wire done_or_start_sig;

vfft32_and_a_b_v2_0  ce_bf_gen (.a_in(ce),
                     .b_in(start_bf),
                     .and_out(ce_bf)
                     );


wire [1:0]mux_select;  

assign mux_select = scale_factor;

assign ovflo_0_temp_re_or_im = ovflo_0_re_or_im;
assign ovflo_1_temp_re_or_im = ovflo_1_re_or_im;
assign ovflo_2_temp_re_or_im = ovflo_2_re_or_im;
  

//parameter C_DEFAULT_DATA_RADIX = 1;
//parameter C_DEPTH         = 16;
//parameter C_MEM_INIT_RADIX = 1;

 C_ADDSUB_V2_0 # (0,
                  0,
                  0,
                  B,
                  0,
                  0,
                  0,
                  0,
                  "",
                  B,
                  1,
                  0,
                  0,
                  0,
                  0,
                  1,
                  0,
                  0,
                  0,
                  1,
                  1,
                  1,
                  0,
                  0,
                  1,
                  0,
                  0,
                  0,
                  0,
                  0,
                  0,
                  0,
                  B,
                  0,
                  B+1,
                  1,
                  0,
                  0,
                  1)
		    
	   
upper_arm_adder_re             (.A (x0r), 
				.B(x1r), 
				.CLK (clk),
				.ADD (dummy_in),
				.C_IN(logic0),
				.B_IN(dummy_in),
				.CE(ce_bf), 
				.BYPASS(dummy_in),
				.ACLR(dummy_in),
				.ASET(dummy_in),
				.AINIT(reset),
				.SCLR(nc),
				.SSET(nc),
				.SINIT(nc),
				.A_SIGNED(logic1),
				.B_SIGNED(logic1),
				.OVFL(open_ovfl),
				.C_OUT(open_c_out),
				.B_OUT(open_b_out),
				.Q_OVFL(open_q_ovfl),
				.Q_C_OUT(open_q_c_out),
				.Q_B_OUT(open_q_b_out),
				.S(open_s),
				.Q (y0r_pre_delay));
 

 C_ADDSUB_V2_0 # (0,
                  0,
                  0,
                  B,
                  0,
                  0,
                  0,
                  0,
                  " ",
                  B,
                  1,
                  0,
                  0,
                  1,
                  0,
                  1,
                  0,
                  0,
                  0,
                  1,
                  1,
                  1,
                  0,
                  0,
                  1,
                  0,
                  0,
                  0,
                  0,
                  0,
                  0,
                  0,
                  B,
                  0,
                  B+2,
                  1,
                  0,
                  0,
                  1)

upper_arm_adder_im             (.A (x0i), 
				.B(x1i), 
				.CLK (clk),
				.ADD (dummy_in),
				.C_IN(logic0),
				.B_IN(dummy_in),
				.CE(ce_bf), 
				.BYPASS(dummy_in),
				.ACLR(dummy_in),
				.ASET(dummy_in),
				.AINIT(reset),
				.SCLR(nc),
				.SSET(nc),
				.SINIT(nc),
				.A_SIGNED(logic1),
				.B_SIGNED(logic1),
				.OVFL(open_ovfl_1),
				.C_OUT(open_c_out_1),
				.B_OUT(open_b_out_1),
				.Q_OVFL(open_q_ovfl_1),
				.Q_C_OUT(open_q_c_out_1),
				.Q_B_OUT(open_q_b_out_1),
				.S(open_s_1),
				.Q (y0i_pre_delay));
 


assign y0r_pre_delay_s_ext[B+1] = y0r_pre_delay[B];
assign y0r_pre_delay_s_ext[B:0] = y0r_pre_delay;

assign y0i_pre_delay_s_ext[B+1] = y0i_pre_delay[B];
assign y0i_pre_delay_s_ext[B:0] = y0i_pre_delay;

 C_SHIFT_RAM_V2_0 # (1,
                     ainit_val,
                     0,
                     1,
                     delay_upper_arm_by,
                     1,
                     0,
                     0,
                     1,
                     0,
                     0,
                     1,
                     0,
                     1,
                     0,
                     0,
                     1,
                     0,
                     0,
                     0,
                     "",
                     0,
                     1,
                     B+2
                     )

 
delay_upper_arm_re  (.A(dummy_addr),
                     .D(y0r_pre_delay_s_ext),
                     .CLK(clk),
                     .CE(ce_bf),
                     .ACLR(reset),
                     .ASET(dummy_in),
		     .AINIT(dummy_in),
		     .SCLR(dummy_in),
		     .SSET(dummy_in),
		     .SINIT(start),
                     .Q(int_y0r)
                    );


 C_SHIFT_RAM_V2_0 # (1,
                     ainit_val,
                     0,
                     1,
                     delay_upper_arm_by,
                     1,
                     0,
                     0,
                     1,
                     0,
                     0,
                     1,
                     0,
                     1,
                     0,
                     0,
                     1,
                     0,
                     0,
                     0,
                     "",
                     0,
                     1,
                     B+2
                     )

 delay_upper_arm_im (.A(dummy_addr),
                     .D(y0i_pre_delay_s_ext),
                     .CLK(clk),
                     .CE(ce_bf),
                     .ACLR(reset),
                     .ASET(dummy_in),
		     .AINIT(dummy_in),
		     .SCLR(dummy_in),
		     .SSET(dummy_in),
		     .SINIT(start),
                     .Q(int_y0i)
                    );



C_ADDSUB_V2_0 # (1,
                  "",
                  0,
                  B,
                  0,
                  0,
                  0,
                  0,
                  " ",
                  B,
                  1,
                  0,
                  0,
                  1,
                  0,
                  1,
                  0,
                  1,
                  0,
                  1,
                  1,
                  0,
                  0,
                  0,
                  1,
                  0,
                  0,
                  0,
                  0,
                  0,
                  0,
                  0,
                  B,
                  0,
                  B+1,
                  1,
    		  
                  "",
                  0,
                  1)

lower_arm_subtr_re             (.A (x0r), 
				.B(x1r), 
				.CLK (clk),
				.ADD (dummy_in),
				.C_IN(dummy_in),
				.B_IN(logic1),
				.CE(ce_bf), 
				.BYPASS(dummy_in),
				.ACLR(dummy_in),
				.ASET(nc),
				.AINIT(reset),
				.SCLR(nc),
				.SSET(nc),
				.SINIT(nc),
				.A_SIGNED(logic1),
				.B_SIGNED(logic1),
				.OVFL(open_ovfl_2),
				.C_OUT(open_c_out_2),
				.B_OUT(open_b_out_2),
				.Q_OVFL(open_q_ovfl_2),
				.Q_C_OUT(open_q_c_out_2),
				.Q_B_OUT(open_q_b_out_2),
				.S(open_s_2),
				.Q (sub_to_mult_r));
 


 C_ADDSUB_V2_0 # (1,
                  "",
                  0,
                  B,
                  0,
                  0,
                  0,
                  0,
                  " ",
                  B,
                  1,
                  0,
                  0,
                  1,
                  0,
                  1,
                  0,
                  1,
                  0,
                  1,
                  1,
                  0,
                  0,
                  0,
                  1,
                  0,
                  0,
                  0,
                  0,
                  0,
                  0,
                  0,
                  B,
                  0,
                  B+1,
                  1,
    		  
                  "",
                  0,
                  1)


lower_arm_subtr_im             (.A (x0i), 
				.B(x1i), 
				.CLK (clk),
				.ADD (dummy_in),
				.C_IN(dummy_in),
				.B_IN(logic1),
				.CE(ce_bf), 
				.BYPASS(dummy_in),
				.ACLR(dummy_in),
				.ASET(dummy_in),
				.AINIT(reset),
				.SCLR(nc),
				.SSET(nc),
				.SINIT(nc),
				.A_SIGNED(logic1),
				.B_SIGNED(logic1),
				.OVFL(open_ovfl_3),
				.C_OUT(open_c_out_3),
				.B_OUT(open_b_out_3),
				.Q_OVFL(open_q_ovfl_3),
				.Q_C_OUT(open_q_c_out_3),
				.Q_B_OUT(open_q_b_out_3),
				.S(open_s_3),
				.Q (sub_to_mult_i));


vfft32_complex_mult_v2_0 # (B+1,
                            W_WIDTH
                            )

 mult               (.ar(sub_to_mult_r),
		     .ai(sub_to_mult_i),
		     .br(wr),
		     .bi(wi),
		     .clk(clk),
		     .ce(ce_bf),
		     .reset(reset),
		     .start(start),
		     .p_re(p_re_full_precision),  				                                        
                     .p_im(p_im_full_precision)
                     ); 			

assign p_re_temp_0scaled = p_re_full_precision[result:0];
assign p_im_temp_0scaled = p_im_full_precision[result:0];

assign p_re_temp_1scaled = p_re_full_precision[result+1:0];
assign p_im_temp_1scaled = p_im_full_precision[result+1:0];

assign p_re_temp_2scaled = p_re_full_precision[result+2:0];
assign p_im_temp_2scaled = p_im_full_precision[result+2:0];

assign y0r_scale0[B-1:0] =  int_y0r[B-1:0];
assign y0i_scale0[B-1:0] =  int_y0i[B-1:0];
assign y1r_scale0[B-1:0] = p_re_temp_0scaled[result:diff0+1];
assign y1i_scale0[B-1:0]=  p_im_temp_0scaled[result:diff0+1];

assign y0r_scale1[B-1:0] = int_y0r[B:1];
assign y0i_scale1[B-1:0] = int_y0i[B:1];
assign y1r_scale1[B-1:0] =  p_re_temp_1scaled[result+1:diff0+2];
assign y1i_scale1[B-1:0] =  p_im_temp_1scaled[result+1:diff0+2];

assign y0r_scale2[B-1:0] = int_y0r[B+1:2];
assign y0i_scale2[B-1:0] = int_y0i[B+1:2];
assign y1r_scale2[B-1:0] = p_re_temp_2scaled[result+2:diff0+3];
assign y1i_scale2[B-1:0] = p_im_temp_2scaled[result+2:diff0+3];

//overflow scale 0

     
always @ (p_re_full_precision or p_re_temp_0scaled)

begin: loop1

integer i;

for (i = xmul_full_pr_width-1; i >= result+1; i=i-1)

begin
 
#1 ovflo_0_int[i] = p_re_full_precision[i] ^ p_re_temp_0scaled[result];

end

end

always @ (ovflo_0_int)

begin: loop11

#1 or_out_0[result+2] = ovflo_0_int[result+1] || ovflo_0_int[result+2];

end

always @ (posedge clk)

begin: loop2

integer i;

for (i = xmul_full_pr_width-1; i >= result+3; i = i-1)

begin
 
or_out_0[i] = or_out_0[i-1] || ovflo_0_int[i];

end

end

 
vfft32_srflop_v2_0 ovfl_gen_0 (.clk(clk),
		    .ce(ce),
		    .set(or_out_0[xmul_full_pr_width-1]),
		    .reset(done_or_start),
		    .q(ovflo_0_re)
                    );

//overflow scale 1

always @ (p_re_full_precision or p_re_temp_1scaled)

begin: loop3

integer i;

for (i = xmul_full_pr_width-1; i >= result+2; i = i-1)

begin
 
#1 ovflo_1_int[i] = p_re_full_precision[i] ^ p_re_temp_1scaled[result+1];

end

end

always @ (ovflo_1_int)

begin: loop12

#1 or_out_1[result+3] = ovflo_1_int[result+2] || ovflo_1_int[result+3];

end

always @ (or_out_1 or ovflo_1_int)

begin: loop4

integer i;

for (i = xmul_full_pr_width-1; i >= result+4; i = i-1)

begin
 
#1 or_out_1[i] = or_out_1[i-1] || ovflo_1_int[i];

end

end
 
vfft32_srflop_v2_0 ovfl_gen_1 (.clk(clk),
		    .ce(ce),
		    .set(or_out_1[xmul_full_pr_width-1]),
		    .reset(done_or_start),
		    .q(ovflo_1_re)
                    );

//overflow scale 2


always @ (p_re_full_precision or p_re_temp_2scaled)

begin: loop5

integer i;

for (i = xmul_full_pr_width-1; i >= result+3; i = i-1)

begin
 
#1 ovflo_2_int[i] = p_re_full_precision[i] ^ p_re_temp_2scaled[result+2];

end

end

always @ (ovflo_1_int or ovflo_2_int)

begin: loop13

#1 or_out_2[result+4] = ovflo_1_int[result+3] || ovflo_2_int[result+4];

end

always @ (or_out_2 or ovflo_2_int)

begin: loop6

integer i;

for (i = xmul_full_pr_width-1; i >= result+5; i = i-1)

begin
 
#1 or_out_2[i] = or_out_2[i-1] || ovflo_2_int[i];

end

end
 
vfft32_srflop_v2_0 ovfl_gen_2 (.clk(clk),
		    .ce(ce),
		    .set(or_out_2[xmul_full_pr_width-1]),
		    .reset(done_or_start),
		    .q(ovflo_2_re)
                    );

// Imaginary
//overflow scale 0

always @ (p_im_full_precision or p_im_temp_0scaled)

begin: loop_im1

integer i;

for (i = xmul_full_pr_width-1; i >= result+1; i = i-1)

begin
 
#1 ovflo_0_int_im[i] = p_im_full_precision[i] ^ p_im_temp_0scaled[result];

end

end

always @ (ovflo_0_int_im)

begin: loop14

#1 or_out_0_im[result+2] = ovflo_0_int_im[result+1] || ovflo_0_int_im[result+2];

end


always @ (posedge clk)

begin: loop_im2

integer i;

for (i = xmul_full_pr_width-1; i >= result+3; i = i-1)

begin
 
#1 or_out_0_im[i] = or_out_0_im[i-1] || ovflo_0_int_im[i];

end

end
 
vfft32_srflop_v2_0 ovfl_gen_0_im (.clk(clk),
		    .ce(ce),
		    .set(or_out_0_im[xmul_full_pr_width-1]),
		    .reset(done_or_start),
		    .q(ovflo_0_im)
                    );

//imaginary - overflow scale1

always @ (p_im_full_precision or p_im_temp_1scaled)

begin: loop_im3

integer i;

for (i = xmul_full_pr_width-1; i >= result+2; i = i-1)

begin
 
#1 ovflo_1_int_im[i] = p_im_full_precision[i] ^ p_im_temp_1scaled[result+1];

end

end

always @ (ovflo_1_int_im)

begin: loop15

#1 or_out_1_im[result+3] = ovflo_1_int_im[result+2] || ovflo_1_int_im[result+3];

end


always @ (or_out_1_im or ovflo_1_int_im)

begin: loop_im4

integer i;

for (i = xmul_full_pr_width-1; i >= result+4; i = i-1)

begin
 
#1 or_out_1_im[i] = or_out_1_im[i-1] || ovflo_1_int_im[i];

end

end

 
vfft32_srflop_v2_0 ovfl_gen_1_im (.clk(clk),
		    .ce(ce),
		    .set(or_out_1_im[xmul_full_pr_width-1]),
		    .reset(done_or_start),
		    .q(ovflo_1_im)
                    );

// Imaginary - ovflo scale 2

always @ (p_im_full_precision or p_im_temp_2scaled)

begin: loop_im5

integer i;

for ( i = xmul_full_pr_width-1; i >= result+3; i = i-1)

begin
 
#1 ovflo_2_int_im[i] = p_im_full_precision[i] ^ p_im_temp_2scaled[result+1];

end

end


always @ (ovflo_1_int_im or ovflo_2_int_im)

begin: loop16

#1 or_out_2_im[result+4] = ovflo_1_int_im[result+3] || ovflo_2_int_im[result+4];

end


always @ (or_out_2_im or ovflo_2_int_im)

begin: loop_im6

integer i;

for ( i = xmul_full_pr_width-1; i >= result+5; i = i-1)

begin
 
#1 or_out_2_im[i] = or_out_2_im[i-1] || ovflo_2_int_im[i];

end

end
 
vfft32_srflop_v2_0 ovfl_gen_2_im (.clk(clk),
		    .ce(ce),
		    .set(or_out_2_im[xmul_full_pr_width-1]),
		    .reset(done_or_start),
		    .q(ovflo_2_im)
                    );




//or_a_b or_gen (.a_in(or_out_0(i-1)),
//		 .b_in(ovflo_0_int(i)),
//	 .or_out(or_out_0(i))
 //                );
//

vfft32_or_a_b_v2_0 or_sc0  (.a_in(ovflo_0_re),
		  .b_in(ovflo_0_im),
		  .or_out(ovflo_0_re_or_im));

vfft32_or_a_b_v2_0 or_sc1(.a_in(ovflo_1_re),
	        .b_in(ovflo_1_im),
	        .or_out(ovflo_1_re_or_im));

vfft32_or_a_b_v2_0 or_sc2 (.a_in(ovflo_2_re),
		 .b_in(ovflo_2_im),
		 .or_out(ovflo_2_re_or_im));



 C_MUX_BUS_V2_0 #("",
                  1,
                  0,
                  0,
                  0,
                  0,
                  0,
                  1,
                  0,
                  0,
                  0,
                  0,
                  3,
                  0,
                  2,
                  "",
                  0,
                  1,
                  B)    
                  
scaled_result_mux_y0r (.MA (y0r_scale0), 
		    .MB (y0r_scale1), 
		   .MC (y0r_scale2),
		   .MD (dummy_mux_inputs),
		   .ME (dummy_mux_inputs),
		   .MF (dummy_mux_inputs),
		   .MG (dummy_mux_inputs),
	           .MH (dummy_mux_inputs),
		   .S  (mux_select),
		   .CLK (dummy_in),
		   .CE 	(dummy_in), 		   
                   .EN 	(dummy_in),  
		   .ASET (dummy_in), 
		   .ACLR (dummy_in),
		   .AINIT (dummy_in),		   
                   .SSET (dummy_in), 		   
                   .SCLR (dummy_in),
		   .SINIT (dummy_in),	
		   .O (y0r),
		   .Q (open_q_r));

 
C_MUX_BUS_V2_0 #("",
                  1,
                  0,
                  0,
                  0,
                  0,
                  0,
                  1,
                  0,
                  0,
                  0,
                  0,
                  3,
                  0,
                  2,
                  "",
                  0,
                  1,
                  B)    
                  
scaled_result_mux_y0i (.MA (y0i_scale0), 
		    .MB (y0i_scale1), 
		   .MC (y0i_scale2),
		   .MD (dummy_mux_inputs),
		   .ME (dummy_mux_inputs),
		   .MF (dummy_mux_inputs),
		   .MG (dummy_mux_inputs),
	           .MH (dummy_mux_inputs),
		   .S  (mux_select),
		   .CLK (dummy_in),
		   .CE 	(dummy_in), 		   
                   .EN 	(dummy_in),  
		   .ASET (dummy_in), 
		   .ACLR (dummy_in),
		   .AINIT (dummy_in),		   
                   .SSET (dummy_in), 		   
                   .SCLR (dummy_in),
		   .SINIT (dummy_in),	
		   .O (y0i),
		   .Q (open_q_i));

 
C_MUX_BUS_V2_0 #("",
                  1,
                  0,
                  0,
                  0,
                  0,
                  0,
                  1,
                  0,
                  0,
                  0,
                  0,
                  3,
                  0,
                  2,
                  "",
                  0,
                  1,
                  B)    
                  
scaled_result_mux_y1r (.MA (y1r_scale0), 
		   .MB (y1r_scale1), 
		   .MC (y1r_scale2),
		   .MD (dummy_mux_inputs),
		   .ME (dummy_mux_inputs),
		   .MF (dummy_mux_inputs),
		   .MG (dummy_mux_inputs),
	           .MH (dummy_mux_inputs),
		   .S  (mux_select),
		   .CLK (dummy_in),
		   .CE 	(dummy_in), 		   
                   .EN 	(dummy_in),  
		   .ASET (dummy_in), 
		   .ACLR (dummy_in),
		   .AINIT (dummy_in),		   
                   .SSET (dummy_in), 		   
                   .SCLR (dummy_in),
		   .SINIT (dummy_in),	
		   .O (y1r),
		   .Q (open_q_r));

 
C_MUX_BUS_V2_0 #("",
                  1,
                  0,
                  0,
                  0,
                  0,
                  0,
                  1,
                  0,
                  0,
                  0,
                  0,
                  3,
                  0,
                  2,
                  "",
                  0,
                  1,
                  B)    
                  
scaled_result_mux_y1i (.MA (y1i_scale0), 
		    .MB (y1i_scale1), 
		   .MC (y1i_scale2),
		   .MD (dummy_mux_inputs),
		   .ME (dummy_mux_inputs),
		   .MF (dummy_mux_inputs),
		   .MG (dummy_mux_inputs),
	           .MH (dummy_mux_inputs),
		   .S  (mux_select),
		   .CLK (dummy_in),
		   .CE 	(dummy_in), 		   
                   .EN 	(dummy_in),  
		   .ASET (dummy_in), 
		   .ACLR (dummy_in),
		   .AINIT (dummy_in),		   
                   .SSET (dummy_in), 		   
                   .SCLR (dummy_in),
		   .SINIT (dummy_in),	
		   .O (y1i),
		   .Q (open_q_i));


 
C_MUX_BUS_V2_0 #("",
                  1,
                  0,
                  0,
                  0,
                  0,
                  0,
                  1,
                  0,
                  0,
                  0,
                  0,
                  3,
                  0,
                  2,
                  "",
                  0,
                  1,
                  B)    
                  
ovflo_mux         (.MA (ovflo_0_temp_re_or_im), 
		   .MB (ovflo_1_temp_re_or_im), 
		   .MC (ovflo_2_temp_re_or_im),
		   .MD (dummy_mux_inputs),
		   .ME (dummy_mux_inputs),
		   .MF (dummy_mux_inputs),
		   .MG (dummy_mux_inputs),
	           .MH (dummy_mux_inputs),
		   .S  (mux_select),
		   .CLK (dummy_in),
		   .CE 	(dummy_in), 		   
                   .EN 	(dummy_in),  
		   .ASET (dummy_in), 
		   .ACLR (done_or_start),
		   .AINIT (dummy_in),		   
                   .SSET (dummy_in), 		   
                   .SCLR (dummy_in),
		   .SINIT (dummy_in),	
		   .O (ovflo_temp),
		   .Q (open_q_ovflo));

always @ (posedge clk)

begin

if (ovflo_temp == 1)

ovflo_temp_set =  1;

else

ovflo_temp_set = 0;

end


vfft32_srflop_v2_0 ovfl_gen (.clk(clk),
                 .ce(ce),
                 .set(ovflo_temp_set),
                 .reset(start),
                 .q(ovflo)
                 );


assign done_or_start = (memory_architecture == 1) ? start : done_or_start_sig;

assign done_or_start_sig = done || start;


endmodule


//******************************************************************************

//******************************************************************************






















   
//******************************************************************************

//******************************************************************************


module vfft32_fft4_32_v2_0 (clk, reset, start, ce, conj, scale_rank3_by, scale_rank4_by, x0r, x0i, x1r, x1i, x2r, x2i, x3r, x3i, y0r, y0i, y1r, y1i, y2r, y2i, y3r, y3i);

parameter B= 16;

input clk;
input reset;
input start;
input ce;
input conj;
input [1:0] scale_rank3_by;
input [1:0] scale_rank4_by;
input [B-1:0] x0r;
input [B-1:0] x0i;
input [B-1:0] x1r;
input [B-1:0] x1i;
input [B-1:0] x2r;
input [B-1:0] x2i;
input [B-1:0] x3r;
input [B-1:0] x3i;

output [B-1:0] y0r;
output [B-1:0] y0i;
output [B-1:0] y1r;
output [B-1:0] y1i;
output [B-1:0] y2r;
output [B-1:0] y2i;
output [B-1:0] y3r;
output [B-1:0] y3i;



wire start_fft4;
wire [B-1:0]x0r_regc;	
wire [B-1:0]x0i_regc; 
wire [B-1:0]x1r_regc; 
wire [B-1:0]x1i_regc; 
wire [B-1:0]x2r_regc; 
wire [B-1:0]x2i_regc; 
wire [B-1:0]x3r_regc; 
wire [B-1:0]x3i_regc; 
		
// registered outputs for butterfly #0

wire [B-1:0]b0_y0r;
wire [B-1:0]b0_y0i;
wire [B-1:0]b0_y1r;
wire [B-1:0]b0_y1i;
		
// registered output for butterfly #1

wire [B-1:0]b1_y0r;
wire [B-1:0]b1_y0i;
wire [B-1:0]b1_y1r;
wire [B-1:0]b1_y1i;
		
// registered output for butterfly #2

wire conji;
wire logic0 = 1'b0;
wire dummy_in = 1'b0;

wire ce0;		//sample reg. ld enables
wire ce1;
wire ce2;
wire ce3;
wire [3:0]cex0x1x2x3;
wire cex0;		//sample reg. ld enables
wire cex1;
wire cex2;
wire cex3;



wire [B-1:0]y0r_preconj;
wire [B-1:0]y0i_preconj;
wire [B-1:0]y1r_preconj;
wire [B-1:0]y1i_preconj;
wire [B-1:0]y2r_preconj;
wire [B-1:0]y2i_preconj;
wire [B-1:0]y3r_preconj;
wire [B-1:0]y3i_preconj;

wire [B-1:0]b0_y0r_preconj;
wire [B-1:0]b0_y0i_preconj;
wire [B-1:0]b0_y1r_preconj;
wire [B-1:0]b0_y1i_preconj;

wire [B-1:0]b1_y0r_preconj;
wire [B-1:0]b1_y0i_preconj;
wire [B-1:0]b1_y1r_preconj;
wire [B-1:0]b1_y1i_preconj;

// complex conjugation. Instantiated 4 times. Each instance is gated off a 
// separate clock enable. This is to be able to read in the 4 different 
// pieces of data from memory. The clock enable distribution is controlled 
// by the state machine.
// Complex conjugation is to support inverse transforms controlled by 
// the conj pin. When the inverse transform is reqd., the imaginary part
// is two's complemented and the real part is simply registered. When inverse
// transform is not reqd., both real and imaginary parts are registered.

vfft32_nand_a_b_v2_0 inv_gen (.a_in(conj),
                  .b_in(conj),
                  .nand_out(conji));


vfft32_bflyw0_v2_0 # (B)
	
            b0 ( 
	        .x0r(x0r),
		.x0i(x0i),		
                .x1r(x2r),
		.x1i(x2i),
		.clk(clk),		
		.ce(ce),		
		.start(start_fft4),
		.reset(reset),
		.scale_by(scale_rank3_by),
		.y0r(b0_y0r_preconj),
		.y0i(b0_y0i_preconj),	
		.y1r(b0_y1r_preconj),	
		.y1i(b0_y1i_preconj)
	        );

vfft32_bflyw_j_v2_0 # (B)
	
            b1 ( 
	        .x0r(x1r),
		.x0i(x1i),		
                .x1r(x3r),
		.x1i(x3i),
		.clk(clk),		
		.ce(ce),		
		.start(start_fft4),
		.reset(reset),
		.scale_by(scale_rank3_by),
		.y0r(b1_y0r_preconj),
		.y0i(b1_y0i_preconj),	
		.y1r(b1_y1r_preconj),	
		.y1i(b1_y1i_preconj)
	        );


vfft32_bflyw0_v2_0 # (B)
	
            b2 ( 
	        .x0r(b0_y0r_preconj),
		.x0i(b0_y0i_preconj),		
                .x1r(b1_y0r_preconj),
		.x1i(b1_y0i_preconj),
		.clk(clk),		
		.ce(ce),		
		.start(start_fft4),
		.reset(reset),
		.scale_by(scale_rank4_by),
		.y0r(y0r),
		.y0i(y0i),	
		.y1r(y1r),	
		.y1i(y1i)
	        );

vfft32_bflyw0_v2_0 # (B)
	
            b3 ( 
	        .x0r(b0_y1r_preconj),
		.x0i(b0_y1i_preconj),		
                .x1r(b1_y1r_preconj),
		.x1i(b1_y1i_preconj),
		.clk(clk),		
		.ce(ce),		
		.start(start_fft4),
		.reset(reset),
		.scale_by(scale_rank4_by),
		.y0r(y2r),
		.y0i(y2i),	
		.y1r(y3r),	
		.y1i(y3i)
	        );

		
vfft32_state_machine_v2_0 # (4)
	
smach (.clk(clk),
	       .ce(ce),
	       .start(start),
	       .reset(reset),
	       .s(cex0x1x2x3)
               );


	assign cex0 = cex0x1x2x3[3];
	assign cex1 = cex0x1x2x3[2];
	assign cex2 = cex0x1x2x3[1];
	assign cex3 = cex0x1x2x3[0];


vfft32_and_a_b_v2_0 gen_start (.a_in(ce),
		    .b_in(cex0),
		    .and_out(start_fft4)
                    );

vfft32_and_a_b_v2_0 gen_ce0 (.a_in(ce),
		    .b_in(cex0),
		    .and_out(ce0)
                    );

vfft32_and_a_b_v2_0 gen_ce1 (.a_in(ce),
		    .b_in(cex1),
		    .and_out(ce1)
                    );

vfft32_and_a_b_v2_0 gen_ce2 (.a_in(ce),
		    .b_in(cex2),
		    .and_out(ce2)
                    );

vfft32_and_a_b_v2_0 gen_ce3 (.a_in(ce),
		    .b_in(cex3),
		    .and_out(ce3)
                    );
endmodule

//******************************************************************************

//******************************************************************************







//******************************************************************************

//******************************************************************************

module vfft32_addr_gen_v2_0 (clk, ce, reset, start, io_pulse, delayed_io_pulse_out, address, rank_number);

parameter points_power = 5;
parameter memory_architecture = 1;

input clk;
input ce;
input reset;
input start;
input io_pulse;
output [points_power-1:0] address;
output [1:0] rank_number;
output delayed_io_pulse_out;

parameter ainit_val = "00000";
parameter rank_ctr_ainit_val = "00";
parameter thirty_one = "11111";
parameter counter_width = points_power;
parameter rank_counter_width = 2;
parameter three = "11";
parameter one_string = "00001";
parameter one_string_1 = "01";
parameter two = "10";

parameter ascii_zero = 8'b00110000;
parameter ascii_ainit_val = {5{ascii_zero}};
parameter ascii_sinit_val = {5{ascii_zero}};

reg [counter_width-1:0] b;
wire [rank_counter_width-1:0] rank_count;

reg [rank_counter_width-1:0] rank_count_dms;
reg [rank_counter_width-1:0] rank_count_tms_sms;

wire dummy_in= 1'b0;
wire logic_1= 1'b1;

wire open_thresh0;
wire open_q_thresh0;
wire open_thresh1;
wire open_q_thresh1; 
wire open_q_thresh0_1; 
wire open_thresh1_1; 
wire open_q_thresh1_1; 

wire [counter_width-1:0] one; 
wire [counter_width-1:0] zero;
assign one = 5'b1;
assign zero[counter_width-1:0] = 1'b0;

wire [rank_counter_width-1:0] rank_ctr_one;
wire [rank_counter_width-1:0] rank_ctr_zero;
assign rank_ctr_one = 2'b1;
assign rank_ctr_zero[rank_counter_width-1:0] = 1'b0;
reg rank_counter_enable;

wire or_rank_number;
wire or_rank_num_temp; 
 
wire open_q; 
wire open_q_1;
wire open_q_2;

wire [1:0] b0b3;
wire [2:0] b3b0b4;
wire [1:0] b4b0;
wire rank_count_1;
wire [4:0] r02address;
wire [4:0] rank3_address;
wire sel_rank3;
wire sel_rank3_temp;

wire open_thresh0_2;
wire open_q_thresh0_2;
wire open_thresh1_2;
wire open_q_thresh1_2;

reg rank_counter_enable_or_start;
reg start_or_delayed_io_pulse;

wire io_pulse_temp;

wire delayed_io_pulse_temp;
wire delayed_io_pulse_temp1;
reg delayed_io_pulse_temp_dms1;
wire delayed_io_pulse_temp_dms;

wire delayed_io_pulse;
wire delayed_io_pulse_out;

wire dummy_addr;

assign b0b3[1] = b[0];
assign b0b3[0] = b[3];

assign b3b0b4[2] = b[3];
assign b3b0b4[1] = b[0];
assign b3b0b4[0] = b[4];

assign b4b0[1] = b[4];
assign b4b0[0] = b[0];

assign sel_rank3 = sel_rank3_temp;
assign address = r02address;

//tms mode/sms mode        


always @ (posedge clk)
			        				
begin

if (reset)

b = 0;

else if (start)

#2 b = 0;

else if (~ce)

b = 0;

else if (memory_architecture == 1)

#2 b = b + 1;

end

always @ (posedge clk)
			        				
begin

if (reset)

b = 0;

else if (start)

#2 b = 0;

else if (~ce)

b = 0;

else if (memory_architecture == 3)

#2 b = b + 1;

end

always @ (posedge clk)

begin

if (b == 30)

#1 rank_counter_enable = 1'b1;

else

#1 rank_counter_enable = 0;

end
		

always @ (rank_counter_enable or start)

begin

if (memory_architecture == 1)

#1 rank_counter_enable_or_start = rank_counter_enable || start;

else if (memory_architecture == 3)

#1 rank_counter_enable_or_start = rank_counter_enable || start;

end


always @ (posedge clk)

begin

if (reset)

rank_count_tms_sms = 0;

else if (start)

rank_count_tms_sms = 0;

else if (rank_counter_enable_or_start == 1)

 begin

  if (rank_count <= 1)

   #2 rank_count_tms_sms = rank_count_tms_sms + 1;

  else

   #2 rank_count_tms_sms = 0;

 end

end


assign rank_count = (memory_architecture == 2) ? rank_count_dms : rank_count_tms_sms;


// dms mode



assign delayed_io_pulse = (memory_architecture == 2) ? delayed_io_pulse_temp : 0;

assign io_pulse_temp = (memory_architecture == 2) ? io_pulse : 0;

assign delayed_io_pulse_out = (memory_architecture == 2) ? delayed_io_pulse : 0;


vfft32_delay_wrapper_v2_0 # (1, 30, 1)


delay_io_pulse_gen      (.addr(dummy_addr),
 			 .data(io_pulse_temp),
 			 .clk(clk),
 			 .reset(reset),
 			 .start(start),
 			 .delayed_data(delayed_io_pulse_temp));




always @ (start or delayed_io_pulse)

begin

if (memory_architecture == 2)

#1 start_or_delayed_io_pulse = start || delayed_io_pulse;

end

always @ (posedge clk)
			        				
begin

if (reset)

b = 0;

else if (start_or_delayed_io_pulse)

#2 b = 0;

else if (~ce)

b = 0;

else if (memory_architecture == 2)

#2 b = b + 1;
 
end

always @ (posedge clk)
			        				
begin

if (reset)

rank_count_dms = 0;

else if (start_or_delayed_io_pulse)

rank_count_dms = 0;

//else if (~rank_counter_enable_or_start)

//rank_count_dms = rank_count_dms;

else if (rank_counter_enable_or_start)

 begin
    
     if (memory_architecture == 2)
  
      begin

        if (rank_count_dms <= 1)

          #2 rank_count_dms = rank_count_dms + 1;
        
        else if (rank_count_dms == 2)
        
         #2 rank_count_dms = 0;

      end

  end

end

always @ (rank_counter_enable or start_or_delayed_io_pulse)

begin

if (memory_architecture == 2)

#1 rank_counter_enable_or_start = rank_counter_enable || start_or_delayed_io_pulse;

end


C_MUX_BIT_V2_0 #  ("",
                    1,
                    0,
                    0,
                    0,
                    0,
                    1,
                    0,
                    0,
                    0,
                    0,
                    2,
                    1,
                    "",
                    0,
                    1,
                    0)



address2_mux                     (.M(b0b3),
			          .S(rank_count_1), 
	                          .CLK(clk),
                                  .CE(logic_1),
	                          .AINIT(dummy_in),
	                          .ASET(dummy_in),
	                          .ACLR(dummy_in),
	                          .SINIT(dummy_in),
	                          .SSET(dummy_in),
	                          .SCLR(dummy_in),
	                          .O(r02address[2]),
	                          .Q(open_q));

			
C_MUX_BIT_V2_0 #  ("",
                    1,
                    0,
                    0,
                    0,
                    0,
                    1,
                    0,
                    0,
                    0,
                    0,
                    3,
                    2,
                    "",
                    0,
                    1,
                    0)



 address3_mux                    (.M(b3b0b4),
			          .S(rank_count), 
	                          .CLK(clk),
                                  .CE(logic_1),
	                          .AINIT(dummy_in),
	                          .ASET(dummy_in),
	                          .ACLR(dummy_in),
	                          .SINIT(dummy_in),
	                          .SSET(dummy_in),
	                          .SCLR(dummy_in),
	                          .O(r02address[3]),
	                          .Q(open_q_1));

C_MUX_BIT_V2_0 #  ("",
                    1,
                    0,
                    0,
                    0,
                    0,
                    1,
                    0,
                    0,
                    0,
                    0,
                    2,
                    1,
                    "",
                    0,
                    1,
                    0)
  


address4_mux                     (.M(b4b0),
			          .S(or_rank_number), 
	                          .CLK(clk),
                                  .CE(logic_1),
	                          .AINIT(dummy_in),
	                          .ASET(dummy_in),
	                          .ACLR(dummy_in),
	                          .SINIT(dummy_in),
	                          .SSET(dummy_in),
	                          .SCLR(dummy_in),
	                          .O(r02address[4]),
	                          .Q(open_q_2));

			
assign r02address[0] = b[1];
assign r02address[1] = b[2];

assign rank_number = rank_count;

vfft32_or_a_b_v2_0	or_rank_count           (.a_in(rank_count[0]),
				 .b_in(rank_count[1]),
				 .or_out(or_rank_num_temp));


assign rank_count_1 = rank_count[1];



vfft32_flip_flop_v2_0  xor_reg    (.d(or_rank_num_temp),
		     	 .clk(clk),
			 .ce(ce),
			 .reset(reset),
			 .q(or_rank_number));

endmodule		

//******************************************************************************

//******************************************************************************

//******************************************************************************

//******************************************************************************
	
module vfft32_phase_factor_adgen_v2_0 (clk, reset, start, ce, fwd_inv, rank_number, w_addr_sine, w_addr_cos);

parameter  W_WIDTH = 16;

input clk;
input reset;
input start;
input ce;
input fwd_inv;
input [1:0] rank_number;
output [4:0] w_addr_sine;
output [3:0] w_addr_cos;

parameter ainit_val = "0000";
parameter sinit_val = "0000";
parameter fifteen = "1111";
parameter sixteen_string = "10000";
parameter zero_string = "00000";

parameter offset_string	= {5{sixteen_string}}; 


wire [3:0] w_addr; 
wire logic0 = 1'b0;
wire logic_1 = 1'b1;
wire dummy_in = 1'b0;

wire open_thresh0;
wire open_q_thresh0;
wire open_thresh1;
wire open_q_thresh1;

wire open_ovfl;
wire open_c_out; 
wire open_b_out; 
wire open_q_ovfl; 
wire open_q_c_out; 
wire open_q_b_out; 
wire [4:0] open_s;  


wire [3:0] addr_to_mux;
wire [3:0] rank1_ph_addr;
wire [3:0] rank2_ph_addr;
wire [3:0] dummy_mux_inputs;
wire [3:0] open_q_0;

wire [3:0] one;
wire [3:0] zero;
wire [4:0] zero_1;
wire [4:0] sixteen;
wire [4:0] offset_value;

assign one = 4'b1;
assign zero = 4'b0;
assign zero_1 = 5'b0;
assign sixteen = 5'b10000;

assign rank1_ph_addr[3:1] = addr_to_mux[2:0];
assign rank1_ph_addr[0] = 1'b0;

assign rank2_ph_addr[3:2] = addr_to_mux[1:0];
assign rank2_ph_addr[1:0] = 1'b0;

assign offset_value[4] = fwd_inv;
assign offset_value[3:0] = 1'b0;


 C_COUNTER_BINARY_V2_0 # (ainit_val,
			 "",
                          0,			
                          "1111111111111111",    
			   1,
			   0,				
                           0, //previously was set to 1.
			   0,										                                
                           1,
                           1,
                           0,
                           1,
                           0,
                           0,
                           0,
                           1,
                           0,
                           1,
                           0,
                           0,
                           1,
                           0,
                           0,
                           0,
                           sinit_val,
                           1,
                           1,
                           fifteen,
                           "1111111111111111",
                           4,
                           1
                            )
 
        addr_gen        (.CLK(clk),
	                  .UP(logic_1),
			  .CE(ce),
			  .LOAD(dummy_in),
			  .L(zero),
			  .IV(one),
			  .ACLR(dummy_in),
			  .ASET(dummy_in),
			  .AINIT(reset),
			  .SCLR(dummy_in),
			  .SINIT(start),
			  .SSET(dummy_in),
			  .THRESH0(open_thresh0),
			  .Q_THRESH0(open_q_thresh0),  
		  	  .THRESH1(open_thresh1),  
		  	  .Q_THRESH1(open_q_thresh1),
			  .Q(addr_to_mux)
                            );


 C_MUX_BUS_V2_0 #("",
                  1,
                  0,
                  0,
                  0,
                  0,
                  0,
                  1,
                  1,
                  0,
                  0,
                  0,
                  3,
                  0,
                  2,
                  "",
                  0,
                  1,
                  4)  

                  addr_mux (.MA(addr_to_mux), 
				.MB(rank1_ph_addr),
				.MC(rank2_ph_addr),
				.MD(dummy_mux_inputs),
				.ME(dummy_mux_inputs),
				.MF(dummy_mux_inputs),
				.MG(dummy_mux_inputs),
				.MH(dummy_mux_inputs),
				.S(rank_number),
		  		.CLK(clk), 
		  		.CE(dummy_in), 
		  		.EN(dummy_in), 
		  		.ASET(dummy_in), 
		  		.ACLR(dummy_in), 
		  		.AINIT(dummy_in), 
		  		.SSET(dummy_in), 
		  		.SCLR(dummy_in), 		
		  		.SINIT(dummy_in),	
				.O(w_addr), 
				.Q(w_addr_cos)
                                );

C_ADDSUB_V2_0 # (0,
                 0,
                 1,
                 4,
                 0,
                 0,
                 0,
                 1,
                 offset_string,
                 5,
                 1,
                 0,
                 0,
                 1,
                 0, 
                 0, 
                 0, 
                 0, 
                 0, 
                 0, 
                 0, 
                 0, 
                 0,
                 0,
                 1,
                 0,
                 0,
                 0,
                 0,
                 1,
                 0,
                 0,
                 4,
                 0,
                 5,
                 1,
                 "0",
                 0,
                 1)

neg_sine_offset                (.A(w_addr), 
				.B(offset_value), 
				.CLK(clk),
				.ADD(dummy_in),
				.C_IN(logic0), 
				.B_IN(logic0),
				.CE(logic0),  				        
                                .BYPASS(dummy_in),
 				.ACLR(dummy_in),
				.ASET(dummy_in),
				.AINIT(reset),
				.SCLR(start),
				.SSET(dummy_in),
				.SINIT(dummy_in),
				.A_SIGNED(logic0),
				.B_SIGNED(logic0),
				.OVFL(open_ovfl),
				.C_OUT(open_c_out),
				.B_OUT(open_b_out),
				.Q_OVFL(open_q_ovfl),
				.Q_C_OUT(open_q_c_out),
				.Q_B_OUT(open_q_b_out),
				.S(open_s),
				.Q(w_addr_sine)
                               );

endmodule


//******************************************************************************

//******************************************************************************






//******************************************************************************

//******************************************************************************

module vfft32_dmem_wkg_r_i_v2_0 (a, we, d_re, d_im, clk, dpra, qdpo_re, qdpo_im);

parameter B = 12;
parameter POINTS_POWER = 5;

input [POINTS_POWER-1:0] a;
input we;
input [B-1:0] d_re;
input [B-1:0] d_im;
input clk;
input [POINTS_POWER-1:0] dpra;

output [B-1:0] qdpo_re;
output [B-1:0] qdpo_im;


wire dummy_in = 1'b0;
wire logic_1 = 1'b1;
wire [POINTS_POWER-1:0] dummy_spra ;
wire [B-1:0] open_spo_re;
wire [B-1:0] open_qspo_re;
wire [B-1:0] open_dpo_re;
wire [B-1:0] open_spo_im;
wire [B-1:0] open_qspo_im;
wire [B-1:0] open_dpo_im;

assign dummy_spra = 0;
assign open_spo_re = 0;
assign open_qspo_re = 0;
assign open_dpo_re = 0;
assign open_spo_im = 0;
assign open_qspo_im = 0;
assign open_dpo_im = 0;



 C_DIST_MEM_V2_0 # (POINTS_POWER,
                    "0",
                     1,
                     32,
                     1,
                     0,
                     1,
                     1,
                     0,
                     1,
                     0,
                     1,
                     0,
                     0,
                     0,
                     0,
                     0,
                     0,
                     0,
                     0,
                     0,
                     1,
                     0, //"null.mif"
                     1,
                     2, //c_dp_ram
                     0, 
                     1,
                     0,
                     0,
                     0,
                     0,
                     0,
                     B 
                     )
  

dis_mem_re (.A(a),
            .D(d_re),
            .DPRA(dpra),
            .SPRA(dummy_spra),
            .CLK(clk),
            .WE(we),
            .I_CE(logic_1),
            .RD_EN(dummy_in),
            .QSPO_CE(logic_1),
            .QDPO_CE(logic_1),
            .QDPO_CLK(dummy_in),
            .QSPO_RST(dummy_in),
            .QDPO_RST(dummy_in),
            .DPO(open_dpo_re),
            .SPO(open_spo_re),
	    .QSPO(open_qspo_re),
	    .QDPO(qdpo_re)
             );

C_DIST_MEM_V2_0 # (POINTS_POWER,
                    "0",
                     1,
                     32,
                     1,
                     0,
                     1,
                     1,
                     0,
                     1,
                     0,
                     1,
                     0,
                     0,
                     0,
                     0,
                     0,
                     0,
                     0,
                     0,
                     0,
                     1,
                     0, //"null.mif"
                     1,
                     2, //c_dp_ram
                     0, 
                     1,
                     0,
                     0,
                     0,
                     0,
                     0,
                     B 
                     )
  
  dis_mem_im (.A(a),
              .D(d_im),
              .DPRA(dpra),
              .SPRA(dummy_spra),
              .CLK(clk),
              .WE(we),
              .I_CE(logic_1),
              .RD_EN(dummy_in),
              .QSPO_CE(logic_1),
              .QDPO_CE(logic_1),
              .QDPO_CLK(dummy_in),
              .QSPO_RST(dummy_in),
              .QDPO_RST(dummy_in),
              .DPO(open_dpo_im),
              .SPO(open_spo_im),
	      .QSPO(open_qspo_im),
	      .QDPO(qdpo_im)
              );


endmodule

//******************************************************************************

//******************************************************************************

//******************************************************************************

//******************************************************************************


module vfft32_mem_wkg_r_i_v2_0 (addra, wea, ena, dia_r, dia_i, reset, clk, addrb, web, enb, dib_r, dib_i, dob_r, dob_i);

parameter B = 12;
parameter POINTS_POWER = 5;

input [POINTS_POWER-1:0] addra;
input [POINTS_POWER-1:0] addrb;
input wea;
input web;
input ena;
input enb;
input reset;
input clk;
input [B-1:0] dia_r;
input [B-1:0] dia_i;
input [B-1:0] dib_r;
input [B-1:0] dib_i;

output [B-1:0] dob_r;
output [B-1:0] dob_i;

//parameter default_data = B-1'b0;
parameter default_data = 8'b00110000;

wire [B-1:0]open_doa_r;
wire [B-1:0]open_doa_i;
wire logic_1= 1'b1;


C_MEM_DP_BLOCK_V1_0  #  (POINTS_POWER,
                         POINTS_POWER,
                         1,
                         1,
                         default_data,
                         32,
                         32,
                         1,
                         1,
                         0,
                         1,
                         1,
                         0,
                         1,
                         1,
                         1,
                         1,
                         1,
                         1,
                         1,
                         0,
                         2,
                         0,
                         0,
                         1,
                         1,
                         1,
                         1,
                         B,
                         B)
		

		
             mem_r	       (.ADDRA(addra), 
				.ADDRB(addrb), 
				.DIA(dia_r), 
				.DIB(dib_r), 
				.CLKA(clk),
				.CLKB(clk),
				.WEA(wea), 
				.WEB(web), 
				.ENA(ena), 
				.ENB(logic_1),
				.RSTA(reset),
				.RSTB(reset),
				.DOA(open_doa_r),
				.DOB(dob_r));

C_MEM_DP_BLOCK_V1_0  #  (POINTS_POWER,
                         POINTS_POWER,
                         1,
                         1,
                         default_data,
                         32,
                         32,
                         1,
                         1,
                         0,
                         1,
                         1,
                         0,
                         1,
                         1,
                         1,
                         1,
                         1,
                         1,
                         1,
                         0,
                         2,
                         0,
                         0,
                         1,
                         1,
                         1,
                         1,
                         B,
                         B)
			
mem_i	                       (.ADDRA(addra), 
				.ADDRB(addrb), 
				.DIA(dia_i), 
				.DIB(dib_i), 
				.CLKA(clk),
				.CLKB(clk),
				.WEA(wea), 
				.WEB(web), 
				.ENA(ena), 
				.ENB(logic_1),
				.RSTA(reset),
				.RSTB(reset),
				.DOA(open_doa_i),
				.DOB(dob_i));


endmodule


//******************************************************************************

//******************************************************************************

//******************************************************************************

//******************************************************************************



module vfft32_bflyw0_v2_0 (x0r, x0i, x1r, x1i, clk, ce, start, reset, scale_by, y0r, y0i, y1r, y1i);
	
parameter bfly_width = 12;

parameter diff_with_0_scaling = 1;

input [bfly_width-1:0] x0r;
input [bfly_width-1:0] x0i;
input [bfly_width-1:0] x1r;
input [bfly_width-1:0] x1i;
input clk;
input ce;
input start;
input reset;
input [1:0] scale_by;
output [bfly_width-1:0] y0r;
output [bfly_width-1:0] y0i;
output [bfly_width-1:0] y1r;
output [bfly_width-1:0] y1i;

wire  [bfly_width:0] y0r_int;
wire  [bfly_width:0] y0i_int;
wire  [bfly_width:0] y1r_int;
wire  [bfly_width:0] y1i_int;

wire   [bfly_width-1:0]  y0r_scale0;
wire   [bfly_width-1:0]  y0i_scale0;
wire   [bfly_width-1:0]  y1r_scale0;
wire   [bfly_width-1:0]  y1i_scale0;
wire   [bfly_width-1:0]  y0r_scale1;
wire   [bfly_width-1:0]  y0i_scale1;
wire   [bfly_width-1:0]  y1r_scale1;
wire   [bfly_width-1:0]  y1i_scale1;

wire logic1 = 1'b1;
wire nc = 1'b0;
wire dummy_in = 1'b0;

wire open_ovfl;
wire open_c_out;
wire open_b_out;
wire open_q_ovfl;
wire open_q_c_out;
wire open_q_b_out;
wire [bfly_width:0] open_s;

wire open_ovfl_1;
wire open_c_out_1;
wire open_b_out_1;
wire open_q_ovfl_1;
wire open_q_c_out_1;
wire open_q_b_out_1;
wire [bfly_width:0] open_s_1;

wire open_ovfl_2;
wire open_c_out_2;
wire open_b_out_2;
wire open_q_ovfl_2;
wire open_q_c_out_2;
wire open_q_b_out_2;
wire [bfly_width:0] open_s_2;

wire open_ovfl_3;
wire open_c_out_3;
wire open_b_out_3;
wire open_q_ovfl_3;
wire open_q_c_out_3;
wire open_q_b_out_3;
wire [bfly_width:0] open_s_3;
wire [bfly_width-1:0] dummy_mux_inputs;
wire [bfly_width-1:0] open_q_r;
wire [bfly_width-1:0] open_q_i;

wire mux_select = scale_by[0];


//wire dummy_mux_inputs = 1'b0;


 C_ADDSUB_V2_0 # (0,
                  0,
                  0,
                  bfly_width,
                  0,
                  0,
                  0,
                  0,
                  " ",
                  bfly_width,
                  1,
                  0,
                  0,
                  0,
                  0,
                  1,
                  0,
                  0,
                  0,
                  1,
                  1,
                  0,
                  0,
                  0,
                  1,
                  0,
                  0,
                  0,
                  0,
                  0,
                  0,
                  0,
                  bfly_width,
                  0,
                  bfly_width+1,
                  1,
                  0,
                  0,
                  1)
		    
		
upper_arm_adder_re             (.A (x0r), 
				.B (x1r), 
				.CLK (clk),
				.ADD (dummy_in),
				.C_IN(dummy_in),
				.B_IN(dummy_in),
				.CE(ce), 
				.BYPASS(dummy_in),
				.ACLR(dummy_in),
				.ASET(dummy_in),
				.AINIT(reset),
				.SCLR(nc),
				.SSET(nc),
				.SINIT(nc),
				.A_SIGNED(logic1),
				.B_SIGNED(logic1),
				.OVFL(open_ovfl),
				.C_OUT(open_c_out),
				.B_OUT(open_b_out),
				.Q_OVFL(open_q_ovfl),
				.Q_C_OUT(open_q_c_out),
				.Q_B_OUT(open_q_b_out),
				.S(open_s),
				.Q (y0r_int));
 

 C_ADDSUB_V2_0 # (0,
                  0,
                  0,
                  bfly_width,
                  0,
                  0,
                  0,
                  0,
                  " ",
                  bfly_width,
                  1,
                  0,
                  0,
                  1,
                  0,
                  1,
                  0,
                  0,
                  0,
                  1,
                  1,
                  0,
                  0,
                  0,
                  1,
                  0,
                  0,
                  0,
                  0,
                  0,
                  0,
                  0,
                  bfly_width,
                  0,
                  bfly_width+1,
                  1,
                  0,
                  0,
                  1)
		    

 upper_arm_adder_im            (.A (x0i), 
				.B(x1i), 
				.CLK (clk),
				.ADD (dummy_in),
				.C_IN(dummy_in),
				.B_IN(dummy_in),
				.CE(ce), 
				.BYPASS(dummy_in),
				.ACLR(dummy_in),
				.ASET(dummy_in),
				.AINIT(reset),
				.SCLR(nc),
				.SSET(nc),
				.SINIT(nc),
				.A_SIGNED(logic1),
				.B_SIGNED(logic1),
				.OVFL(open_ovfl_1),
				.C_OUT(open_c_out_1),
				.B_OUT(open_b_out_1),
				.Q_OVFL(open_q_ovfl_1),
				.Q_C_OUT(open_q_c_out_1),
				.Q_B_OUT(open_q_b_out_1),
				.S(open_s_1),
				.Q (y0i_int));
 
 C_ADDSUB_V2_0 # (1,
                  0,
                  0,
                  bfly_width,
                  0,
                  0,
                  0,
                  0,
                  " ",
                  bfly_width,
                  1,
                  0,
                  0,
                  1,
                  0,
                  1,
                  0,
                  1,
                  0,
                  1,
                  1,
                  0,
                  0,
                  0,
                  1,
                  0,
                  0,
                  0,
                  0,
                  0,
                  0,
                  0,
                  bfly_width,
                  0,
                  bfly_width+1,
                  1,
                  0,
                  0,
                  1)

lower_arm_subtr_re             (.A (x0r), 
				.B(x1r), 
				.CLK (clk),
				.ADD (dummy_in),
				.C_IN(dummy_in),
				.B_IN(logic1),
				.CE(ce), 
				.BYPASS(dummy_in),
				.ACLR(dummy_in),
				.ASET(nc),
				.AINIT(reset),
				.SCLR(nc),
				.SSET(nc),
				.SINIT(nc),
				.A_SIGNED(logic1),
				.B_SIGNED(logic1),
				.OVFL(open_ovfl_2),
				.C_OUT(open_c_out_2),
				.B_OUT(open_b_out_2),
				.Q_OVFL(open_q_ovfl_2),
				.Q_C_OUT(open_q_c_out_2),
				.Q_B_OUT(open_q_b_out_2),
				.S(open_s_2),
				.Q (y1r_int));

C_ADDSUB_V2_0  # (1,
                  0,
                  0,
                  bfly_width,
                  0,
                  0,
                  0,
                  0,
                  " ",
                  bfly_width,
                  1,
                  0,
                  0,
                  1,
                  0,
                  1,
                  0,
                  1,
                  0,
                  1,
                  1,
                  0,
                  0,
                  0,
                  1,
                  0,
                  0,
                  0,
                  0,
                  0,
                  0,
                  0,
                  bfly_width,
                  0,
                  bfly_width+1,
                  1,
                  0,
                  0,
                  1)

lower_arm_subtr_im             (.A (x0i), 
				.B(x1i), 
				.CLK (clk),
				.ADD (dummy_in),
				.C_IN(dummy_in),
				.B_IN(logic1),
				.CE(ce), 
				.BYPASS(dummy_in),
				.ACLR(dummy_in),
				.ASET(dummy_in),
				.AINIT(reset),
				.SCLR(nc),
				.SSET(nc),
				.SINIT(nc),
				.A_SIGNED(logic1),
				.B_SIGNED(logic1),
				.OVFL(open_ovfl_3),
				.C_OUT(open_c_out_3),
				.B_OUT(open_b_out_3),
				.Q_OVFL(open_q_ovfl_3),
				.Q_C_OUT(open_q_c_out_3),
				.Q_B_OUT(open_q_b_out_3),
				.S(open_s_3),
				.Q (y1i_int));
 

 
 
assign  y0r_scale0 = y0r_int[bfly_width-1:0]; 
assign y0i_scale0 = y0i_int[bfly_width-1:0];  

assign y1r_scale0 = y1r_int[bfly_width-1:0];
assign  y1i_scale0 = y1i_int[bfly_width-1:0];

assign  y0r_scale1 = y0r_int[bfly_width:1];
assign  y0i_scale1 = y0i_int[bfly_width:1];

assign  y1r_scale1 = y1r_int[bfly_width:1];
assign  y1i_scale1 = y1i_int[bfly_width:1];


 C_MUX_BUS_V2_0 #("",
                  1,
                  0,
                  0,
                  0,
                  0,
                  0,
                  1,
                  0,
                  0,
                  0,
                  0,
                  2,
                  0,
                  1,
                  "",
                  0,
                  1,
                  bfly_width)    
                  

  scale_mux_y0r  ( .MA (y0r_scale0), 
		   .MB (y0r_scale1), 
		   .MC (dummy_mux_inputs),
		   .MD (dummy_mux_inputs),
		   .ME (dummy_mux_inputs),
		   .MF (dummy_mux_inputs),
		   .MG (dummy_mux_inputs),
	           .MH (dummy_mux_inputs),
		   .S  (mux_select),
		   .CLK (dummy_in),
		   .CE 	(dummy_in), 		   
                   .EN 	(dummy_in),  
		   .ASET (dummy_in), 
		   .ACLR (dummy_in),
		   .AINIT (dummy_in),		   
                   .SSET (dummy_in), 		   
                   .SCLR (dummy_in),
		   .SINIT (dummy_in),	
		   .O (y0r),
		   .Q (open_q_i));


 C_MUX_BUS_V2_0 #("",
                  1,
                  0,
                  0,
                  0,
                  0,
                  0,
                  1,
                  0,
                  0,
                  0,
                  0,
                  2,
                  0,
                  1,
                  "",
                  0,
                  1,
                  bfly_width)    
                  

  scale_mux_y0i  ( .MA (y0i_scale0), 
		   .MB (y0i_scale1), 
		   .MC (dummy_mux_inputs),
		   .MD (dummy_mux_inputs),
		   .ME (dummy_mux_inputs),
		   .MF (dummy_mux_inputs),
		   .MG (dummy_mux_inputs),
	           .MH (dummy_mux_inputs),
		   .S  (mux_select),
		   .CLK (dummy_in),
		   .CE 	(dummy_in), 		   
                   .EN 	(dummy_in),  
		   .ASET (dummy_in), 
		   .ACLR (dummy_in),
		   .AINIT (dummy_in),		   
                   .SSET (dummy_in), 		   
                   .SCLR (dummy_in),
		   .SINIT (dummy_in),	
		   .O (y0i),
		   .Q (open_q_i));



  C_MUX_BUS_V2_0 #("",
                  1,
                  0,
                  0,
                  0,
                  0,
                  0,
                  1,
                  0,
                  0,
                  0,
                  0,
                  2,
                  0,
                  1,
                  "",
                  0,
                  1,
                  bfly_width)    
                  

  scale_mux_y1r  ( .MA (y1r_scale0), 
		   .MB (y1r_scale1), 
		   .MC (dummy_mux_inputs),
		   .MD (dummy_mux_inputs),
		   .ME (dummy_mux_inputs),
		   .MF (dummy_mux_inputs),
		   .MG (dummy_mux_inputs),
	           .MH (dummy_mux_inputs),
		   .S  (mux_select),
		   .CLK (dummy_in),
		   .CE 	(dummy_in), 		   
                   .EN 	(dummy_in),  
		   .ASET (dummy_in), 
		   .ACLR (dummy_in),
		   .AINIT (dummy_in),		   
                   .SSET (dummy_in), 		   
                   .SCLR (dummy_in),
		   .SINIT (dummy_in),	
		   .O (y1r),
		   .Q (open_q_i));



 C_MUX_BUS_V2_0 #("",
                  1,
                  0,
                  0,
                  0,
                  0,
                  0,
                  1,
                  0,
                  0,
                  0,
                  0,
                  2,
                  0,
                  1,
                  "",
                  0,
                  1,
                  bfly_width)    
                  


  scale_mux_y1i  (.MA (y1i_scale0), 
		   .MB (y1i_scale1), 
		   .MC (dummy_mux_inputs),
		   .MD (dummy_mux_inputs),
		   .ME (dummy_mux_inputs),
		   .MF (dummy_mux_inputs),
		   .MG (dummy_mux_inputs),
	           .MH (dummy_mux_inputs),
		   .S  (mux_select),
		   .CLK (dummy_in),
		   .CE 	(dummy_in), 		   
                   .EN 	(dummy_in),  
		   .ASET (dummy_in), 
		   .ACLR (dummy_in),
		   .AINIT (dummy_in),		   
                   .SSET (dummy_in), 		   
                   .SCLR (dummy_in),
		   .SINIT (dummy_in),	
		   .O (y1i),
		   .Q (open_q_i));

endmodule

//******************************************************************************

//******************************************************************************

//******************************************************************************

//******************************************************************************


module vfft32_bflyw_j_v2_0 (x0r, x0i, x1r, x1i, clk, ce, start, reset, scale_by, y0r, y0i, y1r, y1i);
	
parameter bfly_width = 12;

parameter diff_with_0_scaling = 1;

input [bfly_width-1:0] x0r;
input [bfly_width-1:0] x0i;
input [bfly_width-1:0] x1r;
input [bfly_width-1:0] x1i;
input clk;
input ce;
input start;
input reset;
input [1:0] scale_by;
output [bfly_width-1:0] y0r;
output [bfly_width-1:0] y0i;
output [bfly_width-1:0] y1r;
output [bfly_width-1:0] y1i;

wire  [bfly_width:0] y0r_int;
wire  [bfly_width:0] y0i_int;
wire  [bfly_width:0] y1r_int;
wire  [bfly_width:0] y1i_int;

wire   [bfly_width-1:0]  y0r_scale0;
wire   [bfly_width-1:0]  y0i_scale0;
wire   [bfly_width-1:0]  y1r_scale0;
wire   [bfly_width-1:0]  y1i_scale0;
wire   [bfly_width-1:0]  y0r_scale1;
wire   [bfly_width-1:0]  y0i_scale1;
wire   [bfly_width-1:0]  y1r_scale1;
wire   [bfly_width-1:0]  y1i_scale1;

wire logic1 = 1'b1;
wire nc = 1'b0;
wire dummy_in = 1'b0;

wire open_ovfl;
wire open_c_out;
wire open_b_out;
wire open_q_ovfl;
wire open_q_c_out;
wire open_q_b_out;
wire [bfly_width:0] open_s;

wire open_ovfl_1;
wire open_c_out_1;
wire open_b_out_1;
wire open_q_ovfl_1;
wire open_q_c_out_1;
wire open_q_b_out_1;
wire [bfly_width:0] open_s_1;

wire open_ovfl_2;
wire open_c_out_2;
wire open_b_out_2;
wire open_q_ovfl_2;
wire open_q_c_out_2;
wire open_q_b_out_2;
wire [bfly_width:0] open_s_2;

wire open_ovfl_3;
wire open_c_out_3;
wire open_b_out_3;
wire open_q_ovfl_3;
wire open_q_c_out_3;
wire open_q_b_out_3;
wire [bfly_width:0] open_s_3;
wire [bfly_width-1:0] dummy_mux_inputs;


wire [bfly_width-1:0] open_q_r;
wire [bfly_width-1:0] open_q_i;

wire mux_select = scale_by[0];

//wire dummy_mux_inputs = 1'b0;

 C_ADDSUB_V2_0 # (0,
                  0,
                  0,
                  bfly_width,
                  0,
                  0,
                  0,
                  0,
                  " ",
                  bfly_width,
                  1,
                  0,
                  0,
                  0,
                  0,
                  1,
                  0,
                  0,
                  0,
                  1,
                  1,
                  0,
                  0,
                  0,
                  1,
                  0,
                  0,
                  0,
                  0,
                  0,
                  0,
                  0,
                  bfly_width,
                  0,
                  bfly_width+1,
                  1,
                  0,
                  0,
                  1)
		    
		
upper_arm_adder_re             (.A (x0r), 
				.B(x1r), 
				.CLK (clk),
				.ADD (dummy_in),
				.C_IN(dummy_in),
				.B_IN(dummy_in),
				.CE(ce), 
				.BYPASS(dummy_in),
				.ACLR(dummy_in),
				.ASET(dummy_in),
				.AINIT(reset),
				.SCLR(nc),
				.SSET(nc),
				.SINIT(nc),
				.A_SIGNED(logic1),
				.B_SIGNED(logic1),
				.OVFL(open_ovfl),
				.C_OUT(open_c_out),
				.B_OUT(open_b_out),
				.Q_OVFL(open_q_ovfl),
				.Q_C_OUT(open_q_c_out),
				.Q_B_OUT(open_q_b_out),
				.S(open_s),
				.Q (y0r_int));
 

 C_ADDSUB_V2_0 # (0,
                  0,
                  0,
                  bfly_width,
                  0,
                  0,
                  0,
                  0,
                  " ",
                  bfly_width,
                  1,
                  0,
                  0,
                  1,
                  0,
                  1,
                  0,
                  0,
                  0,
                  1,
                  1,
                  0,
                  0,
                  0,
                  1,
                  0,
                  0,
                  0,
                  0,
                  0,
                  0,
                  0,
                  bfly_width,
                  0,
                  bfly_width+1,
                  1,
                  0,
                  0,
                  1)
		    

 upper_arm_adder_im            (.A (x0i), 
				.B(x1i), 
				.CLK (clk),
				.ADD (dummy_in),
				.C_IN(dummy_in),
				.B_IN(dummy_in),
				.CE(ce), 
				.BYPASS(dummy_in),
				.ACLR(dummy_in),
				.ASET(dummy_in),
				.AINIT(reset),
				.SCLR(nc),
				.SSET(nc),
				.SINIT(nc),
				.A_SIGNED(logic1),
				.B_SIGNED(logic1),
				.OVFL(open_ovfl_1),
				.C_OUT(open_c_out_1),
				.B_OUT(open_b_out_1),
				.Q_OVFL(open_q_ovfl_1),
				.Q_C_OUT(open_q_c_out_1),
				.Q_B_OUT(open_q_b_out_1),
				.S(open_s_1),
				.Q (y0i_int));
 
 C_ADDSUB_V2_0 # (1,
                  0,
                  0,
                  bfly_width,
                  0,
                  0,
                  0,
                  0,
                  " ",
                  bfly_width,
                  1,
                  0,
                  0,
                  1,
                  0,
                  1,
                  0,
                  1,
                  0,
                  1,
                  1,
                  0,
                  0,
                  0,
                  1,
                  0,
                  0,
                  0,
                  0,
                  0,
                  0,
                  0,
                  bfly_width,
                  0,
                  bfly_width+1,
                  1,
                  0,
                  0,
                  1)

lower_arm_subtr_re             (.A (x0i), 
				.B(x1i), 
				.CLK (clk),
				.ADD (dummy_in),
				.C_IN(dummy_in),
				.B_IN(logic1),
				.CE(ce), 
				.BYPASS(dummy_in),
				.ACLR(dummy_in),
				.ASET(nc),
				.AINIT(reset),
				.SCLR(nc),
				.SSET(nc),
				.SINIT(nc),
				.A_SIGNED(logic1),
				.B_SIGNED(logic1),
				.OVFL(open_ovfl_2),
				.C_OUT(open_c_out_2),
				.B_OUT(open_b_out_2),
				.Q_OVFL(open_q_ovfl_2),
				.Q_C_OUT(open_q_c_out_2),
				.Q_B_OUT(open_q_b_out_2),
				.S(open_s_2),
				.Q (y1r_int));

C_ADDSUB_V2_0  # (1,
                  0,
                  0,
                  bfly_width,
                  0,
                  0,
                  0,
                  0,
                  " ",
                  bfly_width,
                  1,
                  0,
                  0,
                  1,
                  0,
                  1,
                  0,
                  1,
                  0,
                  1,
                  1,
                  0,
                  0,
                  0,
                  1,
                  0,
                  0,
                  0,
                  0,
                  0,
                  0,
                  0,
                  bfly_width,
                  0,
                  bfly_width+1,
                  1,
                  0,
                  0,
                  1)

lower_arm_subtr_im             (.A (x1r), 
				.B(x0r), 
				.CLK (clk),
				.ADD (dummy_in),
				.C_IN(dummy_in),
				.B_IN(logic1),
				.CE(ce), 
				.BYPASS(dummy_in),
				.ACLR(dummy_in),
				.ASET(dummy_in),
				.AINIT(reset),
				.SCLR(nc),
				.SSET(nc),
				.SINIT(nc),
				.A_SIGNED(logic1),
				.B_SIGNED(logic1),
				.OVFL(open_ovfl_3),
				.C_OUT(open_c_out_3),
				.B_OUT(open_b_out_3),
				.Q_OVFL(open_q_ovfl_3),
				.Q_C_OUT(open_q_c_out_3),
				.Q_B_OUT(open_q_b_out_3),
				.S(open_s_3),
				.Q (y1i_int));
 

 
 
assign  y0r_scale0 = y0r_int[bfly_width-1:0]; 
assign y0i_scale0 = y0i_int[bfly_width-1:0];  

assign y1r_scale0 = y1r_int[bfly_width-1:0];
assign  y1i_scale0 = y1i_int[bfly_width-1:0];

assign  y0r_scale1 = y0r_int[bfly_width:1];
assign  y0i_scale1 = y0i_int[bfly_width:1];

assign  y1r_scale1 = y1r_int[bfly_width:1];
assign  y1i_scale1 = y1i_int[bfly_width:1];


 C_MUX_BUS_V2_0 #("",
                  1,
                  0,
                  0,
                  0,
                  0,
                  0,
                  1,
                  0,
                  0,
                  0,
                  0,
                  2,
                  0,
                  1,
                  "",
                  0,
                  1,
                  bfly_width)    
                  

  scale_mux_y0r  ( .MA (y0r_scale0), 
		   .MB (y0r_scale1), 
		   .MC (dummy_mux_inputs),
		   .MD (dummy_mux_inputs),
		   .ME (dummy_mux_inputs),
		   .MF (dummy_mux_inputs),
		   .MG (dummy_mux_inputs),
	           .MH (dummy_mux_inputs),
		   .S  (mux_select),
		   .CLK (dummy_in),
		   .CE 	(dummy_in), 		   
                   .EN 	(dummy_in),  
		   .ASET (dummy_in), 
		   .ACLR (dummy_in),
		   .AINIT (dummy_in),		   
                   .SSET (dummy_in), 		   
                   .SCLR (dummy_in),
		   .SINIT (dummy_in),	
		   .O (y0r),
		   .Q (open_q_i));


 C_MUX_BUS_V2_0 #("",
                  1,
                  0,
                  0,
                  0,
                  0,
                  0,
                  1,
                  0,
                  0,
                  0,
                  0,
                  2,
                  0,
                  1,
                  "",
                  0,
                  1,
                  bfly_width)    
                  

  scale_mux_y0i  ( .MA (y0i_scale0), 
		   .MB (y0i_scale1), 
		   .MC (dummy_mux_inputs),
		   .MD (dummy_mux_inputs),
		   .ME (dummy_mux_inputs),
		   .MF (dummy_mux_inputs),
		   .MG (dummy_mux_inputs),
	           .MH (dummy_mux_inputs),
		   .S  (mux_select),
		   .CLK (dummy_in),
		   .CE 	(dummy_in), 		   
                   .EN 	(dummy_in),  
		   .ASET (dummy_in), 
		   .ACLR (dummy_in),
		   .AINIT (dummy_in),		   
                   .SSET (dummy_in), 		   
                   .SCLR (dummy_in),
		   .SINIT (dummy_in),	
		   .O (y0i),
		   .Q (open_q_i));



  C_MUX_BUS_V2_0 #("",
                  1,
                  0,
                  0,
                  0,
                  0,
                  0,
                  1,
                  0,
                  0,
                  0,
                  0,
                  2,
                  0,
                  1,
                  "",
                  0,
                  1,
                  bfly_width)    
                  

  scale_mux_y1r  ( .MA (y1r_scale0), 
		   .MB (y1r_scale1), 
		   .MC (dummy_mux_inputs),
		   .MD (dummy_mux_inputs),
		   .ME (dummy_mux_inputs),
		   .MF (dummy_mux_inputs),
		   .MG (dummy_mux_inputs),
	           .MH (dummy_mux_inputs),
		   .S  (mux_select),
		   .CLK (dummy_in),
		   .CE 	(dummy_in), 		   
                   .EN 	(dummy_in),  
		   .ASET (dummy_in), 
		   .ACLR (dummy_in),
		   .AINIT (dummy_in),		   
                   .SSET (dummy_in), 		   
                   .SCLR (dummy_in),
		   .SINIT (dummy_in),	
		   .O (y1r),
		   .Q (open_q_i));



  C_MUX_BUS_V2_0 #("",
                  1,
                  0,
                  0,
                  0,
                  0,
                  0,
                  1,
                  0,
                  0,
                  0,
                  0,
                  2,
                  0,
                  1,
                  "",
                  0,
                  1,
                  bfly_width)    
                  


  scale_mux_y1i   (.MA (y1i_scale0), 
		   .MB (y1i_scale1), 
		   .MC (dummy_mux_inputs),
		   .MD (dummy_mux_inputs),
		   .ME (dummy_mux_inputs),
		   .MF (dummy_mux_inputs),
		   .MG (dummy_mux_inputs),
	           .MH (dummy_mux_inputs),
		   .S  (mux_select),
		   .CLK (dummy_in),
		   .CE 	(dummy_in), 		   
                   .EN 	(dummy_in),  
		   .ASET (dummy_in), 
		   .ACLR (dummy_in),
		   .AINIT (dummy_in),		   
                   .SSET (dummy_in), 		   
                   .SCLR (dummy_in),
		   .SINIT (dummy_in),	
		   .O (y1i),
		   .Q (open_q_i)
                  );

endmodule

//******************************************************************************

//******************************************************************************

//******************************************************************************

//******************************************************************************
 

module vfft32_conj_reg_v2_0 (clk, ce, fwd_inv, dr, di, qr, qi);

parameter B = 16;

 input clk;
 input ce;
 input fwd_inv;
 input [B-1:0]dr;
 input [B-1:0]di; 
 output [B-1:0]qr;
 output [B-1:0]qi;

//wire dummy_in;
wire [B:0] open_s;
wire [B:0] qi_internal;
wire [B-1:0] qr_int;

wire [B-1:0]compare_signal;
wire aneb;
wire altb;
wire agtb;
wire aleb;
wire ageb;
wire qaeqb;
wire qaneb;
wire qaltb;
wire qagtb;
wire qaleb;
wire qageb;
wire conj;
wire [B-1:0] const_signal;
wire mux_select_int;
wire di_eq_comp;
wire [B-1:0] dummy_mux_inputs;
wire [B-1:0] open_o;
wire [B-1:0] q_subs;
wire dummy_in = 1'b0;
wire mux_select = 1'b0;

assign compare_signal [B-1] = 1'b1; 
assign compare_signal [B-2:0] = 1'b0; 
assign const_signal [B-1] = 1'b0; 
assign const_signal [B-2:0] = B-1'b1;

assign dummy_mux_inputs = B-2'b0;
assign q_subs = qi_internal[B-1:0];

 
vfft32_nand_a_b_v2_0 conj_gen (.a_in(fwd_inv),
                    .b_in(fwd_inv),
                    .nand_out(conj)
                    );
 
 C_REG_FD_V2_0 # ("",
                  1,
                  0,
                  0,
                  0,
                  1,
                  0,
                  0,
                  0,
                 "",
                  0,
                  1,
                  B)
     reg_real   (.D(dr),
	         .CLK(clk),
	         .CE(ce),
		 .ACLR(dummy_in), 
		 .ASET(dummy_in),
	         .AINIT(dummy_in), 
	         .SCLR(dummy_in),
		 .SSET(dummy_in),
		 .SINIT(dummy_in),
		 .Q (qr_int)
                 );

 C_REG_FD_V2_0 # ("",
                  1,
                  0,
                  0,
                  0,
                  1,
                  0,
                  0,
                  0,
                 "",
                  0,
                  1,
                  B)
     reg_real_Z   (.D(qr_int),
	         .CLK(clk),
	         .CE(ce),
		 .ACLR(dummy_in), 
		 .ASET(dummy_in),
	         .AINIT(dummy_in), 
	         .SCLR(dummy_in),
		 .SSET(dummy_in),
		 .SINIT(dummy_in),
		 .Q (qr)
                 );
 
   
  C_TWOS_COMP_V2_0 # (0,
                      1,
                      1,
                      1,
                      0,
                      0,
                      0,
                      1,
                      1,
                      1,
                      0,
                      0,
                      0,
                      0,
                      1,
                      "",
                      0,
                      1,
                      B)

    twos_comp_imag  (.A (di),
		     .BYPASS(conj),
		     .CLK(clk),
		     .CE(ce),
		     .ACLR(dummy_in),
		     .ASET(dummy_in),
		     .AINIT(dummy_in),
		     .SCLR(dummy_in),
		     .SSET(dummy_in),
		     .SINIT(dummy_in),
		     .S(open_s),
		     .Q(qi_internal)  
                      );
 
   
   C_COMPARE_V2_0 # ("",
                     0,
                     "",
                     1,
                     1,
                     0,
                     0,
                     1,
                     0,
                     0,
                     0,
                     0, 
                     0,
                     0,
                     0,
                     0,               
                     0,
                     0,
                     0,
                     0,
                     0,
                     0,
                     1,
                     0,
                     1,
                     B)

        compare_im_constant            (.A(di),
					.B(compare_signal),
					.CLK(clk),
                                        .CE(dummy_in),
                                        .ACLR(dummy_in),
                                        .ASET(dummy_in),
                                        .SCLR(dummy_in),
                                        .SSET(dummy_in),
					.A_EQ_B(di_eq_comp),
					.A_NE_B(aneb),
					.A_LT_B(altb),	
					.A_GT_B(agtb),	
					.A_LE_B(aleb),	
					.A_GE_B(ageb),	
					.QA_EQ_B(qaeqb),  	
					.QA_NE_B(qaneb),	
					.QA_LT_B(qaltb),	
					.QA_GT_B(qagtb),	
					.QA_LE_B(qaleb),	
					.QA_GE_B(qageb)	
					);

 vfft32_and_a_notb_v2_0 fwd_inv_qualify (.a_in(di_eq_comp),
                                         .b_in(fwd_inv),
                                         .and_out(mux_select_int)
                                         );
  

    
 C_MUX_BUS_V2_0 #("",
                  1,
                  0,
                  0,
                  0,
                  0,
                  0,
                  0, 
                  1,
                  0,
                  0,
                  0,
                  2,
                  0,
                  1,
                  "",
                  0,
                  1,
                  B)    
 
   const_q_int_mux_reg         (.MA(q_subs),
				.MB(const_signal),
				.MC(dummy_mux_inputs),
				.MD(dummy_mux_inputs),
				.ME(dummy_mux_inputs),
				.MF(dummy_mux_inputs),
				.MG(dummy_mux_inputs),
				.MH(dummy_mux_inputs),
				.S(mux_select),
		  		.CLK(clk),
                                .CE(dummy_in),
                                .EN(dummy_in),
                                .ACLR(dummy_in),
                                .ASET(dummy_in),
                                .AINIT(dummy_in),
                                .SCLR(dummy_in),
                                .SSET(dummy_in),
                                .SINIT(dummy_in),
				.O(open_o),
				.Q(qi)
                                );

endmodule


//******************************************************************************

//******************************************************************************














//******************************************************************************

//******************************************************************************

module vfft32_complex_reg_conj_v2_0 (clk, ce, conj, dr, di, qr, qi);

parameter B = 16;

 input clk;
 input ce;
 input conj;
 input [B-1:0]dr;
 input [B-1:0]di; 
 output [B-1:0]qr;
 output [B-1:0]qi;

wire [B:0] open_s;
wire [B:0] qi_internal;
wire [B-1:0] qi;
wire dummy_in = 1'b0;
wire nc = 1'b0;
assign qi = qi_internal[B-1:0];


  C_TWOS_COMP_V2_0 # (0,
                      1,
                      1,
                      1,
                      0,
                      0,
                      0,
                      1,
                      1,
                      1,
                      0,
                      0,
                      0,
                      0,
                      1,
                      "",
                      0,
                      1,
                      B)

    twos_comp_imag  (.A (di),
		     .BYPASS(conj),
		     .CLK(clk),
		     .CE(ce),
		     .ACLR(dummy_in),
		     .ASET(dummy_in),
		     .AINIT(dummy_in),
		     .SCLR(dummy_in),
		     .SSET(dummy_in),
		     .SINIT(dummy_in),
		     .S(open_s),
		     .Q(qi_internal)  
                      );
 

 
 C_REG_FD_V2_0 # ("",
                  1,
                  0,
                  0,
                  0,
                  1,
                  0,
                  0,
                  0,
                 "",
                  0,
                  1,
                  B)
     reg_real   (.D(dr),
	         .CLK(clk),
	         .CE(ce),
		 .ACLR(dummy_in), 
		 .ASET(nc),
	         .AINIT(nc), 
	         .SCLR(nc),
		 .SSET(nc),
		 .SINIT(nc),
		 .Q (qr)
                 );   

endmodule


//******************************************************************************

//******************************************************************************














//******************************************************************************

//******************************************************************************


module vfft32_complex_mult_v2_0 (ar, ai, br, bi, clk, ce, start, reset, p_re, p_im);


parameter a_width = 12;
parameter b_width = 12;

parameter  prod_a_mult_latency =  (b_width == 2 ? 1 :
                                  (b_width == 3 ? 1 :
                                  (b_width == 4 ? 1 :
                                  (b_width == 5 ? 2 :
                                  (b_width == 6 ? 2 :
                                  (b_width == 7 ? 2 :
                                  (b_width == 8 ? 2 :
                                  (b_width == 9 ? 3 :
                                  (b_width == 10 ? 3 :
                                  (b_width == 11 ? 3 :
                                  (b_width == 12 ? 3 :
                                  (b_width == 13 ? 3 :
                                  (b_width == 14 ? 3 :
                                  (b_width == 15 ? 3 :
                                  (b_width == 16 ? 3 :
                                  (b_width == 17 ? 4 :
                                  (b_width == 18 ? 4 :
                                  (b_width == 19 ? 4 :
                                  (b_width == 20 ? 4 :
                                  (b_width == 21 ? 4 :
                                  (b_width == 22 ? 4 :
                                  (b_width == 23 ? 4 :
                                  (b_width == 24 ? 4 :
                                  (b_width == 25 ? 4 :
                                  (b_width == 26 ? 4 :
                                  (b_width == 27 ? 4 :
                                  (b_width == 28 ? 4 :
                                  (b_width == 29 ? 4 :
                                  (b_width == 30 ? 4 :
                                  (b_width == 31 ? 4 :
                                  (b_width == 32 ? 4 : 4)))))))))))))))))))))))))))))));
                    
parameter  prod_b_mult_latency =  (a_width == 2 ? 1 :
                                  (a_width == 3 ? 1 :
                                  (a_width == 4 ? 1 :
                                  (a_width == 5 ? 2 :
                                  (a_width == 6 ? 2 :
                                  (a_width == 7 ? 2 :
                                  (a_width == 8 ? 2 :
                                  (a_width == 9 ? 3 :
                                  (a_width == 10 ? 3 :
                                  (a_width == 11 ? 3 :
                                  (a_width == 12 ? 3 :
                                  (a_width == 13 ? 3 :
                                  (a_width == 14 ? 3 :
                                  (a_width == 15 ? 3 :
                                  (a_width == 16 ? 3 :
                                  (a_width == 17 ? 4 :
                                  (a_width == 18 ? 4 :
                                  (a_width == 19 ? 4 :
                                  (a_width == 20 ? 4 :
                                  (a_width == 21 ? 4 :
                                  (a_width == 22 ? 4 :
                                  (a_width == 23 ? 4 :
                                  (a_width == 24 ? 4 :
                                  (a_width == 25 ? 4 :
                                  (a_width == 26 ? 4 :
                                  (a_width == 27 ? 4 :
                                  (a_width == 28 ? 4 :
                                  (a_width == 29 ? 4 :
                                  (a_width == 30 ? 4 :
                                  (a_width == 31 ? 4 :
                                  (a_width == 32 ? 4 : 4)))))))))))))))))))))))))))))));

parameter greatest_mult_latency = (prod_a_mult_latency >= prod_b_mult_latency)  ? prod_a_mult_latency : prod_b_mult_latency;

parameter max_mult_vgen_latency = 4;
parameter max_complex_mult_latency = 6;

parameter bsubtraction_factor = (b_width >=8) ? (b_width <=14) ? 1'b1 : 0 : 0;
parameter asubtraction_factor = (a_width >=8) ? (a_width <=14) ? 1'b1 : 0 : 0;

parameter delay_complex_mult_result_by = (max_complex_mult_latency - (greatest_mult_latency +2));

parameter diff_in_latency_a = (greatest_mult_latency - prod_a_mult_latency);
parameter diff_in_latency_b = (greatest_mult_latency - prod_b_mult_latency);

parameter a_slower = (prod_a_mult_latency == greatest_mult_latency) ? 1'b1 : 1'b0;

parameter b_slower = (prod_b_mult_latency == greatest_mult_latency) ? 1'b1 : 1'b0;

parameter a_b_latency_equal = (prod_a_mult_latency == prod_b_mult_latency) ? 1'b1 : 1'b0;


parameter delay_faster_mult_by = ((b_slower * diff_in_latency_a) + (a_slower * diff_in_latency_b));

parameter diff_a_2 = (diff_in_latency_a >= 2) ? 1'b1 : 1'b0;

parameter diff_a_3 = (diff_in_latency_a >= 3) ? 1'b1 : 1'b0;

parameter diff_b_2 = (diff_in_latency_b >= 2) ? 1'b1 : 1'b0;

parameter diff_b_3 = (diff_in_latency_b >= 3) ? 1'b1 : 1'b0;

parameter depth_delay_prod = delay_faster_mult_by + 1 + diff_a_2 + diff_a_3 + diff_b_2 + diff_b_3;

parameter ascii_zero = 8'b00110000;
parameter ainitval_ascii = {a_width+b_width+1{ascii_zero}};
parameter sinitval_ascii = {a_width+b_width+1{ascii_zero}};

input [a_width-1:0] ar;
input [a_width-1:0] ai;
input [b_width-1:0] br;
input [b_width-1:0] bi;
input clk;
input ce;
input start;
input reset;
output [a_width+b_width+1:0] p_re;
output [a_width+b_width+1:0] p_im;

wire [a_width:0] ar_minus_ai;
wire [b_width:0] br_minus_bi;
wire [b_width:0] br_plus_bi;

wire [b_width-1:0]  bi_balance;
wire [a_width-1:0]  ar_balance;
wire [a_width-1:0]  ai_balance;

wire [a_width + b_width:0]  prod_a;
wire [a_width + b_width:0]  prod_b;
wire [a_width + b_width:0]  prod_c;
wire [a_width + b_width:0] prod_a_d;
wire [a_width + b_width:0] prod_b_d;
wire [a_width + b_width:0] prod_c_d;

wire [a_width + b_width:0] prod_a_w;
wire [a_width + b_width:0] prod_b_w;
wire [a_width + b_width:0] prod_c_w;

wire [a_width + b_width:0]  prod_1;
wire [a_width + b_width:0]  prod_2;
wire [a_width + b_width:0]  prod_3;
wire [a_width + b_width:0]  prod_a_int;
wire [a_width + b_width:0]  prod_b_int;
wire [a_width + b_width:0]  prod_c_int;
wire [a_width + b_width+1:0]  pr_full_precision;
wire [a_width + b_width+1:0]  pi_full_precision;
wire [a_width + b_width+1:0]  delayed_pr_full_precision_1;
wire [a_width + b_width+1:0]  delayed_pi_full_precision_2;
wire [a_width + b_width+1:0]  delayed_pr_full_precision;
wire [a_width + b_width+1:0]  delayed_pi_full_precision;
wire [a_width+b_width+1:0] p_re;
wire [a_width+b_width+1:0] p_im;

wire logic0 = 1'b0;
wire logic1 = 1'b1;
wire nc = 1'b0;
wire dummy_in = 1'b0;
wire dummy_addr = 1'b0;

wire open_ovfl;
wire open_c_out;
wire open_b_out;
wire open_q_ovfl;
wire open_q_c_out;
wire open_q_b_out;
wire [a_width:0] open_s;

wire open_ovfl_1;
wire open_c_out_1;
wire open_b_out_1;
wire open_q_ovfl_1;
wire open_q_c_out_1;
wire open_q_b_out_1;
wire [b_width:0] open_s_1;

wire open_ovfl_2;
wire open_c_out_2;
wire open_b_out_2;
wire open_q_ovfl_2;
wire open_q_c_out_2;
wire open_q_b_out_2;
wire [b_width:0] open_s_2;

wire open_ovfl_3;
wire open_c_out_3;
wire open_b_out_3;
wire open_q_ovfl_3;
wire open_q_c_out_3;
wire open_q_b_out_3;
wire [a_width + b_width +1:0] open_s_3;

wire open_ovfl_4;
wire open_c_out_4;
wire open_b_out_4;
wire open_q_ovfl_4;
wire open_q_c_out_4;
wire open_q_b_out_4;
wire [a_width + b_width +1:0] open_s_4;


 C_ADDSUB_V2_0 # (1,
                  "",
                  0,
                  a_width,  
                  0,
                  0,
                  0,
                  0,  
                  " ",
                  a_width,
                  1,
                  0,  
                  0,
                  1,
                  0,
                  1,  
                  0, 
                  1,
                  0,
                  1,
                  1,  
                  0,
                  0,
                  0,  
                  1,
                  0,
                  0,
                  0,
                  0,
                  0,
                  0,
                  0,
                  a_width,
                  0,
                  a_width+1,
                  1,
    		  
                  "",
                  0,
                  1)
   
		
     ar_ai_sub                 (.A (ar), 
				.B(ai), 
				.CLK (clk),
				.ADD (dummy_in),
				.C_IN(dummy_in),
				.B_IN(logic1),
				.CE(ce), 
				.BYPASS(dummy_in),
				.ACLR(dummy_in),
				.ASET(nc),
				.AINIT(reset),
				.SCLR(nc),
				.SSET(nc),
				.SINIT(nc),
				.A_SIGNED(logic1),
				.B_SIGNED(logic1),
				.OVFL(open_ovfl),
				.C_OUT(open_c_out),
				.B_OUT(open_b_out),
				.Q_OVFL(open_q_ovfl),
				.Q_C_OUT(open_q_c_out),
				.Q_B_OUT(open_q_b_out),
				.S(open_s),
				.Q (ar_minus_ai));
 

  C_ADDSUB_V2_0 # (1,
                  "",
                  0,
                  b_width,
                  0,
                  0,
                  0,
                  0,
                  " ",
                  b_width,
                  1,
                  0,
                  0,
                  1,
                  0,
                  1,
                  0,
                  1,
                  0,
                  1,
                  1,
                  0,
                  0,
                  0,
                  1,
                  0,
                  0,
                  0,
                  0,
                  0,
                  0,
                  0,
                  b_width,
                  0,
                  b_width+1,
                  1,
    		
                  "",
                  0,
                  1)
		    

 br_bi_sub                     (.A (br), 
				.B(bi), 
				.CLK (clk),
				.ADD (dummy_in),
				.C_IN(dummy_in),
				.B_IN(logic1),
				.CE(ce), 
				.BYPASS(dummy_in),
				.ACLR(reset),
				.ASET(nc),
				.AINIT(reset),
				.SCLR(nc),
				.SSET(nc),
				.SINIT(nc),
				.A_SIGNED(logic1),
				.B_SIGNED(logic1),
				.OVFL(open_ovfl_1),
				.C_OUT(open_c_out_1),
				.B_OUT(open_b_out_1),
				.Q_OVFL(open_q_ovfl_1),
				.Q_C_OUT(open_q_c_out_1),
				.Q_B_OUT(open_q_b_out_1),
				.S(open_s_1),
				.Q (br_minus_bi));
 
C_ADDSUB_V2_0 # (0,
                  "",
                  0,
                  b_width,
                  0,
                  0,
                  0,
                  0,
                  "",
                  b_width,
                  1,
                  0,
                  0,
                  1,
                  0,
                  1,
                  0,
                  0,
                  0,
                  1,
                  1,
                  1,
                  0,
                  0,
                  1,
                  0,
                  0,
                  0,
                  0,
                  0,
                  0,
                  0,
                  b_width,
                  0,
                  b_width+1,
                  1,
    		
                  "",
                  0,
                  1)


  
 br_bi_add                     (.A (br), 
				.B(bi), 
				.CLK (clk),
				.ADD (dummy_in),
				.C_IN(logic0),
				.B_IN(dummy_in),
				.CE(ce), 
				.BYPASS(dummy_in),
				.ACLR(reset),
				.ASET(nc),
				.AINIT(reset),
				.SCLR(nc),
				.SSET(nc),
				.SINIT(nc),
				.A_SIGNED(logic1),
				.B_SIGNED(logic1),
				.OVFL(open_ovfl_2),
				.C_OUT(open_c_out_2),
				.B_OUT(open_b_out_2),
				.Q_OVFL(open_q_ovfl_2),
				.Q_C_OUT(open_q_c_out_2),
				.Q_B_OUT(open_q_b_out_2),
				.S(open_s_2),
				.Q (br_plus_bi));
 

C_REG_FD_V2_0 # (0,
                 1,
                 0,
                 1,
                 0,
                 1,
                 0,
                 0,
                 0,
                "",
                 0,
                 1,
                 b_width)

 	bi_balance_reg   (.D(bi),
			  .CLK(clk),
			  .CE(ce),
			  .ACLR(dummy_in),
			  .ASET(nc),
			  .AINIT(reset), 
			  .SCLR(nc),
			  .SSET(nc),
			  .SINIT(nc),
			  .Q(bi_balance)
                          );



C_REG_FD_V2_0 # (0,
                 1,
                 0,
                 1,
                 0,
                 1,
                 0,
                 0,
                 0,
                "",
                0,
                 1,
                 a_width)

 	ar_balance_reg   (.D(ar),
			  .CLK(clk),
			  .CE(ce),
			  .ACLR(dummy_in),
			  .ASET(nc),
			  .AINIT(reset), 
			  .SCLR(nc),
			  .SSET(nc),
			  .SINIT(nc),
			  .Q(ar_balance)
                          );


C_REG_FD_V2_0 # (0,
                 1,
                 0,
                 1,
                 0,
                 1,
                 0,
                 0,
                 0,
                "",
                0,
                 1,
                 a_width)

 	ai_balance_reg   (.D(ai),
			  .CLK(clk),
			  .CE(ce),
			  .ACLR(dummy_in),
			  .ASET(nc),
			  .AINIT(reset), 
			  .SCLR(nc),
			  .SSET(nc),
			  .SINIT(nc),
			  .Q(ai_balance)
                          );

 MULT_VGEN_V1_0 # (a_width+1,
                   b_width,
                   1,
                   0,
                   1,
                   0,
                   0,
                   0,
                   0,
                   0,
                   1,
                   0
                   )
      
  prod_a_mult (.A(ar_minus_ai),
               .B(bi_balance),
               .CLK(clk),
               .CE(ce),
               .ACLR(reset),
               .ASET(nc),
               .SCLR(nc),
               .SSET(nc),
               .P(prod_a_int)
               );

 MULT_VGEN_V1_0 # (b_width+1,
                   a_width,
                   1,
                   0,
                   1,
                   0,
                   0,
                   0,
                   0,
                   0,
                   1,
                   0
                   )
      
  prod_b_mult (.A(br_minus_bi),
               .B(ar_balance),
               .CLK(clk),
               .CE(ce),
               .ACLR(reset),
               .ASET(nc),
               .SCLR(nc),
               .SSET(nc),
               .P(prod_b_int)
               );


 MULT_VGEN_V1_0 # (b_width+1,
                   a_width,
                   1,
                   0,
                   1,
                   0,
                   0,
                   0,
                   0,
                   0,
                   1,
                   0
                   )
      
  prod_c_mult (.A(br_plus_bi),
               .B(ai_balance),
               .CLK(clk),
               .CE(ce),
               .ACLR(reset),
               .ASET(nc),
               .SCLR(nc),
               .SSET(nc),
               .P(prod_c_int)
               );

//always @ (posedge clk)

//begin

//  if (a_b_latency_equal)
    
//    begin

//    prod_a = prod_a_int;
//    prod_b = prod_b_int;
//    prod_c = prod_c_int;

//    end

//  else if (~a_b_latency_equal)

//   begin

//   if (b_slower == 1)

//   begin

//   prod_a = prod_1;
//   prod_b = prod_b_int;
//   prod_c = prod_c_int;

 //   end

//  if (a_slower)

//  begin

 // prod_a = prod_a_int;
//  prod_b = prod_2;
//  prod_c = prod_3;

///  end
  
//end
  
//end
 

assign prod_a = (a_b_latency_equal == 1) ? prod_a_int : (b_slower == 1) ? prod_1 : (a_slower == 1) ? prod_a_int : 0;

assign prod_b = (a_b_latency_equal == 1) ? prod_b_int : (b_slower == 1) ? prod_b_int : (a_slower == 1) ? prod_2 : 0;

assign prod_c = (a_b_latency_equal == 1) ? prod_c_int : (b_slower == 1) ? prod_c_int : (a_slower == 1) ? prod_3 : 0;

       
vfft32_delay_wrapper_v2_0 # (1,                 
                             depth_delay_prod,		
                             a_width + b_width + 1)

 delay_prod_a (.addr(dummy_addr),
               .data(prod_a_int),
               .clk(clk),
               .reset(dummy_in),
               .start(start),
               .delayed_data(prod_1)
               ); 
 
      
vfft32_delay_wrapper_v2_0 # (1,                 
                             depth_delay_prod,
                             a_width + b_width + 1)

 delay_prod_b (.addr(dummy_addr),
               .data(prod_b_int),
               .clk(clk),
               .reset(dummy_in),
               .start(reset),
               .delayed_data(prod_2)
               );
 
      
vfft32_delay_wrapper_v2_0 # (1,                 
                             depth_delay_prod,
                             a_width + b_width + 1)
 
delay_prod_c (.addr(dummy_addr),
               .data(prod_c_int),
               .clk(clk),
               .start(reset),
               .reset(dummy_in),
               .delayed_data(prod_3)
               );


assign prod_a_w = prod_a;
assign prod_b_w = prod_b;
assign prod_c_w = prod_c;
 
   
 C_ADDSUB_V2_0 # (0,
                  "",
                  0,
                  a_width + b_width +1,
                  0,
                  0,
                  0,
                  0,
                  " ",
                  a_width + b_width +1,
                  1,
                  0,
                  1,
                  0,
                  0,
                  1,
                  0,
                  0,
                  0,
                  1,
                  0,
                  1,
                  0,
                  0,
                  1,
                  0,
                  0,
                  0,
                  0,
                  0,
                  0,
                  0,
                  a_width + b_width +1,
                  0,
                  a_width + b_width +2,
                  1,
    		  
                  "",
                  0,
                  1)
   
                p_re_add (.A(prod_a_w),
			  .B(prod_b_w),
			  .CLK(clk),
			  .ADD(logic1),
			  .C_IN(logic0),
			  .B_IN(logic0),
			  .CE(logic1),
			  .BYPASS(logic0),
			  .ACLR(reset),
			  .ASET(nc),
			  .AINIT(nc),
			  .SCLR(nc),
			  .SSET(nc),
			  .SINIT(nc),
			  .A_SIGNED(logic1),
			  .B_SIGNED(logic1),
			  .OVFL(open_ovfl_3),
			  .C_OUT(open_c_out_3),
			  .B_OUT(open_b_out_3),
			  .Q_OVFL(open_q_ovfl_3),
			  .Q_C_OUT(open_q_c_out_3),
			  .Q_B_OUT(open_q_b_out_3),
			  .S(open_s_3),
			  .Q(pr_full_precision)
                          );
	
   
 C_ADDSUB_V2_0 # (0,
                  "",
                  0,
                  a_width + b_width +1,
                  0,
                  0,
                  0,
                  0,
                  " ",
                  a_width + b_width +1,
                  1,
                  0,
                  1,
                  0,
                  0,
                  1,
                  0,
                  0,
                  0,
                  1,
                  0,
                  1,
                  0,
                  0,
                  1,
                  0,
                  0,
                  0,
                  0,
                  0,
                  0,
                  0,
                  a_width + b_width +1,
                  0,
                  a_width + b_width +2,
                  1,
    		  
                  "",
                  0,
                  1)
   
      p_im_add (.A(prod_a_w),
			  .B(prod_c_w),
			  .CLK(clk),
			  .ADD(logic1),
			  .C_IN(logic0),
			  .B_IN(logic0),
			  .CE(logic1),
			  .BYPASS(logic0),
			  .ACLR(reset),
			  .ASET(nc),
			  .AINIT(nc),
			  .SCLR(nc),
			  .SSET(nc),
			  .SINIT(nc),
			  .A_SIGNED(logic1),
			  .B_SIGNED(logic1),
			  .OVFL(open_ovfl_4),
			  .C_OUT(open_c_out_4),
			  .B_OUT(open_b_out_4),
			  .Q_OVFL(open_q_ovfl_4),
			  .Q_C_OUT(open_q_c_out_4),
			  .Q_B_OUT(open_q_b_out_4),
			  .S(open_s_4),
			  .Q(pi_full_precision)
                          );


vfft32_delay_wrapper_v2_0 # (1,
                  delay_complex_mult_result_by,
                  a_width+b_width+2
                 )

 delayed_pr_full_p (.addr(dummy_addr),
                    .data(pr_full_precision),
                    .clk(clk),
                    .reset(dummy_in),
                    .start(start),
                    .delayed_data(delayed_pr_full_precision_1)
                    );
 
vfft32_delay_wrapper_v2_0 # (1,
                  delay_complex_mult_result_by,
                  a_width+b_width+2
                 )

 delayed_pi_full_p (.addr(dummy_addr),
                    .data(pi_full_precision),
                    .clk(clk),
                    .reset(dummy_in),
                    .start(start),
                    .delayed_data(delayed_pi_full_precision_2)
                    );

assign delayed_pr_full_precision = (delay_complex_mult_result_by > 0) ? delayed_pr_full_precision_1 : 1'b0;

assign delayed_pi_full_precision = (delay_complex_mult_result_by > 0) ? delayed_pi_full_precision_2 : 1'b0;

assign  p_re = (delay_complex_mult_result_by == 0) ? pr_full_precision : delayed_pr_full_precision_1;

assign  p_im = (delay_complex_mult_result_by == 0) ? pi_full_precision : delayed_pi_full_precision_2;





endmodule


//******************************************************************************

//******************************************************************************





















   
//******************************************************************************

//******************************************************************************

	
module vfft32_state_machine_v2_0 (clk, ce, start, reset, s);
parameter n = 10;	 
input clk;
input ce;
input start;
input reset;
output [n-1:0] s;


wire dummy_in = 1'b0;
wire [n-1:0]temp;
wire [n-1:0]q;
reg [n-1:0]s;

parameter ascii_zero = 8'b00110000;

parameter ainitstring = {n{ascii_zero}};

parameter ascii_one = 8'b00110001;

//parameter initstring = {ascii_one, {(n-1){ascii_zero}}};

parameter initstring = {{(n-1){ascii_zero}}, ascii_one};


assign temp = {q[n-2:0], q[n-1]};

C_REG_FD_V2_0 # (ainitstring,
                 1,
                 0,
                 1,
                 0,
                 1,
                 0,
                 1,
                 0,
                 initstring,
                 0,
                 0,
                 n )            

                flops_n    (.D(temp),
			    .CLK(clk),
			    .CE(ce),
			    .ACLR(dummy_in),
			    .ASET(dummy_in),
			    .AINIT(reset), 
			    .SCLR(dummy_in),
                            .SSET(dummy_in), 
			    .SINIT(start), 
			    .Q(q) 
                            );


always @ (q)

begin : loop

integer i;

for (i=n-1; i>=0; i=i-1)

s[n-1-i] = q[i]; 

end

assign dummy_in = 1'b0;

endmodule

//******************************************************************************

//******************************************************************************


//****************************************************************************

module vfft32_shift_ram_v2_0 (A, D, CLK, CE, ACLR, ASET, AINIT, SCLR, SSET, SINIT, Q); 
    
	parameter C_ADDR_WIDTH    = 4;
	parameter C_AINIT_VAL     = "";
	parameter C_DEFAULT_DATA  = 8'b00110000;
        parameter C_DEFAULT_DATA_RADIX = 1;
        parameter C_DEPTH         = 16;
	parameter C_ENABLE_RLOCS  = 1;
	parameter C_GENERATE_MIF  = 0;   // Unused by the behavioural model
        parameter C_HAS_A         = 0;
	parameter C_HAS_ACLR      = 0;
	parameter C_HAS_AINIT     = 0;
	parameter C_HAS_ASET      = 0;
	parameter C_HAS_CE        = 0;
	parameter C_HAS_SCLR      = 0;
	parameter C_HAS_SINIT     = 0;
	parameter C_HAS_SSET      = 0;
	parameter C_MEM_INIT_FILE = "null.mif";
	parameter C_MEM_INIT_RADIX = 1; // for backwards compatibility
        parameter C_READ_MIF      = 0;
        parameter C_REG_LAST_BIT  = 0;
	parameter C_SHIFT_TYPE    = 0; // c_fixed
	parameter C_SINIT_VAL     = "";
	parameter C_SYNC_ENABLE   = 0; // c_override
	parameter C_SYNC_PRIORITY = 1; // c_clear
        parameter C_WIDTH         = 16;
    	parameter C_DEPTH_TEMP = ((C_DEPTH/16)+1)*16; // to enable vsim to work
        
        parameter radix = (C_DEFAULT_DATA_RADIX == 1 ? C_MEM_INIT_RADIX :      
                          C_DEFAULT_DATA_RADIX);

    input  [C_WIDTH-1 : 0] D;
    input  [C_ADDR_WIDTH-1 : 0] A;
    input  CLK;
    input  CE;
    input  ACLR;
    input  ASET;
    input  AINIT;
    input  SCLR;
    input  SSET;
    input  SINIT;
    output [C_WIDTH-1 : 0] Q;
   
	wire [C_WIDTH-1 : 0] shift_out;
	wire [C_WIDTH-1 : 0] shift_out_1;
	wire [C_WIDTH-1 : 0] shift_out_2;
	wire [C_WIDTH-1 : 0] reg_out;
	// Internal values to drive signals when input is missing
	wire [C_WIDTH-1 : 0] intQ;
	wire [C_WIDTH-1 : 0] Q = intQ;
	wire intCE;
    
	reg lastCLK;
	wire [C_WIDTH-1 : 0] feedin;
        wire [C_ADDR_WIDTH-1 : 0] addtop;
        wire [3 : 0] addlow;
        wire [C_ADDR_WIDTH-1 : 0] intA;
	
	integer i;
	integer rdeep;
	
    reg [C_WIDTH-1 : 0] default_data;
	reg [C_WIDTH-1 : 0] ram_data [0 : C_DEPTH];
	reg [C_WIDTH-1 : 0] shifter [0 : ((C_SHIFT_TYPE === 0 || C_DEPTH%16 == 0)?C_DEPTH:C_DEPTH_TEMP)];
    
    function integer ADDR_IS_X;
      input [C_ADDR_WIDTH-1 : 0] value;
      integer i;
    begin
      ADDR_IS_X = 0;
      for(i = 0; i < C_ADDR_WIDTH; i = i + 1)
        if(value[i] === 1'bX)
          ADDR_IS_X = 1;
    end
    endfunction

    // Sort out default values for missing ports
    
    assign intQ     = (C_REG_LAST_BIT === 1)?reg_out:shift_out;
	assign intCE = defval(CE, C_HAS_CE, 1);
	assign intA = (C_HAS_A ? A : C_DEPTH-1);
	assign addtop = (C_ADDR_WIDTH > 4 ? intA[C_ADDR_WIDTH-1 : (C_ADDR_WIDTH>4?4:0)] : 0);
 	assign addlow = intA[(C_ADDR_WIDTH>3?3:(C_ADDR_WIDTH-1)) : 0];	// modified by dlunn on 21/10/99 from intA[3:0]
	assign shift_out_1 = (ADDR_IS_X(intA) ? {C_WIDTH{1'bx}} : (intA < rdeep ? shifter[intA] : 1'bx));	// DLUNN MODIFIED FINAL EXPRESSION FROM 0 FOR ILLEGAL ADDRESSING
	assign shift_out_2 = (ADDR_IS_X(addlow) ? {C_WIDTH{1'bx}} : shifter[rdeep-16+addlow]);
	assign shift_out = (C_SHIFT_TYPE == 0 ? shifter[C_DEPTH-C_REG_LAST_BIT-1] : 
						(C_SHIFT_TYPE == 1 ? shift_out_1 : shift_out_2));
    assign feedin = (ADDR_IS_X(addtop) ? {C_WIDTH{1'bx}} : (addtop === 0 ? D : (addtop < rdeep/16 ? shifter[(addtop*16)-1] : {C_WIDTH{1'bx}})));	// DLUNN MODIFIED FINAL EXPRESSION FROM 0 FOR ILLEGAL ADDRESSING
	   
	// Register on output by default
	C_REG_FD_V2_0 #(C_AINIT_VAL, C_ENABLE_RLOCS, C_HAS_ACLR, C_HAS_AINIT, C_HAS_ASET,
			   C_HAS_CE, C_HAS_SCLR, C_HAS_SINIT, C_HAS_SSET,
			   C_SINIT_VAL, C_SYNC_ENABLE, C_SYNC_PRIORITY, C_WIDTH)
		final_reg (.D(shift_out), .CLK(CLK), .CE(CE), .ACLR(ACLR), .ASET(ASET),
			  .AINIT(AINIT), .SCLR(SCLR), .SSET(SSET), .SINIT(SINIT),
			  .Q(reg_out)); 
  
 
    initial
    begin
	  #1;
      rdeep = (C_SHIFT_TYPE === 0 || C_DEPTH%16 == 0)?C_DEPTH:((C_DEPTH/16)+1)*16;
      for(i = 0; i < rdeep; i = i + 1) shifter[i] = {C_WIDTH{1'b0}};
      default_data = 'b0;
    case (radix)
       3 : default_data = decstr_conv(C_DEFAULT_DATA);
       2 : default_data = binstr_conv(C_DEFAULT_DATA);
       1 : default_data = hexstr_conv(C_DEFAULT_DATA);
      default : $display("%m, %dns ERROR : BAD DATA RADIX", $time);
    endcase

    for(i = 0; i < C_DEPTH; i = i + 1)
      ram_data[i] = default_data;
    
    if(C_READ_MIF == 1)
    begin
      $readmemb(C_MEM_INIT_FILE, ram_data);
    end
    if (C_GENERATE_MIF == 1)
      write_meminit_file;
	
    for(i = 0; i < C_DEPTH; i = i + 1)
      shifter[i] = ram_data[i];  
    end
	
    always@(posedge CLK or intA)
    begin
      if(CLK !== lastCLK && (intCE === 1'b1 && CLK !== 1'bx && lastCLK !== 1'bx))
      begin
        if(C_SHIFT_TYPE === 2)
		begin
        	for(i = rdeep-1; i > rdeep-16; i = i - 1) shifter[i] <= shifter[i-1];
			shifter[rdeep-16] <= feedin;
	        for(i = rdeep-17; i > 0; i = i - 1) shifter[i] <= shifter[i-1];
		end
		else 
	        for(i = rdeep-1; i > 0; i = i - 1) shifter[i] <= shifter[i-1];
		
		shifter[0] <= D;
      end
      if(CLK !== lastCLK && (intCE === 1'bx || CLK === 1'bx || lastCLK === 1'bx))
        for(i = 0; i < rdeep; i = i + 1) shifter[i] <= {C_WIDTH{1'bx}};
    end
      
  
	always@(CLK)
		lastCLK <= CLK;

	function defval;
	input i;
	input hassig;
	input val;
		begin
			if(hassig == 1)
				defval = i;
			else
				defval = val;
		end
	endfunction
	
	function [C_WIDTH-1:0] binstr_conv;
    input [(C_WIDTH*8)-1:0] def_data;

    integer index,i;

    begin
      index = 0;
      binstr_conv = 'b0;

      for( i=C_WIDTH-1; i>=0; i=i-1 )
      begin
        case (def_data[7:0])
          8'b00000000 : i = -1;
          8'b00110000 : binstr_conv[index] = 1'b0;
          8'b00110001 : binstr_conv[index] = 1'b1;
          default :
          begin
            $display("%m, %dns ERROR : NOT A BINARY CHARACTER", $time);
            binstr_conv[index] = 1'bx;
          end
        endcase
        index = index + 1;
        def_data = def_data >> 8;
      end
    end
  endfunction

  function [C_WIDTH-1:0] hexstr_conv;
    input [(C_WIDTH*8)-1:0] def_data;

    integer index,i,j;
    reg [3:0] bin;

    begin
      index = 0;
      hexstr_conv = 'b0;
      for( i=C_WIDTH-1; i>=0; i=i-1 )
      begin
        case (def_data[7:0])
          8'b00000000 :
          begin
            bin = 4'b0000;
            i = -1;
          end
          8'b00110000 : bin = 4'b0000;
          8'b00110001 : bin = 4'b0001;
          8'b00110010 : bin = 4'b0010;
          8'b00110011 : bin = 4'b0011;
          8'b00110100 : bin = 4'b0100;
          8'b00110101 : bin = 4'b0101;
          8'b00110110 : bin = 4'b0110;
          8'b00110111 : bin = 4'b0111;
          8'b00111000 : bin = 4'b1000;
          8'b00111001 : bin = 4'b1001;
          8'b01000001 : bin = 4'b1010;
          8'b01000010 : bin = 4'b1011;
          8'b01000011 : bin = 4'b1100;
          8'b01000100 : bin = 4'b1101;
          8'b01000101 : bin = 4'b1110;
          8'b01000110 : bin = 4'b1111;
          8'b01100001 : bin = 4'b1010;
          8'b01100010 : bin = 4'b1011;
          8'b01100011 : bin = 4'b1100;
          8'b01100100 : bin = 4'b1101;
          8'b01100101 : bin = 4'b1110;
          8'b01100110 : bin = 4'b1111;
          default :
          begin
            $display("%m, %dns ERROR : NOT A HEX CHARACTER", $time);
            bin = 4'bx;
          end
        endcase
        for( j=0; j<4; j=j+1)
        begin
          if ((index*4)+j < C_WIDTH)
          begin
            hexstr_conv[(index*4)+j] = bin[j];
          end
        end
        index = index + 1;
        def_data = def_data >> 8;
      end
    end
  endfunction

  function [C_WIDTH-1:0] decstr_conv;
    input [(C_WIDTH*8)-1:0] def_data;

    integer index,i,j;
    reg [3:0] bin;

    begin
      index = 0;
      decstr_conv = 'b0;
      for( i=C_WIDTH-1; i>=0; i=i-1 )
      begin
        case (def_data[7:0])
          8'b00000000 :
          begin
            bin = 4'b0000;
            i = -1;
          end
          8'b00110000 : bin = 4'b0000;
          8'b00110001 : bin = 4'b0001;
          8'b00110010 : bin = 4'b0010;
          8'b00110011 : bin = 4'b0011;
          8'b00110100 : bin = 4'b0100;
          8'b00110101 : bin = 4'b0101;
          8'b00110110 : bin = 4'b0110;
          8'b00110111 : bin = 4'b0111;
          8'b00111000 : bin = 4'b1000;
          8'b00111001 : bin = 4'b1001;
          8'b01000001 : bin = 4'b1010;
          8'b01000010 : bin = 4'b1011;
          8'b01000011 : bin = 4'b1100;
          8'b01000100 : bin = 4'b1101;
          8'b01000101 : bin = 4'b1110;
          8'b01000110 : bin = 4'b1111;
          default :
          begin
            $display("%m, %dns ERROR : NOT A DECIMAL CHARACTER", $time);
            bin = 4'bx;
          end
        endcase
        for( j=0; j<4; j=j+1)
        begin
          if ((index*4)+j < C_WIDTH)
          begin
            decstr_conv[(index*4)+j] = bin[j];
          end
        end
        index = index + 1;
        def_data = def_data >> 8;
      end
    end
  endfunction
  
  task write_meminit_file;
  
    integer addrs, outfile, bit;
    
    reg [C_WIDTH-1 : 0] conts;
    reg anyX;
    
    begin
      outfile = $fopen(C_MEM_INIT_FILE);
      for( addrs = 0; addrs < C_DEPTH; addrs=addrs+1)
      begin
        anyX = 1'b0;
        conts = ram_data[addrs];
        for(bit = 0; bit < C_WIDTH; bit=bit+1)
          if(conts[bit] === 1'bx) anyX = 1'b1;
        if(anyX == 1'b1)  
          $display("%m, %dns ERROR : MEMORY CONTAINS UNKNOWNS", $time);
        $fdisplay(outfile,"%b",ram_data[addrs]);
      end
      $fclose(outfile);
    end
  endtask

endmodule

//******************************************************************************

//******************************************************************************


module vfft32_flip_flop_v2_0 (d, clk, ce, reset, q); 
 
input d;
input clk;
input ce;
input reset;
output q;

wire d;
wire clk;
wire ce;
wire reset;
wire dummy_in = 1'b0;
wire q_int;

parameter zero_string = 1'b0;
wire d_int = d;
wire q = q_int;

 C_REG_FD_V2_0 #( zero_string, 
                            1,
                            0, 
                            1, 
                            0, 
                            1, 
                            0, 
                            0, 
                            0, 
                            "", 
                            0, 
                            1, 
                            1)

 ff	(.D(d_int), 
	.CLK(clk),
	 .CE(ce), 
	.ACLR(dummy_in), 
	.ASET(dummy_in),
	 .AINIT(reset), 
	.SCLR (dummy_in),
	 .SSET(dummy_in),
	 .SINIT(dummy_in),
	 .Q(q_int));

endmodule

//******************************************************************************

//******************************************************************************

//******************************************************************************

//******************************************************************************


module vfft32_flip_flop_sclr_v2_0 (d, clk, ce, reset, sclr, q); 
 
input d;
input clk;
input ce;
input reset;
input sclr;
output q;


wire dummy_in = 1'b0;
wire q_int;

parameter zero_string = 1'b0;
wire d_int = d;
wire q = q_int;

 C_REG_FD_V2_0 #( zero_string, 
                            1,
                            0, 
                            1, 
                            0, 
                            1, 
                            1, 
                            0, 
                            0, 
                            "", 
                            0, 
                            1, 
                            1)

 ff	(.D(d_int), 
	 .CLK(clk),
	 .CE(ce), 
	 .ACLR(dummy_in), 
	 .ASET(dummy_in),
	 .AINIT(reset), 
	 .SCLR (sclr),
	 .SSET(dummy_in),
	 .SINIT(dummy_in),
	 .Q(q_int));

endmodule

//******************************************************************************

//******************************************************************************


//******************************************************************************

//******************************************************************************


module vfft32_flip_flop_sclr_sset_v2_0 (d, clk, ce, reset, sclr, sset, q); 
 
input d;
input clk;
input ce;
input reset;
input sclr;
input sset;

output q;

wire d;
wire clk;
wire ce;
wire reset;
wire dummy_in = 1'b0;
wire q_int;

parameter zero_string = 1'b0;
wire d_int = d;
wire q = q_int;

 C_REG_FD_V2_0 #( zero_string, 
                            1,
                            0, 
                            1, 
                            0, 
                            1, 
                            1, 
                            0, 
                            1, 
                            "", 
                            0, 
                            1, 
                            1)

 ff	(.D(d_int), 
	 .CLK(clk),
	 .CE(ce), 
	 .ACLR(dummy_in), 
	 .ASET(dummy_in),
	 .AINIT(reset), 
	 .SCLR (sclr),
	 .SSET(sset),
	 .SINIT(dummy_in),
	 .Q(q_int));

endmodule

//******************************************************************************

//******************************************************************************


//******************************************************************************

//******************************************************************************


module vfft32_flip_flop_ainit_sclr_v2_0 (d, clk, ce, ainit, sclr, q); 
 
input d;
input clk;
input ce;
input ainit;
input sclr;
output q;

wire dummy_in = 1'b0;
wire q_int;
wire d_int;

parameter ainit_val = "1";
assign d_int = d;
assign q = q_int;

C_REG_FD_V2_0 #    (ainit_val, 
                            1,
                            0, 
                            1, 
                            0, 
                            1, 
                            1, 
                            0, 
                            0, 
                            "", 
                            0, 
                            1, 
                            1)

 ff	(.D(d_int), 
	 .CLK(clk),
	 .CE(ce), 
	 .ACLR(dummy_in), 
	 .ASET(dummy_in),
	 .AINIT(ainit), 
	 .SCLR (sclr),
	 .SSET(dummy_in),
	 .SINIT(dummy_in),
	 .Q(q_int));

endmodule


//******************************************************************************

//******************************************************************************

//******************************************************************************

//******************************************************************************


module vfft32_srflop_v2_0 (clk, ce, set, reset, q); 
 

input clk;
input ce;
input set;
input reset;
output q;

wire d;
wire clk;
wire ce;
wire set;
wire reset;
wire dummy_in = 1'b0;
wire q_int;

parameter zero_string = 1'b0;
wire d_int = d;
wire q = q_int;

 vfft32_or_a_b_v2_0  or_set (.a_in(set), 
                             .b_in(q_int),
                             .or_out(to_and)
                             );
 
vfft32_and_a_notb_v2_0 and_reset (.a_in(to_and),
                                  .b_in(reset),
                                  .and_out(to_dff)
                                  );

vfft32_flip_flop_sclr_v2_0 dff (.d(to_dff),
		                .clk(clk),
		                .ce(ce),
		                .sclr(dummy_in),
		                .reset(dummy_in),
		                .q (q_int)
                                );
               

endmodule


//******************************************************************************

//******************************************************************************

//******************************************************************************

//******************************************************************************

module vfft32_or_a_b_v2_0 (a_in, b_in, or_out);

input a_in;
input b_in;
output or_out;

 or #(1) o1(or_out, a_in, b_in);

endmodule

//******************************************************************************

//******************************************************************************

//******************************************************************************

//******************************************************************************

module vfft32_or_a_b_c_v2_0 (a_in, b_in, c_in, or_out);

input a_in;
input b_in;
input c_in;
output or_out;

or #(1) o1(or_out, a_in, b_in, c_in);

endmodule

//******************************************************************************

//******************************************************************************

//******************************************************************************

//******************************************************************************

module vfft32_and_a_b_v2_0 (a_in, b_in, and_out);

input a_in;
input b_in;
output and_out;

and #(1) a1 (and_out, a_in, b_in);

endmodule

//******************************************************************************

//******************************************************************************

//******************************************************************************

//******************************************************************************

module vfft32_and_a_notb_v2_0 (a_in, b_in, and_out);

input a_in;
input b_in;
output and_out;

 assign #1 and_out = a_in && (!b_in);

endmodule

//******************************************************************************

//******************************************************************************

//******************************************************************************

//******************************************************************************

module vfft32_nand_a_b_v2_0 (a_in, b_in, nand_out);

input a_in;
input b_in;
output nand_out;

 nand #(1) n1(nand_out, a_in, b_in);

endmodule

//******************************************************************************

//******************************************************************************

//******************************************************************************

//******************************************************************************

module vfft32_xor_a_b_v2_0 (a_in, b_in, xor_out);

input a_in;
input b_in;
output xor_out;

assign #1 xor_out = a_in ^ b_in;

endmodule

//******************************************************************************

//******************************************************************************



//******************************************************************************

//******************************************************************************

module vfft32_pkg_v2_0 (B_INPUT_WIDTH, W_WIDTH, a_value, b_value);
 
input B_INPUT_WIDTH;
input W_WIDTH;
input a_value;
input b_value;
reg latency;
reg delay_addr;
reg INTEGER;

function mult_latency;
input B_INPUT_WIDTH;
 begin
    case (B_INPUT_WIDTH)

2 : latency = 1; 
3 : latency = 1;
4 : latency = 1;
5 : latency = 2; 
6 : latency = 2; 
7 : latency = 2; 
8 : latency = 2; 
9 : latency = 3; 
10 : latency = 3; 
11 : latency = 3; 
12 : latency = 3; 
13 : latency = 3; 
14 : latency = 3; 
15 : latency = 3; 
16 : latency = 3; 
17 : latency = 4; 
18 : latency = 4; 
19 : latency = 4; 
20 : latency = 4; 
21 : latency = 4; 
22 : latency = 4; 
23 : latency = 4; 
24 : latency = 4; 
25 : latency = 4; 
26 : latency = 4; 
27 : latency = 4; 
28 : latency = 4; 
29 : latency = 4; 
30 : latency = 4; 
31 : latency = 4; 
32 : latency = 4; 
default : latency = 4;

    endcase
end

endfunction   

function bfly32_latency;
input W_WIDTH;
 begin
    case (W_WIDTH)

2 : latency = 6; 
3 : latency = 7;
4 : latency = 7;
5 : latency = 8; 
6 : latency = 8; 
7 : latency = 8; 
8 : latency = 8; 
9 : latency = 9; 
10 : latency = 9; 
11 : latency = 9; 
12 : latency = 9; 
13 : latency = 9; 
14 : latency = 9; 
15 : latency = 9; 
16 : latency = 9; 
17 : latency = 10; 
18 : latency = 10; 
19 : latency = 10; 
20 : latency = 10; 
21 : latency = 10; 
22 : latency = 10; 
23 : latency = 10; 
24 : latency = 10; 
25 : latency = 10; 
26 : latency = 10; 
27 : latency = 10; 
28 : latency = 10; 
29 : latency = 10; 
30 : latency = 10; 
31 : latency = 10; 
32 : latency = 10; 
default : latency = 10;

    endcase
end

endfunction 


function  get_delay_addr;

input W_WIDTH;
  begin  

case (W_WIDTH)


2: delay_addr = 4'b0110;

3: delay_addr = 4'b0111;
4: delay_addr = 4'b0111;

5: delay_addr = 4'b1000;
6: delay_addr = 4'b1000;
7: delay_addr = 4'b1000;
8: delay_addr = 4'b1000;

 9: delay_addr = 4'b1001;
10: delay_addr = 4'b1001;
11: delay_addr = 4'b1001;
12: delay_addr = 4'b1001;
13: delay_addr = 4'b1001;
14: delay_addr = 4'b1001;
15: delay_addr = 4'b1001;
16: delay_addr = 4'b1001;

17: delay_addr = 4'b1010;
18: delay_addr = 4'b1010;
19: delay_addr = 4'b1010;
20: delay_addr = 4'b1010;
21: delay_addr = 4'b1010;
22: delay_addr = 4'b1010;
23: delay_addr = 4'b1010;
24: delay_addr = 4'b1010;
25: delay_addr = 4'b1010;
26: delay_addr = 4'b1010;
27: delay_addr = 4'b1010;
28: delay_addr = 4'b1010;
29: delay_addr = 4'b1010;
30: delay_addr = 4'b1010;
31: delay_addr = 4'b1010;
32: delay_addr = 4'b1010;
default: delay_addr = 4'b0110;

endcase
end
endfunction
   

function  get_early_delay_addr;

input W_WIDTH;
  begin  

case (W_WIDTH)


2: delay_addr = 4'b0101;

3: delay_addr = 4'b0110;
4: delay_addr = 4'b0110;

5: delay_addr = 4'b0111;
6: delay_addr = 4'b0111;
7: delay_addr = 4'b0111;
8: delay_addr = 4'b0111;

 9: delay_addr = 4'b1000;
10: delay_addr = 4'b1000;
11: delay_addr = 4'b1000;
12: delay_addr = 4'b1000;
13: delay_addr = 4'b1000;
14: delay_addr = 4'b1000;
15: delay_addr = 4'b1000;
16: delay_addr = 4'b1000;

17: delay_addr = 4'b1001;
18: delay_addr = 4'b1001;
19: delay_addr = 4'b1001;
20: delay_addr = 4'b1001;
21: delay_addr = 4'b1001;
22: delay_addr = 4'b1001;
23: delay_addr = 4'b1001;
24: delay_addr = 4'b1001;
25: delay_addr = 4'b1001;
26: delay_addr = 4'b1001;
27: delay_addr = 4'b1001;
28: delay_addr = 4'b1001;
29: delay_addr = 4'b1001;
30: delay_addr = 4'b1001;
31: delay_addr = 4'b1001;
32: delay_addr = 4'b1001;

default: delay_addr = 4'b1001;

endcase
end
endfunction


//function rat;
//input value;
//parameter H = 12;
//parameter L = 16;
//begin
//case (value)
//0: out = 1'b0;
//1: out = 1'b1;
//H: out = 1'b1;
//L: out = 1'b0;
//default: out = x;
//endcase
//end
//endfunction


function greatest2;
 
input a_value;
input b_value;
 
 begin
 
  if (a_value >= b_value)
   INTEGER = a_value;
  else
   INTEGER = b_value;
  end
 
 endfunction

endmodule



//******************************************************************************

//******************************************************************************











