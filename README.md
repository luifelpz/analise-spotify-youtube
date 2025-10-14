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

---
