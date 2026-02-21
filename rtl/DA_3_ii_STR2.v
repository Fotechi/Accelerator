`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 09/06/2025 12:31:51 PM
// Design Name: 
// Module Name: DA_3_ii_STR2
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


module DA_3_ii_strx_2 #(parameter next_row= 32, // 4096/128, 512*8=4096, 
                    parameter row3=64,     //32*2
                    parameter input_Datawidth= 128,
                    parameter slice_wdth=7,      //log_2 (input_Datawidth)
                    parameter output_Datawidth= 128,
                    parameter ptr_wdth=14,      //Address_width
                    parameter Address_width= 14,
                    parameter N =3,
				    parameter Nextra =1,		/* strX: 	1 (8 bits)	2(16 bits)	3 (24 bits) 
															Nextra :		N-2		N-1		N-1			*/

                    parameter str_y_1=1,		// 1 or 32 or ... multiples of 32 : since based on partitions of one row
                    parameter str_x=16,
					parameter position = 0,             /*                             str_x: 	1 (8 bits)	2(16 bits)	3 (24 bits) 
											Starting Bit# w.r.t next logical loc.=      pos:		   0		     0		      16		*/
                    parameter slide1=32,

					parameter N_str_x= 48,		   //	N*str_x 
		            parameter next_row_1= 33,                          // 1+next_row
		            parameter row3_1= 65,                             //1+row3  
		            
		            parameter starting_bit=16 ,                       /*    str_x :      1 (8 bits)	2(16 bits)	3 (24 bits) 
		                                                                      st bit:     16              64          72 (But for this temp data is not ready)    */
		            parameter S0  = 0 ,                                                          
		            parameter S0b = 1 ,                                                          
		            parameter S1  = 2 ,                                                          
		            parameter S1b = 3,                                                          
		            parameter S2  = 4,                                                          
		            parameter S2b = 5,
		            S3=6                                                       
)(

		input clk, 
		input reset,
		input [input_Datawidth-1:0] data_a,
		input [input_Datawidth-1:0] data_b,
		output reg [Address_width-1:0] adr_1,
		output reg [Address_width-1:0] adr_2,
		output reg wea,
		output reg web,
		output reg [N-1:0]  data_valid,   
		output     [N-1:0]  Idle_state,
		output reg [slice_wdth-1:0] slice_out,
		output reg [output_Datawidth-1:0] data_1, 
		output reg [output_Datawidth-1:0] data_2, 
		output reg [output_Datawidth-1:0] data_3,
				output reg [Address_width-1:0] ptr
				//output reg [2:0] state
//		output	reg [1:0] chk,n_chk,s,n_s,s_delay
 
    );
	 
reg data1nd2, data_valid_delay,d1;
reg [2:0] valid_loc;
//reg [Address_width-1:0] ptr=0;  //redeclaration of ANSI port not allowed
reg [slice_wdth-1:0] slice,slice_delay,s1;
reg [slice_wdth-1:0] slice1;
reg [1:0] C_grp;
reg [1:0] C;
//reg [1:0] chk,n_chk,s,n_s;
reg [2:0] State_delay,State1;
 reg [2:0] state ;
integer start;
//initial ptr=0;
reg [1:0] chk,n_chk,s,n_s,s_delay;

always @ (posedge clk)
begin
if(reset==1)
begin
data1nd2<=0;
//state<=S0;
wea<=0;
web<=0;
chk<=2;
end

else begin
 if(!data1nd2  && C==0)
begin
adr_1<=ptr;
adr_2<=ptr+next_row;
data1nd2<=1;
data_valid_delay<=0;              state<=S0;
slice_delay<=slice;		/* This makes to update value whenever required. Let slice changes at N egde but that change will be assigned to slice-out when this if block executes that is N+2 edge	*/

end

else if (data1nd2   && C_grp==0)
begin
adr_2 <= ptr+row3;
//web<=0;
data_valid_delay<=1;
data1nd2<=0;                 state<=S0b;
end

else if(!data1nd2  && C==1 )                                 
begin									
adr_1 <= ptr+1;		
adr_2 <= ptr+next_row_1;
chk<=n_chk;  
//wea<=0;  
//web<=0;
/*data_1<={data_a[0 +: (input_Datawidth-slide1)], data_1[ input_Datawidth-slide1 +: slide1]};
data_2<={data_b[0 +: input_Datawidth-slide1], data_2[input_Datawidth-slide1 +: slide1]} ;
temp_data_1<=data_a[input_Datawidth-slide1   +:  slide1];
temp_data_2<=data_b[input_Datawidth-slide1   +:  slide1];
*/
data1nd2<=1;                
data_valid_delay<=0;               state<=S1;
slice_delay<=slice1; //chk<=n_chk;                                                               //At N clk edge s_o ? suppose s1 changes in previous edge now given to s_o. good to use =
end

else if (data1nd2  && C_grp==1)
begin
adr_2 <= ptr+row3;

//web<=0;
/*data_3<={data_b[0 +: input_Datawidth-slide1], data_3[input_Datawidth-slide1  +: slide1]};
temp_data_3<=data_b[input_Datawidth-slide1   +:  slide1];
*/
data_valid_delay<=1;                                                      // For a MAC, now all the rows are available since data access from a dual port RAM so 2 locations at a time accessible.
data1nd2<=0;    
                             state<=S1b;
end

else if(!data1nd2  && C==2)                               
begin						  			
adr_1 <= ptr;		                          //≈ptr1
adr_2 <= ptr+next_row;                      //	≈ ptr1+next_row since ptr value incre
//wea<=0; 
//web<=0;
/*data_1<={data_a[0 +: 16], temp_data_1  , data_1[(slide1+16) +:  (input_Datawidth-slide1-16) ]};           //Since new log. loc used bytes are 2 when concate. thats why 16  so starting a new concatented. data but starting after 16                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                      
data_2<={data_b[0 +: 16], temp_data_2  , data_2[(slide1+16) +: input_Datawidth-slide1-16]} ;
*/
data1nd2<=1;
data_valid_delay<=0;
slice_delay<=slice;
                                 state<=S2;
end

else if(data1nd2  && C_grp==2)                               
begin									
adr_2 <= ptr+row3;                             //	≈ ptr1+next_row
//web<=0;
//data_3<={data_b[0 +: 16], temp_data_3  , data_3[(slide1+16) +: input_Datawidth-slide1-16]} ;
data1nd2<=0;
data_valid_delay<=1;
                         state<=S2b;
end

/*else if(C==3 || C_grp==3)
begin
if (slice==96)
slice_delay<=slice1;
else
slice_delay<=slice;
               state<=S3;          
data_valid_delay<=1;
//Whenever  C_grp==3 it means access valid=0 and hold previous data.
end
*/


else if(!data1nd2 && C==3)
begin
if (slice==112)
slice_delay<=slice-8;
else
slice_delay<=slice;
               state<=S3; 
data1nd2<=1;                        
data_valid_delay<=0;
end

else if(data1nd2 && C_grp==3)
begin

               state<=S3; 
data1nd2<=0;                        
data_valid_delay<=1;
end

else;
end
end


always @ (*)
begin
if (slice< (96-N*str_x) &&   slice1==0   &&((ptr+1) % next_row)!=0  ) begin
valid_loc	= 0;
//if (slice ==0)
C       =0;
//else
//C       =3;                       //access_valid=0;
end
else if (slice==96-N*str_x && ((ptr+1) % next_row)!=0) begin            //slice:72
valid_loc	= 3'b100;
//    if (ptr==0)
//    C       =0;
//    else
    C       =3;                       //access_valid=0;
end

else if (slice>96-N*str_x   &&  slice1==0 && ((ptr+1) % next_row)!=0)  begin    //right most slice w.r.t a logical location other than the first one portion control required. since slice value =16 as set previously
valid_loc	= 2;

C       =1;                         //access_valid=1; // in each case concatenate 1 time //next condition will chk whether one more time concatenated data to be given or not

end

else if (slice1!=0  && (slice==0) && ((ptr+1) % next_row)!=0 ) begin
valid_loc	= 0 ;
C       =2  ;                       //access_valid=1;

end

else if (slice1!=0  && (slice==16) && ((ptr+1) % next_row)!=0) begin
valid_loc	= 3'b100;
C       =2;
end

else if(slice<96-N*str_x && slice1 != 0   && (ptr+1) % next_row != 0 ) //data should be accord. to concat. data
begin
C       =3  ; 
//cgrp value change but data    
valid_loc   =0;
end



else if (slice <112-N*str_x && ((ptr+1) % next_row)==0) begin   
valid_loc	= 0;
C       =0;
end
//Here also zero-padding like in main_str_xy2 thats why size is widthxheight=256x255 and not 255 width
else if (slice==112-N*str_x && ((ptr+1) % next_row)==0) begin
valid_loc	= 3;
C       =3;
end
else
begin
valid_loc	= 4; //default case
C       =3;     //hold state

end

end


always @ (posedge clk)               					 
begin
if (!data1nd2)
C_grp<=C;
else
C_grp<=C_grp;
end



											/* w.r.t pixels  	1	2
											w.r.t bits str_x=	8	16 */
											
											
/*											
Why is Idle_state required ? 
        To deactivate Conv 
When ?
        e.g.    When 1 ROW completes and there are still extra parallel conv. operators
        or      						
        */					
//
assign Idle_state	= (slice_out > (112-N*str_x)) ?    3'd1   :   3'd7; //since given to MAC as Enable


 

/* ------------------------------------------------------------	 This update of slice and ptr block must be synchronized with MAC Block	: Done or not ⬅️  ------------------------------------------------------------
									e.g. 1 clk cycle before the MAC completes 													*/							

always @(posedge clk)               					 
begin
if (reset)
begin
ptr<=0;
slice<=0;
slice1<=0;
s<=0;
end
else if (!data1nd2)
case(valid_loc)                                 //values will update on next clk cycle            
	0 : 	begin				  			// same logical location (w.r.t BMG) but all data not covered   
			slice <= slice+N_str_x ;
			//access_valid<=0;					/*This signal updates on next clk edge but at that time data_3 is being read and we want it to be 1 so some way is required or just use it for data1nd2 reading */
			end
3'b100:		begin 						
	        slice1 <= 0;	
			slice <= slice+N_str_x ;               
			//ptr<=ptr+1;                          //Increment because for MAC, current location right most bytes require further bytes not available in current log. loc since only 16 bytes available per log. loc 
			
			end
		
    1: 		begin 							
			slice1 <= slice1+N_str_x ;               //temporary slice incremented since in case of strx=1 the temp if else block needs to execute 2 times
			
			//ptr1<=ptr+1;                              // Concatenate 2 bytes to match unused width with the current since same # was used in prevoius log.loc
			end
    2: 		begin 	
    		ptr<=ptr+1;			                      //  Next Logical location-officially location value incremented but not to access data just to make sure we are working on new log. location
    		s<=n_s;
    		if( s!=1 && (ptr+2) % next_row != 0 )                  //ptr+2: because suppose current ptr= 30. check here at 30 according to 31. next time ptr=31 and at next time slice must be according to ptr =31 
    		slice <=0;					// Now slice start this way continuing previous logical location slice but  
//			else if (n_s==2 && (ptr+2) % next_row != 0)
//			slice<=16;			
			else
			slice <= 16;                 // 16 bits used previously by log. loc=30 via concate.
			//slice1 <= 0 ;
			slice1 <= slice1+N_str_x ; // to make sure c 2 grp will execute
			end
				
			
	3 : 	begin		
	           s<=0;		  			        
	       // s<=n_s;
            ptr <= ptr + str_y_1 ;// 	Will execute whenever last/right_most_side logical portion of 1 actual/physical location requires C_grp_2 execution	
            slice <= 0 ;                  //To start over after 1 full row completed / covered for computations.
            slice1 <= 0 ;                            // Now next physicsl BRAM location starts with frist byte
            
            end
        
	default: begin				//---- At the start, very 1st time: ptr=0;slice=4096 ????  ;
			ptr<=ptr;
			slice<=slice;
			end
endcase
else; 

end

always @ (posedge clk)
begin
State_delay<=state;
//if(!data1nd2) begin
s1<=slice_delay;//end
slice_out<=s1;
d1<=data_valid_delay;
data_valid<={N{d1}};

end
always @ (*)
begin
State1=State_delay;
end

/*------------------------------------------------------------	Data Capture after How many clks depends on when the data out from BMG becomes valid = 1 clk cycle  ------------------------------------------------------------	*/
always @ (posedge clk)
begin

//if(C!=3 || C_grp!=3)
//begin
case (State1)
    S0:         begin
            data_1<=data_a;                          //Data will be available at next clk cycle or the current edge when address is given? "N E X T"
            data_2<=data_b;
            
            //State_delay<=S3;
			end
    S0b:         begin
            data_3<=data_b;
            //State_delay<=S3;
			
			end
    S1:         begin
           if (chk==0) begin
            data_1<={data_a[0 +: (input_Datawidth-slide1)], data_1[ input_Datawidth-slide1 +: slide1]}; //32
            data_2<={data_b[0 +: input_Datawidth-slide1], data_2[input_Datawidth-slide1 +: slide1]} ;
            end
            else if(chk==1) begin
            data_1<={data_a[0 +: (input_Datawidth-16)], data_1[ input_Datawidth-slide1 +: 16]}; //32
            data_2<={data_b[0 +: input_Datawidth-16], data_2[input_Datawidth-slide1 +: 16]} ;
            end
            else if (chk==2)begin
            data_1<={data_a[0 +: (input_Datawidth-48)], data_1[ input_Datawidth-64 +: 48]}; //8 elements*8bits=[0:63],64th bit starting 
            data_2<={data_b[0 +: input_Datawidth-48], data_2[input_Datawidth-64 +: 48]} ;
            end
            



//            temp_data_1<=data_a[input_Datawidth-slide1   +:  slide1];
//            temp_data_2<=data_b[input_Datawidth-slide1   +:  slide1];
          // State_delay<=S3;
			end
    S1b:        begin
            if (chk==0)            
            data_3<={data_b[0 +: input_Datawidth-slide1], data_3[input_Datawidth-slide1  +: slide1]};
            else if(chk==1)
            data_3<={data_b[0 +: input_Datawidth-16], data_3[input_Datawidth-slide1  +: 16]};
            else  if (chk==2) 
            data_3<={data_b[0 +: input_Datawidth-48], data_3[input_Datawidth-64  +: 48]};

 //           temp_data_3<=data_b[input_Datawidth-slide1   +:  slide1];
            //State_delay<=S3;

			
			end
    S2:         begin
            if (s==0)begin
            data_1<=data_a[start +: (input_Datawidth)];           //Since new log. loc used bytes 0                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                               
            data_2<=data_b[start +: (input_Datawidth)];
            
            end
            else if(s==1) begin
            data_1<=data_a[start +: (input_Datawidth-16)];           //Since new log. loc used bytes are 2 when concate. thats why 16  so starting a new concatented. data but starting after 16                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                      
            data_2<=data_b[start +: (input_Datawidth-16)];
            end
            else begin
            
            data_1<=data_a[start +: (input_Datawidth-16)];           //Since new log. loc used byte 1 when concate. thats why 8  so starting a new concatented. data but starting after 16                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                      
            data_2<=data_b[start +: (input_Datawidth-16)];
            s_delay<=2;
            end
            //State_delay<=S2b;


			
			end
    S2b:        begin
            if (s_delay==2)
            begin
            data_3<=data_b[16 +: (input_Datawidth-16)];s_delay=0;
            end
            else if (s==0)
            data_3<=data_b[start +: (input_Datawidth)];  //case1 : no X, 1: 2 bytes, 2: 1 byte 
            else if(s==1) 
            data_3<=data_b[start +: (input_Datawidth-16)];
             
            else;
            //State_delay<=S3;
            end
    S3:     begin
            if ((ptr+1) % next_row==0)
            begin
            data_1<={8'b0,data_1[8 +: input_Datawidth-8]};
            data_2<={8'b0,data_2[8 +: input_Datawidth-8]};
            data_3<={8'b0,data_3[8 +: input_Datawidth-8]};
            end
            else
            begin
            data_1<=data_1;
            data_2<=data_2;
            data_3<=data_3;
           end
            end
            
default:    begin				
			data_1<=data_1;                          //Data will be available at next clk cycle or the current edge when address is given? "N E X T"
            data_2<=data_2;
            data_3<=data_3;


            end
endcase
end
//end

always @ *
begin
case(s)
0:  begin
    start=0;
    n_s=1;      //next state
    end
1:  begin
    start=16;
//    if((ptr+1) % next_row == 0 )
//    n_s=0;
//    else
    n_s=2;
    
//    if(ptr%next_row == 1)   // with just next state assignment in vloc 2 
//    n_s=1;
//    else
//    n_s=2;
    end 
2:  begin
    start=16;
    n_s=0;
    end  
default: begin
         start=0;
         n_s=0;
         end  
endcase
end      

   always @ *
begin
case(chk)
2:  begin
    n_chk=0;      //next state
    end
0:  begin
    if((ptr) % next_row == 0 ) //New memory location started 
    n_chk=0;
    else
    n_chk=1;
    end 
1:  begin
    
    n_chk=2;
    end  
default: begin
         
         n_chk=0;
         end  
endcase
end      

   






endmodule



/*
Time (ns)	posedge#	adr1	adr2	adr3	d1	d2	d3
105		1		0	32	-	-	-	-
115		2		=	=	64	|---not valid---|
125		3		=	=	=	valid	valid	valid

delayed by 2 clk cycle = 1 current , 1 next 
			available after it|
*/



