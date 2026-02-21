`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:
// Design Name: 
// Module Name: main1_tb_str1
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


module main1_tb_str1;
    reg clk;
    reg RESET;
    wire [23:0] DATA_OUT;
    wire [2:0]  O_valid;
    wire [13:0]    ptr;    
    wire [127:0]  data_1,data_2,data_3;
    wire [6:0]      slice;
    integer FILE1,FILE2;
    integer x,y; 

 main1 uut_top(
 .clk(clk),
 .reset(RESET),
 .O_data(DATA_OUT),
 .O_valid(O_valid),
 .ptr(ptr)
 //,
 //.addra(addra),
// .data_1(data_1),
// .data_2(data_2),
// .data_3(data_3),
// .slice(slice)
 );  
 
   initial begin
  clk=0;
  RESET=0;
  #100
  RESET=1;      
  #10 RESET=0;
  x=0; y=0;
  FILE1 = $fopen("Edges2.bin","wb");

  end
 
always @(posedge clk)
begin
 if(O_valid==7)
 begin
     $fwrite(FILE1,"%c%c%c",DATA_OUT[7:0],DATA_OUT[15:8],DATA_OUT[23:16]);    
 end


 if(ptr == 16319)
    x<=#180 1;                                     
  if(x==1 ) 
 begin 
 $fclose(FILE1);
 $stop;
 end
 
 end

  
  initial begin 
  forever #5 clk=~clk;  
  end

endmodule

