module Routes exposing (Route(..), parseUrl, playerPath, playersPath)

import Url exposing (Url)
import Url.Parser exposing (..)


type Route
    = PlayersRoute
    | PlayerRoute String
    | HelloRoute
    | HomeRoute
    | NotFoundRoute


matchers : Parser (Route -> a) a
matchers =
    oneOf
        [ map HomeRoute top
        , map PlayerRoute (s "players" </> string)
        , map PlayersRoute (s "players")
        , map HelloRoute (s "hello")
        , map HomeRoute (s "home")
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
        PlayersRoute ->
            "/players"

        PlayerRoute id ->
            "/players/" ++ id

        HelloRoute ->
            "/hello"

        HomeRoute ->
            "/home"

        NotFoundRoute ->
            "/"


playersPath : String
playersPath =
    pathFor PlayersRoute


playerPath : String -> String
playerPath id =
    pathFor (PlayerRoute id)