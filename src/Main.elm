module Main exposing (init, main, subscriptions)

import Browser exposing (UrlRequest)
import Browser.Navigation as Nav exposing (Key)
import Html exposing (Html, div, text)
import Html.Attributes exposing (..)
import Url exposing (Url)
import Debug exposing (..)

import Models.Content exposing (ContentInfo)
import Component.Content as Content
import Pages.Basket as Basket
import Pages.Details as Details
import Pages.Home as Home

import Routes exposing (Route)
import Shared exposing (..)

import Styles.Common exposing (mainContainerStyle)

type alias Model =
    { flags : Flags
    , navKey : Key
    , route : Route
    , page : Page
    , basket: List ContentInfo
    }


type Page
    = PageNone
    | PageBasket Basket.Model
    | PageDetails Details.Model
    | PageHome Home.Model


type Msg
    = OnUrlChange Url
    | OnUrlRequest UrlRequest
    | HomeMsg Home.Msg
    | DetailsMsg Details.Msg
    | BasketMsg Basket.Msg


init : Flags -> Url -> Key -> ( Model, Cmd Msg )
init flags url navKey =
    loadCurrentPage ({ flags = flags
            , navKey = navKey
            , route = Routes.parseUrl url
            , page = PageNone
            , basket = []
            }, Cmd.none )

loadCurrentPage : ( Model, Cmd Msg ) -> ( Model, Cmd Msg )
loadCurrentPage ( model, cmd ) =
    let
        ( page, newCmd ) =
            case model.route of
                Routes.HomeRoute ->
                    let
                        ( pageModel, pageCmd) = Home.init model.basket
                    in
                    ( PageHome pageModel, Cmd.map HomeMsg pageCmd )
                Routes.BasketRoute ->
                    let
                        (pageModel, pageCmd) = Basket.init model.basket
                    in
                        ( PageBasket pageModel, pageCmd )

                Routes.DetailsRoute id ->
                    let
                        (pageModel, pageCmd) = Details.init id
                    in
                        ( PageDetails pageModel, Cmd.map DetailsMsg pageCmd  )

                Routes.NotFoundRoute -> ( PageNone, Cmd.none )
    in
    ( { model | page = page }, Cmd.batch [ cmd, newCmd ] )


subscriptions : Model -> Sub Msg
subscriptions _ = Sub.none

update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case ( msg, model.page ) of
        ( OnUrlRequest urlRequest, _ ) ->
            case urlRequest of
                Browser.Internal url ->
                    ( model, Nav.pushUrl model.navKey (Url.toString url))

                Browser.External url -> ( model, Nav.load url )

        ( OnUrlChange url, _ ) ->
            loadCurrentPage ( { model | route = Routes.parseUrl url }, Cmd.none )

        ( HomeMsg subMsg, PageHome pageModel ) ->
            let
                ( newPageModel, newCmd ) = Home.update subMsg pageModel
            in
            ( { model | page = PageHome newPageModel, basket = newPageModel.basket  }, Cmd.map HomeMsg newCmd )

        ( BasketMsg subMsg, PageBasket pageModel ) ->
            let
                ( newPageModel, newCmd ) = Basket.update subMsg pageModel
            in
            ( { model | page = PageBasket newPageModel, basket = newPageModel.basket  }, Cmd.map BasketMsg newCmd )

        ( DetailsMsg subMsg, PageDetails pageModel ) ->
            let
                ( newPageModel, newCmd ) = Details.update subMsg pageModel
            in
            ( { model | page = PageDetails newPageModel }, Cmd.map DetailsMsg newCmd )

        ( HomeMsg _, _ ) -> ( model, Cmd.none )
        ( DetailsMsg _, _ ) -> ( model, Cmd.none )
        ( BasketMsg _, _ ) -> ( model, Cmd.none )

main : Program Flags Model Msg
main =
    Browser.application
        { init = init
        , view = view
        , update = update
        , subscriptions = subscriptions
        , onUrlRequest = OnUrlRequest
        , onUrlChange = OnUrlChange
        }


-- VIEWS

view : Model -> Browser.Document Msg
view model =
    { title = "App", body = [ currentPage model ] }

notFoundView : Html msg
notFoundView =
    div [] [ text "Not found" ]

currentPage : Model -> Html Msg
currentPage model =
    let
        page =
            case model.page of
                PageHome pageModel -> Html.map HomeMsg (Home.view pageModel)
                PageBasket pageModel -> Html.map BasketMsg  (Basket.view pageModel)
                PageDetails pageModel -> Html.map DetailsMsg (Details.view pageModel)
                PageNone -> notFoundView
    in
    div ([] ++ mainContainerStyle) [page]