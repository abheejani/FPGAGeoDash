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


module  ball ( input Reset, frame_clk, portal_status, up_down_status, // currently, Reset is the internal reset for when we collide. May need an FPGA rest down the line. 
					input [7:0] keycode, 
					//input logics replace params below
					input[64:0] Ball_X_Center, Ball_Y_Center,
					input [9:0] ball_floor,
					input pause,
               output [64:0]  BallX, BallY, BallS);
					
	///////////////////// All this is for the regular game //////////////////
    
    logic [64:0] Ball_X_Pos, Ball_X_Motion, Ball_Y_Pos, Ball_Y_Motion, Ball_Size;
	 
    parameter [9:0] Ball_X_Min=0;       // Leftmost point on the X axis
    parameter [9:0] Ball_X_Max=639;     // Rightmost point on the X axis
    logic [9:0] Ball_Y_Min;           // Topmost point on the Y axis
    logic [9:0] Ball_Y_Max;           // Bottommost point on the Y axis                    // HEADASSSSSSSARY HERE!!!!!!
    parameter [9:0] Ball_X_Step=1;      // Step size on the X axis
    parameter [9:0] Ball_Y_Step=5;      // Step size on the Y axis

    assign Ball_Size = 15;  // assigns the value 4 as a 10-digit binary number, ie "0000000100"
   
    always_ff @ (posedge Reset or posedge frame_clk)
    begin: Move_Ball
        if (Reset)  // Asynchronous Reset
        begin
				Ball_Y_Max <= ball_floor;
				Ball_Y_Min <= 0;
            Ball_Y_Motion <= 10'd0; //Ball_Y_Step;
				Ball_X_Motion <= 10'd0; //Ball_X_Step;
				Ball_Y_Pos <= Ball_Y_Max - Ball_Size; //Ball_Y_Center;
				Ball_X_Pos <= Ball_X_Center;
        end
		else if(pause) begin          
				Ball_Y_Max <= ball_floor;
				Ball_Y_Motion <= 10'd0; 
				Ball_X_Motion <= 10'd0;
				Ball_Y_Pos <= (Ball_Y_Pos + Ball_Y_Motion);  
				Ball_X_Pos <= (Ball_X_Pos + Ball_X_Motion);
		 end
			
       else begin // GENERAL GAMEPLAY STATES STARTING HERE
				if(portal_status == 1'b0 && up_down_status == 1'b0) begin          
						 Ball_Y_Max <= ball_floor;
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
				end // THE REGULAR PLAY ENDS HERE 
				
				
		///////////// PORTAL STUFF HERE /////////////////////////////////////////////
		
				// PORTAL LOGIC HERE: 
				if(portal_status == 1'b1 && up_down_status == 1'b0) begin         
				Ball_Y_Max <= ball_floor;
						 if(keycode == 8'h1A)begin // W pressed
								Ball_Y_Motion <= -8;
							end
							
						 if ( ((Ball_Y_Pos + Ball_Size) >= Ball_Y_Max - 1) && keycode != 8'h1A)begin  // Ball is at the bottom edge
							   Ball_Y_Motion <= 0;
						 end	  //(~ (Ball_Y_Step) + 1'b1);  // 2's complement.
							  
						 else if ( (Ball_Y_Pos - Ball_Size) <= 0)  // Ball is at the top edge, BOUNCE!
							  Ball_Y_Motion <= Ball_Y_Step;
						 else if(Ball_Y_Motion == 0 && Ball_Y_Pos + Ball_Size <= Ball_Y_Max -1 && keycode != 8'h1A) begin
							  Ball_Y_Motion <= 8;
						 end
				
							if(Ball_Y_Motion != 0) begin
								Ball_Y_Motion <= 0;
							end
							Ball_Y_Pos <= (Ball_Y_Pos + Ball_Y_Motion);  // Update ball position
							Ball_X_Pos <= (Ball_X_Pos + Ball_X_Motion);
							
							
				end // THE PORTAL PLAY ENDS HERE
				
				
				
		 ///////////// UPSIDE DOWN LEVEL STUFF HERE /////////////////////////////////////////////		
			   if(portal_status == 1'b0 && up_down_status == 1'b1) begin          
				Ball_Y_Min <= 0; // ball_floor;
						 if ( $signed(Ball_Y_Pos) <= $signed(Ball_Y_Min + 1))begin  // Ball is at the top edge
							if(keycode == 8'h1A)begin // W pressed
								Ball_Y_Max <= Ball_Y_Pos + Ball_Size + 100; 
								Ball_Y_Motion <= 5;
							end
							else Ball_Y_Motion <= 0;
						 end
						 else if ( (Ball_Y_Pos + Ball_Size) >= Ball_Y_Max)  // Ball is at the bottom edge, BOUNCE!
							  Ball_Y_Motion <= -Ball_Y_Step;
						else if(Ball_Y_Motion == 0 && Ball_Y_Pos >= Ball_Y_Min -1) begin
							Ball_Y_Motion <= -5;
						end
				
							Ball_Y_Pos <= (Ball_Y_Pos + Ball_Y_Motion);  // Update ball position
							Ball_X_Pos <= (Ball_X_Pos + Ball_X_Motion);
				end   // THE UPSIDE DOWN ENDS HERE 
				
				
				
			end // THE GAME PLAY ENDS HERE 
		end  

       
    assign BallX = Ball_X_Pos;
    assign BallY = Ball_Y_Pos;
    assign BallS = Ball_Size;
	 
endmodule






/*

		else if(portal_status == 1'b1) begin
				parameter [9:0] Ball_X_Min=0;       // Leftmost point on the X axis
				parameter [9:0] Ball_X_Max=639;     // Rightmost point on the X axis
				parameter [9:0] Ball_Y_Min=0;     		// Topmost point on the Y axis
				parameter [9:0] Ball_Y_Max=480;     // Bottommost point on the Y axis
				parameter [9:0] Ball_X_Step=1;      // Step size on the X axis
				parameter [9:0] Ball_Y_Step=5;

			
			 if(keycode == 8'h1A)begin // W pressed
					Ball_Y_Motion <= -5;
				end
				
			 if( ((Ball_Y_Pos + Ball_Size) >= Ball_Y_Max - 1) && keycode != 8'h1A)begin  // Ball is at the bottom edge and you are not pressing W
				Ball_Y_Motion <= 0;
			 end
			 else if ( (Ball_Y_Pos - Ball_Size) <= 0)  // Ball is at the top edge, turn it around
				   Ball_Y_Motion <= Ball_Y_Step;
				
			 Ball_Y_Pos <= (Ball_Y_Pos + Ball_Y_Motion);  // Update ball position
		end





*/






/////////spike////////////////////////////////////////////////////////////////////////////////////

module  spike ( input Reset, frame_clk,
					input [7:0] keycode,
					input pause, gameplay,
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
		 
		 else if(pause == 1'b1) begin
				spike_Y_Motion <= 10'd0; 
				spike_X_Motion <= 10'd0;
				spike_Y_Pos <= (spike_Y_Pos + spike_Y_Motion);  
				spike_X_Pos <= (spike_X_Pos + spike_X_Motion);
		 end
           
        else 
        begin	  if ((spike_Y_Pos + spike_Size) >= spike_Y_Max)  // spike is at the bottom edge, BOUNCE!
					  spike_Y_Motion <= (~ (spike_Y_Step) + 1'b1);    // 2's complement.
					  
				 else if ( (spike_Y_Pos - spike_Size) <= spike_Y_Min)  // spike is at the top edge, BOUNCE!
					  spike_Y_Motion <= spike_Y_Step;

					  
				 else
					begin
					
					  spike_Y_Motion <= spike_Y_Motion;  // spike is somewhere in the middle, don't bounce, just keep moving
					
				 
				 case (gameplay)
					1'b1 : begin

								spike_X_Motion <= -3;//A//changed to pause state
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




//////////////// Finish Line ///////////////////////////////

module  fin ( input Reset, frame_clk,
					input [7:0] keycode,
					input pause, gameplay,
					//input logics replace params below
					input[64:0] fin_X_Center, fin_Y_Center,
               output [64:0]  finX, finY, finS);
    
    logic [64:0] fin_X_Pos, fin_X_Motion, fin_Y_Pos, fin_Y_Motion, fin_Size;
	 
    //parameter [9:0] fin_X_Center=320;  // Center position on the X axis
    //parameter [9:0] fin_Y_Center=240;  // Center position on the Y axis
    parameter [9:0] fin_X_Min=0;       // Leftmost point on the X axis
    parameter [9:0] fin_X_Max=639;     // Rightmost point on the X axis
    parameter [9:0] fin_Y_Min=0;       // Topmost point on the Y axis
    parameter [9:0] fin_Y_Max=479;     // Bottommost point on the Y axis
    parameter [9:0] fin_X_Step=1;      // Step size on the X axis
    parameter [9:0] fin_Y_Step=1;      // Step size on the Y axis

   assign fin_Size = 50;  // assigns the value 4 as a 10-digit binary number, ie "0000000100"
	logic rst_flag; 
	assign rst_flag = Reset; 
	
	
    always_ff @ (posedge Reset or posedge frame_clk)
    begin: Move_fin
        if (Reset)  // Asynchronous Reset
        begin
            fin_Y_Motion <= 10'd0; //fin_Y_Step;
				fin_X_Motion <= 10'd0; //fin_X_Step;
				fin_Y_Pos <= fin_Y_Max - fin_Size - 1;
				fin_X_Pos <= fin_X_Center;
				//Reset <= 1'b0; 
       end
		 
		 else if(pause == 1'b1) begin
				fin_Y_Motion <= 10'd0; 
				fin_X_Motion <= 10'd0;
				fin_Y_Pos <= (fin_Y_Pos + fin_Y_Motion);  
				fin_X_Pos <= (fin_X_Pos + fin_X_Motion);
		 end
           
        else 
        begin	  if ((fin_Y_Pos + fin_Size) >= fin_Y_Max)  // fin is at the bottom edge, BOUNCE!
					  fin_Y_Motion <= (~ (fin_Y_Step) + 1'b1);    // 2's complement.
					  
				 else if ( (fin_Y_Pos - fin_Size) <= fin_Y_Min)  // fin is at the top edge, BOUNCE!
					  fin_Y_Motion <= fin_Y_Step;

					  
				 else
					begin
					
					  fin_Y_Motion <= fin_Y_Motion;  // fin is somewhere in the middle, don't bounce, just keep moving
					
				 
				 case (gameplay)
					1'b1 : begin

								fin_X_Motion <= -3;//A//changed to pause state
								fin_Y_Motion<= 0;
							  end 
					default: ;
			   endcase
				
				end
				 
				 fin_Y_Pos <= (fin_Y_Pos + fin_Y_Motion);  // Update fin position
				 fin_X_Pos <= (fin_X_Pos + fin_X_Motion);	
		end  
    end
       
    assign finX = fin_X_Pos;
   
    assign finY = fin_Y_Pos;
   
    assign finS = fin_Size;
    

endmodule









////////////////BACKGROUND//////////////////////////////////

module  bg ( input Reset, frame_clk,
					input [7:0] keycode,
					input pause, gameplay,
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
        
		else if(pause == 1'b1) begin
				bg_Y_Motion <= 10'd0; 
				bg_X_Motion <= 10'd0;
				bg_Y_Pos <= (bg_Y_Pos + bg_Y_Motion);  
				bg_X_Pos <= (bg_X_Pos + bg_X_Motion);
		 end
	
        else 
        begin	  if ((bg_Y_Pos + bg_Size) >= bg_Y_Max)  // bg is at the bottom edge, BOUNCE!
					  bg_Y_Motion <= (~ (bg_Y_Step) + 1'b1);    // 2's complement.
					  
				 else if ( (bg_Y_Pos - bg_Size) <= bg_Y_Min)  // bg is at the top edge, BOUNCE!
					  bg_Y_Motion <= bg_Y_Step;
					  
				 else
					begin
					
					  bg_Y_Motion <= bg_Y_Motion;  // bg is somewhere in the middle, don't bounce, just keep moving
					
				 case (gameplay)
					1'b1 : begin
								bg_X_Motion <= -0.5;//A
								bg_Y_Motion<= 0;
							  end 
					default: ;
			   endcase
				
				 case (keycode)
				   8'h04 : begin 
								bg_X_Motion <= -0.5;
								bg_Y_Motion <= 0;
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



////////////////SECOND BACKGROUND//////////////////////////////////

module  bg2 ( input Reset, frame_clk,
					input [7:0] keycode,
					input pause, gameplay,
					//input logics replace params below
					input[64:0] bg2_X_Center, bg2_Y_Center,
               output [64:0]  bg2X, bg2Y, bg2S);
    
    logic [64:0] bg2_X_Pos, bg2_X_Motion, bg2_Y_Pos, bg2_Y_Motion, bg2_Size;
	 
    //parameter [9:0] bg2_X_Center=320;  // Center position on the X axis
    //parameter [9:0] bg2_Y_Center=240;  // Center position on the Y axis
    parameter [9:0] bg2_X_Min=0;       // Leftmost point on the X axis
    parameter [9:0] bg2_X_Max=639;     // Rightmost point on the X axis
    parameter [9:0] bg2_Y_Min=0;       // Topmost point on the Y axis
    parameter [9:0] bg2_Y_Max=479;     // Bottommost point on the Y axis
    parameter [9:0] bg2_X_Step=1;      // Step size on the X axis
    parameter [9:0] bg2_Y_Step=1;      // Step size on the Y axis

    assign bg2_Size = 500;  // assigns the value 4 as a 10-digit binary number, ie "0000000100"
   
    always_ff @ (posedge Reset or posedge frame_clk)
    begin: Move_bg2
        if (Reset)  // Asynchronous Reset
        begin
            bg2_Y_Motion <= 10'd0; //bg2_Y_Step;
				bg2_X_Motion <= 10'd0; //bg2_X_Step;
				bg2_Y_Pos <= bg2_Y_Max - bg2_Size - 1;
				bg2_X_Pos <= bg2_X_Center; 
       end
        
		else if(pause == 1'b1) begin
				bg2_Y_Motion <= 10'd0; 
				bg2_X_Motion <= 10'd0;
				bg2_Y_Pos <= (bg2_Y_Pos + bg2_Y_Motion);  
				bg2_X_Pos <= (bg2_X_Pos + bg2_X_Motion);
		 end
	
        else 
        begin	  if ((bg2_Y_Pos + bg2_Size) >= bg2_Y_Max)  // bg2 is at the bottom edge, BOUNCE!
					  bg2_Y_Motion <= (~ (bg2_Y_Step) + 1'b1);    // 2's complement.
					  
				 else if ( (bg2_Y_Pos - bg2_Size) <= bg2_Y_Min)  // bg2 is at the top edge, BOUNCE!
					  bg2_Y_Motion <= bg2_Y_Step;

					  
				 else
					begin
					
					  bg2_Y_Motion <= bg2_Y_Motion;  // bg2 is somewhere in the middle, don't bounce, just keep moving
					
				 
				 case (gameplay)
					1'b1 : begin

								bg2_X_Motion <= -0.5;//A
								bg2_Y_Motion<= 0;
							  end 
					default: ;
			   endcase
				
				end
				 
				 bg2_Y_Pos <= (bg2_Y_Pos + bg2_Y_Motion);  // Update bg2 position
				 bg2_X_Pos <= (bg2_X_Pos + bg2_X_Motion);	
		end  
    end
       
    assign bg2X = bg2_X_Pos;
   
    assign bg2Y = bg2_Y_Pos;
   
    assign bg2S = bg2_Size;
    

endmodule

/////////////////// THIRD BACKGROUND //////////////////////////////

module  bg3 ( input Reset, frame_clk,
					input [7:0] keycode,
					input pause, gameplay,
					//input logics replace params below
					input[64:0] bg3_X_Center, bg3_Y_Center,
               output [64:0]  bg3X, bg3Y, bg3S);
    
    logic [64:0] bg3_X_Pos, bg3_X_Motion, bg3_Y_Pos, bg3_Y_Motion, bg3_Size;
	 
    //parameter [9:0] bg3_X_Center=320;  // Center position on the X axis
    //parameter [9:0] bg3_Y_Center=240;  // Center position on the Y axis
    parameter [9:0] bg3_X_Min=0;       // Leftmost point on the X axis
    parameter [9:0] bg3_X_Max=639;     // Rightmost point on the X axis
    parameter [9:0] bg3_Y_Min=0;       // Topmost point on the Y axis
    parameter [9:0] bg3_Y_Max=479;     // Bottommost point on the Y axis
    parameter [9:0] bg3_X_Step=1;      // Step size on the X axis
    parameter [9:0] bg3_Y_Step=1;      // Step size on the Y axis

    assign bg3_Size = 500;  // assigns the value 4 as a 10-digit binary number, ie "0000000100"
   
    always_ff @ (posedge Reset or posedge frame_clk)
    begin: Move_bg3
        if (Reset)  // Asynchronous Reset
        begin
            bg3_Y_Motion <= 10'd0; //bg3_Y_Step;
				bg3_X_Motion <= 10'd0; //bg3_X_Step;
				bg3_Y_Pos <= bg3_Y_Max - bg3_Size - 1;
				bg3_X_Pos <= bg3_X_Center; 
       end
        
		else if(pause == 1'b1) begin
				bg3_Y_Motion <= 10'd0; 
				bg3_X_Motion <= 10'd0;
				bg3_Y_Pos <= (bg3_Y_Pos + bg3_Y_Motion);  
				bg3_X_Pos <= (bg3_X_Pos + bg3_X_Motion);
		 end
	
        else 
        begin	  if ((bg3_Y_Pos + bg3_Size) >= bg3_Y_Max)  // bg3 is at the bottom edge, BOUNCE!
					  bg3_Y_Motion <= (~ (bg3_Y_Step) + 1'b1);    // 2's complement.
					  
				 else if ( (bg3_Y_Pos - bg3_Size) <= bg3_Y_Min)  // bg3 is at the top edge, BOUNCE!
					  bg3_Y_Motion <= bg3_Y_Step;

					  
				 else
					begin
					
					  bg3_Y_Motion <= bg3_Y_Motion;  // bg3 is somewhere in the middle, don't bounce, just keep moving
					
				 
				 case (gameplay)
					1'b1 : begin

								bg3_X_Motion <= -0.5;//A
								bg3_Y_Motion<= 0;
							  end 
					default: ;
			   endcase
				
				end
				 
				 bg3_Y_Pos <= (bg3_Y_Pos + bg3_Y_Motion);  // Update bg3 position
				 bg3_X_Pos <= (bg3_X_Pos + bg3_X_Motion);	
		end  
    end
       
    assign bg3X = bg3_X_Pos;
   
    assign bg3Y = bg3_Y_Pos;
   
    assign bg3S = bg3_Size;
    

endmodule


////////////////////// PLATFORM  //////////////////////////////////

module  platform ( input Reset, frame_clk,
					input [7:0] keycode,
					input pause, gameplay,
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
		else if(pause == 1'b1) begin
				pf_Y_Motion <= 10'd0; 
				pf_X_Motion <= 10'd0;
				pf_Y_Pos <= (pf_Y_Pos + pf_Y_Motion);  
				pf_X_Pos <= (pf_X_Pos + pf_X_Motion);
		 end
			
			
        else 
        begin	  if ((pf_Y_Pos + pf_Size) >= pf_Y_Max)  // pf is at the bottom edge, BOUNCE!
					  pf_Y_Motion <= (~ (pf_Y_Step) + 1'b1);    // 2's complement.
					  
				 else if ( (pf_Y_Pos - pf_Size) <= pf_Y_Min)  // pf is at the top edge, BOUNCE!
					  pf_Y_Motion <= pf_Y_Step;

					  
				 else
					begin
					
					  pf_Y_Motion <= pf_Y_Motion;  // pf is somewhere in the middle, don't bounce, just keep moving
					
				 
				case (gameplay)
					1'b1 : begin

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


//////////////////////// Portal ///////////////////////////////////////////

module  portal ( input Reset, frame_clk,
					input [7:0] keycode,
					input pause, gameplay,
					input[64:0] portal_X_Center, portal_Y_Center,
               output [64:0]  portalX, portalY, portalS);
    
    logic [64:0] portal_X_Pos, portal_X_Motion, portal_Y_Pos, portal_Y_Motion, portal_Size;
	 
    parameter [9:0] portal_X_Min=0;       // Leftmost point on the X axis
    parameter [9:0] portal_X_Max=639;     // Rightmost point on the X axis
    parameter [9:0] portal_Y_Min=0;       // Topmost point on the Y axis
    parameter [9:0] portal_Y_Max=479;     // Bottommost point on the Y axis
    parameter [9:0] portal_X_Step=1;      // Step size on the X axis
    parameter [9:0] portal_Y_Step=1;      // Step size on the Y axis

   assign portal_Size = 28;  // assigns the value 4 as a 10-digit binary number, ie "0000000100"
	logic rst_flag; 
	assign rst_flag = Reset; 
	

    always_ff @ (posedge Reset or posedge frame_clk)
    begin: Move_portal
        if (Reset)  // Asynchronous Reset
        begin
            portal_Y_Motion <= 10'd0; //portal_Y_Step;
				portal_X_Motion <= 10'd0; //portal_X_Step;
				portal_Y_Pos <= portal_Y_Max - portal_Size - 1;
				portal_X_Pos <= portal_X_Center;
				//Reset <= 1'b0; 
       end
		else if(pause == 1'b1) begin
				portal_Y_Motion <= 10'd0; 
				portal_X_Motion <= 10'd0;
				portal_Y_Pos <= (portal_Y_Pos + portal_Y_Motion);  
				portal_X_Pos <= (portal_X_Pos + portal_X_Motion);
		 end
			
			
        else 
        begin	  if ((portal_Y_Pos + portal_Size) >= portal_Y_Max)  // portal is at the bottom edge, BOUNCE!
					  portal_Y_Motion <= (~ (portal_Y_Step) + 1'b1);    // 2's complement.
					  
				 else if ( (portal_Y_Pos - portal_Size) <= portal_Y_Min)  // portal is at the top edge, BOUNCE!
					  portal_Y_Motion <= portal_Y_Step;

					  
				 else
					begin
					
					  portal_Y_Motion <= portal_Y_Motion;  // portal is somewhere in the middle, don't bounce, just keep moving
					
				case (gameplay)
					1'b1 : begin
								portal_X_Motion <= -3;//A
								portal_Y_Motion<= 0;
							  end 
					default: ;
			   endcase
				
				end
				 portal_Y_Pos <= (portal_Y_Pos + portal_Y_Motion);
				 portal_X_Pos <= (portal_X_Pos + portal_X_Motion);	
		end  
    end
       
    assign portalX = portal_X_Pos;
    assign portalY = portal_Y_Pos;
    assign portalS = portal_Size;
    
endmodule 