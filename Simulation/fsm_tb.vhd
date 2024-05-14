library ieee;
use ieee.std_logic_1164.all;

entity fsm_tb is
end entity;

architecture fsm_tb_arch of fsm_tb is
    component fsm is
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
    end component;

    signal i_clk      : std_logic;                   
    signal i_rst      : std_logic;                   
    signal i_start    : std_logic;        
    signal i_mem_data : std_logic_vector(7 downto 0);
    signal fsm_done   : std_logic;
    signal o_mem_en   : std_logic;
    signal o_mem_we   : std_logic;
    signal fsm_rst    : std_logic;
    signal r_en       : std_logic;
    signal cred_en    : std_logic;
    signal cred_set   : std_logic;
    signal mux_ctrl   : std_logic;
    signal c_en       : std_logic;
    signal o_done     : std_logic;

    constant clk_period : time := 10ns;
begin
    fsm_istance : fsm
    port map (i_clk, i_rst, i_start, i_mem_data, fsm_done, o_mem_en, o_mem_we, fsm_rst, r_en, cred_en, cred_set, mux_ctrl, c_en, o_done);

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
        i_start <= '0';
        i_mem_data <= "00000000";
        fsm_done <= '0';
        wait for clk_period;
        assert (
            o_mem_en = '0' and
            o_mem_we = '0' and
            fsm_rst = '0' and
            r_en = '0' and
            cred_en = '0' and
            cred_set = '0' and
            mux_ctrl = '0' and
            c_en = '0' and
            o_done = '0'
        ) report "Simulation FAILED. (After i_rst expected S0)" severity failure;

        i_rst <= '0';
        i_start <= '1';
        wait for 8*clk_period;
        assert (
            o_mem_en = '1' and
            o_mem_we = '0' and
            fsm_rst = '0' and
            r_en = '0' and
            cred_en = '0' and
            cred_set = '0' and
            mux_ctrl = '0' and
            c_en = '0' and
            o_done = '0'
        ) report "Simulation FAILED. (5 clocks with i_mem_data = 0 expected S2)" severity failure;

        i_mem_data <= "00000001";
        wait for 6*clk_period;
        assert (
            o_mem_en = '1' and
            o_mem_we = '0' and
            fsm_rst = '0' and
            r_en = '0' and
            cred_en = '0' and
            cred_set = '0' and
            mux_ctrl = '0' and
            c_en = '0' and
            o_done = '0'
        ) report "Simulation FAILED. (5 clocks with i_mem_data /= 0 expected S2)" severity failure;

        fsm_done <= '1';
        wait for clk_period;
        assert (
            o_mem_en = '0' and
            o_mem_we = '0' and
            fsm_rst = '1' and
            r_en = '0' and
            cred_en = '0' and
            cred_set = '0' and
            mux_ctrl = '0' and
            c_en = '0' and
            o_done = '1'
        ) report "Simulation FAILED. (After fsm_done expected S8)" severity failure;

        i_start <= '0';
        wait for clk_period;
        assert (
            o_mem_en = '0' and
            o_mem_we = '0' and
            fsm_rst = '0' and
            r_en = '0' and
            cred_en = '0' and
            cred_set = '0' and
            mux_ctrl = '0' and
            c_en = '0' and
            o_done = '0'
        ) report "Simulation FAILED. (After i_start = 0 expected S0)" severity failure;

        assert (false) report "Simulation OK." severity failure;
    end process;  
end architecture;