-- 1. histórico escolar de qualquer aluno, retornando o código e nome da disciplina, semestre e ano que a disciplina foi cursada e nota final

SELECT c.id_aluno as ra, c.codigo_disciplina, d.nome AS nome_disciplina, c.semestre, c.ano, c.media AS nota_final
FROM Cursa c
INNER JOIN Disciplina d ON c.codigo_disciplina = d.codigo_disciplina
WHERE c.id_aluno = '1' -- Substitua pelo ra do aluno desejado
ORDER BY c.ano, c.semestre;

--2. histórico de disciplinas ministradas por qualquer professor, com semestre e ano

SELECT l.id_professor, p.nome, d.codigo_disciplina, d.nome AS nome_disciplina, l.semestre, l.ano
FROM Leciona l
INNER JOIN Disciplina d ON l.codigo_disciplina = d.codigo_disciplina
INNER JOIN Professor p ON l.id_professor = p.id
WHERE l.id_professor = '2' -- Substitua pelo id do professor desejado
ORDER BY l.ano, l.semestre;

--3. listar alunos que já se formaram (foram aprovados em todos os cursos de uma matriz curricular) em um determinado semestre de um ano
--obs: na nossa universidade, um aluno pode cursar as disciplinas da matriz curricular de seu curso na ordem que desejar
--portanto, "em um determinado semestre de um ano" se refere ao semestre e ano da última disciplina cursada e aprovada pelo aluno.
--para verificar todos os alunos formados em qualquer semestre e ano, basta não informar o semestre e ano (remover WHERE)

WITH MatriculasAprovadas AS (
    SELECT a.ra, c.codigo_disciplina, c.semestre, c.ano, c.media
    FROM Aluno a
    JOIN Cursa c ON a.ra = c.id_aluno
    JOIN MatrizCurricular mc ON c.codigo_disciplina = mc.codigo_disciplina
    WHERE c.media >= 5 AND mc.id_curso = a.id_curso
),
UltimaDisciplina AS (
    SELECT ra, MAX(ano) AS ultimo_ano, MAX(semestre) AS ultimo_semestre
    FROM MatriculasAprovadas
    GROUP BY ra
),
AprovacoesPorAluno AS (
    SELECT ra, COUNT(*) AS disciplinas_aprovadas
    FROM MatriculasAprovadas
    GROUP BY ra
),
TotalDisciplinasCurso AS (
    SELECT id_curso, COUNT(*) AS total_disciplinas
    FROM MatrizCurricular
    GROUP BY id_curso
),
AlunosFormados AS (
    SELECT a.ra
    FROM Aluno a
    JOIN AprovacoesPorAluno apa ON a.ra = apa.ra
    JOIN TotalDisciplinasCurso tdc ON a.id_curso = tdc.id_curso
    WHERE apa.disciplinas_aprovadas = tdc.total_disciplinas
)
SELECT a.ra, a.nome, ud.ultimo_semestre, ud.ultimo_ano
FROM AlunosFormados af
JOIN UltimaDisciplina ud ON af.ra = ud.ra
JOIN Aluno a ON af.ra = a.ra
WHERE ud.ultimo_semestre = 2  -- Substitua pelo semestre desejado
AND ud.ultimo_ano = 2023;  -- Substitua pelo ano desejado

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