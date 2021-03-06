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
root = do
  setHeader "Content-Type" "text/html"
  file "./static/index.html"

events :: ActionM ()
events = do
  connStr <- liftIO $ getOption "kamdanes.connstr"
  time <- liftIO getCurrentTime
  events <- liftIO $ runDB connStr $ P.selectList [EventTime P.>. addUTCTime (-21600) time] [ P.Asc EventTime ]
  json $ object [ "events" .= events ]

main :: IO ()
main = do
  connStr <- liftIO $ getOption "kamdanes.connstr"
  liftIO $ runDB connStr $ Postgresql.runMigration migrateAll
  scotty 3000 $ do
    -- TODO: use logStdout in production
    middleware logStdoutDev
    middleware $ staticPolicy (noDots >-> hasPrefix "static/")
    app
