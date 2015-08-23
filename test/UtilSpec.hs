module UtilSpec (main, spec) where

import Data.Time.Clock
import Test.Hspec
import Util

main :: IO ()
main = hspec spec

spec :: Spec
spec = do
  describe "parseFacebookTime" $ do
    it "parses timezones" $
      (parseFacebookTime "2015-05-05T05:12:05-02:00" :: UTCTime) `shouldBe` (parseFacebookTime "2015-05-05T04:12:05-03:00" :: UTCTime)

    it "parses dates" $
      (parseFacebookTime "2015-05-05" :: UTCTime) `shouldBe` (parseFacebookTime "2015-05-05T00:00:00-00:00" :: UTCTime)

  describe "replaceRN" $ do
    it "works" $
      replaceRN "\r\na\nb\rc" `shouldBe` "<br>a<br>b<br>c"
