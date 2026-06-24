CREATE TABLE IF NOT EXISTS songs (
    id INTEGER PRIMARY KEY,
    name TEXT NOT NULL,
    artist_id INTEGER NOT NULL,
    tempo REAL,
    energy REAL,
    danceability REAL
);

INSERT INTO songs (id, name, artist_id, tempo, energy, danceability) VALUES
(1, 'Dance Monkey', 1, 98.0, 0.82, 0.82),
(2, 'Blinding Lights', 2, 171.0, 0.73, 0.51),
(3, 'Shape of You', 3, 96.0, 0.65, 0.83),
(4, 'Rockstar', 4, 159.9, 0.53, 0.58),
(5, 'One Dance', 5, 103.9, 0.62, 0.79),
(6, 'Closer', 6, 95.0, 0.67, 0.75),
(7, 'Sunflower', 7, 93.0, 0.48, 0.76),
(8, 'Señorita', 8, 117.0, 0.55, 0.75),
(9, 'Memories', 5, 89.9, 0.44, 0.76),
(10, 'Bad Guy', 9, 135.0, 0.43, 0.70),
(11, 'Lucid Dreams', 10, 83.9, 0.46, 0.51),
(12, 'Happier', 11, 100.0, 0.64, 0.60),
(13, 'God''s Plan', 5, 77.2, 0.45, 0.75),
(14, 'Shallow', 12, 96.0, 0.43, 0.51),
(15, 'In My Feelings', 5, 91.9, 0.52, 0.84);
