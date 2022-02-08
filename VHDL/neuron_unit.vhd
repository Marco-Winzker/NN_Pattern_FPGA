-- neuron_unit.vhd
--
-- generates neural network with the signal based neurons
--
-- FPGA Vision Remote Lab http://h-brs.de/fpga-vision-lab
-- (c) Steffen Reckels, Hochschule Bonn-Rhein-Sieg, 2021
--     Release: Marco Winzker, Hochschule Bonn-Rhein-Sieg, 4.02.2022

library IEEE;
use IEEE.STD_LOGIC_1164.all;
use IEEE.NUMERIC_STD.all;
use work.CONFIG.ALL;
--
entity neuron_unit is
  port (
	--in  
  		clk      	: in std_logic;
        reset    	: in std_logic;
        de_in    	: in std_logic;
        --
        line_0 : in std_logic_vector(55 downto 0);
        line_1 : in std_logic_vector(55 downto 0);
        line_2 : in std_logic_vector(55 downto 0);
        line_3 : in std_logic_vector(55 downto 0);
        line_4 : in std_logic_vector(55 downto 0);
        line_5 : in std_logic_vector(55 downto 0);
        line_6 : in std_logic_vector(55 downto 0);
	--out
		symbol_0 	: out integer range 0 to 255;
		symbol_1 	: out integer range 0 to 255;
		symbol_2 	: out integer range 0 to 255;
		symbol_3 	: out integer range 0 to 255
		);
end neuron_unit;
--
architecture behave of neuron_unit is
--
begin     
--
	--generates the neural network with the parameters from config.vhd
	--the outer loop creates the layers and the inner loop creates the neurons within the layers
	--use "neuron" (works with variables) for small input numbers and "neuronInputN" (works with signals) for large input numbers
--
	gen0 : FOR i IN 1 TO networkStructure'length - 1 GENERATE --layers
--
		gen1 : FOR j IN 0 TO networkStructure(i) - 1 GENERATE --neurons within the layers
--
			if0: IF (i = 1) GENERATE
				--"neuronInput49" is exlusive for neurons with 49 inputs in favor of timing 
				knot : entity work.neuron_input49
							generic map ( 
								weightsIn => weights(positions(j+1,i)-1 downto positions(j,i))
								)
							port map (  
								clk      => clk,
								inputsIn => (connection(connnectionRange(i)-1 downto connnectionRange(i-1))),
								output   => connection(connnectionRange(i)+j)
								);			
			END GENERATE if0;
--			
			if1: IF (i > 1) GENERATE
				--"neuronInput37" is exlusive for neurons with 37 inputs in favor of timing 
				--"neuronInput18" is exlusive for neurons with 18 inputs in favor of timing 
				knot : entity work.neuron_input37
				--knot : entity work.neuronInput18
							generic map ( 
								weightsIn => weights(positions(j+1,i)-1 downto positions(j,i))
								)
							port map (  
								clk      => clk,
								inputsIn => (connection(connnectionRange(i)-1 downto connnectionRange(i-1))),
								output   => connection(connnectionRange(i)+j)
								);
			END GENERATE if1; 
--			
		END GENERATE;
	END GENERATE;
--
--reading data from memory into the network 
	process
		begin
		wait until rising_edge(clk);
			--assign values of the input layer
		--0 line
			connection( 0) <= to_integer(unsigned(line_0(55 downto 48))); 			
			connection( 1) <= to_integer(unsigned(line_0(47 downto 40))); 
			connection( 2) <= to_integer(unsigned(line_0(39 downto 32))); 
			connection( 3) <= to_integer(unsigned(line_0(31 downto 24))); 
			connection( 4) <= to_integer(unsigned(line_0(23 downto 16))); 
			connection( 5) <= to_integer(unsigned(line_0(15 downto  8))); 
			connection( 6) <= to_integer(unsigned(line_0( 7 downto  0))); 
		--1 line
			connection( 7) <= to_integer(unsigned(line_1(55 downto 48))); 
			connection( 8) <= to_integer(unsigned(line_1(47 downto 40))); 
			connection( 9) <= to_integer(unsigned(line_1(39 downto 32))); 
			connection(10) <= to_integer(unsigned(line_1(31 downto 24))); 
			connection(11) <= to_integer(unsigned(line_1(23 downto 16))); 
			connection(12) <= to_integer(unsigned(line_1(15 downto  8))); 
			connection(13) <= to_integer(unsigned(line_1( 7 downto  0))); 
		--2 line
			connection(14) <= to_integer(unsigned(line_2(55 downto 48))); 
			connection(15) <= to_integer(unsigned(line_2(47 downto 40))); 
			connection(16) <= to_integer(unsigned(line_2(39 downto 32))); 
			connection(17) <= to_integer(unsigned(line_2(31 downto 24))); 
			connection(18) <= to_integer(unsigned(line_2(23 downto 16))); 
			connection(19) <= to_integer(unsigned(line_2(15 downto  8))); 
			connection(20) <= to_integer(unsigned(line_2( 7 downto  0))); 
		--3 line
			connection(21) <= to_integer(unsigned(line_3(55 downto 48))); 
			connection(22) <= to_integer(unsigned(line_3(47 downto 40))); 
			connection(23) <= to_integer(unsigned(line_3(39 downto 32))); 
			connection(24) <= to_integer(unsigned(line_3(31 downto 24))); 
			connection(25) <= to_integer(unsigned(line_3(23 downto 16))); 
			connection(26) <= to_integer(unsigned(line_3(15 downto  8))); 
			connection(27) <= to_integer(unsigned(line_3( 7 downto  0))); 
		--4 line
			connection(28) <= to_integer(unsigned(line_4(55 downto 48))); 
			connection(29) <= to_integer(unsigned(line_4(47 downto 40))); 
			connection(30) <= to_integer(unsigned(line_4(39 downto 32))); 
			connection(31) <= to_integer(unsigned(line_4(31 downto 24))); 
			connection(32) <= to_integer(unsigned(line_4(23 downto 16))); 
			connection(33) <= to_integer(unsigned(line_4(15 downto  8)));
			connection(34) <= to_integer(unsigned(line_4( 7 downto  0))); 
		--5 line
			connection(35) <= to_integer(unsigned(line_5(55 downto 48))); 
			connection(36) <= to_integer(unsigned(line_5(47 downto 40))); 
			connection(37) <= to_integer(unsigned(line_5(39 downto 32))); 
			connection(38) <= to_integer(unsigned(line_5(31 downto 24))); 
			connection(39) <= to_integer(unsigned(line_5(23 downto 16))); 
			connection(40) <= to_integer(unsigned(line_5(15 downto  8))); 
			connection(41) <= to_integer(unsigned(line_5( 7 downto  0))); 
		--6 line
			connection(42) <= to_integer(unsigned(line_6(55 downto 48))); 
			connection(43) <= to_integer(unsigned(line_6(47 downto 40))); 
			connection(44) <= to_integer(unsigned(line_6(39 downto 32))); 
			connection(45) <= to_integer(unsigned(line_6(31 downto 24))); 
			connection(46) <= to_integer(unsigned(line_6(23 downto 16))); 
			connection(47) <= to_integer(unsigned(line_6(15 downto  8))); 
			connection(48) <= to_integer(unsigned(line_6( 7 downto  0))); 
--	
		--connection(48+37+1) = connection (86)++
			symbol_0 <= connection(86);
			symbol_1 <= connection(87);
			symbol_2 <= connection(88);
			symbol_3 <= connection(89);
		--connection(48+27+1) = connection (76)++
		--	symbol_0 <= connection(76);
		--	symbol_1 <= connection(77);
		--	symbol_2 <= connection(78);
		--	symbol_3 <= connection(79);
		--connection(48+18+1) = connection (67)++
		--	symbol_0 <= connection(67);
		--	symbol_1 <= connection(68);
		--	symbol_2 <= connection(69);
		--	symbol_3 <= connection(70);
		--connection(48+9+1) = connection (58)++
		--  symbol_0 <= connection(58);
		--  symbol_1 <= connection(59);
		--  symbol_2 <= connection(60);
		--  symbol_3 <= connection(61);	
--
	end process;
--
end behave;
