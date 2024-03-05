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

  -- report "(*************) revision de las 12 am y 12 pm en modo 12 horas" severity note;
  --   -- Esperar a las 11 y 58 AM
  --   esperar_hora(horas, minutos, AM_PM, clk, '0', X"11"&X"58");
	-- wait until clk'event and clk = '1';
	-- cambiar_modo_12_24(ena_cmd, cmd_tecla, clk); -- cambiamos en 11:58:01 12h am --> am 24h
	-- wait until clk'event and clk = '1';
	-- cambiar_modo_12_24(ena_cmd, cmd_tecla, clk); -- Cambiamos en 11:58:02 24h am --> am 12h
	-- wait until clk'event and clk = '1';
	
  --   esperar_hora(horas, minutos, AM_PM, clk, '1', X"11"&X"59");
	-- wait until clk'event and clk = '1';
	-- cambiar_modo_12_24(ena_cmd, cmd_tecla, clk); -- Cambiamos en 11:59:01 12h pm --> pm 24h
	-- wait until clk'event and clk = '1';
	-- cambiar_modo_12_24(ena_cmd, cmd_tecla, clk); -- Cambiamos en 11:59:02 24h pm --> pm 12h
	-- wait until clk'event and clk = '1';
	
	-- -- Cambio de 12h a 24 horas
	-- report "(*************) revision de las 12 am y 12 pm en modo 24 horas" severity note;
	-- cambiar_modo_12_24(ena_cmd, cmd_tecla, clk);
	
	-- esperar_hora(horas, minutos, AM_PM, clk, '0', X"00"&X"00");
	-- wait until clk'event and clk = '1';
	-- cambiar_modo_12_24(ena_cmd, cmd_tecla, clk); -- Cambiamos en 00:00:01 24h am --> am 12h
	-- wait until clk'event and clk = '1';
	-- cambiar_modo_12_24(ena_cmd, cmd_tecla, clk); -- Cambiamos en 00:00:02 12h am --> am 24h
	-- wait until clk'event and clk = '1';
	
  
	-- esperar_hora(horas, minutos, AM_PM, clk, '1', X"12"&X"00");
	-- wait until clk'event and clk = '1';
	-- cambiar_modo_12_24(ena_cmd, cmd_tecla, clk); -- Cambiamos en 12:00:01 24h pm --> pm 12h
	-- wait until clk'event and clk = '1';
	-- cambiar_modo_12_24(ena_cmd, cmd_tecla, clk); -- Cambiamos en 12:00:02 12h pm --> pm 24h
	-- wait until clk'event and clk = '1';

  -- esperar_hora(horas, minutos, AM_PM, clk, '0', X"00"&X"00");
  -- wait until clk'event and clk = '1';
	
  -- report "(+) FASE DE PREBA MODO NORMAL FUNCIONA" severity note;

  
  -- *****************  FASE DE PRUEBA DE MODO PROGRAMACION *****************
  --  -- 0. que pueda salir de modo programacion,
  -- -- 0.1 con el boton de cancelar
  -- fin_prog(ena_cmd, cmd_tecla, clk);

  -- wait until clk'event and clk = '1';
  -- wait until clk'event and clk = '1';

  -- --  0.2 esperando los 7 segundos
  -- entrar_modo_prog( pulso_largo, cmd_tecla, clk);
  -- time_out(clk);
 -- 1:30:00 am en modo 12 horas que tendria que salirse a los 7 segundos


  -- ++++++++++++  INCREMENTACION EN PULSACION CORTA +++++++++++++

-- -- 1. Entramos en modo programacion habiendo fijado una hora (para tenerla de referencia)

-- esperar_hora(horas, minutos, AM_PM, clk, '0', X"01"&X"01"); -- 00:01:00 am en modo 12 horas
-- entrar_modo_prog( pulso_largo, cmd_tecla, clk); 
-- report "(*) Iniciamos la prueba de programacin mediante pulsacion corta " severity note;
-- wait until clk'event and clk = '1';
-- wait until clk'event and clk = '1';
-- -- 2. avanzar hasta las 11:59:00 pm
-- programar_hora_inc_corto(ena_cmd, cmd_tecla, horas, minutos, AM_PM, clk, '0', X"00"&X"00");
-- report "(+) Funciona el cambio con pulsacion corta en modo 12 horas" severity note;

-- -- 3. probamos lo mismo pero con el modo 24h
-- cambiar_modo_12_24(ena_cmd, cmd_tecla, clk);
-- report "(*) Inicializaos para comprobar en modo 24h" severity note;
-- programar_hora_inc_corto(ena_cmd, cmd_tecla, horas, minutos, AM_PM, clk, '0', X"01"&X"01");

-- report "(*) Iniciamos la prueba de programacin mediante pulsacion corta " severity note;
-- wait until clk'event and clk = '1';
-- wait until clk'event and clk = '1';

-- -- 4. avanzar hasta las 23:59:00 pm
-- programar_hora_inc_corto(ena_cmd, cmd_tecla, horas, minutos, AM_PM, clk, '0', X"00"&X"00");
-- report "(+) Funciona el cambio con pulsacion corta en modo 24 horas" severity note;
-- fin_prog(ena_cmd, cmd_tecla, clk);

  -- ++++++++++++  INCREMENTACION EN PULSACION LARGA +++++++++++++

  -- esperar_hora(horas, minutos, AM_PM, clk, '0', X"01"&X"01"); -- 00:00:00 am en modo 12 horas
  -- entrar_modo_prog( pulso_largo, cmd_tecla, clk); 
  -- report "(*) Iniciamos la prueba de programacin mediante pulsacion larga MODO 12H " severity note;
  -- wait until clk'event and clk = '1';
  -- wait until clk'event and clk = '1';

  -- -- 2. avanzar hasta las 11:59:00 am
  -- programar_hora_inc_largo(pulso_largo, ena_cmd, cmd_tecla, horas, minutos, AM_PM, clk, '0', X"00"&X"00");
  -- report "(+) Funciona el cambio con pulsacion corta en modo 12 horas" severity note;
  
  -- -- 3. probamos lo mismo pero con el modo 24h
  -- cambiar_modo_12_24(ena_cmd, cmd_tecla, clk);
  -- programar_hora_inc_largo(pulso_largo, ena_cmd, cmd_tecla, horas, minutos, AM_PM, clk, '0', X"01"&X"01");
  -- report "(*) Iniciamos la prueba de programacin mediante pulsacion larga MODO 24H " severity note;
  -- wait until clk'event and clk = '1';
  -- wait until clk'event and clk = '1';
  -- -- 4. avanzar hasta las 23:59:00 pm
  -- programar_hora_inc_largo(pulso_largo, ena_cmd, cmd_tecla, horas, minutos, AM_PM, clk, '0', X"00"&X"00");
  -- report "(+) Funciona el cambio con pulsacion corta en modo 24 horas" severity note;
  -- fin_prog(ena_cmd, cmd_tecla, clk);

  
 
  -- ++++++++++++  CAMBIO DE HORA POR TECLEO +++++++++++++
  
  -- 3. que pueda cambiar la hora
  -- 3.1 cambiando una hora normal
  entrar_modo_prog( pulso_largo, cmd_tecla, clk);
  wait until clk'event and clk = '1';
  programar_hora_directa(ena_cmd, cmd_tecla, clk, X"0941"); -- 09:41:00 am en modo 12 horas
  wait until clk'event and clk = '1';
  fin_prog(ena_cmd, cmd_tecla, clk);
  wait until clk'event and clk = '1';


    assert false
    report "done"
    severity failure;
  end process;

end test;
