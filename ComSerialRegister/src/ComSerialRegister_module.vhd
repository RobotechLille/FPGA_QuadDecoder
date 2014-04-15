----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    17:29:41 04/07/2014 
-- Design Name: 
-- Module Name:    ComSerialRegister_module - Behavioral 
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

entity ComSerialRegister_module is
generic(
	Param_clk_fq	: integer := 50000000;
	Param_nb_bit_data : integer :=	8;
	Param_baud_rate : integer := 8
);
Port(	
	iClk : in std_logic;
	oTx : out std_logic;
	oData : out std_logic_vector(7 downto 0); --affichage sur les leds
	iRx : in std_logic
	
);
end ComSerialRegister_module;

architecture Behavioral of ComSerialRegister_module is

----------------------------------------------------------------------------------
-- Components
----------------------------------------------------------------------------------

-------------------- Serial ----------------------
component serial_module is
generic(
	--generic
		Param_clk_fq	: integer := 50000000;
		Param_nb_bit_data : integer :=8;
		Param_baud_rate	: integer := 9600 
);
Port(
-- inputs
	iClk : in STD_LOGIC;
	iDataToTransmit : in STD_LOGIC_VECTOR ((Param_nb_bit_data - 1) downto 0);
	iRx : in STD_LOGIC;
	iEnableTransmit : in STD_LOGIC;
	
-- outputs
	oDataReady : out STD_LOGIC;
	oTransmitComplete : out STD_LOGIC := '0';
	oTx : out STD_LOGIC;
	oData : out STD_LOGIC_VECTOR((Param_nb_bit_data - 1) downto 0):="00000000"
);
end component;

-------------------- Register ----------------------
component Register_module is
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
end component;

----------------------------------------------------------------------------------
-- Behavioral
------------------------------------------------------------------------------------
--- Signaux
signal DataToSend : std_logic_vector ((Param_nb_bit_data - 1) downto 0);
signal DataReceive : std_logic_vector ((Param_nb_bit_data - 1) downto 0);
signal EnableTx : std_logic := '0';
signal DataReady : std_logic := '0';
signal TransmitComplete : std_logic := '0';
signal order : std_logic_vector(Param_nb_bit_data-1 downto 0);
signal initOk : std_logic := '0';
signal endOk: std_logic := '0';
signal receptError : std_logic := '0';
signal RegI : STD_LOGIC_VECTOR((21*Param_nb_bit_data)+2 downto 0);
signal regO : STD_LOGIC_VECTOR((21*Param_nb_bit_data)+2 downto 0);
signal dataBuffer : std_logic_vector(Param_nb_bit_data-1 downto 0);
signal startSend : std_logic_vector(4 downto 0); --5 bits pour pouvoir compter jusqu'a 23


--- Constantes 

--- Alias
	-- Odometrie
alias odoX : STD_LOGIC_VECTOR (Param_nb_bit_data-1 downto 0) is RegI ((1*Param_nb_bit_data)-1 downto 0); --odometrie X
alias odoY : STD_LOGIC_VECTOR (Param_nb_bit_data-1 downto 0) is RegI ((2*Param_nb_bit_data)-1 downto 1*Param_nb_bit_data); --odometrie Y
alias odoPhi : STD_LOGIC_VECTOR (Param_nb_bit_data-1 downto 0) is RegI ((3*Param_nb_bit_data)-1 downto 2*Param_nb_bit_data); --odometrie Y
	-- Encode
alias encMotD : STD_LOGIC_VECTOR (Param_nb_bit_data-1 downto 0) is RegI ((4*Param_nb_bit_data)-1 downto 3*Param_nb_bit_data); --encodeur moteur droit
alias encMotG : STD_LOGIC_VECTOR (Param_nb_bit_data-1 downto 0) is RegI ((5*Param_nb_bit_data)-1 downto 4*Param_nb_bit_data); --encodeur moteur gauche
alias encMesD : STD_LOGIC_VECTOR (Param_nb_bit_data-1 downto 0) is RegI ((6*Param_nb_bit_data)-1 downto 5*Param_nb_bit_data); --encodeur mesure droit
alias encMesG : STD_LOGIC_VECTOR (Param_nb_bit_data-1 downto 0) is RegI ((7*Param_nb_bit_data)-1 downto 6*Param_nb_bit_data); --encodeur mesure gauche
	-- Asservissement vitesse
alias asservMotD_KP : STD_LOGIC_VECTOR (Param_nb_bit_data-1 downto 0) is RegI ((8*Param_nb_bit_data)-1 downto 7*Param_nb_bit_data); -- KP asservissement vitesse moteur droit
alias asservMotD_KI : STD_LOGIC_VECTOR (Param_nb_bit_data-1 downto 0) is RegI ((9*Param_nb_bit_data)-1 downto 8*Param_nb_bit_data); -- KI asservissement vitesse moteur droit
alias asservMotD_KD : STD_LOGIC_VECTOR (Param_nb_bit_data-1 downto 0) is RegI ((10*Param_nb_bit_data)-1 downto 9*Param_nb_bit_data); -- KD asservissement vitesse moteur droit
alias asservMotG_KP : STD_LOGIC_VECTOR (Param_nb_bit_data-1 downto 0) is RegI ((11*Param_nb_bit_data)-1 downto 10*Param_nb_bit_data); -- KP asservissement vitesse moteur gauche
alias asservMotG_KI : STD_LOGIC_VECTOR (Param_nb_bit_data-1 downto 0) is RegI ((12*Param_nb_bit_data)-1 downto 11*Param_nb_bit_data); -- KI asservissement vitesse moteur gauche
alias asservMotG_KD : STD_LOGIC_VECTOR (Param_nb_bit_data-1 downto 0) is RegI ((13*Param_nb_bit_data)-1 downto 12*Param_nb_bit_data); -- KD asservissement vitesse moteur gauche
alias asservMotD_consigne : STD_LOGIC_VECTOR (Param_nb_bit_data-1 downto 0) is RegI ((14*Param_nb_bit_data)-1 downto 13*Param_nb_bit_data); -- consigne asservissement vitesse moteur droit
alias asservMotG_consigne : STD_LOGIC_VECTOR (Param_nb_bit_data-1 downto 0) is RegI ((15*Param_nb_bit_data)-1 downto 14*Param_nb_bit_data); -- consigne asservissement vitesse moteur gauche
	-- Asservissement polaire
alias asservPolAngle_KP : STD_LOGIC_VECTOR (Param_nb_bit_data-1 downto 0) is RegI ((16*Param_nb_bit_data)-1 downto 15*Param_nb_bit_data); -- KP asservissement polaire en angle
alias asservPolAngle_KI : STD_LOGIC_VECTOR (Param_nb_bit_data-1 downto 0) is RegI ((17*Param_nb_bit_data)-1 downto 16*Param_nb_bit_data); -- KI asservissement polaire en angle
alias asservPolAngle_KD : STD_LOGIC_VECTOR (Param_nb_bit_data-1 downto 0) is RegI ((18*Param_nb_bit_data)-1 downto 17*Param_nb_bit_data); -- KD asservissement polaire en angle
alias asservPolDist_KP : STD_LOGIC_VECTOR (Param_nb_bit_data-1 downto 0) is RegI ((19*Param_nb_bit_data)-1 downto 18*Param_nb_bit_data); -- KP asservissement polaire en distance
alias asservPolDist_KI : STD_LOGIC_VECTOR (Param_nb_bit_data-1 downto 0) is RegI ((20*Param_nb_bit_data)-1 downto 19*Param_nb_bit_data); -- KI asservissement polaire en distance
alias asservPolDist_KD : STD_LOGIC_VECTOR (Param_nb_bit_data-1 downto 0) is RegI ((21*Param_nb_bit_data)-1 downto 20*Param_nb_bit_data); -- KD asservissement polaire en distance
	-- Use
alias asservPolUse : STD_LOGIC_VECTOR ( 0 downto 0) is RegI ((21*Param_nb_bit_data) downto 21*Param_nb_bit_data); -- bool pour savoir si asservissement polaire utilisé
alias asservMotGUse : STD_LOGIC_VECTOR ( 0 downto 0) is RegI ((21*Param_nb_bit_data)+1 downto (21*Param_nb_bit_data)+1); -- bool pour savoir si asservissement moteur gauche utilisé
alias asservMotDUse : STD_LOGIC_VECTOR ( 0 downto 0) is RegI ((21*Param_nb_bit_data)+2 downto (21*Param_nb_bit_data)+2); -- bool pour savoir si asservissement moteur droit utilisé

--- Initialization
--asservMotD_KP = DefaultAsservMotD_KP;
--asservMotD_KI = DefaultAsservMotD_KI;
--asservMotD_KD = DefaultAsservMotD_KD;
--
--asservMotG_KP = DefaultAsservMotG_KP;
--asservMotG_KI = DefaultAsservMotG_KI;
--asservMotG_KD = DefaultAsservMotG_KD;
--
--asservPolAngle_KP = DefaultAsservPolAngle_KP;
--asservPolAngle_KI = DefaultAsservPolAngle_KI;
--asservPolAngle_KD = DefaultAsservPolAngle_KD;
--
--asservPolDist_KP = DefaultAsservPolDist_KP;
--asservPolDist_KI = DefaultAsservPolDist_KI;
--asservPolDist_KD = DefaultAsservPolDist_KD;
--
--asservPolUse = DefaultAsservPolUse;
--asservMotGUse = DefaultAsservMotGUse;
--asservMotDUse = DefaultAsservMotDUse;

begin 

	serial_inst : serial_module
	generic map(
		Param_clk_fq	=> Param_clk_fq,
		Param_nb_bit_data => Param_nb_bit_data,
		Param_baud_rate	=> Param_baud_rate 
		)
	port map(
		iClk => iClk,
		iDataToTransmit => DataToSend,
		iRx => iRx,
		iEnableTransmit => EnableTx,
		oDataReady => DataReady,
		oTransmitComplete => TransmitComplete,
		oTx => oTx,
		oData => DataReceive
	);
				
	register_inst : register_module
	port map(
	iClk => iClk,
	iRegData  => RegI,
	oRegData => RegO
	);

	process(iClk)
	
	begin
		oData<=DataReceive; --affichage sur les leds de la donnée reçu
		if iClk'event and iClk='1' then
			-- Recuperer un ordre en communication serie
			if (DataReceive=x"61") then -- Octet initialisation, exemple avec 'a'
				initOk <= '1';
			end if;
			
			if(initOk ='1') then 
				enableTx <= '1';
				DataToSend <= X"62";	 --si initialisation OK on renvoi b 			
			end if;
			
			if(enableTx='1') then --RAZ pour autre reception
				initOK <= '0';
				enableTx <= '0';
			end if;
			
			----------------------------------------------
--				dataBuffer <= DataReceive;
--				if(dataBuffer = x"61") then  --a
--					odoX<=dataBuffer;
--					startSend <= "00001";
--				end if;
--				
--				if(dataBuffer = x"62") then --b
--					odoY<=dataBuffer;
--					startSend <= "00010";
--				end if;
--					
--				-- Faire une lecture de se registre pour afficher la valeur sur le port série ou des leds
--				if(startSend = "00001") then 
--					Data <= odoX;
--					EnableTx <='1';
--				end if;
--				if(startSend = "00010") then 
--					Data <= odoY;
--					EnableTx <='1';
--				end if;
--				
--				if (EnableTx = '1') then
--					EnableTx <= '0';
--					startSend <= "00000";
--				end if;
			-----------------------------------------------------------------------------
		end if;
	end process;
end Behavioral;

