-- Counter 10

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity counter_10 is
    port (
        i_clk   : in std_logic;
        i_rst   : in std_logic;
        fsm_rst : in std_logic;
        c_en    : in std_logic;
        c_out   : out std_logic_vector(9 downto 0)
    );
end entity;

architecture counter_10_arch of counter_10 is
    signal counter : std_logic_vector(9 downto 0);
begin
    c_out <= counter;
    process(i_clk, i_rst)
    begin
        if i_rst = '1' then
            -- Valore inizializzato a 0
            counter <= "0000000000";
        elsif rising_edge(i_clk) then
            if fsm_rst = '1' then
                -- Come nel reset esterno, valore inizializzato a 0
                counter <= "0000000000";
            elsif c_en = '1' then
                -- Incremento del contatore quando abilitato
                counter <= std_logic_vector(unsigned(counter) + 1);
            end if;
        end if;  
    end process;
end architecture;