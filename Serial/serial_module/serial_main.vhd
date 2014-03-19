----------------------------------------------------------------------------------
-- Company: Polytech Lille	
-- Engineer: Benjamin Lafit
-- 
-- Create Date:    11:15:41 03/13/2014 
-- Design Name: 
-- Module Name:    serial_module - Behavioral 
-- Project Name: 
-- Target Devices: 
-- Tool versions: 
-- Description: Module to manage the serial communication
--
-- Dependencies: serial_rx and serial_tx
--
-- Revision: 
-- Revision 0.01 - File Created
-- Additional Comments: 
--
----------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity serial_main is
generic(
	--generic
		Param_clk_fq_main	: integer := 50000000;
		Param_nb_bit_data_main : integer :=8;
		Param_baud_rate_main	: integer := 115200 
);
Port(
-- inputs
	iClk : in STD_LOGIC;
	iDataToTransmit : in STD_LOGIC_VECTOR ((Param_nb_bit_data_main - 1) downto 0);
	iRx : in STD_LOGIC;
	iEnableTransmit : in STD_LOGIC;
	
-- outputs
	--oDataReady : out STD_LOGIC;
	--oTransmitComplete : out STD_LOGIC := '0';
	oTx : out STD_LOGIC;
	oData : out STD_LOGIC_VECTOR((Param_nb_bit_data_main-1) downto 0):="00000000"
);
end serial_main;

architecture Behavioral of serial_main is
----------------------------------------------------------------------------------
-- Component
----------------------------------------------------------------------------------

-- RX component

component serial_rx is
generic(
	--generic
		Param_clk_fq	: integer := Param_clk_fq_main;
		Param_nb_bit_data : integer := Param_nb_bit_data_main;
		Param_baud_rate	: integer := Param_baud_rate_main
	);	
Port ( iClk : in STD_LOGIC;
		iRx : in STD_LOGIC;
		--oDataReady : out STD_LOGIC;
		oData : out STD_LOGIC_VECTOR((Param_nb_bit_data-1) downto 0):="00000000"
);
end component;

-- Tx component

component serial_tx is 
generic(
	--generic
		Param_clk_fq	: integer := Param_clk_fq_main;
		Param_nb_bit_data : integer := Param_nb_bit_data_main;
		Param_baud_rate	: integer := Param_baud_rate_main
	);	
Port (iClk : in STD_LOGIC;
		iEnableTransmit : in STD_LOGIC;
		iDataToTransmit : in  STD_LOGIC_VECTOR ((Param_nb_bit_data - 1) downto 0);
		--oLEDS : out STD_LOGIC_VECTOR (7 downto 0);
		--oTransmitComplete : out STD_LOGIC := '0';
		oTx : out  STD_LOGIC :='1'
      );
end component;

begin

rx : serial_rx port map	(iClk,iRx,oData);
tx : serial_tx port map (iClk,iEnableTransmit,iDataToTransmit,oTx);	

--oData <= X"55";

end Behavioral;

