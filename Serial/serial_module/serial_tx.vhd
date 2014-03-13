----------------------------------------------------------------------------------
-- Company: Polytech Lille	
-- Engineer: Benjamin Lafit
-- 
-- Create Date:    23:38:03 03/10/2014 
-- Design Name: 
-- Module Name:    serial_tx - Behavioral 
-- Project Name: 
-- Target Devices: 
-- Tool versions: 
-- Description: VHDL module which allow to transmit data by serial communication 
--
-- Dependencies: 
--
-- Revision: 
-- Revision 0.01 - File Created
-- Additional Comments: 
--
----------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity serial_tx is
generic(
	--generic
		Param_clk_fq	: integer := 50000000;
		Param_nb_bit_data : integer :=8;
		Param_baud_rate	: integer := 9600
	);	
Port (iClk : in STD_LOGIC;
		iEnableTransmit : in STD_LOGIC;
		iDataToTransmit : in  STD_LOGIC_VECTOR ((Param_nb_bit_data - 1) downto 0);
		--oLEDS : out STD_LOGIC_VECTOR (7 downto 0);
		--oTransmitComplete : out STD_LOGIC := '0';
		oTx : out  STD_LOGIC :='1'
      );
end serial_tx;

architecture Behavioral of serial_tx is
--Constantes
constant Cst_DivF : integer := (Param_clk_fq/Param_baud_rate);

-- Signaux 
signal i: integer:=0;
signal cpt: integer:= 0 ; -- compteur interne
signal DataToTransmit : STD_LOGIC_VECTOR (Param_nb_bit_data downto 0);
signal Enable : STD_LOGIC := '0';
signal EnableTransmitPrec : STD_LOGIC :='0';

begin

DataToTransmit<=iDataToTransmit & '0' ; --concatenation avec bit de start
--oLEDS<= DataToTransmit(8 downto 1); --affichage sur leds de la data a transmettre

process (iClk)
	begin
	if iClk'event and iClk='1' then --front montant
		EnableTransmitPrec<=iEnableTransmit;
		if Enable='0' and iEnableTransmit='1' and EnableTransmitPrec='0' then --transmission
			Enable<='1';
			--oTransmitComplete<='0';
		end if;
	
		if Enable='1' then
			cpt<=cpt+1;
			if cpt=Cst_DivF and i<(Param_nb_bit_data+2) then 
				oTx<=DataToTransmit(i);
				i<=i+1;
				cpt<=0;
			end if;
			if i=(Param_nb_bit_data+2) then --fin transmission 
				i<=0;
				cpt<=0;
				Enable<='0';
				oTx<='1';
				--oTransmitComplete <='1';
			end if;
		else 
			oTx<='1';
			--oTransmitComplete <='0';
		end if;
	end if;
	end process;

end Behavioral;
