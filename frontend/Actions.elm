module Actions (..) where

import Models exposing (..)
import Http


type alias EventID = Int

type Action
  = NewEvents (Result Http.Error (List Event))
  | ToggleDescription EventID
