module ISDU (   input logic Clk, hit,//if we've collided, comes from color mapper
					input [7:0] keycode, 
//					output [7:0] jumpmotion,
//				input logic[2:0] Opcode,
				output internal_reset, //resets in ball file
				output screen
				);

				
				
//collision output inputted into ball file to determine reset
//collision determined by color mapper
	enum logic [4:0] {//Idle,
						//PauseIR1, 
						//PauseIR2,
						S_0,	//menu
						S_01, // Game state
						S_02 // Reset state
//						S_03,  // jump states 
//						S_03_2,
//						S_03_3,
////						S_03_4,
////						S_03_5,
////						S_03_6, 
//						S_03_7
						} State, Next_state;
		
//reg[31:0] counter; 	
//logic flag;  

//		always_ff @ (posedge Clk)
//		begin
//			if(flag) 
//				counter <= 0;
//			
//			else
//				counter <= counter + 1;
//		end
	
	
	always_ff @ (posedge Clk)
	begin
			State <= Next_state;
	end
   
	///////////////////////////////////////////////////////////
	
	always_comb
	begin 
		// Default next state is staying at current state
		
		Next_state = State;
	
		// Assign next state
		unique case (State)                      
			S_01 : 
				if(hit)
				Next_state = S_02;
//				else if(keycode == 8'h1A)//The only intimate affection I've had is with my pillow in the middle of the night
//				Next_state = S_03; 
				else
				Next_state = S_01; 
			S_02 : 
				Next_state = S_01;
			S_0 : 
				if(keycode == 8'h2c)
				Next_state = S_01;
				else
				Next_state = S_0;	
				
//			S_03 : 
//				Next_state = S_03_2;	// start jump state
//			S_03_2 : 
//				Next_state = S_03_3; // mid jump
//			S_03_3 :
//				Next_state = S_03_7; // peak(!!!!!!!!!SETTING TO 3_7 FOR NOW, CHANGE LATER!!!!!!!!!!!!)
//			S_03_4 :
//				Next_state = S_03_5; // begin fall
//			S_03_5 :
//				Next_state = S_03_6; // midfall
//			S_03_6 :
//				Next_state = S_03_7; //back to zero
//			S_03_7 :
//				Next_state = S_01;   // regular play state 
				
			
			
		
				
//			S_32 : 
//				case (Opcode)
//					3'b000 : 
//						Next_state = S_01;	//Start  
//					3'b001:					
//						Next_state = S_02;	//Game
//					4'b010: 
//						Next_state = S_03;	//Jump
//					4'b011: 
//						begin
//						Next_state = PauseIR1;    // pause
//						end
//					default : 
//						Next_state = S_01;
//				endcase
//			S_01 : 
//				Next_state = S_18;
//			S_02 : 
//				Next_state = S_18;
//			default : 
//				Next_state = S_18;

		endcase
		
		case (State) // what is happening in each of the states 
			//Halted:; //LD_LED = 1'b1;
			S_0  :
				begin
					internal_reset = 1'b0; 
					screen = 1'b0; 
					
					end
			S_01 : 
				begin 
				internal_reset = 1'b0;  
				//jumpmotion = 0;
					screen = 1'b1; 

				end
			S_02 : 
				begin
				// Put something here 
				internal_reset = 1'b1;
				//jumpmotion = 0; 
				screen = 1'b1; 
				
				end
				
//			S_03 : 
//				begin 
//				internal_reset = 1'b0;  
//				jumpmotion = -10;
//
//				end
//			S_03_2 : 
//				begin 
//				internal_reset = 1'b0;  
//				jumpmotion = -6;
//
//				end
//			S_03_3 : 
//				begin 
//				internal_reset = 1'b0;  
//				jumpmotion = -3;
//
//				end
//			S_03_4 : 
//				begin 
//				internal_reset = 1'b0;  
//				jumpmotion = 3;
//				jump_ready = 1'b0;
//				end
//			S_03_5 : 
//				begin 
//				internal_reset = 1'b0;  
//				jumpmotion = 6;
//				end
//			S_03_6 : 
//				begin 
//				internal_reset = 1'b0;  
//				jumpmotion = 10;
//				end
//			S_03_7 : 
//				begin 
//				internal_reset = 1'b0;  
//				jumpmotion = 0;
//				end
			default : ;
		endcase
	end 

	
endmodule
