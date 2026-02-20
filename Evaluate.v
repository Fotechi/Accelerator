module evaluate #(parameter o_dimen = 260100,
                            o_width=510)(); 
integer chk,i, j,k,counts,q;
integer fedge;
integer sb,mul;
real avg,sum;
reg [4095:0] imgData[0:511] ;
reg [4079:0] outData [0:509];
reg clk;
reg valid;
initial begin
j=1; 
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
            sb= imgData[(i/o_width)+1][(j+(i%o_width))*8 +: 8]-outData[i/o_width][(i%o_width)*8 +: 8];
            mul=sb * sb;
            sum=sum+mul; 
            
                            /*  i+1 - because 1st location not used
                                j+  - because 1st byte of each location not being used
                            */                               
            
            //if ((i+1) % o_width == 0)
            //j=j+3;  //stride in y & boundary 
            //else
            //j=j+1; //stride in x
            end
    avg = sum/260100;
    $display("psnr %f",avg);
    $stop;
end


endmodule

//  psnr= 21
