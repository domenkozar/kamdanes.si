{-# LANGUAGE FlexibleContexts           #-}
{-# LANGUAGE GADTs                      #-}
{-# LANGUAGE MultiParamTypeClasses      #-}
{-# LANGUAGE OverloadedStrings          #-}

import System.TimeIt
import Data.Time.Format (formatTime, defaultTimeLocale)
import Data.Aeson.Lens
import Data.Time.Clock
import Data.Text (unpack, pack)
import Data.Text.Internal
import Database.Persist
import Database.Persist.TH
import Data.ByteString.Lazy (ByteString)
import Database.Persist.Postgresql
import Control.Monad.IO.Class (liftIO)
import Control.Lens
import Network.Wreq as Wreq

import Models
import Util


constructEvent :: String -> IO Event
constructEvent id_ = do
    accesstoken <- getOption "kamdanes.accesstoken" :: IO String
    r <- liftIO $ Wreq.get $ "https://graph.facebook.com/v2.2/" ++ id_ ++ "?access_token=" ++ accesstoken
    let body = r ^. responseBody
        eventid = read id_ :: Int
        title = unpack $ body ^. key "name" . _String
        location = unpack $ body ^. key "location" . _String
        time = parseFacebookTime  $ unpack $ body ^. key "start_time" . _String
        description = pack $ replaceRN $ unpack $ body ^. key "description" . _String
        link = "https://www.facebook.com/events/" ++ id_
        image = "https://graph.facebook.com/v2.2/" ++ id_ ++ "/picture?type=large&access_token=" ++ accesstoken
    return $ Event eventid title location time description link (Just image) Nothing


fetchPage :: String -> IO [Event]
fetchPage url = do
    time <- getCurrentTime
    accesstoken <- getOption "kamdanes.accesstoken" :: IO String
    let timeInt = read (formatTime defaultTimeLocale "%s" time) :: Int
    r <- Wreq.get $ "https://graph.facebook.com/v2.2/" ++ url ++ "?access_token=" ++ accesstoken ++ "&since=" ++ show timeInt ++ "&until=" ++ show (timeInt + 86400)
    let ids = r ^. responseBody ^.. key "data" . _Array . traverse . to (\o -> o ^?! key "id" . _String)
    mapM (constructEvent . unpack) ids


main :: IO ()
main = timeIt $ do
    connStr <- getOption "kamdanes.connstr"
    places <- getOption "kamdanes.places" :: IO [String]
    runDB connStr $ do
        runMigration migrateAll
        events <- fmap concat $ liftIO $ mapM fetchPage places
        mapM_ insert events
        liftIO $ putStrLn $ "Fetched " ++ show (length events) ++ " events."
