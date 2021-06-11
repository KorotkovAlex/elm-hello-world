module Pages.Home exposing (..)

import Html exposing (..)
import Http
import Models.Content exposing (Content, ContentInfo, decoder)
import Shared exposing (..)
import String exposing(..)
import Html.Events exposing (onInput, onClick)
import Html.Attributes exposing (value)
import Html.Attributes exposing (placeholder)

type alias Model =
    {
        searchText: String,
        content: RemoteData Content
    }

init : ( Model, Cmd Msg )
init =
    ( { content = NotAsked, searchText = "" }, Cmd.none)

type Msg
    = OnFetchContent (Result Http.Error Content)
    | OnInputSearchText String
    | SearchContent

update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        OnFetchContent (Ok players) ->
            ( { model | content = Loaded players }, Cmd.none )
        OnFetchContent (Err err) ->
            ( { model | content = Failure }, Cmd.none )
        OnInputSearchText searchText ->
            ( { model | searchText = searchText}, Cmd.none)
        SearchContent ->
            ( { content = Loading, searchText = "" }, fetchContent model.searchText)

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

view : Model -> Html Msg
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
    div [] [
        div [] [
            input [
                onInput OnInputSearchText,
                value model.searchText,
                placeholder "searchText"] []
            ],
            div [] [
                        button [onClick SearchContent]
                        [ text "Search"]
                    ],
            content
        ]


-- DATA

fetchContent : String -> Cmd Msg
fetchContent searchText =
    Http.request
    { method = "GET"
    , headers = [
        Http.header "Access-Control-Allow-Origin" "*",
        Http.header "Access-Control-Allow-Credentials" "true",
        Http.header "Access-Control-Allow-Methods" "Get",
        Http.header "Accept" "application/json",
        Http.header "Content-Type" "application/json"
    ]
    , url = ("https://itunes.apple.com/search?term=" ++ searchText)
    , body = Http.emptyBody
    , expect = Http.expectJson OnFetchContent decoder
    , timeout = Nothing
    , tracker = Nothing
    }