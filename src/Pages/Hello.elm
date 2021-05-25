module Pages.Hello exposing (..)


import Html exposing (..)
import Html.Attributes exposing (class, href)
import Http
import Json.Decode as Decode
import Player exposing (Player)
import Routes
import Shared exposing (..)


type alias Model = Int

init : ( Model, Cmd msg )
init =
    ( 0, Cmd.none )

initialModel : Model
initialModel =
    0

view : Model -> Html msg
view model =
    div []
        [ button [] [ text "-" ]
        , text (String.fromInt model)
        , button [] [ text "+" ]
        ]