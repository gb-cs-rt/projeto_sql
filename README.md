# Projeto SQL Universidade
Projeto de Banco de Dados em SQL da disciplina CC5232

# Diagrama Relacional
![image](https://github.com/gb-cs-rt/projeto_sql/blob/main/diagrama_relacional.png)

# Código de geração de dados aleatórios
Para facilitar os testes durante o desenvolvimento do projeto, nós desenvolvemos um código em python que popula o banco de dados com dados gerados aleatoriamente. Além disso, o código também "apaga" todas as tabelas e as cria novamente, antes de preenchê-las com novos dados. Para rodar o código de geração de dados aleatórios, siga os passos a seguir.

## 1- Crie um cluster no CockroachDB (ou em outra plataforma que utilize postgresql)
_obs: o tutorial abaixo apresenta os passos para conectar-se ao CockroachDB utilizando a biblioteca em python psycopg2. Caso deseje utilizar outra plataforma, o procedimento de conexão pode ser diferente. Neste caso, consulte a documentação de sua plataforma desejada._

- Crie uma conta na plataforma **CockroachDB** e crie um cluster (free tier).

## 2- Configure a variável de conexão no seu sistema
- Na página inicial do seu cluster no CockroachDB, clique em **Connect**.

![image](https://github.com/gb-cs-rt/projeto_sql/assets/103227067/7cbdf9f2-ecb0-4d01-8036-584ea1122ab3)


- Na opção de opção/linguagem, selecione **Python**.

![image](https://github.com/gb-cs-rt/projeto_sql/assets/103227067/db7ce608-2e1c-4efc-abde-987a4af49be0)


- Faça o download do certificado de conexão (CA), usando a linha de comando que será fornecida pelo CockroachDB.

![image](https://github.com/gb-cs-rt/projeto_sql/assets/103227067/c75f7491-d1d1-45d5-ab56-fe7063b5fd88)


- Na opção de ferramenta, selecione **psycopg2**. Neste tutorial, selecionamos o *Linux* como sistema operacional.

![image](https://github.com/gb-cs-rt/projeto_sql/assets/103227067/be509191-88ce-4aa4-a627-4471c0f83c3f)

## 3- Execute o código generate_data.py
```
python3 generate_data.py
```
<br>
![image](https://github.com/gb-cs-rt/projeto_sql/assets/103227067/22979a97-fcaa-451e-8794-654fcc30ec23)
> A senha foi descartada após esse print.

# Membros
Cauan Sousa - 24.124.084-5  
Gustavo Baggio - 24.122.012-8  
Ruan Turola - 24.122.050-8  
