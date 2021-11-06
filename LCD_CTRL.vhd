LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.all;
USE IEEE.NUMERIC_STD.all;
 
ENTITY LCD_CTRL IS
  PORT (
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
END LCD_CTRL;
 
ARCHITECTURE arch1 OF LCD_CTRL IS
   TYPE ESTADO IS (CicloC1,CicloC2,CicloC3,CicloD1,CicloD2,CicloD3,MandarComDraw,MandarPix,MandarComando,MandarDato,FinCursor,FinColor,ProcesarC,EsperaOP,Inicio,ProcesarD);
   SIGNAL estado_q, estado_d: ESTADO;
   SIGNAL sel_data : unsigned(2 DOWNTO 0);
   SIGNAL ENABLE_CONT_DATA: std_logic;
   SIGNAL x : std_logic_vector(7 DOWNTO 0);
   SIGNAL y :  std_logic_vector(8 DOWNTO 0);
   SIGNAL LD_X: std_logic;
   SIGNAL LD_Y: std_logic;
   SIGNAL LD_CONT_DATA: std_logic;
   SIGNAL LD_VALUE_CONT_DATA : unsigned(2 DOWNTO 0);
   SIGNAL cntrgb : unsigned (16 downto 0);
   SIGNAL EN_CONT_PIX : std_logic;
   SIGNAL LD_CONT_PIX : std_logic;
   SIGNAL FIN_CNT_PIX : std_logic;
   SIGNAL LD_RGB: std_logic;
   SIGNAL LD_NUMPIX: std_logic;
   SIGNAL rgbreg: std_logic_vector(15 downto 0);
   SIGNAL num_pix: unsigned(16 downto 0);
   SIGNAL rsreg: std_logic;
   SIGNAL SET_RS: std_logic;
   SIGNAL RESET_RS: std_logic;
   
BEGIN
   PROCESS (estado_q,sel_data,OP_SETCURSOR, OP_DRAWCOLOUR, FIN_CNT_PIX,LCD_init_done)
   begin
  case estado_q is
   when Inicio => if LCD_init_done='1' then 
                      estado_d<=EsperaOP; 
                    else 
                      estado_d<=Inicio;Ç
                    end if;
   when EsperaOP => if OP_SETCURSOR='1' then e
                      stado_d<=ProcesarC; 
                    elsif OP_DRAWCOLOUR='1' then 
                      estado_d<=ProcesarD; 
                    else 
                      estado_d<=EsperaOP; 
                    end if;
   when ProcesarC => estado_d<=CicloC1;
   when ProcesarD => estado_d<=CicloD1;
   when CicloC1 => estado_d<=CicloC2; 
   when CicloC2 => estado_d<=CicloC3;
   when CicloC3 => if sel_data="000" or sel_data = "011" then 
                      estado_d<=MandarComando; 
                    elsif sel_data = "001" or sel_data="010" or sel_data="100" then 
                      estado_d <= MandarDato;
                    else 
                      estado_d<=FinCursor; 
                    end if;
   when CicloD1 => estado_d<=CicloD2;
   when CicloD2 => estado_d<=CicloD3;
   when CicloD3 => if sel_data="111" then 
                      estado_d<=MandarPix; 
                    else 
                      estado_d<=MandarComDraw; 
                    end if;
   when MandarComDraw => estado_d<=CicloD1;
   when MandarPix => if FIN_CNT_PIX='1' then 
                        estado_d<=FinColor; 
                      else 
                        estado_d<=CicloD1; 
                      end if;
   when MandarComando => estado_d<=CicloC1;
   when MandarDato => estado_d<=CicloC1;
   when FinCursor => estado_d<=EsperaOP;
   when FinColor => estado_d<=EsperaOP;
   when others => estado_d<=EsperaOP;
  end case;
   end process; 

LCD_WR_N <='0' when (estado_q=CicloC1) or (estado_q=CicloD1) else '1';
LCD_CS_N <='0' when (estado_q=CicloC1) or (estado_q=CicloD1) else '1';
LCD_RS  <=rsreg;
SET_RS <= '1' when (estado_q=MandarComando) or (estado_q=MandarComDraw) else '0';
RESET_RS <= '1' when (estado_q=ProcesarC) or (sel_data="010" and estado_q=MandarDato) or (sel_data="101" and estado_q=MandarDato) or (estado_q=ProcesarD) else '0';
ENABLE_CONT_DATA <='1' when (estado_q=MandarComando) or (estado_q=MandarDato) or (estado_q=MandarComDraw) else '0';
LD_X <='1' when (estado_q=ProcesarC) else '0';
LD_Y <='1' when (estado_q=ProcesarC) else '0';
LD_VALUE_CONT_DATA <= "000" when (estado_q=ProcesarC) 
                      else "110" when (estado_q=ProcesarD) 
                      else "000";
LD_CONT_DATA <= '1' when (estado_q=ProcesarC) or (estado_q=ProcesarD) else '0';
LD_CONT_PIX <= '1' when (estado_q=ProcesarD) else '0';
EN_CONT_PIX <='1' when (estado_q=MandarPix) else '0';
FIN_CNT_PIX <='1' when (cntrgb="00000000000000000") else '0';
DONE_SETCURSOR <='1' when (estado_q=FinCursor) else '0';
DONE_DRAWCOLOR <='1' when (estado_q=FinColor) else '0';
LD_RGB <= '1' when (estado_q=ProcesarD) else '0';
LD_NUMPIX <='1' when (estado_q=ProcesarD) else '0';
--multiplexor de datos
LCD_DATA<="0000000000101010" when (sel_data="000") 
          else "0000000000000000" when (sel_data="001") 
          else  std_logic_vector(resize(signed(XCOL), LCD_DATA'length)) when (sel_data="010") 
          else "0000000000101011" when (sel_data="011") 
          else std_logic_vector(resize(signed(YROW(8 downto 8)), LCD_DATA'length)) when (sel_data="100")  
          else std_logic_vector(resize(signed(YROW(7 downto 0)), LCD_DATA'length)) when (sel_data="101") 
          else "0000000000101100" when (sel_data="110") 
          else rgbreg;
--registro de estado
   PROCESS (clk,reset_l)
   begin
    if reset_l='0' then
    estado_q<=Inicio;
     elsif (clk'event and clk='1') then
    estado_q<=estado_d;
    end if;
   end process;
--registro X e Y
   PROCESS (clk, reset_l,XCOL)
   begin
  if reset_l='0' then
    x <= (others => '0');
  elsif LD_X='1' then
    x <= XCOL;
  end if;
   end process;
   PROCESS (clk, reset_l, YROW)
   begin
  if reset_l='0' then
    y <= (others => '0');
  elsif LD_Y='1' then
    y <= YROW;
  end if;
   end process;
--contadorCiclos                                                                   
   PROCESS (clk, reset_l)
   BEGIN
     IF reset_l = '0' THEN
       sel_data <= (others => '0');
     ELSIF clk'event AND clk='1' THEN
       IF ENABLE_CONT_DATA='1' THEN
         sel_data <= sel_data + 1;
       ELSIF LD_CONT_DATA='1' THEN
   sel_data <= LD_VALUE_CONT_DATA;
       END IF;
     END IF;
   END PROCESS;
--registros RGB y NUMPIX 
 PROCESS (clk, reset_l,RGB)
   begin
  if reset_l='0' then
    rgbreg <= (others => '0');
  elsif LD_RGB='1' then
    rgbreg <= RGB;
  end if;
   end process;
   PROCESS (clk, reset_l, NUMPIX)
   begin
  if reset_l='0' then
    num_pix <= (others => '0');
  elsif LD_NUMPIX='1' then
    num_pix <= NUMPIX;
  end if;
   end process;
--contadorPixeles
   process (clk, reset_l)
   begin
  if reset_l = '0' then
    cntrgb <= (others => '0');
  elsif clk'event AND  clk='1' then
    if EN_CONT_PIX='1' then
      cntrgb <= cntrgb -1;
    elsif LD_CONT_PIX='1' then
      cntrgb <= num_pix;
    end if;
  end if;
   end process;
--regRs
  PROCESS (clk, reset_l)
    begin
    if reset_l='0' then
      rsreg <= '1';
    elsif clk'event AND clk='1' then
      if SET_RS='1' then
        rsreg <='1';
      elsif RESET_RS='1' then
        rsreg <='0';
      end if;
    end if;
  end process;
END arch1;
