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
    media NUMERIC(2, 2),
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
