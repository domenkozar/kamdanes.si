{-# LANGUAGE EmptyDataDecls             #-}
{-# LANGUAGE FlexibleContexts           #-}
{-# LANGUAGE GADTs                      #-}
{-# LANGUAGE GeneralizedNewtypeDeriving #-}
{-# LANGUAGE MultiParamTypeClasses      #-}
{-# LANGUAGE OverloadedStrings          #-}
{-# LANGUAGE QuasiQuotes                #-}
{-# LANGUAGE TemplateHaskell            #-}


import System.Locale
import Data.Time.Format
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


pages = ["zootobacna/events", "klubtiffany/events"]


constructEvent :: Text -> IO Event
constructEvent id = do
    let id_ = unpack id
    accesstoken <- getOption"kamdanes.accesstoken" :: IO String
    r <- liftIO $ Wreq.get $ "https://graph.facebook.com/v2.2/" ++ id_ ++ "?access_token=" ++ accesstoken
    let body = r ^. responseBody
        eventid = (read id_ :: Int)
        title = unpack $ body ^. key "name" . _String
        location = unpack $ body ^. key "location" . _String
        time = readTime defaultTimeLocale "%FT%T+0100" $ unpack $ body ^. key "start_time" . _String
        description = pack $ replaceRN $ unpack $ body ^. key "description" . _String
        link = "https://www.facebook.com/events/" ++ id_
        image = "https://graph.facebook.com/v2.2/" ++ id_ ++ "/picture?access_token=" ++ accesstoken
    return $ Event eventid title location time description link (Just image) Nothing


fetchEvent :: String -> IO [Event]
fetchEvent url = do
    accesstoken <- getOption "kamdanes.accesstoken" :: IO String
    r <- Wreq.get $ "https://graph.facebook.com/v2.2/" ++ url ++ "?access_token=" ++ accesstoken
    let ids = r ^. responseBody ^.. key "data" . _Array . traverse . to (\o -> (o ^?! key "id" . _String))
    events <- mapM constructEvent ids
    return events



main :: IO ()
main = do
    connStr <- getOption "kamdanes.connstr"
    runDB connStr $ do
        runMigration migrateAll
        events <- liftIO $ mapM fetchEvent pages
        mapM insert $ concat events
        liftIO $ print "Done."