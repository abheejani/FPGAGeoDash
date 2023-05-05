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
							   input logic vga_clk, blank,Reset,
								input[64:0] spikeX, spikeY, spike_size, 
								input[64:0] finX, finY, fin_size,
								input[64:0] bgX, bgY, bg_size,
								input[64:0] bg2X, bg2Y, bg2_size,
								input[64:0] bg3X, bg3Y, bg3_size,
								input[64:0] pfX, pfY, pf_size,
								input[64:0] portalX, portalY, portal_size,
								input [7:0] keycode,
								input screen, inc_deaths, 
                        output logic [7:0]  Red, Green, Blue,  
								output hit, finish, portal, up_down,
								output[9:0] cur_floor, 
								input[8:0] deaths
								);
								

 // Hex display
 

///////////////////////////////////// SPIKE SPRITE ASSIGNMENT ////////////////////////
	 logic [3:0] palette_red, palette_green, palette_blue;
	 logic [9:0] rom_address;
	 logic [2:0] rom_q; 
	 
	 betterspike_rom betterspike_rom(
	.clock   (~vga_clk),
	.address (rom_address),
	.q       (rom_q) 
);
	
	betterspike_palette betterspike_palette(
	.index (rom_q),
	.red   (palette_red),
	.green (palette_green),
	.blue  (palette_blue) 
);



///////////////////////////////////// FINISH SPRITE ASSIGNMENT ////////////////////////
logic [15:0] fin_rom_address;
logic [4:0] fin_rom_q;
logic [3:0] fin_palette_red, fin_palette_green, fin_palette_blue;


finish_rom finish_rom (
	.clock   (~vga_clk),
	.address (fin_rom_address),
	.q       (fin_rom_q)
);

finish_palette finish_palette (
	.index (fin_rom_q),
	.red   (fin_palette_red),
	.green (fin_palette_green),
	.blue  (fin_palette_blue)
);


///////////////////////////////////// NUMBERS FOR DEATH COUNTER /////////////////////////
logic [10:0] number_address;
logic [0:0] Rom_q;
logic [3:0] Palette_red, Palette_green, Palette_blue;

numbers_rom numbers_rom (
                .clock   (~vga_clk),
                .address (number_address),
                .q(Rom_q)
);
 

numbers_palette numbers_palette (
                .index (Rom_q),
                .red   (Palette_red),
                .green (Palette_green),
                .blue  (Palette_blue)
);


////////////////////////////// FIRST BACKGROUND SPRITE ASSIGNMENT ///////////////////
logic [17:0] bg_rom_address;
logic [3:0] bg_rom_q;
logic [3:0] bg_palette_red, bg_palette_green, bg_palette_blue;
assign bg_rom_address = ((((DrawX-bgX) * 320) / 512) + (((DrawY-bgY) * 240) / 512) * 320);


background_rom background_rom (
	.clock   (~vga_clk),
	.address (bg_rom_address),
	.q       (bg_rom_q)
);

background_palette background_palette (
	.index (bg_rom_q),
	.red   (bg_palette_red),
	.green (bg_palette_green),
	.blue  (bg_palette_blue)
);


////////////////////////////// SECOND BACKGROUND SPRITE ASSIGNMENT ///////////////////
logic [17:0] bg2_rom_address;
logic [3:0] bg2_rom_q;
logic [3:0] bg2_palette_red, bg2_palette_green, bg2_palette_blue;
assign bg2_rom_address = ((((DrawX-bg2X) * 320) / 512) + (((DrawY-bg2Y) * 240) / 512) * 320);

background2_rom background2_rom (
	.clock   (~vga_clk),
	.address (bg2_rom_address),
	.q       (bg2_rom_q)
);

background2_palette background2_palette (
	.index (bg2_rom_q),
	.red   (bg2_palette_red),
	.green (bg2_palette_green),
	.blue  (bg2_palette_blue)
);

////////////////////////////// THIRD BACKGROUND SPRITE ASSIGNMENT ///////////////////

logic [16:0] bg3_rom_address;
logic [3:0] bg3_rom_q;
logic [3:0] bg3_palette_red, bg3_palette_green, bg3_palette_blue;
assign bg3_rom_address = ((((DrawX-bg3X) * 300) / 512) + (((DrawY-bg3Y) * 300) / 512) * 300);
 
background3_rom background3_rom (
	.clock   (~vga_clk),
	.address (bg3_rom_address),
	.q       (bg3_rom_q)
);

background3_palette background3_palette (
	.index (bg3_rom_q),
	.red   (bg3_palette_red),
	.green (bg3_palette_green),
	.blue  (bg3_palette_blue)
);



///////////////////////////// Title Screen instantiation /////////////////////
logic [16:0] title_rom_address;
logic [3:0] title_rom_q;
logic [3:0] title_palette_red, title_palette_green, title_palette_blue;
assign title_rom_address = ((DrawX * 300) >> 9) + (((DrawY * 300) >> 9) * 300);

title_rom title_rom (
	.clock   (~vga_clk),
	.address (title_rom_address),
	.q       (title_rom_q)
);

title_palette title_palette (
	.index (title_rom_q),
	.red   (title_palette_red),
	.green (title_palette_green),
	.blue  (title_palette_blue)
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
	 
	 //same logic but for finish
	 logic[64:0] finDistX, finDistY, finSize;
	 assign finDistX = DrawX - finX;
	 assign finDistY = DrawY - finY; 
	 assign finSize = fin_size;
	 
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
	 
	 //now for portals
	 logic[64:0] portalDistX, portalDistY, portalSize; 
	 assign portalDistX = DrawX - portalX;
    assign portalDistY = DrawY - portalY;
    assign portalSize = portal_size;
	 
	 // numberical assignments for deaths
	 int a, zero, ten, hundred;
	 assign a=deaths;
	 assign zero=a%10;
	 assign ten = ((a-zero)/10)+1;
	 assign hundred = a/100 + 2;
	 
	 
//////////////////////////////// Spike/Platform Collision Logic ////////////////////////////

	always_ff @ (posedge vga_clk) begin //always_comb begin:collision_detection
	
		 if(backgroundType == 4'b0000) begin // COLLISION FOR SCREEN 1
			  if ( (spriteX + Size >= spikeX+5 && spriteX < spikeX-5 + 32 && spriteY + Size >= spikeY) || 
					 (spriteX + Size >= pfX + 250 && spriteX < pfX + 28 + 250 && spriteY + Size >= pfY) ||
					 (spriteX + Size >= spikeX + 350 && spriteX < spikeX + 32 + 350 && spriteY + Size >= spikeY) ||
					 (spriteX + Size >= spikeX + 500 && spriteX < spikeX + 32 + 500 && spriteY + Size >= spikeY) ||
				  	 (spriteX + Size >= pfX + 650 && spriteX < pfX + 28 + 650 && spriteY + Size >= pfY) ||
					 (spriteX + Size >= spikeX + 750 && spriteX < spikeX + 32 + 750 && spriteY + Size >= spikeY) ||
					 (spriteX + Size >= spikeX + 900 && spriteX < spikeX + 32 + 900 && spriteY + Size >= spikeY) ||
					 (spriteX + Size >= pfX + 1050 && spriteX < pfX + 28 + 1050 && spriteY + Size >= pfY) ||
					 (spriteX + Size >= spikeX + 1150 && spriteX < spikeX + 32 + 1150 && spriteY + Size >= spikeY) ||
					 (spriteX + Size >= spikeX + 1350 && spriteX < spikeX + 32 + 1350 && spriteY + Size >= spikeY)
				  )begin
					hit<= 1'b1;
			  end
			  else begin
				hit <= 1'b0;
			  end
		 end
		 
		 else if(backgroundType == 4'b0001) begin // COLLISION FOR SCREEN 2
			 if ( (spriteX + Size >= spikeX+5 && spriteX < spikeX-5 + 32 && spriteY + Size >= spikeY) || 
					 (spriteX + Size >= spikeX + 150+5 && spriteX < spikeX + 32 + 150 -5 && spriteY + Size >= spikeY) ||
					 (spriteX + Size >= spikeX + 350 + 5 && spriteX < spikeX + 32 + 350 -5 && spriteY + Size >= spikeY) ||
					 (spriteX + Size >= spikeX + 550 + 5 && spriteX < spikeX + 32 + 550 -5 && spriteY + Size >= spikeY) ||
					 (spriteX + Size >= pfX + 750 + 5 && spriteX < pfX + 28 + 750  -5&& spriteY + Size >= pfY) ||
					 (spriteX + Size >= pfX + 1050 + 5 && spriteX < pfX + 28*3 + 1050  -5&& spriteY + Size >= pfY) ||
					 (spriteX + Size >= pfX + 1134 + 5 && spriteX < pfX + 28*3 + 1134  -5&& spriteY + Size >= pfY - 28) ||
					 //(spriteX + Size >= pfX + 1218 + 5 && spriteX < pfX + 28*3 + 1218 -5 && spriteY + Size >= pfY - 28*2) ||
					 (spriteX + Size >= pfX + 1520 && spriteX < pfX + 28 + 1520 && $signed(spriteY+Size) >= $signed(-20) && spriteY<28 && my_sprite_red != 4'hF) ||
					 (spriteX + Size >= pfX + 1720 && spriteX < pfX + 28 + 1720 && $signed(spriteY+Size) >= $signed(-20) && spriteY<28 && my_sprite_red != 4'hF) ||
					 (spriteX + Size >= pfX + 1920 && spriteX < pfX + 28 + 1920 && $signed(spriteY+Size) >= $signed(-20) && spriteY<28 && my_sprite_red != 4'hF) ||
					 (spriteX + Size >= pfX + 2120 && spriteX < pfX + 28 + 2120 && $signed(spriteY+Size) >= $signed(-20) && spriteY<28 && my_sprite_red != 4'hF) ||
					 (spriteX + Size >= pfX + 2300 && spriteX < pfX + 28 + 2300 && $signed(spriteY+Size) >= $signed(-20) && spriteY<28 && my_sprite_red != 4'hF) ||
					 (spriteX + Size >= pfX + 2480 && spriteX < pfX + 28 + 2480 && $signed(spriteY+Size) >= $signed(-20) && spriteY<28 && my_sprite_red != 4'hF) ||
					 (spriteX + Size >= pfX + 2660 && spriteX < pfX + 28 + 2660 && $signed(spriteY+Size) >= $signed(-20) && spriteY<28 && my_sprite_red != 4'hF) ||
					 (spriteX + Size >= pfX + 2840 && spriteX < pfX + 28 + 2840 && $signed(spriteY+Size) >= $signed(-20) && spriteY<28 && my_sprite_red != 4'hF) ||
					 //blank (spriteX + Size >= pfX + 2940 && spriteX < pfX + 28 + 2940 && spriteY+Size >= 0 && spriteY<28) ||
					 (spriteX + Size >= pfX + 3320 && spriteX < pfX + 28 + 3320 && $signed(spriteY+Size) >= $signed(-20) && spriteY<28 && my_sprite_red != 4'hF)	 
				  ) begin
					hit<= 1'b1;
			 end
			 else begin
				   hit<= 1'b0;
			 end
		 end
		 
		 else if(backgroundType == 4'b0010) begin
			if( (spriteX + Size >= spikeX+5 && spriteX < spikeX-5 + 32 && spriteY + Size >= spikeY) ||
				 (spriteX + Size >= spikeX+150+5 && spriteX < spikeX+150-5 + 32 && spriteY + Size >= spikeY) ||
				 (spriteX + Size >= spikeX+350+5 && spriteX < spikeX+350-5 + 32 && spriteY + Size >= spikeY) ||
				 (spriteX + Size >= spikeX+550+5 && spriteX < spikeX+550-5 + 32 && spriteY + Size >= spikeY) ||
				 (spriteX + Size >= pfX + 900 && spriteX < pfX + 500 + 900 && spriteY + Size >= pfY && my_sprite_blue != 4'hF) ||
				 (spriteX + Size >= pfX + 1000 && spriteX < pfX + 28 + 1000 && spriteY+Size >= pfY-100 && spriteY<pfY+28-100 && my_sprite_blue != 4'hF) ||
				 (spriteX + Size >= pfX + 1100 && spriteX < pfX + 28 + 1100 && spriteY+Size >= pfY-300 && spriteY<pfY+28-300 && my_sprite_blue != 4'hF) ||
				 (spriteX + Size >= pfX + 1200 && spriteX < pfX + 28 + 1200 && spriteY+Size >= pfY-200 && spriteY<pfY+28-200 && my_sprite_blue != 4'hF) ||
				 (spriteX + Size >= pfX + 1300 && spriteX < pfX + 28 + 1300 && spriteY+Size >= pfY-250 && spriteY<pfY+28-250 && my_sprite_blue != 4'hF) ||
				 (spriteX + Size >= pfX + 1450 && spriteX < pfX + 28 + 1450 && spriteY+Size >= pfY-150 && spriteY<pfY+28-150&& my_sprite_blue != 4'hF) ||
				 (spriteX + Size >= pfX + 1500 && spriteX < pfX + 28 + 1500 && spriteY+Size >= pfY-350 && spriteY<pfY+28-350&& my_sprite_blue != 4'hF) ||
				 (spriteX + Size >= pfX + 1700 && spriteX < pfX + 28 + 1700 && spriteY+Size >= pfY-100 && spriteY<pfY+28-100&& my_sprite_blue != 4'hF) ||
				 (spriteX + Size >= pfX + 1800 && spriteX < pfX + 28 + 1800 && spriteY+Size >= pfY-200 && spriteY<pfY+28-200&& my_sprite_blue != 4'hF) ||
				 (spriteX + Size >= pfX + 1900 && spriteX < pfX + 28 + 1900 && spriteY+Size >= pfY-150 && spriteY<pfY+28-150&& my_sprite_blue != 4'hF) ||
				 (spriteX + Size >= pfX + 2000 && spriteX < pfX + 28 + 2000 && spriteY+Size >= pfY-105 && spriteY<pfY+28-105&& my_sprite_blue != 4'hF) ||
				 (spriteX + Size >= pfX + 2100 && spriteX < pfX + 28 + 2100 && spriteY+Size >= pfY-200 && spriteY<pfY+28-200&& my_sprite_blue != 4'hF) ||
				 (spriteX + Size >= pfX + 2200 && spriteX < pfX + 28 + 2200 && spriteY+Size >= pfY-300 && spriteY<pfY+28-300&& my_sprite_blue != 4'hF) ||
				 (spriteX + Size >= pfX + 2300 && spriteX < pfX + 28 + 2300 && spriteY+Size >= pfY-150 && spriteY<pfY+28-150&& my_sprite_blue != 4'hF) ||
				 (spriteX + Size >= pfX + 2400 && spriteX < pfX + 28 + 2400 && spriteY+Size >= pfY-100 && spriteY<pfY+28-100&& my_sprite_blue != 4'hF) ||
				 (spriteX + Size >= pfX + 2500 && spriteX < pfX + 28 + 2500 && spriteY+Size >= pfY-250 && spriteY<pfY+28-250&& my_sprite_blue != 4'hF) ||
				 (spriteX + Size >= pfX + 2600 && spriteX < pfX + 28 + 2600 && spriteY+Size >= pfY-150 && spriteY<pfY+28-150&& my_sprite_blue != 4'hF) ||
				 ($signed(spriteY)<0)
				 ) begin
				 hit <= 1'b1;
			end
			else begin
				 hit <= 1'b0;
			end
		 end
		 
		 else begin 
				 hit <= 1'b0;
		 end
	end
	
	
///////////////////// Finish Line Collision Detection //////////////////////////
	
	always_comb begin:finish_detection
		if(backgroundType == 4'b0000) begin
			if(spriteX + Size >= spikeX + 1500) begin
				finish = 1'b1;
			end
			else begin
				finish = 1'b0;
			end
		end
		
		else if(backgroundType == 4'b0001) begin
			if(spriteX + Size >= pfX + 3500) begin
				finish = 1'b1;
			end
			else begin
				finish = 1'b0;
			end
		end
		
		else if(backgroundType == 4'b0010) begin
			if(spriteX + Size >= portalX+2900) begin
				finish = 1'b1;
			end
			else begin
				finish = 1'b0;
			end
		end
		else begin
			finish = 1'b0; 
		end
	end
	

//////////////////////// Portal Collision Detection ///////////////////////

	always_comb begin:portal_detection
		if(backgroundType == 4'b0010) begin
			if($signed(spriteX + Size) >= $signed(portalX + 750) && $signed(spriteX) < $signed(portalX+2750)) begin
				portal = 1'b1;
			end
			else begin
				portal = 1'b0;
			end
		end
		else begin
			portal = 1'b0; 
		end
	
	end


	
//////////////////////// Upside Down Collision Detection ///////////////////////

	always_comb begin:up_down_detection
		if(backgroundType == 4'b0001) begin
			if($signed(spriteX + Size) >= $signed(pfX + 1210) && $signed(spriteX) < $signed(pfX+3230)) begin
				up_down = 1'b1;
			end
			else begin
				up_down = 1'b0;
			end
		end
		else begin
			up_down = 1'b0; 
		end
	
	end
	

/////////////////////////////// Floor logic //////////////////////////////
	always_comb begin:floor_detection
		
			if(backgroundType == 4'b0000) begin  // FLOOR LOGIC FOR SCREEN 1
				if((spriteX + Size >= pfX + 250 && spriteX < pfX + 28 + 250) ||
					(spriteX + Size >= pfX + 650 && spriteX < pfX + 28 + 650) ||
					(spriteX + Size >= pfX + 1050 && spriteX < pfX + 28 + 1050)
				)begin // if within x bounds of platform
					cur_floor = 440; // raise the floor
				end
				else begin
					cur_floor = 480; // otherwise floor stays normal 
				end
			end
			else if(backgroundType == 4'b0001)begin // FLOOR LOGIC FOR SCREEN 2
				if(
					(spriteX + Size >= pfX + 750 && spriteX < pfX + 28 + 750) ||
					(spriteX + Size >= pfX + 1050 && spriteX < pfX + 28*3 + 1050)
					)
					cur_floor = 452-12;
				else if (
					(spriteX + Size >= pfX + 1134 && spriteX < pfX + 28*3 + 1134)
					)
					cur_floor = 424-12;
				else if (
					(spriteX + Size >= pfX + 1218 && spriteX < pfX + 28*3 + 1218)
					)
					cur_floor = 396-12;
				else if(spriteX + Size >= pfX + 1230 && spriteX < 3230)begin
					if((spriteX + Size >= pfX + 1520 && spriteX < pfX + 28 + 1520) ||
						(spriteX + Size >= pfX + 1720 && spriteX < pfX + 28 + 1720) ||
						(spriteX + Size >= pfX + 1920 && spriteX < pfX + 28 + 1920) ||
						(spriteX + Size >= pfX + 2120 && spriteX < pfX + 28 + 2120)
					)begin
						cur_floor = 34;
					end
					else
						cur_floor = 0;
				end
				else
					cur_floor = 480;
			end
			
			else 
				cur_floor = 480;
			
	end 

///////////////////////// SPRITE COLOR LOGIC //////////////////////
	logic[7:0] my_sprite_red;
	logic[7:0] my_sprite_blue;
	logic[7:0] my_sprite_green;
	
///////////////////////// BACKGROUND COLOR LOGIC //////////////////
	logic[7:0] my_bg_red;
	logic[7:0] my_bg_green;
	logic[7:0] my_bg_blue; 
	logic[3:0] backgroundType;
	logic[3:0] flag;

///////////////////////////////// Design Implementation ///////////////////////
always_ff @ (posedge vga_clk) begin
	Red <= 4'h0;
	Green <= 4'h0;
	Blue <= 4'h0;
	//assign flag = 4'b0000;
	if(screen == 1'b0) begin
		Red <= 4'h0; 
		Green <= 4'h0;
		Blue <= 4'h0;
		if(blank) begin
			if(keycode == 8'h1E)begin
				flag = 4'b0001;
			end
			else if(keycode == 8'h1F)begin
				flag = 4'b0010;
			end
			if(keycode == 8'h20)begin
				flag = 4'b0011;
			end
         
			case(flag)
				4'b0001 : begin
					Red <= bg_palette_red;
					Green <= bg_palette_green;
					Blue <= bg_palette_blue;
					backgroundType <= 4'b0000;
				end
				4'b0010 : begin
					Red <= bg2_palette_red;
					Green <= bg2_palette_green;
					Blue <= bg2_palette_blue;
					backgroundType <= 4'b0001;
				end 
				4'b0011 : begin
					Red <= bg3_palette_red;
					Green <= bg3_palette_green;
					Blue <= bg3_palette_blue;
					backgroundType <= 4'b0010;
				end 
				4'b0000 : begin
					if(DrawX > 50 && DrawX < 490)begin
						Red <= title_palette_red;
						Green <= title_palette_green;
						Blue <= title_palette_blue;
						backgroundType <= 4'b0000;
					end
				end 
				default : begin
					if(DrawX > 70 && DrawX < 570) begin
						Red <= title_palette_red;
						Green <= title_palette_green;
						Blue <= title_palette_blue;
						backgroundType <= 4'b0000;
					end
				end 
			endcase
		end

		if(DrawX>250 && DrawX<280 && DrawY>20 && DrawY<50) begin //Draw block To center
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
				8'h1D : begin //black-z
					my_sprite_red <= 4'h0;
					my_sprite_blue <= 4'h0; 
					my_sprite_green <= 4'h0; 								
				end
				default: ;
			endcase
		end
		else begin
		end
	end
		
	else begin
		if (blank) begin
				 if(backgroundType == 4'b0001)begin
					Red <= bg2_palette_red; 
					Green <= bg2_palette_green; 
					Blue <= bg2_palette_blue;
					flag <= 1'b0;
				 end
				 
				 else if(backgroundType == 4'b0010) begin
					Red <= bg3_palette_red; 
					Green <= bg3_palette_green; 
					Blue <= bg3_palette_blue;
					flag <= 1'b0;
				 end
				 else begin
					Red <= bg_palette_red; 
					Green <= bg_palette_green; 
					Blue <= bg_palette_blue;
					flag <= 1'b0;
				 end
		end
		if  ( DistX<Size && DistY<Size) begin 
				 Red <= my_sprite_red;
				 Green <= my_sprite_green;
				 Blue <= my_sprite_blue;
		end
		
		// SCREEN ONE DRAWING STARTING HERE /////////////////////////////////
		
		if(backgroundType == 4'b0000)begin  
			if (DrawX>528&&DrawY>110&&DrawY<=124&&DrawX<538)begin
                                number_address <= (((zero)*10+DrawX -527) + ((DrawY -111) * 100));
                                Red<=Palette_red;
                                Green <= Palette_green;
                                Blue <= Palette_blue;
         end
			if (DrawX>518&&DrawY>110&&DrawY<=124&&DrawX<528)begin
                                number_address <= (((ten)*10+DrawX -527) + ((DrawY -111) * 100));
                                Red<=Palette_red;
                                Green <= Palette_green;
                                Blue <= Palette_blue;
         end
			if (DrawX>508&&DrawY>110&&DrawY<=124&&DrawX<518)begin
                                number_address <= (((hundred)*10+DrawX -527) + ((DrawY -111) * 100));
                                Red<=Palette_red;
                                Green <= Palette_green;
                                Blue <= Palette_blue;
         end
			if(spikeDistX < spikeSize && spikeDistY-5<spikeSize)begin  
					 rom_address <= ((DrawX-spikeX) + (DrawY-spikeY-5)*32);
					 if(palette_red != 4'hD)begin 
						Red <= palette_red; 
						Green <= palette_green;
						Blue <= palette_blue; end
			
			end
			if(pfDistX - 250 < pfSize&& pfDistY<pfSize)begin
					 rom_address <= ((DrawX-pfX-250) + (DrawY-pfY)*32);
						Red <= 4'h0; 
						Green <= 4'h0;
						Blue <= 4'hF;
			end
			if(spikeDistX - 350 < spikeSize && spikeDistY - 5< spikeSize)begin
					 rom_address <= ((DrawX-spikeX-350) + (DrawY-spikeY-5)*32);
					 if(palette_red != 4'hD)begin 
						Red <= palette_red;
						Green <= palette_green;
						Blue <= palette_blue;
					 end
			end
			if(spikeDistX - 500 < spikeSize&& spikeDistY-5<spikeSize)begin
					 rom_address <= ((DrawX-spikeX-500) + (DrawY-spikeY-5)*32);
					 if(palette_red != 4'hD)begin 
						Red <= palette_red; 
						Green <= palette_green;
						Blue <= palette_blue;
					 end
			end
			if(pfDistX - 650 < pfSize&& pfDistY<pfSize)begin
					 rom_address <= ((DrawX-pfX-650) + (DrawY-pfY)*32);
						Red <= 4'h0; 
						Green <= 4'h0;
						Blue <= 4'hF;
			end
			if(spikeDistX - 750 < spikeSize&& spikeDistY-5<spikeSize)begin
					 rom_address <= ((DrawX-spikeX-750) + (DrawY-spikeY-5)*32);
					 if(palette_red != 4'hD)begin 
						Red <= palette_red; 
						Green <= palette_green;
						Blue <= palette_blue;
					 end
			end
			if(spikeDistX - 900 < spikeSize&& spikeDistY-5<spikeSize)begin
					 rom_address <= ((DrawX-spikeX-900) + (DrawY-spikeY-5)*32);
					 if(palette_red != 4'hD)begin 
						Red <= palette_red; 
						Green <= palette_green;
						Blue <= palette_blue;
					 end
			end
			if(pfDistX - 1050 < pfSize&& pfDistY<pfSize)begin
					 rom_address <= ((DrawX-pfX-1050) + (DrawY-pfY)*32);
						Red <= 4'h0; 
						Green <= 4'h0;
						Blue <= 4'hF;
			end
			if(spikeDistX - 1150 < spikeSize&& spikeDistY-5<spikeSize)begin
					 rom_address <= ((DrawX-spikeX-1150) + (DrawY-spikeY-5)*32);
					 if(palette_red != 4'hD)begin 
						Red <= palette_red; 
						Green <= palette_green;
						Blue <= palette_blue;
					 end
			end
			if(spikeDistX - 1350 < spikeSize&& spikeDistY-5<spikeSize)begin
					 rom_address <= ((DrawX-spikeX-1350) + (DrawY-spikeY-5)*32);
					 if(palette_red != 4'hD)begin 
						Red <= palette_red; 
						Green <= palette_green;
						Blue <= palette_blue;
					 end
			end
			if(finDistX - 1500 < finSize && finDistY < finSize*5)begin
					 fin_rom_address <= ((DrawX - finX - 1500) + (DrawY - spikeY)*50);
					 Red <= fin_palette_red; 
					 Green <= fin_palette_green;
					 Blue <= fin_palette_blue;
			end
		end
		
		// SCREEN TWO DRAWING STARTING HERE /////////////////////////////////
		
		else if(backgroundType == 4'b0001) begin
			if (DrawX>528&&DrawY>110&&DrawY<=124&&DrawX<538)begin
                                number_address <= (((zero)*10+DrawX -527) + ((DrawY -111) * 100));
                                Red<=Palette_red;
                                Green <= Palette_green;
                                Blue <= Palette_blue;
         end
			if (DrawX>518&&DrawY>110&&DrawY<=124&&DrawX<528)begin
                                number_address <= (((ten)*10+DrawX -527) + ((DrawY -111) * 100));
                                Red<=Palette_red;
                                Green <= Palette_green;
                                Blue <= Palette_blue;
			end
			if (DrawX>508&&DrawY>110&&DrawY<=124&&DrawX<518)begin
                                number_address <= (((hundred)*10+DrawX -527) + ((DrawY -111) * 100));
                                Red<=Palette_red;
                                Green <= Palette_green;
                                Blue <= Palette_blue;
         end
			if(spikeDistX < spikeSize && spikeDistY-5<spikeSize)begin  
					 rom_address <= ((DrawX-spikeX) + (DrawY-spikeY-5)*32);
					 if(palette_red != 4'hD)begin 
						Red <= palette_red; 
						Green <= palette_green;
						Blue <= palette_blue;
					 end
			end
			if(spikeDistX - 150 < spikeSize&& spikeDistY-5<spikeSize)begin
					 rom_address <= ((DrawX-spikeX-150) + (DrawY-spikeY-5)*32);
					 if(palette_red != 4'hD)begin 
						Red <= palette_red; 
						Green <= palette_green;
						Blue <= palette_blue;
					 end
			end
			if(pfDistX - 750 < pfSize&& pfDistY<pfSize)begin
					 rom_address <= ((DrawX-pfX-750) + (DrawY-pfY)*32);
						Red <= 4'h0; 
						Green <= 4'h0;
						Blue <= 4'hF;
			end
			if(pfDistX - 1050 < pfSize*3 && pfDistY<pfSize)begin
					 rom_address <= ((DrawX-pfX-1050) + (DrawY-pfY)*32);
						Red <= 4'h0; 
						Green <= 4'h0;
						Blue <= 4'hF;
			end
			if(pfDistX - 1134 < pfSize*3 && pfDistY+28<pfSize)begin
					 rom_address <= ((DrawX-pfX-1134) + (DrawY-pfY+28)*32);
						Red <= 4'h0; 
						Green <= 4'h0;
						Blue <= 4'hF;
			end
//			if(pfDistX - 1218 < pfSize*3 && pfDistY+28+28<pfSize)begin
//					 rom_address <= ((DrawX-pfX-1218) + (DrawY-pfY+28*2)*32);
//						Red <= 4'h0; 
//						Green <= 4'h0;
//						Blue <= 4'hF;
//			end
			if(pfDistX - 1520 < pfSize && pfDistY+460<pfSize)begin
					 rom_address <= ((DrawX-pfX-1520) + (DrawY-pfY+460)*32);
						Red <= 4'hF; 
						Green <= 4'h0;
						Blue <= 4'h0;
			end
			if(pfDistX - 1720 < pfSize && pfDistY+460<pfSize)begin
					 rom_address <= ((DrawX-pfX-1720) + (DrawY-pfY+460)*32);
						Red <= 4'hF; 
						Green <= 4'h0;
						Blue <= 4'h0;
			end
			if(pfDistX - 1920 < pfSize && pfDistY+460<pfSize)begin
					 rom_address <= ((DrawX-pfX-1920) + (DrawY-pfY+460)*32);
						Red <= 4'hF; 
						Green <= 4'h0;
						Blue <= 4'h0;
			end
			if(pfDistX - 2120 < pfSize && pfDistY+460<pfSize)begin
					 rom_address <= ((DrawX-pfX-2120) + (DrawY-pfY+460)*32);
						Red <= 4'hF; 
						Green <= 4'h0;
						Blue <= 4'h0;
			end
			if(pfDistX - 2300 < pfSize && pfDistY+460<pfSize)begin
					 rom_address <= ((DrawX-pfX-2300) + (DrawY-pfY+460)*32);
						Red <= 4'hF; 
						Green <= 4'h0;
						Blue <= 4'h0;
			end
			if(pfDistX - 2480 < pfSize && pfDistY+460<pfSize)begin
					 rom_address <= ((DrawX-pfX-2480) + (DrawY-pfY+460)*32);
						Red <= 4'hF; 
						Green <= 4'h0;
						Blue <= 4'h0;
			end
			if(pfDistX - 2660 < pfSize && pfDistY+460<pfSize)begin
					 rom_address <= ((DrawX-pfX-2660) + (DrawY-pfY+460)*32);
						Red <= 4'hF; 
						Green <= 4'h0;
						Blue <= 4'h0;
			end
			if(pfDistX - 2840 < pfSize && pfDistY+460<pfSize)begin
					 rom_address <= ((DrawX-pfX-2840) + (DrawY-pfY+460)*32);
						Red <= 4'hF; 
						Green <= 4'h0;
						Blue <= 4'h0;
			end
			if(pfDistX - 2940 < pfSize && pfDistY+460<pfSize)begin
					 rom_address <= ((DrawX-pfX-2940) + (DrawY-pfY+460)*32);
						Red <= 4'h0; 
						Green <= 4'hF;
						Blue <= 4'h0;
			end
			if(pfDistX - 3320 < pfSize && pfDistY+460<pfSize)begin
					 rom_address <= ((DrawX-pfX-3320) + (DrawY-pfY+460)*32);
						Red <= 4'hF; 
						Green <= 4'h0;
						Blue <= 4'h0;
			end			
			if(spikeDistX - 350 < spikeSize && spikeDistY-5< spikeSize)begin
					 rom_address <= ((DrawX-spikeX-350) + (DrawY-spikeY-5)*32);
					 if(palette_red != 4'hD)begin 
						Red <= palette_red;
						Green <= palette_green;
						Blue <= palette_blue;
					 end
			end
			if(spikeDistX - 550 < spikeSize&& spikeDistY-5<spikeSize)begin
					 rom_address <= ((DrawX-spikeX-550) + (DrawY-spikeY-5)*32);
					 if(palette_red != 4'hD)begin 
						Red <= palette_red; 
						Green <= palette_green;
						Blue <= palette_blue;
					 end
			end
			if(finDistX - 3500 < finSize && finDistY < finSize*5)begin
					 fin_rom_address <= ((DrawX - finX - 3500) + (DrawY - spikeY)*50);
					 Red <= fin_palette_red; 
					 Green <= fin_palette_green;
					 Blue <= fin_palette_blue;
			end
			else begin
			end
		end 
			
		// SCREEN THREE DRAWING STARTING HERE /////////////////////////////////
		
		else if(backgroundType == 4'b0010) begin
			if (DrawX>528&&DrawY>110&&DrawY<=124&&DrawX<538)begin
                                number_address <= (((zero)*10+DrawX -527) + ((DrawY -111) * 100));
                                Red<=Palette_red;
                                Green <= Palette_green;
                                Blue <= Palette_blue;
         end
			if (DrawX>518&&DrawY>110&&DrawY<=124&&DrawX<528)begin
                                number_address <= (((ten)*10+DrawX -527) + ((DrawY -111) * 100));
                                Red<=Palette_red;
                                Green <= Palette_green;
                                Blue <= Palette_blue;
			end
			if (DrawX>508&&DrawY>110&&DrawY<=124&&DrawX<518)begin
                                number_address <= (((hundred)*10+DrawX -527) + ((DrawY -111) * 100));
                                Red<=Palette_red;
                                Green <= Palette_green;
                                Blue <= Palette_blue;
         end
			if(spikeDistX < spikeSize && spikeDistY-5<spikeSize)begin  
					 rom_address <= ((DrawX-spikeX) + (DrawY-spikeY-5)*32);
					 if(palette_red != 4'hD)begin 
						Red <= palette_red; 
						Green <= palette_green;
						Blue <= palette_blue;
					 end
			end
			if(spikeDistX - 150 < spikeSize&& spikeDistY-5<spikeSize)begin
					 rom_address <= ((DrawX-spikeX-150) + (DrawY-spikeY-5)*32);
					 if(palette_red != 4'hD)begin 
						Red <= palette_red; 
						Green <= palette_green;
						Blue <= palette_blue;
					 end
			end 
			if(spikeDistX - 350 < spikeSize&& spikeDistY-5<spikeSize)begin
					 rom_address <= ((DrawX-spikeX-350) + (DrawY-spikeY-5)*32);
					 if(palette_red != 4'hD)begin 
						Red <= palette_red; 
						Green <= palette_green;
						Blue <= palette_blue;
					 end
			end
			if(spikeDistX - 550 < spikeSize&& spikeDistY-5<spikeSize)begin
					 rom_address <= ((DrawX-spikeX-550) + (DrawY-spikeY-5)*32);
					 if(palette_red != 4'hD)begin 
						Red <= palette_red; 
						Green <= palette_green;
						Blue <= palette_blue;
					 end
			end 
			if(pfDistX - 900 < pfSize*15 && pfDistY<pfSize)begin
					 rom_address <= ((DrawX-pfX-900) + (DrawY-pfY)*32);
						Red <= 4'h0; 
						Green <= 4'h0;
						Blue <= 4'hF;
			end
			if(pfDistX - 1000 < pfSize && pfDistY+100<pfSize)begin
					 rom_address <= ((DrawX-pfX-1000) + (DrawY-pfY+100)*32);
						Red <= 4'h0; 
						Green <= 4'h0;
						Blue <= 4'hF;
			end
			if(pfDistX - 1100 < pfSize && pfDistY+300<pfSize)begin
					 rom_address <= ((DrawX-pfX-1100) + (DrawY-pfY+300)*32);
						Red <= 4'h0; 
						Green <= 4'h0;
						Blue <= 4'hF;
			end
			if(pfDistX - 1200 < pfSize && pfDistY+200<pfSize)begin
					 rom_address <= ((DrawX-pfX-1200) + (DrawY-pfY+200)*32);
						Red <= 4'h0; 
						Green <= 4'h0;
						Blue <= 4'hF;
			end
			if(pfDistX - 1300 < pfSize && pfDistY+250<pfSize)begin
					 rom_address <= ((DrawX-pfX-1300) + (DrawY-pfY+250)*32);
						Red <= 4'h0; 
						Green <= 4'h0;
						Blue <= 4'hF;
			end
			if(pfDistX - 1450 < pfSize && pfDistY+150<pfSize)begin
					 rom_address <= ((DrawX-pfX-1450) + (DrawY-pfY+150)*32);
						Red <= 4'h0; 
						Green <= 4'h0;
						Blue <= 4'hF;
			end
			if(pfDistX - 1500 < pfSize && pfDistY+350<pfSize)begin
					 rom_address <= ((DrawX-pfX-1500) + (DrawY-pfY+350)*32);
						Red <= 4'h0; 
						Green <= 4'h0;
						Blue <= 4'hF;
			end
			if(pfDistX - 1700 < pfSize && pfDistY+100<pfSize)begin
					 rom_address <= ((DrawX-pfX-1700) + (DrawY-pfY+100)*32);
						Red <= 4'h0; 
						Green <= 4'h0;
						Blue <= 4'hF;
			end
			if(pfDistX - 1800 < pfSize && pfDistY+200<pfSize)begin
					 rom_address <= ((DrawX-pfX-1800) + (DrawY-pfY+200)*32);
						Red <= 4'h0; 
						Green <= 4'h0;
						Blue <= 4'hF;
			end
			if(pfDistX - 1900 < pfSize && pfDistY+150<pfSize)begin
					 rom_address <= ((DrawX-pfX-1900) + (DrawY-pfY+150)*32);
						Red <= 4'h0; 
						Green <= 4'h0;
						Blue <= 4'hF;
			end
			if(pfDistX - 2000 < pfSize && pfDistY+105<pfSize)begin
					 rom_address <= ((DrawX-pfX-2000) + (DrawY-pfY+105)*32);
						Red <= 4'h0; 
						Green <= 4'h0;
						Blue <= 4'hF;
			end
			if(pfDistX - 2100 < pfSize && pfDistY+200<pfSize)begin
					 rom_address <= ((DrawX-pfX-2100) + (DrawY-pfY+200)*32);
						Red <= 4'h0; 
						Green <= 4'h0;
						Blue <= 4'hF;
			end
			if(pfDistX - 2200 < pfSize && pfDistY+300<pfSize)begin
					 rom_address <= ((DrawX-pfX-2200) + (DrawY-pfY+300)*32);
						Red <= 4'h0; 
						Green <= 4'h0;
						Blue <= 4'hF;
			end
			if(pfDistX - 2300 < pfSize && pfDistY+150<pfSize)begin
					 rom_address <= ((DrawX-pfX-2300) + (DrawY-pfY+150)*32);
						Red <= 4'h0; 
						Green <= 4'h0;
						Blue <= 4'hF;
			end
			if(pfDistX - 2400 < pfSize && pfDistY+100<pfSize)begin
					 rom_address <= ((DrawX-pfX-2400) + (DrawY-pfY+100)*32);
						Red <= 4'h0; 
						Green <= 4'h0;
						Blue <= 4'hF;
			end
			if(pfDistX - 2100 < pfSize && pfDistY+200<pfSize)begin
					 rom_address <= ((DrawX-pfX-2100) + (DrawY-pfY+200)*32);
						Red <= 4'h0; 
						Green <= 4'h0;
						Blue <= 4'hF;
			end
			if(pfDistX - 2500 < pfSize && pfDistY+250<pfSize)begin
					 rom_address <= ((DrawX-pfX-2500) + (DrawY-pfY+250)*32);
						Red <= 4'h0; 
						Green <= 4'h0;
						Blue <= 4'hF;
			end
			if(pfDistX - 2600 < pfSize && pfDistY+150<pfSize)begin
					 rom_address <= ((DrawX-pfX-2600) + (DrawY-pfY+150)*32);
						Red <= 4'h0; 
						Green <= 4'h0;
						Blue <= 4'hF;
			end
			if(portalDistX - 750 < (portalSize-10))begin
						Red <= 4'h0; 
						Green <= 4'hF;
						Blue <= 4'h0;
			end
			if(portalDistX - 750 - 2000 < (portalSize-10))begin
						Red <= 4'h0; 
						Green <= 4'hF;
						Blue <= 4'h0;
			end
			if(finDistX - 2900 < finSize && finDistY < finSize*5)begin
					 fin_rom_address <= ((DrawX - finX - 2900) + (DrawY - spikeY)*50);
					 Red <= fin_palette_red; 
					 Green <= fin_palette_green;
					 Blue <= fin_palette_blue;
			end
			else begin
			end
		end
		else begin
		end
	end
end


endmodule

