-- =========================================================================
-- |                                                                       |
-- |           BLOCO 05: OTIMIZAÇÃO DE CONSULTA (OPTIMIZATION)             |
-- |                                                                       |
-- =========================================================================
-- Neste capítulo final, demonstramos uma abordagem proativa em relação à
-- performance do banco de dados. Simulamos um caso de uso comum - buscar as
-- faixas mais populares de um artista específico - e otimizamos a consulta
-- através da criação de um índice.

-- *************************************************************************
-- |               Etapa 1: Diagnóstico (EXPLAIN ANALYZE)                  |
-- *************************************************************************
-- Objetivo: Analisar o plano de execução e o custo de uma consulta comum
-- *antes* de qualquer otimização. O objetivo é estabelecer um baseline
-- de performance. A consulta escolhida busca as 25 faixas mais populares
-- do artista 'Gorillaz' na plataforma YouTube.

EXPLAIN ANALYZE
SELECT
    artist,
    track,
    views
FROM spotify_youtube
WHERE artist = 'Gorillaz'
  AND most_played_on = 'Youtube'
ORDER BY stream DESC
LIMIT 25;

-- Análise do Resultado: Ao executar a query acima, observamos que o PostgreSQL
-- realiza um "Sequential Scan" (Leitura Sequencial) na tabela 'spotify'.
-- Isso significa que ele precisa ler a tabela inteira, linha por linha, para
-- encontrar os registros do artista 'Gorillaz'. Para uma tabela grande,
-- isso seria muito ineficiente.


-- *************************************************************************
-- |               Etapa 2: Solução (CREATE INDEX)                         |
-- *************************************************************************
-- Objetivo: Criar um índice na coluna 'artist' para acelerar as buscas
-- que filtram por este campo. Um índice funciona como o índice de um livro,
-- permitindo que o banco de dados "pule" diretamente para as linhas
-- relevantes sem precisar ler a tabela inteira.

CREATE INDEX idx_artist ON spotify_youtube(artist);


-- *************************************************************************
-- |               Etapa 3: Verificação (EXPLAIN ANALYZE Novamente)        |
-- *************************************************************************
-- Objetivo: Executar exatamente a mesma consulta de diagnóstico para
-- verificar o impacto da criação do índice.

EXPLAIN ANALYZE
SELECT
    artist,
    track,
    views
FROM spotify_youtube
WHERE artist = 'Gorillaz'
  AND most_played_on = 'Youtube'
ORDER BY stream DESC
LIMIT 25;

-- Análise do Resultado: Após a criação do índice, o novo plano de execução
-- agora utiliza um "Index Scan" ou "Bitmap Index Scan". O custo da consulta
-- e, mais importante, o tempo de execução (execution time) são drasticamente
-- menores. Isso prova que nossa otimização foi bem-sucedida e que a consulta
-- agora é muito mais eficiente.