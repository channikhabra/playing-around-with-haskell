module Week5.Calc where

import           Week5.ExprT
import           Week5.Parser

eval :: ExprT -> Integer
eval x = case x of
  Lit n   -> n
  Add a b -> (eval a) + (eval b)
  Mul a b -> (eval a) * (eval b)

evalStr :: String -> Maybe Integer
evalStr = fmap eval . parseExp Lit Add Mul

class Expr a where
  lit :: Integer -> a
  add :: a -> a -> a
  mul :: a -> a -> a

instance Expr ExprT where
  lit x = Lit x
  add a b = Add a b
  mul a b = Mul a b
