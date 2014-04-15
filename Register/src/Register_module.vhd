----------------------------------------------------------------------------------
-- Company: Polytech Lille	
-- Engineers: Benjamin Lafit and Valentin Vergez
-- 
-- Create Date:    16:44:10 03/26/2014 
-- Design Name: 
-- Module Name:    Register_module - Behavioral 
-- Project Name: FPGA_QuadDecoder
-- Target Devices: 
-- Tool versions: 
-- Description: Module to save/change data in order to do loopback control
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
use IEEE.STD_LOGIC_UNSIGNED.ALL;
--use IEEE.NUMERIC_STD.ALL;


entity Register_module is
--generic
generic(
	-- Settings
		Param_clk_fq	: integer := 50000000;
		Param_nb_bit_data : integer :=8;
	-- Default values
		-- Asservissement moteurs en vitesse
		DefaultAsservMotG_KP : integer :=10;
		DefaultAsservMotG_KI : integer :=0;
		DefaultAsservMotG_KD : integer :=0;
		
		DefaultAsservMotD_KP : integer :=10;
		DefaultAsservMotD_KI : integer :=0;
		DefaultAsservMotD_KD : integer :=0;
		
		-- Asservissement moteurs polaire
		DefaultAsservPolAngle_KP : integer :=10;
		DefaultAsservPolAngle_KI : integer :=0;
		DefaultAsservPolAngle_KD : integer :=0;
		DefaultAsservPolDist_KP : integer :=10;
		DefaultAsservPolDist_KI : integer :=0;
		DefaultAsservPolDist_KD : integer :=0;
		
		--Use
		DefaultAsservPolUse: integer :=0;
		DefaultAsservMotGUse: integer :=0;
		DefaultAsservMotDUse: integer :=0
	);	
port(
	iClk : in STD_LOGIC;
	iRegData : in STD_LOGIC_VECTOR((21*Param_nb_bit_data)+2 downto 0); -- 21 data de nb_bit_data et 3 bits soit 24 adresses possibles
	oRegData : out STD_LOGIC_VECTOR((21*Param_nb_bit_data)+2 downto 0)
);
end Register_module;

architecture Behavioral of Register_module is

-- Alias
	-- Odometrie
alias odoX : STD_LOGIC_VECTOR (Param_nb_bit_data-1 downto 0) is iRegData((1*Param_nb_bit_data)-1 downto 0); --odometrie X
alias odoY : STD_LOGIC_VECTOR (Param_nb_bit_data-1 downto 0) is iRegData((2*Param_nb_bit_data)-1 downto 1*Param_nb_bit_data); --odometrie Y
alias odoPhi : STD_LOGIC_VECTOR (Param_nb_bit_data-1 downto 0) is iRegData((3*Param_nb_bit_data)-1 downto 2*Param_nb_bit_data); --odometrie Y
	-- Encode
alias encMotD : STD_LOGIC_VECTOR (Param_nb_bit_data-1 downto 0) is iRegData((4*Param_nb_bit_data)-1 downto 3*Param_nb_bit_data); --encodeur moteur droit
alias encMotG : STD_LOGIC_VECTOR (Param_nb_bit_data-1 downto 0) is iRegData((5*Param_nb_bit_data)-1 downto 4*Param_nb_bit_data); --encodeur moteur gauche
alias encMesD : STD_LOGIC_VECTOR (Param_nb_bit_data-1 downto 0) is iRegData((6*Param_nb_bit_data)-1 downto 5*Param_nb_bit_data); --encodeur mesure droit
alias encMesG : STD_LOGIC_VECTOR (Param_nb_bit_data-1 downto 0) is iRegData((7*Param_nb_bit_data)-1 downto 6*Param_nb_bit_data); --encodeur mesure gauche
	-- Asservissement vitesse
alias asservMotD_KP : STD_LOGIC_VECTOR (Param_nb_bit_data-1 downto 0) is iRegData((8*Param_nb_bit_data)-1 downto 7*Param_nb_bit_data); -- KP asservissement vitesse moteur droit
alias asservMotD_KI : STD_LOGIC_VECTOR (Param_nb_bit_data-1 downto 0) is iRegData((9*Param_nb_bit_data)-1 downto 8*Param_nb_bit_data); -- KI asservissement vitesse moteur droit
alias asservMotD_KD : STD_LOGIC_VECTOR (Param_nb_bit_data-1 downto 0) is iRegData((10*Param_nb_bit_data)-1 downto 9*Param_nb_bit_data); -- KD asservissement vitesse moteur droit
alias asservMotG_KP : STD_LOGIC_VECTOR (Param_nb_bit_data-1 downto 0) is iRegData((11*Param_nb_bit_data)-1 downto 10*Param_nb_bit_data); -- KP asservissement vitesse moteur gauche
alias asservMotG_KI : STD_LOGIC_VECTOR (Param_nb_bit_data-1 downto 0) is iRegData((12*Param_nb_bit_data)-1 downto 11*Param_nb_bit_data); -- KI asservissement vitesse moteur gauche
alias asservMotG_KD : STD_LOGIC_VECTOR (Param_nb_bit_data-1 downto 0) is iRegData((13*Param_nb_bit_data)-1 downto 12*Param_nb_bit_data); -- KD asservissement vitesse moteur gauche
alias asservMotD_consigne : STD_LOGIC_VECTOR (Param_nb_bit_data-1 downto 0) is iRegData((14*Param_nb_bit_data)-1 downto 13*Param_nb_bit_data); -- consigne asservissement vitesse moteur droit
alias asservMotG_consigne : STD_LOGIC_VECTOR (Param_nb_bit_data-1 downto 0) is iRegData((15*Param_nb_bit_data)-1 downto 14*Param_nb_bit_data); -- consigne asservissement vitesse moteur gauche
	-- Asservissement polaire
alias asservPolAngle_KP : STD_LOGIC_VECTOR (Param_nb_bit_data-1 downto 0) is iRegData((16*Param_nb_bit_data)-1 downto 15*Param_nb_bit_data); -- KP asservissement polaire en angle
alias asservPolAngle_KI : STD_LOGIC_VECTOR (Param_nb_bit_data-1 downto 0) is iRegData((17*Param_nb_bit_data)-1 downto 16*Param_nb_bit_data); -- KI asservissement polaire en angle
alias asservPolAngle_KD : STD_LOGIC_VECTOR (Param_nb_bit_data-1 downto 0) is iRegData((18*Param_nb_bit_data)-1 downto 17*Param_nb_bit_data); -- KD asservissement polaire en angle
alias asservPolDist_KP : STD_LOGIC_VECTOR (Param_nb_bit_data-1 downto 0) is iRegData((19*Param_nb_bit_data)-1 downto 18*Param_nb_bit_data); -- KP asservissement polaire en distance
alias asservPolDist_KI : STD_LOGIC_VECTOR (Param_nb_bit_data-1 downto 0) is iRegData((20*Param_nb_bit_data)-1 downto 19*Param_nb_bit_data); -- KI asservissement polaire en distance
alias asservPolDist_KD : STD_LOGIC_VECTOR (Param_nb_bit_data-1 downto 0) is iRegData((21*Param_nb_bit_data)-1 downto 20*Param_nb_bit_data); -- KD asservissement polaire en distance
	-- Use
alias asservPolUse : STD_LOGIC_VECTOR ( 0 downto 0) is iRegData((21*Param_nb_bit_data) downto 21*Param_nb_bit_data); -- bool pour savoir si asservissement polaire utilisé
alias asservMotGUse : STD_LOGIC_VECTOR ( 0 downto 0) is iRegData((21*Param_nb_bit_data)+1 downto (21*Param_nb_bit_data)+1); -- bool pour savoir si asservissement moteur gauche utilisé
alias asservMotDUse : STD_LOGIC_VECTOR ( 0 downto 0) is iRegData((21*Param_nb_bit_data)+2 downto (21*Param_nb_bit_data)+2); -- bool pour savoir si asservissement moteur droit utilisé

begin

oRegData<=iRegData;

end Behavioral;

