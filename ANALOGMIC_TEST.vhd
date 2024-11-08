library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity ANALOGMIC_TEST is
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
end ANALOGMIC_TEST;

architecture Behavioral of ANALOGMIC_TEST is

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
	 
	 signal txx : std_logic;



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


    process (CLK, NRST)
    begin
        if NRST = '0' then
			txx <= '0';

        elsif rising_edge(CLK) then
			if(to_integer(unsigned(adc_out1)) >= 2500) then
				txx <= '1';
         end if;
		  
		  Tx <= txx;
		 end if;
    end process;

end Behavioral;
