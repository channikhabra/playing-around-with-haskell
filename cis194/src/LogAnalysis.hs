module LogAnalysis
  ( parseMessage
  , parse
  , insert
  , build
  , inOrder
  , whatWentWrong
  ) where

import           LogAnalysis.Internal

parseMessage :: String -> LogMessage
parseMessage str =
  case words str of
    "E":n:ts:ws -> LogMessage (Error $ read n) (read ts) (unwords ws)
    "I":ts:ws   -> LogMessage Info (read ts) (unwords ws)
    "W":ts:ws   -> LogMessage Warning (read ts) (unwords ws)
    otherwise   -> Unknown str

parse :: String -> [LogMessage]
parse = mapFunc parseMessage . lines
  where
    mapFunc func str =
      case str of
        []   -> []
        x:xs -> func x : mapFunc func xs

insert :: LogMessage -> MessageTree -> MessageTree
insert (Unknown _) tree = tree
insert msg Leaf         = Node Leaf msg Leaf
insert m1@(LogMessage _ t1 _) (Node left m2@(LogMessage _ t2 _) right)
  | t1 >= t2 = Node left m2 (insert m1 right)
  | t1 < t2 = Node (insert m1 left) m2 right

build :: [LogMessage] -> MessageTree
build = insertIn Leaf
  where
    insertIn tree []     = tree
    insertIn tree (m:ms) = insertIn (insert m tree) ms

inOrder :: MessageTree -> [LogMessage]
inOrder Leaf                  = []
inOrder (Node left msg right) = (inOrder left) ++ [msg] ++ (inOrder right)

whatWentWrong :: [LogMessage] -> [String]
whatWentWrong = pickImportant . sortByTs
  where
    sortByTs = inOrder . build
    pickImportant [] = []
    pickImportant (x:xs) = case x of
      (LogMessage (Error p) _ msg) -> (if p > 50 then [msg] else []) ++ whatWentWrong xs
      otherwise                    -> whatWentWrong xs
