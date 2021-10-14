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
    count     : OUT std_logic_vector(3 DOWNTO 0);
    tc        : OUT std_logic;
    LCD_WRN   : OUT std_logic;
    LCD_RS    : OUT std_logic;
    LCD_CSN   : OUT std_logic
	  ); 
  end component ; 
-- *** y declarar como señales internas todas las señales del port()
-- *** usando el mismo nombre
-- *** Además, pueden inicializarse las entradas para t=0
  signal tb_clk       : std_logic := '1'; 
  signal tb_reset     : std_logic := '1'; 
  signal tb_enable    : std_logic := '0';
  signal tb_count     : std_logic_vector(3 DOWNTO 0);
  signal tb_tc        : std_logic;
  signal tb_lcd_rs    : std_logic :='0';
  signal tb_lcd_wrn   : std_logic :='0';
  signal tb_lcd_csn   : std_logic :='0';
  signal tb_enable_data: std_logic :='0';
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
    count    => tb_count,
    tc       => tb_tc,
    LCD_WRN  => tb_lcd_wrn,
    LCD_CSN  => tb_lcd_csn,
    LCD_RS   => tb_lcd_rs
    );

  -- definicion del reloj
  tb_clk <= not tb_clk after 10 ns; -- per?odo 20ns -> 50 MHz

  -- definicion de estimulos de entrada
  process
    begin
    wait for 50 ns;      
      tb_reset <= '0';
    wait;
    end process;
end;
