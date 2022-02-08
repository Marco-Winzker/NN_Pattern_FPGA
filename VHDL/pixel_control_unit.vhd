-- pixel_control_unit.vhd
--
-- delays one pixel as a std_logic_vector(7 downto 0) for n clk cycles  
--
-- FPGA Vision Remote Lab http://h-brs.de/fpga-vision-lab
-- (c) Steffen Reckels, Hochschule Bonn-Rhein-Sieg, 2021
--     Release: Marco Winzker, Hochschule Bonn-Rhein-Sieg, 4.02.2022

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;
--
entity pixel_control_unit is
  generic ( delay : integer := 7 );
  port ( clk          : in  std_logic;
         input_pixel  : in  std_logic_vector(7 downto 0);
         output_pixel : out std_logic_vector(7 downto 0));
end pixel_control_unit;
--
architecture behave of pixel_control_unit is
--
  type delay_array is array (1 to delay) of std_logic_vector(7 downto 0);
  signal pixel_delay : delay_array;
--
begin
--
    process
        begin
        wait until rising_edge(clk);
            -- first value of array is current input
            pixel_delay(1) <= input_pixel;
            -- delay according to generic
            for i in 2 to delay loop
                pixel_delay(i) <= pixel_delay(i-1);
            end loop;
    end process; 
    -- last value of array is output
    output_pixel <= pixel_delay(delay);
--
end behave;