--------------------------------------------------------------------------------------------------
-- Autor: DTE
-- Version:3.0
-- Fecha: 17-02-2021
--------------------------------------------------------------------------------------------------
-- Paquete para simulacion del teclado hexadecimal
-- Contiene:
---- Las constantes necesarias para realizar la simulacion:
---- N_CLK_5ms : numero de ciclos de reloj que hay en un periodo del tic de 5 ms.  Para un reloj 
---- de 100 MHz deberian ser 500000; el valor escalado es 50
---- pulsacion_corta. Tiempo simulado para una pulsacion corta. El valor escalado es 3000 ns,
---- equivalente a 6 tics de 5 ms (escalados) 
---- pulsacion_larga. Tiempo simulado para una pulsacion larga. 8000 ns (16 tics escalados) 
---- constant pulsacion_corta_limite_sup. Pulsacion corta mas larga. 5000 ns; (10 tics)
---- constant pulsacion_larga_limite_inf. Pulsacion larga mas corta. 7000 ns (14 tics)
---- El procedimiento pulsa_tecla que permite simular la pulsacion de una tecla junto con el modulo
---- simulador de teclado. Este procedimiento esta pensado para ser utilizado dentro del modulo de
---- estimulos
---- El procedimiento espera_TIC que permite esperar el numero de tics de 5 ms que se indiquen en 
---- su segundo argumento. Este procedimiento esta pensado para ser utilizado dentro del modulo de
---- estimulos
--------------------------------------------------------------------------------------------------
library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;

package pack_test_teclado is

  -- Constantes de la simulacion
  constant T_CLK : time := 10 ns; -- 100 MHz
  constant N_CLK_5ms : natural := 50; -- Realmente son 500000;
  constant pulsacion_corta:     time := 3000 ns; -- 6 tics 
  constant pulsacion_larga:     time := 8000 ns; -- 16 tics 
  constant pulsacion_corta_limite_sup:     time := 5000 ns; -- 10 tics 
  constant pulsacion_larga_limite_inf:     time := 7000 ns; -- 14 tics 
  
 -- Procedimientos de test
  
  -- Pulsación de una tecla del teclado
  
  procedure pulsa_tecla(signal   clk          : in  std_logic;
                        constant tecla        : in  std_logic_vector(3 downto 0);
                        constant   duracion   : in  time;
                        signal   tecla_test   : out std_logic_vector(3 downto 0); 
                        signal   duracion_test: out time; 
                        signal   pulsar_tecla : out std_logic
                        ); 
  procedure espera_TIC(signal clk            : in  std_logic;
                       signal TIC            : in  std_logic;
                       constant numero       : in natural
                       );
end package;
package body pack_test_teclado is
  
  -- Procedimientos de test
  -- Pulsacion de una tecla del teclado
  -- Uso: en la llamada es necesario indicar la tecla que se quiere pulsar (tecla) y la duracion que se
  -- desea que tenga la pulsacion (duracion). El procedimiento activa la salida pulsar_tecla durante el
  -- tiempo que dura la pulsacion. Las salidas tecla_test y duracion_test contienen los mismos valores
  -- introducidos en tecla y duracion, respectivamente
  -- Ejemplo: pulsa la tecla "A" durante "pulsacion_corta" (constante definida, 1000 ns)
  -- pulsa_tecla(clk, x"A", pulsacion_corta, tecla_test, duracion_test, pulsar_tecla);
  procedure pulsa_tecla(signal   clk          : in  std_logic;
                        constant tecla        : in  std_logic_vector(3 downto 0);
                        constant duracion     : in  time;
                        signal   tecla_test   : out std_logic_vector(3 downto 0); 
                        signal   duracion_test: out time; 
                        signal   pulsar_tecla : out std_logic
                        ) is
  begin
    tecla_test <= tecla;
    duracion_test <= duracion;
    pulsar_tecla <= '1';
    wait for duracion;
    wait until clk'event and clk = '1';
    pulsar_tecla <= '0';
    wait until clk'event and clk = '1';
 end procedure;

  -- Espera el numero de tics indicado en el argumento numero
  -- Ejemplo: espera durante 10 tics de 5 ms
  -- espera_TIC(clk, tic_5ms, 10);
  procedure espera_TIC(signal clk            : in  std_logic;
                       signal TIC            : in  std_logic;
                       constant numero       : in natural
                      ) is
  begin
    for i in 1 to numero loop
      wait until tic'event and tic = '1';
    end loop;
    wait until clk'event and clk = '1'; 
  end procedure;
end package body pack_test_teclado;