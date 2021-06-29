module Styles.Content exposing (..)
import Html exposing (Attribute)
import Html.Attributes exposing (style)
import Styles.Colors exposing (blueColor, whiteColor)

contentContainer : List (Attribute msg)
contentContainer =
    [
      style "display" "flex"
    , style "width" "100%"
    , style "flex-direction" "column"
    , style "padding" "20px"
    ]

contentImageContainer : List (Attribute msg)
contentImageContainer =
    [
     style "align-self" "center"
    ]

contentImage : List (Attribute msg)
contentImage =
    [
      style "width" "200px"
    , style "height" "200px"
    ]

contentInfoContainer : List (Attribute msg)
contentInfoContainer =
    [
      style "width" "200px"
    , style "align-self" "center"
    , style "margin-top" "10px"
    , style "text-align" "center"
    ]

addToBasketButtonStyle : List (Attribute msg)
addToBasketButtonStyle =
    [
      style "background-color" blueColor
    , style "padding" "4px 20px"
    , style "margin-top" "5px"
    , style "text-align" "center"
    , style "border-radius" "10px"
    , style "color" whiteColor
    ]