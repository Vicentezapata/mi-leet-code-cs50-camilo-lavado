CREATE TABLE IF NOT EXISTS artists (
    id INTEGER PRIMARY KEY,
    name TEXT NOT NULL
);

CREATE TABLE IF NOT EXISTS songs (
    id INTEGER PRIMARY KEY,
    name TEXT NOT NULL,
    artist_id INTEGER NOT NULL,
    FOREIGN KEY (artist_id) REFERENCES artists(id)
);

INSERT INTO artists (id, name) VALUES
(1, 'Billie Eilish'),
(2, 'Drake'),
(3, 'Ed Sheeran'),
(4, 'Post Malone'),
(5, 'Taylor Swift'),
(6, 'The Weeknd');

INSERT INTO songs (id, name, artist_id) VALUES
(1,  'Bad Guy',         1),
(2,  'Therefore I Am',  1),
(3,  'God''s Plan',      2),
(4,  'One Dance',       2),
(5,  'Hotline Bling',   2),
(6,  'Shape of You',    3),
(7,  'Perfect',         3),
(8,  'Rockstar',        4),
(9,  'Sunflower',       4),
(10, 'Circles',         4),
(11, 'Anti-Hero',       5),
(12, 'Shake It Off',    5),
(13, 'Blinding Lights', 6),
(14, 'Starboy',         6),
(15, 'Save Your Tears', 6);
