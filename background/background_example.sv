module background_example (
	input logic [9:0] DrawX, DrawY,
	input logic vga_clk, blank,
	output logic [3:0] red, green, blue
);

logic [17:0] rom_address;
logic [3:0] rom_q;

logic [3:0] palette_red, palette_green, palette_blue;

assign rom_address = ((DrawX * 500) / 640) + (((DrawY * 500) / 480) * 500);

always_ff @ (posedge vga_clk) begin
	red <= 4'h0;
	green <= 4'h0;
	blue <= 4'h0;

	if (blank) begin
		red <= palette_red;
		green <= palette_green;
		blue <= palette_blue;
	end
end

background_rom background_rom (
	.clock   (vga_clk),
	.address (rom_address),
	.q       (rom_q)
);

background_palette background_palette (
	.index (rom_q),
	.red   (palette_red),
	.green (palette_green),
	.blue  (palette_blue)
);

endmodule


/// TEMP LOCATION FOR SPIKE ON LOGIC BELOW

//    always_comb
//    begin:sprite_on_proc
//        if  ( DistX<Size && DistY<Size) 
//            sprite_on = 1'b1;
//        else 
//            sprite_on = 1'b0;
//     end 
	  ///always comb to determine spike on
//	  always_comb
//
//    begin:spike_on_proc
//		  //int flag = 1;
//        if  (spikeDistX < spikeSize && spikeDistY<spikeSize && spikeDistX > 0 && spikeDistY > 0)begin  
//				spike_on = 1'b1;
//				spike2_on = 1'b0;
//				spike3_on = 1'b0;
//				end
//		  else if(spikeDistX -150 < spikeSize&& spikeDistY<spikeSize)begin
//				spike_on = 1'b0;
//				spike2_on = 1'b1;
//				spike3_on = 1'b0; 
//			end
//		  else if(spikeDistX -250 < spikeSize && spikeDistY< spikeSize && spikeDistX > 0 && spikeDistY > 0)begin
//				spike_on = 1'b0;
//				spike2_on = 1'b0;
//				spike3_on = 1'b1; 
//			end
//		  else if(spikeDistX -550 < spikeSize&& spikeDistY<spikeSize)begin
//				spike_on = 1'b1;
//				spike2_on = 1'b0;	
//				spike3_on = 1'b0; 
//			end
//        else begin
//            spike_on = 1'b0;
//				spike2_on = 1'b0;
//				spike3_on = 1'b0; 
//				end
//     end 