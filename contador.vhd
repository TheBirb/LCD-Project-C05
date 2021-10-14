LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.all;
USE IEEE.NUMERIC_STD.all;
 
ENTITY counter8 IS
  PORT (
    clk       : IN std_logic; 
    reset     : IN std_logic; 
    count     : OUT std_logic_vector(3 DOWNTO 0);
    tc        : OUT std_logic;
    LCD_WRN   : OUT std_logic;
    LCD_RS    : OUT std_logic;
    LCD_CSN   : OUT std_logic
  );
END counter8;
 
ARCHITECTURE arch1 OF counter8 IS
   TYPE ESTADO IS (Estado0,Estado1,Estado2, Estado3,Estado9,Estado10,Estado11);
   SIGNAL estado_q, estado_d: ESTADO;
   SIGNAL cnt : unsigned(3 DOWNTO 0);
   SIGNAL ENABLE_DATA: std_logic;
   
   
BEGIN
   PROCESS (estado_q,cnt)
   begin
	case estado_q is
	 when Estado0 => estado_d<=Estado1;
	 when Estado1 => estado_d<=Estado2;
	 when Estado2 => estado_d<=Estado3;
	 when Estado3 => if cnt="000" or cnt = "011" then estado_d<=Estado9; elsif cnt = "001" or cnt="010" or cnt="100" or cnt="101" then estado_d <= Estado10;else estado_d<=Estado11; end if;
	 when Estado9 => estado_d<=Estado0;
	 when Estado10 => estado_d<=Estado0;
	 when others => estado_d<=Estado11;
 	end case;
   end process; 
LCD_WRN <='1' when (estado_q=Estado1) or (estado_q=Estado2) or (estado_q=Estado3) else '0';
LCD_CSN <='1' when (estado_q=Estado1) or (estado_q=Estado2) or (estado_q=Estado3) else '0';
LCD_RS  <='1' when (estado_q=Estado10) else '0';
ENABLE_DATA <='1' when (estado_q=Estado3) else '0';

--registro de estado
   PROCESS (clk,reset)
   begin
   if reset='1' then
	estado_q<=Estado0;
   elsif (clk'event and clk='1') then
	estado_q<=estado_d;
   end if;
   end process;

--contador                                                                    
   PROCESS (clk, reset)
   BEGIN
     IF reset = '1' THEN
       cnt <= (others => '0');
     ELSIF clk'event AND clk='1' THEN
       IF ENABLE_DATA='1' THEN
         cnt <= cnt + 1;
       END IF;
     END IF;
   END PROCESS;
 
   tc <= '1' WHEN cnt = "111" ELSE '0';
   count <= std_logic_vector(cnt);
 
END arch1;
