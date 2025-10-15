-- =================================================================================
-- |                                                                               |
-- |                      BLOCO 01: CRIAÇÃO DA TABELA (SCHEMA)                     |
-- |                                                                               |
-- =================================================================================
-- Definir a estrutura da tabela 'spotify_youtube' com a ordem de
-- colunas correspondendo exatamente ao arquivo CSV de origem.
-- O dataset que será usado:  
-- https://www.kaggle.com/datasets/sanjanchaudhari/spotify-dataset/code
-- ======================================================+++++++++++++==============

-- Garante que a tabela seja recriada do zero a cada execução do script.
DROP TABLE IF EXISTS spotify_youtube;

-- Cria a tabela 'spotify_youtube' com a ordem de colunas correta.
CREATE TABLE spotify_youtube (
    artist TEXT NOT NULL,
    track TEXT NOT NULL,
    album TEXT NOT NULL,
    album_type VARCHAR(50),
    danceability REAL,
    energy REAL,
    loudness REAL,
    speechiness REAL,
    acousticness REAL,
    instrumentalness REAL,
    liveness REAL,
    valence REAL,
    tempo REAL,
    duration_min REAL, 
    title TEXT, 
    channel TEXT,
    views BIGINT,
    likes BIGINT,
    comments BIGINT,
    licensed BOOLEAN,
    official_video BOOLEAN,
    stream BIGINT NOT NULL,
    energy_liveness REAL,
    most_played_on VARCHAR(50)
);
