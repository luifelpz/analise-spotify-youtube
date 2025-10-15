# Análise de Métricas Musicais e Engajamento (Spotify & YouTube)

## 1. Introdução e Contexto do Projeto

Este projeto representa um mergulho profundo no universo da análise de dados musicais, utilizando um dataset híbrido que combina métricas técnicas da API do Spotify com dados de popularidade de vídeos do YouTube. O objetivo principal não foi apenas responder a perguntas de negócio, mas sim demonstrar um fluxo de trabalho analítico completo e profissional, desde a estruturação inicial dos dados em PostgreSQL até a otimização de consultas.

Ao longo desta análise, identifiquei e tratei problemas de qualidade de dados, explorei as características que definem a "personalidade" das músicas e desenvolvi queries complexas para extrair insights que não eram óbvios à primeira vista. A narrativa deste projeto foi estruturada para simular um desafio real de análise de dados, onde o pensamento crítico e a capacidade de adaptar a metodologia foram tão importantes quanto a proficiência técnica em SQL.

## 2. Objetivo Principal

O objetivo deste projeto foi duplo:

* **Técnico:** Demonstrar proficiência em todo o ciclo de vida de um projeto de dados em ambiente SQL, incluindo:
    * **Modelagem de Dados:** Criação de um schema robusto e otimizado no PostgreSQL.
    * **Análise Exploratória (EDA):** Investigação sistemática para entender a estrutura, as distribuições e os vieses do dataset.
    * **Limpeza de Dados (Data Cleaning):** Tratamento de dados inválidos e consolidação de registros duplicados para garantir a integridade da análise.
    * **Análise de Dados com SQL Avançado:** Uso de CTEs, Funções de Janela (`PARTITION BY`, `DENSE_RANK`, `SUM() OVER()`) e agregações complexas para responder a perguntas de negócio.
    * **Otimização de Consultas:** Diagnóstico de performance com `EXPLAIN ANALYZE` e solução com a criação de Índices.

* **Analítico:** Utilizar o dataset para extrair insights sobre a popularidade e as características de faixas musicais, estabelecendo as bases para futuros projetos de Business Intelligence e Machine Learning.

## 3. Ferramentas e Tecnologias Utilizadas

* **Banco de Dados:** PostgreSQL
* **IDE / Cliente SQL:** pgAdmin 4
* **Linguagem:** SQL (PostgreSQL dialect)

## 4. Estrutura do Projeto

O projeto está organizado em diretórios e scripts sequenciais para refletir um fluxo de trabalho de dados claro, modular e reprodutível. A estrutura abaixo serve como um mapa para a navegação no repositório.

```
/analise-spotify-youtube
|
|-- dataset/                <-- Pasta para armazenar os dados
|   |-- cleaned_dataset.csv
|
|-- images/                 <-- Pasta para armazenar imagens e prints para o README
|
|-- sql/                    <-- Pasta com todos os scripts SQL do projeto
|   |-- 01_schema.sql       # Criação da estrutura da tabela no PostgreSQL
|   |-- 02_eda.sql          # Scripts para a análise exploratória dos dados
|   |-- 03_cleaning.sql     # Scripts para a limpeza e tratamento dos dados
|   |-- 04_analysis.sql     # Queries da análise principal (perguntas de negócio)
|   |-- 05_optimization.sql # Demonstração de otimização de consulta com índices
|
|-- README.md               <-- A documentação principal do projeto que você está lendo
|-- LICENSE                 <-- A licença de uso do código e do projeto
```

## 5. A Jornada Técnica: Do Dado Bruto ao Insight

Esta seção detalha o processo técnico completo, dividido nos blocos de código SQL que compõem este projeto. Cada bloco representa uma etapa lógica no ciclo de vida da análise de dados, com o código-fonte detalhado disponível nos respectivos arquivos `.sql` do repositório.

### 5.1. Bloco 01: Criação da Estrutura (Schema)

**Objetivo:** A primeira etapa foi definir uma estrutura de tabela robusta e semanticamente correta no PostgreSQL. Uma base bem estruturada é o alicerce para qualquer análise de dados confiável.

**Decisões e Boas Práticas Adotadas:**

* **Tipos de Dados Específicos:** Em vez de usar tipos genéricos, optei por `REAL` para métricas musicais e `BIGINT` para contagens de alta cardinalidade (`views`, `stream`), demonstrando um entendimento sobre otimização de armazenamento e a natureza dos dados.
* **Restrições de Integridade:** Apliquei restrições `NOT NULL` em colunas essenciais (`artist`, `track`, `stream`) para garantir a integridade dos dados desde o início.
* **Ordem das Colunas:** A ordem das colunas no `CREATE TABLE` foi definida para espelhar exatamente a ordem do arquivo `.csv` de origem, garantindo uma ingestão de dados correta e sem falhas.

> *O código SQL completo para a criação da tabela está documentado no arquivo `sql/01_schema.sql`.*

### 5.2. Bloco 02: Análise Exploratória de Dados (EDA)

**Objetivo:** Antes de responder a qualquer pergunta de negócio, a etapa de EDA foi fundamental para "conversar" com os dados. O objetivo foi entender a sua estrutura, a distribuição, identificar anomalias e descobrir as "personalidades" escondidas no dataset.

**Principais Descobertas (Insights da EDA):**

1.  **A Natureza Híbrida do Dataset:** A análise da coluna `most_played_on` revelou que o dataset não era puramente do Spotify, mas sim uma combinação de dados do Spotify e do YouTube. Essa descoberta foi estratégica e levou à decisão de renomear e redefinir o escopo do projeto.
2.  **Identificação de Dados Inválidos:** Investiguei a qualidade dos dados e encontrei registros com valores fisicamente impossíveis, como `duration_min = 0` e `tempo = 0`, que foram marcados para remoção.
3.  **Descoberta de Duplicatas:** A EDA revelou um problema de qualidade de dados significativo: a mesma faixa musical aparecia em múltiplas linhas, atribuída a artistas ligeiramente diferentes.
4.  **Viés na Coleta de Dados:** A análise da distribuição de faixas por artista expôs um forte viés de coleta, com 853 artistas (cerca de 27% do total) limitados a exatamente 10 faixas, sugerindo que o dataset foi criado a partir de "Top 10s".

---
> **[SUGESTÃO DE IMAGEM]**
> 
> O print abaixo ilustra a descoberta sobre o viés de coleta, mostrando a tabela de frequência gerada pela análise:
> 
> ![Tabela de distribuição de faixas por artista](./images/NOME_DA_SUA_IMAGEM_AQUI.png)
>
---

Todas essas descobertas foram documentadas e serviram como a justificativa direta para as ações tomadas na etapa seguinte.

> *Todas as queries utilizadas para esta exploração estão disponíveis no arquivo `sql/02_eda.sql`.*

### 5.3. Bloco 03: Limpeza de Dados (Data Cleaning)

**Objetivo:** Com os problemas e anomalias identificados na Análise Exploratória, esta etapa foi dedicada a tratar cada um deles de forma sistemática para garantir a integridade e a consistência do dataset.

**Processos de Limpeza Executados:**

* **Consolidação de Faixas Duplicadas:** Para resolver o problema de duplicatas, implementei um processo robusto que agrupou os registros idênticos, combinou os nomes dos artistas em um único campo (usando `|` como separador seguro) e substituiu as várias linhas duplicadas por um único registro "mestre".
* **Remoção de Dados Inválidos:** Registros com `duration_min = 0` e `tempo = 0` foram removidos, pois representam valores fisicamente impossíveis que distorceriam qualquer análise estatística.
* **Remoção de Dados Irrelevantes:** Faixas com `stream = 0` foram excluídas para focar a análise na popularidade e engajamento, que são o cerne do projeto.

> *A implementação de todas estas regras de limpeza, com verificações "antes e depois", pode ser encontrada no script `sql/03_cleaning.sql`.*
