-- 1. Histórico escolar de qualquer aluno

SELECT *
FROM Cursa;

SELECT d.codigo_disciplina, d.nome AS nome_disciplina, c.semestre, c.ano, c.media AS nota_final
FROM Cursa c
JOIN Disciplina d ON c.codigo_disciplina = d.codigo_disciplina
WHERE c.id_aluno = '411137319';

--2. Histórico de disciplinas ministradas por qualquer professor

SELECT *
FROM Leciona;

SELECT d.codigo_disciplina, d.nome AS nome_disciplina, l.semestre, l.ano
FROM Leciona l
JOIN Disciplina d ON l.codigo_disciplina = d.codigo_disciplina
WHERE l.id_professor = '672891314';

--3. listar alunos que já se formaram (foram aprovados em todos os cursos de uma matriz curricular) em um determinado semestre de um ano


--4. listar todos os professores que são chefes de departamento, junto com o nome do departamento

SELECT *
FROM ChefeDepartamento;

SELECT p.id, p.nome, d.nome_departamento
FROM Professor p
JOIN ChefeDepartamento d ON p.id = d.id_professor;

--5. saber quais alunos formaram um grupo de TCC e qual professor foi o orientador

SELECT *
FROM GrupoTCC;

SELECT g.id_grupo, a.ra, a.nome, p.nome
FROM GrupoTCC g
JOIN Aluno a ON g.ra = a.ra
JOIN Professor p ON g.id_professor = p.id;
