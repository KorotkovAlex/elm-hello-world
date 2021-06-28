module Styles.Common exposing (..)
import Html exposing (Attribute)
import Html.Attributes exposing (style)


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
      style "justify-self" "start",
      style "flex" "1",
      style "text-indent" "10px"
    ]

searchButtonStyle : List (Attribute msg)
searchButtonStyle =
    [
      style "border-radius" "0px 10px 10px 0px",
      style "background-color" "rgb(18, 147, 216)",
      style "padding-left" "10px",
      style "padding-right" "10px",
      style "color" "white"
    ]

headerStyle : List (Attribute msg)
headerStyle =
    [
      style "display" "flex"
    , style "height" "40px"
    , style "width" "100%"
    , style "justify-content" "center"
    ]