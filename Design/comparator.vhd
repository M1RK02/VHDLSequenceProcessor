-- Comparator

library ieee;
use ieee.std_logic_1164.all;

entity comparator is
    port (
        c_out    : in std_logic_vector(9 downto 0);
        i_k      : in std_logic_vector(9 downto 0);
        fsm_done : out std_logic
    );
end entity;

architecture comparator_arch of comparator is
begin
    -- Porta il valore fsm_done a 1 quando il contatore è maggiore uguale di 2K
    fsm_done <= '1' when ('0' & c_out) >= (i_k & '0') else '0';
end architecture;