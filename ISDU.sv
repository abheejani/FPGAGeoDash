module ISDU (   input logic Clk, hit, finish,//if we've collided, comes from color mapper
					input [7:0] keycode, 
//				output [7:0] jumpmotion,
//				input logic[2:0] Opcode,
				output internal_reset, //resets in ball file
				output screen,
				output pause, 
				output gameplay, 
				output show_title, 
				//output[7:0] deaths, 
				output inc_deaths
				);
				
//collision output inputted into ball file to determine reset
//collision determined by color mapper
	enum logic [4:0] {//Idle,
						//PauseIR1, 
						//PauseIR2,
						S_0,	//menu
						S_01, // Game state
						S_02, // Reset state
						S_P,	//pause state
//						S_03,  // jump states 
//						S_03_2,
//						S_03_3,
////						S_03_4,
////						S_03_5,
////						S_03_6, 
//						S_03_7
						S_04
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
			
			S_01 : begin
				if(hit) begin
				Next_state = S_02;
				end
				else if(finish) begin // if game ends, go to the menu bosssssssssss
				Next_state = S_04;
		 
				end
			
//				else if(keycode == 8'h1A)
//				Next_state = S_03;
				else if(keycode == 8'h13) begin//p key causes pause
					Next_state = S_P;
					
					end
				else if(keycode == 8'h10) begin //m key causes menu
					Next_state = S_04;
		
				end
				else begin
				Next_state = S_01; 
				end
			end
			S_02 : begin
				Next_state = S_01;
			end
			S_0 : begin
				if(keycode == 8'h2c)
				Next_state = S_01;
				else
				Next_state = S_0;	
			end
			S_P : begin
				if(keycode == 8'h13)
				Next_state = S_01;
				else
				Next_state = S_P;	
			end
			S_04 : begin
				Next_state = S_0;
			end
				
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
			//deaths = 7'b0000000;
			S_0  :
				begin
					internal_reset = 1'b0; 
					screen = 1'b0; 
					pause = 1'b0; 
					gameplay = 1'b0; 
					show_title = 1'b1;
					inc_deaths = 1'b0;
					end
			S_01 : 
				begin 
				internal_reset = 1'b0;  
				//jumpmotion = 0;
				screen = 1'b1;
				pause = 1'b0;
				gameplay = 1'b1; 
				show_title = 1'b0;
				inc_deaths = 1'b0;
				end
			S_02 : 
				begin
				// Put something here 
				internal_reset = 1'b1;
				//jumpmotion = 0; 
				screen = 1'b1; 
				pause = 1'b0;
				gameplay = 1'b0; 
				show_title = 1'b0;
				inc_deaths = 1'b1;
				end
			S_P  :
				begin
					internal_reset = 1'b0; 
					screen = 1'b1; 
					pause = 1'b1;
					gameplay = 1'b0; 
					show_title = 1'b0;
					inc_deaths = 1'b0;
					end
			S_04  :
				begin
					internal_reset = 1'b1;
					pause = 1'b0;
					gameplay = 1'b0; 
					screen = 1'b0;
					show_title = 1'b1;
					inc_deaths = 1'b0;
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
