-- 1. histórico escolar de qualquer aluno,retornando o código e nome da disciplina, semestre e ano que a disciplina foi cursada e nota final

SELECT *
FROM Cursa;

SELECT d.codigo_disciplina, d.nome AS nome_disciplina, c.semestre, c.ano, c.media AS nota_final
FROM Cursa c
INNER JOIN Disciplina d ON c.codigo_disciplina = d.codigo_disciplina
WHERE c.id_aluno = '411137319';

--2. histórico de disciplinas ministradas por qualquer professor, com semestre e ano

SELECT *
FROM Leciona;

SELECT d.codigo_disciplina, d.nome AS nome_disciplina, l.semestre, l.ano
FROM Leciona l
INNER JOIN Disciplina d ON l.codigo_disciplina = d.codigo_disciplina
WHERE l.id_professor = '672891314';

--3. listar alunos que já se formaram (foram aprovados em todos os cursos de uma matriz curricular) em um determinado semestre de um ano

SELECT *
FROM Cursa;

WITH CursosAprovados AS (
    SELECT c.id_aluno, c.semestre, c.ano
    FROM Cursa c
    WHERE c.media >= 5
    GROUP BY c.id_aluno, c.semestre, c.ano
)
SELECT a.ra, a.nome, c.semestre, c.ano
FROM Aluno a
INNER JOIN CursosAprovados c ON a.ra = c.id_aluno
WHERE c.semestre = 1 AND c.ano = 2020;

--4. listar todos os professores que são chefes de departamento, junto com o nome do departamento

SELECT *
FROM ChefeDepartamento;

SELECT p.id, p.nome, d.nome_departamento
FROM Professor p
INNER JOIN ChefeDepartamento d ON p.id = d.id_professor;

--5. saber quais alunos formaram um grupo de TCC e qual professor foi o orientador

SELECT *
FROM GrupoTCC;

SELECT g.id_grupo, a.ra, a.nome, p.nome
FROM GrupoTCC g
INNER JOIN Aluno a ON g.ra = a.ra
INNER JOIN Professor p ON g.id_professor = p.id;

-------------------------------------
DROP TABLE GrupoTCC;
DROP TABLE Leciona;
DROP TABLE Cursa;
DROP TABLE MatrizCurricular;
DROP TABLE Disciplina;
DROP TABLE Curso;
DROP TABLE Aluno;
DROP TABLE ChefeDepartamento;
DROP TABLE Professor;
DROP TABLE Departamento;
