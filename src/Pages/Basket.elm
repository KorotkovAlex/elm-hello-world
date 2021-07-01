module Pages.Basket exposing (..)

import Html exposing (..)
import List exposing (length)

import Models.Content exposing (ContentInfo)
import Component.Content as Content exposing(..)
import Common as CommonStyles

type Msg =  ContentMsg Content.Msg

type alias Model =
    {
        basket: List ContentInfo
    }

init : List ContentInfo -> ( Model, Cmd msg )
init basket =
    ( { basket = basket }, Cmd.none)
-- List.append model.basket [contentInfo]

filteContent : ContentInfo -> ContentInfo -> Bool
filteContent content content2 =
    content == content2

update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        ContentMsg subMsg ->
            case subMsg of
                AddToBasket _ ->
                    ( model, Cmd.none)
                RemoveFromBasket contentInfo ->
                    ( { model | basket = List.filter ( \content -> contentInfo.trackId /= content.trackId)  model.basket }, Cmd.none)


view : Model -> Html Msg
view model =
    div ([] ++ CommonStyles.contentGridStyle) (List.map rowItemInfo model.basket)

rowItemInfo: ContentInfo -> Html Msg
rowItemInfo contentInfo =
    Html.map ContentMsg (Content.view contentInfo True)
