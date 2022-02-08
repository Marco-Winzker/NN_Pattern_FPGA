-- manipulation_unit.vhd
--
-- sets color or original pixel for output pixel depending on the result of the neural network 
--
-- FPGA Vision Remote Lab http://h-brs.de/fpga-vision-lab
-- (c) Steffen Reckels, Hochschule Bonn-Rhein-Sieg, 2021
--     Release: Marco Winzker, Hochschule Bonn-Rhein-Sieg, 4.02.2022

library IEEE;
use IEEE.STD_LOGIC_1164.all;
use IEEE.NUMERIC_STD.all;
use work.CONFIG.ALL;
--
entity manipulation_unit is
  port (
		--in  
  		clk      	: in std_logic;
		data_in  	: in std_logic_vector(7 downto 0);
		symbol_0 	: in integer range 0 to 255; --circle filed 
		symbol_1 	: in integer range 0 to 255; --circle open 
		symbol_2 	: in integer range 0 to 255; --X
		symbol_3 	: in integer range 0 to 255; --cross
		--out
		r_out 		: out std_logic_vector(7 downto 0);
		g_out 		: out std_logic_vector(7 downto 0);
		b_out 		: out std_logic_vector(7 downto 0)
		);
end manipulation_unit;
--
architecture behave of manipulation_unit is
--
	--threshold for all the symbols 
	constant threshold : integer := 127;
--
begin
--
	--check if the value for a symbol is greater than the threshold 
	process
		begin
		wait until rising_edge(clk);
			--circle filled 
			if (symbol_0 > threshold) then
				-- dark yellow
				r_out 	<=	"11111111";
				g_out 	<=  "11111111";
				b_out 	<=  "01000000";
			--circle open 
			elsif (symbol_1 > threshold) then
				-- green
				r_out 	<=	 "00000000";
				g_out 	<=	 "11111111";
				b_out 	<=	 "00000000";
			--X	
			elsif (symbol_2 > threshold) then
				-- blue
				r_out 	<=	 "00000000";
				g_out 	<=	 "00000000";
				b_out 	<=	 "11111111";
			--cross
			elsif (symbol_3 > threshold) then
				-- red 
				r_out	<=	 "11111111";
				g_out 	<=	 "00000000";
				b_out 	<=	 "00000000";
			--no symbol 
			else
				-- light input value
				r_out 	<= "11" & data_in(7 downto 2);
				g_out 	<= "11" & data_in(7 downto 2);
				b_out 	<= "11" & data_in(7 downto 2);
			end if;
--
	end process;
--
end behave;