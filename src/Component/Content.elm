module Component.Content exposing (..)

import Models.Content exposing (ContentInfo)
import Html exposing (..)
import Html.Events exposing (onClick)
import Html.Attributes exposing (src)

import Styles.Content exposing (..)

type Msg = AddToBasket ContentInfo

view : ContentInfo -> Html Msg
view contentInfo =
    div ([] ++ contentContainer) [
      div ([] ++ contentImageContainer) [
        img ([src contentInfo.artworkUrl100] ++ contentImage) []
      ],
      div ([] ++ contentInfoContainer) [
        text contentInfo.artistName,
        div [] [
          button ([onClick (AddToBasket contentInfo)] ++ addToBasketButtonStyle) [ text " + "]
        ]
      ]
    ]