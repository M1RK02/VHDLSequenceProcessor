library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity credibility_tb is
end entity;

architecture credibility_tb_arch of credibility_tb is
    component credibility is
        port (
            i_clk    : in std_logic;
            i_rst    : in std_logic;
            fsm_rst  : in std_logic;
            cred_set : in std_logic;
            cred_en  : in std_logic;
            cred     : out std_logic_vector(4 downto 0)
        );
    end component;

    signal i_clk    : std_logic;                   
    signal i_rst    : std_logic;                   
    signal fsm_rst  : std_logic;                   
    signal cred_set : std_logic;                   
    signal cred_en  : std_logic;                   
    signal cred     : std_logic_vector(4 downto 0);

    constant clk_period : time := 10ns;
begin
    credibility_istance : credibility
    port map (i_clk, i_rst, fsm_rst, cred_set, cred_en, cred);

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
        cred_set <= '0';
        cred_en <= '0';
        wait for clk_period;
        assert (unsigned(cred) = 0) report "Simulation FAILED. (After i_rst expected 0)" severity failure;

        i_rst <= '0';
        cred_set <= '1';
        wait for clk_period;
        assert (unsigned(cred) = 31) report "Simulation FAILED. (After cred_set expected 31)" severity failure;

        cred_set <= '0';
        cred_en <= '1';
        wait for clk_period;
        assert (unsigned(cred) = 30) report "Simulation FAILED. (One clock with cred_en expected 30)" severity failure;

        cred_en <= '0';
        fsm_rst <= '1';
        wait for clk_period;
        assert (unsigned(cred) = 0) report "Simulation FAILED. (After fsm_rst expected 0)" severity failure;

        fsm_rst <= '0';
        cred_set <= '1';
        wait for clk_period;
        assert (unsigned(cred) = 31) report "Simulation FAILED. (After cred_set expected 31)" severity failure;

        cred_set <= '0';
        cred_en <= '1';
        wait for clk_period*32;
        assert (unsigned(cred) = 0) report "Simulation FAILED. (32 clocks with cred_en expected 0)" severity failure;

        assert (false) report "Simulation OK." severity failure;
    end process;  
end architecture;