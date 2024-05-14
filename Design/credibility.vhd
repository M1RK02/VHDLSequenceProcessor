-- Credibility

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity credibility is
    port (
        i_clk    : in std_logic;
        i_rst    : in std_logic;
        fsm_rst  : in std_logic;
        cred_set : in std_logic;
        cred_en  : in std_logic;
        cred     : out std_logic_vector(4 downto 0)
    );
end entity;

architecture credibility_arch of credibility is
    signal counter : std_logic_vector(4 downto 0);
begin
    cred <= counter;
    process(i_clk, i_rst)
    begin
        if i_rst = '1' then
            -- Credibilità inizializzata a 0
            counter <= "00000";
        elsif rising_edge(i_clk) then
            if fsm_rst = '1' then
                -- Come nel reset esterno, credibilità inizializzata a 0
                counter <= "00000";
            elsif cred_set = '1' then
                -- Credibilità settata a 31
                counter <= "11111";
            elsif cred_en = '1' then
                if counter /= "00000" then
                    -- Decremento della credbilità fino a 0 e non oltre
                    counter <= std_logic_vector(unsigned(counter) - 1);
                end if;
            end if;
        end if;  
    end process;
end architecture;