module Util where

import qualified Data.Configurator as Conf
import Data.Configurator.Types
import Data.List
import Data.Time.Format (parseTimeOrError, defaultTimeLocale, ParseTime)
import System.Environment


replaceRN :: String -> String
replaceRN [] = []
replaceRN ('\r':'\n':xs) = "<br>" ++ replaceRN xs
replaceRN ('\n':'\r':xs) = "<br>1" ++ replaceRN xs
replaceRN ('\n':xs) = "<br>" ++ replaceRN xs
replaceRN ('\r':xs) = "<br>" ++ replaceRN xs
replaceRN (x:xs) = x : replaceRN xs


getConfig :: [String] -> String
getConfig ["-c", x]  = x
getConfig [] = "kamdanes.cfg"


getOption :: Configured b => Name -> IO b
getOption name = do
    args <- getArgs
    config <- Conf.load [ Conf.Required (getConfig args)]
    Conf.require config name


-- handles datetime and date formats
parseFacebookTime :: ParseTime t => String -> t
parseFacebookTime s = parseTimeOrError True defaultTimeLocale (getFormat s) s
    where getFormat f = if isInfixOf "T" f then "%FT%T%z" else "%F"
