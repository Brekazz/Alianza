/******************************************************** ********************************
 Procedimiento almacenado para crear archivis con los estudiantes admitidos, que queda en la ruta F:/INFORMES/ESTUDIANTES_ADMITIDOS del servidor
 Realizado por: Breiner Sanchez Martinez
 Fecha: Mayo 2023
******************************************************************************************/
PROMPT CREATE OR REPLACE PROCEDURE ods_stag.sp_estudiantes_admitidos
CREATE OR REPLACE PROCEDURE ods_stag.sp_estudiantes_admitidos AS
-- definicion de variables
Lv_LineaTexto      	VARCHAR2(4000)		:= null;
Pv_path             VARCHAR2(7)        	;
Lt_Archivo          Utl_File.File_Type 	;
v_nom_archivo       varchar2(50)       	;
v_date              VARCHAR2(8)        	;


-- Cursor de estudiantes admitidos
CURSOR C_INFO_ESTUDIANTES IS
		SELECT 	AD.T_IDENTIFICACION,
						AD.IDENTIFICACION,
	 					A.NOMBRE,
						A.APELLIDO,
						C.CARRERA
						A.CORREO,
						A.TELEFONO
		  FROM ODS_STAG.ESTUDIANTES_ADMITIDOS AD INNER JOIN ASPIRANTES AS A
			  ON AD.IDENTIFICACION = A.IDENTIFICACION INNER JOIN CARRERAS C ON C.IDENTIFICADOR_CARRERA = AD.IDENTIFICADOR_CARRERA
		 WHERE AD.T_IDENTIFICACION = A.T_IDENTIFICACION;

TYPE R_ESTUDIANTES_ADMITIDOS IS TABLE OF C_INFO_ESTUDIANTES%ROWTYPE INDEX BY PLS_INTEGER;
VR_ESTUDIANTES_ADMITIDOS R_ESTUDIANTES_ADMITIDOS;

--Inicia Creacion del archivo
BEGIN
DBMS_OUTPUT.PUT_LINE ('Inicia proceso');
	SELECT TO_CHAR(LAST_DAY(TO_DATE(ADD_MONTHS( SYSDATE, -1))), 'YYYYMMDD')
	  INTO V_DATE
	  FROM DUAL;
 	Pv_Path     := 'F:/INFORMES/ESTUDIANTES_ADMITIDOS';
  v_nom_archivo   := 'EST_ADMIT'||V_DATE||'.TXT';
BEGIN
		Lt_Archivo    := Utl_File.FOpen(Pv_Path, v_nom_archivo, 'w');

    EXCEPTION
		WHEN UTL_FILE.INVALID_FILEHANDLE THEN
			UTL_FILE.FCLOSE(Lt_Archivo);
			RAISE_APPLICATION_ERROR(-2000, 'ARCHIVO INVALIDO');
		WHEN UTL_FILE.INVALID_PATH THEN
			UTL_FILE.FCLOSE(Lt_Archivo);
			RAISE_APPLICATION_ERROR(-20003, 'DIRECTORIO NO EXISTE');
			WHEN UTL_FILE.INVALID_MODE THEN
			UTL_FILE.FCLOSE(Lt_Archivo);
			RAISE_APPLICATION_ERROR(-20003, 'APERTURA ERRADA ');
END;
-- se recorre el cursor y se realiza la escritura del archivo
	OPEN C_INFO_ESTUDIANTES;
		LOOP
			FETCH C_INFO_ESTUDIANTES BULK COLLECT INTO VR_ESTUDIANTES_ADMITIDOS LIMIT 500;
				IF VR_ESTUDIANTES_ADMITIDOS.COUNT > 0 THEN
					FOR I IN 1 .. VR_ESTUDIANTES_ADMITIDOS.COUNT
						LOOP
							Lv_LineaTexto :=	VR_ESTUDIANTES_ADMITIDOS(I).T_IDENTIFICACION 	||';'||
												VR_ESTUDIANTES_ADMITIDOS(I).IDENTIFICACION	   	||';'||
												VR_ESTUDIANTES_ADMITIDOS(I).NOMBRE     			||';'||
												VR_ESTUDIANTES_ADMITIDOS(I).APELLIDO      		||';'||
												VR_ESTUDIANTES_ADMITIDOS(I).CARRERA      		||';'||
												VR_ESTUDIANTES_ADMITIDOS(I).CORREO      		||';'||
												VR_ESTUDIANTES_ADMITIDOS(I).TELEFONO       		||CHR(13);
							Utl_File.Put_line(Lt_Archivo, Lv_LineaTexto);
							Lv_LineaTexto :=Null;
						END LOOP;
				ELSE
					Lv_LineaTexto := 'NO HAY ESTUDIANTES ADMITIDOS HASTA EL MOMENTO'||chr(13);
					Utl_File.Put_line(Lt_Archivo, Lv_LineaTexto);
				END IF;
			EXIT WHEN C_INFO_ESTUDIANTES%NOTFOUND;
		END LOOP;
DBMS_OUTPUT.PUT_LINE ('	Crea Archivo: ' || v_nom_archivo);
   CLOSE C_INFO_ESTUDIANTES;

Utl_File.Fclose(Lt_Archivo);
-- manejo de excepciones
EXCEPTION
	WHEN NO_DATA_FOUND THEN
		RAISE_APPLICATION_ERROR(SUBSTR(SQLERRM, 1 , 9),SUBSTR(SQLERRM, 12 , LENGTH(SQLERRM)-1));
	WHEN VALUE_ERROR THEN
		RAISE_APPLICATION_ERROR(SUBSTR(SQLERRM, 1 , 9),SUBSTR(SQLERRM, 12 , LENGTH(SQLERRM)-1));

DBMS_OUTPUT.PUT_LINE ('Finaliza proceso');

END sp_estudiantes_admitidos;
/
