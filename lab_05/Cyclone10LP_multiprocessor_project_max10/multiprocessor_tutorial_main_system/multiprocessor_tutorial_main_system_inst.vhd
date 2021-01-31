	component multiprocessor_tutorial_main_system is
		port (
			clk_clk_in_reset_reset_n : in std_logic := 'X'; -- reset_n
			clk_in_clk               : in std_logic := 'X'  -- clk
		);
	end component multiprocessor_tutorial_main_system;

	u0 : component multiprocessor_tutorial_main_system
		port map (
			clk_clk_in_reset_reset_n => CONNECTED_TO_clk_clk_in_reset_reset_n, -- clk_clk_in_reset.reset_n
			clk_in_clk               => CONNECTED_TO_clk_in_clk                --           clk_in.clk
		);

