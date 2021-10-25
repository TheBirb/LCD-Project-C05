LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.all;
USE IEEE.NUMERIC_STD.all;

ENTITY LCD_DRAWING IS
  PORT (
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
    NUM_PIX       : OUT std_logic_vector(16 DOWNTO 0);
  );
END LCD_DRAWING;

ARCHITECTURE arch1 OF LCD_CTRL IS
   TYPE ESTADO IS (Esp1,Esp2,Esp3,Esp4,Esp5,Esp6,Esp7,Inicio,Fin,Posicion_Borrar,Dibujar_Borrar,Posicion_D,Rojo,Verde,Azul,Dib_X,Avanza_X,Dib_Y,Avanza_Y,Reinic_Cont_Y);
   SIGNAL estado_q, estado_d: ESTADO;
   SIGNAL CONT_X  : unsigned (7 DOWNTO 0);
   SIGNAL CONT_A  : unsigned (1 DOWNTO 0);
   SIGNAL CONT_Y  : unsigned (9 DOWNTO 0);
   SIGNAL LD_CONT_X  : std_logic;
   SIGNAL LD_CONT_A  : std_logic;
   SIGNAL RES_CONT_A  : std_logic;
   SIGNAL LD_CONT_Y  : std_logic;
   SIGNAL REG_COLOR  : unsigned (1 DOWNTO 0);
   SIGNAL LD_REG_COLOR : std_logic;
   

BEGIN
   PROCESS (estado_q,DEL_SCREEN,DRAW_DIAG,DONE_CURSOR,DONE_COLOUR,COLOUR_CODE,CONT_Y,CONT_X)
   begin
	case estado_q is
	 when Inicio => if DEL_SCREEN='1' then estado_d<=Posicion_Borrar; elsif DRAW_DIAG='1' then estado_d<=Inicio; else estado_d<=Inicio; end if;
	 when Fin => estado_d<=Inicio;
	 when Esp1 => if DONE_CURSOR='1' and COLOUR_CODE='01' then estado_d<=Rojo; elsif DONE_CURSOR='1' and COLOUR_CODE='10' then estado_d<=Verde; elsif DONE_CURSOR='1' and COLOUR_CODE='11' then estado_d<=Azul; else estado_d<=Esp1; end if;
	 when Esp2 => if DONE_COLOUR='1' then estado_d<=Avanza_X; else estado_d<=Esp2; end if; 
	 when Esp3 => if DONE_CURSOR='1' then estado_d<=Dib_Y; else estado_d<=Esp3; end if; 
	 when Esp4 => if DONE_COLOUR='1' then estado_d<=Avanza_Y; else estado_d<=Esp4; end if; 
	 when Esp5 => if DONE_CURSOR='1' and CONT_A/='11' then estado_d<=Dib_Y; elsif DONE_CURSOR='1' and CONT_A='11' and CONT_X/='11110001' then estado_d<=Reinic_Cont_Y; elsif DONE_CURSOR='1' and CONT_A='11' and CONT_X='11110001' then estado_d<=Fin; else estado_d<=Esp5; end if;
	 when Esp6 => if DONE_CURSOR='1' then estado_d<=Dibujar_Borrar; else estado_d<=Esp6; end if; 
	 when Esp7 => if DONE_COLOUR='1' then estado_d<=Fin; else estado_d<=Esp7; end if; 
	 when Posicion_Borrar => if DONE_CURSOR='1' then estado_d<=Dibujar_Borrar; else estado_d<=Esp6; end if;
 	 when Dibujar_Borrar => if DONE_COLOUR='1' then estado_d<=Fin; else estado_d<=Esp7; end if;
	 when Posicion_D => if DONE_CURSOR='1' and COLOUR_CODE='01' then estado_d<=Rojo; elsif DONE_CURSOR='1' and COLOUR_CODE='10' then estado_d<=Verde; elsif DONE_CURSOR='1' and COLOUR_CODE='11' then estado_d<=Azul; else estado_d<=Esp1; end if;
	 when Rojo => estado_d<=Dib_x;
	 when Verde => estado_d<=Dib_x;
	 when Azul => estado_d<=Dib_x;
	 when Dib_X => if DONE_COLOUR='1' then estado_d<=Avanza_X; else estado_d<=Esp2; end if;
	 when Avanza_X => if DONE_CURSOR='1' then estado_d<=Dib_Y; else estado_d<=Esp3; end if;
	 when Dib_Y => if DONE_COLOUR='1' then estado_d<=Avanza_Y; else estado_d<=Esp4; end if;
	 when Avanza_Y=> if DONE_CURSOR='1' and CONT_A/='11' then estado_d<=Dib_Y; elsif DONE_CURSOR='1' and CONT_A='11' and CONT_X/='11110001' then estado_d<=Reinic_Cont_Y; elsif DONE_CURSOR='1' and CONT_A='11' and CONT_X='11110001' then estado_d<=Fin; else estado_d<=Esp5; end if;
	 when Reinic_Cont_Y => estado_d<=Dib_x;
	 when others => estado_d<=EsperaOP;
	end case;
   end process;

OP_SETCURSOR <='1' when (estado_q=Posicion_Borrar) or (estado_q=Posicion_D) or (estado_q=Avanza_X) or (estado_q=Avanza_Y) else '0';
OP_DRAWCOLOUR <='1' when (estado_q=Dibujar_Borrar) or (estado_q=Dib_X) or (estado_q=Dib_Y) else '0';
XCOL <= "00000000" when (estado_q=Posicion_Borrar) or (estado_q=Posicion_D) else CONT_X;
YCOL <= "000000000" when (estado_q=Posicion_Borrar) or (estado_q=Posicion_D) else CONT_Y;
LD_CONT_X <= '1' when (estado_q=Posicion_D) or (estadoq=Avanza_X) else '0';
LD_CONT_Y <= '1' when (estado_q=Posicion_D) or (estadoq=Avanza_Y) else '0';
LD_CONT_A <= '1' when (estado_q=Posicion_D) or (estadoq=Avanza_Y) else '0';
RES_CONT_A <= '1' when (estado_q=Reinic_Cont_Y) else '0';
LD_REG_COLOR <='1' when (estado_q=Rojo) or (estado_q=Verde) or (estado_q=Azul) or (estado_q=Dibujar_Borrar) else '0';
NUM_PIX <= "00000000000000001" when (estado_q=Dib_X) or (estado_q=Dib_Y) else "11111111111111111" when (estado_q=Dibujar_Borrar) else "00000000000000000";
--registro de estado
   PROCESS (clk,reset)
   begin
   	if reset='1' then
		estado_q<=Inicio;
  	 elsif (clk'event and clk='1') then
		estado_q<=estado_d;
   	end if;
   end process;
--contador X
   PROCESS (clk, reset)
   begin
	if reset = '1' then
		CONT_X<= (others => '0');
	elsif clk'event AND  clk='1' then
		if LD_CONT_X='1' then
			CONT_X <= CONT_X +1;
		end if;
	end if;
   end process;
--contador Y
   PROCESS (clk, reset)
   begin
	if reset = '1' then
		CONT_Y<= (others => '0');
	elsif clk'event AND  clk='1' then
		if LD_CONT_Y='1' then
			CONT_Y <= CONT_Y +1;
		end if;
	end if;
   end process;
--contador A
   PROCESS (clk, reset)
   begin
	if reset = '1' then
		CONT_A<= (others => '0');
	elsif clk'event AND  clk='1' then
		if LD_CONT_A='1' then
			CONT_A <= CONT_A +1;
		elsif RES_CONT_A='1' then
			CONT_A <= 0;
		end if;
	end if;
   end process;
--registro color
   PROCESS (clk, reset,COLOR)
   begin
	if reset='1' then
		REG_COLOR <= (others => '0');
	elsif LD_REG_COLOR='1' then
		REG_COLOR <= COLOR;
	end if;
   end process;




