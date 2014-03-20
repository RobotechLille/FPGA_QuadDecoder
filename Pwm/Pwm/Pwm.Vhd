library ieee;
use ieee.std_logic_1164.all;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

entity pwm is
   port (iClk: in STD_LOGIC;
        iDutyCycle : in STD_LOGIC_VECTOR (7 downto 0); --rapport cyclique (de 0  10)
        oPwm : out STD_lOGIC); -- sortie
end entity pwm;

architecture behavioral of pwm is

signal cnt : std_logic_vector(7 downto 0) := X"00";
signal s : std_logic;

begin
process (iClk) begin
if (iClk'event and iClk='1') then
    if (cnt < iDutyCycle) then s <='1'; --met la sortie  1 jusqu'a
    else s <='0';               --la valeur du rapport cyclique
    end if;
	 
    if (cnt >= X"FF") then cnt<=X"00"; --remet  0 quand on a
    else cnt <= cnt + 1;                 -- compt jusqu'a 255
    end if;
end if;
end process;
oPwm <= s;
end architecture behavioral;
