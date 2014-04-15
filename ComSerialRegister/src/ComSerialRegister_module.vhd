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
signal dataToSend : std_logic_vector ((Param_nb_bit_data - 1) downto 0);
signal dataReceive : std_logic_vector ((Param_nb_bit_data - 1) downto 0);
signal add :  std_logic_vector ((Param_nb_bit_data - 1) downto 0);
signal enableTx : std_logic := '0';
signal dataReady : std_logic := '0';
signal transmitComplete : std_logic := '0';
signal initOk : std_logic := '0';
signal endOk: std_logic := '0';
signal receptError : std_logic := '0';
signal regI : STD_LOGIC_VECTOR((21*Param_nb_bit_data)+2 downto 0);
signal regO : STD_LOGIC_VECTOR((21*Param_nb_bit_data)+2 downto 0);
signal data : std_logic_vector(Param_nb_bit_data-1 downto 0);
signal addReg : std_logic_vector(4 downto 0); --5 bits pour pouvoir compter jusqu'a 23
signal lecture : std_logic;
signal ecriture : std_logic;
signal finOK : std_logic;
signal addOK : std_logic;
signal dataOK : std_logic;

--- Constantes 

--- Alias
	-- Odometrie
alias odoX : STD_LOGIC_VECTOR (Param_nb_bit_data-1 downto 0) is regI ((1*Param_nb_bit_data)-1 downto 0); --odometrie X
alias odoY : STD_LOGIC_VECTOR (Param_nb_bit_data-1 downto 0) is regI ((2*Param_nb_bit_data)-1 downto 1*Param_nb_bit_data); --odometrie Y
alias odoPhi : STD_LOGIC_VECTOR (Param_nb_bit_data-1 downto 0) is regI ((3*Param_nb_bit_data)-1 downto 2*Param_nb_bit_data); --odometrie Y
	-- Encode
alias encMotD : STD_LOGIC_VECTOR (Param_nb_bit_data-1 downto 0) is regI ((4*Param_nb_bit_data)-1 downto 3*Param_nb_bit_data); --encodeur moteur droit
alias encMotG : STD_LOGIC_VECTOR (Param_nb_bit_data-1 downto 0) is regI ((5*Param_nb_bit_data)-1 downto 4*Param_nb_bit_data); --encodeur moteur gauche
alias encMesD : STD_LOGIC_VECTOR (Param_nb_bit_data-1 downto 0) is regI ((6*Param_nb_bit_data)-1 downto 5*Param_nb_bit_data); --encodeur mesure droit
alias encMesG : STD_LOGIC_VECTOR (Param_nb_bit_data-1 downto 0) is regI ((7*Param_nb_bit_data)-1 downto 6*Param_nb_bit_data); --encodeur mesure gauche
	-- Asservissement vitesse
alias asservMotD_KP : STD_LOGIC_VECTOR (Param_nb_bit_data-1 downto 0) is regI ((8*Param_nb_bit_data)-1 downto 7*Param_nb_bit_data); -- KP asservissement vitesse moteur droit
alias asservMotD_KI : STD_LOGIC_VECTOR (Param_nb_bit_data-1 downto 0) is regI ((9*Param_nb_bit_data)-1 downto 8*Param_nb_bit_data); -- KI asservissement vitesse moteur droit
alias asservMotD_KD : STD_LOGIC_VECTOR (Param_nb_bit_data-1 downto 0) is regI ((10*Param_nb_bit_data)-1 downto 9*Param_nb_bit_data); -- KD asservissement vitesse moteur droit
alias asservMotG_KP : STD_LOGIC_VECTOR (Param_nb_bit_data-1 downto 0) is regI ((11*Param_nb_bit_data)-1 downto 10*Param_nb_bit_data); -- KP asservissement vitesse moteur gauche
alias asservMotG_KI : STD_LOGIC_VECTOR (Param_nb_bit_data-1 downto 0) is regI ((12*Param_nb_bit_data)-1 downto 11*Param_nb_bit_data); -- KI asservissement vitesse moteur gauche
alias asservMotG_KD : STD_LOGIC_VECTOR (Param_nb_bit_data-1 downto 0) is regI ((13*Param_nb_bit_data)-1 downto 12*Param_nb_bit_data); -- KD asservissement vitesse moteur gauche
alias asservMotD_consigne : STD_LOGIC_VECTOR (Param_nb_bit_data-1 downto 0) is regI ((14*Param_nb_bit_data)-1 downto 13*Param_nb_bit_data); -- consigne asservissement vitesse moteur droit
alias asservMotG_consigne : STD_LOGIC_VECTOR (Param_nb_bit_data-1 downto 0) is regI ((15*Param_nb_bit_data)-1 downto 14*Param_nb_bit_data); -- consigne asservissement vitesse moteur gauche
	-- Asservissement polaire
alias asservPolAngle_KP : STD_LOGIC_VECTOR (Param_nb_bit_data-1 downto 0) is regI ((16*Param_nb_bit_data)-1 downto 15*Param_nb_bit_data); -- KP asservissement polaire en angle
alias asservPolAngle_KI : STD_LOGIC_VECTOR (Param_nb_bit_data-1 downto 0) is regI ((17*Param_nb_bit_data)-1 downto 16*Param_nb_bit_data); -- KI asservissement polaire en angle
alias asservPolAngle_KD : STD_LOGIC_VECTOR (Param_nb_bit_data-1 downto 0) is regI ((18*Param_nb_bit_data)-1 downto 17*Param_nb_bit_data); -- KD asservissement polaire en angle
alias asservPolDist_KP : STD_LOGIC_VECTOR (Param_nb_bit_data-1 downto 0) is regI ((19*Param_nb_bit_data)-1 downto 18*Param_nb_bit_data); -- KP asservissement polaire en distance
alias asservPolDist_KI : STD_LOGIC_VECTOR (Param_nb_bit_data-1 downto 0) is regI ((20*Param_nb_bit_data)-1 downto 19*Param_nb_bit_data); -- KI asservissement polaire en distance
alias asservPolDist_KD : STD_LOGIC_VECTOR (Param_nb_bit_data-1 downto 0) is regI ((21*Param_nb_bit_data)-1 downto 20*Param_nb_bit_data); -- KD asservissement polaire en distance
	-- Use
alias asservPolUse : STD_LOGIC_VECTOR ( 0 downto 0) is regI ((21*Param_nb_bit_data) downto 21*Param_nb_bit_data); -- bool pour savoir si asservissement polaire utilisé
alias asservMotGUse : STD_LOGIC_VECTOR ( 0 downto 0) is regI ((21*Param_nb_bit_data)+1 downto (21*Param_nb_bit_data)+1); -- bool pour savoir si asservissement moteur gauche utilisé
alias asservMotDUse : STD_LOGIC_VECTOR ( 0 downto 0) is regI ((21*Param_nb_bit_data)+2 downto (21*Param_nb_bit_data)+2); -- bool pour savoir si asservissement moteur droit utilisé

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
		iDataToTransmit => dataToSend,
		iRx => iRx,
		iEnableTransmit => enableTx,
		oDataReady => dataReady,
		oTransmitComplete => transmitComplete,
		oTx => oTx,
		oData => dataReceive
	);
				
	register_inst : register_module
	port map(
	iClk => iClk,
	iRegData  => regI,
	oRegData => regO
	);

	process(iClk)
	
	begin
	
		------------ TEST du protocole -----------------
		
		oData<=dataReceive; --affichage sur les leds de la donnée reçue
		if iClk'event and iClk='1' then
			-- Recuperer un ordre en communication serie
			if (dataReceive=x"00" and dataReady='1' and lecture ='0' and ecriture ='0') then -- Octet initialisation
				initOk <= '1';
			end if;
			
			if(initOk ='1') then  -- attente octet ordre
				if(dataReceive=X"01" and dataReady='1') then  
					lecture <= '1';
					initOk<='0';
				end if;
				
				if(dataReceive=X"02" and dataReady='1') then
					ecriture <= '1';
					initOk<='0';
				end if;	
			end if;
			
			if((ecriture ='1' or lecture ='1') and addOK='0' and dataOK='0' and finOK='0') then -- recuperation de l'adresse
				if(dataReady='1') then
					add<=dataReceive;
					addOK<='1';
				end if;
			end if;

			if(addOk='1') then  --recuperation de la donnée
				if(dataReady='1') then
					data<=dataReceive;
					addOK<='0';
					dataOK<='1';
				end if;
			end if;

			if(dataOK='1') then --recuperation de l'octet de fin
				if(dataReady='1' and dataReceive=X"FF") then
					finOK<='1';
					dataOK<='0';
				end if;
			end if;

			
		--------------- TEST du registre avec envoi/écriture par communication série -------------------------
--				data <= dataReceive;
--				if(data = x"61") then  --a
--					odoX<=data;
--					addReg <= "00001";
--				end if;
--				
--				if(data = x"62") then --b
--					odoY<=data;
--					addReg <= "00010";
--				end if;
--					
--				-- Faire une lecture de se registre pour afficher la valeur sur le port série ou des leds
--				if(addReg = "00001") then 
--					dataToSend <= odoX;
--					enableTx <='1';
--				end if;
--				if(addReg = "00010") then 
--					dataToSend <= odoY;
--					enableTx <='1';
--				end if;
--				
--				if (enableTx = '1') then
--					enableTx <= '0';
--					addReg <= "00000";
--				end if;
			-----------------------------------------------------------------------------
		end if;
	end process;
end Behavioral;

