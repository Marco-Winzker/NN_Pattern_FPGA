-- nn_pattern.vhd
--
-- top-level-entity
--   neural network for pattern matching
--
-- FPGA Vision Remote Lab http://h-brs.de/fpga-vision-lab
-- (c) Steffen Reckels, Hochschule Bonn-Rhein-Sieg, 2021
--     Release: Marco Winzker, Hochschule Bonn-Rhein-Sieg, 4.02.2022

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity nn_pattern is
  port (clk       : in  std_logic;                      -- input clock 74.25 MHz, video 720p
        reset_n   : in  std_logic;                      -- reset (invoked during configuration)
        enable_in : in  std_logic_vector(2 downto 0);   -- three slide switches
        -- video in
        vs_in     : in  std_logic;                      -- vertical sync
        hs_in     : in  std_logic;                      -- horizontal sync
        de_in     : in  std_logic;                      -- data enable is '1' for valid pixel
        r_in      : in  std_logic_vector(7 downto 0);   -- red component of pixel
        g_in      : in  std_logic_vector(7 downto 0);   -- green component of pixel
        b_in      : in  std_logic_vector(7 downto 0);   -- blue component of pixel
        -- video out
        vs_out    : out std_logic;                      -- corresponding to video-in
        hs_out    : out std_logic;
        de_out    : out std_logic;
        r_out     : out std_logic_vector(7 downto 0);
        g_out     : out std_logic_vector(7 downto 0);
        b_out     : out std_logic_vector(7 downto 0);
        --
        clk_o     : out std_logic;                      -- output clock (do not modify)
        clk_n_o   : out std_logic;                      -- output clock inverted (do not modify)
        led       : out std_logic_vector(2 downto 0));  -- not supported by remote lab
end nn_pattern;
--
architecture behave of nn_pattern is
--
    -- input FFs
    signal reset             		: std_logic;
	  signal enable            		: std_logic_vector(2 downto 0);
    signal vs_0, hs_0, de_0			: std_logic;
    signal r_0, g_0, b_0     		: std_logic_vector(7 downto 0);
	-- convert to luminance
    signal lum     					: std_logic_vector(7 downto 0);
    -- output of signal processing
    signal vs_1, hs_1, de_1  		: std_logic;
    signal r_out_npu, g_out_npu, b_out_npu : std_logic_vector(7 downto 0);
--
begin
	
process
	variable result : integer range  0 to  255;
begin	
	wait until rising_edge(clk);   
	-- input FFs for control
    reset <= not reset_n;
	enable <= enable_in;
	 -- input FFs for video signal
    vs_0  <= vs_in;
    hs_0  <= hs_in;
    de_0  <= de_in;
    r_0   <= r_in; 
    g_0   <= g_in;
    b_0   <= b_in;
	
	
	-- convert RGB to luminance: Y = (5*R + 9*G + 2*B)/16
    result := (   5*to_integer(unsigned(r_0))
                + 9*to_integer(unsigned(g_0))
                + 2*to_integer(unsigned(b_0))) / 16;
	lum    <=  std_logic_vector(to_unsigned(result, 8));
	
end process;
--
npu_instance: entity work.npu
    port map (
      --in  
      clk      	=> clk,
      reset    	=> reset,
      de_in    	=> de_0,
      data_in  	=> lum,
      --out
      r_out 	  => r_out_npu,
      g_out 	  => g_out_npu,
      b_out 	  => b_out_npu
    );  

control_instance: entity work.control
    generic map (delay => 21) 
    port map (
        --in
        clk   	=> clk,
        reset   => reset,
        vs_in	  => vs_0,
        hs_in 	=> hs_0,
        de_in   => de_0,
        --out
        vs_out	=> vs_1,
        hs_out 	=> hs_1,
        de_out  => de_1
    );    
--  
process
begin
  wait until rising_edge(clk);
    -- output FFs 
    vs_out  <= vs_1;
    hs_out  <= hs_1;
    de_out  <= de_1;

    if (de_1 = '1') then
      r_out   <= r_out_npu;
      g_out   <= g_out_npu;
      b_out   <= b_out_npu;
    else
  		r_out   <= "00000000";
  		g_out   <= "00000000";
  		b_out   <= "00000000";
    end if;
--
end process;
--
clk_o   <= clk;
clk_n_o <= '0'; -- output not required, set to constant
led     <= "000";
--
end behave;
--
