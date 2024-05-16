-- Criação da tabela Departamento
CREATE TABLE Departamento (
    nome_departamento VARCHAR(20) PRIMARY KEY
);

-- Criação da tabela Professor
CREATE TABLE Professor (
    id VARCHAR(9) PRIMARY KEY,
    nome_departamento VARCHAR(20),
    nome VARCHAR(50),
    email VARCHAR(50),
    telefone VARCHAR(13),
    salario NUMERIC(8, 2),
    FOREIGN KEY (nome_departamento) REFERENCES Departamento(nome_departamento)
);

-- Criação da tabela ChefeDepartamento
CREATE TABLE ChefeDepartamento (
    id_professor VARCHAR(9) PRIMARY KEY,
    nome_departamento VARCHAR(20),
    FOREIGN KEY (id_professor) REFERENCES Professor(id),
    FOREIGN KEY (nome_departamento) REFERENCES Departamento(nome_departamento)
);

-- Criação da tabela Aluno
CREATE TABLE Aluno (
    ra VARCHAR(9) PRIMARY KEY,
    nome_departamento VARCHAR(20),
    nome VARCHAR(50),
    email VARCHAR(50),
    telefone VARCHAR(13),
    FOREIGN KEY (nome_departamento) REFERENCES Departamento(nome_departamento)
);

-- Criação da tabela Curso
CREATE TABLE Curso (
    id_curso VARCHAR(9) PRIMARY KEY,
    nome_departamento VARCHAR(20),
    horas_complementares NUMERIC(3),
    faltas NUMERIC(2),
    FOREIGN KEY (nome_departamento) REFERENCES Departamento(nome_departamento)
);

-- Criação da tabela Disciplina
CREATE TABLE Disciplina (
    codigo_disciplina VARCHAR(6) PRIMARY KEY,
    nome_departamento VARCHAR(20),
    nome VARCHAR(20),
    carga_horaria NUMERIC(3),
    FOREIGN KEY (nome_departamento) REFERENCES Departamento(nome_departamento)
);

-- Criação da tabela MatrizCurricular
CREATE TABLE MatrizCurricular (
    codigo_disciplina VARCHAR(6),
    id_curso VARCHAR(9),
    PRIMARY KEY (codigo_disciplina, id_curso),
    FOREIGN KEY (codigo_disciplina) REFERENCES Disciplina(codigo_disciplina),
    FOREIGN KEY (id_curso) REFERENCES Curso(id_curso)
);

-- Criação da tabela Cursa
CREATE TABLE Cursa (
    id_aluno VARCHAR(9),
    id_curso VARCHAR(9),
    codigo_disciplina VARCHAR(6),
    semestre NUMERIC(1),
    ano NUMERIC(4),
    media NUMERIC(4, 2),
    faltas NUMERIC(2),
    PRIMARY KEY (semestre, ano),
    FOREIGN KEY (id_aluno) REFERENCES Aluno(ra),
    FOREIGN KEY (id_curso) REFERENCES Curso(id_curso),
    FOREIGN KEY (codigo_disciplina) REFERENCES Disciplina(codigo_disciplina)
);

-- Criação da tabela Leciona
CREATE TABLE Leciona (
    id_professor VARCHAR(9),
    id_curso VARCHAR(9),
    codigo_disciplina VARCHAR(6),
    semestre NUMERIC(1),
    ano NUMERIC(4),
    carga_horaria NUMERIC(3),
    PRIMARY KEY (semestre,ano),
    FOREIGN KEY (id_professor) REFERENCES Professor(id),
    FOREIGN KEY (id_curso) REFERENCES Curso(id_curso),
    FOREIGN KEY (codigo_disciplina) REFERENCES Disciplina(codigo_disciplina)
);

-- Criação da tabela GrupoTCC
CREATE TABLE GrupoTCC (
    id_grupo INT PRIMARY KEY,
    id_professor VARCHAR(9),
    ra VARCHAR(9),
    FOREIGN KEY (id_professor) REFERENCES Professor(id),
    FOREIGN KEY (ra) REFERENCES Aluno(ra)
);

-- Queries de busca

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
