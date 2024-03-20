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