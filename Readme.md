# Stored Procedures

## Sobre o projeto

Projeto de resolução de exercícios práticos de **Stored Procedures no MySQL**, utilizando banco de dados de uma loja de tecnologia loja_tech.


---

## Tecnologias utilizadas

- MySQL
- MySQL Workbench
- Stored Procedures
- Parâmetros `IN` e `OUT`
- Estruturas condicionais (`IF`, `ELSEIF`, `ELSE`)
- Funções de agregação (`COUNT`, `SUM`, `AVG`, `MAX`)
- Manipulação de dados (`UPDATE`, `INSERT`, `SELECT`)

---

## Exercícios desenvolvidos

### 1. `atualizar_preco_categoria`

Procedure responsável por atualizar o preço dos produtos ativos de uma determinada categoria, aplicando um percentual de aumento ou desconto.

**Parâmetros:**

| Parâmetro | Tipo | Descrição |
|---|---|---|
| `p_id_categoria` | `IN INT` | Identificador da categoria |
| `p_percentual` | `IN DECIMAL(5,2)` | Percentual de ajuste no preço |
| `p_quantidade_alterada` | `OUT INT` | Quantidade de produtos alterados |
| `p_mensagem` | `OUT VARCHAR(255)` | Mensagem de sucesso ou erro |

**Regras:**

- Atualiza somente produtos ativos da categoria informada.
- Percentuais positivos representam aumento de preço.
- Percentuais negativos representam desconto.
- Desconto máximo permitido de 50%.
- Aumento máximo permitido de 100%.
- Valida se a categoria existe.
- Não realiza alterações quando o percentual é igual a zero.
- Retorna a quantidade de produtos alterados.
- Registra a operação na tabela `log_operacoes`.

**Exemplo de execução:**

```sql
CALL atualizar_preco_categoria(3, 10, @quantidade, @mensagem);

SELECT @quantidade AS produtos_alterados,
       @mensagem AS resultado;
```

Nesse exemplo, os preços dos produtos ativos da categoria 3 serão aumentados em 10%.

---

### 2. `consultar_extrato_cliente`

Procedure responsável por consultar informações cadastrais, pedidos e um resumo financeiro de determinado cliente.

**Parâmetro:**

| Parâmetro | Tipo | Descrição |
|---|---|---|
| `p_id_cliente` | `IN INT` | Identificador do cliente |

**Resultados retornados:**

A procedure retorna três Result Sets:

#### Result Set 1 — Dados do cliente

- Nome
- E-mail
- Telefone
- Data de cadastro

#### Result Set 2 — Pedidos do cliente

- Número do pedido
- Data do pedido
- Status
- Valor total

Os pedidos são apresentados em ordem decrescente de data.

#### Result Set 3 — Resumo

- Total de pedidos
- Valor total gasto
- Ticket médio
- Data do último pedido

Pedidos cancelados são desconsiderados nos cálculos de valor total gasto e ticket médio.

Caso o cliente não exista, a procedure retorna uma mensagem de erro utilizando `SELECT`, sem o uso de `SIGNAL`.

**Exemplo de execução:**

```sql
CALL consultar_extrato_cliente(1);
```

---

## Estrutura do banco de dados

O projeto utiliza o banco `loja_tech`, com tabelas relacionadas a uma loja de tecnologia.

| Tabela | Descrição |
|---|---|
| `categorias` | Armazena as categorias de produtos |
| `produtos` | Armazena os produtos, preços e estoque |
| `clientes` | Armazena os dados dos clientes |
| `pedidos` | Armazena os pedidos realizados |
| `itens_pedido` | Armazena os produtos pertencentes a cada pedido |
| `log_operacoes` | Registra operações realizadas no banco |

---

## Como executar

1. Abra o MySQL Workbench.
2. Conecte-se ao servidor MySQL.
3. Selecione o banco de dados `loja_tech`.
4. Execute os scripts de criação das tabelas, caso ainda não existam.
5. Execute os scripts das Stored Procedures.
6. Utilize os comandos `CALL` para testar os exercícios.

---

## Exemplos de testes

### Atualização de preços

-- Aumento de 10%
CALL atualizar_preco_categoria(3, 10, @quantidade, @mensagem);

SELECT @quantidade, @mensagem;

<img width="395" height="47" alt="image" src="https://github.com/user-attachments/assets/91560410-3066-4c37-b757-d8161254fda9" />


-- Desconto de 20%
CALL atualizar_preco_categoria(3, -20, @quantidade, @mensagem);

SELECT @quantidade, @mensagem;

<img width="391" height="46" alt="image" src="https://github.com/user-attachments/assets/b71a4cc1-e475-479a-94db-3fad42d923e1" />


-- Percentual inválido
CALL atualizar_preco_categoria(3, -60, @quantidade, @mensagem);

SELECT @quantidade, @mensagem;

<img width="373" height="45" alt="image" src="https://github.com/user-attachments/assets/5b5ff817-1fca-400f-8c1f-f0a29c768828" />



### Extrato de cliente


-- Cliente existente
CALL consultar_extrato_cliente(1);

<img width="412" height="51" alt="image" src="https://github.com/user-attachments/assets/613268f9-6bd3-4380-a889-c75062b73848" />


-- Cliente inexistente
CALL consultar_extrato_cliente(99);

<img width="200" height="42" alt="image" src="https://github.com/user-attachments/assets/92691839-e854-49e6-b4f1-e6679f34cebd" />


### Consultar registros de log


SELECT *
FROM log_operacoes
ORDER BY id_log DESC;

<img width="682" height="172" alt="image" src="https://github.com/user-attachments/assets/44b6383e-a636-485a-90eb-b38d1879819c" />



---

## Autor

- Nicolas Massuda <@massudesu>
