-- Plantilla para creaci�n de testbench
--    xxx debe sustituires por el nombre del m�dulo a testear
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
    reset_l       : IN std_logic; 
    DEL_SCREEN    : IN std_logic;
    DRAW_DIAG     : IN std_logic;
    COLOUR        : IN std_logic_vector(1 DOWNTO 0);
    DONE_SETCURSOR   : IN std_logic;
    DONE_DRAWCOLOR   : IN std_logic;
    OP_SETCURSOR  : OUT std_logic;
    XCOL          : OUT std_logic_vector(7 DOWNTO 0);
    YROW          : OUT std_logic_vector(8 DOWNTO 0);
    OP_DRAWCOLOUR : OUT std_logic;
    RGB           : OUT std_logic_vector(15 DOWNTO 0);
    NUMPIX       : OUT std_logic_vector(16 DOWNTO 0)
  ); 
  end component ; 
-- *** y declarar como se�ales internas todas las se�ales del port()
-- *** usando el mismo nombre
-- *** Adem�s, pueden inicializarse las entradas para t=0
  signal tb_clk       : std_logic := '1'; 
  signal tb_reset     : std_logic := '0'; 
  signal tb_del_screen : std_logic:='1';
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
  -- instancia del m�dulo a testear
  DUT: LCD_DRAWING
  port map ( 
-- *** incluir todas las se�ales del port()
    clk      => tb_clk,
    reset_l    => tb_reset,
    DEL_SCREEN  => tb_del_screen,
    DRAW_DIAG  => tb_draw_diag,
    COLOUR   => tb_colour_code,
    DONE_SETCURSOR => tb_done_cursor,
    DONE_DRAWCOLOR => tb_done_colour,
    OP_SETCURSOR => tb_op_setcursor,
    XCOL => tb_xcol,
    YROW => tb_yrow,
    OP_DRAWCOLOUR => tb_op_drawcolour,
    RGB => tb_rgb,
    NUMPIX => tb_num_pix
    );

  -- definicion del reloj
  tb_clk <= not tb_clk after 20 ns; -- per?odo 20ns -> 50 MHz

  -- definicion de estimulos de entrada
  process
    begin
    wait for 20 ns;      
      tb_reset <= '1';
    wait;
    end process;
end;