//-------------------------------------------------------------------------
//    Ball.sv                                                            --
//    Viral Mehta                                                        --
//    Spring 2005                                                        --
//                                                                       --
//    Modified by Stephen Kempf 03-01-2006                               --
//                              03-12-2007                               --
//    Translated by Joe Meng    07-07-2013                               --
//    Fall 2014 Distribution                                             --
//                                                                       --
//    For use with ECE 298 Lab 7                                         --
//    UIUC ECE Department                                                --
//-------------------------------------------------------------------------


module  ball ( input Reset, frame_clk, // currently, Reset is the internal reset for when we collide. May need an FPGA rest down the line. 
					input [7:0] keycode,
					//input logics replace params below
					input[64:0] Ball_X_Center, Ball_Y_Center,
					input [9:0] ball_floor, 
               output [64:0]  BallX, BallY, BallS);
    
    logic [64:0] Ball_X_Pos, Ball_X_Motion, Ball_Y_Pos, Ball_Y_Motion, Ball_Size;
	 
    //parameter [9:0] Ball_X_Center=320;  // Center position on the X axis
    //parameter [9:0] Ball_Y_Center=240;  // Center position on the Y axis
    parameter [9:0] Ball_X_Min=0;       // Leftmost point on the X axis
    parameter [9:0] Ball_X_Max=639;     // Rightmost point on the X axis
    logic [9:0] Ball_Y_Min=380;     // Topmost point on the Y axis
    logic [9:0] Ball_Y_Max;        //480;     // Bottommost point on the Y axis                    // HEADASSSSSSSARY HERE!!!!!!
	 assign Ball_Y_Max = ball_floor;
    parameter [9:0] Ball_X_Step=1;      // Step size on the X axis
    parameter [9:0] Ball_Y_Step=5;      // Step size on the Y axis

    assign Ball_Size = 15;  // assigns the value 4 as a 10-digit binary number, ie "0000000100"
   
    always_ff @ (posedge Reset or posedge frame_clk)
    begin: Move_Ball
        if (Reset)  // Asynchronous Reset
        begin 
            Ball_Y_Motion <= 10'd0; //Ball_Y_Step;
				Ball_X_Motion <= 10'd0; //Ball_X_Step;
				Ball_Y_Pos <= Ball_Y_Max - Ball_Size; //Ball_Y_Center;
				Ball_X_Pos <= Ball_X_Center;
        end
           
        else 
        begin 
				 if ( (Ball_Y_Pos + Ball_Size) >= Ball_Y_Max - 1)begin  // Ball is at the bottom edge
					if(keycode == 8'h1A)begin // W pressed
						Ball_Y_Min <= Ball_Y_Pos - 100; 
						Ball_Y_Motion <= -5;
					end
					else Ball_Y_Motion <= 0;
				 end	  //(~ (Ball_Y_Step) + 1'b1);  // 2's complement.
					  
				 else if ( (Ball_Y_Pos - Ball_Size) <= Ball_Y_Min)  // Ball is at the top edge, BOUNCE!
					  Ball_Y_Motion <= Ball_Y_Step;
				else if(Ball_Y_Motion == 0 && Ball_Y_Pos + Ball_Size <= Ball_Y_Max -1) begin
					Ball_Y_Motion <= 5;
				end
		
					Ball_Y_Pos <= (Ball_Y_Pos + Ball_Y_Motion);  // Update ball position
					Ball_X_Pos <= (Ball_X_Pos + Ball_X_Motion);
				
				end
				 

			
			
	  /**************************************************************************************
	    ATTENTION! Please answer the following quesiton in your lab report! Points will be allocated for the answers!
		 Hidden Question #2/2:
          Note that Ball_Y_Motion in the above statement may have been changed at the same clock edge
          that is causing the assignment of Ball_Y_pos.  Will the new value of Ball_Y_Motion be used,
          or the old?  How will this impact behavior of the ball during a bounce, and how might that 
          interact with a response to a keypress?  Can you fix it?  Give an answer in your Post-Lab.
      **************************************************************************************/
      
			
		end  

       
    assign BallX = Ball_X_Pos;
   
    assign BallY = Ball_Y_Pos;
   
    assign BallS = Ball_Size;
    

endmodule


/////////spike////////////////////////////////////////////////////////////////////////////////////

module  spike ( input Reset, frame_clk,
					input [7:0] keycode,
					//input logics replace params below
					input[64:0] spike_X_Center, spike_Y_Center,
               output [64:0]  spikeX, spikeY, spikeS);
    
    logic [64:0] spike_X_Pos, spike_X_Motion, spike_Y_Pos, spike_Y_Motion, spike_Size;
	 
    //parameter [9:0] spike_X_Center=320;  // Center position on the X axis
    //parameter [9:0] spike_Y_Center=240;  // Center position on the Y axis
    parameter [9:0] spike_X_Min=0;       // Leftmost point on the X axis
    parameter [9:0] spike_X_Max=639;     // Rightmost point on the X axis
    parameter [9:0] spike_Y_Min=0;       // Topmost point on the Y axis
    parameter [9:0] spike_Y_Max=479;     // Bottommost point on the Y axis
    parameter [9:0] spike_X_Step=1;      // Step size on the X axis
    parameter [9:0] spike_Y_Step=1;      // Step size on the Y axis

   assign spike_Size = 32;  // assigns the value 4 as a 10-digit binary number, ie "0000000100"
	logic rst_flag; 
	assign rst_flag = Reset; 
	
	
    always_ff @ (posedge Reset or posedge frame_clk)
    begin: Move_spike
        if (Reset)  // Asynchronous Reset
        begin
            spike_Y_Motion <= 10'd0; //spike_Y_Step;
				spike_X_Motion <= 10'd0; //spike_X_Step;
				spike_Y_Pos <= spike_Y_Max - spike_Size - 1;
				spike_X_Pos <= spike_X_Center;
				//Reset <= 1'b0; 
       end
           
        else 
        begin	  if ((spike_Y_Pos + spike_Size) >= spike_Y_Max)  // spike is at the bottom edge, BOUNCE!
					  spike_Y_Motion <= (~ (spike_Y_Step) + 1'b1);    // 2's complement.
					  
				 else if ( (spike_Y_Pos - spike_Size) <= spike_Y_Min)  // spike is at the top edge, BOUNCE!
					  spike_Y_Motion <= spike_Y_Step;

					  
				 else
					begin
					
					  spike_Y_Motion <= spike_Y_Motion;  // spike is somewhere in the middle, don't bounce, just keep moving
					
				 
				 case (keycode)
					8'h04 : begin

								spike_X_Motion <= -3;//A
								spike_Y_Motion<= 0;
							  end 
					default: ;
			   endcase
				
				end
				 
				 spike_Y_Pos <= (spike_Y_Pos + spike_Y_Motion);  // Update spike position
				 spike_X_Pos <= (spike_X_Pos + spike_X_Motion);	
		end  
    end
       
    assign spikeX = spike_X_Pos;
   
    assign spikeY = spike_Y_Pos;
   
    assign spikeS = spike_Size;
    

endmodule



////////////////BACKGROUND//////////////////////////////////

module  bg ( input Reset, frame_clk,
					input [7:0] keycode,
					//input logics replace params below
					input[64:0] bg_X_Center, bg_Y_Center,
               output [64:0]  bgX, bgY, bgS);
    
    logic [64:0] bg_X_Pos, bg_X_Motion, bg_Y_Pos, bg_Y_Motion, bg_Size;
	 
    //parameter [9:0] bg_X_Center=320;  // Center position on the X axis
    //parameter [9:0] bg_Y_Center=240;  // Center position on the Y axis
    parameter [9:0] bg_X_Min=0;       // Leftmost point on the X axis
    parameter [9:0] bg_X_Max=639;     // Rightmost point on the X axis
    parameter [9:0] bg_Y_Min=0;       // Topmost point on the Y axis
    parameter [9:0] bg_Y_Max=479;     // Bottommost point on the Y axis
    parameter [9:0] bg_X_Step=1;      // Step size on the X axis
    parameter [9:0] bg_Y_Step=1;      // Step size on the Y axis

    assign bg_Size = 500;  // assigns the value 4 as a 10-digit binary number, ie "0000000100"
   
    always_ff @ (posedge Reset or posedge frame_clk)
    begin: Move_bg
        if (Reset)  // Asynchronous Reset
        begin
            bg_Y_Motion <= 10'd0; //bg_Y_Step;
				bg_X_Motion <= 10'd0; //bg_X_Step;
				bg_Y_Pos <= bg_Y_Max - bg_Size - 1;
				bg_X_Pos <= bg_X_Center;
				//Reset <= 1'b0; 
       end
           
        else 
        begin	  if ((bg_Y_Pos + bg_Size) >= bg_Y_Max)  // bg is at the bottom edge, BOUNCE!
					  bg_Y_Motion <= (~ (bg_Y_Step) + 1'b1);    // 2's complement.
					  
				 else if ( (bg_Y_Pos - bg_Size) <= bg_Y_Min)  // bg is at the top edge, BOUNCE!
					  bg_Y_Motion <= bg_Y_Step;

					  
				 else
					begin
					
					  bg_Y_Motion <= bg_Y_Motion;  // bg is somewhere in the middle, don't bounce, just keep moving
					
				 
				 case (keycode)
					8'h04 : begin

								bg_X_Motion <= -0.5;//A
								bg_Y_Motion<= 0;
							  end 
					default: ;
			   endcase
				
				end
				 
				 bg_Y_Pos <= (bg_Y_Pos + bg_Y_Motion);  // Update bg position
				 bg_X_Pos <= (bg_X_Pos + bg_X_Motion);	
		end  
    end
       
    assign bgX = bg_X_Pos;
   
    assign bgY = bg_Y_Pos;
   
    assign bgS = bg_Size;
    

endmodule


////////////////////// PLATFORM  //////////////////////////////////

module  platform ( input Reset, frame_clk,
					input [7:0] keycode,
					input[64:0] pf_X_Center, pf_Y_Center,
               output [64:0]  pfX, pfY, pfS);
    
    logic [64:0] pf_X_Pos, pf_X_Motion, pf_Y_Pos, pf_Y_Motion, pf_Size;
	 
    parameter [9:0] pf_X_Min=0;       // Leftmost point on the X axis
    parameter [9:0] pf_X_Max=639;     // Rightmost point on the X axis
    parameter [9:0] pf_Y_Min=0;       // Topmost point on the Y axis
    parameter [9:0] pf_Y_Max=479;     // Bottommost point on the Y axis
    parameter [9:0] pf_X_Step=1;      // Step size on the X axis
    parameter [9:0] pf_Y_Step=1;      // Step size on the Y axis

   assign pf_Size = 28;  // assigns the value 4 as a 10-digit binary number, ie "0000000100"
	logic rst_flag; 
	assign rst_flag = Reset; 
	
	
    always_ff @ (posedge Reset or posedge frame_clk)
    begin: Move_pf
        if (Reset)  // Asynchronous Reset
        begin
            pf_Y_Motion <= 10'd0; //pf_Y_Step;
				pf_X_Motion <= 10'd0; //pf_X_Step;
				pf_Y_Pos <= pf_Y_Max - pf_Size - 1;
				pf_X_Pos <= pf_X_Center;
				//Reset <= 1'b0; 
       end
           
        else 
        begin	  if ((pf_Y_Pos + pf_Size) >= pf_Y_Max)  // pf is at the bottom edge, BOUNCE!
					  pf_Y_Motion <= (~ (pf_Y_Step) + 1'b1);    // 2's complement.
					  
				 else if ( (pf_Y_Pos - pf_Size) <= pf_Y_Min)  // pf is at the top edge, BOUNCE!
					  pf_Y_Motion <= pf_Y_Step;

					  
				 else
					begin
					
					  pf_Y_Motion <= pf_Y_Motion;  // pf is somewhere in the middle, don't bounce, just keep moving
					
				 
				 case (keycode)
					8'h04 : begin

								pf_X_Motion <= -3;//A
								pf_Y_Motion<= 0;
							  end 
					default: ;
			   endcase
				
				end
				 pf_Y_Pos <= (pf_Y_Pos + pf_Y_Motion);  // Update pf position
				 pf_X_Pos <= (pf_X_Pos + pf_X_Motion);	
		end  
    end
       
    assign pfX = pf_X_Pos;
   
    assign pfY = pf_Y_Pos;
   
    assign pfS = pf_Size;
    

endmodule