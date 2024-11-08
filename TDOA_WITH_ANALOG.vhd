library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity TDOA_WITH_ANALOG is
    Port (
        CLK       : in  STD_LOGIC; 
        NRST      : in  STD_LOGIC; 
        ADC_CSN   : out STD_LOGIC;
        ADC_SCLK  : out STD_LOGIC;
        ADC_MOSI  : out STD_LOGIC;
        ADC_MISO  : in  STD_LOGIC;
        TX        : out STD_LOGIC;     
        TOGGLE     : out STD_LOGIC;     
        MIC1      : out std_logic_vector(11 downto 0);
        MIC2      : out std_logic_vector(11 downto 0);
        MIC3      : out std_logic_vector(11 downto 0)  
    );
end TDOA_WITH_ANALOG;

architecture Behavioral of TDOA_WITH_ANALOG is

    component ADC_READER
        port (
            CLK       : in std_logic;  
            NRST      : in std_logic;  
            ADC_CSN   : out std_logic; 
            ADC_SCLK  : out std_logic; 
            ADC_MOSI  : out std_logic;
            ADC_MISO  : in std_logic;  
            CHANNEL   : out std_logic_vector(2 downto 0); 
            ADC_OUT1  : out std_logic_vector(11 downto 0);
            ADC_OUT2  : out std_logic_vector(11 downto 0);
            ADC_OUT3  : out std_logic_vector(11 downto 0);
            DONE      : out std_logic;
            CLOCK_OUT : out std_logic 
        );
    end component;

    signal channel   : std_logic_vector(2 downto 0);
    signal adc_out1 : std_logic_vector(11 downto 0);
    signal adc_out2 : std_logic_vector(11 downto 0);
    signal adc_out3 : std_logic_vector(11 downto 0);
    signal adc_done : std_logic;
    signal clock_out : std_logic; 

    signal uart_tx_data : std_logic_vector(7 downto 0);
    signal uart_ready : std_logic := '0';
	 signal data_pack : std_logic_vector(35 downto 0);

    component UART_TX is
        Port ( 
            CLK    : in  STD_LOGIC;      
            NRST   : in  STD_LOGIC;     
            TX     : out STD_LOGIC;     
            TOGGLE : out STD_LOGIC;
				DATA_IN   : in  STD_LOGIC_VECTOR(35 downto 0)		
        );
    end component;

begin

    -- ADC READER instance
    adc_instance: ADC_READER
        port map (
            CLK       => CLK,
            NRST      => NRST,
            ADC_CSN   => ADC_CSN,
            ADC_SCLK  => ADC_SCLK,
            ADC_MOSI  => ADC_MOSI,
            ADC_MISO  => ADC_MISO,
            CHANNEL   => channel,
            ADC_OUT1  => adc_out1,
            ADC_OUT2  => adc_out2,
            ADC_OUT3  => adc_out3,
            DONE      => adc_done,
            CLOCK_OUT => clock_out
        );


    uart_instance: UART_TX
        port map (
            CLK    => CLK,
            NRST   => NRST,
            TX     => TX,
            TOGGLE => TOGGLE,
				DATA_IN => data_pack
        );

    process (CLK, NRST)
    begin
        if NRST = '0' then
            MIC1 <= (others => '0');
            MIC2 <= (others => '0');
            MIC3 <= (others => '0');
            uart_tx_data <= (others => '0');
            uart_ready <= '0';

        elsif rising_edge(CLK) then
            MIC1 <= adc_out1(11 downto 0);
            MIC2 <= adc_out2(11 downto 0);
            MIC3 <= adc_out3(11 downto 0);
			
        end if;
		  
		  data_pack(35 downto 24) <= adc_out1;
		  data_pack(23 downto 12) <= adc_out2;
		  data_pack(11 downto 0)  <= adc_out3;
		  
    end process;

end Behavioral;
