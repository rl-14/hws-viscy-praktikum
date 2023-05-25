----------------------------------------------------------------------------------------
-- This file is part of the VISCY project.
-- (C) 2007-2021 Gundolf Kiefer, Fachhochschule Augsburg, University of Applied Sciences
-- (C) 2018 Michael SchÃ¤ferling, Hochschule Augsburg, University of Applied Sciences
--
-- Description:
--   This is a testbench for the VISCY CPU - neither exhaustive nor complete
----------------------------------------------------------------------------------------

library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;


entity VISCY_CPU_TB is
end VISCY_CPU_TB;


architecture BEHAVIOR of VISCY_CPU_TB is

  -- Component Declaration for the Unit Under Test (UUT) ...
  component VISCY_CPU
    port (
      clk:    in    std_logic;
      reset:  in    std_logic;
      adr:    out   std_logic_vector (15 downto 0);
      rdata:  in    std_logic_vector (15 downto 0);
      wdata:  out   std_logic_vector (15 downto 0);
      rd:     out   std_logic;
      wr:     out   std_logic;
      ready:  in    std_logic
    );
  end component;

  -- Signals ...
  signal clk:   std_logic := '0';
  signal reset: std_logic := '0';
  signal ready: std_logic := '0';

  signal adr:   std_logic_vector(15 downto 0);
  signal rdata: std_logic_vector(15 downto 0);
  signal wdata: std_logic_vector(15 downto 0);
  signal rd:    std_logic;
  signal wr:    std_logic;

  -- Parameters...
  constant clk_period: time := 10 ns;
  constant mem_delay: time := 25 ns;

  -- Memory content (generated by viscy2l) ...

  -- HIER: DIE AUSGABE VON VISCY2L EINFÃœGEN


BEGIN

  -- Instantiate the Unit Under Test (UUT)
  UUT: VISCY_CPU port map (
      clk => clk,
      reset => reset,
      adr => adr,
      rdata => rdata,
      wdata => wdata,
      rd => rd,
      wr => wr,
      ready => ready
    );

  -- Process to simulate the memory behavior ...
  memory: process
  begin
    ready <= '0';
    wait on rd, wr;
    if rd = '1' then
      wait for mem_delay;
      if is_x (adr) then
        rdata <= (others => 'X');
      else
        rdata <= mem_content (to_integer (unsigned (adr)));
      end if;
      ready <= '1';
      wait until rd = '0';
      rdata <= (others => 'X');
      wait for mem_delay;
      ready <= '0';
    elsif wr = '1' then
      wait for mem_delay;
      if not is_x(adr) then
        mem_content (to_integer (unsigned (adr))) <= wdata;
      end if;
      ready <= '1';
      wait until wr = '0';
      wait for mem_delay;
      ready <= '0';
    end if;
  end process;


  -- Main testbench process ...
  testbench: process
    
    procedure run_cycle is
    begin
      clk <= '0';
      wait for clk_period / 2;
      clk <= '1';
      wait for clk_period / 2;
    end procedure;

    variable n: integer;
    
  begin

    -- HIER: SINNVOLLES HAUPTPROGRAMM EINFÃœGEN
        
    wait; -- wait forever (stop simulation)
  end process;

end;
