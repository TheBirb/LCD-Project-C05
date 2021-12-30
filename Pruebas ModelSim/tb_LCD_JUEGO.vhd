library ieee; 
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity tb_LDC_JUEGO  is 
end;

architecture a of tb_LDC_JUEGO is
  component LCD_JUEGO
    PORT (
      clk           : IN std_logic; 
      reset_l       : IN std_logic;
      FUN_JUEGO     : IN std_logic;
      MOVE          : IN std_logic;
      FIN           : IN std_logic;
      DIRECCION     : IN  std_logic_vector(1 DOWNTO 0);
      COLOR_CODE    : IN  std_logic_vector(1 DOWNTO 0);
      DONE_DEL      : IN std_logic;
      DONE_CURSOR   : IN std_logic;
      DONE_COLOR    : IN std_logic;
      DEL_SCREEN    : OUT std_logic;
      OP_SETCURSOR  : OUT std_logic;
      XCOL          : OUT std_logic_vector(7 DOWNTO 0);
      YROW          : OUT std_logic_vector(8 DOWNTO 0);
      OP_DRAWCOLOUR : OUT std_logic;
      RGB           : OUT std_logic_vector(15 DOWNTO 0);
      NUM_PIX       : OUT std_logic_vector(16 DOWNTO 0);
      DONE_DRAWING  : OUT std_logic
    );
  end component;

  SIGNAL  tb_clk           : std_logic; 
  SIGNAL  tb_reset_l       : std_logic;
  SIGNAL  tb_FUN_JUEGO     : std_logic;
  SIGNAL  tb_MOVE          : std_logic;
  SIGNAL  tb_FIN           : std_logic;
  SIGNAL  tb_DIRECCION     : std_logic_vector(1 DOWNTO 0);
  SIGNAL  tb_COLOR_CODE    : std_logic_vector(1 DOWNTO 0);
  SIGNAL  tb_DONE_DEL      : std_logic;
  SIGNAL  tb_DONE_CURSOR   : std_logic;
  SIGNAL  tb_DONE_COLOR    : std_logic;
  SIGNAL  tb_DEL_SCREEN    : std_logic;
  SIGNAL  tb_OP_SETCURSOR  : std_logic;
  SIGNAL  tb_XCOL          : std_logic_vector(7 DOWNTO 0);
  SIGNAL  tb_YROW          : std_logic_vector(8 DOWNTO 0);
  SIGNAL  tb_OP_DRAWCOLOUR : std_logic;
  SIGNAL  tb_RGB           : std_logic_vector(15 DOWNTO 0);
  SIGNAL  tb_NUM_PIX       : std_logic_vector(16 DOWNTO 0);
  SIGNAL  tb_DONE_DRAWING  : std_logic;

  begin DUT: LCD_JUEGO
  port map(
    clk => tb_clk,
    reset_l => tb_reset_l,
    FUN_JUEGO     => tb_FUN_JUEGO,
    MOVE          => tb_MOVE,
    FIN           => tb_FIN,
    DIRECCION     => tb_DIRECCION,
    COLOR_CODE    => tb_COLOR_CODE,
    DONE_DEL      => tb_DONE_DEL,
    DONE_CURSOR   => tb_DONE_CURSOR,
    DONE_COLOR    => tb_DONE_COLOR,
    DEL_SCREEN    => tb_DEL_SCREEN,
    OP_SETCURSOR  => tb_OP_SETCURSOR,
    XCOL          => tb_XCOL,
    YROW          => tb_YROW,
    OP_DRAWCOLOUR => tb_OP_DRAWCOLOUR,
    RGB           => tb_RGB,
    NUM_PIX       => tb_NUM_PIX,
    DONE_DRAWING  => tb_DONE_DRAWING 
  );


  tb_clk <= not tb_clk after 10 ns;

  process
  begin
    wait for 50 ns;
      tb_reset_l<='1';
    wait;
  end process;

end;