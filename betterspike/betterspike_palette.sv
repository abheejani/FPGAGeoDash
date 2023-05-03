module betterspike_palette (
	input logic [2:0] index,
	output logic [3:0] red, green, blue
);

localparam [0:7][11:0] palette = {
	{4'hD, 4'h3, 4'h9},
	{4'h1, 4'h3, 4'h6},
	{4'h9, 4'hA, 4'hC},
	{4'hE, 4'hE, 4'hF},
	{4'h0, 4'h0, 4'h0},
	{4'h2, 4'h5, 4'hA},
	{4'hC, 4'h6, 4'hB},
	{4'h1, 4'h2, 4'h3}
};

assign {red, green, blue} = palette[index];

endmodule

//////////////////////////////////////////


module background_palette (
	input logic [3:0] index,
	output logic [3:0] red, green, blue
);

localparam [0:15][11:0] palette = {
	{4'hF, 4'hF, 4'hF},
	{4'h2, 4'h2, 4'h2},
	{4'h8, 4'h8, 4'h8},
	{4'hD, 4'hD, 4'hD},
	{4'h5, 4'h5, 4'h5},
	{4'hB, 4'hB, 4'hB},
	{4'h0, 4'h0, 4'h0},
	{4'h7, 4'h7, 4'h7},
	{4'h9, 4'h9, 4'h9},
	{4'h3, 4'h3, 4'h3},
	{4'hE, 4'hE, 4'hE},
	{4'hC, 4'hC, 4'hC},
	{4'h2, 4'h2, 4'h2},
	{4'h6, 4'h6, 4'h6},
	{4'hA, 4'hA, 4'hA},
	{4'h1, 4'h1, 4'h1}
};

assign {red, green, blue} = palette[index];

endmodule




///////////////////////////////////////////////////////////////


module TestMenu_palette (
	input logic [2:0] index,
	output logic [3:0] red, green, blue
);

localparam [0:7][11:0] palette = {
	{4'h3, 4'hA, 4'hF},
	{4'h7, 4'h3, 4'h1},
	{4'hF, 4'hF, 4'hF},
	{4'h4, 4'h9, 4'h1},
	{4'h2, 4'hA, 4'hF},
	{4'h5, 4'hB, 4'hF},
	{4'hB, 4'hD, 4'hF},
	{4'h2, 4'h5, 4'hC}
};

assign {red, green, blue} = palette[index];

endmodule


///////////////////////////////////////////////////////////////

module background2_palette (
	input logic [3:0] index,
	output logic [3:0] red, green, blue
);

localparam [0:15][11:0] palette = {
	{4'h0, 4'h0, 4'h0},
	{4'hD, 4'hD, 4'hD},
	{4'h7, 4'h7, 4'h7},
	{4'hF, 4'hF, 4'hF},
	{4'h4, 4'h4, 4'h4},
	{4'hA, 4'hA, 4'hA},
	{4'h1, 4'h1, 4'h1},
	{4'h5, 4'h5, 4'h5},
	{4'hE, 4'hE, 4'hE},
	{4'h9, 4'h9, 4'h9},
	{4'h3, 4'h3, 4'h3},
	{4'hB, 4'hB, 4'hB},
	{4'h6, 4'h6, 4'h6},
	{4'h8, 4'h8, 4'h8},
	{4'hC, 4'hC, 4'hC},
	{4'hF, 4'hF, 4'hF}
};

assign {red, green, blue} = palette[index];

endmodule

///////////////////////////////////////////////////////////

module title_palette (
	input logic [3:0] index,
	output logic [3:0] red, green, blue
);

localparam [0:15][11:0] palette = {
	{4'h0, 4'h0, 4'h6},
	{4'hE, 4'hB, 4'h9},
	{4'hD, 4'h6, 4'h5},
	{4'h2, 4'h9, 4'hE},
	{4'h6, 4'h1, 4'h6},
	{4'h0, 4'h0, 4'h1},
	{4'h5, 4'h3, 4'h9},
	{4'hF, 4'hF, 4'hF},
	{4'hB, 4'h3, 4'h6},
	{4'h9, 4'h8, 4'hB},
	{4'h2, 4'h1, 4'h8},
	{4'h7, 4'hC, 4'hF},
	{4'h5, 4'h9, 4'hB},
	{4'h2, 4'h2, 4'h3},
	{4'h0, 4'h0, 4'h5},
	{4'h2, 4'h5, 4'h8}
};

assign {red, green, blue} = palette[index];

endmodule

///////////////////////////////////////////////////////////////

module background3_palette (
	input logic [3:0] index,
	output logic [3:0] red, green, blue
);

localparam [0:15][11:0] palette = {
	{4'h4, 4'h4, 4'h4},
	{4'hD, 4'hD, 4'hD},
	{4'h8, 4'h8, 4'h8},
	{4'h0, 4'h0, 4'h0},
	{4'hA, 4'hA, 4'hA},
	{4'hF, 4'hF, 4'hF},
	{4'h6, 4'h6, 4'h6},
	{4'h2, 4'h2, 4'h2},
	{4'hB, 4'hB, 4'hB},
	{4'hC, 4'hC, 4'hC},
	{4'h5, 4'h5, 4'h5},
	{4'h7, 4'h7, 4'h7},
	{4'h9, 4'h9, 4'h9},
	{4'h3, 4'h3, 4'h3},
	{4'hE, 4'hE, 4'hE},
	{4'h1, 4'h1, 4'h1}
};

assign {red, green, blue} = palette[index];

endmodule


///////////////////////////////////////////////////////////////
module finish_palette (
	input logic [3:0] index,
	output logic [3:0] red, green, blue
);

localparam [0:15][11:0] palette = {
	{4'h0, 4'h0, 4'h0},
	{4'hF, 4'hF, 4'hF},
	{4'h7, 4'h7, 4'h7},
	{4'h3, 4'h3, 4'h3},
	{4'hA, 4'hA, 4'hA},
	{4'hD, 4'hD, 4'hD},
	{4'h5, 4'h5, 4'h5},
	{4'h1, 4'h1, 4'h1},
	{4'hB, 4'hB, 4'hB},
	{4'hE, 4'hE, 4'hE},
	{4'h4, 4'h4, 4'h4},
	{4'h5, 4'h5, 4'h5},
	{4'hD, 4'hD, 4'hD},
	{4'h9, 4'h9, 4'h9},
	{4'h8, 4'h8, 4'h8},
	{4'h0, 4'h0, 4'h0}
};

assign {red, green, blue} = palette[index];

endmodule 