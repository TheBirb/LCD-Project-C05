LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.all;
USE IEEE.NUMERIC_STD.all;

ENTITY LCD_UART IS
  PORT (
    clk          : IN  std_logic;
    RxD 	 : IN  std_logic;
    reset_l: IN  std_logic;
    DONE_DRAWING : IN  std_logic;
    DEL_SCREEN : OUT  std_logic;
    DRAW_DIAG : OUT  std_logic
  );
END LCD_UART;

ARCHITECTURE arch1 of LCD_UART is
	TYPE ESTADO IS (Inicio,EsperaComando,RecibirDat,ProcesarDato,EnviarBorrado,EnviarDiagonal,Fin,ResetDeDatos,TiempoRxD,TiempoDat);
  SIGNAL estado_q,estado_d : ESTADO;
--CONTADOR DE DATOS UART
	SIGNAL FIN_CONT : std_logic;
	SIGNAL RESET_CONT : std_logic;
	SIGNAL EN_CONT : std_logic;
	SIGNAL contd : unsigned(2 downto 0);
--CONTADOR DE DATOS UART
	SIGNAL FIN_TIME : std_logic;
	SIGNAL FIN_CICLO : std_logic;
	SIGNAL RESET_CONT_TIME : std_logic;
	SIGNAL EN_CONT_TIME : std_logic;
	SIGNAL contime : unsigned(12 downto 0);
--SEÃALES DE COMPARADORES
	SIGNAL Rxd_in : std_logic;
	SIGNAL COMPE : std_logic;
	SIGNAL COMPQ : std_logic;
--REGISTRO DE DESPLAZAMIENTO
	SIGNAL EN_DESPLZ_DER : std_logic;
	SIGNAL REGDPLZ_out : std_logic_vector(7 downto 0);
        SIGNAL content     : std_logic_vector(7 downto 0);

BEGIN
  process (estado_q, estado_d,Rxd_in,FIN_CONT,COMPE,COMPQ,DONE_DRAWING,FIN_TIME,FIN_CICLO)
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
                          else
                            	estado_d<=EsperaComando;
                          end if;
      when EnviarBorrado =>estado_d<=ResetDeDatos;
      when EnviarDiagonal =>estado_d<=ResetDeDatos;
      when ResetDeDatos => estado_d<=Fin;
      when TiempoRxD => if FIN_TIME='1' then
				estado_d<=RecibirDat;
			else
				estado_d<=TiempoRxD;
			end if;
      when TiempoDat => if FIN_CICLO='1' and FIN_CONT='1' then
				estado_d<=ProcesarDato;
			elsif FIN_CICLO='1' then
				estado_d<=RecibirDat;
			else
				estado_d<=TiempoDat;
			end if;
      when Fin=> if DONE_DRAWING='1' then
        		estado_d<=EsperaComando;
    		 else
                  	estado_d<=Fin;
                 end if;
      when others => estado_d<=EsperaComando;
    end case;
 	end process;
  
      
--comparador de entrada Rx_in
  Rxd_in <= '1' when RxD='0' else '0';
--comparador de comando DEL_SCREEN
  COMPE <= '1' when content="01100101" else '0';
--comparador de comando DRAW_DIAG
  COMPQ <= '1' when content="01110001" else '0';
--seÃ±al de final del contador
  FIN_CONT <= '1' when contd="111" else '0';
--seÃ±al de borrado de pantalla
  DEL_SCREEN <= '1' when (estado_q=EnviarBorrado) else '0';
--seÃ±al de dibujado de diagonal
  DRAW_DIAG <= '1' when (estado_q=EnviarDiagonal) else '0'; 
--seÃ±al de salida del registro desplazador      
  REGDPLZ_out <= content;
  EN_DESPLZ_DER <= '1' when (estado_q=RecibirDat) else '0';
--SeÃ±ales del contador de datos
  RESET_cont <= '1' when (estado_q=ResetDeDatos) else '0';
  EN_CONT <= '1' when (estado_q=RecibirDat) else '0';
--SeÃ±ales de contador de tiempo
  RESET_CONT_TIME <= '1' when (estado_q=RecibirDat or estado_d=ResetDeDatos) else '0';
  EN_CONT_TIME <= '1' when (estado_q=TiempoRxD or estado_d=TiempoDat) else '0';
  FIN_CICLO <= '1' when (contime="1110010001101") else '0';
  FIN_TIME <= '1' when (contime="1111111111111") else '0';
  
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
      process(clk, reset_l)
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
      process(clk, reset_l)
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
      process(clk, reset_l)
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
end arch1;
          