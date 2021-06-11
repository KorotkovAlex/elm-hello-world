module Pages.Home exposing (..)

import Html exposing (..)
import Http
import Json.Decode as Decode
import Components.Content exposing (Content, ContentInfo, decoder)
import Shared exposing (..)

type alias Model =
    {
        searchText: String,
        content: RemoteData (List Content)
    }

init : ( Model, Cmd Msg )
init =
    ( { content = Loading, searchText = "" }, fetchContent)

type Msg
    = OnFetchContent (Result Http.Error (List Content))

update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        OnFetchContent (Ok players) ->
            ( { model | content = Loaded players }, Cmd.none )

        OnFetchContent (Err _) ->
            ( { model | content = Failure }, Cmd.none )

rowItemInfo: ContentInfo -> Html msg
rowItemInfo contentInfo =
    div []
        [ text contentInfo.artistName ]

rowItem: Content -> Html msg
rowItem content =
    div []
        (List.map rowItemInfo content.results)

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

viewWithData : List Content -> Html msg
viewWithData content =
    div []
        (List.map rowItem content)


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
    , expect = Http.expectJson OnFetchContent (Decode.list decoder)
    , timeout = Nothing
    , tracker = Nothing
    }