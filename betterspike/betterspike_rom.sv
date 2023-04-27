module betterspike_rom (
	input logic clock,
	input logic [9:0] address,
	output logic [2:0] q
);

logic [2:0] memory [0:1023] /* synthesis ram_init_file = "./betterspike/betterspike.mif" */;

always_ff @ (posedge clock) begin
	q <= memory[address];
end

endmodule



/////////////////////////////////////////////////////////////////////////////////////


/////////////////////////////////////////////////////////////////////////////////////
module background_rom (
	input logic clock,
	input logic [17:0] address,
	output logic [3:0] q
);

logic [3:0] memory [0:249999] /* synthesis ram_init_file = "./background/background.mif" */;

always_ff @ (posedge clock) begin
	q <= memory[address];
end

endmodule
////////////////////////////////////////////////////////////////////////////////////