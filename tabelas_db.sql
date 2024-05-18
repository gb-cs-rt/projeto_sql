-- Criação da tabela Departamento
CREATE TABLE IF NOT EXISTS Departamento (
    nome_departamento VARCHAR(30) PRIMARY KEY
);

-- Criação da tabela Professor
CREATE SEQUENCE professor_id_seq START 1;
    
CREATE TABLE IF NOT EXISTS Professor (
    id INTEGER PRIMARY KEY DEFAULT nextval('professor_id_seq'),
    nome_departamento VARCHAR(30),
    nome VARCHAR(50),
    email VARCHAR(50),
    telefone VARCHAR(20),
    salario NUMERIC(8, 2),
    FOREIGN KEY (nome_departamento) REFERENCES Departamento(nome_departamento)
);

-- Criação da tabela ChefeDepartamento
CREATE TABLE IF NOT EXISTS ChefeDepartamento (
    id_professor INTEGER PRIMARY KEY,
    nome_departamento VARCHAR(30),
    FOREIGN KEY (id_professor) REFERENCES Professor(id),
    FOREIGN KEY (nome_departamento) REFERENCES Departamento(nome_departamento)
);

-- Criação da tabela Curso
CREATE SEQUENCE curso_id_seq START 1;

CREATE TABLE IF NOT EXISTS Curso (
    id_curso INTEGER PRIMARY KEY DEFAULT nextval('curso_id_seq'),
    nome VARCHAR(30),
    nome_departamento VARCHAR(30),
    horas_complementares NUMERIC(3),
    faltas NUMERIC(2),
    FOREIGN KEY (nome_departamento) REFERENCES Departamento(nome_departamento)
);

-- Criação da tabela Aluno
CREATE SEQUENCE aluno_ra_seq START 1;

CREATE TABLE IF NOT EXISTS Aluno (
    ra INTEGER PRIMARY KEY DEFAULT nextval('aluno_ra_seq'),
    id_curso INTEGER,
    nome VARCHAR(50),
    email VARCHAR(50),
    telefone VARCHAR(20),
    FOREIGN KEY (id_curso) REFERENCES Curso(id_curso)
);

-- Criação da tabela Disciplina
CREATE TABLE IF NOT EXISTS Disciplina (
    codigo_disciplina VARCHAR(6) PRIMARY KEY,
    nome_departamento VARCHAR(30),
    nome VARCHAR(40),
    carga_horaria NUMERIC(3),
    FOREIGN KEY (nome_departamento) REFERENCES Departamento(nome_departamento)
);

-- Criação da tabela MatrizCurricular
CREATE TABLE IF NOT EXISTS MatrizCurricular (
    codigo_disciplina VARCHAR(6),
    id_curso INTEGER,
    PRIMARY KEY (codigo_disciplina, id_curso),
    FOREIGN KEY (codigo_disciplina) REFERENCES Disciplina(codigo_disciplina),
    FOREIGN KEY (id_curso) REFERENCES Curso(id_curso)
);

-- Criação da tabela Cursa
CREATE TABLE IF NOT EXISTS Cursa (
    id_aluno INTEGER,
    id_curso INTEGER,
    codigo_disciplina VARCHAR(6),
    semestre NUMERIC(1),
    ano NUMERIC(4),
    media NUMERIC(4, 2),
    faltas NUMERIC(2),
    PRIMARY KEY (id_aluno, codigo_disciplina),
    FOREIGN KEY (id_aluno) REFERENCES Aluno(ra),
    FOREIGN KEY (id_curso) REFERENCES Curso(id_curso),
    FOREIGN KEY (codigo_disciplina) REFERENCES Disciplina(codigo_disciplina)
);

-- Criação da tabela Leciona
CREATE TABLE IF NOT EXISTS Leciona (
    id_professor INTEGER,
    id_curso INTEGER,
    codigo_disciplina VARCHAR(6),
    semestre NUMERIC(1),
    ano NUMERIC(4),
    carga_horaria NUMERIC(3),
    PRIMARY KEY (id_professor, codigo_disciplina),
    FOREIGN KEY (id_professor) REFERENCES Professor(id),
    FOREIGN KEY (id_curso) REFERENCES Curso(id_curso),
    FOREIGN KEY (codigo_disciplina) REFERENCES Disciplina(codigo_disciplina)
);

-- Criação da tabela GrupoTCC
CREATE TABLE IF NOT EXISTS GrupoTCC (
    id_grupo INTEGER,
    id_professor INTEGER,
    ra INTEGER,
    PRIMARY KEY (id_grupo, ra),
    FOREIGN KEY (id_professor) REFERENCES Professor(id),
    FOREIGN KEY (ra) REFERENCES Aluno(ra)
);
