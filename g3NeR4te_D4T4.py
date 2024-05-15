import sqlite3
from faker import Faker
import random

# Initialize Faker for generating random data
fake = Faker()

# Connect to the SQLite database (replace with your DB connection)
conn = sqlite3.connect('university.db')
cursor = conn.cursor()

# Create tables
tables = [
    """
    CREATE TABLE IF NOT EXISTS Departamento (
        nome_departamento VARCHAR(20) PRIMARY KEY
    );
    """,
    """
    CREATE TABLE IF NOT EXISTS Professor (
        id VARCHAR(9) PRIMARY KEY,
        nome_departamento VARCHAR(20),
        nome VARCHAR(50),
        email VARCHAR(50),
        telefone VARCHAR(13),
        salario NUMERIC(8, 2),
        FOREIGN KEY (nome_departamento) REFERENCES Departamento(nome_departamento)
    );
    """,
    """
    CREATE TABLE IF NOT EXISTS ChefeDepartamento (
        id_professor VARCHAR(9) PRIMARY KEY,
        nome_departamento VARCHAR(20),
        FOREIGN KEY (id_professor) REFERENCES Professor(id),
        FOREIGN KEY (nome_departamento) REFERENCES Departamento(nome_departamento)
    );
    """,
    """
    CREATE TABLE IF NOT EXISTS Aluno (
        ra VARCHAR(9) PRIMARY KEY,
        nome_departamento VARCHAR(20),
        nome VARCHAR(50),
        email VARCHAR(50),
        telefone VARCHAR(13),
        FOREIGN KEY (nome_departamento) REFERENCES Departamento(nome_departamento)
    );
    """,
    """
    CREATE TABLE IF NOT EXISTS Curso (
        id_curso VARCHAR(9) PRIMARY KEY,
        nome_departamento VARCHAR(20),
        horas_complementares NUMERIC(3),
        faltas NUMERIC(2),
        FOREIGN KEY (nome_departamento) REFERENCES Departamento(nome_departamento)
    );
    """,
    """
    CREATE TABLE IF NOT EXISTS Disciplina (
        codigo_disciplina VARCHAR(6) PRIMARY KEY,
        nome_departamento VARCHAR(20),
        nome VARCHAR(20),
        carga_horaria NUMERIC(3),
        FOREIGN KEY (nome_departamento) REFERENCES Departamento(nome_departamento)
    );
    """,
    """
    CREATE TABLE IF NOT EXISTS MatrizCurricular (
        codigo_disciplina VARCHAR(6),
        id_curso VARCHAR(9),
        PRIMARY KEY (codigo_disciplina, id_curso),
        FOREIGN KEY (codigo_disciplina) REFERENCES Disciplina(codigo_disciplina),
        FOREIGN KEY (id_curso) REFERENCES Curso(id_curso)
    );
    """,
    """
    CREATE TABLE IF NOT EXISTS Cursa (
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
    """,
    """
    CREATE TABLE IF NOT EXISTS Leciona (
        id_professor VARCHAR(9),
        id_curso VARCHAR(9),
        codigo_disciplina VARCHAR(6),
        semestre NUMERIC(1),
        ano NUMERIC(4),
        carga_horaria NUMERIC(3),
        PRIMARY KEY (semestre, ano),
        FOREIGN KEY (id_professor) REFERENCES Professor(id),
        FOREIGN KEY (id_curso) REFERENCES Curso(id_curso),
        FOREIGN KEY (codigo_disciplina) REFERENCES Disciplina(codigo_disciplina)
    );
    """,
    """
    CREATE TABLE IF NOT EXISTS GrupoTCC (
        id_grupo INT PRIMARY KEY,
        id_professor VARCHAR(9),
        ra VARCHAR(9),
        FOREIGN KEY (id_professor) REFERENCES Professor(id),
        FOREIGN KEY (ra) REFERENCES Aluno(ra)
    );
    """
]

for table in tables:
    cursor.execute(table)

# Insert data into Departamento
departamentos = ['Science', 'Arts', 'Engineering', 'Mathematics']
for dep in departamentos:
    cursor.execute("INSERT INTO Departamento (nome_departamento) VALUES (?)", (dep,))

# Insert data into Professor
for _ in range(10):
    id_prof = fake.unique.ssn()
    nome_dep = random.choice(departamentos)
    nome = fake.name()
    email = fake.email()
    telefone = fake.phone_number()
    salario = round(random.uniform(3000, 10000), 2)
    cursor.execute("""
        INSERT INTO Professor (id, nome_departamento, nome, email, telefone, salario) 
        VALUES (?, ?, ?, ?, ?, ?)
    """, (id_prof, nome_dep, nome, email, telefone, salario))

# Insert data into Aluno
for _ in range(50):
    ra = fake.unique.ssn()
    nome_dep = random.choice(departamentos)
    nome = fake.name()
    email = fake.email()
    telefone = fake.phone_number()
    cursor.execute("""
        INSERT INTO Aluno (ra, nome_departamento, nome, email, telefone) 
        VALUES (?, ?, ?, ?, ?)
    """, (ra, nome_dep, nome, email, telefone))

# Insert data into Curso
for _ in range(5):
    id_curso = fake.unique.ssn()
    nome_dep = random.choice(departamentos)
    horas_complementares = random.randint(20, 50)
    faltas = random.randint(0, 10)
    cursor.execute("""
        INSERT INTO Curso (id_curso, nome_departamento, horas_complementares, faltas) 
        VALUES (?, ?, ?, ?)
    """, (id_curso, nome_dep, horas_complementares, faltas))

# Insert data into Disciplina
for _ in range(15):
    codigo_disciplina = fake.unique.bothify(text='??###')
    nome_dep = random.choice(departamentos)
    nome = fake.word()
    carga_horaria = random.randint(30, 60)
    cursor.execute("""
        INSERT INTO Disciplina (codigo_disciplina, nome_departamento, nome, carga_horaria) 
        VALUES (?, ?, ?, ?)
    """, (codigo_disciplina, nome_dep, nome, carga_horaria))

# Insert data into MatrizCurricular
disciplinas = cursor.execute("SELECT codigo_disciplina FROM Disciplina").fetchall()
cursos = cursor.execute("SELECT id_curso FROM Curso").fetchall()
for _ in range(20):
    codigo_disciplina = random.choice(disciplinas)[0]
    id_curso = random.choice(cursos)[0]
    cursor.execute("""
        INSERT INTO MatrizCurricular (codigo_disciplina, id_curso) 
        VALUES (?, ?)
    """, (codigo_disciplina, id_curso))

# Insert data into Cursa
alunos = cursor.execute("SELECT ra FROM Aluno").fetchall()
for _ in range(30):
    id_aluno = random.choice(alunos)[0]
    id_curso = random.choice(cursos)[0]
    codigo_disciplina = random.choice(disciplinas)[0]
    semestre = random.randint(1, 2)
    ano = random.randint(2019, 2024)
    media = round(random.uniform(0, 10), 2)
    faltas = random.randint(0, 10)
    cursor.execute("""
        INSERT INTO Cursa (id_aluno, id_curso, codigo_disciplina, semestre, ano, media, faltas) 
        VALUES (?, ?, ?, ?, ?, ?, ?)
    """, (id_aluno, id_curso, codigo_disciplina, semestre, ano, media, faltas))

# Insert data into Leciona
professores = cursor.execute("SELECT id FROM Professor").fetchall()
for _ in range(30):
    id_professor = random.choice(professores)[0]
    id_curso = random.choice(cursos)[0]
    codigo_disciplina = random.choice(disciplinas)[0]
    semestre = random.randint(1, 2)
    ano = random.randint(2019, 2024)
    carga_horaria = random.randint(30, 60)
    cursor.execute("""
        INSERT INTO Leciona (id_professor, id_curso, codigo_disciplina, semestre, ano, carga_horaria) 
        VALUES (?, ?, ?, ?, ?, ?)
    """, (id_professor, id_curso, codigo_disciplina, semestre, ano, carga_horaria))

# Insert data into GrupoTCC
for _ in range(10):
    id_grupo = fake.unique.random_int()
    id_professor = random.choice(professores)[0]
    ra = random.choice(alunos)[0]
    cursor.execute("""
        INSERT INTO GrupoTCC (id_grupo, id_professor, ra) 
        VALUES (?, ?, ?)
    """, (id_grupo, id_professor, ra))

# Commit the transaction and close the connection
conn.commit()
conn.close()
