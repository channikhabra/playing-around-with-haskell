module GolfSpec
  ( spec
  ) where

import           Test.Hspec

import           Golf

spec :: Spec
spec = do
  describe "skips" $ do
    it "should return correct list of lists" $ do
      skips "ABCD" `shouldBe` ["ABCD", "BD", "C", "D"]
      skips "hello!" `shouldBe` ["hello!", "el!", "l!", "l", "o", "!"]
      skips [1] `shouldBe` [[1]]
      skips [True, False] `shouldBe` [[True, False], [False]]

  describe "localMaxima" $ do
    it "should return correct list of local maximas" $ do
      localMaxima [2,9,5,6,1] `shouldBe` [9,6]
      localMaxima [2,3,4,1,5] `shouldBe` [4]
      localMaxima [1,2,3,4,5] `shouldBe` []

  describe "histogram" $ do
    it "should return correct list of local maximas" $ do
      histogram [1,1,1,5] `shouldBe` " *\n *\n *   *\n==========\n0123456789"
      histogram [1,4,5,4,6,6,3,4,2,4,9] `shouldBe` "    *\n    *\n    * *\n ******  *\n==========\n0123456789"
