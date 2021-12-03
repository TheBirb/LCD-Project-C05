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
	TYPE ESTADO IS (Inicio,EsperaComando,RecibirDat,ProcesarDato,EnviarBorrado,EnviarDiagonal,Fin,ResetDeDatos);
  SIGNAL estado_q,estado_d : ESTADO;
--CONTADOR DE DATOS UART
	SIGNAL FIN_CONT : std_logic;
	SIGNAL RESET_CONT : std_logic;
	SIGNAL EN_CONT : std_logic;
	SIGNAL contd : unsigned(2 downto 0);
--SEÑALES DE COMPARADORES
	SIGNAL Rxd_in : std_logic;
	SIGNAL COMPE : std_logic;
	SIGNAL COMPQ : std_logic;
--REGISTRO DE DESPLAZAMIENTO
	SIGNAL EN_DESPLZ_DER : std_logic;
	SIGNAL REGDPLZ_out : std_logic_vector(7 downto 0);
  SIGNAL content     : std_logic_vector(7 downto 0);

BEGIN
  process (estado_q, estado_d,Rxd_in,FIN_CONT,COMPE,COMPQ,DONE_DRAWING)
  begin
    case estado_q is
      when Inicio => estado_d<=EsperaComando;
    	when EsperaComando => if Rxd_in='1' then
        			estado_d<=RecibirDat;
    			else
                              	estado_d<=EsperaComando;
    			end if;
      when RecibirDat => if FIN_CONT='1' then
        			estado_d<=ProcesarDato;
                         else
                           	estado_d<=RecibirDat;
                         end if;
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
--señal de final del contador
  FIN_CONT <= '1' when contd="111" else '0';
--señal de borrado de pantalla
  DEL_SCREEN <= '1' when (estado_q=EnviarBorrado) else '0';
--señal de dibujado de diagonal
  DRAW_DIAG <= '1' when (estado_q=EnviarDiagonal) else '0'; 
--señal de salida del registro desplazador      
  REGDPLZ_out <= content;
  EN_DESPLZ_DER <= '1' when (estado_q=RecibirDat) else '0';

--Señales del contador de datos
  RESET_cont <= '1' when (estado_q=ResetDeDatos) else '0';
  EN_CONT <= '1' when (estado_q=RecibirDat) else '0';
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
end arch1;
          