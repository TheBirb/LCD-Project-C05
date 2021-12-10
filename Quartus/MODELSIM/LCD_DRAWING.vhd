LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.all;
USE IEEE.NUMERIC_STD.all;

ENTITY LCD_DRAWING IS
  PORT (
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
    NUMPIX        : OUT std_logic_vector(16 DOWNTO 0);
    DONE_DRAWING  : OUT std_logic
  );
END LCD_DRAWING;

ARCHITECTURE arch1 OF LCD_DRAWING IS
   TYPE ESTADO IS (Esp1,Esp2,Esp3,Esp4,Esp5,Esp6,Inicio,Fin,Posicion_Borrar,Dibujar_Borrar,Posicion_D,Rojo,Verde,Azul,Dib_D,Avanza_D,Res_X);
   SIGNAL estado_q, estado_d: ESTADO;
   SIGNAL cont_x  : unsigned (7 DOWNTO 0);
   SIGNAL cont_y  : unsigned (8 DOWNTO 0);
   SIGNAL EN_CONT_X  : std_logic;
   SIGNAL EN_CONT_Y  : std_logic;
   SIGNAL RES_CONT_X  : std_logic;
   SIGNAL RES_CONT_Y  : std_logic;
   SIGNAL color   : unsigned (1 DOWNTO 0);
   SIGNAL num_pix : unsigned (16 DOWNTO 0);
   SIGNAL LD_REG_COLOR : std_logic;
   SIGNAL LD_NUMPIX_5 : std_logic; 
   SIGNAL LD_NUMPIX_A : std_logic; 
   SIGNAL RS_NUMPIX   : std_logic; 
   SIGNAL LD_COLOR_N  : std_logic;

BEGIN
   PROCESS (estado_q,DEL_SCREEN,DRAW_DIAG,DONE_SETCURSOR,DONE_DRAWCOLOR,COLOUR,CONT_Y,CONT_X)
   begin
	case estado_q is
	 when Inicio => if DEL_SCREEN='1' then 
				estado_d<=Posicion_Borrar; 
			elsif DRAW_DIAG='1' then 
				estado_d<=Posicion_D; 
			else 
				estado_d<=Inicio; 
			end if;
	 when Fin => estado_d<=Inicio;
	 when Esp1 => if DONE_SETCURSOR='1' and COLOUR="01" then 
			estado_d<=Rojo; 
		      elsif DONE_SETCURSOR='1' and COLOUR="10" then 
			estado_d<=Verde; 
		      elsif DONE_SETCURSOR='1' and COLOUR="11" then 
			estado_d<=Azul; 
		      elsif DONE_SETCURSOR='1' and COLOUR="00" then 
		        estado_d<=Fin; 
		      else 
			estado_d<=Esp1; 
		      end if;
	 when Esp2 => if DONE_DRAWCOLOR='1' then 
			estado_d<=Avanza_D; 
		      else 
			estado_d<=Esp2; 
		      end if; 
	 when Esp3 => if DONE_SETCURSOR='1' and cont_y/="101000000" and cont_x/="11110000" then 
			estado_d<=Dib_D; 
		      elsif DONE_SETCURSOR='1' and cont_y/="101000000" and cont_x="11110000" then 
			estado_d<=Res_X; 
		      elsif DONE_SETCURSOR='1' and cont_y="101000000" then 
			estado_d<=Fin; 
		      else 
			estado_d<=Esp3; 
		      end if; 
	 when Esp4 => if DONE_SETCURSOR='1' then 
			estado_d<=Dibujar_Borrar; 
		      else 
			estado_d<=Esp4; 
		      end if; 
	 when Esp5 => if DONE_DRAWCOLOR='1' then 
			estado_d<=Fin;
		      else 
			estado_d<=Esp5; 
		      end if;
	 when Esp6 => if DONE_SETCURSOR='1' then 
			estado_d<=Dib_D; 
		      else 
			estado_d<=Esp6; 
		      end if;
	 when Posicion_Borrar => estado_d<=Esp4; 

 	 when Dibujar_Borrar => estado_d<=Esp5; 

	 when Posicion_D => estado_d<=Esp1; 

	 when Rojo => estado_d<=Dib_D;

	 when Verde => estado_d<=Dib_D;

	 when Azul => estado_d<=Dib_D;

	 when Dib_D => estado_d<=Esp2; 

	 when Avanza_D => estado_d<=Esp3; 

	 when Res_X => estado_d<=Esp6; 

	 when others => estado_d<=Inicio;
	end case;
   end process;

OP_SETCURSOR <='1' when (estado_q=Posicion_Borrar) or (estado_q=Posicion_D) or (estado_q=Avanza_D) or (estado_q=Res_X) else '0';
OP_DRAWCOLOUR <='1' when (estado_q=Dibujar_Borrar) or (estado_q=Dib_D) else '0';
XCOL <= std_logic_vector(cont_x);
YROW <= std_logic_vector(cont_y);
EN_CONT_X <= '1' when (estado_q=Avanza_D) else '0';
EN_CONT_Y <= '1' when (estado_q=Avanza_D) else '0';
RES_CONT_X <= '1' when (estado_q=Dibujar_Borrar) or (estado_q=Posicion_D) or (estado_q=Res_X) else '0';
RES_CONT_Y <= '1' when (estado_q=Dibujar_Borrar) or (estado_q=Posicion_D) else '0';
LD_REG_COLOR <='1' when (estado_q=Rojo) or (estado_q=Verde) or (estado_q=Azul) else '0';
LD_COLOR_N <='1' when (estado_q=Posicion_Borrar) else '0';
NUMPIX <= std_logic_vector(num_pix);
RGB <= "0000000000000000" when (color="00") 
	else "1111100000000000" when (color="01") 
	else "0000011111100000" when (color="10") 
	else "0000000000011111" when (color="11") 
	else "0000000000000000";
LD_NUMPIX_5 <= '1' when (estado_q=Posicion_D) else '0';
LD_NUMPIX_A <= '1' when (estado_q=Posicion_Borrar) else '0';
RS_NUMPIX <= '1' when (estado_q=Fin) else '0';
DONE_DRAWING <= '1' when (estado_q=Fin) else '0';

--registro de estado
   PROCESS (clk,reset_l)
   begin
   	if reset_l='0' then
		estado_q<=Inicio;
  	 elsif (clk'event and clk='1') then
		estado_q<=estado_d;
   	end if;
   end process;
--registro color
   PROCESS (clk, reset_l,COLOUR)
   begin
	if reset_l='0' then
		color <= (others => '0');
	elsif LD_REG_COLOR='1' then
		color <= unsigned(COLOUR);
        elsif LD_COLOR_N='1' then
		color<="00";
	end if;
   end process;
--registro numpix
   PROCESS (clk, reset_l)
   begin
	if reset_l='0' then
		num_pix <= (others => '0');
	elsif LD_NUMPIX_5='1' then
		num_pix <= "00000000000000101";	
	elsif LD_NUMPIX_A='1' then
		num_pix <= "10010110000000000";
	elsif RS_NUMPIX='1' then
		num_pix <= "00000000000000000";
	end if;
   end process;
--contador X
   PROCESS (clk, reset_l)
   begin
	if reset_l = '0' then
		cont_x<= (others => '0');
	elsif clk'event AND  clk='1' then
		if EN_CONT_X='1' then
			cont_x <= cont_x +1;
		elsif RES_CONT_X='1' then
			cont_x <= "00000000";
		end if;
	end if;
   end process;
--contador Y
   PROCESS (clk, reset_l)
   begin
	if reset_l = '0' then
		cont_y<= (others => '0');
	elsif clk'event AND  clk='1' then
		if EN_CONT_Y='1' then
			cont_y <= cont_y +1;
		elsif RES_CONT_Y='1' then
			cont_y <= "000000000";
		end if;
	end if;
   end process;

END arch1;
