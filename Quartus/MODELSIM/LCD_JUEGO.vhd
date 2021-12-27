LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.all;
USE IEEE.NUMERIC_STD.all;

ENTITY LCD_BASICA IS
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
END LCD_BASICA;

ARCHITECTURE arch1 OF LCD_BASICA IS
	TYPE ESTADO IS (Inicio,Inicializar,Posicionar,Final,Dibujar,DoneDrawing,EsperaCom,CargarComando,XIzF,XIzN,XDrF,XDrN,YAbF,YAbN,YArF,YArN,Esp1,EspBorrar,EspCursor,EspColor,PosY,ContPix,ResYPix);
   SIGNAL estado_q, estado_d: ESTADO;
--Registro de X
   SIGNAL pos_x    : unsigned(7 DOWNTO 0);
   SIGNAL IZ_POSX  : std_logic;
   SIGNAL DR_POSX  : std_logic;
   SIGNAL RES_X    : std_logic;
   SIGNAL FIN_X    : std_logic;
   SIGNAL LD_POSXM : std_logic; 
--Registro de Y
   SIGNAL pos_y    : unsigned(8 DOWNTO 0);
   SIGNAL AR_POSY  : std_logic;
   SIGNAL AB_POSY  : std_logic;
   SIGNAL RES_Y    : std_logic;
   SIGNAL FIN_Y    : std_logic;
   SIGNAL LD_POSYM : std_logic;
   SIGNAL Y_CINCO  : std_logic; 
--Registro de Color
   SIGNAL color     : std_logic_vector(1 DOWNTO 0);
   SIGNAL LD_COLOR  : std_logic;
--Contador de Pixeles
   SIGNAL cont_pix     : unsigned(2 DOWNTO 0);
   SIGNAL EN_CONT_PIX  : std_logic;
   SIGNAL RES_CONT_PIX : std_logic;
   

BEGIN
   PROCESS (estado_q, estado_d, FUN_JUEGO, DONE_DEL, DONE_CURSOR, DONE_COLOR, MOVE, FIN, DIRECCION)
   begin
  case estado_q is
   when Inicio => if FUN_JUEGO='1' then 
                      estado_d<=Inicializar; 
                  else 
                      estado_d<=Inicio;
                  end if;
   when Inicializar => estado_d<=EspBorrar;
	when EspBorrar   => if DONE_DEL='1' then
									estado_d<=Posicionar;
							  else
							      estado_d<=EspBorrar;
							  end if;
   when Posicionar  => estado_d<=EspCursor;
	when EspCursor   => if DONE_CURSOR='1' then
									estado_d<=Dibujar;
							  else
							      estado_d<=EspCursor;
							  end if;
   when Dibujar     => estado_d<=EspColor;
   
   when EspColor   => if DONE_COLOR='1' and CONT_PIX="101" then
		          estado_d<=ResYPix;
		      elsif DONE_COLOR='0' then
		          estado_d<=EspColor;
 		      else
			  estado_d<=PosY;
		      end if;
   when PosY     => estado_d<=ContPix;
   when ContPix  => estado_d<=Posicionar;
   when ResYPix  => estado_d<=DoneDrawing;
   when DoneDrawing => estado_d<=EsperaCom;
   when EsperaCom   => if MOVE='1' then 
                           estado_d<=CargarComando; 
                       elsif FIN='1' then
                           estado_d<=Final;
                       else
                           estado_d<=EsperaCom;
                       end if;
   when Final       => estado_d<=Inicio; 
   when CargarComando => if DIRECCION="00" and POS_X="00000000" then
                             estado_d<=XIzF;
                         elsif DIRECCION="00" then
                             estado_d<=XIzN;
                         elsif DIRECCION="01" and POS_X="11101011" then
                             estado_d<=XDrF;
                         elsif DIRECCION="01" then
                             estado_d<=XDrN;
                         elsif DIRECCION="10" and POS_Y="000000000" then
                             estado_d<=YAbF;
                         elsif DIRECCION="10" then
                             estado_d<=YAbN;
                         elsif DIRECCION="11" and POS_Y="100111011" then
                             estado_d<=YArF;
                         elsif DIRECCION="11" then
                             estado_d<=YArN;
                         end if;
   when XIzF=> estado_d<=Esp1;
   when XIzN=> estado_d<=Esp1;
   when XDrF=> estado_d<=Esp1;
   when XDrN=> estado_d<=Esp1;
   when YAbF=> estado_d<=Esp1;
   when YAbN=> estado_d<=Esp1;
   when YArF=> estado_d<=Esp1;
   when YArN=> estado_d<=Esp1;
   when Esp1=> estado_d<=Posicionar;
   when others => estado_d<=Inicio;
  end case;
  end process; 
--Señal de Borrar Pantalla
DEL_SCREEN   <= '1' when (estado_q=Inicializar) else '0';
--Señal de Posicionar Cursor
OP_SETCURSOR <= '1' when (estado_q=Posicionar) else '0';
--Señal de Dibujar 
OP_DRAWCOLOUR<= '1' when (estado_q=Dibujar) else '0';
--Señal de Confirmar dibujar
DONE_DRAWING <= '1' when (estado_q=DoneDrawing or estado_q=Final) else '0';
--Cargar Posicion X
IZ_POSX  <= '1' when (estado_q=XIzN) else '0';
DR_POSX  <= '1' when (estado_q=XDrN) else '0';
RES_X    <= '1' when (estado_q=XDrF) else '0';
FIN_X    <= '1' when (estado_q=XIzF) else '0';
LD_POSXM <= '1' when (estado_q=Inicializar) else '0';
XCOL     <= std_logic_vector(pos_x);
--Cargar Posicion Y 
AR_POSY  <= '1' when (estado_q=YArN) else '0';
AB_POSY  <= '1' when (estado_q=YAbN or estado_q=PosY) else '0';
RES_Y    <= '1' when (estado_q=YarF) else '0';
FIN_Y    <= '1' when (estado_q=YAbF) else '0';
LD_POSYM <= '1' when (estado_q=Inicializar) else '0';
YROW     <= std_logic_vector(pos_y);
Y_CINCO  <= '1' when (estado_q=ResYPix) else '0';
--Cargar Color
LD_COLOR <= '1' when (estado_q=Posicionar) else '0';
RGB <= "0000000000000000" when (color="00") 
	else "1111100000000000" when (color="01") 
	else "0000011111100000" when (color="10") 
	else "0000000000011111" when (color="11") 
	else "0000000000000000";
--Numero de Pixeles siempre es 5
NUM_PIX <= "00000000000000101";
--Contador de Pixeles
EN_CONT_PIX  <= '1' when (estado_q=PosY) else '0';
RES_CONT_PIX <= '1' when (estado_q=ResYPix) else '0';


--registro de estados
      process(clk, reset_l)
      begin
        if reset_l='0' then
          estado_q<= Inicio;
        elsif (clk'event and clk='1') then
          estado_q<=estado_d;
        end if;
      end process;

--Contador de X
      process(clk, reset_l,IZ_POSX,DR_POSX,RES_X,FIN_X,LD_POSXM)
      begin
        if reset_l='0' then
          pos_x <= "00000000";
        elsif (clk'event and clk='1') then
          if IZ_POSX='1' then
            pos_x <= pos_x - 1;
          elsif DR_POSX='1' then
            pos_x <= pos_x + 1;
          elsif RES_X='1' then
            pos_x <= "00000000";
          elsif FIN_X='1' then
            pos_x <= "11101111";
          elsif LD_POSXM='1' then
            pos_x <= "01111011";
 	  end if;
        end if;
	end process;
--Contador de Y
      process(clk, reset_l,AR_POSY,AB_POSY,RES_Y,FIN_Y,LD_POSYM,Y_CINCO)
      begin
        if reset_l='0' then
          pos_y <= "000000000";
        elsif (clk'event and clk='1') then
          if AR_POSY='1' then
            pos_y <= pos_y - 1;
          elsif AB_POSY='1' then
            pos_y <= pos_y + 1;
          elsif RES_Y='1' then
            pos_y <= "000000000";
          elsif FIN_Y='1' then
            pos_y <= "100111111";
          elsif LD_POSYM='1' then
            pos_y <= "010100000";
          elsif Y_CINCO='1' then
            pos_y <= pos_y - 5;
 	  end if;
        end if;
	end process;
--registro de color
      process(clk, reset_l,LD_COLOR,COLOR_CODE)
      begin
        if reset_l='0' then
          color<= (others => '0');
        elsif (clk'event and clk='1') then
         if LD_COLOR='1' then
            color <= COLOR_CODE;
         end if;
        end if;
      end process;
--Contador de Pixeles
      process(clk, reset_l,EN_CONT_PIX,RES_CONT_PIX)
      begin
        if reset_l='0' then
          cont_pix<= (others => '0');
        elsif (clk'event and clk='1') then
         if EN_CONT_PIX='1' then
            cont_pix <= cont_pix + 1;
         elsif RES_CONT_PIX='1' then
            cont_pix <= "000";
         end if;
        end if;
      end process;

END arch1;