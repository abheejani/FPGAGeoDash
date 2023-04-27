

module cat_example (
	input logic [9:0] DrawX, DrawY, spriteX, spriteY, sprite_size, 
	input logic vga_clk, blank,
	output logic [3:0] red, green, blue
);


logic [10:0] rom_address;
logic [6:0] rom_q;
logic [15:0] spike_rom_address;
logic [15:0] spike_rom_q;
logic sprite_on;//new
logic [9:0]DistX, DistY, Size;//new
assign DistX = DrawX - spriteX;//new
assign DistY = DrawY - spriteY;//new
//assign Size = sprite_size;//new


/////////////////////// COLOR INSTANTIATIONS ////////////////////////////
logic [3:0] palette_red, palette_green, palette_blue;
logic [3:0] spike_palette_red, spike_palette_green, spike_palette_blue;
////////////////////////////////////////////////////////////////////////




//assign rom_address = ((DrawX * 10) / 20) + (((DrawY * 10) / 15) * 10);
assign rom_address = ((DrawX-spriteX) + (DrawY-spriteY)*15);









always_ff @ (posedge vga_clk) begin
	red <= 4'h0;
	green <= 4'h0;
	blue <= 4'h0;

	if (DistX < sprite_size && DistY < sprite_size ) begin //changed blank
		red <= palette_red;
		green <= palette_green;
		blue <= palette_blue;
	end
end













//////////////////////////////// ROM AND PALETTE INSATANTIATIONS //////////////////////////////////////////

cat_rom cat_rom (
	.clock   (vga_clk),
	.address (rom_address),
	.q       (rom_q)
);

cat_palette cat_palette (
	.index (rom_q),
	.red   (palette_red),
	.green (palette_green),
	.blue  (palette_blue)
);




endmodule
