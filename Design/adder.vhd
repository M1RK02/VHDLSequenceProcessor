-- Adder

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity adder is
    port (
        i_add      : in std_logic_vector(15 downto 0);
        c_out      : in std_logic_vector(9 downto 0);
        o_mem_addr : out std_logic_vector(15 downto 0)
    );
end entity;

architecture adder_arch of adder is
begin
    -- Somma l'indirizzo di partenza al valore del contatore per calcolare l'indirizzo attuale
    o_mem_addr <= std_logic_vector(unsigned(i_add) + unsigned(c_out));
end architecture;