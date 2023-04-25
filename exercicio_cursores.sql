CREATE DATABASE exercicio_cursores
GO

USE exercicio_cursores
GO

CREATE TABLE Curso (
codigo           INT         NOT NULL,
nome             VARCHAR(50) NULL,
duracao          INT         NULL
PRIMARY KEY(codigo)
)
GO

CREATE TABLE Disciplina (
codigo         CHAR(6)           NOT NULL,
nome           VARCHAR(50)   NULL,
carga_horaria        INT           NULL,
PRIMARY KEY(codigo)
)
GO



CREATE TABLE Curso_Disciplina (
codigo_disciplina  CHAR(6)      NOT NULL,
codigo_curso   INT          NOT NULL
PRIMARY KEY(codigo_curso, codigo_disciplina)
FOREIGN KEY(codigo_disciplina) REFERENCES Disciplina(codigo),
FOREIGN KEY(codigo_curso) REFERENCES Curso(codigo)
)
GO

/*
Criar uma UDF (Function) cuja entrada é o código do curso e, com um cursor, monte uma
tabela de saída com as informações do curso que é parâmetro de entrada.
(Código_Disciplina | Nome_Disciplina | Carga_Horaria_Disciplina | Nome_Curso)
*/
DROP FUNCTION fn_cursor

CREATE FUNCTION fn_cursor(@codigo_curso INT)
RETURNS @tabela TABLE (
codigo_disciplina     CHAR(6),
nome_disciplina       VARCHAR(50),
carga_horaria_disciplina INT,
nome_curso  VARCHAR(50)
)
AS
BEGIN
     DECLARE @codigo_disciplina VARCHAR(6) 

     DECLARE c CURSOR FOR 
	 SELECT codigo_curso,
	        codigo_disciplina
	 FROM Curso_Disciplina 
	 WHERE codigo_curso = @codigo_curso

     OPEN C
	 FETCH NEXT FROM C INTO  @codigo_curso, @codigo_disciplina
     WHILE @@FETCH_STATUS = 0
	 BEGIN

     INSERT INTO @tabela (codigo_disciplina, nome_disciplina, carga_horaria_disciplina, nome_curso) 
	 SELECT 
	        d.codigo, 
	        d.nome, 
			d.carga_horaria, 
			c.nome 
	 FROM Curso c, Disciplina d, Curso_Disciplina cd 
	 WHERE c.codigo = cd.codigo_curso
	   AND d.codigo = cd.codigo_disciplina
	   AND c.codigo = @codigo_curso
	   AND d.codigo = @codigo_disciplina

       
	   FETCH NEXT FROM C INTO @codigo_curso, @codigo_disciplina  
	   
	 END
	 
	 CLOSE C
	 DEALLOCATE C
     RETURN
END

SELECT DISTINCT * FROM fn_cursor(51)

SELECT * FROM fn_cursor(48)

SELECT d.codigo, 
	   d.nome, 
	   d.carga_horaria,
	   c.nome 
FROM Curso c, Disciplina d, Curso_Disciplina cd 
WHERE c.codigo = cd.codigo_curso
  AND d.codigo = cd.codigo_disciplina
  AND c.codigo = 51

SELECT * FROM Curso
SELECT * FROM Disciplina
SELECT * FROM Curso_Disciplina

