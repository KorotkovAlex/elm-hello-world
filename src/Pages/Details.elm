module Pages.Details exposing (..)
import Html exposing (..)
import Models.Content exposing (Content, decoder)
import Http exposing (..)

import Shared exposing (..)
type alias Model =
    {
        id: Int,
        content: RemoteData Content
    }

type Msg
    = OnFetchContent (Result Http.Error Content)

update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        OnFetchContent (Ok content) ->
            ( { model | content = Loaded content }, Cmd.none )
        OnFetchContent (Err err) ->
            ( { model | content = Failure }, Cmd.none )

init : Int -> ( Model, Cmd Msg )
init id =
    ( {
      content = Loading,
      id = id
      }, fetchContent id)


renderContent : Model -> Html Msg
renderContent model =
  case model.content of
    Loaded loadedContent ->  text (String.fromInt loadedContent.resultCount)
    Failure -> text "err"
    Loading -> text "loading"
    NotAsked -> text "NotAsked"

view : Model -> Html Msg
view model =
  div [] [
    text "!!!!!!!!!contentInfo \n",
    text (String.fromInt model.id),
    (renderContent model)
  ]


fetchContent : Int -> Cmd Msg
fetchContent id =
    Http.request
    { method = "GET"
    , headers = [
        Http.header "Access-Control-Allow-Origin" "*",
        Http.header "Access-Control-Allow-Credentials" "true",
        Http.header "Access-Control-Allow-Methods" "Get",
        Http.header "Accept" "application/json",
        Http.header "Content-Type" "application/json"
    ]
    , url = ("https://itunes.apple.com/lookup?id=" ++ String.fromInt id)
    , body = Http.emptyBody
    , expect = Http.expectJson OnFetchContent decoder
    , timeout = Nothing
    , tracker = Nothing
    }