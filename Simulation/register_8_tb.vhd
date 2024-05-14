library ieee;
use ieee.std_logic_1164.all;

entity register_8_tb is  
end entity;

architecture register_8_tb_arch of register_8_tb is
    component register_8 is
        port (
            i_clk      : in std_logic;
            i_rst      : in std_logic;
            fsm_rst    : in std_logic;
            r_en       : in std_logic;
            i_mem_data : in std_logic_vector(7 downto 0);
            r_out      : out std_logic_vector(7 downto 0)
        );
    end component;

    signal i_clk      : std_logic;
    signal i_rst      : std_logic;
    signal fsm_rst    : std_logic;
    signal r_en       : std_logic;
    signal i_mem_data : std_logic_vector(7 downto 0);
    signal r_out      : std_logic_vector(7 downto 0);

    constant clk_period : time := 10ns;
begin
    register_8_istance: register_8
    port map (i_clk, i_rst, fsm_rst, r_en, i_mem_data, r_out);
    
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
        r_en <= '0';
        i_mem_data <= "00000001";
        wait for clk_period;
        assert (r_out = "00000000") report "Simulation FAILED. (After i_rst expected 0)" severity failure;

        i_rst <= '0';
        r_en <= '1';
        wait for clk_period;
        assert (r_out = "00000001") report "Simulation FAILED. (One clock with r_en expected i_mem_data)" severity failure;

        fsm_rst <= '1';
        r_en <= '0';
        wait for clk_period;
        assert (r_out = "00000000") report "Simulation FAILED. (After fsm_rst expected 0)" severity failure;

        fsm_rst <= '0';
        wait for clk_period;
        assert (r_out = "00000000") report "Simulation FAILED. (One clock without r_en expected 0)" severity failure;

        assert (false) report "Simulation OK." severity failure;
    end process;  
end architecture;