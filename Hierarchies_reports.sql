--Creo la tabla de empleados
CREATE TABLE empleados
    ([id] int, [id_manager] int, [nombre] nvarchar(30), [nombre_manager] nvarchar(30))
;

INSERT INTO empleados
    ([id] , [id_manager], [nombre], [nombre_manager])
VALUES
    (1, null, 'Fredi', null),
    (2, 1, 'Mafi', 'Fredi'),
    (3, 1, 'Diego', 'Fredi'),
    (4, 2, 'Sofy', 'Mafi'),
    (5, 4, 'Tomy', 'Sofy');
	
--El objetivo es llegar a una tabla en la que figure el Manager y la cantidad de subordinados TOTALES de cada uno. 
--Debería dar: Fredi 4, Mafi 2, Sofy 1, Diego 0, Tomy 0.

--Creo la CTE recursiva que construye la jerarquía de gerentes y subordinados.
WITH Managers AS (
--Selecciono los nombres de los generentes que no sean nulos, asigno el nivel jerarquico y el nombre. 
  SELECT
    nombre_manager as base_manager 
  , 1 as nivel
  , nombre
  , nombre_manager as direct_manager
  FROM empleados
  WHERE nombre_manager IS NOT NULL
  
  --Parte recursiva. Uno la tabla empleados con la vista de Managers de manera que los gerentes coincidan con los empleados, incrementando el nivel en cada recursión.
  UNION ALL
  
  SELECT
    m.base_manager
  , m.nivel + 1
  , emp.nombre
  , emp.nombre_manager
  FROM Managers m
  JOIN empleados emp
    ON emp.nombre_manager = m.nombre
)

--Ejecuto la consulta de manera que el nombre de los gerentes en mgr coincidan con el nombre de los empleados en emp. Ordeno por numero de subordinados y nombre.
SELECT 
  emp.nombre
, COUNT(mgr.nombre) AS subordinates
FROM empleados emp
LEFT JOIN Managers mgr 
  ON mgr.base_manager = emp.nombre
GROUP BY emp.nombre
ORDER BY COUNT(mgr.nombre) DESC, emp.nombre;

