	component unsaved is
		port (
			clk_clk                         : in    std_logic                     := 'X';             -- clk
			reset_reset_n                   : in    std_logic                     := 'X';             -- reset_n
			led_wire_export                 : out   std_logic_vector(7 downto 0);                     -- export
			sdram_wire_addr                 : out   std_logic_vector(12 downto 0);                    -- addr
			sdram_wire_ba                   : out   std_logic_vector(1 downto 0);                     -- ba
			sdram_wire_cas_n                : out   std_logic;                                        -- cas_n
			sdram_wire_cke                  : out   std_logic;                                        -- cke
			sdram_wire_cs_n                 : out   std_logic;                                        -- cs_n
			sdram_wire_dq                   : inout std_logic_vector(15 downto 0) := (others => 'X'); -- dq
			sdram_wire_dqm                  : out   std_logic_vector(1 downto 0);                     -- dqm
			sdram_wire_ras_n                : out   std_logic;                                        -- ras_n
			sdram_wire_we_n                 : out   std_logic;                                        -- we_n
			sdram_pll_locked_conduit_export : out   std_logic;                                        -- export
			sdram_clk_clk                   : out   std_logic                                         -- clk
		);
	end component unsaved;

	u0 : component unsaved
		port map (
			clk_clk                         => CONNECTED_TO_clk_clk,                         --                      clk.clk
			reset_reset_n                   => CONNECTED_TO_reset_reset_n,                   --                    reset.reset_n
			led_wire_export                 => CONNECTED_TO_led_wire_export,                 --                 led_wire.export
			sdram_wire_addr                 => CONNECTED_TO_sdram_wire_addr,                 --               sdram_wire.addr
			sdram_wire_ba                   => CONNECTED_TO_sdram_wire_ba,                   --                         .ba
			sdram_wire_cas_n                => CONNECTED_TO_sdram_wire_cas_n,                --                         .cas_n
			sdram_wire_cke                  => CONNECTED_TO_sdram_wire_cke,                  --                         .cke
			sdram_wire_cs_n                 => CONNECTED_TO_sdram_wire_cs_n,                 --                         .cs_n
			sdram_wire_dq                   => CONNECTED_TO_sdram_wire_dq,                   --                         .dq
			sdram_wire_dqm                  => CONNECTED_TO_sdram_wire_dqm,                  --                         .dqm
			sdram_wire_ras_n                => CONNECTED_TO_sdram_wire_ras_n,                --                         .ras_n
			sdram_wire_we_n                 => CONNECTED_TO_sdram_wire_we_n,                 --                         .we_n
			sdram_pll_locked_conduit_export => CONNECTED_TO_sdram_pll_locked_conduit_export, -- sdram_pll_locked_conduit.export
			sdram_clk_clk                   => CONNECTED_TO_sdram_clk_clk                    --                sdram_clk.clk
		);

