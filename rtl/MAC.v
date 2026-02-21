`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////                                              N+2
// Company: 
// Engineer: 
// 
// Create Date:    
// Design Name: 
// Module Name:    MAC 
// Proiect Name: 
// Target Devices: 
// Tool versions: 
// Description: 
//
// Dependencies: 
// 
// Revision: 
// Revision 0.01 - File Created
// Additional Comments: 
//
//////////////////////////////////////////////////////////////////////////////////
module MAC #(
	 parameter rows_kernel =3,
	 parameter kernel_size=9,
	 parameter k_div_3=3       // kernel_size/3= 9/3
	 )(
    input clk,
    input Enable,                   
    input I_data_valid,             
    input [23:0] I_data_1,
    input [23:0] I_data_2,
    input [23:0] I_data_3,    
    output reg signed [10:0] O_data_x,
    output reg signed [10:0] O_data_y,
    output   O_data_valid
    );
reg signed [7:0] kernel_x [0:8];
reg signed [7:0] kernel_y [0:8];
reg signed [89:0] prod_x;
reg signed [89:0] prod_y;
reg signed [10:0] sum_x1;
reg signed [10:0] sum_x2;
reg signed [10:0] sum_y1;
reg signed [10:0] sum_y2;
reg sum_y,sum_x,prod_x_valid, prod_y_valid;
reg [23:0] pixel_data_row[2:0];
integer i;
integer j;
integer k;
integer l;
integer n;


initial
begin


    kernel_x[0] =  -1;
    kernel_x[1] =  0;
    kernel_x[2] =  1;
    kernel_x[3] =  -2;
    kernel_x[4] =  0;
    kernel_x[5] =  2;
    kernel_x[6] =  -1;
    kernel_x[7] =  0;
    kernel_x[8] =  1;
    
    kernel_y[0] = -1;
    kernel_y[1] = -2;
    kernel_y[2] = -1;
    kernel_y[3] =  0;
    kernel_y[4] =  0;
    kernel_y[5] =  0;
    kernel_y[6] =  1;
    kernel_y[7] =  2;
    kernel_y[8] =  1;
end    
    


always@(*)
begin

pixel_data_row[0]=I_data_1;
pixel_data_row[1]=I_data_2;
pixel_data_row[2]=I_data_3;
end


always@(posedge clk)
begin	
if (Enable && I_data_valid)       
begin
	for(i=0;i<kernel_size;i=i+1)begin
	if (i!=1 && i!=4 && i!=7)
	prod_x[((kernel_size-i)*10-1)-:10]<=$signed({1'b0,pixel_data_row[i/3][((rows_kernel-i%3)*8-1)-:8]}) * $signed(kernel_x[i]);
	else 
	prod_x[((kernel_size-i)*10-1)-:10]<=0;
	end
 //middle slice multiplication missed 
	prod_x_valid<=1;
end
else
	prod_x_valid<=0;
	
end

always@(posedge clk)
begin
if (Enable && I_data_valid)
begin
	for(j=0;j<k_div_3;j=j+1)
	prod_y[((kernel_size-j)*10-1)-:10]<=$signed({1'b0,pixel_data_row[j/3][((rows_kernel-j%3)*8-1)-:8]}) * $signed(kernel_y[j]); 
	for(j=3;j<6;j=j+1)
	prod_y[((kernel_size-j)*10-1)-:10]<=0; 
	for(j=6;j<kernel_size;j=j+1)
	prod_y[((kernel_size-j)*10-1)-:10]<=$signed({1'b0,pixel_data_row[j/3][((rows_kernel-j%3)*8-1)-:8]}) * $signed(kernel_y[j]); 

    prod_y_valid<=1;
end
else
prod_y_valid<=0;
 
end

//middle row multiplication missed 


always @(*)
begin
sum_x1=0;

	for(k=0; k<3; k=k+2 )begin
	sum_x1= $signed(prod_x[((kernel_size-k)*10-1)-:10])+$signed(sum_x1); end
	for(k=3; k<4; k=k+1 )begin
	sum_x1= $signed(prod_x[((kernel_size-k)*10-1)-:10])+$signed(sum_x1); end

end
always @(*)
begin
sum_x2=0;
	for(n=5; n<7; n=n+1 )
	begin
	sum_x2= $signed(prod_x[((kernel_size-n)*10-1)-:10])+$signed(sum_x2);
	end
		for(n=8; n<9; n=n+1 )
	begin
	sum_x2= $signed(prod_x[((kernel_size-n)*10-1)-:10])+$signed(sum_x2);
	end        //6 adders 3 for x1, 3 for x2

end

always @(*)
begin
sum_y1=0;
	for(l=0;l<3;l=l+1)
	begin
	sum_y1= $signed(prod_y[((kernel_size-l)*10-1)-:10])+$signed(sum_y1);
	end

//	end
//always @(posedge clk)
//begin	
sum_y2=0; // 0 and sum at the same time? 
	for(l=6;l<9;l=l+1)
	begin
	sum_y2= $signed(prod_y[((kernel_size-l)*10-1)-:10])+$signed(sum_y2);// sum/
	end // HEre also 6 adders
end

always @ (posedge clk)
begin
sum_x   <=  prod_x_valid;
sum_y   <=  prod_y_valid;
//O_data_x    <= $signed(sum_x1+sum_x2);	
O_data_x    <= sum_x1+sum_x2;
O_data_y    <= sum_y1+sum_y2;
end

//assign O_data_x= sum_x1+sum_x2;	
//assign O_data_y= sum_y1+sum_y2;

assign O_data_valid= sum_x && sum_y ;                                                                    
endmodule
  
