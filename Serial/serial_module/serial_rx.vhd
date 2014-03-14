----------------------------------------------------------------------------------
-- Company: Polytech Lille
-- Engineer: Benjamin Lafit
-- 
-- Create Date:    14:52:12 03/10/2014 
-- Design Name: 
-- Module Name:    serial_rx - Behavioral 
-- Project Name: 
-- Target Devices: 
-- Tool versions: 
-- Description: VHDL module which allow to receipt data by serial communication
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
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

entity serial_rx is
generic(
	--generic
		Param_clk_fq	: integer := 50000000;
		Param_nb_bit_data : integer :=8;
		Param_baud_rate	: integer := 9600 
	);	
Port ( iClk : in STD_LOGIC;
iRx : in STD_LOGIC;
--oDataReady : out STD_LOGIC;
oData : out STD_LOGIC_VECTOR((Param_nb_bit_data-1) downto 0):="00000000"
);
end serial_rx;

architecture Behavioral of serial_rx is

--Constante
constant Cst_DivF : integer := (Param_clk_fq/Param_baud_rate);
constant Cst_fq_init : integer := Cst_DivF/2;

-- Signaux
signal Data_next : STD_LOGIC_VECTOR (Param_nb_bit_data downto 0); -- mémoire data
signal cpt: integer:= 0 ; -- compteur interne
signal start: STD_LOGIC:='0';
signal enable: STD_LOGIC:='0';
signal i: integer:=0;

begin

--Process Clk
process(iClk,iRx)
begin
	if iRx='0' then
		if start='0' then
			start<='1';
		end if;
	end if;
	if enable='1' then
		-- le bit enable est à vrai le temps de la réception des données
		start<='0';
	end if;
	
	if iClk'event and iClk='1' then --front montant
		if i<10 then 
			--oDataReady<='0';
		end if;
		
		if start='1' or enable='1'then
			cpt<=cpt+1;
			enable<='1';
			if cpt=0 then --initialisation du compteur au premier passage pour prendre la valeur des bits au "milieu"
				if i=0 then
					cpt<=Cst_fq_init;
				end if;
			end if;
		end if;
		if cpt=Cst_DivF and i<(Param_nb_bit_data + 2) then 
			Data_next<=Data_next((Param_nb_bit_data - 1) downto 0) & iRx; --le remplir à l'envers
			i<=i+1;
			cpt<=0;
		end if;
		if i=(Param_nb_bit_data + 2) then -- recuperation de tous les bits
			oData(0)<=Data_next(8); --changer pour avoir un truc parametrable (après avoir fait changement sur Data_next)
			oData(1)<=Data_next(7);
			oData(2)<=Data_next(6);
			oData(3)<=Data_next(5);
			oData(4)<=Data_next(4);
			oData(5)<=Data_next(3);
			oData(6)<=Data_next(2);
			oData(7)<=Data_next(1);
			i<=0;
			cpt<=0;
			enable<='0';
			--oDataReady='1';
			end if;
	end if;
end process;

end Behavioral;

