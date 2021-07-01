module Asset exposing (Image, src, basketIcon, searchIcon)

{-| Assets, such as images, videos, and audio. (We only have images for now.)
We should never expose asset URLs directly; this module should be in charge of
all of them. One source of truth!
-}

import Html exposing (Attribute, Html)
import Html.Attributes as Attr


type Image
    = Image String



-- IMAGES

basketIcon : Image
basketIcon =
    image "basket.svg"

searchIcon : Image
searchIcon =
    image "search.svg"


image : String -> Image
image filename =
    Image ("/assets/" ++ filename)



-- USING IMAGES


src : Image -> Attribute msg
src (Image url) =
    Attr.src url