-- neuron_input27.vhd
--
-- sigmoid neuron for 27 input neurons 
--
-- FPGA Vision Remote Lab http://h-brs.de/fpga-vision-lab
-- (c) Steffen Reckels, Hochschule Bonn-Rhein-Sieg, 2021
--     Release: Marco Winzker, Hochschule Bonn-Rhein-Sieg, 4.02.2022

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;
use work.CONFIG.ALL;
--
entity neuron_input27 is
    generic ( weightsIn : constIntArray);				
    port (  clk         : in std_logic;
            inputsIn    : in input;
            output      : out integer range 0 to 255
    );
end neuron_input27;
--
architecture behave of neuron_input27 is
	signal sumAdress : std_logic_vector(15 downto 0); -- adress for the lookup table
	signal afterActivation : std_logic_vector(7 downto 0); -- result of the lookup table
	signal sumForActivation : integer range minSumRange to maxSumRange:= 0; --sum after accumulation of the bias plus all inputs multiplied by their weights	
--    
    signal accumulate : multResults (weightsIn'length-2 downto 0) :=(others => 0); -- Array with the results from the multiplication of input with its weight
--
    signal sum, sum0, sum1, sum2, sum3, sum4 : integer range minSumRange to maxSumRange:= 0;
--
begin
--	
-- Generate a multiplier for each input to multiply it with its weight
-- Save the results in the array
-- This step is necessary because otherwise the mac operations would be to slow
gen : FOR I IN 0 TO weightsIn'length-2 GENERATE --Layers
    mult: entity work.multiplier 
        generic map (weight => weightsIn(I+weightsIn'right))
        port map (  clk     => clk,
                    input   => inputsIn(I+inputsIn'right),
                    output	=> accumulate(I));
END GENERATE;
--
process
begin
    wait until rising_edge(clk);
--
        sum0 <=  accumulate(0)
             +   accumulate(1)
             +   accumulate(2)
             +   accumulate(3)
             +   accumulate(4);
--
        sum1 <=  accumulate(5)
             +   accumulate(6)
             +   accumulate(7)
             +   accumulate(8)
             +   accumulate(9);
--
        sum2 <=  accumulate(10)
             +   accumulate(11)
             +   accumulate(12)
             +   accumulate(13)
             +   accumulate(14);
--
        sum3 <=  accumulate(15)
             +   accumulate(16)
             +   accumulate(17) 
             +   accumulate(18)
             +   accumulate(19);
--
        sum4 <=  accumulate(20)
             +   accumulate(21)
             +   accumulate(22)
             +   accumulate(23)  
             +   accumulate(24)
             +   accumulate(25)
             +   accumulate(26);
--
        sum <= sum0 + sum1 + sum2 + sum3 + sum4;             
--
        sumForActivation <= sum + weightsIn(weightsIn'left);    
--
end process;	
--
process
begin
	wait until rising_edge(clk);
	-- limiting result for sigmoid
    if (sumForActivation < -32768) then
      sumAdress <= (others => '0');
    elsif (sumForActivation > 32767) then
		sumAdress <= (others => '1');
	 else 
      sumAdress <= std_logic_vector(to_unsigned(sumForActivation + 32768, 16));
	end if;
end process;
--
--lookup table for the sigmoid function
sigmoid : entity work.sigmoid_IP 
	port map (  clock   => clk,
--
                --choose bitwidth for sigmoid             
                --address => sumAdress(15 downto 13), -- 3 Bit
                --address => sumAdress(15 downto 12), -- 4 Bit
                --address => sumAdress(15 downto 11), -- 5 Bit
                --address => sumAdress(15 downto 10), -- 6 Bit
                --address => sumAdress(15 downto  9), -- 7 Bit
                --address => sumAdress(15 downto  8), -- 8 Bit
                --address => sumAdress(15 downto  7), -- 9 Bit
                --address => sumAdress(15 downto  6), --10 Bit
                --address => sumAdress(15 downto  5), --11 Bit 
			    address => sumAdress(15 downto 4),
--
                q       => afterActivation);
--			  
-- set output of the neuron
output <= to_integer(unsigned(afterActivation));
--
end behave;