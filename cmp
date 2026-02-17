`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:     
// Design Name: 
// Module Name:    comp 
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
//////////////////////////////////////////////////////////////////////////////////
module comp#(parameter Th=75)(
//    input [21:0] G_in,
    input clk,
    input [11:0] G_in,
    input G_valid,
    
    output  [7:0] O_data,
    output  O_valid
    );

/*always @(posedge clk) 
                             //Comb or sequential: as just comparison is being made
begin
    if (G_valid) begin
        if (G_in >= Th)
        O_data<=8'd255;
        else
        O_data<=8'd0;
    O_valid<=1; //This should be with odata signals conditional block
        end
    else
    begin
    O_data<=O_data;
    O_valid<=0;
    end
end
*/
//Combinational-dataflow
assign O_data = ( G_in >= Th) ? 8'hff : 8'h0;
assign O_valid = (G_valid) ? 1'b1 : 1'b0;

//Just double to uint8 conversion
/*assign O_data = ( G_in >= 255) ? 8'hff : 
                    (G_in>=70)? 8'hff  :
//                    8'h00;
                    G_in[7:0]; 
assign O_valid = (G_valid) ? 1'b1 : 1'b0;
*/

endmodule
