-- 1. histórico escolar de qualquer aluno,retornando o código e nome da disciplina, semestre e ano que a disciplina foi cursada e nota final

SELECT c.id_aluno as ra, c.codigo_disciplina, d.nome AS nome_disciplina, c.semestre, c.ano, c.media AS nota_final
FROM Cursa c
INNER JOIN Disciplina d ON c.codigo_disciplina = d.codigo_disciplina
WHERE c.id_aluno = '1'
ORDER BY c.ano, c.semestre;

--2. histórico de disciplinas ministradas por qualquer professor, com semestre e ano

SELECT l.id_professor, p.nome, d.codigo_disciplina, d.nome AS nome_disciplina, l.semestre, l.ano
FROM Leciona l
INNER JOIN Disciplina d ON l.codigo_disciplina = d.codigo_disciplina
INNER JOIN Professor p ON l.id_professor = p.id
WHERE l.id_professor = '2'
ORDER BY l.ano, l.semestre;

--3. listar alunos que já se formaram (foram aprovados em todos os cursos de uma matriz curricular) em um determinado semestre de um ano

WITH TotalDisciplinas AS (
    SELECT id_aluno, COUNT(codigo_disciplina) AS total_disciplinas
    FROM Cursa
    WHERE semestre = 1 AND ano = 2021
    GROUP BY id_aluno
),
DisciplinasAprovadas AS (
    SELECT id_aluno, COUNT(codigo_disciplina) AS disciplinas_aprovadas
    FROM Cursa
    WHERE media >= 5 AND semestre = 1 AND ano = 2021
    GROUP BY id_aluno
)
SELECT a.ra, a.nome
FROM Aluno a
INNER JOIN TotalDisciplinas t ON a.ra = t.id_aluno
INNER JOIN DisciplinasAprovadas d ON a.ra = d.id_aluno
WHERE t.total_disciplinas = d.disciplinas_aprovadas;

--4. listar todos os professores que são chefes de departamento, junto com o nome do departamento

SELECT d.nome_departamento, p.nome as chefe, p.id
FROM Professor p
INNER JOIN ChefeDepartamento d ON p.id = d.id_professor;

--5. saber quais alunos formaram um grupo de TCC e qual professor foi o orientador

SELECT g.id_grupo, a.ra, a.nome as nome_aluno, p.nome as orientador
FROM GrupoTCC g
INNER JOIN Aluno a ON g.ra = a.ra
INNER JOIN Professor p ON g.id_professor = p.id
ORDER BY g.id_grupo;
