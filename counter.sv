module Death(input hit, input Clk, output[7:0] counter, input screen
);
logic [7:0] count;
logic a;
assign a=hit;
always_ff @ (posedge Clk)begin
	if(a) begin
		counter <= counter + 1;
	end
	if(screen == 1'b0) begin
		counter <= 0;
	end
	//counter<=count/10;
	
end 

endmodule 