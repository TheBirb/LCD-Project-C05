-- Plantilla para creación de testbench
--    xxx debe sustituires por el nombre del módulo a testear
---
library ieee; 
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity tb_cont  is 
end; 
 
architecture a of tb_cont is
  component counter8
    port ( 
    clk       : IN std_logic; 
    reset     : IN std_logic; 
    enable    : IN std_logic;
    load      : IN std_logic;
    data_ini  : IN std_logic_vector(7 DOWNTO 0);
    count     : OUT std_logic_vector(7 DOWNTO 0);
    tc        : OUT std_logic
	  ); 
  end component ; 
-- *** y declarar como señales internas todas las señales del port()
-- *** usando el mismo nombre
-- *** Además, pueden inicializarse las entradas para t=0
  signal tb_clk       : std_logic := '1'; 
  signal tb_reset     : std_logic := '1'; 
  signal tb_enable    : std_logic := '0';
  signal tb_load      : std_logic := '0';
  signal tb_data_ini  : std_logic_vector(7 DOWNTO 0):=(others=>'0');
  signal tb_count     : std_logic_vector(7 DOWNTO 0);
  signal tb_tc        : std_logic;
--	...
--	...
--	...
begin
  -- instancia del módulo a testear
  DUT: counter8  
  port map ( 
-- *** incluir todas las señales del port()
    clk      => tb_clk,
    reset    => tb_reset,
    enable   => tb_enable,
    load     => tb_load,
    data_ini => tb_data_ini,
    count    => tb_count,
    tc       => tb_tc
    );

  -- definicion del reloj
  tb_clk <= not tb_clk after 10 ns; -- per?odo 20ns -> 50 MHz

  -- definicion de estimulos de entrada
  process
    begin
    wait for 50 ns;      
      tb_reset <= '0';
    wait for 70 ns;
      tb_data_ini <= "00000011";
    wait for 70 ns;
      tb_load <= '1';
    wait for 150 ns;
      tb_load <= '0';
      tb_enable <= '1';
    wait for 400 ns;
      tb_enable <= '0';
    wait;
    end process;
end;
