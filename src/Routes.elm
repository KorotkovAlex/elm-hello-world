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
        [ map HomeRoute (s "elm-hello-world")
        , map HomeRoute (s "elm-hello-world/home")
        , map BasketRoute (s "elm-hello-world/basket")
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
        HomeRoute -> "/elm-hello-world"
        BasketRoute -> "/elm-hello-world/basket"
        DetailsRoute id -> "/elm-hello-world/details/" ++ String.fromInt id
        NotFoundRoute -> "/"
