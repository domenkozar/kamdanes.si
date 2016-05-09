module Update (..) where

import List
import Effects exposing (Effects)

import Models exposing (..)
import Actions exposing (..)


update : Action -> AppModel -> ( AppModel, Effects Action )
update action model =
  case action of
    NewEvents result ->
      case result of
        Ok events -> ( AppModel (Ok events), Effects.none )
        Err httpCode -> ( AppModel (Err (toString httpCode)), Effects.none )
    ToggleDescription eventID ->
      case model.events of
        Ok events ->
          let
            toggleEvent event =
              if event.id == eventID
              then {event | showDescription = not event.showDescription}
              else event
            newevents = List.map toggleEvent events
          in ( AppModel (Ok newevents), Effects.none )
        Err msg -> ( AppModel (Err msg), Effects.none )
