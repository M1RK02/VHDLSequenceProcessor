library ieee;
use ieee.std_logic_1164.all;

entity comparator_tb is
end entity;

architecture comparator_tb_arch of comparator_tb is
    component comparator is
        port (
            c_out    : in std_logic_vector(9 downto 0);
            i_k      : in std_logic_vector(9 downto 0);
            fsm_done : out std_logic
        );
    end component;

    signal c_out    : std_logic_vector(9 downto 0);
    signal i_k      : std_logic_vector(9 downto 0);
    signal fsm_done : std_logic;

    constant clk_period : time := 10ns;
begin
    comparator_istance : comparator
    port map (c_out, i_k, fsm_done);

    simulation_process : process 
    begin
        c_out <= "0000000010";
        i_k <= "0000000000";
        wait for clk_period;
        assert (fsm_done = '1') report "Simulation FAILED. (c_out > 2*i_k expected 1)" severity failure;

        i_k <= "0000000001";
        wait for clk_period;
        assert (fsm_done = '1') report "Simulation FAILED. (c_out = 2*i_k expected 1)" severity failure;

        i_k <= "0000000010";
        wait for clk_period;
        assert (fsm_done = '0') report "Simulation FAILED. (c_out < 2*i_k expected 0)" severity failure;

        assert (false) report "Simulation OK." severity failure;
    end process;   
end architecture;