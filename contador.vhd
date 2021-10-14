LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.all;
USE IEEE.NUMERIC_STD.all;
 
ENTITY counter8 IS
  PORT (
    clk       : IN std_logic; 
    reset     : IN std_logic; 
    LCD_init_done : IN std_logic;
    OP_SETCURSOR : IN std_logic;
    OP_DRAWCOLOR : IN std_logic;
    YROW      : IN std_logic_vector(8 DOWNTO 0);
    XCOL      : IN std_logic_vector(7 DOWNTO 0);
    LCD_WRN   : OUT std_logic;
    LCD_RS    : OUT std_logic;
    LCD_CSN   : OUT std_logic
  );
END counter8;
 
ARCHITECTURE arch1 OF counter8 IS
   TYPE ESTADO IS (Estado0,Estado1,Estado2, Estado3,Estado9,Estado10,Estado11,ProcesarC,EsperaOP,Inicio,ProcesarD);
   SIGNAL estado_q, estado_d: ESTADO;
   SIGNAL cnt : unsigned(2 DOWNTO 0);
   SIGNAL ENABLE_CONT_DATA: std_logic;
   SIGNAL x : std_logic_vector(7 DOWNTO 0);
   SIGNAL y :  std_logic_vector(8 DOWNTO 0);
   SIGNAL LD_X: std_logic;
   SIGNAL LD_Y: std_logic;
   SIGNAL LD_CONT_DATA: std_logic;
   SIGNAL LD_VALUE_CONT_DATA : unsigned(2 DOWNTO 0);
 	
   
BEGIN
   PROCESS (estado_q,cnt,OP_SETCURSOR, OP_DRAWCOLOR)
   begin
	case estado_q is
	 when Inicio => if LCD_init_done='1' then estado_d<=EsperaOP; else estado_d<=Inicio; end if; --al ponerlo a 1 en la sim no cambia de estado?
	 when EsperaOP => if OP_SETCURSOR='1' then estado_d<=ProcesarC; elsif OP_DRAWCOLOR='1' then estado_d<=ProcesarD; else estado_d<=EsperaOP; end if;
	 when ProcesarC => estado_d<=Estado0;
	 when ProcesarD => estado_d<=EsperaOP; --TODO
	 when Estado0 => estado_d<=Estado1;
	 when Estado1 => estado_d<=Estado2;
	 when Estado2 => estado_d<=Estado3;
	 when Estado3 => if cnt="000" or cnt = "011" then estado_d<=Estado9; elsif cnt = "001" or cnt="010" or cnt="100" or cnt="101" then estado_d <= Estado10;else estado_d<=Estado11; end if;
	 when Estado9 => estado_d<=Estado0;
	 when Estado10 => estado_d<=Estado0;
	 when Estado11 => estado_d<=EsperaOP;
	 when others => estado_d<=EsperaOP;
 	end case;
   end process; 

LCD_WRN <='1' when (estado_q=Estado1) or (estado_q=Estado2) or (estado_q=Estado3) else '0';
LCD_CSN <='1' when (estado_q=Estado1) or (estado_q=Estado2) or (estado_q=Estado3) else '0';
LCD_RS  <='1' when (estado_q=Estado10) else '0';
ENABLE_CONT_DATA <='1' when (estado_q=Estado3) else '0';
LD_X <='1' when (estado_q=ProcesarC) else '0';
LD_Y <='1' when (estado_q=ProcesarC) else '0';
LD_VALUE_CONT_DATA <= "000" when (estado_q=ProcesarC) else "110" when (estado_q=ProcesarD) else "000";
LD_CONT_DATA <= '1' when (estado_q=ProcesarC) or (estado_q=ProcesarD) else '0';
--registro de estado
   PROCESS (clk,reset)
   begin
   	if reset='1' then
		estado_q<=Inicio;
  	 elsif (clk'event and clk='1') then
		estado_q<=estado_d;
   	end if;
   end process;
--registro X e Y
   PROCESS (clk, reset,XCOL)
   begin
	if reset='1' then
		x <= (others => '0');
	elsif LD_X='1' then
		x <= XCOL;
	end if;
   end process;
   PROCESS (clk, reset, YROW)
   begin
	if reset='1' then
		y <= (others => '0');
	elsif LD_Y='1' then
		y <= YROW;
	end if;
   end process;
--contadorCiclos                                                                   
   PROCESS (clk, reset)
   BEGIN
     IF reset = '1' THEN
       cnt <= (others => '0');
     ELSIF clk'event AND clk='1' THEN
       IF ENABLE_CONT_DATA='1' THEN
         cnt <= cnt + 1;
       ELSIF LD_CONT_DATA='1' THEN
	 cnt <= LD_VALUE_CONT_DATA;
       END IF;
     END IF;
   END PROCESS;
END arch1;
