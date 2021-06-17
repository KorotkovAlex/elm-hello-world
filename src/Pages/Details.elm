module Pages.Details exposing (..)
import Html exposing (..)
import Models.Content exposing (ContentInfo)

type alias Model =
    {
        contentInfo: Maybe ContentInfo,
        id: Int
    }


init : Int -> ( Model, Cmd msg )
init id =
    ( { 
      contentInfo = Nothing,
      id = id
      }, Cmd.none)

view : Model -> Html msg
view model =
  div [] [
    text "!!!!!!!!!contentInfo \n",
    text (String.fromInt model.id)
  ]

