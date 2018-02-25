
-- PRÁCTICA 1.4. METODOLOGÍA DE LA PROGRAMACIÓN --


-- Diego Díaz Alvarellos



with Ada.Text_IO, Ada.Integer_Text_Io;
use Ada.Text_Io, Ada.Integer_Text_Io;


procedure Prac4 is




   --*******************************************************--

   -- DEFINICION DE TIPOS :


   -------------------------------------------------

   type Tipo_Fecha is record
               dia: Natural range 1..31;
               mes: Natural range 1..12;
               agno: Integer;
   end record;


   ----------- texto de longitud variable ----------

   Tam_Max_Texto : constant := 40;

   subtype Tipo_Long_Texto is Natural range 0..Tam_Max_Texto;

   type Tipo_Texto is array (1..Tam_Max_Texto) of character;

   type Tipo_Texto_Mensaje is
   record
      Texto_Mensaje : Tipo_Texto;
      Long_Texto : Tipo_Long_Texto;
   end record;


   -------- dirección de longitud variable ---------

   Tam_Max_Direccion : constant := 30;

   subtype Tipo_Long_Direccion is Natural range 1..Tam_Max_Direccion;

   type Tipo_Direccion is array (1..Tam_Max_Direccion) of character;

   type Tipo_Direccion_Mensaje is
   record
      Direccion : Tipo_Direccion;
      Long_Direccion : Tipo_Long_Direccion;
   end record;

   -------------------------------------------------
      type Tipo_Mensaje is
   record
      Direccion_Correo_Emisor : Tipo_Direccion_Mensaje;
      Direccion_Correo_Receptor : Tipo_Direccion_Mensaje;
      Fecha_Emision_Mensaje : Tipo_Fecha;
      Texto_Del_Mensaje : Tipo_Texto_Mensaje;
   end record;

   -------------------------------------------------


   -- declaración del puntero --

   type Tipo_Celda;
   type Tipo_Cadena is access Tipo_Celda;
   type Tipo_Celda is record
      Valor : Tipo_Mensaje;
      Siguiente : Tipo_Cadena;
      end record;

   -------------------------------------------------

    subtype TipoFicheroTexto is ADA.TEXT_IO.FILE_TYPE;

    --******************************************************--



   -- PROCEDIMIENTOS DE LECTURA :    

    ------------------------------------------------

procedure LeerDireccion (entrada : in TipoFicheroTexto; direccion_M : out Tipo_Direccion_Mensaje) is
-- Pre : "fichero entrada es un fichero ya abierto para lectura"
-- Post : "Lee la dirección que se encuentra en el fichero entrada"

  car : Character;
  i : positive :=1;
begin
   Get (entrada, car);
   while not (car=',') loop
         direccion_M.Direccion(i) := car;
         i:= i+1;
         Get(entrada,car);
   end loop;
   direccion_M.Long_Direccion := i;
end LeerDireccion;

   -------------------------------------------------

procedure LeerDireccionArchivo (direccion_M : out Tipo_Direccion_Mensaje) is
-- Pre : "fichero interno es un fichero ya abierto para lectura"
-- Post : "lee la dirección que corresponde a la dirección del propietario de mensajes"
  car : Character;
  i : positive :=1;
begin
   New_Line (2);
   Put ("Escribe la direccion del archivo entre comillas y terminada en '.' ");
   New_Line;
   Put ("y a continuacion pulsa intro ");
   New_Line (2);
   Get (car);
   while not (car='.') loop
         direccion_M.Direccion(i) := car;
         i:= i+1;
         Get(car);
   end loop;
   direccion_M.Long_Direccion := i;
end LeerDireccionArchivo;

   -------------------------------------------------

procedure LeerTexto (entrada : in TipoFicheroTexto; texto : out Tipo_Texto_Mensaje) is
-- Pre : "fichero entrada es un fichero ya abierto para lectura"
-- Post : "Lee un texto que se encuentra en el fichero entrada" 
  car : Character;
  i : positive :=1;
begin
   Get (entrada, car);
   while not (car= '.') loop
         texto.Texto_Mensaje(i) := car;
         i:= i+1;
         Get (entrada, car);
   end loop;
   texto.Long_Texto := i-1;
end LeerTexto;

   -------------------------------------------------

procedure LeerFecha (entrada : in TipoFicheroTexto; fecha : out Tipo_Fecha) is
-- Pre : "fichero entrada es un fichero ya abierto para lectura"
-- Post : "lee una fecha que se encuentra en el fichero entrada"

   car:Character;

begin
   Get (entrada, car);
   Get (entrada, fecha.dia);
   Get (entrada, car);
   Get (entrada, fecha.mes);
   Get (entrada, car);
   Get (entrada, fecha.agno);
   Get (entrada, car);
   Get (entrada, car);

end LeerFecha;

   -------------------------------------------------

procedure LeerMensaje (entrada : in TipoFicheroTexto; mensaje : out Tipo_Mensaje) is
-- Pre : "fichero entrada es un fichero ya abierto para lectura"
-- Post : "lee un mensaje que se encuentra en el fichero entrada"

begin
       LeerDireccion (entrada, mensaje.Direccion_Correo_Emisor);
       LeerDireccion (entrada, mensaje.Direccion_Correo_Receptor);
       LeerFecha (entrada, mensaje.Fecha_Emision_Mensaje);
       LeerTexto (entrada, mensaje.Texto_Del_Mensaje);

end LeerMensaje;

   -------------------------------------------------

procedure LeerColeccion (entrada: in TipoFicheroTexto; Coleccion: out Tipo_Cadena) is
-- Pre : "fichero entrada es un fichero ya abierto para la lectura"
-- Post : "lee una colección de mensajes que se encuentra en el fichero entrada"
begin
      while Coleccion /= null loop
      LeerMensaje (entrada, Coleccion.Valor);
      Skip_Line (entrada);
      Coleccion := Coleccion.Siguiente;
      end loop;
end LeerColeccion;


   --*******************************************************--




   -- PROCEDIMIENTOS DE ESCRITURA :

   -------------------------------------------------

procedure EscribirDireccion (salida : in TipoFicheroTexto; direccion_M: in Tipo_Direccion_Mensaje) is
-- Pre : "fichero salida es un fichero ya creado para la escritura"
-- Post : "escribe una direccion de correo en el fichero salida"
begin
	for i in 1..direccion_M.Long_Direccion loop
		Put (salida, Direccion_M.Direccion(i));
	end loop;
end EscribirDireccion;

   -------------------------------------------------

procedure EscribirTexto (salida : in TipoFicheroTexto; texto: in Tipo_Texto_Mensaje) is
-- Pre : "fichero salida es un fichero ya creado para la escritura"
-- Post : "escribe un texto en el fichero de salida"
begin
	for i in 1..texto.Long_Texto loop
		Put (salida, texto.Texto_Mensaje(i));
    	end loop;
end EscribirTexto;

   -------------------------------------------------

procedure EscribirFecha (salida : in TipoFicheroTexto ; fecha: in Tipo_Fecha) is
-- Pre : "fichero salida es un fichero ya creado para la escritura"
-- Post : "escribe una fecha en el fichero de salida"
begin
      Put (salida, "(");
	Put (salida, fecha.Dia, 0); Put (salida, ",");
	Put (salida, fecha.Mes, 0); Put (salida, ",");
	Put (salida, fecha.Agno, 0);
      Put (salida, ")");
      Put (salida, " ");
end EscribirFecha;

   -------------------------------------------------

procedure EscribirMensaje (salida : in  TipoFicheroTexto; mensaje :in Tipo_Mensaje) is
-- Pre : "fichero salida es un fichero ya creado para la escritura"
-- Post : "escribe un mensaje en el fichero de salida"
begin
	EscribirDireccion (salida, mensaje.Direccion_Correo_Emisor);
	EscribirDireccion (salida, Mensaje.Direccion_Correo_Receptor);
     	EscribirFecha (salida, mensaje.Fecha_Emision_Mensaje);
	EscribirTexto (salida, mensaje.Texto_Del_Mensaje);
end EscribirMensaje;

   -------------------------------------------------

procedure EscribirColeccion(salida : in TipoFicheroTexto; Coleccion: in out Tipo_Cadena) is
-- Pre: "fichero salida es un fichero ya creado para la escritura"
-- Post : "escribe una colección de mensajes en el fichero de salida" 
begin
      while Coleccion /= null loop
      EscribirMensaje (salida, Coleccion.Valor);
      Coleccion := Coleccion.Siguiente;
      end loop;
end EscribirColeccion;


   --*******************************************************--




   -- FUNCIONES Y PROCEDIMIENTOS :

   -------------------------------------------------

function MensajeMasReciente (Mensaje_1, Mensaje_2 : Tipo_Mensaje) return Tipo_Mensaje is
-- Pre : cierto
-- Post : "devuelve el mensaje mas reciente entre dos mensajes" 
resultado: Tipo_Mensaje;
begin
   if Mensaje_1.Fecha_Emision_Mensaje.agno > Mensaje_2.Fecha_Emision_Mensaje.agno then resultado:= Mensaje_1;
     elsif Mensaje_1.Fecha_Emision_Mensaje.agno < Mensaje_2.Fecha_Emision_Mensaje.agno then resultado:= Mensaje_2;
     else
        if Mensaje_1.Fecha_Emision_Mensaje.mes > Mensaje_2.Fecha_Emision_Mensaje.mes then resultado:= Mensaje_1;
           elsif Mensaje_1.Fecha_Emision_Mensaje.mes < Mensaje_2.Fecha_Emision_Mensaje.mes then resultado:= Mensaje_2;
           else
              if Mensaje_1.Fecha_Emision_Mensaje.dia > Mensaje_2.Fecha_Emision_Mensaje.dia then resultado:= Mensaje_1;
              else resultado:= Mensaje_2;
              end if;
           end if;
         end if;
   return resultado;
end MensajeMasReciente;

   -------------------------------------------------

function Segundo_Mas_Reciente (Mensaje_1, Mensaje_2 : Tipo_Mensaje) return Boolean is
-- PRE: cierto
-- POST: "Devuelve cierto si el segundo mensaje es más reciente que el primero"
begin
   if Mensaje_2 = MensajeMasReciente (Mensaje_1, Mensaje_2)
      then return True;
   else return False;
   end if;
end Segundo_Mas_Reciente;


   -------------------------------------------------

procedure Intercambiar_Mensaje (Mensaje_1, Mensaje_2 : in out Tipo_Mensaje) is
-- PRE: cierto
-- POST: "Intercambia ambos mensajes"
Cambio_Por : Tipo_Mensaje := Mensaje_1;
begin
      Mensaje_1 := Mensaje_2;
      Mensaje_2 := Cambio_Por;
end Intercambiar_Mensaje;


   -------------------------------------------------

function Longitud_Cadena (Cadena : in Tipo_Cadena) return Natural is
-- Pre : cierto
-- Post : "Calcula la longitud de la lista enlazada de mensajes"
Ref_Cadena : Tipo_Cadena := Cadena;
L : Natural := 0;
begin
      while Ref_Cadena /= null loop
      L := L+1;
      Ref_Cadena := Ref_Cadena.Siguiente;
      end loop;
      return L;
end Longitud_Cadena;

   -------------------------------------------------


procedure Ordenar_Mensajes (salida : in TipoFicheroTexto; Coleccion_Mensajes : in out Tipo_Cadena) is
-- PRE: "fichero salida es un fichero ya creado para la escritura" 
-- POST: "Ordena una coleccion de mensajes por orden cronologico de mayor (mas reciente)
--         a menor (menos reciente)"
i: Natural := 1;
Cambios: Boolean := True;
begin
   while (i <= (Longitud_Cadena(Coleccion_Mensajes)-1)) and Cambios loop
         Cambios := False;
      for j in 1..(Longitud_Cadena(Coleccion_Mensajes)-1) loop
        if Segundo_Mas_Reciente (Coleccion_Mensajes.Valor,Coleccion_Mensajes.Siguiente.Valor) then
           Intercambiar_Mensaje (Coleccion_Mensajes.Valor,Coleccion_Mensajes.Siguiente.Valor);
           Cambios := True;
        end if;
      end loop;
      i := i+1;
   end loop;
   EscribirColeccion (salida, Coleccion_Mensajes);
end Ordenar_Mensajes;


   -------------------------------------------------

procedure Concatenar_Mensajes (Mensaje : in out Tipo_Mensaje; Mensajes : in out Tipo_Cadena) is
-- Pre : cierto
-- Post : concatena un mensaje con la coleccion de mensajes que tenemos.
Nuevo : Tipo_Cadena;
begin
      Nuevo := new Tipo_Celda'(Mensaje, Mensajes);
      Mensajes := Nuevo;

end Concatenar_Mensajes;


   -------------------------------------------------

function Mensaje_Salida (Direccion_Archivo : Tipo_Direccion_Mensaje; Mensaje_Enviado : Tipo_Mensaje) return Boolean is
-- PRE: cierto
-- POST: "Devuelve cierto si la direccion de correo de emisor del mensaje
--        coincide con la direccion de correo del archivo" 
begin
   if Direccion_Archivo.Direccion = Mensaje_Enviado.Direccion_Correo_Emisor.Direccion then
      return True;
   else return False;
   end if;
end Mensaje_Salida;

   -------------------------------------------------

function Mensaje_Entrada (Direccion_Archivo : Tipo_Direccion_Mensaje; Mensaje_Recibido : Tipo_Mensaje) return Boolean is
-- Pre : cierto
-- Post : "Devuelve cierto si la direccion de correo de receptor del mensaje
--         coincide con la direccion de correo del archivo"
begin
   if Direccion_Archivo.Direccion = Mensaje_Recibido.Direccion_Correo_Receptor.Direccion then
      return True;
   else return False;
   end if;
end Mensaje_Entrada;

   ------------------------------------------------- 

procedure Lista_Mensajes_Salida (fichero_interno : in TipoFicheroTexto;
          Direccion_Archivo : in Tipo_Direccion_Mensaje; Mensajes : in out Tipo_Cadena) is
-- Pre : "fichero interno es un fichero ya creado para la escritura"
-- Post : "Elige los mensajes de salida de la coleccion de mensajes totales y luego los ordena"
Coleccion : Tipo_Cadena;
begin
     Put (fichero_interno, "Mensajes de salida :");
     New_Line (fichero_interno);
     --Coleccion.Siguiente := null;
   for i in 1..(Longitud_Cadena(Mensajes)) loop
      if Mensaje_Salida (Direccion_Archivo, Mensajes.Valor) then
         Concatenar_Mensajes (Mensajes.Valor, Coleccion);
      end if;
      end loop;
      Ordenar_Mensajes (fichero_interno, Coleccion);
end Lista_Mensajes_Salida;

   -------------------------------------------------

procedure Lista_Mensajes_Entrada (fichero_interno : in TipoFicheroTexto;
          Direccion_Archivo : in Tipo_Direccion_Mensaje; Mensajes : in out Tipo_Cadena) is
-- Pre : "fichero interno es un fichero ya creado para la escritura"
-- Post : "Elige los mensajes de entrada de la coleccion de mensajes totales y luego los ordena"
Coleccion : Tipo_Cadena;
begin
     Put (fichero_interno, "Mensajes de entrada :");
     New_Line (fichero_interno);
     --Coleccion.Siguiente:= null;
   for i in 1..(Longitud_Cadena(Mensajes)) loop
      if Mensaje_Entrada (Direccion_Archivo, Mensajes.Valor) then
         Concatenar_Mensajes (Mensajes.Valor, Coleccion);
      end if;
      end loop;
      Ordenar_Mensajes (fichero_interno, Coleccion);
end Lista_Mensajes_Entrada;


   --*******************************************************--



   -- PRUEBA DEL PROGRAMA :


-- Archivo "prueba.txt"

--"Diego","Jose",(2,4,2000),"¿Qué tal te va?".
--"Jose","Diego",(3,4,2000),"Bien gracias".
--"Manu","Diego",(2,4,2000),"¿Vamos a tomar unas birras?".
--"Diego","Manu",(3,4,2000),"Tengo que terminar esta práctica".
--"Diego","Silvia",(5,5,2000),"Mañana es el cumpleaños de Jose".
--"Silvia,"Diego",(6,5,2000),"No puedo ir a la fiesta".
--"Silvia","Jose",(6,5,2000),"¡¡Felicidades, siento no poder ir!!".
--"Manu","Jose",(4,5,20000),"¡¿Vamos a tomar unas birras?".

--Mensaje1 : constant Tipo_Cadena := new Tipo_Celda'(Mensaje1, Mensaje2);
--Mensaje2 : constant Tipo_Cadena := new Tipo_Celda'(Mensaje2, Mensaje3);
--Mensaje3 : constant Tipo_Cadena := new Tipo_Celda'(Mensaje3, null);


coleccion: Tipo_Cadena;
entrada,salida: TipoFicheroTexto;
usuario : Tipo_Direccion_Mensaje;

BEGIN

   -- Create (salida, entrada, Out_File, "prueba.txt");
   -- Put (salida, Mensaje1);
   -- New_Line;
   -- Put (salida, Mensaje2);
   -- New_Line;
   -- Put (salida, Mensaje3);
   -- close (salida);

   Open (entrada,In_File, "prueba.txt");
   LeerColeccion (entrada, coleccion);

   LeerDireccionArchivo(Usuario);

   Create (salida,Out_File, "funciona.txt");
      Lista_Mensajes_Entrada (salida, usuario, coleccion);
      Lista_Mensajes_Salida (salida, usuario, coleccion);

   close (salida);
   close (entrada);


end prac4;