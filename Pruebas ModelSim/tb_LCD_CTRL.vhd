library ieee; 
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity tb_cont  is 
end; 
 
architecture a of tb_cont is
  component LCD_CTRL
    port ( 
    clk       : IN std_logic; 
    reset_l     : IN std_logic; 
    LCD_init_done : IN std_logic;
    OP_SETCURSOR : IN std_logic;
    OP_DRAWCOLOUR : IN std_logic;
    RGB       : IN std_logic_vector(15 downto 0);
    NUMPIX   : IN unsigned(16 downto 0);
    YROW      : IN std_logic_vector(8 DOWNTO 0);
    XCOL      : IN std_logic_vector(7 DOWNTO 0);
    LCD_WR_N   : OUT std_logic;
    LCD_RS    : OUT std_logic;
    LCD_CS_N   : OUT std_logic;
    DONE_SETCURSOR : OUT std_logic;
    DONE_DRAWCOLOR : OUT std_logic;
    LCD_DATA : OUT std_logic_vector (15 downto 0)
	  ); 
  end component ; 
-- *** y declarar como señales internas todas las señales del port()
-- *** usando el mismo nombre
-- *** Además, pueden inicializarse las entradas para t=0
  signal tb_clk       : std_logic := '1'; 
  signal tb_reset     : std_logic := '0'; 
  signal tb_lcd_init_done : std_logic:='1';
  signal tb_enable    : std_logic := '0';
  signal tb_lcd_rs    : std_logic :='1';
  signal tb_lcd_wrn   : std_logic :='1';
  signal tb_lcd_csn   : std_logic :='1';
  signal tb_op_setcursor : std_logic :='0';
  signal tb_op_drawcolor : std_logic :='0';
  signal tb_yrow : std_logic_vector (8 downto 0) := "100010011";
  signal tb_xcol : std_logic_vector (7 downto 0) :="10001001";
  signal tb_done_cursor: std_logic:='0';
  signal tb_done_colour: std_logic:='0';
  signal tb_lcd_data: std_logic_vector (15 downto 0);
  signal tb_num_pix : unsigned (16 downto 0) := "00000000000000101";  
  signal tb_rgb : std_logic_vector (15 downto 0) := "1111100000000000";

--	...
--	...
--	...
begin
  -- instancia del módulo a testear
  DUT: LCD_CTRL  
  port map ( 
-- *** incluir todas las señales del port()
    clk      => tb_clk,
    reset_l   => tb_reset,
    LCD_WR_N  => tb_lcd_wrn,
    LCD_CS_N  => tb_lcd_csn,
    LCD_RS   => tb_lcd_rs,
    OP_SETCURSOR => tb_op_setcursor,
    OP_DRAWCOLOUR => tb_op_drawcolor,
    LCD_init_done => tb_lcd_init_done,
    YROW => tb_yrow,
    XCOL => tb_xcol,
    RGB => tb_rgb,
    NUMPIX => tb_num_pix,
    DONE_DRAWCOLOR => tb_done_colour,
    DONE_SETCURSOR => tb_done_cursor
    );

  -- definicion del reloj
  tb_clk <= not tb_clk after 10 ns; -- per?odo 20ns -> 50 MHz

  -- definicion de estimulos de entrada
  process
    begin
    wait for 50 ns;      
      tb_reset <= '1';
      tb_op_setcursor <= '1';
    wait for 30 ns;
	tb_op_setcursor <= '0';
    wait for 560 ns;
        tb_op_drawcolor <= '1';
    wait for 30 ns;
	tb_op_drawcolor <= '0';
    wait;
    end process;
end;
