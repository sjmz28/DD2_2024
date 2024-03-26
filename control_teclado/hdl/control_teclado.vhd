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
--   y se indica la pulsación con un bit (tecla_pulsada) el tiempo que dure el tiempo que dure la pulsación.

-- Frecuencia de muestreo de las filas:
--   El retardo maximo que se tarda en dectar una pulsacion la calculamos como: (t_activacion_de_una_fila) x (nº_filas)

-- Rebotes:
--   Para prevenir los rebotes, emplearemos una sennal periodida de habiliotacion de reloj (tic) con una duracion de 5ms
--   que se encargará tambien de muestrear la tecla cada 5ms
entity teclado   is
    port(clk:           in     std_logic;
         nRst:          in     std_logic;
         col0:          in     std_logic;
         col1:          in     std_logic;
         col2:          in     std_logic;
         col3:          in     std_logic;
         tic:           in     std_logic;
         fil0:          buffer    std_logic;
         fil1:          buffer    std_logic;
         fil2:          buffer    std_logic;
         fil3:          buffer    std_logic;
         tecla :        buffer    std_logic_vector(3 downto 0);
         tecla_pulsada: buffer    std_logic;
         pulso_largo:   buffer    std_logic);
    end entity;

architecture rtl of teclado is
  
    signal filas: std_logic_vector(3 downto 0);
    signal columnas: std_logic_vector(3 downto 0);
    signal col_muestreada: std_logic_vector(3 downto 0);
    signal contador_fila: std_logic_vector(1 downto 0);
    signal contador_columna: std_logic_vector(1 downto 0);
	
	signal ena_muestreo: std_logic;  -- sennal que habilita el muestreo de las filas.

    
	
begin
    -- nuestro objetivo por una parte es "turnar" las filas y por otra, quitar los rebotes de las columnas 
    -- por lo que por un lado vamos a utilizar un contador para saber por que fila vamos y por otro usar ese 
    -- tic para quitar el rebote de las columnas
   proccess(clk, nRst)
   if nRst='0' then
      tecla_pulsada<='0';
      pulso_largo<='0';
      tecla<="0000";
      contador_fila<="00";
    elsif clk'event and clk='1' then
        if tic='1' then 
            col_muestreada=columnas; -- al pasar todos el registro de columnas, si hay alguna activa lo sabremos
    
            if contador_fila<4 then -- con esto controlamos por que fila vamos 
                contador_fila<=contador_fila+1;
            else
                contador_fila<="00";
            end if;
            -- me he perdido ya:)
    end if;
           
		   

  filas    <= fil3 & fil2 & fil1 & fil0;             -- Fila de menor peso a la derecha.
  columnas <= col3 & col2 & col1 & col0;             -- Columna de menor peso a la derecha.
  -- Rebotes columnas
  process(clk, nRst)
  begin
    if nRst = '0' then
	  col_muestreada <= (others => '1');             -- Columnas activas a nivel bajo
	elsif clk'event and clk = '1' then
	  if tic = '1' then 
	    col_muestreada = col;
	  end if;
	end if;
  end process;
  
  -- Registro de desplazamiento filas
  process(clk, nRst)
  begin
    if nRst = '0' then
	  filas <= (0 => '0', others => '1');
	elsif clk'event and clk = '1' then
	  if ena_muestreo = '1' then                     -- Habilita el desplazamiento del nivel bajo
		  if tic = '1' then                          -- Iniciamos el desplazamiento cuando se produce un pulso de tic
			filas <= filas(2 downto 0) & fila(3);
		  end if;
		end if;
  end process;
	  



end rtl;

    