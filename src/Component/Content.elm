module Component.Content exposing (..)

import Models.Content exposing (ContentInfo)
import Html exposing (..)
import Html.Events exposing (onClick)
import Html.Attributes exposing (src)

import Styles.Content exposing (..)

type Msg = AddToBasket ContentInfo | RemoveFromBasket ContentInfo

showButtonView : ContentInfo -> Bool -> Html Msg
showButtonView contentInfo isShowRemoveButton  =
  if isShowRemoveButton then
    button ([onClick (RemoveFromBasket contentInfo)] ++ addToBasketButtonStyle) [ text " - "]
  else
    button ([onClick (AddToBasket contentInfo)] ++ addToBasketButtonStyle) [ text " + "]

view : ContentInfo -> Bool -> Html Msg
view contentInfo isShowRemoveButton =
    div ([] ++ contentContainer) [
      div ([] ++ contentImageContainer) [
        img ([src contentInfo.artworkUrl100] ++ contentImage) []
      ],
      div ([] ++ contentInfoContainer) [
        text contentInfo.artistName,
        showButtonView contentInfo isShowRemoveButton
      ]
    ]