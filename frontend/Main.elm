module Main (..) where

import Html exposing (..)
import Effects exposing (Effects, Never)
import Task
import StartApp
import Http
import Json.Decode as Json
import Json.Decode exposing ((:=))
import Json.Decode.Extra exposing ((|:))
import Date

import Actions exposing (..)
import Models exposing (..)
import Update exposing (..)
import View exposing (..)


init : ( AppModel, Effects Action )
init = ( initialModel, getEvents )


getEvents : Effects Action
getEvents =
  Http.get decodeEvent "/events"
    |> Task.toResult
    |> Task.map NewEvents
    |> Effects.task


decodeEvent : Json.Decoder (List Event)
decodeEvent =
  "events" := (Json.list (Json.succeed Event
    |: ("id" := Json.int)
    |: ("title" := Json.string)
    |: ("description" := Json.string)
    |: (("time" := Json.string) `Json.andThen` decodeTime)
    |: ("location" := Json.string)
    |: ("link" := Json.string)
    |: ("image" := Json.string)
    |: (Json.maybe ("showDescription" := Json.bool) `Json.andThen` decodeShowDescription)
  ))
decodeShowDescription : Maybe Bool -> Json.Decoder Bool
decodeShowDescription showDescription =
  Json.succeed (Maybe.withDefault False showDescription)

decodeTime : String -> Json.Decoder (Result String Date.Date)
decodeTime time =
    Date.fromString time
      |> Json.succeed

app : StartApp.App AppModel
app =
  StartApp.start
    { init = init
    , update = update
    , view = view
    , inputs = []
    }


main : Signal.Signal Html
main =
  app.html


port runner : Signal (Task.Task Never ())
port runner =
  app.tasks
