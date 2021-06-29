module Pages.Home exposing (..)

import Html exposing (..)
import Html.Events exposing (onInput, onClick)
import Html.Attributes exposing (placeholder, src, href, value, height, width)

import Http
import String exposing(..)

import Shared exposing (..)
import Models.Content exposing (Content, ContentInfo, decoder)
import Styles.Common exposing (searchContainerStyle, headerStyle, searchInputLineStyle, searchButtonStyle, bucketContainerStyle, bucketImageStyle, bucketCounterStyle)
import Routes exposing (Route, pathFor)
import Asset

type alias Model =
    {
        searchText: String,
        content: RemoteData Content,
        basket: List ContentInfo
    }

init : List ContentInfo -> ( Model, Cmd Msg )
init basket =
    ( { content = NotAsked, searchText = "", basket = basket }, Cmd.none)

type Msg
    = OnFetchContent (Result Http.Error Content)
    | OnInputSearchText String
    | SearchContent
    | AddToBasket ContentInfo

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
            ( { model | content = Loading, searchText = "" }, fetchContent model.searchText)
        AddToBasket contentInfo ->
            ( { model | basket = List.append model.basket [contentInfo] }, Cmd.none)


-- View
rowItemInfo: ContentInfo -> Html Msg
rowItemInfo contentInfo =
    div []
        [
            text (contentInfo.artistName ++ " "),
            button [onClick (AddToBasket contentInfo)] [ text " + "] 
        ]

viewWithData : Content -> Html Msg
viewWithData content =
    div []
        [
            text (String.fromInt content.resultCount),
            div [] (List.map rowItemInfo content.results)
        ]


searchInputLiveView : Model -> Html Msg
searchInputLiveView model =
    div ([] ++ searchContainerStyle) [
        input ([
            onInput OnInputSearchText,
            value model.searchText,
            placeholder "searchText"
        ] ++ searchInputLineStyle) [],
        button ([onClick SearchContent] ++ searchButtonStyle) [
            img [ Asset.src Asset.searchIcon, width 30, height 30] []
        ]
    ]

contentView : Model -> Html Msg
contentView model =
    case model.content of
        NotAsked -> text ""
        Loading -> text "Loading ..."
        Loaded items -> viewWithData items
        Failure -> text "Error"

bucketView : Model -> Html Msg
bucketView model =
    div ([] ++ bucketContainerStyle) [
        a [ href (pathFor Routes.BasketRoute) ]
        [
            div ([] ++ bucketImageStyle) [
                img [ Asset.src Asset.bucketIcon, width 30, height 30] [],
                div ([] ++ bucketCounterStyle) [
                    text (String.fromInt (List.length model.basket))
                ]
            ]
        ]
    ]
view : Model -> Html Msg
view model =
    div [] [
        div ([] ++ headerStyle) [
            searchInputLiveView model,
            bucketView model
        ],
        contentView model
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
    , url = ("https://itunes.apple.com/search?media=music&term=" ++ searchText)
    , body = Http.emptyBody
    , expect = Http.expectJson OnFetchContent decoder
    , timeout = Nothing
    , tracker = Nothing
    }