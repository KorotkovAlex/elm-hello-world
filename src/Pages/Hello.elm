module Pages.Hello exposing (..)

import Html exposing (..)
import Shared exposing (..)

type alias Model = Int

type Msg = Nothing

init : ( Model, Cmd Msg )
init =
    ( 0, Cmd.none )

initialModel : Model
initialModel =
    0

view : Model -> Html Msg
view model =
    div []
        [ button [] [ text "-" ]
        , text (String.fromInt model)
        , button [] [ text "+" ]
        ]