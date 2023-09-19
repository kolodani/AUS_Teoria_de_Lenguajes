import Parsing  
import Control.Monad
import Control.Applicative ((<|>))

{- 1) Escribir un trasformador que al recibir un parser, devuelve un nuevo parser que se comporta
como el original pero que tambi´en acepta opcionalmente las cadenas que est´en entre par´entesis -}

parent p = do  char '('
               x <- p
               char ')'
               return x

entreP p = parent p <|> p

{- 3) Escribir un parser para listas heterog´eneas de enteros y caracteres. Definir un tipo de datos
en haskell adecuado para representarlas. Ejemplo [3, ’z’, ’r’, 7, 9, 22, ’1’]-}

data Elem = I Int | C Char deriving Show
type ListHetero = [Elem]

-- [3, ’z’, ’r’, 7, 9, 22, ’1’] ---> [I 3,C ’z’,C ’r’,I 7,I 9,I 22,C ’1’]

entero :: Parser Elem
entero = do i <- int 
            return (I i)

caracter :: Parser Elem
caracter = do char '\''
              c <- item
              char '\''
              return (C c)

elemento :: Parser Elem
elemento = entero <|> caracter

listaH :: Parser ListHetero
listaH = do char '['
            xs <- sepBy elemento (char ',')
            char ']'
            return xs


{-

expr -> expr ('+' term | '-' term)) | term
term -> term ('*' factor | '/' factor) | factor
factor -> digit | '('expr')'
digit ->  '0' | '1' | '2' | ... | '9'

A -> A a | b
A -> b A'
A' -> E | a A'

expr -> term expr'
expr' -> empty | ('+' term | '-' term) expr'
term -> factor term'
term' -> empty | ('*' factor | '/' factor) term'
factor -> digit | '(' expr' ')'
digit -> '0' | '1' | '2' | ... | '9'

-}

expr :: Parser Int
expr = do t <- term
          e <- expr'
          return (e t)

expr' = do char '+'
           t <- term   
           e' <- expr'
           return (e'.(\x-> x+t))
           --return (e'.(+t)
          <|>
           do char '-'
              t <- term
              e' <- expr'
              return (e'.(\x -> x-t))
             <|> return id


term :: Parser Int
term = do f <- factor
          t' <- term'
          return (t' f)

term' = do char '*'
           f <- factor
           t' <- term'
           return (t'.(*f))
          <|>
           do char '/'
              f <- factor
              t' <- term'
              return (t'.(\x -> x `div`f))
            <|> return id

factor :: Parser Int
factor = do d <- nat
            return d
           <|>
            do char '('
               e <- expr
               char ')'
               return e


eval xs = fst (head(parse expr xs))          
          
