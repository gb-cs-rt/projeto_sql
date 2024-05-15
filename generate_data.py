import psycopg2
from faker import Faker
import random
import os

# Initialize Faker for generating random data
fake = Faker()

# Connect to the SQLite database (replace with your DB connection)
conn = psycopg2.connect(os.environ["DATABASE_URL"])
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
        media NUMERIC(4, 2),
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
    cursor.execute("INSERT INTO Departamento (nome_departamento) VALUES (%s) ON CONFLICT (nome_departamento) DO NOTHING", (dep,))

# Insert data into Professor
for _ in range(10):
    id_prof = str(random.randint(500000000, 999999999))
    nome_dep = random.choice(departamentos)
    nome = fake.name()
    email = fake.email()
    telefone = str(random.randint(100000000000, 999999999999))
    salario = round(random.uniform(3000, 10000), 2)
    cursor.execute("""
        INSERT INTO Professor (id, nome_departamento, nome, email, telefone, salario) 
        VALUES (%s, %s, %s, %s, %s, %s) ON CONFLICT (id) DO NOTHING
    """, (id_prof, nome_dep, nome, email, telefone, salario))

# Insert data into Aluno
for _ in range(50):
    ra = str(random.randint(100000000, 499999999))
    nome_dep = random.choice(departamentos)
    nome = fake.name()
    email = fake.email()
    telefone = str(random.randint(100000000000, 999999999999))
    cursor.execute("""
        INSERT INTO Aluno (ra, nome_departamento, nome, email, telefone) 
        VALUES (%s, %s, %s, %s, %s) ON CONFLICT (ra) DO NOTHING
    """, (ra, nome_dep, nome, email, telefone))

# Insert data into Curso
for _ in range(5):
    id_curso = str(random.randint(1000, 9999))
    nome_dep = random.choice(departamentos)
    horas_complementares = random.randint(20, 50)
    faltas = random.randint(0, 10)
    cursor.execute("""
        INSERT INTO Curso (id_curso, nome_departamento, horas_complementares, faltas) 
        VALUES (%s, %s, %s, %s) ON CONFLICT (id_curso) DO NOTHING
    """, (id_curso, nome_dep, horas_complementares, faltas))

# Insert data into Disciplina
for _ in range(15):
    codigo_disciplina = fake.unique.bothify(text='??###')
    nome_dep = random.choice(departamentos)
    nome = fake.word()
    carga_horaria = random.randint(30, 60)
    cursor.execute("""
        INSERT INTO Disciplina (codigo_disciplina, nome_departamento, nome, carga_horaria) 
        VALUES (%s, %s, %s, %s) ON CONFLICT (codigo_disciplina) DO NOTHING
    """, (codigo_disciplina, nome_dep, nome, carga_horaria))

# Insert data into MatrizCurricular
cursor.execute("SELECT codigo_disciplina FROM Disciplina")
disciplinas = cursor.fetchall()

cursor.execute("SELECT id_curso FROM Curso")
cursos = cursor.fetchall()

for _ in range(20):
    codigo_disciplina = random.choice(disciplinas)[0]
    id_curso = random.choice(cursos)[0]
    cursor.execute("""
        INSERT INTO MatrizCurricular (codigo_disciplina, id_curso) 
        VALUES (%s, %s) ON CONFLICT (codigo_disciplina, id_curso) DO NOTHING
    """, (codigo_disciplina, id_curso))

# Insert data into Cursa
cursor.execute("SELECT ra FROM Aluno")
alunos = cursor.fetchall()
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
        VALUES (%s, %s, %s, %s, %s, %s, %s) ON CONFLICT (semestre, ano) DO NOTHING
    """, (id_aluno, id_curso, codigo_disciplina, semestre, ano, media, faltas))

# Insert data into Leciona
cursor.execute("SELECT id FROM Professor")
professores = cursor.fetchall()
for _ in range(30):
    id_professor = random.choice(professores)[0]
    id_curso = random.choice(cursos)[0]
    codigo_disciplina = random.choice(disciplinas)[0]
    semestre = random.randint(1, 2)
    ano = random.randint(2019, 2024)
    carga_horaria = random.randint(30, 60)
    cursor.execute("""
        INSERT INTO Leciona (id_professor, id_curso, codigo_disciplina, semestre, ano, carga_horaria) 
        VALUES (%s, %s, %s, %s, %s, %s) ON CONFLICT (semestre, ano) DO NOTHING
    """, (id_professor, id_curso, codigo_disciplina, semestre, ano, carga_horaria))

# Insert data into GrupoTCC
for _ in range(10):
    id_grupo = fake.unique.random_int()
    id_professor = random.choice(professores)[0]
    ra = random.choice(alunos)[0]
    cursor.execute("""
        INSERT INTO GrupoTCC (id_grupo, id_professor, ra) 
        VALUES (%s, %s, %s) ON CONFLICT (id_grupo) DO NOTHING
    """, (id_grupo, id_professor, ra))

# Commit the transaction and close the connection
conn.commit()
conn.close()

print("Database and tables created, and data inserted successfully!")