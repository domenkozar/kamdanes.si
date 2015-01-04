{-# LANGUAGE OverloadedStrings #-}

import Control.Monad.IO.Class  (liftIO)
import Data.Time.Clock
import Data.Time.Format
import Data.Aeson (object, (.=))
import qualified Database.Persist as P
import qualified Database.Persist.Postgresql as Postgresql
import qualified Database.Persist.Sql as Sql

import Network.Wai.Middleware.RequestLogger
import Network.Wai.Middleware.Static
import Web.Scotty

import Models
import Util


app :: ScottyM ()
app = do
  get "/events"
    events
  get "/"
    root
  notFound $
    json ("404 Not Found" :: String)

root :: ActionM ()
root =
  file "./static/index.html"

events :: ActionM ()
events = do
  connStr <- liftIO $ getOption "kamdanes.connstr"
  time <- liftIO getCurrentTime
  events <- liftIO $ runDB connStr $ P.selectList [EventTime P.>. addUTCTime (-21600) time] [ P.Asc EventTime ]
  json $ object [ "events" .= events ] 

main = scotty 3000 $ do
  connStr <- liftIO $ getOption "kamdanes.connstr"
  liftIO $ runDB connStr $ Postgresql.runMigration migrateAll
  middleware logStdoutDev
  middleware $ staticPolicy hasPrefix "static/"
  app