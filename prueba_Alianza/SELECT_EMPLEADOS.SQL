/******************************************************** ********************************
 Se crea Select para extraer el nombre de los empleados cuyo salario es mayor que el salario promedio de su dependencia
 Realizado por: Breiner Sanchez Martinez
 Fecha: Mayo 2023
******************************************************************************************/
SELECT e.nombre Nombre
  FROM ODS_STAG.empleados e, (SELECT Dependencia D, AVG(salario) S from ODS_STAG.empleados Group by Dependencia ) Q
 WHERE e.salario > Q.S and e.dependencia = Q.D;
