module Component.Content exposing (..)

import Models.Content exposing (ContentInfo)
import Html exposing (..)
import Html.Events exposing (onClick)
import Html.Attributes exposing (src)

import Common as CommonStyles

type Msg = AddToBasket ContentInfo | RemoveFromBasket ContentInfo

showButtonView : ContentInfo -> Bool -> Html Msg
showButtonView contentInfo isShowRemoveButton  =
  if isShowRemoveButton then
    button ([onClick (RemoveFromBasket contentInfo)] ++ CommonStyles.addToBasketButtonStyle) [ text " - "]
  else
    button ([onClick (AddToBasket contentInfo)] ++ CommonStyles.addToBasketButtonStyle) [ text " + "]

view : ContentInfo -> Bool -> Html Msg
view contentInfo isShowRemoveButton =
    div ([] ++ CommonStyles.contentContainer) [
      div ([] ++ CommonStyles.contentImageContainer) [
        img ([src contentInfo.artworkUrl100] ++ CommonStyles.contentImage) []
      ],
      div ([] ++ CommonStyles.contentInfoContainer) [
        text contentInfo.artistName,
        showButtonView contentInfo isShowRemoveButton
      ]
    ]