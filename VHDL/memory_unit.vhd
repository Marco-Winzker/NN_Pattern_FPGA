-- memoryUnit.vhd
--
-- saves 6 lines in shift registers 
-- gives a 7x7 pixel array as an output arranged in 7 1x7 arrays and the pixel in the middle of the 7x7 array separately
--
-- FPGA Vision Remote Lab http://h-brs.de/fpga-vision-lab
-- (c) Steffen Reckels, Hochschule Bonn-Rhein-Sieg, 2021
--     Release: Marco Winzker, Hochschule Bonn-Rhein-Sieg, 4.02.2022

library IEEE;
use IEEE.STD_LOGIC_1164.all;
use IEEE.NUMERIC_STD.all;
use work.CONFIG.ALL;
--
entity memory_unit is
  port (
	--in  
  		clk      	: in std_logic;
        reset    	: in std_logic;
        de_in    	: in std_logic;
		data_in  	: in std_logic_vector(7 downto 0);
	--out
		data_out 	: out std_logic_vector(7 downto 0);
        --
        line_0 : out std_logic_vector(55 downto 0);
        line_1 : out std_logic_vector(55 downto 0);
        line_2 : out std_logic_vector(55 downto 0);
        line_3 : out std_logic_vector(55 downto 0);
        line_4 : out std_logic_vector(55 downto 0);
        line_5 : out std_logic_vector(55 downto 0);
        line_6 : out std_logic_vector(55 downto 0)
		);
end memory_unit;
--
architecture behave of memory_unit is
--
--tap_ij for 7x7 pixels -> 0 to 6
--tap_33 is the one  to be manipulated	
signal 	tap_00, tap_01, tap_02, tap_03, tap_04, tap_05, tap_06,
		tap_10, tap_11, tap_12, tap_13, tap_14, tap_15, tap_16,
		tap_20, tap_21, tap_22, tap_23, tap_24, tap_25, tap_26,
		------------------------#######-----------------------
		tap_30, tap_31, tap_32, tap_33, tap_34, tap_35, tap_36,
		------------------------#######-----------------------
		tap_40, tap_41, tap_42, tap_43, tap_44, tap_45, tap_46,
		tap_50, tap_51, tap_52, tap_53, tap_54, tap_55, tap_56,
		tap_60, tap_61, tap_62, tap_63, tap_64, tap_65, tap_66	: std_logic_vector(7 downto 0);
--
begin 
--
--current input pixel is right-bottom (tap_66)
	tap_66 <= data_in;
--
--6 line memories -> 0 to 5
--0 line   
	mem_0 : entity work.linemem
		port map (
			clk      => clk,
			reset    => reset,
			write_en => de_in,
			data_in  => tap_66,
			data_out => tap_56);
--1 line			  
	mem_1 : entity work.linemem
		port map (
			clk      => clk,
			reset    => reset,
			write_en => de_in,
			data_in  => tap_56,
			data_out => tap_46);
--2 line			  
	mem_2 : entity work.linemem
		port map (
			clk      => clk,
			reset    => reset,
			write_en => de_in,
			data_in  => tap_46,
			data_out => tap_36);
--3 line			  
	mem_3 : entity work.linemem
		port map (
			clk      => clk,
			reset    => reset,
			write_en => de_in,
			data_in  => tap_36,
			data_out => tap_26);
--4 line			  
	mem_4 : entity work.linemem
		port map (
			clk      => clk,
			reset    => reset,
			write_en => de_in,
			data_in  => tap_26,
			data_out => tap_16);
--5 line			  
	mem_5 : entity work.linemem
		port map (
			clk      => clk,
			reset    => reset,
			write_en => de_in,
			data_in  => tap_16,
			data_out => tap_06);
--
-- delay each line by six clock cycles:		  			  
	process
		begin
		wait until rising_edge(clk);
		--0 line 
			tap_05 <= tap_06;
			tap_04 <= tap_05;
			tap_03 <= tap_04;
			tap_02 <= tap_03;
			tap_01 <= tap_02;
			tap_00 <= tap_01;
		--1 line
			tap_15 <= tap_16;
			tap_14 <= tap_15;
			tap_13 <= tap_14;
			tap_12 <= tap_13;
			tap_11 <= tap_12;
			tap_10 <= tap_11;
		--2 line
			tap_25 <= tap_26;
			tap_24 <= tap_25;
			tap_23 <= tap_24;
			tap_22 <= tap_23;
			tap_21 <= tap_22;
			tap_20 <= tap_21;
		--3 line
			tap_35 <= tap_36;
			tap_34 <= tap_35;
			tap_33 <= tap_34;
			tap_32 <= tap_33;
			tap_31 <= tap_32;
			tap_30 <= tap_31;
		--4 line
			tap_45 <= tap_46;
			tap_44 <= tap_45;
			tap_43 <= tap_44;
			tap_42 <= tap_43;
			tap_41 <= tap_42;
			tap_40 <= tap_41;
		--5 line
			tap_55 <= tap_56;
			tap_54 <= tap_55;
			tap_53 <= tap_54;
			tap_52 <= tap_53;
			tap_51 <= tap_52;
			tap_50 <= tap_51;
		--6 line 
			tap_65 <= tap_66;
			tap_64 <= tap_65;
			tap_63 <= tap_64;
			tap_62 <= tap_63;
			tap_61 <= tap_62;
			tap_60 <= tap_61;
--
	end process;
--
	--write 7x7 pixel array on output 
    line_0 <= tap_00 & tap_01 & tap_02 & tap_03 & tap_04 & tap_05 & tap_06;
    line_1 <= tap_10 & tap_11 & tap_12 & tap_13 & tap_14 & tap_15 & tap_16;
    line_2 <= tap_20 & tap_21 & tap_22 & tap_23 & tap_24 & tap_25 & tap_26;
	-------------------------------------######----------------------------		
    line_3 <= tap_30 & tap_31 & tap_32 & tap_33 & tap_34 & tap_35 & tap_36;
	-------------------------------------######----------------------------
    line_4 <= tap_40 & tap_41 & tap_42 & tap_43 & tap_44 & tap_45 & tap_46;
    line_5 <= tap_50 & tap_51 & tap_52 & tap_53 & tap_54 & tap_55 & tap_56;
    line_6 <= tap_60 & tap_61 & tap_62 & tap_63 & tap_64 & tap_65 & tap_66;              
--
	--store original pixel in case of no manipulation 			
    data_out <= tap_33;            
--
end behave;