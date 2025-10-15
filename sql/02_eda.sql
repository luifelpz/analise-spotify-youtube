-- =================================================================================
-- |                                                                               |
-- |                 BLOCO 02: ANÁLISE EXPLORATÓRIA DOS DADOS (EDA)                |
-- |                                                                               |
-- =================================================================================
-- Entender as dimensões, cardinalidade, distribuições,
-- qualidade dos dados e inspecionar anomalias diretamente.
-- =================================================================================

-- 1. Visão Geral da Dimensão do Dataset
-- Uma única consulta para obter contagens totais e de valores únicos (cardinalidade)
-- para as entidades mais importantes do nosso dataset.
SELECT
    COUNT(*) AS total_de_faixas,
    COUNT(DISTINCT artist) AS artistas_unicos,
    COUNT(DISTINCT track) AS faixas_unicas,
    COUNT(DISTINCT album) AS albuns_unicos
FROM spotify_youtube;


-- 2. Análise de Qualidade dos Dados (Contagem de Problemas)
-- Esta consulta quantifica a presença de dados ausentes ou inválidos em
-- colunas críticas, nos dando uma visão macro dos problemas.
SELECT
    SUM(CASE WHEN licensed IS NULL THEN 1 ELSE 0 END) AS licensed_nulos,
    SUM(CASE WHEN official_video IS NULL THEN 1 ELSE 0 END) AS official_video_nulos,
    SUM(CASE WHEN duration_min = 0 THEN 1 ELSE 0 END) AS faixas_com_duracao_zero,
	SUM(CASE WHEN tempo = 0 THEN 1 ELSE 0 END) AS faixas_com_tempo_zero,
    SUM(CASE WHEN stream = 0 THEN 1 ELSE 0 END) AS faixas_sem_stream
FROM spotify_youtube;
-- Descoberta: Identificamos problemas a serem tratados na fase de limpeza.


-- 3. Distribuição de Variáveis Categóricas
-- Entender como as faixas se distribuem entre diferentes categorias é
-- fundamental para contextualizar as análises.

-- a) Contagem de faixas por tipo de álbum.
SELECT
    album_type,
    COUNT(*) AS total_faixas,
    ROUND((COUNT(*) * 100.0 / (SELECT COUNT(*) FROM spotify_youtube)), 2) AS porcentagem
FROM spotify_youtube
GROUP BY album_type
ORDER BY total_faixas DESC;

-- b) Contagem de faixas pela plataforma mais tocada.
SELECT
    most_played_on,
    COUNT(*) AS total_faixas,
    ROUND((COUNT(*) * 100.0 / (SELECT COUNT(*) FROM spotify_youtube)), 2) AS porcentagem
FROM spotify_youtube
GROUP BY most_played_on
ORDER BY total_faixas DESC;


-- 4. Análise Descritiva Detalhada das Métricas Musicais
-- Um resumo estatístico completo para cada feature musical, fundamental
-- para futuros modelos de Machine Learning.
SELECT
    -- Danceability: O quão adequada uma faixa é para dançar (0.0 = menos dançante, 1.0 = mais dançante).
    ROUND(AVG(danceability)::numeric, 2) AS media_danceability,
    ROUND(STDDEV(danceability)::numeric, 2) AS desvio_padrao_danceability,
    ROUND(MIN(danceability)::numeric, 2) AS min_danceability,
    ROUND(MAX(danceability)::numeric, 2) AS max_danceability,

    -- Energy: Medida de intensidade e atividade numa escala de 0.0 a 1.0. 
	-- Valores altos indicam faixas mais energéticas (rápidas, altas, barulhentas).
    ROUND(AVG(energy)::numeric, 2) AS media_energy,
    ROUND(STDDEV(energy)::numeric, 2) AS desvio_padrao_energy,
    ROUND(MIN(energy)::numeric, 2) AS min_energy,
    ROUND(MAX(energy)::numeric, 2) AS max_energy,

    -- Loudness: Volume geral da faixa em decibéis (dB). 
	-- Valores mais próximos de 0 indicam que a faixa é mais alta (geralmente entre -60 e 0 dB).
    ROUND(AVG(loudness)::numeric, 2) AS media_loudness,
    ROUND(STDDEV(loudness)::numeric, 2) AS desvio_padrao_loudness,
    ROUND(MIN(loudness)::numeric, 2) AS min_loudness,
    ROUND(MAX(loudness)::numeric, 2) AS max_loudness,

    -- Speechiness: Detecta a presença de palavras faladas. 
	-- Valores abaixo de 0.33 são tipicamente música; entre 0.33 e 0.66 podem ser rap; 
	-- acima de 0.66 são provavelmente audiolivros ou podcasts.
    ROUND(AVG(speechiness)::numeric, 2) AS media_speechiness,
    ROUND(STDDEV(speechiness)::numeric, 2) AS desvio_padrao_speechiness,
    ROUND(MIN(speechiness)::numeric, 2) AS min_speechiness,
    ROUND(MAX(speechiness)::numeric, 2) AS max_speechiness,

    -- Acousticness: Medida de confiança se a faixa é acústica (0.0 = baixa confiança, 1.0 = alta confiança).
    ROUND(AVG(acousticness)::numeric, 2) AS media_acousticness,
    ROUND(STDDEV(acousticness)::numeric, 2) AS desvio_padrao_acousticness,
    ROUND(MIN(acousticness)::numeric, 2) AS min_acousticness,
    ROUND(MAX(acousticness)::numeric, 2) AS max_acousticness,

    -- Instrumentalness: Prevê se uma faixa não contém vocais. Próximo de 1.0 representa maior probabilidade.
    ROUND(AVG(instrumentalness)::numeric, 2) AS media_instrumentalness,
    ROUND(STDDEV(instrumentalness)::numeric, 2) AS desvio_padrao_instrumentalness,
    ROUND(MIN(instrumentalness)::numeric, 2) AS min_instrumentalness,
    ROUND(MAX(instrumentalness)::numeric, 2) AS max_instrumentalness,

    -- Liveness: Detecta a presença de uma audiência na gravação. 
	-- Um valor acima de 0.8 indica uma forte probabilidade de que a faixa foi gravada ao vivo.
    ROUND(AVG(liveness)::numeric, 2) AS media_liveness,
    ROUND(STDDEV(liveness)::numeric, 2) AS desvio_padrao_liveness,
    ROUND(MIN(liveness)::numeric, 2) AS min_liveness,
    ROUND(MAX(liveness)::numeric, 2) AS max_liveness,

    -- Valence: Medida de positividade musical (0.0 = triste/negativo, 1.0 = feliz/positivo).
    ROUND(AVG(valence)::numeric, 2) AS media_valence,
    ROUND(STDDEV(valence)::numeric, 2) AS desvio_padrao_valence,
    ROUND(MIN(valence)::numeric, 2) AS min_valence,
    ROUND(MAX(valence)::numeric, 2) AS max_valence,

    -- Tempo: A velocidade ou ritmo da faixa em batidas por minuto (BPM).
    ROUND(AVG(tempo)::numeric, 2) AS media_tempo,
    ROUND(STDDEV(tempo)::numeric, 2) AS desvio_padrao_tempo,
    ROUND(MIN(tempo)::numeric, 2) AS min_tempo,
    ROUND(MAX(tempo)::numeric, 2) AS max_tempo
FROM spotify_youtube
WHERE duration_min > 0; -- Exclui as durações zeradas da análise estatística para não distorcer o resultado.


-- 5. Inspeção Direta de Anomalias
-- Após quantificar os problemas, inspecionamos as linhas específicas.

-- a) Inspecionando as faixas com duração zero.
-- A consulta 2 nos mostrou que há 2 faixas nesta condição. Vamos visualizá-las para confirmar antes de removê-las.
SELECT *
FROM spotify_youtube
WHERE duration_min = 0;

-- b) Amostra de faixas com zero streams no Spotify.
-- A consulta 2 identificou 576 faixas com stream = 0. Inspecionar uma amostra pode nos ajudar a entender o padrão.
SELECT artist, track, album, stream
FROM spotify_youtube
WHERE stream = 0
LIMIT 10;

-- c) Investigando faixas duplicadas (mesma música, artistas diferentes).
-- Buscamos por faixas com o mesmo nome e mesmo número de streams, mas que aparecem
-- mais de uma vez. Isso indica um problema de duplicidade de dados a ser tratado.
SELECT
    track,
    stream,
    COUNT(*) AS numero_de_duplicatas,
    STRING_AGG(artist, ' | ') AS artistas_envolvidos -- Mostra os diferentes artistas para a mesma faixa
FROM spotify_youtube
GROUP BY track, stream
HAVING COUNT(*) > 1
ORDER BY numero_de_duplicatas DESC;

-- d) Inspecionando as faixas com tempo inválido (BPM = 0).
-- A consulta na Seção 2 quantificou estas faixas. Aqui, nós as visualizamos
-- para confirmar que são dados anômalos antes da remoção na fase de limpeza.
SELECT 
	artist, 
	track, 
	tempo
FROM spotify_youtube
WHERE tempo = 0;
