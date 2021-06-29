module Component.Content exposing (..)

import Models.Content exposing (ContentInfo)
import Html exposing (..)
import Html.Events exposing (onInput, onClick)
import Html.Attributes exposing (placeholder, src, href, value, height, width)

type Msg = AddToBasket ContentInfo

view : ContentInfo -> Html Msg
view contentInfo =
    div [] [
      text contentInfo.artistName,
      button [onClick (AddToBasket contentInfo)] [ text " + "]
    ]