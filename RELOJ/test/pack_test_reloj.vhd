library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;

package pack_test_reloj is
  
  constant Tclk_50_MHz:       time := 20 ns; 

  -- Funcion auxiliar
  function hora_to_natural (hora: std_logic_vector(23 downto 0)) return natural;

  -- Parar el reloj cuando se alcanza un valor de hora especificado
  procedure esperar_hora    (signal   horas:       in  std_logic_vector(7 downto 0);
                             signal   minutos:     in  std_logic_vector(7 downto 0);   
                             signal   AM_PM:       in  std_logic;   
                             signal   clk:         in  std_logic;
                             constant periodo:     in  std_logic;
                             constant valor:       in  std_logic_vector(15 downto 0));

  -- Pulsacion breve de tecla
  procedure tecleo(signal   ena_cmd:   out std_logic; 
                   signal   cmd_tecla: out std_logic_vector(3 downto 0); 
                   signal   clk:       in  std_logic;
                   constant tecla:     in  std_logic_vector(3 downto 0));

  -- Cambiar de formato 12 a 24 horas y viceversa
  procedure cambiar_modo_12_24(signal   ena_cmd:   out std_logic; 
                               signal   cmd_tecla: out std_logic_vector(3 downto 0); 
                               signal   clk:       in  std_logic);

  -- Sostenimiento de tecla de entrada a programación
  procedure entrar_modo_prog(signal   pulso_largo: out std_logic; 
                             signal   cmd_tecla:   out std_logic_vector(3 downto 0); 
                             signal   clk:         in  std_logic;
                             constant duracion:    in  natural := 15);

  -- Salir del modo de programación
  procedure fin_prog(signal   ena_cmd:   out std_logic; 
                     signal   cmd_tecla: out std_logic_vector(3 downto 0); 
                     signal   clk:       in  std_logic);

  -- Dejar transcurrir el tiempo de time-out
  procedure time_out(signal   clk:       in  std_logic);

  -- Programar una hora con el comando de incremento de campo
  procedure programar_hora_inc_corto(signal   ena_cmd:   out std_logic; 
                                      signal   cmd_tecla: out std_logic_vector(3 downto 0);
                                      signal   horas:     in  std_logic_vector(7 downto 0);
                                      signal   minutos:   in  std_logic_vector(7 downto 0);   
				      signal   AM_PM:     in  std_logic;   
                                      signal   clk:       in  std_logic;
				      constant periodo:   in  std_logic;
                                      constant valor:     in  std_logic_vector(15 downto 0));

  -- Programar una hora con el comando de incremento continuo de campo
  procedure programar_hora_inc_largo (signal   pulso_largo: out std_logic; 
                                      signal   ena_cmd:     out std_logic;
                                      signal   cmd_tecla:   out std_logic_vector(3 downto 0);
                                      signal   horas:       in  std_logic_vector(7 downto 0);
                                      signal   minutos:     in  std_logic_vector(7 downto 0);   
				      signal   AM_PM:       in  std_logic;   
                                      signal   clk:         in  std_logic;
				      constant periodo:     in  std_logic;
                                      constant valor:       in  std_logic_vector(15 downto 0));

  -- Programar una hora indicando el valor de cada campo por introduccion numerica
  procedure programar_hora_directa (signal   ena_cmd:   out std_logic;
                                    signal   cmd_tecla: out std_logic_vector(3 downto 0);
				    signal   clk:       in std_logic;
				    constant valor:     in std_logic_vector(15 downto 0));
end package;

package body pack_test_reloj is
  -- Funciones auxiliares -----------------------------------------------------------------------------------
    function hora_to_natural (hora: std_logic_vector(23 downto 0)) return natural is
      variable resultado: natural := 0;

    begin
      resultado := 10*conv_integer(hora(23 downto 20));
      resultado := resultado + conv_integer(hora(19 downto 16));
      resultado := resultado * 3600;
      resultado := resultado + 600*conv_integer(hora(15 downto 12)); 
      resultado := resultado + 60*conv_integer(hora(11 downto 8));
      resultado := resultado + 10*conv_integer(hora(7 downto 4));
      resultado := resultado + conv_integer(hora(3 downto 0));
      return resultado;

    end function;

  -- Procedimientos de test -----------------------------------------------------------------------------------

  -- Parar el reloj cuando se alcanza un valor de hora especificado
  procedure esperar_hora    (signal   horas:       in  std_logic_vector(7 downto 0);
                             signal   minutos:     in  std_logic_vector(7 downto 0);   
                             signal   AM_PM:       in  std_logic;   
                             signal   clk:         in  std_logic;
                             constant periodo:     in  std_logic;
                             constant valor:       in  std_logic_vector(15 downto 0)) is
  begin
   wait until (horas = valor(15 downto 8) and minutos = valor(7 downto 0) and AM_PM = periodo);
   wait until clk'event and clk = '1';
  end procedure;

  -- Pulsacion breve de tecla
  procedure tecleo(signal   ena_cmd:   out std_logic; 
                   signal   cmd_tecla: out std_logic_vector(3 downto 0); 
                   signal   clk:       in  std_logic;
                   constant tecla:     in  std_logic_vector(3 downto 0)) is
  begin
   wait until clk'event and clk = '1';
     ena_cmd <= '1';
     cmd_tecla <= tecla;

   wait until clk'event and clk = '1';
     ena_cmd <= '0';

   wait until clk'event and clk = '1';
  end procedure;

  -- cambiar de formato 12 a 24 horas y viceversa
  procedure cambiar_modo_12_24(signal   ena_cmd:   out std_logic; 
                               signal   cmd_tecla: out std_logic_vector(3 downto 0); 
                               signal   clk:       in  std_logic) is
  begin
    tecleo(ena_cmd, cmd_tecla, clk, X"D");  
  end procedure;

  -- Sostenimiento de tecla de entrada en programación
  procedure entrar_modo_prog(signal   pulso_largo: out std_logic; 
                             signal   cmd_tecla:   out std_logic_vector(3 downto 0); 
                             signal   clk:         in  std_logic;
                             constant duracion:    in  natural := 15) is
  begin
   wait until clk'event and clk = '1';
     pulso_largo <= '1';
     cmd_tecla <= X"A";

   wait for duracion*Tclk_50_MHz;
   wait until clk'event and clk = '1';
     pulso_largo <= '0';
  end procedure;

  -- Salir del modo de programación
  procedure fin_prog(signal   ena_cmd:   out std_logic; 
                     signal   cmd_tecla: out std_logic_vector(3 downto 0); 
                     signal   clk:       in  std_logic) is
  begin
    tecleo(ena_cmd, cmd_tecla, clk, X"A");
  end procedure;


  -- Dejar transcurrir el tiempo de time-out
  procedure time_out(signal   clk:       in  std_logic) is
  begin
    for i in 1 to 8*16 loop -- el tic esta escalado: 1 tic son 16 clks; esperamos 8 tics
      wait until clk'event and clk = '1';

    end loop;
  end procedure;

  -- Programar una hora con el comando de incremento corto
  procedure programar_hora_inc_corto (signal   ena_cmd:   out std_logic; 
                                      signal   cmd_tecla: out std_logic_vector(3 downto 0);
                                      signal   horas:     in  std_logic_vector(7 downto 0);
                                      signal   minutos:   in  std_logic_vector(7 downto 0);   
				      signal   AM_PM:     in  std_logic;   
                                      signal   clk:       in  std_logic;
				      constant periodo:   in  std_logic;
                                      constant valor:     in  std_logic_vector(15 downto 0)) is

  begin

   while horas /= valor(15 downto 8) or AM_PM /= periodo loop
     tecleo(ena_cmd, cmd_tecla, clk, X"C"); --mediante pulsaciones cortas se va incrementando
   end loop;
    report "Horas programadas" severity note;
   tecleo(ena_cmd, cmd_tecla, clk, X"B"); -- cambia el modo de edicion a minutos
    
   while minutos /= valor(7 downto 0) loop
     tecleo(ena_cmd, cmd_tecla, clk, X"C"); --mediante pulsaciones cortas se va incrementando
   end loop;
    report "Minutos programados" severity note;
    
    tecleo(ena_cmd, cmd_tecla, clk, X"B"); -- para poder poner la info ="10" para las horas
   end procedure; 

  -- Programar una hora con el comando de incremento continuo
  procedure programar_hora_inc_largo (signal   pulso_largo: out std_logic; 
                                      signal   ena_cmd:     out std_logic;
                                      signal   cmd_tecla:   out std_logic_vector(3 downto 0);
                                      signal   horas:       in  std_logic_vector(7 downto 0);
                                      signal   minutos:     in  std_logic_vector(7 downto 0);   
				      signal   AM_PM:       in  std_logic;   
                                      signal   clk:         in  std_logic;
				      constant periodo:     in  std_logic;
                                      constant valor:       in  std_logic_vector(15 downto 0)) is

  begin

   pulso_largo <= '1';
   cmd_tecla <= X"C";                        -- pulso largo en C (incrementa)
   wait until horas = valor(15 downto 8) and AM_PM = periodo;    -- esperas hasta las horas indicadas en AM o PM
   wait until clk'event and clk = '1';
   
   pulso_largo <= '0';
    
   tecleo(ena_cmd, cmd_tecla, clk, X"B");    -- pasas a modificar las horas

   pulso_largo <= '1';
   cmd_tecla <= X"C";                        -- pulso largo en C (incrementa)
   wait until minutos = valor(7 downto 0);   -- esperas hasta los minutos indicados
   pulso_largo <= '0';  
    
   tecleo(ena_cmd, cmd_tecla, clk, X"B"); -- para poder poner la info ="10" para las horas
   
  end procedure; 

  -- Programar una hora indicando el valor de cada campo por introduccion numerica
  procedure programar_hora_directa (signal   ena_cmd:   out std_logic;
                                    signal   cmd_tecla: out std_logic_vector(3 downto 0);
				    signal   clk:       in std_logic;
			            constant valor:     in std_logic_vector(15 downto 0)) is
  begin
   tecleo(ena_cmd, cmd_tecla, clk, valor(15 downto 12));   -- editas decenas de horas
   tecleo(ena_cmd, cmd_tecla, clk, valor(11 downto 8));    -- editas unidades de horas
   
   tecleo(ena_cmd, cmd_tecla, clk, X"B");   -- cambia el modo de edicion a minutos
   
   tecleo(ena_cmd, cmd_tecla, clk, valor(7 downto 4));   -- editas decenas de minutos
   tecleo(ena_cmd, cmd_tecla, clk, valor(3 downto 0));   -- editas unidades de minutos
  end procedure;

end package body pack_test_reloj;

