-- =================================================================================
-- |                                                                               |
-- |                    BLOCO 03: LIMPEZA DOS DADOS (CLEANING)                     |
-- |                                                                               |
-- =================================================================================
-- Remover registros inválidos ou fora do escopo da análise, com base nas descobertas
-- feitas na fase de EDA (Bloco 02).
-- =================================================================================

-- 1. Consolidação de Faixas Duplicadas (mesma música, artistas diferentes)
-- Nossa EDA (em 02_eda.sql) identificou faixas com o mesmo nome e stream, mas artistas diferentes.
-- O processo a seguir irá consolidá-las em um único registro "mestre".

-- Passo 1.1: Criar uma tabela temporária com os registros mestres e consolidados.
-- Esta tabela conterá uma única linha para cada faixa duplicada, com os artistas agregados com ' | '.
CREATE TEMP TABLE consolidated_records AS
SELECT
    STRING_AGG(DISTINCT artist, ' | ') AS artist,
    track,
    MAX(album) AS album, -- Usamos MAX() para agregar, pois os valores são idênticos para as duplicatas
    MAX(album_type) AS album_type,
    MAX(danceability) AS danceability,
    MAX(energy) AS energy,
    MAX(loudness) AS loudness,
    MAX(speechiness) AS speechiness,
    MAX(acousticness) AS acousticness,
    MAX(instrumentalness) AS instrumentalness,
    MAX(liveness) AS liveness,
    MAX(valence) AS valence,
    MAX(tempo) AS tempo,
    MAX(duration_min) AS duration_min,
    MAX(title) AS title,
    MAX(channel) AS channel,
    MAX(views) AS views,
    MAX(likes) AS likes,
    MAX(comments) AS comments,
    MAX(licensed::text)::boolean AS licensed, -- Agregação segura para tipo booleano
    MAX(official_video::text)::boolean AS official_video,
    stream, -- Esta é uma das nossas chaves de agrupamento, não precisa de agregação
    MAX(energy_liveness) AS energy_liveness,
    MAX(most_played_on) AS most_played_on
FROM spotify_youtube
GROUP BY track, stream
HAVING COUNT(*) > 1;

-- Passo 1.2: Deletar TODOS os registros antigos e duplicados da tabela principal.
-- Usamos as chaves (track, stream) para identificar com precisão quais linhas remover.
DELETE FROM spotify_youtube
WHERE (track, stream) IN (SELECT track, stream FROM consolidated_records);

-- Passo 1.3: Inserir os novos registros mestres e consolidados de volta na tabela principal.
-- Agora a tabela 'spotify' conterá apenas uma versão de cada faixa, com os artistas combinados.
INSERT INTO spotify_youtube
SELECT * FROM consolidated_records;

-- Verificação (Opcional, mas recomendado): Contar quantas faixas únicas foram consolidadas.
SELECT COUNT(*) AS total_faixas_unicas_consolidadas FROM consolidated_records;

-- 2. Remoção de Faixas com Duração Inválida
-- Nossa EDA (em 02_eda.sql) identificou 2 faixas com duration_min = 0.
-- Como uma faixa não pode ter duração nula, estes registros são inválidos.

-- Exibe a contagem ANTES da remoção.
SELECT COUNT(*) AS antes_remocao_duracao_zero FROM spotify_youtube WHERE duration_min = 0;

-- Ação: Deletar as linhas onde a duração é zero.
DELETE FROM spotify_youtube
WHERE duration_min = 0;

-- Verificação: A contagem agora deve ser 0.
SELECT COUNT(*) AS depois_remocao_duracao_zero FROM spotify_youtube WHERE duration_min = 0;


-- 3. Remoção de Faixas com Zero Streams no Spotify
-- Nossa EDA (em 02_eda.sql) identificou 576 faixas com stream = 0.
-- Para uma análise focada em popularidade e engajamento, estas faixas
-- não são relevantes e podem ser consideradas ruído.

-- Exibe a contagem ANTES da remoção.
SELECT COUNT(*) AS antes_remocao_stream_zero FROM spotify_youtube WHERE stream = 0;

-- Ação: Deletar as linhas onde o stream é zero.
DELETE FROM spotify_youtube
WHERE stream = 0;

-- Verificação: A contagem agora deve ser 0.
SELECT COUNT(*) AS depois_remocao_stream_zero FROM spotify_youtube WHERE stream = 0;

-- 4. Remoção de Faixas com Tempo Inválido
-- A EDA identificou faixas com tempo = 0 BPM, o que é um valor físico inválido.
-- Estes registros serão removidos para garantir a integridade das análises estatísticas.

-- Verificação ANTES da remoção.
SELECT COUNT(*) AS antes_remocao_tempo_zero FROM spotify_youtube WHERE tempo = 0;

-- Ação: Deletar as linhas onde o tempo é zero.
DELETE FROM spotify_youtube
WHERE tempo = 0;

-- Verificação DEPOIS da remoção. O resultado esperado é 0.
SELECT COUNT(*) AS depois_remocao_tempo_zero FROM spotify_youtube WHERE tempo = 0;

-- 5. Verificação Final do Tamanho do Dataset
-- Confirma o número total de linhas após todas as etapas de limpeza.
SELECT COUNT(*) AS total_faixas_apos_limpeza FROM spotify_youtube;

-- 6. Verficação dos dados consolidados (contem o separador '|')
SELECT
    artist,
    track,
    stream
FROM
    spotify_youtube
WHERE
    artist LIKE '%|%';

-- 7. Tabela Final
SELECT * FROM spotify_youtube;