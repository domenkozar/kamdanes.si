module Actions exposing (..)

import Http
import Models exposing (..)

type alias EventID = Int

type Msg
  = FetchSucceed (List Event)
  | FetchFail Http.Error
  | ToggleDescription EventID
