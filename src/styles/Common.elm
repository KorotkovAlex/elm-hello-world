module Styles.Common exposing (..)
import Html exposing (Attribute)
import Html.Attributes exposing (style)


searchInputLineStyle : List (Attribute msg)
searchInputLineStyle =
    [ style "border-radius" "5px"
    , style "border" "solid"
    , style "padding" "20px"
    , style "width" "500px"
    ]