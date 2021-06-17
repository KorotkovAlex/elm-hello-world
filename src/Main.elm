module Main exposing (init, main, subscriptions)

import Browser exposing (UrlRequest)
import Browser.Navigation as Nav exposing (Key)
import Html exposing (Html, div, section, text, a)
import Html.Attributes exposing (..)
import Pages.Home as Home
import Routes exposing (Route, pathFor)
import Shared exposing (..)
import Url exposing (Url)
import Models.Content exposing (Content, ContentInfo)
import Debug exposing (..)
import List exposing (length)
import Pages.Basket as Basket
import Pages.Details as Details

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
                Routes.DetailsRoute ->
                    let
                        (pageModel, pageCmd) = Details.init
                    in
                        ( PageDetails pageModel, pageCmd )

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
                    Debug.log("dsasad")
                    ( model, Nav.pushUrl model.navKey (Url.toString url))

                Browser.External url -> Debug.log("dsasad") ( model, Nav.load url )

        ( OnUrlChange url, _ ) ->
            Debug.log("dsasad")
            loadCurrentPage ( { model | route = Routes.parseUrl url }, Cmd.none )

        ( HomeMsg subMsg, PageHome pageModel ) ->
            let
                ( newPageModel, newCmd ) = Home.update subMsg pageModel
            in
            ( { model | page = PageHome newPageModel, basket = newPageModel.basket  }, Cmd.map HomeMsg newCmd )

        ( HomeMsg _, _ ) -> ( model, Cmd.none )

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

currentPage : Model -> Html Msg
currentPage model =
    let
        page =
            case model.page of
                PageHome pageModel -> Html.map HomeMsg (Home.view pageModel)
                PageBasket pageModel -> Basket.view pageModel
                PageDetails pageModel -> Details.view pageModel
                PageNone -> notFoundView
        basketCount = length model.basket
    in
    section [] [
        text (String.fromInt basketCount),
        a [ href (pathFor Routes.HomeRoute) ] [text "Go to home"],
        a [ href (pathFor Routes.BasketRoute) ] [text "Go to the basket"],
        page
        ]

notFoundView : Html msg
notFoundView =
    div [] [ text "Not found" ]