library ieee;
use ieee.std_logic_1164.all;

entity adder_tb is
end entity;

architecture adder_tb_arch of adder_tb is
    component adder is
        port(
            i_add      : in std_logic_vector(15 downto 0);
            c_out      : in std_logic_vector(9 downto 0);
            o_mem_addr : out std_logic_vector(15 downto 0)
        );
    end component;

    signal i_add      : std_logic_vector(15 downto 0);
    signal c_out      : std_logic_vector(9 downto 0);
    signal o_mem_addr : std_logic_vector(15 downto 0);

    constant clk_period : time := 10ns;
begin
    adder_istance : adder
    port map (i_add, c_out, o_mem_addr);

    simulation_process : process 
    begin
        i_add <= "0000000001000101";
        c_out <= "0001011010";
        wait for clk_period;
        assert (o_mem_addr = "0000000010011111") report "Simulation FAILED. (Sum is not correct)" severity failure;

        assert (false) report "Simulation OK." severity failure;
    end process;
end architecture;