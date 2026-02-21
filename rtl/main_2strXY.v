`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 09/08/2025 11:03:00 AM
// Design Name: 
// Module Name: main_2strXY
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module main_2strXY#(parameter str_X=16,	                                //strides along horizontal direction:- 1 ==> 8
								                                                  //2==> 16
								                                                  //because here dealing with bits
	    parameter str_Y=1,
	    parameter N_str_x=48,
        parameter O_Datawidth=8,
		parameter M=3,		                                         //parallel OUTPUT data
			                                                 
		parameter N=3,		                                           //parallel MAC(all designed based on N= 3)
		parameter n=2,		                                          //log_2 (N)
		parameter Dataread_width=128,                              //
		parameter Address_width=14,	                               //
		parameter kernel_width=24,	                              //
        parameter slice_wdth=7,                                  //log_2 (input_Datawidth)
        parameter Datawrite_width=128
        
) 
(
input clk,
input reset,
output [N-1:0]               O_valid,
output [(N*O_Datawidth)-1 :0] O_data
//output [Address_width-1:0]    ptr 
// , output [Dataread_width-1:0]  data_1, data_2, data_3,
//output [slice_wdth-1:0]      slice
);


wire [Datawrite_width-1:0] dina, dinb;
wire [Address_width-1:0] ptr  ,  addra, addrb ;// 
wire                       wa, wb;
wire [Dataread_width-1:0]  data_porta, data_portb;
wire [N-1:0]               data_valid;
wire [N-1:0]               idle;
wire [Dataread_width-1:0]  data_1, data_2, data_3;//
 wire [slice_wdth-1:0]      slice;
wire [N-1:0]               O_valid_M, G_op_valid;
wire [(N*11)-1 :0]         Gx_data, Gy_data;
wire [(N*12)-1 :0]          G_mag;

blk_mem_gen_0 uut_bmg (
		.clka(clk), 
		.wea(wa), 
		.addra(addra), 
		.dina(dina), 
		.douta(data_porta), 
		.clkb(clk), 
		.web(wb), 
		.addrb(addrb), 
		.dinb(dinb), 
		.doutb(data_portb)
	);


DA_3_ii_strXY_2 #(.N(N), 
               .Nextra(0),
               .N_str_x(N_str_x ),
               .str_x(str_X)) uut_DA_strx ( 
            .clk(clk),
			.reset(reset ),
			.data_a(data_porta),
			.data_b(data_portb),
			.adr_1(addra),
			.adr_2(addrb),
			.wea(wa),
			.web(wb),
			.data_valid(data_valid), //For MAc
			.Idle_state(idle), 	// ==
			.slice_out(slice),						// slice is wire and will use in vector part select... declare as integer allowed??		
			.data_1(data_1),
			.data_2(data_2),
			.data_3(data_3),
			.ptr(ptr)
			);
// Parallel
genvar index;
generate 

for (index=0; index<N; index=index+1)
begin
MAC uut_MAC(
		.clk(clk),
		.I_data_valid(data_valid[index]), 
		.Enable(idle[index]),
		.I_data_1(data_1[(slice + index*str_X ) +: 24]), 
		.I_data_2(data_2[(slice + index*str_X ) +: 24]), 
		.I_data_3(data_3[(slice + index*str_X ) +: 24]), 
		.O_data_valid(O_valid_M[index]),
		.O_data_x(Gx_data[((index)*11)     +:  11]), 
		.O_data_y(Gy_data[((index)*11)     +:  11])	
		);


mag uut_Mag (
		.Gx_data(Gx_data[((index)*11)     +:  11]), 
		.Gy_data(Gy_data[((index)*11)     +:  11]), 
		.G_ip_valid(O_valid_M[index]), 
		.clk(clk), 
		.G_mag_op(G_mag[((index)*12)     +:  12]), 
		.G_op_valid(G_op_valid[index])
	);
 
 
	comp uut_CMP (
	    .clk(clk), 
		.G_in(G_mag[((index)*12)     +:  12]), 
		.G_valid(G_op_valid[index]), 
		.O_data(O_data[((index)*O_Datawidth)     +:  O_Datawidth]), 
		.O_valid(O_valid[index])
	);end		
endgenerate
endmodule
