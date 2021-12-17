LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.all;
USE IEEE.NUMERIC_STD.all;

ENTITY LCD_UART IS
  PORT (
    clk          : IN   std_logic;
    RxD 	 : IN   std_logic;
    reset_l      : IN   std_logic;
    DONE_DRAWING : IN   std_logic;
    DEL_SCREEN   : OUT  std_logic;
    DRAW_DIAG    : OUT  std_logic;
    FUN_BASICA   : OUT  std_logic;
    MOVE         : OUT  std_logic;
    FIN_FUN      : OUT  std_logic;
    POSICION     : OUT  std_logic_vector(1 DOWNTO 0) 
  );
END LCD_UART;

ARCHITECTURE arch1 of LCD_UART is
	TYPE ESTADO IS (Inicio,EsperaComando,RecibirDat,ProcesarDato,EnviarBorrado,EnviarDiagonal,EnviarBasica,Arriba,Izquierda,Abajo,Derecha,Mover,FinFuncion,Fin,Fin_NC,ResetDeDatos,TiempoRxD,TiempoDat);
  SIGNAL estado_q,estado_d : ESTADO;
--CONTADOR DE DATOS UART
	SIGNAL FIN_CONT : std_logic;
	SIGNAL RESET_CONT : std_logic;
	SIGNAL EN_CONT : std_logic;
	SIGNAL contd : unsigned(3 downto 0);
--CONTADOR DE DATOS UART
	SIGNAL FIN_TIME : std_logic;
	SIGNAL FIN_CICLO : std_logic;
	SIGNAL RESET_CONT_TIME : std_logic;
	SIGNAL EN_CONT_TIME : std_logic;
	SIGNAL contime : unsigned(12 downto 0);
--SEÃƒÂ‘ALES DE COMPARADORES
	SIGNAL Rxd_in : std_logic;
	SIGNAL COMPE : std_logic;
	SIGNAL COMPQ : std_logic;
	SIGNAL COMPB : std_logic;
	SIGNAL COMPW : std_logic;
	SIGNAL COMPA : std_logic;
	SIGNAL COMPS : std_logic;
	SIGNAL COMPD : std_logic;
	SIGNAL COMPF : std_logic;
--REGISTRO DE DESPLAZAMIENTO
	SIGNAL EN_DESPLZ_DER : std_logic;
	SIGNAL REGDPLZ_out : std_logic_vector(7 downto 0);
        SIGNAL content     : std_logic_vector(7 downto 0);
--REGISTRO DE DIRECCION
	SIGNAL LD_POS_W   : std_logic;
	SIGNAL LD_POS_A   : std_logic;
	SIGNAL LD_POS_S   : std_logic;
	SIGNAL LD_POS_D   : std_logic;
	SIGNAL direccion  : std_logic_vector(1 downto 0);

BEGIN
  process (estado_q, estado_d,Rxd_in,FIN_CONT,COMPE,COMPQ,COMPB,COMPW,COMPA,COMPS,COMPD,COMPF,DONE_DRAWING,FIN_TIME,FIN_CICLO)
  begin
    case estado_q is
      when Inicio => estado_d<=EsperaComando;
    	when EsperaComando => if Rxd_in='1' then
        			estado_d<=TiempoRxD;
    			else
                              	estado_d<=EsperaComando;
    			end if;
      when RecibirDat => estado_d<=TiempoDat;
      when ProcesarDato => if COMPE='1' then
										estado_d<=EnviarBorrado;
                          elsif COMPQ='1' then
                            	estado_d<=EnviarDiagonal;
                          elsif COMPB='1' then
                            	estado_d<=EnviarBasica;
                          elsif COMPW='1' then
                            	estado_d<=Arriba;
                          elsif COMPA='1' then
                            	estado_d<=Izquierda;
                          elsif COMPS='1' then
                            	estado_d<=Abajo;
                          elsif COMPD='1' then
                            	estado_d<=Derecha;
                          elsif COMPF='1' then
                            	estado_d<=FinFuncion;
                          else
                            	estado_d<=FIN_NC;
                          end if;
      when EnviarBorrado =>estado_d<=ResetDeDatos;
      when EnviarDiagonal =>estado_d<=ResetDeDatos;
      when EnviarBasica   =>estado_d<=ResetDeDatos;
      when Arriba =>estado_d<=Mover;
      when Izquierda =>estado_d<=Mover;
      when Abajo =>estado_d<=Mover;
      when Derecha =>estado_d<=Mover;
      when Mover =>estado_d<=ResetDeDatos;
      when FinFuncion =>estado_d<=FIN_NC;
      when ResetDeDatos => estado_d<=Fin;
      when TiempoRxD => if FIN_TIME='1' then
				estado_d<=RecibirDat;
			else
				estado_d<=TiempoRxD;
			end if;
      when TiempoDat => if FIN_CICLO='1' and FIN_CONT='1' then
				estado_d<=ProcesarDato;
			elsif FIN_CICLO='1' and FIN_CONT='0' then
				estado_d<=RecibirDat;
			else
				estado_d<=TiempoDat;
			end if;
      when Fin=> if DONE_DRAWING='1' then
        		estado_d<=EsperaComando;
    		 else
                  	estado_d<=Fin;
                 end if;
	  when FIN_NC => estado_d<=EsperaComando;
      when others => estado_d<=EsperaComando;
    end case;
 	end process;
  
      
--comparador de entrada Rx_in
  Rxd_in <= '1' when RxD='0' else '0';
--comparador de comando DEL_SCREEN
  COMPE <= '1' when content="01100101" else '0';
--comparador de comando DRAW_DIAG
  COMPQ <= '1' when content="01110001" else '0';
--comparador de comando DEL_SCREEN
  COMPB <= '1' when content="01100010" else '0';
--comparador de comando DRAW_DIAG
  COMPW <= '1' when content="01110111" else '0';
--comparador de comando DEL_SCREEN
  COMPA <= '1' when content="01100001" else '0';
--comparador de comando DRAW_DIAG
  COMPS <= '1' when content="01110011" else '0';
--comparador de comando DEL_SCREEN
  COMPD <= '1' when content="01100100" else '0';
--comparador de comando DRAW_DIAG
  COMPF <= '1' when content="01100110" else '0';
--seÃƒÂ±al de final del contador
  FIN_CONT <= '1' when contd="1000" else '0';
--seÃƒÂ±al de borrado de pantalla
  DEL_SCREEN <= '1' when (estado_q=EnviarBorrado) else '0';
--seÃƒÂ±al de dibujado de diagonal
  DRAW_DIAG <= '1' when (estado_q=EnviarDiagonal) else '0'; 
--seÃƒÂ±al de dibujado de diagonal
  FUN_BASICA <= '1' when (estado_q=EnviarBasica) else '0'; 
--seÃƒÂ±al de dibujado de diagonal
  MOVE <= '1' when (estado_q=Mover) else '0'; 
--seÃƒÂ±al de dibujado de diagonal
  FIN_FUN <= '1' when (estado_q=FinFuncion) else '0'; 
--seÃƒÂ±al de salida del registro desplazador      
  REGDPLZ_out <= content;
  EN_DESPLZ_DER <= '1' when (estado_q=RecibirDat) else '0';
--SeÃƒÂ±ales del contador de datos
  RESET_CONT <= '1' when (estado_q=ResetDeDatos or estado_q=FIN_NC) else '0';
  EN_CONT <= '1' when (estado_q=RecibirDat) else '0';
--SeÃ±ales de contador de tiempo
  RESET_CONT_TIME <= '1' when (estado_q=RecibirDat or estado_q=ResetDeDatos or estado_q=FIN_NC) else '0';
  EN_CONT_TIME <= '1' when (estado_q=TiempoRxD or estado_q=TiempoDat) else '0';
  FIN_CICLO <= '1' when (contime="1010001011001") else '0';
  FIN_TIME <= '1' when (contime="1111010100011") else '0';
--Señales de Registro Direccion
  LD_POS_W <= '1' when (estado_q=Arriba) else '0';
  LD_POS_A <= '1' when (estado_q=Izquierda) else '0';
  LD_POS_S <= '1' when (estado_q=Abajo) else '0';
  LD_POS_D <= '1' when (estado_q=Derecha) else '0';
  POSICION <= std_logic_vector(direccion);
--registro de estados
      process(clk, reset_l)
      begin
        if reset_l='0' then
          estado_q<= Inicio;
        elsif (clk'event and clk='1') then
          estado_q<=estado_d;
        end if;
      end process;
--Contador de datos UART
      process(clk, reset_l,EN_CONT, RESET_CONT)
      begin
        if reset_l='0' then
          contd <= (others => '0');
        elsif (clk'event and clk='1') then
          if EN_CONT='1' then
            contd <= contd + 1;
          elsif RESET_CONT='1' then
            contd <= (others => '0');
 	  end if;
        end if;
	end process;
--regsitro de REGDPLZ (Registro de desplazamiento derecha)
      process(clk, reset_l,EN_DESPLZ_DER)
      begin
        if reset_l='0' then
          content <="00000000";
        elsif (clk'event and clk='1') then
          if (EN_DESPLZ_DER='1') then
            content <= RxD & content(7 downto 1);
          end if;
        end if;
      end process;
--Contador de datos UART
      process(clk, reset_l,EN_CONT_TIME, RESET_CONT_TIME)
      begin
        if reset_l='0' then
          contime <= (others => '0');
        elsif (clk'event and clk='1') then
          if EN_CONT_TIME='1' then
            contime <= contime + 1;
          elsif RESET_CONT_TIME='1' then
            contime <= (others => '0');
 	  end if;
        end if;
	end process;
--regsitro de POSICION (Registro de desplazamiento derecha)
      process(clk, reset_l,LD_POS_A,LD_POS_W,LD_POS_S,LD_POS_D)
      begin
        if reset_l='0' then
          direccion<="00";
        elsif (clk'event and clk='1') then
          if LD_POS_W='1' then
            direccion <= "11";
          elsif LD_POS_A='1' then
            direccion <= "00";
          elsif LD_POS_S='1' then
            direccion <= "10";
          elsif LD_POS_D='1' then
            direccion <= "01";
          end if;
        end if;
      end process;
end arch1;
