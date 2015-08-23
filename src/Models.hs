{-# LANGUAGE EmptyDataDecls             #-}
{-# LANGUAGE FlexibleContexts           #-}
{-# LANGUAGE FlexibleInstances          #-}
{-# LANGUAGE GADTs                      #-}
{-# LANGUAGE GeneralizedNewtypeDeriving #-}
{-# LANGUAGE MultiParamTypeClasses      #-}
{-# LANGUAGE OverloadedStrings          #-}
{-# LANGUAGE QuasiQuotes                #-}
{-# LANGUAGE TemplateHaskell            #-}
{-# LANGUAGE TypeFamilies               #-}

module Models where

import Data.Text (Text)
import Data.Time (UTCTime)
import Database.Persist
import Database.Persist.TH
import Database.Persist.Postgresql
import qualified Database.Persist.Sql as Sql
import Control.Monad.Logger    (runNoLoggingT)
import Control.Monad.IO.Class  (liftIO)

share [mkPersist sqlSettings, mkMigrate "migrateAll"] [persistLowerCase|
Event json
    fbId Int
    title String
    location String
    time UTCTime
    description Text
    link String
    image String Maybe
    price Double Maybe
    deriving Show
|]


runDB :: ConnectionString -> Sql.SqlPersistM a -> IO a
runDB connStr commands =
  liftIO $ runNoLoggingT $ withPostgresqlPool connStr 10 $ \pool ->
    liftIO $ Sql.runSqlPersistMPool commands pool
