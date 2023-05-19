/******************************************************** ********************************
 Se crea procedimiento para obtener el nombre de las tablas que son referenciadas por una tabla enviada al procedimiento -- se devuelve un cursor con la informacion con la información
 Realizado por: Breiner Sanchez Martinez
 Fecha: Mayo 2023
******************************************************************************************/

PROMPT CREATE OR REPLACE PROCEDURE ods_stag.sp_cons_dic_tabl_ref
CREATE OR REPLACE PROCEDURE ods_stag.sp_cons_dic_tabl_ref (tabla IN varchar2, v_cod_respuesta OUT VARCHAR2,  v_msj_respuesta OUT VARCHAR2, c_resultado OUT SYS_REFCURSOR) IS

-- definición de variables
v_Table   VARCHAR2 (32);

BEGIN
-- asignacion de variables
	v_table := REPLACE(Tabla, ' ', '');
	v_msj_respuesta := '0';
	v_cod_respuesta := 'consulta Exitosa';

-- Realiza la consulta de los nombres de las tablas  
	OPEN c_resultado FOR
	
		SELECT table_name
		  FROM  all_constraints
		 WHERE CONSTRAINT_TYPE = 'R'
		   AND R_CONSTRAINT_NAME IN ( SELECT constraint_name 
									    FROM all_constraints
									   WHERE constraint_type in ('P', 'U')
									     AND table_name = v_table
										 );
--Manejo de excepciones	
EXCEPTION
	WHEN OTHERS THEN
		v_msj_respuesta := '500';
		v_cod_respuesta := 'Error inesperado en el servidor';
	RETURN;

END sp_cons_dic_tabl_ref;
/
