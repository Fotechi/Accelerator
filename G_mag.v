`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company:  
// Engineer: 
// 
// Create Date:    
// Design Name:  
// Module Name:    mag 
// Project Name: 
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
//////////////////////////////////////////////////////////////////////////////////              N
module mag(
    input clk,
    input signed [10:0] Gx_data,
    input signed [10:0] Gy_data,
    input G_ip_valid,
    
   output  reg [11:0] G_mag_op,                 // abs sum

    output  reg G_op_valid
    );

//reg [20:0] abs_Gx ;
//reg [20:0] abs_Gy ;
reg [10:0] abs_Gx ;
reg [10:0] abs_Gy ;



always @(posedge clk)
begin 
	if (G_ip_valid)                                                   
			begin
			//Gx
if (Gx_data < 0)
    abs_Gx <= -Gx_data;
    //abs_Gx <= $signed(Gx_data)*$signed(Gx_data); 
else
    abs_Gx <= Gx_data; 
			//Gy
if (Gy_data < 0)
   abs_Gy <= -Gy_data;
//   abs_Gy <= $signed(Gy_data) * $signed(Gy_data);
else
    abs_Gy <= Gy_data; 
G_op_valid<=1;	 
			end
	else
			begin
abs_Gx <= abs_Gx ;
abs_Gy <= abs_Gy ;	
G_op_valid<=0;	 
		
			end
	 
end

always @ (*)
G_mag_op =abs_Gx + abs_Gy;      // Sum
 
endmodule
