-- Mux

library ieee;
use ieee.std_logic_1164.all;

entity mux is
    port (
        r_out      : in std_logic_vector(7 downto 0);
        cred       : in std_logic_vector(4 downto 0);
        mux_ctrl   : in std_logic;
        o_mem_data : out std_logic_vector(7 downto 0)
    );
end entity;

architecture mux_arch of mux is   
begin
    -- Ingresso 0 valore del registro, ingresso 1 credibilità (estesa ad 8 bit)
    o_mem_data <= r_out when mux_ctrl = '0' else ("000" & cred) when mux_ctrl = '1';
end architecture;