/******************************************************** ********************************
 Se crea tabla empleados para guardar la informacion sobre empleados (Debe existir previamente ESQUEMAS, TABLESPACE, TABLAS DE FORANEAS, PRUEBAS EN pl solo el codigo, ejecucion por batch todo el archivo como sqlplus)
 Realizado por: Breiner Sanchez Martinez
 Fecha: Mayo 2023
******************************************************************************************/
CREATE TABLE ods_stag.empleados (
		identificacion	VARCHAR2(10) NOT NULL PRIMARY KEY,
		Nombre					VARCHAR2(100)	NOT	NULL,
		Salario					NUMERIC(10,2)	NOT	NULL CONSTRAINT SALAR_POSIT CHECK (Salario >= 0),
		Auxilio					NUMERIC(8,2)	NOT	NULL CONSTRAINT AUX_POSIT CHECK (Auxilio >= 0),
		Codigo					VARCHAR2(7)	NOT	NULL,
		Dependencia				NUMERIC(3) NOT NULL,
		CONSTRAINT fk_dependencia FOREIGN KEY (Dependencia) REFERENCES DEPENDENCIAS(dependencia)
		)
tablespace pdods_datos
  pctfree 10
  pctused 40
  initrans 1
  maxtrans 255
  storage
  (
    initial 51200 K
    next 10240 K
    minextents 1
    maxextents unlimited
    pctincrease 0
);
--Comentarios de la tabla
COMMENT ON TABLE ods_stag.empleados
			  IS 'Tabla donde se almacena la informacion sobre los empleados';
-- Comentarios de columnas
COMMENT ON COLUMN ods_stag.empleados.identificacion
			IS 'Identificacion del Empleado';
COMMENT ON COLUMN ods_stag.empleados.Nombre
			IS 'Nombre del Empleado';
COMMENT ON COLUMN ods_stag.empleados.Salario
			IS 'Salario del Empleado';
COMMENT ON COLUMN ods_stag.empleados.Auxilio
			IS 'Valor del auxilio que se le da al empeleado';
COMMENT ON COLUMN ods_stag.empleados.Codigo
            IS 'Codigo asigando al Empleado';
COMMENT ON COLUMN ods_stag.empleados.Dependencia
							IS 'Dependencia a la que pertenece el Empleado';

CREATE INDEX idx_Codigo
		  ON ods_stag.empleados(Codigo)
					tablespace pdods_idx
						pctfree 10
						storage (
						   	initial 1024 K
						   	next 10240 K
						    minextents 1
						    maxextents unlimited
						    pctincrease 0
										)
				LOGGING;
COMMIT;
