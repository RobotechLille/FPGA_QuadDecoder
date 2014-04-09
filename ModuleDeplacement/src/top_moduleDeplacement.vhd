----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    15:28:11 03/19/2014 
-- Design Name: 
-- Module Name:    top_moduleDeplacement - Behavioral 
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
use IEEE.STD_LOGIC_ARITH.ALL;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx primitives in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity top_moduleDeplacement is
	generic(
	register_width : integer:= 32
		);
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
end top_moduleDeplacement;


----------------------------
----- ARCHITECTURE ----
architecture Behavioral of top_moduleDeplacement is

---- COMPOSANTS ----
-- DEBOUNCER
component Debouncer is
generic(
	--generic
		Param_ActiveEdgeClk		: STD_LOGIC := '1';
		Param_ActiveEdgeRst		: STD_LOGIC := '1';
		Param_ActiveEnable		: STD_LOGIC := '1';
		Param_SamplingFreg		: integer 	:= ( 40_000_000 / 100 ); -- ex : 10mS
		Param_Sampler_Depth		: integer 	:= 5							 -- etat stable sur 5 coups d'horloge ( Freq = Param_SamplingFreg )
	);
	Port ( 
		-- general
		iClk			: in 	STD_LOGIC;
		-- data path
			--in
		iSwitch		: in 	STD_LOGIC;
			--out
		oPressed		: out STD_LOGIC
			);
end component;

-- DECODEUR (signaux à quadratures de phases)
component QuadDecoder is
	--Configurable quadrature counter width; default is 32 bits
   generic (register_width : integer:= 32 );
   port (clk: in STD_LOGIC;
        A : in STD_LOGIC;
        B : in STD_LOGIC;
        reset : in STD_LOGIC;
        -- Sortie
        Bd : out STD_LOGIC;
        Ad : out STD_LOGIC;
        sEn : out STD_LOGIC;
        sUp : out STD_lOGIC;
        count : out STD_LOGIC_VECTOR(register_width-1 downto 0));
end component;

-- PWM
component pwm is
   port (iClk: in STD_LOGIC;
        iDutyCycle : in STD_LOGIC_VECTOR (7 downto 0); --rapport cyclique (de 0  10)
        oPwm : out STD_lOGIC); -- sortie
end component;

---- SIGNAUX ----
	-- Encodeurs
		-- Signaux une fois debounced (x8)
			-- Signal A
			signal sDebounced_EncMesD_sigA : STD_LOGIC;
			signal sDebounced_EncMesG_sigA : STD_LOGIC;
			signal sDebounced_EncMotD_sigA : STD_LOGIC;
			signal sDebounced_EncMotG_sigA : STD_LOGIC;
			-- Signal B
			signal sDebounced_EncMesD_sigB : STD_LOGIC;
			signal sDebounced_EncMesG_sigB : STD_LOGIC;
			signal sDebounced_EncMotD_sigB : STD_LOGIC;
			signal sDebounced_EncMotG_sigB : STD_LOGIC;
			-- -- Signal Z
			-- signal sDebounced_EncMesD_sigZ : STD_LOGIC;
			-- signal sDebounced_EncMesG_sigZ : STD_LOGIC;
			-- signal sDebounced_EncMotD_sigZ : STD_LOGIC;
			-- signal sDebounced_EncMotG_sigZ : STD_LOGIC;
		-- Counter (x4)
			signal sCount_EncMesD : STD_LOGIC_VECTOR(register_width-1 downto 0);
			signal sCount_EncMesG : STD_LOGIC_VECTOR(register_width-1 downto 0);
			signal sCount_EncMotD : STD_LOGIC_VECTOR(register_width-1 downto 0);
			signal sCount_EncMotG : STD_LOGIC_VECTOR(register_width-1 downto 0);
	-- Moteurs (x2)
		-- Moteur droit
			signal sDutyCycle_MotD : STD_LOGIC_VECTOR(7 downto 0);
		-- Moteur gauche
			signal sDutyCycle_MotG : STD_LOGIC_VECTOR(7 downto 0);


begin
	
-- Debouncer (x8)
	-- Signal A
		-- Roue de Mesure Droite
		-- debouncer_inst_EncMesD_sigA : Debouncer
		-- generic map(
		-- 	--generic
		-- 		Param_ActiveEdgeClk		=> '1',
		-- 		Param_ActiveEdgeRst		=> '1',
		-- 		Param_ActiveEnable		=> '1',
		-- 		Param_SamplingFreg		=> ( 40_000_000 / 100 ), -- ex : 10mS
		-- 		Param_Sampler_Depth		=> 5							 -- etat stable sur 5 coups d'horloge ( Freq = Param_SamplingFreg )
		-- 	)
		-- 	Port map( 
		-- 		-- general
		-- 		iClk 		=> iClk,
		-- 		-- data path
		-- 			--in
		-- 		iSwitch 	=> iEncMesDA,
		-- 			--out
		-- 		oPressed	=> sDebounced_EncMesD_sigA
		-- 			);
		sDebounced_EncMesD_sigA	<= iEncMesDA;

					
		-- Roue de Mesure Gauche
		-- debouncer_inst_EncMesG_sigA : Debouncer
		-- generic map(
		-- 	--generic
		-- 		Param_ActiveEdgeClk		=> '1',
		-- 		Param_ActiveEdgeRst		=> '1',
		-- 		Param_ActiveEnable		=> '1',
		-- 		Param_SamplingFreg		=> ( 40_000_000 / 100 ), -- ex : 10mS
		-- 		Param_Sampler_Depth		=> 5							 -- etat stable sur 5 coups d'horloge ( Freq = Param_SamplingFreg )
		-- 	)
		-- 	Port map( 
		-- 		-- general
		-- 		iClk 		=> iClk,
		-- 		-- data path
		-- 			--in
		-- 		iSwitch 	=> iEncMesGA,
		-- 			--out
		-- 		oPressed	=> sDebounced_EncMesG_sigA
		-- 			);
		sDebounced_EncMesG_sigA	<= iEncMesGA;
					
		-- Moteur Droit
		-- debouncer_inst_EncMotD_sigA : Debouncer
		-- generic map(
		-- 	--generic
		-- 		Param_ActiveEdgeClk		=> '1',
		-- 		Param_ActiveEdgeRst		=> '1',
		-- 		Param_ActiveEnable		=> '1',
		-- 		Param_SamplingFreg		=> ( 40_000_000 / 100 ), -- ex : 10mS
		-- 		Param_Sampler_Depth		=> 5							 -- etat stable sur 5 coups d'horloge ( Freq = Param_SamplingFreg )
		-- 	)
		-- 	Port map( 
		-- 		-- general
		-- 		iClk 		=> iClk,
		-- 		-- data path
		-- 			--in
		-- 		iSwitch 	=> iEncMotDA,
		-- 			--out
		-- 		oPressed	=> sDebounced_EncMotD_sigA
		-- 			);
		sDebounced_EncMotD_sigA	<= iEncMotDA;
					
		-- Moteur Gauche
		-- debouncer_inst_EncMotG_sigA : Debouncer
		-- generic map(
		-- 	--generic
		-- 		Param_ActiveEdgeClk		=> '1',
		-- 		Param_ActiveEdgeRst		=> '1',
		-- 		Param_ActiveEnable		=> '1',
		-- 		Param_SamplingFreg		=> ( 40_000_000 / 100 ), -- ex : 10mS
		-- 		Param_Sampler_Depth		=> 5							 -- etat stable sur 5 coups d'horloge ( Freq = Param_SamplingFreg )
		-- 	)
		-- 	Port map( 
		-- 		-- general
		-- 		iClk 		=> iClk,
		-- 		-- data path
		-- 			--in
		-- 		iSwitch 	=> iEncMotGA,
		-- 			--out
		-- 		oPressed	=> sDebounced_EncMotG_sigA
		-- 			);
		sDebounced_EncMotG_sigA	<= iEncMotGA;
				
	-- Signal B
		-- Roue de Mesure Droite
		-- debouncer_inst_EncMesD_sigB : Debouncer
		-- generic map(
		-- 	--generic
		-- 		Param_ActiveEdgeClk		=> '1',
		-- 		Param_ActiveEdgeRst		=> '1',
		-- 		Param_ActiveEnable		=> '1',
		-- 		Param_SamplingFreg		=> ( 40_000_000 / 100 ), -- ex : 10mS
		-- 		Param_Sampler_Depth		=> 5							 -- etat stable sur 5 coups d'horloge ( Freq = Param_SamplingFreg )
		-- 	)
		-- 	Port map( 
		-- 		-- general
		-- 		iClk 		=> iClk,
		-- 		-- data path
		-- 			--in
		-- 		iSwitch 	=> iEncMesDB,
		-- 			--out
		-- 		oPressed	=> sDebounced_EncMesD_sigB
		-- 			);
		sDebounced_EncMesD_sigB	<= iEncMesDB;
					
		-- Roue de Mesure Gauche
		-- debouncer_inst_EncMesG_sigB : Debouncer
		-- generic map(
		-- 	--generic
		-- 		Param_ActiveEdgeClk		=> '1',
		-- 		Param_ActiveEdgeRst		=> '1',
		-- 		Param_ActiveEnable		=> '1',
		-- 		Param_SamplingFreg		=> ( 40_000_000 / 100 ), -- ex : 10mS
		-- 		Param_Sampler_Depth		=> 5							 -- etat stable sur 5 coups d'horloge ( Freq = Param_SamplingFreg )
		-- 	)
		-- 	Port map( 
		-- 		-- general
		-- 		iClk 		=> iClk,
		-- 		-- data path
		-- 			--in
		-- 		iSwitch 	=> iEncMesGB,
		-- 			--out
		-- 		oPressed	=> sDebounced_EncMesG_sigB
		-- 			);
		sDebounced_EncMesG_sigB	<= iEncMesGB;
					
		-- Moteur Droit
		-- debouncer_inst_EncMotD_sigB : Debouncer
		-- generic map(
		-- 	--generic
		-- 		Param_ActiveEdgeClk		=> '1',
		-- 		Param_ActiveEdgeRst		=> '1',
		-- 		Param_ActiveEnable		=> '1',
		-- 		Param_SamplingFreg		=> ( 40_000_000 / 100 ), -- ex : 10mS
		-- 		Param_Sampler_Depth		=> 5							 -- etat stable sur 5 coups d'horloge ( Freq = Param_SamplingFreg )
		-- 	)
		-- 	Port map( 
		-- 		-- general
		-- 		iClk 		=> iClk,
		-- 		-- data path
		-- 			--in
		-- 		iSwitch 	=> iEncMotDB,
		-- 			--out
		-- 		oPressed	=> sDebounced_EncMotD_sigB
		-- 			);
		sDebounced_EncMotD_sigB	<= iEncMotDB;
					
		-- Moteur Gauche
		-- debouncer_inst_EncMotG_sigB : Debouncer
		-- generic map(
		-- 	--generic
		-- 		Param_ActiveEdgeClk		=> '1',
		-- 		Param_ActiveEdgeRst		=> '1',
		-- 		Param_ActiveEnable		=> '1',
		-- 		Param_SamplingFreg		=> ( 40_000_000 / 100 ), -- ex : 10mS
		-- 		Param_Sampler_Depth		=> 5							 -- etat stable sur 5 coups d'horloge ( Freq = Param_SamplingFreg )
		-- 	)
		-- 	Port map( 
		-- 		-- general
		-- 		iClk 		=> iClk,
		-- 		-- data path
		-- 			--in
		-- 		iSwitch 	=> iEncMotGB,
		-- 			--out
		-- 		oPressed	=> sDebounced_EncMotG_sigB
		-- 			);
		sDebounced_EncMotG_sigB	<= iEncMotGB;
				
-- Decoder (x4)
	-- Roue de Mesure Droite
	quadDecoder_inst_MesD : QuadDecoder
	--Configurable quadrature counter width; default is 32 bits
	generic map(
		register_width => 32 
		)
		Port map(clk => iClk,
			  A => sDebounced_EncMesD_sigA,
			  B => sDebounced_EncMesD_sigB,
			  reset => '0',
			  -- Sortie
			  Bd => open,
			  Ad => open,
			  sEn => open,
			  sUp => open,
			  count => sCount_EncMesD
			  );
			  
	-- Roue de Mesure Gauche
	quadDecoder_inst_MesG : QuadDecoder
	--Configurable quadrature counter width; default is 32 bits
	generic map(
		register_width => 32 
		)
		Port map(clk => iClk,
			  A => sDebounced_EncMesG_sigA,
			  B => sDebounced_EncMesG_sigB,
			  reset => '0',
			  -- Sortie
			  Bd => open,
			  Ad => open,
			  sEn => open,
			  sUp => open,
			  count => sCount_EncMesG
			  );
			  
	-- Moteur Droit
	quadDecoder_inst_MotD : QuadDecoder
	--Configurable quadrature counter width; default is 32 bits
	generic map(
		register_width => 32 
		)
		Port map(clk => iClk,
			  A => sDebounced_EncMotD_sigA,
			  B => sDebounced_EncMotD_sigB,
			  reset => '0',
			  -- Sortie
			  Bd => open,
			  Ad => open,
			  sEn => open,
			  sUp => open,
			  count => sCount_EncMotD
			  );
			  
	-- Moteur Gauche
	quadDecoder_inst_MotG : QuadDecoder
	--Configurable quadrature counter width; default is 32 bits
	generic map(
		register_width => 32 
		)
		Port map(clk => iClk,
			  A => sDebounced_EncMotG_sigA,
			  B => sDebounced_EncMotG_sigB,
			  reset => '0',
			  -- Sortie
			  Bd => open,
			  Ad => open,
			  sEn => open,
			  sUp => open,
			  count => sCount_EncMotG
			  );
-- PWM (x2)
	-- Moteur Droit
	pwm_inst_MotD : pwm
   port map (iClk => iClk,
        iDutyCycle => sDutyCycle_MotD,
        oPwm => oPwmMotD);		  
	
	-- Moteur Gauche
	pwm_inst_MotG : pwm
   port map (iClk => iClk,
        iDutyCycle => sDutyCycle_MotG,
        oPwm => oPwmMotG);

-- Signals
	sDutyCycle_MotD <= sCount_EncMesD(13 downto 6);
	sDutyCycle_MotG <= sCount_EncMesG(13 downto 6);

-- Mapping
	-- Moteur Droit
	oBrakeMotD <= '0';
	oDirMotD <= '1';
	-- Moteur Gauche
	oBrakeMotG <= '0';
	oDirMotG <= '1';

-- Others
	oLed1 <= '1';
	oLed2 <= '1';
	oLed3 <= '1';
	oLed4 <= '1';
		

end Behavioral;

