library ieee;
use ieee.std_logic_1164.all;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

entity QuadDecoder is
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
end entity QuadDecoder;

-- Architecture
architecture behavioral of QuadDecoder is

-- Signals
signal A_delayed : std_logic ;
signal B_delayed : std_logic ;
signal enable : STD_LOGIC;
signal up : STD_lOGIC;
signal count_register : STD_LOGIC_VECTOR(register_width-1 downto 0);

begin

process (clk) begin
  if (clk'event and clk='1') then
    up <= A XOR B_delayed;
    enable <= A XOR B XOR A_delayed XOR B_delayed;
    A_delayed <= A;
    B_delayed <= B;

    if (reset='0') then
        if (enable='1') then
            if (up='1') then
               count_register <= count_register+1;
            else
                count_register <= count_register-1;
            end if;
        end if;
    else
        count_register <= (others =>'0');
    end if;
  end if;
end process;

Ad <= A_delayed;
Bd <= B_delayed;
count <= count_register;
sEn <= enable;
sUp <= up;

end architecture behavioral;
