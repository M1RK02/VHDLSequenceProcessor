library ieee;
use ieee.std_logic_1164.all;

entity mux_tb is
end entity;

architecture mux_tb_arch of mux_tb is
    component mux is
        port(
            r_out      : in std_logic_vector(7 downto 0);
            cred       : in std_logic_vector(4 downto 0);
            mux_ctrl   : in std_logic;
            o_mem_data : out std_logic_vector(7 downto 0)
        );
    end component;

    signal r_out      : std_logic_vector(7 downto 0);
    signal cred       : std_logic_vector(4 downto 0);
    signal mux_ctrl   : std_logic;
    signal o_mem_data : std_logic_vector(7 downto 0);

    constant clk_period : time := 10ns;
begin
    mux_istance : mux
    port map (r_out, cred, mux_ctrl, o_mem_data);

    simulation_process : process
    begin
        r_out <= "00000001";
        cred <= "00010";
        mux_ctrl <= '0';
        wait for clk_period;
        assert (o_mem_data = "00000001") report "Simulation FAILED. (mux_ctrl = 0 expected r_out)" severity failure;

        mux_ctrl <= '1';
        wait for clk_period;
        assert (o_mem_data = "00000010") report "Simulation FAILED. (mux_ctrl = 1 expected cred)" severity failure;

        assert (false) report "Simulation OK." severity failure;
    end process;
end architecture;