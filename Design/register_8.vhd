-- Register 8

library ieee;
use ieee.std_logic_1164.all;

entity register_8 is
    port (
        i_clk      : in std_logic;
        i_rst      : in std_logic;
        fsm_rst    : in std_logic;
        r_en       : in std_logic;
        i_mem_data : in std_logic_vector(7 downto 0);
        r_out      : out std_logic_vector(7 downto 0)
    );
end entity;

architecture register_8_arch of register_8 is
    signal stored_value : std_logic_vector(7 downto 0);
begin
    r_out <= stored_value;
    process(i_clk, i_rst)
    begin
        if i_rst = '1' then
            -- Valore inizializzato a 0
            stored_value <= "00000000";
        elsif rising_edge(i_clk) then
            if fsm_rst = '1' then 
                -- Come nel reset esterno, valore inizializzatoa  0
                stored_value <= "00000000";
            elsif r_en = '1' then
                -- Legge il valore dalla memoria se il registro è abilitato
                stored_value <= i_mem_data;
            end if;
        end if;
    end process;
end architecture;