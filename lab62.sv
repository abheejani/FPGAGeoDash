//-------------------------------------------------------------------------
//                                                                       --
//                                                                       --
//      For use with ECE 385 Lab 62                                       --
//      UIUC ECE Department                                              --
//-------------------------------------------------------------------------


module lab62 (

      ///////// Clocks /////////
      input     MAX10_CLK1_50, 

      ///////// KEY /////////
      input    [ 1: 0]   KEY,

      ///////// SW /////////
      input    [ 9: 0]   SW,

      ///////// LEDR /////////
      output   [ 9: 0]   LEDR,

      ///////// HEX /////////
      output   [ 7: 0]   HEX0,
      output   [ 7: 0]   HEX1,
      output   [ 7: 0]   HEX2,
      output   [ 7: 0]   HEX3,
      output   [ 7: 0]   HEX4,
      output   [ 7: 0]   HEX5,

      ///////// SDRAM /////////
      output             DRAM_CLK,
      output             DRAM_CKE,
      output   [12: 0]   DRAM_ADDR,
      output   [ 1: 0]   DRAM_BA,
      inout    [15: 0]   DRAM_DQ,
      output             DRAM_LDQM,
      output             DRAM_UDQM,
      output             DRAM_CS_N,
      output             DRAM_WE_N,
      output             DRAM_CAS_N,
      output             DRAM_RAS_N,

      ///////// VGA /////////
      output             VGA_HS,
      output             VGA_VS,
      output   [ 3: 0]   VGA_R,
      output   [ 3: 0]   VGA_G,
      output   [ 3: 0]   VGA_B,


      ///////// ARDUINO /////////
      inout    [15: 0]   ARDUINO_IO,
      inout              ARDUINO_RESET_N 

);




logic Reset_h, vssig, blank, sync, VGA_Clk;
logic rst; 


//=======================================================
//  REG/WIRE declarations
//=======================================================
	logic SPI0_CS_N, SPI0_SCLK, SPI0_MISO, SPI0_MOSI, USB_GPX, USB_IRQ, USB_RST;
	logic [3:0] hex_num_4, hex_num_3, hex_num_1, hex_num_0; //4 bit input hex digits
	logic [1:0] signs;
	logic [1:0] hundreds;
	
	//new spikes 
	logic [64:0] drawxsig, drawysig, ballxsig, ballysig, ballsizesig, 
					 spikexsig, spikeysig, spikesizesig, 
					 finxsig, finysig, finsizesig; 
	logic [7:0] Red, Blue, Green;
	logic [7:0] keycode;
	
	// background
	logic[64:0] bgxsig, bgysig, bgsize; 
	
	// background2
	logic[64:0] bg2xsig, bg2ysig, bg2size; 
	
	// background3
	logic[64:0] bg3xsig, bg3ysig, by3size;
	
	// new platforms
	logic[64:0] pfxsig, pfysig, pfsizesig;
	
	// new portal
	logic[64:0] portalxsig, portalysig, portalsizesig;
	
	//deaths
	logic[6:0] deaths;
	
//=======================================================
//  Structural coding
//=======================================================
	assign ARDUINO_IO[10] = SPI0_CS_N;
	assign ARDUINO_IO[13] = SPI0_SCLK;
	assign ARDUINO_IO[11] = SPI0_MOSI;
	assign ARDUINO_IO[12] = 1'bZ;
	assign SPI0_MISO = ARDUINO_IO[12];
	
	assign ARDUINO_IO[9] = 1'bZ; 
	assign USB_IRQ = ARDUINO_IO[9];
		
	//Assignments specific to Circuits At Home UHS_20
	assign ARDUINO_RESET_N = USB_RST;
	assign ARDUINO_IO[7] = USB_RST;//USB reset 
	assign ARDUINO_IO[8] = 1'bZ; //this is GPX (set to input)
	assign USB_GPX = 1'b0;//GPX is not needed for standard USB host - set to 0 to prevent interrupt
	
	//Assign uSD CS to '1' to prevent uSD card from interfering with USB Host (if uSD card is plugged in)
	assign ARDUINO_IO[6] = 1'b1;
	
	//HEX drivers to convert numbers to HEX output
	HexDriver hex_driver4 (deaths[3:0], HEX4[6:0]);
	assign HEX4[7] = 1'b1;
	
	HexDriver hex_driver3 (hex_num_2, HEX3[6:0]);
	assign HEX3[7] = 1'b1;
	
	
	int d;
	reg [7:0] count;
	
	Death arnav(.Clk(VGA_VS), .hit(hit), .counter(count), .screen(screensig));
	
	
	HexDriver hex_driver1 (count[7:4], HEX1[6:0]);
	assign HEX1[7] = 1'b1;
	
	HexDriver hex_driver0 (count[3:0], HEX0[6:0]);
	assign HEX0[7] = 1'b1;
	
	//fill in the hundreds digit as well as the negative sign
	assign HEX5 = {1'b1, ~signs[1], 3'b111, ~hundreds[1], ~hundreds[1], 1'b1};
	assign HEX2 = {1'b1, ~signs[0], 3'b111, ~hundreds[0], ~hundreds[0], 1'b1};
	
	
	//Assign one button to reset
	////////////COMMENTING THIS OUT IS HELLA SUS
	assign {Reset_h}=~ (KEY[0]);

	//Our A/D converter is only 12 bit
	assign VGA_R = Red[3:0];
	assign VGA_B = Blue[3:0];
	assign VGA_G = Green[3:0];
	
	
	lab62_soc u0 (
		.clk_clk                           (MAX10_CLK1_50),  //clk.clk
		.reset_reset_n                     (1'b1),           //reset.reset_n
		.altpll_0_locked_conduit_export    (),               //altpll_0_locked_conduit.export
		.altpll_0_phasedone_conduit_export (),               //altpll_0_phasedone_conduit.export
		.altpll_0_areset_conduit_export    (),               //altpll_0_areset_conduit.export
		.key_external_connection_export    (KEY),            //key_external_connection.export

		//SDRAM
		.sdram_clk_clk(DRAM_CLK),                            //clk_sdram.clk
		.sdram_wire_addr(DRAM_ADDR),                         //sdram_wire.addr
		.sdram_wire_ba(DRAM_BA),                             //.ba
		.sdram_wire_cas_n(DRAM_CAS_N),                       //.cas_n
		.sdram_wire_cke(DRAM_CKE),                           //.cke
		.sdram_wire_cs_n(DRAM_CS_N),                         //.cs_n
		.sdram_wire_dq(DRAM_DQ),                             //.dq
		.sdram_wire_dqm({DRAM_UDQM,DRAM_LDQM}),              //.dqm
		.sdram_wire_ras_n(DRAM_RAS_N),                       //.ras_n
		.sdram_wire_we_n(DRAM_WE_N),                         //.we_n

		//USB SPI	
		.spi0_SS_n(SPI0_CS_N),
		.spi0_MOSI(SPI0_MOSI),
		.spi0_MISO(SPI0_MISO),
		.spi0_SCLK(SPI0_SCLK),
		
		//USB GPIO
		.usb_rst_export(USB_RST),
		.usb_irq_export(USB_IRQ),
		.usb_gpx_export(USB_GPX),
		
		//LEDs and HEX
		.hex_digits_export({hex_num_4, hex_num_3, hex_num_1, hex_num_0}),
		.leds_export({hundreds, signs, LEDR}),
		.keycode_export(keycode)
		
	 );


//instantiate a vga_controller, ball, and color_mapper here with the ports.

vga_controller abhee(.Clk(MAX10_CLK1_50), .Reset(Reset_h), .hs(VGA_HS), .vs(VGA_VS), .pixel_clk(VGA_Clk), 
.blank(blank), .sync(sync), .DrawX(drawxsig), .DrawY(drawysig));

///changing reset to Reset_h
ball azim(.Reset(int_reset||Reset_h), .frame_clk(VGA_VS), .keycode(keycode),
.BallX(ballxsig), .BallY(ballysig), .BallS(ballsizesig), .Ball_X_Center(100), 
.Ball_Y_Center(400), .ball_floor(floor), .pause(pausesig), .portal_status(portal), 
.up_down_status(up_down)
);


logic[9:0] floor;

 
logic[7:0] jumpmotionsig;
spike akshat(.Reset(int_reset||Reset_h), .frame_clk(VGA_VS), .keycode(keycode), .spikeX(spikexsig), .spikeY(spikeysig), .spikeS(spikesizesig), .spike_X_Center(350), .spike_Y_Center(400), .pause(pausesig), .gameplay(gameplaysig));

fin shivam(.Reset(int_reset||Reset_h), .frame_clk(VGA_VS), .keycode(keycode), .finX(finxsig), .finY(finysig), .finS(finsizesig), .fin_X_Center(350), .fin_Y_Center(400), .pause(pausesig), .gameplay(gameplaysig));

bg Arjun(.Reset(int_reset||Reset_h), .frame_clk(VGA_VS), .keycode(keycode), .bg_X_Center(250), .bg_Y_Center(250),  .bgX(bgxsig), .bgY(bgysig), .bgS(bgsize), .pause(pausesig), .gameplay(gameplaysig));

bg2 Pedro(.Reset(int_reset||Reset_h), .frame_clk(VGA_VS), .keycode(keycode), .bg2_X_Center(250), .bg2_Y_Center(250),  .bg2X(bg2xsig), .bg2Y(bg2ysig), .bg2S(bg2size), .pause(pausesig), .gameplay(gameplaysig));

bg3 Advaith(.Reset(int_reset||Reset_h), .frame_clk(VGA_VS), .keycode(keycode), .bg3_X_Center(250), .bg3_Y_Center(250),  .bg3X(bg3xsig), .bg3Y(bg3ysig), .bg3S(bg3size), .pause(pausesig), .gameplay(gameplaysig));

platform ali(.Reset(int_reset||Reset_h), .frame_clk(VGA_VS), .keycode(keycode), .pfX(pfxsig), .pfY(pfysig), .pfS(pfsizesig), .pf_X_Center(350), .pf_Y_Center(400), .pause(pausesig), .gameplay(gameplaysig));

portal aleena(.Reset(int_reset||Reset_h), .frame_clk(VGA_VS), .keycode(keycode), .portalX(portalxsig), .portalY(portalysig), .portalS(portalsizesig), .portal_X_Center(350), .portal_Y_Center(400), .pause(pausesig), .gameplay(gameplaysig));

color_mapper jason(.spriteX(ballxsig), .spriteY(ballysig), .DrawX(drawxsig),
 .DrawY(drawysig), .sprite_size(ballsizesig), 
 .spikeX(spikexsig), .spikeY(spikeysig), .spike_size(spikesizesig),
 .finX(finxsig), .finY(finysig), .fin_size(finsizesig),
 .bgX(bgxsig), .bgY(bgysig), .bg_size(bgsize),
 .bg2X(bg2xsig), .bg2Y(bg2ysig), .bg2_size(bg2size),
 .bg3X(bg3xsig), .bg3Y(bg3ysig), .bg3_size(bg3size), 
 .pfX(pfxsig), .pfY(pfysig), .pf_size(pfsizesig), 
 .portalX(portalxsig), .portalY(portalysig), .portal_size(portalsizesig),
 .Red(Red), .Green(Green), .Blue(Blue), .vga_clk(VGA_Clk), .blank(blank), 
 .hit(hit), .finish(finish), .cur_floor(floor), .portal(portal), .up_down(up_down),
 .keycode(keycode), .screen(screensig), .deaths(count), .inc_deaths(inc_deaths)
 );
	
logic hit; 
logic finish;
logic int_reset; 
logic showtitle;
logic portal;
logic up_down;


 ISDU Adnan(.Clk(VGA_VS), .hit(hit), .finish(finish), 
 .internal_reset(int_reset), .keycode(keycode), .screen(screensig), 
 .pause(pausesig), .gameplay(gameplaysig), .show_title(showtitle), .inc_deaths(inc_deaths)
 );
 
 
logic screensig;
logic pausesig; 
logic gameplaysig; 
logic inc_deaths;  

endmodule
