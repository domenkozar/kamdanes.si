module Update exposing (..)

import List

import Models exposing (..)
import Actions exposing (..)


update : Msg -> AppModel -> ( AppModel, Cmd Msg )
update action model =
  case action of
    FetchSucceed events ->
      ( AppModel (Ok events), Cmd.none )

    FetchFail msg ->
      ( AppModel (Err (toString msg)), Cmd.none )

    ToggleDescription eventID ->
      case model.events of
        Ok events ->
          let
            toggleEvent event =
              if event.id == eventID
              then {event | showDescription = not event.showDescription}
              else event
            newevents = List.map toggleEvent events
          in ( AppModel (Ok newevents), Cmd.none )
        Err msg -> ( AppModel (Err msg), Cmd.none )
