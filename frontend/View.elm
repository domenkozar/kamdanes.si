module View (..) where

import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (onClick)
import Json.Encode exposing (string)
import Date
import Result
import Maybe

import Actions exposing (..)
import Models exposing (..)

resultWithDefault : a -> Result b a -> a
resultWithDefault default result =
  Result.toMaybe result
    |> Maybe.withDefault default


view : Signal.Address Action -> AppModel -> Html
view address model =
  let
    items = List.map (viewEvent address) (resultWithDefault [] model.events)
    userMsg = case model.events of
      Ok value -> "Ni dogodkov :("
      Err "Loading" -> "Loading ..."
      Err msg -> "Prišlo je do napake: " ++ msg ++ ". Prosimo osvežite stran."
  in
  div
    []
    [ ul
        [ class "list-group"
        , style
            [ ("maxWidth", "600px")
            , ("margin", "5px auto")
            ]
        ]
        ([ li
          [ class "list-unstyled text-center" ]
          [ h3
            []
            [ text "Danes v Ljubljani" ]
          ]
        ] ++ items ++ if List.isEmpty items then [
          li
          [ class "list-unstyled text-center" ]
          [ i
            []
            [ text userMsg]
          ]
        ] else [])
    , p
        [ class "text-center" ]
        [ small
          []
          [ text "Za dodatne lokacije piši na "
          ,  a [ href "mailto:domen@dev.si" ] [ text "domen@dev.si" ]
          ,  text "."
          ]
        ]
    ]


viewEvent : Signal.Address Action -> Event -> Html
viewEvent address event =
  let
    time = case event.time of
      -- TODO: hour is am/pm
      Ok value -> toString (Date.hour value) ++ ":" ++ toString (Date.minute value)
      Err msg -> msg
  in
  li
    [ class "list-group-item"]
    [ div
        [ class "media" ]
        [ a
          [ class "media-left"
          , href event.link ]
          [ img
            [ src event.image
            , alt "Event image"
            , style [ ("width", "128px") ]
            ]
            []
          ]
        , div
          [ class "media-body"
          , style [ ("width", "100%") ]
          ]
          ([ h4
            [ class "media-heading" ]
            [ a
              [ href event.link ]
              [ text event.title ]
            ]
          , h4
            []
            [ span
              [ class "label label-danger"]
              [ text event.location ]
            ]
          , h5
            []
            [ i
              []
              [ text "Začetek: "
              -- TODO: timeago
              , text time ]
            , span
              [ class "label label-primary"]
              [] -- TODO: if price
            ]
          , button
            [ (onClick address (ToggleDescription event.id))
            , class "btn btn-primary" ]
            [ span
              [ class "glyphicon glyphicon-info-sign" ]
              (if event.showDescription then
                [ text " Skrij opis" ]
              else
                [ text " Opis dogodka" ])
            ]
          ] ++
          if event.showDescription
          then [ div
                 [ property  "innerHTML" <| string event.description ]
                 [] ]
          else []
          )
        ]
    ]
