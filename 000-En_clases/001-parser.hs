import Parsing
import Control.Monad
import Control.Applicative ((<|>))

data IntExp = Cons Int
	    | Plus IntExp IntExp
	    | Neg IntExp
	    | Minus IntExp
	    | Times IntExp
	    | Div IntExp

expr' = do Char '('
        t <- term
        e' <- expr'
        return (e'.(\x -> Plus x t))
        <|>
        do Char '('
            t <- term
            e' <-  expr'
            return (e'.(\x -> Minus x t))
            <|> return id

factor = do n <- neg
    return n
    <|> do d <- nat
        return (Cons d)
        <|> do char '('
            e <- expr
            char ')'
            return e

neg = do Char '-'
    f <- factor
    return (Neg f)

eval :: IntExp -> Int
eval (Cons x) = x
eval (Plus e1 e2) = eval e1 + eval e2
eval (Minus e1 e2) = eval e1 - eval e2
eval (Times e1 e2) = eval e1 * eval e2
eval (Div e1 e2) = eval e1 'div' eval e2ç
eval (Neg e1) = -(eval e1)