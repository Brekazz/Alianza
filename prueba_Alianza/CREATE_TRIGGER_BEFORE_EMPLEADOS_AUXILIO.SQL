 /******************************************************** ********************************
  Se crea TRIGGER para actualizar la informacion del empleados y se asigna el auxilio de acuerdo con su salario
  Realizado por: Breiner Sanchez Martinez
  Fecha: Mayo 2023
 ******************************************************************************************/

CREATE OR REPLACE TRIGGER before_empleados_auxilio
BEFORE INSERT OR UPDATE
ON empleados
FOR EACH ROW
BEGIN
	    IF :NEW.salario < 500000 then
			:NEW.auxilio := (:NEW.salario) * 0.05;
		ELSE
			:NEW.auxilio := 0;
		END IF;
END;
/
