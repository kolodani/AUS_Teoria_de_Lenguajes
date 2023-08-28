{-

Dada la siguiente gramática:
G = ( {E, Ep , V, I, D},
{+, −, ∗, /, (, ), x, y, z, 0, 1, 2, 3, 4, 5, 6, 7, 8, 9},
P, E)
donde P tiene las siguientes producciones:
E  →  E + E | E − E | E ∗ E | E/E | Ep
Ep →  V | I | (E)
V  →  x | y | z
I  →  DI | D
D  →  0 | 1 | 2 | 3 | 4 | 5 | 6 | 7 | 8 | 9

a) Dibujar el árbol de parseo de las siguientes expresiones
1)  1+ x
2)  (99 + 4 ∗ y ∗ (x − 678))
3)  69 ∗ x − z
4)  −1
-}

-- 1)  1+ x
--    E
--  / | \
-- E  +  E
-- |     |
-- Ep    Ep
-- |     |
-- I     V
-- |     |
-- D     x
-- |
-- 1

