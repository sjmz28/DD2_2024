-- Disenno de un teclado matricial para el Bloque Tematico 1, Tarea 2.
-- El disenno consiste en la elaboración de un teclado matricial con una interfaz paralela.
-- Interfaz: 
--  - Salidas: filas, tecla_pulsada, tecla(Valor hexadec. de la tecla pulsada), pulso largo(si la pulsacion es mayor a 2ms)
--  - Entradas: columnas, tic ¿pasarla or un flipflop?

-- Modo de deteccion de pulsacion:
--   Se pone a nivel alto la salida del controlado, correspondiente a una fila, cada tecla es un interruptor, 
--   cuando se pulsa una tecla (ON -> cortocircuito) el nivel bajo de la salida se lleva a la columna de la tecla 
--   que esta conectada a la entrada del controlador.
--   Si por el contrario, ninguna tecla está pulsada, la resistencia de pull-up deja a nivel alto la entrada del controlador
--   RESUMEN: Salida (Fila) siempre nivel bajo. Si Entrada (Columna) a nivel bajo: Pulsada.
--                                              Si Entrada (Columna) a nivel alto: No pulsada (pull-up a nivel alto).

-- Modo de muestreo de las filas - columnas:
--   El controlador va "paseando" un nivel bajo por todas las filas constantemente hasta que se encuentra con una entrada a nivel bajo.
--   Cuando se encuentra con una columna a nivel bajo, para la secuencia de muestreo, deja la entrada nivel bajo 
--   y se indica la pulsacion con un bit (tecla_pulsada) el tiempo que dure el tiempo que dure la pulsacion.

-- Frecuencia de muestreo de las filas:
--   El retardo maximo que se tarda en dectar una pulsacion la calculamos como: (t_activacion_de_una_fila) x (nº_filas)

-- Rebotes:
--   Para prevenir los rebotes, emplearemos una sennal periodida de habiliotacion de reloj (tic) con una duracion de 5ms
--   que se encargará tambien de muestrear la tecla cada 5ms

library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;

entity ctrl_tec   is
  port(clk           : in     std_logic;
	   nRst          : in     std_logic;
	   tic           : in     std_logic;
	   columna       : in     std_logic_vector(3 downto 0);		 
       fila          : buffer std_logic_vector(3 downto 0);
	   tecla         : buffer std_logic_vector(3 downto 0);
	   tecla_pulsada : buffer std_logic;
	   pulso_largo   : buffer std_logic);
  end entity;

architecture rtl of ctrl_tec is
  

  signal col_filtrada     : std_logic_vector(3 downto 0);   -- Columnas filtradas sin rebotes
  signal fila_aux        : std_logic_vector(3 downto 0);   -- Senna que retrasa un tic el muestreo de las filas
  signal ena_muestreo     : std_logic;                      -- sennal que habilita el muestreo de las filas.
  
  -- Contador de 2 segundos con clk
  --signal cnt_2seg         : std_logic_vector(27 downto 0);   -- Contador con modulo maximo 2^28
  --constant modulo_2seg    : natural := 200000000;            -- 100Mhz/0.5
  
  -- Contador de 2 segundos con tic
  signal ena_cnt_2seg     : std_logic;
  signal cnt_2seg         : std_logic_vector(9 downto 0);   -- Contador con modulo maximo 512
  constant modulo_2seg    : natural := 400;                 -- 200Hz/0.5
  signal fdc              : std_logic;
  
  type t_estado is (muestreo, pulsacion, corta, larga);
  signal estado: t_estado;

begin
  
  --Automata de control
  process(clk, nRst)
  begin
    if nRst = '0' then
	  estado <= muestreo;
	  tecla_pulsada <= '1';
	  ena_cnt_2seg <= '0';
	elsif clk'event and clk = '1' then
	  case estado is
	    when muestreo =>
		  ena_muestreo <= '1';
		  pulso_largo <= '0';
		  tecla_pulsada <= '0';
		  
		  if col_filtrada /= X"F" then
		    estado <= pulsacion;
		  end if;
		  
		when pulsacion =>
		  ena_muestreo <= '0';
		  ena_cnt_2seg <= '1';
		  
		  if col_filtrada = X"F" then
		    estado <= corta;
		  elsif fdc = '1' then
		    estado <= larga;
		  end if; 
		  
		when corta =>
		  ena_cnt_2seg <= '0';
		  tecla_pulsada <= '1';
		  estado <= muestreo;
		  
		when larga =>
		  pulso_largo <= '1';
		  ena_cnt_2seg <= '0';
		  if col_filtrada = X"F" then
		    estado <= muestreo;
		  end if;
		  
	  end case;
	end if;
  end process;
  
  -- Contador 2 segundos con entrada de habilitacion
  process(clk, nRst)
  begin
    if nRst = '0' then
	  cnt_2seg <= (0 => '1', others => '0');
	elsif clk'event and clk = '1' then
	  if ena_cnt_2seg = '1' then
		  if tic = '1' then
			if fdc = '1' then
			  cnt_2seg <= (0 => '1', others => '0');
			else
			  cnt_2seg <= cnt_2seg + 1;
			end if;
		  end if;
      else
	    cnt_2seg <= (0 => '1', others => '0');
	  end if;
	end if;
  end process;
  
  fdc <= '1' when cnt_2seg = modulo_2seg else
        '0';
  
  -- Rebotes columnas
  process(clk, nRst)
  begin
    if nRst = '0' then
	  col_filtrada <= (others => '1');               -- Columnas activas a nivel bajo
	elsif clk'event and clk = '1' then
	  if tic = '1' then 
	    col_filtrada <= columna;
	  end if;
	end if;
  end process;
  
  -- Registro de desplazamiento filas
  process(clk, nRst)
  begin
    if nRst = '0' then
	  fila <= (0 => '0', others => '1');            -- Colocamos la primera fila a 0 para iniciar con ella el muestreo
	elsif clk'event and clk = '1' then
	  if ena_muestreo = '1' then                     -- Habilita el desplazamiento del nivel bajo por las filas
		if tic = '1' then                          -- Iniciamos el desplazamiento cuando se produce un pulso de tic
			fila <= fila(2 downto 0) & fila(3);
		end if;
	  end if;
	end if;
  end process;
  
  -- Retraso de las filas para que no coja el siguiente muestreo
  process(clk, nRst)
  begin
    if nRst = '0'then
	  fila_aux <= (others => '1');
	elsif clk'event and clk = '1' then
	  if tic = '1' then
	    fila_aux <= fila;
      end if;
	end if;
  end process;
	  
  tecla <= X"0" when fila_aux(3) = '0' and col_filtrada(1) = '0' else
           X"1" when fila_aux(0) = '0' and col_filtrada(0) = '0' else
		   X"2" when fila_aux(0) = '0' and col_filtrada(1) = '0' else
		   X"3" when fila_aux(0) = '0' and col_filtrada(2) = '0' else
		   X"4" when fila_aux(1) = '0' and col_filtrada(0) = '0' else
		   X"5" when fila_aux(1) = '0' and col_filtrada(1) = '0' else
		   X"6" when fila_aux(1) = '0' and col_filtrada(2) = '0' else
		   X"7" when fila_aux(2) = '0' and col_filtrada(0) = '0' else
		   X"8" when fila_aux(2) = '0' and col_filtrada(1) = '0' else
		   X"9" when fila_aux(2) = '0' and col_filtrada(2) = '0' else
		   X"A" when fila_aux(3) = '0' and col_filtrada(0) = '0' else
		   X"B" when fila_aux(3) = '0' and col_filtrada(2) = '0' else
		   X"C" when fila_aux(3) = '0' and col_filtrada(3) = '0' else
		   X"D" when fila_aux(2) = '0' and col_filtrada(3) = '0' else
		   X"E" when fila_aux(1) = '0' and col_filtrada(3) = '0' else
		   X"F" when fila_aux(0) = '0' and col_filtrada(3) = '0' else
		   "ZZZZ";


end rtl;

    