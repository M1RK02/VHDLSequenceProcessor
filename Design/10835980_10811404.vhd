-- Adder

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity adder is
    port (
        i_add      : in std_logic_vector(15 downto 0);
        c_out      : in std_logic_vector(9 downto 0);
        o_mem_addr : out std_logic_vector(15 downto 0)
    );
end entity;

architecture adder_arch of adder is
begin
    -- Somma l'indirizzo di partenza al valore del contatore per calcolare l'indirizzo attuale
    o_mem_addr <= std_logic_vector(unsigned(i_add) + unsigned(c_out));
end architecture;

-- Comparator

library ieee;
use ieee.std_logic_1164.all;

entity comparator is
    port (
        c_out    : in std_logic_vector(9 downto 0);
        i_k      : in std_logic_vector(9 downto 0);
        fsm_done : out std_logic
    );
end entity;

architecture comparator_arch of comparator is
begin
    -- Porta il valore fsm_done a 1 quando il contatore è maggiore uguale di 2K
    fsm_done <= '1' when ('0' & c_out) >= (i_k & '0') else '0';
end architecture;

-- Counter 10

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity counter_10 is
    port (
        i_clk   : in std_logic;
        i_rst   : in std_logic;
        fsm_rst : in std_logic;
        c_en    : in std_logic;
        c_out   : out std_logic_vector(9 downto 0)
    );
end entity;

architecture counter_10_arch of counter_10 is
    signal counter : std_logic_vector(9 downto 0);
begin
    c_out <= counter;
    process(i_clk, i_rst)
    begin
        if i_rst = '1' then
            -- Valore inizializzato a 0
            counter <= "0000000000";
        elsif rising_edge(i_clk) then
            if fsm_rst = '1' then
                -- Come nel reset esterno, valore inizializzato a 0
                counter <= "0000000000";
            elsif c_en = '1' then
                -- Incremento del contatore quando abilitato
                counter <= std_logic_vector(unsigned(counter) + 1);
            end if;
        end if;  
    end process;
end architecture;

-- Credibility

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity credibility is
    port (
        i_clk    : in std_logic;
        i_rst    : in std_logic;
        fsm_rst  : in std_logic;
        cred_set : in std_logic;
        cred_en  : in std_logic;
        cred     : out std_logic_vector(4 downto 0)
    );
end entity;

architecture credibility_arch of credibility is
    signal counter : std_logic_vector(4 downto 0);
begin
    cred <= counter;
    process(i_clk, i_rst)
    begin
        if i_rst = '1' then
            -- Credibilità inizializzata a 0
            counter <= "00000";
        elsif rising_edge(i_clk) then
            if fsm_rst = '1' then
                -- Come nel reset esterno, credibilità inizializzata a 0
                counter <= "00000";
            elsif cred_set = '1' then
                -- Credibilità settata a 31
                counter <= "11111";
            elsif cred_en = '1' then
                if counter /= "00000" then
                    -- Decremento della credbilità fino a 0 e non oltre
                    counter <= std_logic_vector(unsigned(counter) - 1);
                end if;
            end if;
        end if;  
    end process;
end architecture;

-- Mux

library ieee;
use ieee.std_logic_1164.all;

entity mux is
    port (
        r_out      : in std_logic_vector(7 downto 0);
        cred       : in std_logic_vector(4 downto 0);
        mux_ctrl   : in std_logic;
        o_mem_data : out std_logic_vector(7 downto 0)
    );
end entity;

architecture mux_arch of mux is   
begin
    -- Ingresso 0 valore del registro, ingresso 1 credibilità (estesa ad 8 bit)
    o_mem_data <= r_out when mux_ctrl = '0' else ("000" & cred) when mux_ctrl = '1';
end architecture;

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