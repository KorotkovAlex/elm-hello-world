module Styles.Common exposing (..)
import Html exposing (Attribute)
import Html.Attributes exposing (style)
import Styles.Colors exposing (blueColor)

mainContainerStyle : List (Attribute msg)
mainContainerStyle =
  [
    style "margin-top" "25px"
  ]

searchContainerStyle : List (Attribute msg)
searchContainerStyle =
    [
      style "width" "500px"
    , style "display" "flex"
    ]

searchInputLineStyle : List (Attribute msg)
searchInputLineStyle =
    [
      style "border-radius" "10px 0px 0px 10px",
      style "background-color" "rgb(236, 236, 236)",
      style "justify-self" "flex-start",
      style "flex" "1",
      style "text-indent" "10px"
    ]

searchButtonStyle : List (Attribute msg)
searchButtonStyle =
    [
      style "border-radius" "0px 10px 10px 0px",
      style "background-color" blueColor,
      style "padding-left" "10px",
      style "padding-right" "10px",
      style "color" "white"
    ]

basketContainerStyle : List (Attribute msg)
basketContainerStyle =
    [
      style "justify-self" "flex-end",
      style "align-self" "center",
      style "margin-left" "50px"
    ]

basketImageStyle : List (Attribute msg)
basketImageStyle =
    [
      style "position" "relative"
    ]


basketCounterStyle : List (Attribute msg)
basketCounterStyle =
  [
    style "position" "absolute",
    style "bottom" "-3px",
    style "right" "-5px"
  ]

headerStyle : List (Attribute msg)
headerStyle =
    [
      style "display" "flex"
    , style "height" "40px"
    , style "width" "100%"
    , style "justify-content" "center"
    ]

contentGridStyle : List (Attribute msg)
contentGridStyle =
  [
    style "display" "grid",
    style "grid-template-columns" "repeat(4, 1fr)",
    style "margin" "5em",
    style "grid-column-gap" "2em",
    style "grid-row-gap" "2em",
    style "align-content" "center",
    style "justify-content" "center"
  ]