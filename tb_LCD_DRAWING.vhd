-- Plantilla para creación de testbench
--    xxx debe sustituires por el nombre del módulo a testear
---
library ieee; 
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity tb_draw  is 
end; 
 
architecture a of tb_draw is
  component LCD_DRAWING
    port ( 
    clk           : IN std_logic; 
    reset         : IN std_logic; 
    DEL_SCREEN    : IN std_logic;
    DRAW_DIAG     : IN std_logic;
    COLOUR_CODE   : IN std_logic_vector(1 DOWNTO 0);
    DONE_CURSOR   : IN std_logic;
    DONE_COLOUR   : IN std_logic;
    OP_SETCURSOR  : OUT std_logic;
    XCOL          : OUT std_logic_vector(7 DOWNTO 0);
    YROW          : OUT std_logic_vector(8 DOWNTO 0);
    OP_DRAWCOLOUR : OUT std_logic;
    RGB           : OUT std_logic_vector(15 DOWNTO 0);
    NUM_PIX       : OUT std_logic_vector(16 DOWNTO 0)
	  ); 
  end component ; 
-- *** y declarar como señales internas todas las señales del port()
-- *** usando el mismo nombre
-- *** Además, pueden inicializarse las entradas para t=0
  signal tb_clk       : std_logic := '1'; 
  signal tb_reset     : std_logic := '1'; 
  signal tb_del_screen : std_logic:='0';
  signal tb_draw_diag    : std_logic := '0';
  signal tb_colour_code    : std_logic_vector (1 downto 0);
  signal tb_done_cursor   : std_logic :='0';
  signal tb_done_colour   : std_logic :='0';
  signal tb_op_setcursor : std_logic :='0';
  signal tb_xcol : std_logic_vector (7 downto 0);
  signal tb_yrow : std_logic_vector (8 downto 0);
  signal tb_op_drawcolour: std_logic:='0';
  signal tb_rgb: std_logic_vector (15 downto 0);
  signal tb_num_pix: std_logic_vector (16 downto 0);

--	...
--	...
--	...
begin
  -- instancia del módulo a testear
  DUT: LCD_DRAWING
  port map ( 
-- *** incluir todas las señales del port()
    clk      => tb_clk,
    reset    => tb_reset,
    DEL_SCREEN  => tb_del_screen,
    DRAW_DIAG  => tb_draw_diag,
    COLOUR_CODE   => tb_colour_code,
    DONE_CURSOR => tb_done_cursor,
    DONE_COLOUR => tb_done_colour,
    OP_SETCURSOR => tb_op_setcursor,
    XCOL => tb_xcol,
    YROW => tb_yrow,
    OP_DRAWCOLOUR => tb_op_drawcolour,
    RGB => tb_rgb,
    NUM_PIX => tb_num_pix
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