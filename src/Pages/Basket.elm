module Pages.Basket exposing (..)

import Html exposing (..)
import Models.Content exposing (ContentInfo)
import List exposing (length)
import Pages.Home exposing (Msg)

type alias Model =
    {
        basket: List ContentInfo
    }

init : List ContentInfo -> ( Model, Cmd msg )
init basket =
    ( { basket = basket }, Cmd.none)

view : Model -> Html msg
view model =
  div [] [
    text "!!!!!!!!!Basket \n",
    text (String.fromInt (length model.basket)),
    div [] (List.map rowItemInfo model.basket)
  ]

rowItemInfo: ContentInfo -> Html msg
rowItemInfo contentInfo =
    div []
        [
            text (contentInfo.artistName ++ " ")
        ]
