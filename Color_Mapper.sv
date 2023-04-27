//Important things to figure out:
//agenda:
	//sprites-character, spikes, background, and also maybe platforms/blocks
	//jump logic 
	//collisions


//-------------------------------------------------------------------------
//    Color_Mapper.sv                                                    --
//    Stephen Kempf                                                      --
//    3-1-06                                                             --
//                                                                       --
//    Modified by David Kesler  07-16-2008                               --
//    Translated by Joe Meng    07-07-2013                               --
//                                                                       --
//    Fall 2014 Distribution                                             --
//                                                                       --
//    For use with ECE 385 Lab 7                                         --
//    University of Illinois ECE Department                              --
//-------------------------------------------------------------------------


module  color_mapper ( input [64:0] spriteX, spriteY, DrawX, DrawY, sprite_size, 
							   input logic vga_clk, blank,
								input[64:0] spikeX, spikeY, spike_size, 
								input[64:0] bgX, bgY, bg_size,
								input[64:0] pfX, pfY, pf_size,
								input [7:0] keycode,
								input screen,
                        output logic [7:0]  Red, Green, Blue,  
								output hit, 
								output[9:0] cur_floor 
								);
								

 

///////////////////////////////////// SPIKE SPRITE ASSIGNMENT ////////////////////////
	 logic spike_on;
	 logic [3:0] palette_red, palette_green, palette_blue;
	 logic [9:0] rom_address;
	 logic [2:0] rom_q; 
	 
	 betterspike_rom betterspike_rom(
	.clock   (vga_clk),
	.address (rom_address),
	.q       (rom_q) 
);
	
	betterspike_palette betterspike_palette(
	.index (rom_q),
	.red   (palette_red),
	.green (palette_green),
	.blue  (palette_blue) 
);


////////////////////////////// BACKGROUND SPRITE ASSIGNMENT ///////////////////
logic [17:0] bg_rom_address;
logic [3:0] bg_rom_q;
logic [3:0] bg_palette_red, bg_palette_green, bg_palette_blue;
assign bg_rom_address = ((((DrawX-bgX) * 500)/512 ) + (((DrawY-bgY) * 500)/512) * 500);

background_rom background_rom (
	.clock   (vga_clk),
	.address (bg_rom_address),
	.q       (bg_rom_q)
);

background_palette background_palette (
	.index (bg_rom_q),
	.red   (bg_palette_red),
	.green (bg_palette_green),
	.blue  (bg_palette_blue)
);


/////////////////////////////// LOGIC ASSIGNMENTS ////////////////////////////

    logic [64:0] DistX, DistY, Size;
	 assign DistX = DrawX - spriteX;
    assign DistY = DrawY - spriteY;
    assign Size = sprite_size;
	 
	 //same logic but for spike
	 logic[64:0] spikeDistX, spikeDistY, spikeSize; 
	 assign spikeDistX = DrawX - spikeX;
    assign spikeDistY = DrawY - spikeY;
    assign spikeSize = spike_size;
	 
	 //now for background
	 logic[64:0] bgDistX, bgDistY, bgSize;
	 assign bgDistX = DrawX - bgX; 
	 assign bgDistY = DrawY - bgY;
	 assign bgSize = bg_size; 
	 
	 //now for platform
	 logic[64:0] pfDistX, pfDistY, pfSize; 
	 assign pfDistX = DrawX - pfX;
    assign pfDistY = DrawY - pfY;
    assign pfSize = pf_size;
	 
	
	 

	 
//////////////////////////////// Collision Logic ////////////////////////////
	logic collision;
	always_comb
    begin:collision_detection
        if ( (spriteX + Size >= spikeX+5 && spriteX < spikeX-5 + 32 && spriteY + Size >= spikeY) || 
		       /*(spriteX + Size >= spikeX + 150 && spriteX < spikeX + 32 + 150 && spriteY + Size >= spikeY) || */
				 (spriteX + Size >= pfX + 250 && spriteX < pfX + 28 + 250 && spriteY + Size >= pfY) ||
				 (spriteX + Size >= spikeX + 350 && spriteX < spikeX + 32 + 350 && spriteY + Size >= spikeY) ||
				 (spriteX + Size >= spikeX + 550 && spriteX < spikeX + 32 + 550 && spriteY + Size >= spikeY) 
			  )
			hit= 1'b1;
        else 
			hit = 1'b0; 
     end 
	  
	   
	  
	  
/////////////////////////////// Floor logic //////////////////////////////
	always_comb
		begin:floor_detection
			if(spriteX + Size >= pfX + 250 && spriteX < pfX + 28 + 250)begin // if within x bounds of platform
				cur_floor = 435; // raise the floor
			end
			
			else begin
				cur_floor = 480; // otherwise floor stays normal 
			end
	end 
	  

///////////////////////// SPRITE COLOR LOGIC //////////////////////
	
	logic[7:0] my_sprite_red;
	logic[7:0] my_sprite_blue;
	logic[7:0] my_sprite_green;
	

	
//	always_comb 
//		begin:decide_sprite_color
//		if(keycode == 8'h15) begin//red
//			my_sprite_red = 4'hF;
//			my_sprite_blue = 4'h0; 
//			my_sprite_green = 4'h0; 
//			end
//		if(keycode == 8'h0A) begin//green
//			my_sprite_red = 4'h0; 
//			my_sprite_blue = 4'h0; 
//			my_sprite_green = 4'hF;
//		end
//		if(keycode == 8'h05)begin //blue
//			my_sprite_red = 4'h0;
//			my_sprite_blue = 4'hF; 
//			my_sprite_green = 4'h0; 
//			end
//		else begin
//			my_sprite_red = 4'hF;
//			my_sprite_blue = 4'h0; 
//			my_sprite_green = 4'h0; 
//		end
//			
//		end
		
		
			
			
	//end 
 
	  

	  
	  
	  

	     
///////////////////////////////// Design Implementation ///////////////////////
always_ff @ (posedge vga_clk) begin
		Red <= 4'h0;
		Green <= 4'h0;
		Blue <= 4'h0;
		
		 
	if(screen == 1'b0) begin
		Red <= 4'h0;
		Green <= 4'h0;
		Blue <= 4'h0;
	end
		
	else begin
		if (blank) begin
				 Red <= bg_palette_red; 
				 Green <= bg_palette_green;
				 Blue <= bg_palette_blue;
		end
		if  ( DistX<Size && DistY<Size) begin 
				 Red <= my_sprite_red;
				 Green <= my_sprite_green;
				 Blue <= my_sprite_blue;
				 case (keycode)
					8'h15 : begin //red
						my_sprite_red <= 4'hF;
						my_sprite_blue <= 4'h0; 
						my_sprite_green <= 4'h0; 								
					end 
					8'h0A : begin //green
						my_sprite_red <= 4'h0;
						my_sprite_blue <= 4'h0; 
						my_sprite_green <= 4'hF; 								
					end 
					8'h05 : begin //blue
						my_sprite_red <= 4'h0;
						my_sprite_blue <= 4'hF; 
						my_sprite_green <= 4'h0; 								
					end 
					default: ;
			   endcase

		end
		if(spikeDistX < spikeSize && spikeDistY<spikeSize)begin  
				 rom_address <= ((DrawX-spikeX) + (DrawY-spikeY)*32);
				 if(palette_red != 4'hD)begin 
					Red <= palette_red; 
					Green <= palette_green;
					Blue <= palette_blue;
				 end
			end
		if(spikeDistX - 150 < spikeSize&& spikeDistY<spikeSize)begin
				 rom_address <= ((DrawX-spikeX-150) + (DrawY-spikeY)*32);
				 if(palette_red != 4'hD)begin 
					Red <= palette_red; 
					Green <= palette_green;
					Blue <= palette_blue;
				 end
		end
		if(pfDistX - 250 < pfSize&& pfDistY<pfSize)begin
				 rom_address <= ((DrawX-pfX-250) + (DrawY-pfY)*32);
					Red <= 4'h0; 
					Green <= 4'h0;
					Blue <= 4'hF;
		end
		if(spikeDistX - 350 < spikeSize && spikeDistY< spikeSize)begin
				 rom_address <= ((DrawX-spikeX-350) + (DrawY-spikeY)*32);
				 if(palette_red != 4'hD)begin 
					Red <= palette_red;
					Green <= palette_green;
					Blue <= palette_blue;
				 end
		end
		if(spikeDistX - 550 < spikeSize&& spikeDistY<spikeSize)begin
				 rom_address <= ((DrawX-spikeX-550) + (DrawY-spikeY)*32);
				 if(palette_red != 4'hD)begin 
					Red <= palette_red; 
					Green <= palette_green;
					Blue <= palette_blue;
				 end
		end
		else begin
			
		end
	end
end


endmodule

