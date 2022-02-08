-- npu.vhd
--
-- NPU: Neural Processing Unit 
--
-- encapsulates
--              |-> neuron_unit ------->|
-- memoryUnit ->|                       |-> manipulation_unit
--              |-> pixel_control_unit->|
--
-- FPGA Vision Remote Lab http://h-brs.de/fpga-vision-lab
-- (c) Steffen Reckels, Hochschule Bonn-Rhein-Sieg, 2021
--     Release: Marco Winzker, Hochschule Bonn-Rhein-Sieg, 4.02.2022

library IEEE;
use IEEE.STD_LOGIC_1164.all;
use IEEE.NUMERIC_STD.all;
use work.CONFIG.ALL;
--
entity npu is
  port (
	--in  
  		clk     : in std_logic;
        reset   : in std_logic;
        de_in   : in std_logic;
		data_in : in std_logic_vector(7 downto 0);
	--out
		r_out 	: out std_logic_vector(7 downto 0);
        g_out 	: out std_logic_vector(7 downto 0);
        b_out 	: out std_logic_vector(7 downto 0)
		);
end npu;
--
architecture behave of npu is
--
    signal line_0, line_1, line_2, line_3, line_4, line_5, line_6 : std_logic_vector(55 downto 0);
--
    signal symbol0, symbol1, symbol2, symbol3 : integer range 0 to 255;
--
    signal pixel_0, pixel_1 : std_logic_vector(7 downto 0);
--
begin 
-- 
--shift register
mem : entity work.memory_unit
port map (
    --in  
        clk      	=> clk,
        reset    	=> reset,
        de_in    	=> de_in,
		data_in  	=> data_in,
	--out
		data_out 	=> pixel_0,
        --
        line_0      => line_0 ,
        line_1      => line_1 ,
        line_2      => line_2 ,
        line_3      => line_3 ,
        line_4      => line_4 ,
        line_5      => line_5 ,
        line_6      => line_6
    ); 
--
--neural network 
neu : entity work.neuron_unit
port map (
    --in  
        clk   => clk,
        reset => reset,
        de_in => de_in,
        --
        line_0 => line_0,
        line_1 => line_1,
        line_2 => line_2,
        line_3 => line_3,
        line_4 => line_4,
        line_5 => line_5,
        line_6 => line_6,
	--out
		symbol_0 => symbol0,
		symbol_1 => symbol1,
		symbol_2 => symbol2,
		symbol_3 => symbol3
        );
--
--delay pixel to fit with the symbol
cp: entity work.pixel_control_unit
generic map (delay => 16) 
port map (
    --in
        clk      	 => clk,
        input_pixel  => pixel_0,
    --out
        output_pixel => pixel_1
        ); 
--
--image processing 
man: entity work.manipulation_unit 
port map (
    --in 
        clk      	=> clk,
        data_in  	=> pixel_1,
        --
        symbol_0 	=> symbol0,
        symbol_1 	=> symbol1,
        symbol_2 	=> symbol2,
        symbol_3 	=> symbol3,
    --out
        r_out 		=> r_out,
        g_out 		=> g_out,
        b_out 		=> b_out
        );
--
end behave;
