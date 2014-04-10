----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    14:54:38 03/19/2014 
-- Design Name: 
-- Module Name:    top_mapping_avt - Behavioral 
-- Project Name: 
-- Target Devices: 
-- Tool versions: 
-- Description: 
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

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx primitives in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity top_mapping_avt is
    Port ( 
--		--############################################################################	
--		--# User Reset Push Button
--		--#   Ignore the timing for this signal
--		--#   Internal pull-down required since external resistor is not populated
--		--############################################################################	
--			USER_RESET : in  STD_LOGIC;
		
--		--############################################################################	
--		--# Micron N25Q128 SPI Flash
--		--#   This is a Multi-I/O Flash.  Several pins have dual purposes
--		--#   depending on the mode.
--		--############################################################################	
--			SPI_SCK : in  STD_LOGIC;
--			SPI_CS_n : in  STD_LOGIC;
--			SPI_MOSI_MISO0 : in  STD_LOGIC;
--			SPI_MISO_MISO1 : in  STD_LOGIC;
--			SPI_Wn_MISO2 : in  STD_LOGIC;
--			SPI_HOLDn_MISO3 : in  STD_LOGIC;
		
--		--############################################################################	
--		--# Texas Instruments CDCE913 Triple-Output PLL Clock Chip
--		--#   Y1: 40 MHz, USER_CLOCK can be used as external configuration clock
--		--#   Y2: 66.667 MHz
--		--#   Y3: 100 MHz 
--		--############################################################################	
--			USER_CLOCK : in  STD_LOGIC;
--			CLOCK_Y2 : in  STD_LOGIC;
			CLOCK_Y3 : in  STD_LOGIC;
		
--		--############################################################################	
--		--# The following oscillator is not populated in production but the footprint
--		--# is compatible with the Maxim DS1088LU			
--		--############################################################################	
--			BACKUP_CLK : in  STD_LOGIC;
		
--		--############################################################################	
--		--# User DIP Switch x4
--		--#   Internal pull-down required since external resistor is not populated
--		--############################################################################	
--			GPIO_DIP1 : in  STD_LOGIC;
--			GPIO_DIP2 : in  STD_LOGIC;
--			GPIO_DIP3 : in  STD_LOGIC;
--			GPIO_DIP4 : in  STD_LOGIC;
	
		
		--############################################################################	
		--# User LEDs			
		--############################################################################	
			GPIO_LED1 : out  STD_LOGIC;
			GPIO_LED2 : out  STD_LOGIC;
			GPIO_LED3 : out  STD_LOGIC;
			GPIO_LED4 : out  STD_LOGIC;
		
--		--############################################################################	
--		--# Silicon Labs CP2102 USB-to-UART Bridge Chip
--		--############################################################################	
--			USB_RS232_RXD : in  STD_LOGIC;
--			USB_RS232_TXD : out  STD_LOGIC;
		
--		--############################################################################	
--		--# Texas Instruments CDCE913 programming port
--		--#   Internal pull-ups required since external resistors are not populated
--		--############################################################################	
--			SCL : in  STD_LOGIC;
--			SDA : in  STD_LOGIC;
		
--		--############################################################################	
--		--# Micron MT46H32M16LFBF-5 LPDDR			
--		--############################################################################	
--		--# Addresses
--			LPDDR_A0 : out  STD_LOGIC;
--			LPDDR_A1 : out  STD_LOGIC;
--			LPDDR_A2 : out  STD_LOGIC;
--			LPDDR_A3 : out  STD_LOGIC;
--			LPDDR_A4 : out  STD_LOGIC;
--			LPDDR_A5 : out  STD_LOGIC;
--			LPDDR_A6 : out  STD_LOGIC;
--			LPDDR_A7 : out  STD_LOGIC;
--			LPDDR_A8 : out  STD_LOGIC;
--			LPDDR_A9 : out  STD_LOGIC;
--			LPDDR_A10 : out  STD_LOGIC;
--			LPDDR_A11 : out  STD_LOGIC;
--			LPDDR_A12 : out  STD_LOGIC;
--			LPDDR_BA0 : out  STD_LOGIC;
--			LPDDR_BA1 : out  STD_LOGIC;
--		
--		--# Data                                                                  
--			LPDDR_DQ0 : inout  STD_LOGIC;
--			LPDDR_DQ1 : inout  STD_LOGIC;
--			LPDDR_DQ2 : inout  STD_LOGIC;
--			LPDDR_DQ3 : inout  STD_LOGIC;
--			LPDDR_DQ4 : inout  STD_LOGIC;
--			LPDDR_DQ5 : inout  STD_LOGIC;
--			LPDDR_DQ6 : inout  STD_LOGIC;
--			LPDDR_DQ7 : inout  STD_LOGIC;
--			LPDDR_DQ8 : inout  STD_LOGIC;
--			LPDDR_DQ9 : inout  STD_LOGIC;
--			LPDDR_DQ10 : inout  STD_LOGIC;
--			LPDDR_DQ11 : inout  STD_LOGIC;
--			LPDDR_DQ12 : inout  STD_LOGIC;
--			LPDDR_DQ13 : inout  STD_LOGIC;
--			LPDDR_DQ14 : inout  STD_LOGIC;
--			LPDDR_DQ15 : inout  STD_LOGIC;
--			LPDDR_LDM : inout  STD_LOGIC;
--			LPDDR_UDM : inout  STD_LOGIC;
--			LPDDR_LDQS : inout  STD_LOGIC;
--			LPDDR_UDQS : inout  STD_LOGIC;
--		
--		--# Clock
--			LPDDR_CK_N : in  STD_LOGIC;
--			LPDDR_CK_P : in  STD_LOGIC;
--			LPDDR_CKE : in  STD_LOGIC;
--
--		--# Control
--			LPDDR_CAS_n : inout  STD_LOGIC;
--			LPDDR_RAS_n : inout  STD_LOGIC;
--			LPDDR_WE_n : inout  STD_LOGIC;
--			LPDDR_RZQ : inout  STD_LOGIC;
		
--		--############################################################################	
--		--# National Semiconductor DP83848J 10/100 Ethernet PHY			
--		--#   Pull-ups on RXD are necessary to set the PHY AD to 11110b.
--		--#   Must keep the PHY from defaulting to PHY AD = 00000b      
--		--#   because this is Isolate Mode                              
--		--############################################################################	
--			ETH_COL : inout  STD_LOGIC;
--			ETH_CRS : inout  STD_LOGIC;
--			ETH_MDC : inout  STD_LOGIC;
--			ETH_MDIO : inout  STD_LOGIC;
--			ETH_RESET_n : inout  STD_LOGIC;
--			ETH_RX_CLK : inout  STD_LOGIC;
--			ETH_RX_D0 : in  STD_LOGIC;
--			ETH_RX_D1 : in  STD_LOGIC;
--			ETH_RX_D2 : in  STD_LOGIC;
--			ETH_RX_D3 : in  STD_LOGIC;
--			ETH_RX_DV : in  STD_LOGIC;
--			ETH_RX_ER : in  STD_LOGIC;
--			ETH_TX_CLK : inout  STD_LOGIC;
--			ETH_TX_D0 : out  STD_LOGIC;
--			ETH_TX_D1 : out  STD_LOGIC;
--			ETH_TX_D2 : out  STD_LOGIC;
--			ETH_TX_D3 : out  STD_LOGIC;
--			ETH_TX_EN : out  STD_LOGIC;
		
		--############################################################################	
		--# Peripheral Modules and GPIO
		--#   Peripheral Modules (PMODs) were invented by Digilent Inc. as small, 
		--#   inexpensive add-on boards for FPGA development boards. With costs 
		--#   starting as low as $10, PMODs allow you to add a number of capabilities 
		--#   to your board, including A/D, D/A, Wireless Radio, SD Card, 2x16 
		--#   Character LCD and a variety of LEDs, switches, and headers. See the 
		--#   complete library of Digilent PMODs at 
		--#     https://www.digilentinc.com/PMODs
		--############################################################################	
		--# Connector J5
			PMOD1_P1 : inout  STD_LOGIC;
			PMOD1_P2 : inout  STD_LOGIC;
			PMOD1_P3 : inout  STD_LOGIC;
			PMOD1_P4 : inout  STD_LOGIC;
			PMOD1_P7 : inout  STD_LOGIC;
			PMOD1_P8 : inout  STD_LOGIC;
			PMOD1_P9 : inout  STD_LOGIC;
			PMOD1_P10 : inout  STD_LOGIC;
		
		--# Connector J4
			PMOD2_P1 : inout  STD_LOGIC;
			PMOD2_P2 : inout  STD_LOGIC;
			PMOD2_P3 : inout  STD_LOGIC;
			PMOD2_P4 : inout  STD_LOGIC;
			PMOD2_P7 : inout  STD_LOGIC;
			PMOD2_P8 : inout  STD_LOGIC;
			PMOD2_P9 : inout  STD_LOGIC;
			PMOD2_P10 : inout  STD_LOGIC);
end top_mapping_avt;

architecture Behavioral of top_mapping_avt is

----------------------------------------------------------------------------------
-- Component
----------------------------------------------------------------------------------
component top_moduleDeplacement is
--	generic(
--		--generic
--		);
	Port ( 
		-- Clock
		iClk	: in STD_LOGIC;
		-- Encodeur
			-- Encodeur Mesure Droit
			iEncMesDA : in STD_LOGIC;
			iEncMesDB : in STD_LOGIC;
			iEncMesDZ : in STD_LOGIC;
			-- Encodeur Mesure Gauche
			iEncMesGA : in STD_LOGIC;
			iEncMesGB : in STD_LOGIC;
			iEncMesGZ : in STD_LOGIC;
			-- Encodeur Moteur Droit
			iEncMotDA : in STD_LOGIC;
			iEncMotDB : in STD_LOGIC;
			iEncMotDZ : in STD_LOGIC;
			-- Encodeur Moteur Gauche
			iEncMotGA : in STD_LOGIC;
			iEncMotGB : in STD_LOGIC;
			iEncMotGZ : in STD_LOGIC;
		-- Moteur
			-- Moteur Droit
			oPwmMotD 	: out STD_LOGIC;
			oBrakeMotD	: out STD_LOGIC;
			oDirMotD 	: out STD_LOGIC;
			-- Moteur Gauche
			oPwmMotG 	: out STD_LOGIC;
			oBrakeMotG	: out STD_LOGIC;
			oDirMotG		: out STD_LOGIC;			
		
		-- Led
		oLed1	: out STD_LOGIC;
		oLed2	: out STD_LOGIC;
		oLed3	: out STD_LOGIC;
		oLed4	: out STD_LOGIC
		);
end component;

begin

	top_moduleDeplacement_inst : top_moduleDeplacement 
--	generic map(
--		--generic
--		)
	Port map ( 
		-- Clock
		iClk	=> CLOCK_Y3,
		-- Encodeur
			-- Encodeur Mesure Droit
			iEncMesDA => PMOD2_P1,
			iEncMesDB => PMOD2_P2,
			iEncMesDZ => PMOD2_P3,
			-- Encodeur Mesure Gauche
			iEncMesGA => '0',
			iEncMesGB => '0',
			iEncMesGZ => '0',
			-- Encodeur Moteur Droit
			iEncMotDA => '0',
			iEncMotDB => '0',
			iEncMotDZ => '0',
			-- Encodeur Moteur Gauche
			iEncMotGA => '0',
			iEncMotGB => '0',
			iEncMotGZ => '0',
		-- Moteur
			-- Moteur Droit
			oPwmMotD 	=> PMOD1_P3,
			oBrakeMotD	=> open,
			oDirMotD 	=> PMOD1_P1,
			-- Moteur Gauche
			oPwmMotG 	=> PMOD1_P9,
			oBrakeMotG	=> open,
			oDirMotG	=> PMOD1_P7,
		
		-- Led
		oLed1	=> GPIO_LED1,
		oLed2	=> GPIO_LED2,
		oLed3	=> GPIO_LED3,
		oLed4	=> GPIO_LED4
		);	

end Behavioral;

