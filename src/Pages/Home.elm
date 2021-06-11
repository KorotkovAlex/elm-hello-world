module Pages.Home exposing (..)

import Html exposing (..)
import Http
import Models.Content exposing (Content, ContentInfo, decoder)
import Shared exposing (..)
import Debug exposing (log)
import String exposing(..)

type alias Model =
    {
        searchText: String,
        content: RemoteData Content
    }

init : ( Model, Cmd Msg )
init =
    ( { content = Loading, searchText = "" }, fetchContent)

type Msg
    = OnFetchContent (Result Http.Error Content)

update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        OnFetchContent (Ok players) ->
            log("players")
            ( { model | content = Loaded players }, Cmd.none )

        OnFetchContent (Err err) ->
            log("players2112")
            ( { model | content = Failure }, Cmd.none )

rowItemInfo: ContentInfo -> Html msg
rowItemInfo contentInfo =
    div []
        [ text contentInfo.artistName ]

viewWithData : Content -> Html msg
viewWithData content =
    div []
        [
            text (String.fromInt content.resultCount),
            div [] (List.map rowItemInfo content.results)
        ]

view : Model -> Html msg
view model =
    let
        content =
            case model.content of
                NotAsked ->
                    text ""

                Loading ->
                    text "Loading ..."

                Loaded items ->
                    viewWithData items

                Failure ->
                    text "Error"
    in
    div [] [content]


-- DATA

fetchContent : Cmd Msg
fetchContent =
    Http.request
    { method = "GET"
    , headers = [
        Http.header "Access-Control-Allow-Origin" "*",
        Http.header "Access-Control-Allow-Credentials" "true",
        Http.header "Access-Control-Allow-Methods" "Get",
        Http.header "Accept" "application/json",
        Http.header "Content-Type" "application/json"
    ]
    , url = ("https://itunes.apple.com/search?term=" ++ "eminem")
    , body = Http.emptyBody
    , expect = Http.expectJson OnFetchContent decoder
    , timeout = Nothing
    , tracker = Nothing
    }