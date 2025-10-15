-- =================================================================================
-- |                                                                               |
-- |                    BLOCO 04: ANÁLISE DOS DADOS (ANALYSIS)                     |
-- |                                                                               |
-- =================================================================================
-- Este script contém a análise principal do projeto, estruturada em capítulos
-- para contar uma história coesa sobre os dados, desde uma visão geral até
-- insights específicos e demonstrações de técnicas avançadas de SQL.
-- O público-alvo deste script é um recrutador ou líder técnico avaliando
-- a profundidade e a qualidade da análise de dados.
-- =================================================================================

-- *************************************************************************
-- |                    Capítulo 1: O Panorama Geral                       |
-- |                      (Agregações Fundamentais)                        |
-- *************************************************************************
-- Começamos do macro, entendendo a estrutura, a distribuição e os
-- principais grupos do nosso dataset para estabelecer uma base sólida.

-- ========================================================================
-- Pergunta 1: Qual a distribuição de faixas por artista no dataset?
-- Objetivo: Investigar a distribuição de faixas por artista para identificar
-- a estrutura do dataset e potenciais vieses de coleta, uma etapa crítica
-- antes de prosseguir com análises de ranking.

WITH contagem_faixas_por_artista AS (
-- Passo 1: Contar quantas faixas cada artista tem.
    SELECT
        artist,
        COUNT(*) AS numero_de_faixas
    FROM spotify_youtube
    GROUP BY artist
)
-- Passo 2: Agrupar pelas contagens e contar quantos artistas existem em 
-- cada grupo.
SELECT
    numero_de_faixas,
    COUNT(artist) AS numero_de_artistas
FROM contagem_faixas_por_artista
GROUP BY numero_de_faixas
ORDER BY numero_de_artistas DESC;
-- ========================================================================


-- ========================================================================
-- Pergunta 2: Quais são os álbuns mais populares?
-- Objetivo: Identificar os álbuns com maior engajamento agregado (soma de
-- streams), respondendo a uma pergunta de negócio fundamental sobre quais
-- projetos musicais foram mais consumidos.

SELECT
    artist,
    album,
    SUM(stream) AS total_streams
FROM
    spotify_youtube
GROUP BY
    artist, album
ORDER BY
    total_streams DESC
LIMIT 20;
-- ========================================================================


-- *************************************************************************
-- |                    Capítulo 2: Os Grandes Sucessos                    |
-- |                (Ranking e Segmentação de Popularidade)                |
-- *************************************************************************
-- Depois de ver o todo, focamos nos destaques individuais e nas
-- comparações de alto nível para identificar as faixas de maior impacto.

-- ========================================================================
-- Pergunta 3: Quais faixas pertencem ao "Clube do Bilhão" de streams?
-- Objetivo: Segmentar e identificar um grupo de elite de faixas que
-- atingiram o marco de 1 bilhão de streams, representando os maiores
-- sucessos globais presentes no dataset.

SELECT
    artist,
    track,
    album,
    stream
FROM spotify_youtube
WHERE stream > 1e9 
ORDER BY stream DESC;
-- ========================================================================


-- ========================================================================
-- Pergunta 4: Quais faixas dominam em cada plataforma (Spotify vs. YouTube)?
-- Objetivo: Comparar diretamente a popularidade de cada faixa nas duas
-- plataformas para identificar quais músicas performam melhor em cada
-- ecossistema, explorando a natureza híbrida e única do dataset.

-- A) Faixas mais populares no Spotify do que no YouTube (Top 20 por diferença).
-- Esta análise compara diretamente as duas principais métricas de popularidade do dataset
-- e calcula a diferença para encontrar as faixas com maior dominância no Spotify.
SELECT
    artist,
    track,
    stream,
    views,
    (stream - views) AS diferenca_spotify_vs_youtube
FROM
    spotify_youtube
WHERE
    stream > views
ORDER BY
    diferenca_spotify_vs_youtube DESC
LIMIT 20;

-- B) Faixas mais populares no YouTube do que no Spotify (Top 20 por diferença).
-- A análise inversa da anterior, para encontrar faixas cujo apelo visual ou viral no YouTube
-- supera sua popularidade em streams de áudio.
SELECT
    artist,
    track,
    views,
    stream,
    (views - stream) AS diferenca_youtube_vs_spotify
FROM
    spotify_youtube
WHERE
    views > stream
ORDER BY
    diferenca_youtube_vs_spotify DESC
LIMIT 20;
-- ========================================================================


-- *************************************************************************
-- |                    Capítulo 3: O DNA Musical                          |
-- |             (Análise Profunda dos Atributos Musicais)                 |
-- *************************************************************************
-- Agora mergulhamos nos detalhes técnicos da música para entender as
-- características sonoras que definem as faixas do nosso dataset.

-- ========================================================================
-- Pergunta 5: Quais são os extremos de cada atributo musical?
-- Objetivo: Explorar sistematicamente os extremos de cada um dos 9
-- atributos musicais (ex: Danceability, Energy). Ao identificar o Top 5,
-- o Bottom 5 e a Média de cada atributo, criamos um perfil detalhado
-- da diversidade sonora do dataset.

-- A) Análise da métrica Danceability
-- Danceability: O quão adequada uma faixa é para dançar (0.0 = menos dançante, 1.0 = mais dançante).
SELECT ROUND(AVG(danceability)::numeric, 3) AS media_geral_danceability FROM spotify_youtube;

WITH ranked_tracks AS (
    SELECT artist, track, danceability, stream, DENSE_RANK() OVER (ORDER BY danceability DESC, stream DESC) AS ranking
    FROM spotify_youtube
)
SELECT artist, track, danceability, stream, ranking FROM ranked_tracks WHERE ranking <= 5;

WITH ranked_tracks AS (
    SELECT artist, track, danceability, stream, DENSE_RANK() OVER (ORDER BY danceability ASC, stream DESC) AS ranking
    FROM spotify_youtube
)
SELECT artist, track, danceability, stream, ranking FROM ranked_tracks WHERE ranking <= 5;


-- B) Análise da métrica Energy
-- Energy: Medida de intensidade e atividade (0.0 a 1.0). Valores altos indicam faixas mais energéticas.
SELECT ROUND(AVG(energy)::numeric, 3) AS media_geral_energy FROM spotify_youtube;

WITH ranked_tracks AS (
    SELECT artist, track, energy, stream, DENSE_RANK() OVER (ORDER BY energy DESC, stream DESC) AS ranking
    FROM spotify_youtube
)
SELECT artist, track, energy, stream, ranking FROM ranked_tracks WHERE ranking <= 5;

WITH ranked_tracks AS (
    SELECT artist, track, energy, stream, DENSE_RANK() OVER (ORDER BY energy ASC, stream DESC) AS ranking
    FROM spotify_youtube
)
SELECT artist, track, energy, stream, ranking FROM ranked_tracks WHERE ranking <= 5;


-- C) Análise da métrica Loudness
-- Loudness: Volume em decibéis (dB). Valores mais próximos de 0 indicam que a faixa é mais alta.
SELECT ROUND(AVG(loudness)::numeric, 3) AS media_geral_loudness FROM spotify_youtube;

WITH ranked_tracks AS (
    SELECT artist, track, loudness, stream, DENSE_RANK() OVER (ORDER BY loudness DESC, stream DESC) AS ranking
    FROM spotify_youtube
)
SELECT artist, track, loudness, stream, ranking FROM ranked_tracks WHERE ranking <= 5;

WITH ranked_tracks AS (
    SELECT artist, track, loudness, stream, DENSE_RANK() OVER (ORDER BY loudness ASC, stream DESC) AS ranking
    FROM spotify_youtube
)
SELECT artist, track, loudness, stream, ranking FROM ranked_tracks WHERE ranking <= 5;


-- D) Análise da métrica Speechiness
-- Speechiness: Detecta palavras faladas. Abaixo de 0.33 é música/rap; acima de 0.66 é fala.
SELECT ROUND(AVG(speechiness)::numeric, 3) AS media_geral_speechiness FROM spotify_youtube;

WITH ranked_tracks AS (
    SELECT artist, track, speechiness, stream, DENSE_RANK() OVER (ORDER BY speechiness DESC, stream DESC) AS ranking
    FROM spotify_youtube
)
SELECT artist, track, speechiness, stream, ranking FROM ranked_tracks WHERE ranking <= 5;

WITH ranked_tracks AS (
    SELECT artist, track, speechiness, stream, DENSE_RANK() OVER (ORDER BY speechiness ASC, stream DESC) AS ranking
    FROM spotify_youtube
)
SELECT artist, track, speechiness, stream, ranking FROM ranked_tracks WHERE ranking <= 5;


-- E) Análise da métrica Acousticness
-- Acousticness: Medida de confiança se a faixa é acústica (0.0 = baixa confiança, 1.0 = alta confiança).
SELECT ROUND(AVG(acousticness)::numeric, 3) AS media_geral_acousticness FROM spotify_youtube;

WITH ranked_tracks AS (
    SELECT artist, track, acousticness, stream, DENSE_RANK() OVER (ORDER BY acousticness DESC, stream DESC) AS ranking
    FROM spotify_youtube
)
SELECT artist, track, acousticness, stream, ranking FROM ranked_tracks WHERE ranking <= 5;

WITH ranked_tracks AS (
    SELECT artist, track, acousticness, stream, DENSE_RANK() OVER (ORDER BY acousticness ASC, stream DESC) AS ranking
    FROM spotify_youtube
)
SELECT artist, track, acousticness, stream, ranking FROM ranked_tracks WHERE ranking <= 5;


-- F) Análise da métrica Instrumentalness
-- Instrumentalness: Prevê se uma faixa não contém vocais. Próximo de 1.0 representa maior probabilidade de ser instrumental.
SELECT ROUND(AVG(instrumentalness)::numeric, 3) AS media_geral_instrumentalness FROM spotify_youtube;

WITH ranked_tracks AS (
    SELECT artist, track, instrumentalness, stream, DENSE_RANK() OVER (ORDER BY instrumentalness DESC, stream DESC) AS ranking
    FROM spotify_youtube
)
SELECT artist, track, instrumentalness, stream, ranking FROM ranked_tracks WHERE ranking <= 5;

WITH ranked_tracks AS (
    SELECT artist, track, instrumentalness, stream, DENSE_RANK() OVER (ORDER BY instrumentalness ASC, stream DESC) AS ranking
    FROM spotify_youtube
)
SELECT artist, track, instrumentalness, stream, ranking FROM ranked_tracks WHERE ranking <= 5;


-- G) Análise da métrica Liveness
-- Liveness: Detecta a presença de audiência. Um valor acima de 0.8 indica forte probabilidade de ser ao vivo.
SELECT ROUND(AVG(liveness)::numeric, 3) AS media_geral_liveness FROM spotify_youtube;

WITH ranked_tracks AS (
    SELECT artist, track, liveness, stream, DENSE_RANK() OVER (ORDER BY liveness DESC, stream DESC) AS ranking
    FROM spotify_youtube
)
SELECT artist, track, liveness, stream, ranking FROM ranked_tracks WHERE ranking <= 5;

WITH ranked_tracks AS (
    SELECT artist, track, liveness, stream, DENSE_RANK() OVER (ORDER BY liveness ASC, stream DESC) AS ranking
    FROM spotify_youtube
)
SELECT artist, track, liveness, stream, ranking FROM ranked_tracks WHERE ranking <= 5;


-- H) Análise da métrica Valence (Positividade)
-- Valence: Medida de positividade musical (0.0 = triste/negativo, 1.0 = feliz/positivo).
SELECT ROUND(AVG(valence)::numeric, 3) AS media_geral_valence FROM spotify_youtube;

WITH ranked_tracks AS (
    SELECT artist, track, valence, stream, DENSE_RANK() OVER (ORDER BY valence DESC, stream DESC) AS ranking
    FROM spotify_youtube
)
SELECT artist, track, valence, stream, ranking FROM ranked_tracks WHERE ranking <= 5;

WITH ranked_tracks AS (
    SELECT artist, track, valence, stream, DENSE_RANK() OVER (ORDER BY valence ASC, stream DESC) AS ranking
    FROM spotify_youtube
)
SELECT artist, track, valence, stream, ranking FROM ranked_tracks WHERE ranking <= 100;


-- I) Análise da métrica Tempo (BPM)
-- Tempo: A velocidade ou ritmo da faixa em batidas por minuto (BPM).
SELECT ROUND(AVG(tempo)::numeric, 3) AS media_geral_tempo FROM spotify_youtube;

WITH ranked_tracks AS (
    SELECT artist, track, tempo, stream, DENSE_RANK() OVER (ORDER BY tempo DESC, stream DESC) AS ranking
    FROM spotify_youtube
)
SELECT artist, track, tempo, stream, ranking FROM ranked_tracks WHERE ranking <= 5;

WITH ranked_tracks AS (
    SELECT artist, track, tempo, stream, DENSE_RANK() OVER (ORDER BY tempo ASC, stream DESC) AS ranking
    FROM spotify_youtube
)
SELECT artist, track, tempo, stream, ranking FROM ranked_tracks WHERE ranking <= 5;
-- ========================================================================


-- ========================================================================
-- Pergunta 6: Quais álbuns possuem a maior diversidade sonora?
-- Objetivo: Criar uma métrica derivada (range de energia) para quantificar
-- a diversidade sonora *dentro* de cada álbum, identificando os projetos
-- que oferecem a maior variação dinâmica aos ouvintes.

WITH energy_por_album AS (
    SELECT
        artist,
        album,
        MAX(energy) AS max_energia,
        MIN(energy) AS min_energia
    FROM spotify_youtube
    GROUP BY artist, album
)
SELECT
    artist,
    album,
    max_energia,
    min_energia,
    ROUND((max_energia - min_energia)::numeric, 3) AS range_energia
FROM energy_por_album
WHERE (max_energia - min_energia) > 0 -- Filtra álbuns com apenas uma música (range = 0)
ORDER BY range_energia DESC
LIMIT 20;
-- ========================================================================


-- *************************************************************************
-- |                Capítulo 4: Técnicas Avançadas de SQL                  |
-- |                 (Análises Contextuais e de Ranking)                   |
-- *************************************************************************
-- Terminamos com as demonstrações mais sofisticadas de habilidade em SQL,
-- resolvendo perguntas de negócio complexas que exigem funções de janela.

-- ========================================================================
-- Pergunta 7: Quais são as 3 faixas mais populares de cada artista?
-- Objetivo: Demonstrar a capacidade de criar rankings segmentados,
-- respondendo a uma pergunta de negócio que exige personalização. Esta
-- análise utiliza a função de janela PARTITION BY, uma técnica avançada.

WITH ranked_tracks AS (
    SELECT
        artist,
        track,
        SUM(views) AS total_views,
        DENSE_RANK() OVER(PARTITION BY artist ORDER BY SUM(views) DESC) AS ranking
    FROM spotify_youtube
    GROUP BY artist, track
)
SELECT
    artist,
    track,
    total_views,
    ranking
FROM ranked_tracks
WHERE ranking <= 3
ORDER BY artist, ranking;
-- ========================================================================


-- ========================================================================
-- Pergunta 8: Como o engajamento (likes) se acumula com a popularidade?
-- Objetivo: Calcular a soma cumulativa de 'likes' ao longo do ranking de
-- popularidade (views), demonstrando como o engajamento se concentra nas
-- faixas do topo. Esta análise utiliza funções de janela para cálculos sequenciais.

SELECT
    artist,
    track,
    views,
    likes,
    SUM(likes) OVER (ORDER BY views DESC) AS cumulative_likes
FROM
    spotify_youtube
ORDER BY
    views DESC
LIMIT 100;
-- ========================================================================


-- ========================================================================
-- Pergunta 9: Quais são as faixas que se destacam por serem "ao vivo"?
-- Objetivo: Usar uma métrica agregada (a média geral de 'Liveness') como um
-- baseline para segmentar o dataset, identificando um grupo específico de
-- faixas que se destacam em relação à norma.

WITH avg_liveness AS (
    SELECT AVG(liveness) AS media_geral FROM spotify_youtube
)
SELECT
    sy.artist,
    sy.track,
    sy.liveness,
    ROUND(a.media_geral::numeric, 3) AS media_geral_liveness -- Mostra a média para contexto
FROM
    spotify_youtube sy
CROSS JOIN -- Juntamos a média a todas as linhas para poder usá-la no SELECT e no WHERE
    avg_liveness a
WHERE
    sy.liveness > a.media_geral
ORDER BY
    sy.liveness DESC
LIMIT 20;
-- ========================================================================
