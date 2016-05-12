module Models exposing (..) 

import Date


type alias AppModel =
  { events : Result String (List Event)
  }

type alias Event =
  { id : Int
  , title : String
  , description : String
  , time : Result String Date.Date
  , location : String
  , link : String  -- URL
  , image : String -- URL
  , showDescription : Bool
  }

initialModel : AppModel
initialModel =
  AppModel (Err "Loading")
