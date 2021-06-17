module Pages.Details exposing (..)
import Html exposing (..)
import Models.Content exposing (ContentInfo)

type alias Model =
    {
        contentInfo: Maybe ContentInfo
    }

init : ( Model, Cmd msg )
init =
    ( { contentInfo = Nothing }, Cmd.none)

view : Model -> Html msg
view model =
  div [] [
    text "!!!!!!!!!contentInfo \n"
  ]

