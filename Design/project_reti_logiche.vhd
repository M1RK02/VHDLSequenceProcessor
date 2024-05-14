-- Project Reti Logiche

library ieee;
use ieee.std_logic_1164.all;

entity project_reti_logiche is
    port (
        i_clk   : in std_logic;
        i_rst   : in std_logic;
        i_start : in std_logic;
        i_add   : in std_logic_vector(15 downto 0);
        i_k     : in std_logic_vector(9 downto 0);

        o_done : out std_logic;

        o_mem_addr : out std_logic_vector(15 downto 0) ;
        i_mem_data : in std_logic_vector(7 downto 0);
        o_mem_data : out std_logic_vector(7 downto 0);
        o_mem_we   : out std_logic;
        o_mem_en   : out std_logic
) ;
end entity;

-- Descrizione strutturale del progetto
architecture project_reti_logiche_arch of project_reti_logiche is
    signal fsm_rst, r_en, cred_en, cred_set, mux_ctrl, c_en, fsm_done : std_logic;
    signal cred  : std_logic_vector(4 downto 0);
    signal r_out : std_logic_vector(7 downto 0);
    signal c_out : std_logic_vector(9 downto 0);
    
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

    component adder is
        port(
            i_add      : in std_logic_vector(15 downto 0);
            c_out      : in std_logic_vector(9 downto 0);
            o_mem_addr : out std_logic_vector(15 downto 0)
        );
    end component;

    component comparator is
        port (
            c_out    : in std_logic_vector(9 downto 0);
            i_k      : in std_logic_vector(9 downto 0);
            fsm_done : out std_logic
        );
    end component;

    component counter_10 is
        port (
            i_clk   : in std_logic;
            i_rst   : in std_logic;
            fsm_rst : in std_logic;
            c_en    : in std_logic;
            c_out   : out std_logic_vector(9 downto 0)
        );
    end component;

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

    component mux is
        port(
            r_out      : in std_logic_vector(7 downto 0);
            cred       : in std_logic_vector(4 downto 0);
            mux_ctrl   : in std_logic;
            o_mem_data : out std_logic_vector(7 downto 0)
        );
    end component;
begin
    adder_instance : adder
    port map (i_add, c_out, o_mem_addr);
    
    comparator_instance : comparator
    port map (c_out, i_k, fsm_done);
    
    counter_10_instance : counter_10
    port map (i_clk, i_rst, fsm_rst, c_en, c_out);

    credibility_instance : credibility
    port map (i_clk, i_rst, fsm_rst, cred_set, cred_en, cred);
    
    fsm_instance : fsm
    port map (i_clk, i_rst, i_start, i_mem_data, fsm_done, o_mem_en, o_mem_we, fsm_rst, r_en, cred_en, cred_set, mux_ctrl, c_en, o_done);
    
    mux_instance : mux
    port map (r_out, cred, mux_ctrl, o_mem_data);
    
    register_8_instance: register_8
    port map (i_clk, i_rst, fsm_rst, r_en, i_mem_data, r_out);
end architecture;