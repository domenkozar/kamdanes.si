module Main exposing (..)

import Html.App as Html
import Task
import Http
import Json.Decode as Json
import Json.Decode exposing ((:=))
import Json.Decode.Extra exposing ((|:))
import Date

import Actions exposing (..)
import Models exposing (..)
import Update exposing (..)
import View exposing (..)


init : ( AppModel, Cmd Msg )
init = ( initialModel, getEvents )


getEvents : Cmd Msg
getEvents =
  Task.perform FetchFail FetchSucceed (Http.get decodeEvent "/events")


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


main : Program Never
main =
  Html.program
    { init = init
    , update = update
    , view = view
    , subscriptions = subscriptions
    }

subscriptions : AppModel -> Sub Msg
subscriptions model =
  Sub.none
