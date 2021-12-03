library ieee; 
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity tb_uart  is 
end;
architecture a of tb_uart is
	component LCD_UART
  	PORT (
   	clk          : IN  std_logic;
   	RxD 	 : IN  std_logic;
    	reset_l: IN  std_logic;
    	DONE_DRAWING : IN  std_logic;
    	DEL_SCREEN : OUT  std_logic;
    	DRAW_DIAG : OUT  std_logic
  	);
	end component;
signal tb_clk : std_logic:='1';
signal tb_reset_l : std_logic:='0';
signal tb_rxd : std_logic:='1';
signal tb_done_drawing: std_logic:='0';
signal tb_del_screen: std_logic:='0';
signal tb_draw_diag: std_logic:='0';

begin
DUT: LCD_UART
port map(
clk => tb_clk,
RxD => tb_rxd,
reset_l => tb_reset_l,
DONE_DRAWING => tb_done_drawing,
DEL_SCREEN => tb_del_screen,
DRAW_DIAG => tb_draw_diag
);


tb_clk <= not tb_clk after 10 ns;

process
begin
	wait for 50 ns;
	tb_reset_l<='1';
	wait for 100 ns;
	tb_rxd<='0';
	wait for 20 ns;
	tb_rxd<='1';
	wait for 20 ns;
	tb_rxd<='0';
	wait for 20 ns;
	tb_rxd<='0';
	wait for 20 ns;
	tb_rxd<='0';
	wait for 20 ns;
	tb_rxd<='1';
	wait for 20 ns;
	tb_rxd<='1';
	wait for 20 ns;
	tb_rxd<='1';
	wait for 20 ns;
	tb_rxd<='0';
	wait for 80 ns;
	tb_done_drawing<='1';
	wait for 20 ns;
	tb_done_drawing<='0';
	wait;
	end process;
end;

	