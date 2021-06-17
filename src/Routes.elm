module Routes exposing (Route(..), parseUrl, pathFor)

import Url exposing (Url)
import Url.Parser exposing (..)

type Route
    = HomeRoute
    | BasketRoute
    | DetailsRoute Int
    | NotFoundRoute


matchers : Parser (Route -> a) a
matchers =
    oneOf
        [ map HomeRoute top
        , map HomeRoute (s "home")
        , map BasketRoute (s "basket")
        , map DetailsRoute (s "details" </> int)
        ]


parseUrl : Url -> Route
parseUrl url =
    case parse matchers url of
        Just route ->
            route

        Nothing ->
            NotFoundRoute


pathFor : Route -> String
pathFor route =
    case route of
        HomeRoute -> "/home"
        BasketRoute -> "/basket"
        DetailsRoute id -> "details/" ++ String.fromInt id
        NotFoundRoute -> "/"
