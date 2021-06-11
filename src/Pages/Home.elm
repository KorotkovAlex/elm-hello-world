module Pages.Home exposing (..)

import Html exposing (..)
import Html.Attributes exposing (class, href)
import Http
import Json.Decode as Decode
import Components.Content exposing (Content, ContentInfo, decoder)
import Shared exposing (..)
import Html.Attributes exposing (step)


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

        OnFetchContent (Err err) ->
            ( { model | content = Failure }, Cmd.none )

rowItemInfo: ContentInfo -> Html Msg
rowItemInfo contentInfo =
    div []
        [ text contentInfo.artistName ]

rowItem: Content -> Html Msg
rowItem content =
    div []
        (List.map rowItemInfo content.results)

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
    div [] [content]

viewWithData : List Content -> Html Msg
viewWithData content =
    div []
        (List.map rowItem content)


-- DATA

fetchContent : Cmd Msg
fetchContent =
    Http.request
    { method = "GET"
    , headers = [Http.header "Access-Control-Allow-Origin" "*", Http.header "Access-Control-Allow-Credentials" "true", Http.header "Access-Control-Allow-Methods" "Get", Http.header "Accept" "application/json", Http.header "Content-Type" "application/json"]
    , url = ("https://itunes.apple.com/search?term=" ++ "eminem")
    , body = Http.emptyBody
    , expect = Http.expectJson OnFetchContent (Decode.list decoder)
    , timeout = Nothing
    , tracker = Nothing
    }
    -- Http.get
    -- {
    --     url = ("http://itunes.apple.com/search?term=" ++ "eminem")
    --     , expect = Http.expectJson OnFetchContent (Decode.list decoder)
    -- }


    -- Http.header "Access-Control-Allow-Origin" "*"
    -- Http.header "Access-Control-Allow-Credentials" "true"
    -- Http.header "Access-Control-Allow-Methods" "Get"
