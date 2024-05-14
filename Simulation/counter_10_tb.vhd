library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity counter_10_tb is
end entity;

architecture counter_10_tb_arch of counter_10_tb is
    component counter_10 is
        port (
            i_clk   : in std_logic;
            i_rst   : in std_logic;
            fsm_rst : in std_logic;
            c_en    : in std_logic;
            c_out   : out std_logic_vector(9 downto 0)
        );
    end component;

    signal i_clk   : std_logic;                   
    signal i_rst   : std_logic;                  
    signal fsm_rst : std_logic;                  
    signal c_en    : std_logic;          
    signal c_out   : std_logic_vector(9 downto 0);

    constant clk_period : time := 10ns;
begin
    counter_10_istance : counter_10
    port map (i_clk, i_rst, fsm_rst, c_en, c_out);

    clk_process : process
    begin
        i_clk <= '0';
        wait for clk_period/2;
        i_clk <= '1';
        wait for clk_period/2;
    end process;

    simulation_process : process
    begin
        i_rst <= '1';
        fsm_rst <= '0';
        c_en <= '0';
        wait for clk_period;
        assert (unsigned(c_out) = 0) report "Simulation FAILED. (After i_rst expected 0)" severity failure;

        i_rst <= '0';
        c_en <= '1';
        wait for clk_period;
        assert (unsigned(c_out) = 1) report "Simulation FAILED. (One clock with c_en expected 1)" severity failure;

        c_en <= '0';
        fsm_rst <= '1';
        wait for clk_period;
        assert (unsigned(c_out) = 0) report "Simulation FAILED. (After fsm_rst expected 0)" severity failure;

        fsm_rst <= '0';
        c_en <= '1';
        wait for clk_period*10;
        assert (unsigned(c_out) = 10) report "Simulation FAILED. (Ten clocks with c_en expected 10)" severity failure;

        assert (false) report "Simulation OK." severity failure;
    end process;  
end architecture;