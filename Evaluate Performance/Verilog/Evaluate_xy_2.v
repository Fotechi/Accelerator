`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 09/20/2025 01:05:38 PM
// Design Name: 
// Module Name: Evaluate_xy_2
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


module Evaluate_xy_2 #(parameter o_dimen = 256*256,
                            o_width=256)(); 
integer i,counts,q;
integer fedge;
integer sb,mul,sum;
real avg;
reg [4095:0] imgData[0:511] ;
reg [2047:0] outData [0:255];
reg clk;
reg valid;
initial begin

sum=0;
valid=0;
fedge=$fopen("Edges2.hex","r");
$readmemh("imgdatahex_4096x512.mem",imgData, 0, 511);

    clk = 1'b0;
    forever
    begin
        #5 clk = ~clk;
    end
 end

initial //seqntial blk wont work
begin
    for (i=0; i<o_dimen ; i=i+1)	begin
    counts=$fscanf(fedge,"%x\n",q[7:0]);	
    //outData[i/o_width][(i%o_width)*8 +: 8]=q[7:0];
    outData[i/o_width][(o_width-(i%o_width))*8-1 -: 8]=q[7:0];
    end
#10 valid=1;
end

initial  begin
   @(posedge valid)
        for (i=0; i<o_dimen ; i=i+1) begin
            @(posedge clk);
            sb= imgData[2*(i/o_width)+1][((2*i+1)%o_width)*8 +: 8]-outData[i/o_width][(i%o_width)*8 +: 8];
            mul=sb * sb;
            sum=sum+mul; 
            
                            /*  i+1 - because 1st location not used
                                j  - because stride x=2 
                            */                               
            
            //if ((i+1) % o_width == 0)
            //j=j+3;  //stride in y & boundary 
            //else
            //j=j+1; //stride in x
            end
    #10 avg = sum/65536;
    $display("psnr %f",avg);
    $stop;
end




//  psnr= 
endmodule
