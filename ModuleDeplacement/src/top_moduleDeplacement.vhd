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
		iClk	: in STD_LOGIC;
		iEncA : in STD_LOGIC;
		iEncB : in STD_LOGIC;
		iEncZ : in STD_LOGIC;
		oLed1	: out STD_LOGIC
		);
end top_moduleDeplacement;

architecture Behavioral of top_moduleDeplacement is

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

component pwm is
   port (iClk: in STD_LOGIC;
        iDutyCycle : in STD_LOGIC_VECTOR (7 downto 0); --rapport cyclique (de 0  10)
        oPwm : out STD_lOGIC); -- sortie
end component;

signal sDebouncedEncA : STD_LOGIC;
signal sDebouncedEncB : STD_LOGIC;
signal sEncCount : STD_LOGIC_VECTOR(register_width-1 downto 0);
signal sDutyCycle : STD_LOGIC_VECTOR(7 downto 0);

begin

	debouncer_inst_EncA : Debouncer
	generic map(
		--generic
			Param_ActiveEdgeClk		=> '1',
			Param_ActiveEdgeRst		=> '1',
			Param_ActiveEnable		=> '1',
			Param_SamplingFreg		=> ( 40_000_000 / 100 ), -- ex : 10mS
			Param_Sampler_Depth		=> 5							 -- etat stable sur 5 coups d'horloge ( Freq = Param_SamplingFreg )
		)
		Port map( 
			-- general
			iClk 		=> iClk,
			-- data path
				--in
			iSwitch 	=> iEncA,
				--out
			oPressed	=> sDebouncedEncA
				);
				
	debouncer_inst_EncB : Debouncer
	generic map(
		--generic
			Param_ActiveEdgeClk		=> '1',
			Param_ActiveEdgeRst		=> '1',
			Param_ActiveEnable		=> '1',
			Param_SamplingFreg		=> ( 40_000_000 / 100 ), -- ex : 10mS
			Param_Sampler_Depth		=> 5							 -- etat stable sur 5 coups d'horloge ( Freq = Param_SamplingFreg )
		)
		Port map( 
			-- general
			iClk 		=> iClk,
			-- data path
				--in
			iSwitch 	=> iEncB,
				--out
			oPressed	=> sDebouncedEncB
				);
				
		

	quadDecoder_inst : QuadDecoder
	--Configurable quadrature counter width; default is 32 bits
	generic map(
		register_width => 32 
		)
		Port map(clk => iClk,
			  A => sDebouncedEncA,
			  B => sDebouncedEncB,
			  reset => '0',
			  -- Sortie
			  Bd => open,
			  Ad => open,
			  sEn => open,
			  sUp => open,
			  count => sEncCount
			  );
			  
	pwm_inst_1 : pwm
   port map (iClk => iClk,
        iDutyCycle => sDutyCycle,
        oPwm => oLed1);
		  
	sDutyCycle <= x"80";
		

end Behavioral;

