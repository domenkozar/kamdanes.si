module Util where


import qualified Data.Configurator as Conf
import Data.Configurator.Types
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