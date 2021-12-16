------------------------------------------------------
--  Project sample
--
-------------------------------------------------------
--
-- CLOCK_50 is the system clock.
-- KEY0 is the active-low system reset.
-- LCD withouth touch screen
-- 
---------------------------------------------------------------
--- Developed by: G.A. 
--- Date : 07/07/2021
--
--- Version: V1.3  Basic design with internal ROM (LT24Setup + LT24_Test_LCD) (22-07-2021)
--- Version  V2.0  Stage 1 primary design (22-10-2021) 
---          New version (LT24Setup + LCD_Ctrl + LCD_Drawing)
---------------------------------------------------------------

library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;
use work.romData_pkg.all;

entity DE1SOC_TOP is
 port(
        -- CLOCK ----------------
        CLOCK_50        : in    std_logic;
--      CLOCK2_50       : in    std_logic;
--      CLOCK3_50       : in    std_logic;
--      CLOCK4_50       : in    std_logic;
        -- KEY ----------------
        KEY             : in    std_logic_vector(3 downto 0);
        -- SW ----------------
        SW              : in    std_logic_vector(9 downto 0);
        -- LEDR ----------------
        LEDR            : out   std_logic_vector(9 downto 0);
        
        -- LT24_LCD ----------------
        LT24_LCD_ON     : out std_logic;
        LT24_RESET_N    : out std_logic;
        LT24_CS_N       : out std_logic;
        LT24_RD_N       : out std_logic;
        LT24_RS         : out std_logic;
        LT24_WR_N       : out std_logic;
        LT24_D          : out   std_logic_vector(15 downto 0);

        -- GPIO ----------------
        GPIO_0          : inout std_logic_vector(35 downto 0)
--      GPIO_1          : inout std_logic_vector(35 downto 0)

        -- SEG7 ----------------
--      HEX0    : out   std_logic_vector(6 downto 0);
--      HEX1    : out   std_logic_vector(6 downto 0);
--      HEX2    : out   std_logic_vector(6 downto 0);
--      HEX3    : out   std_logic_vector(6 downto 0);
--      HEX4    : out   std_logic_vector(6 downto 0);
--      HEX5    : out   std_logic_vector(6 downto 0);

 );
end;

architecture rtl_0 of DE1SOC_TOP is 


   component LT24Setup 
   port(
      -- CLOCK and Reset_l ----------------
      clk            : in      std_logic;
      reset_l        : in      std_logic;

      LT24_LCD_ON      : out std_logic;
      LT24_RESET_N     : out std_logic;
      LT24_CS_N        : out std_logic;
      LT24_RS          : out std_logic;
      LT24_WR_N        : out std_logic;
      LT24_RD_N        : out std_logic;
      LT24_D           : out std_logic_vector(15 downto 0);

      LT24_CS_N_Int        : in std_logic;
      LT24_RS_Int          : in std_logic;
      LT24_WR_N_Int        : in std_logic;
      LT24_D_Int           : in std_logic_vector(15 downto 0);
      
      LT24_Init_Done       : out std_logic
   );
   end component;

   component LCD_Ctrl  
   port (
       clk             : in  std_logic;
       reset_l         : in  std_logic;
    
       LCD_Init_Done  : in std_logic;      -- LCD Initialization Done
       
       -- OP SetCursor(XCol, YRow)   Change Cursor position  (On reset 0,0)
       OP_SetCursor  : in std_logic;
       XCol          : in std_logic_vector(7 downto 0);
       YRow          : in std_logic_vector(8 downto 0);
       
       -- OP DrawColour(RGB, NumPix)  from the current cursor position
       OP_DrawColour  : in std_logic;
       RGB            : in std_logic_vector (15 downto 0) ;
       NumPix         : in std_logic_vector (16 downto 0);
      
       -- Operation Finish
       Done_SetCursor   : out std_logic;     -- Done_Cursor
       Done_DrawColor   : out std_logic;     -- Done_Color
       
       
       -- LT24 LCD Bus Interface (signal_N  == signal_l) 
       LCD_CS_N     : out std_logic;           -- Chip select 
       LCD_RS       : out std_logic;           -- Command(0)/Data(1) Operation 
       LCD_WR_N     : out std_logic;           -- Write Operation (0)
       LCD_DATA     : out std_logic_vector(15 downto 0) -- Bus data (Command code or Data to send)
   );
   end component;
 
   -- component LCD_DRAWING
   component LCD_Drawing  
   port (
       clk             : in  std_logic;
       reset_l         : in  std_logic;
       -- OP: Delete Screen Draw al Screen with black pixels 
       Del_Screen       : in std_logic;      -- Delete Screen Operation
       -- OP: Draw a Diagonal Line 
       Draw_Diag        : in std_logic;      -- Draw a diagonal line (from 0,0, to ...)
       Colour		      : in std_logic_vector(1 downto 0);    -- Code of color
       -- Operation Finish (from Lcd_Control)
       Done_SetCursor   : in std_logic; 
       Done_DrawColor   : in std_logic;        -- OP DrawColour(RGB, NumPix)  from the current cursor position
       -- OP SetCursor(XCol, YRow)   Change Cursor position  (On reset 0,0)
       OP_SetCursor  : out std_logic;
       XCol          : out std_logic_vector(7 downto 0);
       YRow          : out std_logic_vector(8 downto 0);
       -- OP DrawColour(RGB, NumPix)  from the current cursor position
       OP_DrawColour  : out std_logic;
       RGB            : out std_logic_vector (15 downto 0) ; 	
       NumPix         : out std_logic_vector (16 downto 0) ;
		 Done_Drawing   : out std_logic
   );
   end component ;
	
	component LCD_UART
	port (
		clk          : IN  std_logic;
      RxD 	       : IN  std_logic;
      reset_l      : IN  std_logic;
      DONE_DRAWING : IN  std_logic;
      DEL_SCREEN 	 : OUT  std_logic;
      DRAW_DIAG 	 : OUT  std_logic;
		FUN_BASICA   : OUT  std_logic;
		FIN_FUN      : OUT  std_logic;
		MOVE         : OUT  std_logic;
		POSICION     : OUT  std_logic_vector(1 DOWNTO 0) 
	);
	end component ;
	
	component LCD_BASICA
	port (
    clk           : IN std_logic; 
    reset_l       : IN std_logic;
    FUN_BASICA    : IN std_logic;
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
	end component;

  
      constant BLACK_rgb : std_logic_vector (15 downto 0) := "0000000000000000";
      constant RED_rgb   : std_logic_vector (15 downto 0) := "1111100000000000";
      constant GREEN_rgb : std_logic_vector (15 downto 0) := "0000011111100000";
      constant BLUE_rgb  : std_logic_vector (15 downto 0) := "0000000000011111";

--------------------------------------------------
    signal clk     : std_logic;
    signal reset_l : std_logic;
    signal reset   : std_logic;

   signal  LT24_CS_N_Int        :  std_logic;
   signal  LT24_RS_Int          :  std_logic;
   signal  LT24_WR_N_Int        :  std_logic;
   signal  LT24_RD_N_Int        :  std_logic;
   signal  LT24_D_Int           :  std_logic_vector(15 downto 0);

   signal  OP_SetCursor_A      :  std_logic;   -- LT24_Init_Done
   signal  OP_SetCursor_Sinc   :  std_logic;   -- LT24_Init_Done
   signal  XCol_A               :  std_logic_vector(7 downto 0);
   signal  YRow_A               :  std_logic_vector(8 downto 0);
   signal  Done_SetCursor      :  std_logic;
 
   signal  OP_DrawColour_A       :  std_logic;   -- OP_DrawColour
   signal  OP_DrawColour_Sinc  :  std_logic;   -- OP_DrawColour
   signal  OP_DrawColour_sinc_one  :  std_logic;   -- OP_DrawColour one shot
   signal  NUMPIX_A            :  std_logic_vector(16 downto 0);
   signal  RGB_A               :  std_logic_vector(15 downto 0);
   signal  Done_DrawColor      :  std_logic;
	signal  Done_Drawing_A      :  std_logic;
	signal  Del_Screen_A        :  std_logic;
	signal  Draw_Diag           :  std_logic;

   signal  LT24_Init_Done       : std_logic;   -- LT24_Init_Done
   signal  Test_LCD_Done        : std_logic;   -- Test_LCD_Done
   signal  Rx                   : std_logic;
	
	signal  Direccion            : std_logic_vector(1 downto 0);
	signal  Move                 : std_logic;
	signal  Fin_Fun              : std_logic;
	signal  Fun_Basica           : std_logic;
	signal  OP_SetCursor_B       :  std_logic;
   signal  XCol_B               :  std_logic_vector(7 downto 0);
   signal  YRow_B               :  std_logic_vector(8 downto 0);
   signal  OP_DrawColour_B     :  std_logic;   -- OP_DrawColour
   signal  NUMPIX_B            :  std_logic_vector(16 downto 0);
   signal  RGB_B               :  std_logic_vector(15 downto 0);
   signal  Done_Drawing_B      :  std_logic;	
	signal  Del_Screen_B        :  std_logic;
	
	signal  OP_SetCursor        :  std_logic;
   signal  XCol                :  std_logic_vector(7 downto 0);
   signal  YRow                :  std_logic_vector(8 downto 0);
   signal  OP_DrawColour       :  std_logic;   -- OP_DrawColour
   signal  NUMPIX              :  std_logic_vector(16 downto 0);
   signal  RGB                 :  std_logic_vector(15 downto 0);
   signal  Done_Drawing        :  std_logic;	
	signal  Del_Screen          :  std_logic;
	
	signal divclk : unsigned(5 downto 0);
   attribute noprune: boolean;
   attribute noprune of divclk: signal is true;
	
	signal  set_fun              : std_logic;
	signal  set_fun_o            : std_logic;

begin 
        --  Input PINs Asignements
        clk <= CLOCK_50;

        reset_l <= KEY(0);
        reset   <= '1' when KEY(0)='0' else '0';
		  Rx <= GPIO_0(5);
		  
		  --Registro señal del Multiplexor
		   PROCESS (clk,reset_l,FUN_BASICA,FIN_FUN)
			begin
				if reset_l='0' then
					set_fun<='0';
			elsif (clk'event and clk='1') then
				if FUN_BASICA='1' then
					set_fun<='1';
				elsif FIN_FUN='1' then
				   set_fun<='0';
				end if;
			end if;
			end process;
			
			--Registro señal del Multiplexor
			PROCESS (clk,reset_l,Del_Screen_B,Done_Drawing_A)
			begin
				if reset_l='0' then
					set_fun_o<='0';
			elsif (clk'event and clk='1') then
				if Del_Screen_B='1' then 
				   set_fun_o<='0';
				elsif Done_Drawing_A='1' then
				   set_fun_o<='1';
				end if;
			end if;
			end process;
			
			
		   process (CLOCK_50, KEY(0))
			begin
				if KEY(0)='0' then
					divclk <= "000000";
				elsif (CLOCK_50'event and CLOCK_50='1') then
					divclk <= divclk +1;
			end if;
			end process;
			--Multiplexores de entrada
			OP_SetCursor  <= OP_SetCursor_A when (set_fun='0') else OP_SetCursor_A when (set_fun='1' and set_fun_o='0') else OP_SetCursor_B;
         XCol          <= XCol_A when (set_fun='0') else XCol_A when (set_fun='1' and set_fun_o='0') else XCol_B;
         YRow          <= YRow_A when (set_fun='0') else YRow_A when (set_fun='1' and set_fun_o='0')  else YRow_B;
         OP_DrawColour <= OP_DrawColour_A when (set_fun='0') else OP_DrawColour_A when (set_fun='1' and set_fun_o='0')  else OP_DrawColour_B;
         NUMPIX        <= NUMPIX_A when (set_fun='0') else NUMPIX_A when (set_fun='1' and set_fun_o='0') else NUMPIX_B;
         RGB           <= RGB_A when (set_fun='0') else RGB_A when (set_fun='1' and set_fun_o='0') else RGB_B;
			
         Done_Drawing  <= Done_Drawing_A when (set_fun='0')  else Done_Drawing_B;	
	      Del_Screen    <= Del_Screen_A when (set_fun='0')  else Del_Screen_B;

-- Instaciacion de componentes--------------    


  DUT_SETUP:LT24Setup 
  port map(
      clk          => clk,
      reset_l      => reset_l,

      LT24_LCD_ON      => LT24_LCD_ON,
      LT24_RESET_N     => LT24_RESET_N,
      LT24_CS_N        => LT24_CS_N,
      LT24_RS          => LT24_RS,
      LT24_WR_N        => LT24_WR_N,
      LT24_RD_N        => LT24_RD_N,
      LT24_D           => LT24_D,

      LT24_CS_N_Int       => LT24_CS_N_Int,
      LT24_RS_Int         => LT24_RS_Int,
      LT24_WR_N_Int       => LT24_WR_N_Int,
      LT24_D_Int          => LT24_D_Int,

      
      LT24_Init_Done      => LT24_Init_Done
 );
   LEDR(9)  <= LT24_Init_Done;

  DUT_LCD_Ctrl:LCD_Ctrl  
    port map (
      clk          => clk,
      reset_l      => reset_l,
    
       LCD_Init_Done  => LT24_Init_Done,     -- LCD Initialization Done
      
       -- OP SetCursor(XCol, YRow)   Change Cursor position  (On reset 0,0)
       OP_SetCursor  => OP_SetCursor,
       XCol          => XCol,
       YRow          => YRow,
       
       -- OP DrawColour(RGB, NumPix)  from the current cursor position
       OP_DrawColour   => OP_DrawColour,
       RGB             => RGB,
       NumPix          => NumPix,
      
       -- Operation Finish
       Done_SetCursor    => Done_SetCursor,
       Done_DrawColor     => Done_DrawColor,
       
       
       -- LT24 LCD Bus Interface (signal_N  == signal_l) 
       LCD_CS_N     =>  LT24_CS_N_Int,           -- Chip select 
       LCD_RS       =>  LT24_RS_Int,           -- Command(0)/Data(1) Operation 
       LCD_WR_N     =>  LT24_WR_N_Int,           -- Write Operation (0)
       LCD_DATA     =>  LT24_D_Int -- Bus data (Command code or Data to send)
   );

  LEDR(7)  <= Done_SetCursor;
  LEDR(8)  <= Done_DrawColor;

 
  DUT_LCD_Drawing:LCD_Drawing  
    port map (
      clk          => clk,
      reset_l      => reset_l,
       -- OP: Delete Screen Draw al Screen with black pixels 
       Del_Screen          => Del_Screen,
       -- OP: Draw a Diagonal Line 
       Draw_Diag           => Draw_Diag,
       Colour              => SW(1 downto 0),
       -- Operation Finish (from Lcd_Control)
       Done_SetCursor              => Done_SetCursor,
       Done_DrawColor              => Done_DrawColor,
       -- OP SetCursor(XCol, YRow)   Change Cursor position  (On reset 0,0)
       OP_SetCursor             => OP_SetCursor_A,
       XCol                     => XCol_A,
       YRow                     => YRow_A,
       -- OP DrawColour(RGB, NumPix)  from the current cursor position
       OP_DrawColour     => OP_DrawColour_A,
       RGB               => RGB_A,
       NumPix            => NumPix_A,
		 -- Done of Drawing
		 Done_Drawing      => Done_Drawing_A
   );
	
	LEDR(6)  <= not(Rx);
   LEDR(5)  <= Del_Screen_B;
	LEDR(2)  <= Done_Drawing_A;
	LEDR(1)  <= Fun_Basica;
	LEDR(3)  <= not(set_fun);
	LEDR(0)  <= Del_Screen;
	
	DUT_LCD_UART:LCD_UART
	  port map (
		 clk  		  => clk,
		 reset_l      => reset_l,
       RxD 	        => Rx,
       DONE_DRAWING => Done_Drawing,
       DEL_SCREEN   => Del_Screen_A,
       DRAW_DIAG    => Draw_Diag,
		 FUN_BASICA   => Fun_Basica,
		 FIN_FUN      => Fin_Fun,
		 MOVE         => Move,    
		 POSICION     => Direccion
	);
	
	DUT_LCD_BASICA:LCD_BASICA
	  port map (
		 clk           => clk,
		 reset_l       => reset_l,
		 FUN_BASICA    => Fun_Basica,
		 MOVE          => Move,
		 FIN           => Fin_Fun,
		 DIRECCION     => Direccion,
		 COLOR_CODE    => SW(1 downto 0),
		 DONE_DEL      => Done_Drawing_A,
	    DONE_CURSOR   => Done_SetCursor,
	    DONE_COLOR    => Done_DrawColor,
		 DEL_SCREEN    => Del_Screen_B,
		 OP_SETCURSOR  => OP_SetCursor_B,
		 XCOL          => XCol_B,
		 YROW          => YRow_B,
		 OP_DRAWCOLOUR => OP_DrawColour_B,
		 RGB           => RGB_B,
		 NUM_PIX       => NumPix_B,
		 DONE_DRAWING  => Done_Drawing_B
	);
   


--------------------------------------------------
END rtl_0;
