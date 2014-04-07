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
--use IEEE.NUMERIC_STD.ALL;


entity Register_module is
--generic
generic(
	-- Settings
		Param_clk_fq	: integer := 50000000;
		Param_nb_bit_data : integer :=8;
		Param_nb_bit_adresse : integer :=8;
		Param_nb_slave : integer :=2;
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
		DefaultAsservPolDist_KD : integer :=0
	);	
port(
	iClk : in STD_LOGIC;
	iAddresse : in STD_LOGIC_VECTOR (Param_nb_bit_adresse-1 downto 0);
	iDataToChange : in STD_LOGIC_VECTOR(Param_nb_bit_data downto 0);
	oData : out STD_LOGIC_VECTOR (Param_nb_bit_data-1 downto 0);
	oSignalOK : out STD_LOGIC_VECTOR(Param_nb_slave-1 downto 0) -- permet de dire à l'esclave si sa demande de données est acceptée 
);
end Register_module;

architecture Behavioral of Register_module is

-- Signaux
	-- Odometrie
signal odoX : STD_LOGIC_VECTOR (Param_nb_bit_data downto 0); --odometrie X
signal odoY : STD_LOGIC_VECTOR (Param_nb_bit_data downto 0); --odometrie Y
signal odoPhi : STD_LOGIC_VECTOR (Param_nb_bit_data downto 0); --odometrie Y
	-- Encodeurs
signal encMotD : STD_LOGIC_VECTOR (Param_nb_bit_data downto 0); --encodeur moteur droit
signal encMotG : STD_LOGIC_VECTOR (Param_nb_bit_data downto 0); --encodeur moteur gauche
signal encMesD : STD_LOGIC_VECTOR (Param_nb_bit_data downto 0); --encodeur mesure droit
signal encMesG : STD_LOGIC_VECTOR (Param_nb_bit_data downto 0); --encodeur mesure gauche
	-- Asservissement vitesse
signal asservMotD_KP : STD_LOGIC_VECTOR (Param_nb_bit_data downto 0); -- KP asservissement vitesse moteur droit
signal asservMotD_KI : STD_LOGIC_VECTOR (Param_nb_bit_data downto 0); -- KI asservissement vitesse moteur droit
signal asservMotD_KD : STD_LOGIC_VECTOR (Param_nb_bit_data downto 0); -- KD asservissement vitesse moteur droit
signal asservMotG_KP : STD_LOGIC_VECTOR (Param_nb_bit_data downto 0); -- KP asservissement vitesse moteur gauche
signal asservMotG_KI : STD_LOGIC_VECTOR (Param_nb_bit_data downto 0); -- KI asservissement vitesse moteur gauche
signal asservMotG_KD : STD_LOGIC_VECTOR (Param_nb_bit_data downto 0); -- KD asservissement vitesse moteur gauche
signal asservMotD_consigne : STD_LOGIC_VECTOR (Param_nb_bit_data downto 0); -- consigne asservissement vitesse moteur droit
signal asservMotG_consigne : STD_LOGIC_VECTOR (Param_nb_bit_data downto 0); -- consigne asservissement vitesse moteur gauche
	-- Asservissement polaire
signal asservPolAngle_KP : STD_LOGIC_VECTOR (Param_nb_bit_data downto 0); -- KP asservissement polaire en angle
signal asservPolAngle_KI : STD_LOGIC_VECTOR (Param_nb_bit_data downto 0); -- KI asservissement polaire en angle
signal asservPolAngle_KD : STD_LOGIC_VECTOR (Param_nb_bit_data downto 0); -- KD asservissement polaire en angle
signal asservPolDist_KP : STD_LOGIC_VECTOR (Param_nb_bit_data downto 0); -- KP asservissement polaire en distance
signal asservPolDist_KI : STD_LOGIC_VECTOR (Param_nb_bit_data downto 0); -- KI asservissement polaire en distance
signal asservPolDist_KD : STD_LOGIC_VECTOR (Param_nb_bit_data downto 0); -- KD asservissement polaire en distance
	-- Use
signal asservPolUse : STD_LOGIC; -- bool pour savoir si asservissement polaire utilisé
signal asservMotGUse : STD_LOGIC; -- bool pour savoir si asservissement moteur gauche utilisé
signal asservMotDUse : STD_LOGIC; -- bool pour savoir si asservissement moteur droit utilisé

begin


end Behavioral;

