-- FSM

library ieee;
use ieee.std_logic_1164.all;

entity fsm is
    port (
        i_clk      : in std_logic;
        i_rst      : in std_logic;
        i_start    : in std_logic;
        i_mem_data : in std_logic_vector(7 downto 0);
        fsm_done   : in std_logic;
        o_mem_en   : out std_logic;
        o_mem_we   : out std_logic;
        fsm_rst    : out std_logic;
        r_en       : out std_logic;
        cred_en    : out std_logic;
        cred_set   : out std_logic;
        mux_ctrl   : out std_logic;
        c_en       : out std_logic;
        o_done     : out std_logic
    );
end entity;

-- Implementata come macchina di Moore
architecture fsm_arch of fsm is
    type state is (s0, s1, s2, s3, s4, s5, s6, s7, s8);
    signal current_state : state;
begin
    -- Processo che si occupa delle transizioni di stato
    state_process : process(i_clk, i_rst)
    begin
        if i_rst = '1' then
            current_state <= s0;
        elsif rising_edge(i_clk) then
            -- Negli stati senza condizioni si verificano transizioni spontanee
            case current_state is
                when s0 =>
                    if i_start = '1' then
                        current_state <= s1;
                    end if;
                when s1 =>
                    current_state <= s2;
                when s2 =>
                    if fsm_done = '1' then
                        current_state <= s8;
                    elsif i_mem_data = "00000000" then
                        current_state <= s3;
                    elsif i_mem_data /= "00000000" then
                        current_state <= s4;
                    end if;
                when s3 =>
                    current_state <= s5;
                when s4 =>
                    current_state <= s5;
                when s5 =>
                    current_state <= s6;
                when s6 =>
                    current_state <= s7;
                when s7 =>
                    current_state <= s1;
                when s8 =>
                    if i_start = '0' then
                        current_state <= s0;
                    end if;
            end case;
        end if;
    end process;

    -- Processo che si occupa degli output
    out_process : process(current_state)
    begin
        o_mem_en <= '0';
        o_mem_we <= '0';
        o_done <= '0';
        fsm_rst <= '0';
        cred_en <= '0';
        cred_set <= '0';
        r_en <= '0';
        c_en <= '0';
        mux_ctrl <= '0';
        case current_state is
            when s0 =>
            when s1 =>
                o_mem_en <= '1';
            when s2 =>
                o_mem_en <= '1';
            when s3 =>
                o_mem_en <= '1';
                o_mem_we <= '1';
                cred_en <= '1';
            when s4 =>
                o_mem_en <= '1';
                r_en <= '1';
                cred_set <= '1';
            when s5 =>
                o_mem_en <= '1';
                c_en <= '1';
            when s6 =>
                o_mem_en <= '1';
                o_mem_we <= '1';
                mux_ctrl <= '1';
            when s7 =>
                o_mem_en <= '1';
                c_en <= '1';
            when s8 =>
                fsm_rst <= '1';
                o_done <= '1';
            end case;        
    end process;
end architecture;