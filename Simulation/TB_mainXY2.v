`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 09/08/2025 11:17:39 AM
// Design Name: 
// Module Name: TB_mainXY2
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


module TB_mainXY2;
    reg clk;
    reg RESET;
    wire [23:0] DATA_OUT;
    wire [2:0]  O_valid;
    wire [13:0]    ptr,addra;    
    wire [127:0]  data_1,data_2,data_3;
    wire [6:0]      slice;
    integer FILE11,FILE1;
    integer x,y; 

 main_2strXY uut_top(
 .clk(clk),
 .reset(RESET),
 .O_data(DATA_OUT),
 .O_valid(O_valid),
 .ptr(ptr)
 //,
// .addra(addra),
// .data_1(data_1),
// .slice(slice)
// ,
// .data_2(data_2),
// .data_3(data_3)
 );   
   initial begin
  clk=0;
  RESET=0;
  #100
  RESET=1;      
  #10 RESET=0;
  x=0; y=0;
  FILE11 = $fopen("Edges2.hex","w");
    FILE1 = $fopen("Edges2.bin","wb");

  end

always @(posedge clk)
begin
 if(O_valid==7)
 begin
    $fwrite(FILE11,"%h\n%h\n%h\n",DATA_OUT[7:0],DATA_OUT[15:8],DATA_OUT[23:16]); 
     $fwrite(FILE1,"%c%c%c",DATA_OUT[7:0],DATA_OUT[15:8],DATA_OUT[23:16]);    
 end
 //required for O
 else if (O_valid==1) begin
     $fwrite(FILE1,"%c",DATA_OUT[7:0]);
     $fwrite(FILE11,"%h\n",DATA_OUT[7:0]);  end
else;
 if(ptr == 16287)
   x<=#110 1;                                      //120 FOR STRX 2
  if(x==1) 
 begin 
 $fclose(FILE1); 
 $fclose(FILE11);
 $stop;
 end
end
  
  initial begin 
  forever #5 clk=~clk;  
  end

endmodule
