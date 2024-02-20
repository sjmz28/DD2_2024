library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;

use work.pack_test_reloj.all;

entity test_estimulos_reloj is
port(clk:     	  in std_logic;
     nRst:        in std_logic;
     tic_025s:    out std_logic;
     tic_1s:      out std_logic;
     ena_cmd:     out std_logic;
     cmd_tecla:   out std_logic_vector(3 downto 0);
     pulso_largo: out std_logic;
     modo:        in std_logic;
     segundos:    in std_logic_vector(7 downto 0);
     minutos:     in std_logic_vector(7 downto 0);
     horas:       in std_logic_vector(7 downto 0);
     AM_PM:       in std_logic;
     info:        in std_logic_vector(1 downto 0)
    );
end entity;

architecture test of test_estimulos_reloj is

begin
  -- Tic para el incremento continuo de campo. Escalado. 
  process
  begin
    tic_025s <= '0';
    for i in 1 to 3 loop
       wait until clk'event and clk = '1';
    end loop;

    tic_025s <= '1';
    wait until clk'event and clk = '1';

  end process;
  -- Tic de 1 seg. Escalado.
  process
  begin
    tic_1s <= '0';
    for i in 1 to 15 loop
       wait until clk'event and clk = '1';
    end loop;

    tic_1s <= '1';
    wait until clk'event and clk = '1';

  end process;


  process
  variable h: std_logic_vector(7 downto 0);
  
  begin
    ena_cmd  <= '0';
    cmd_tecla <= (others => '0');
    pulso_largo <= '0';
    

    -- Esperamos el final del Reset
    wait until nRst'event and nRst = '1';


    for i in 1 to 9 loop
       wait until clk'event and clk = '1';
    end loop;

    -- Cuenta en formato de 12 horas
    wait until clk'event and clk = '1';
  --   cambiar_modo_12_24(ena_cmd, cmd_tecla, clk);
  --   report "(*) Comprobacion de la vuelta en modo 24 horas ";
  --   -- Esperar a las 11 y 58 AM
  --   esperar_hora(horas, minutos, AM_PM, clk, '1', X"11"&X"59");
	
	-- -- Cambio de 12h a 24 horas
  --   report "(*) Comprobacion de la vuelta en modo 12 horas ";
  -- 	cambiar_modo_12_24(ena_cmd, cmd_tecla, clk);
	--   esperar_hora(horas, minutos, AM_PM, clk, '1', X"11"&X"59");
	
    report "(*) Comprobacion de la conversion 12-24 y viceversa";
    esperar_hora(horas, minutos, AM_PM, clk, '0', X"00"&X"03");

    -- variable para las horas
    
    h:=X"00";
  
    for i in 1 to 12 loop
      
      cambiar_modo_12_24(ena_cmd, cmd_tecla, clk);
      wait until clk'event and clk = '1';
      wait until clk'event and clk = '1';
      cambiar_modo_12_24(ena_cmd, cmd_tecla, clk);
      wait until clk'event and clk = '1';
     
      h:=h+X"01";
      esperar_hora(horas, minutos, AM_PM, clk, '0', h&X"03");
      end loop;
     
      h:=X"00";

    for i in 1 to 12 loop
    
      cambiar_modo_12_24(ena_cmd, cmd_tecla, clk);
      wait until clk'event and clk = '1';
      wait until clk'event and clk = '1';
      cambiar_modo_12_24(ena_cmd, cmd_tecla, clk);
      wait until clk'event and clk = '1';
       
      h:=h+X"01";
      esperar_hora(horas, minutos, AM_PM, clk, '1', h&X"03");
    end loop;

    assert false
    report "done"
    severity failure;
  end process;

end test;
