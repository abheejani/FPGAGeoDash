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


//////////////////////////////////////////////////////////////////

module title_rom (
	input logic clock,
	input logic [16:0] address,
	output logic [3:0] q
);

logic [3:0] memory [0:89999] /* synthesis ram_init_file = "./title/title.mif" */;

always_ff @ (posedge clock) begin
	q <= memory[address];
end

endmodule

///////////////////////////////////////////////////////////////////

module finish_rom (
	input logic clock,
	input logic [11:0] address,
	output logic [3:0] q
);

logic [3:0] memory [0:2499] /* synthesis ram_init_file = "./finish/finish.mif" */;

always_ff @ (posedge clock) begin
	q <= memory[address];
end

endmodule


////////////////////////////////////////////////////////////////////

module background3_rom (
	input logic clock,
	input logic [16:0] address,
	output logic [3:0] q
);

logic [3:0] memory [0:89999] /* synthesis ram_init_file = "./background3/background3.mif" */;

always_ff @ (posedge clock) begin
	q <= memory[address];
end

endmodule

////////////////////////////////////////////////////////////////////

module background2_rom (
	input logic clock,
	input logic [16:0] address,
	output logic [3:0] q
);

logic [3:0] memory [0:76799] /* synthesis ram_init_file = "./background2/background2.mif" */;

always_ff @ (posedge clock) begin
	q <= memory[address];
end

endmodule


/////////////////////////////////////////////////////////////////////

module background_rom (
	input logic clock,
	input logic [16:0] address,
	output logic [3:0] q
);

logic [3:0] memory [0:76799] /* synthesis ram_init_file = "./background/background.mif" */;

always_ff @ (posedge clock) begin
	q <= memory[address];
end

endmodule

/////////////////////////////////////////////////////////////////////


