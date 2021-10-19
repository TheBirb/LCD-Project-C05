-- Plantilla para creación de testbench
--    xxx debe sustituires por el nombre del módulo a testear
---
library ieee; 
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity tb_cont  is 
end; 
 
architecture a of tb_cont is
  component LCD_CTRL
    port ( 
    clk       : IN std_logic; 
    reset     : IN std_logic; 
    LCD_init_done : IN std_logic;
    OP_SETCURSOR : IN std_logic;
    OP_DRAWCOLOR : IN std_logic;
    RGB       : IN std_logic_vector(15 downto 0);
    NUM_PIX   : IN unsigned(16 downto 0);
    YROW      : IN std_logic_vector(8 DOWNTO 0);
    XCOL      : IN std_logic_vector(7 DOWNTO 0);
    LCD_WRN   : OUT std_logic;
    LCD_RS    : OUT std_logic;
    LCD_CSN   : OUT std_logic;
    DONE_CURSOR : OUT std_logic;
    DONE_COLOUR : OUT std_logic;
    LCD_DATA : OUT std_logic_vector (15 downto 0)
	  ); 
  end component ; 
-- *** y declarar como señales internas todas las señales del port()
-- *** usando el mismo nombre
-- *** Además, pueden inicializarse las entradas para t=0
  signal tb_clk       : std_logic := '1'; 
  signal tb_reset     : std_logic := '1'; 
  signal tb_lcd_init_done : std_logic:='1';
  signal tb_enable    : std_logic := '0';
  signal tb_lcd_rs    : std_logic :='0';
  signal tb_lcd_wrn   : std_logic :='0';
  signal tb_lcd_csn   : std_logic :='0';
  signal tb_op_setcursor : std_logic :='0';
  signal tb_op_drawcolor : std_logic :='0';
  signal tb_yrow : std_logic_vector (8 downto 0);
  signal tb_xcol : std_logic_vector (7 downto 0);
  signal tb_done_cursor: std_logic:='0';
  signal tb_done_colour: std_logic:='0';
  signal tb_lcd_data: std_logic_vector (15 downto 0);
  signal tb_num_pix : unsigned (16 downto 0);  
  signal tb_rgb : std_logic_vector (15 downto 0);

--	...
--	...
--	...
begin
  -- instancia del módulo a testear
  DUT: LCD_CTRL  
  port map ( 
-- *** incluir todas las señales del port()
    clk      => tb_clk,
    reset    => tb_reset,
    LCD_WRN  => tb_lcd_wrn,
    LCD_CSN  => tb_lcd_csn,
    LCD_RS   => tb_lcd_rs,
    OP_SETCURSOR => tb_op_setcursor,
    OP_DRAWCOLOR => tb_op_drawcolor,
    LCD_init_done => tb_lcd_init_done,
    YROW => tb_yrow,
    XCOL => tb_xcol,
    RGB => tb_rgb,
    NUM_PIX => tb_num_pix,
    DONE_COLOUR => tb_done_colour,
    DONE_CURSOR => tb_done_cursor
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
