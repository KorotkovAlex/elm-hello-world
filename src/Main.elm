module Main exposing (init, main, subscriptions)

import Browser exposing (UrlRequest)
import Browser.Navigation as Nav exposing (Key)
import Html exposing (Html, div, section, text)
import Pages.Edit as Edit
import Pages.List as List
import Pages.Hello as Hello
import Pages.Home as Home
import Routes exposing (Route)
import Shared exposing (..)
import Url exposing (Url)

type alias Model =
    { flags : Flags
    , navKey : Key
    , route : Route
    , page : Page
    }


type Page
    = PageNone
    | PageList List.Model
    | PageEdit Edit.Model
    | PageHome Home.Model
    | PageHello Hello.Model


type Msg
    = OnUrlChange Url
    | OnUrlRequest UrlRequest
    | ListMsg List.Msg
    | EditMsg Edit.Msg
    | HomeMsg Home.Msg
    | HelloMsg Hello.Msg


init : Flags -> Url -> Key -> ( Model, Cmd Msg )
init flags url navKey =
    loadCurrentPage ({ flags = flags
            , navKey = navKey
            , route = Routes.parseUrl url
            , page = PageNone
            }, Cmd.none )


loadCurrentPage : ( Model, Cmd Msg ) -> ( Model, Cmd Msg )
loadCurrentPage ( model, cmd ) =
    let
        ( page, newCmd ) =
            case model.route of
                Routes.PlayersRoute ->
                    let
                        ( pageModel, pageCmd ) = List.init model.flags
                    in
                    ( PageList pageModel, Cmd.map ListMsg pageCmd )

                Routes.PlayerRoute playerId ->
                    let
                        ( pageModel, pageCmd ) = Edit.init model.flags playerId
                    in
                    ( PageEdit pageModel, Cmd.map EditMsg pageCmd )

                Routes.HelloRoute ->
                    let
                        ( pageModel, pageCmd ) = Hello.init
                    in
                    ( PageHello pageModel, Cmd.map HelloMsg pageCmd )

                Routes.HomeRoute ->
                    let
                        ( pageModel, pageCmd) = Home.init
                    in
                    ( PageHome pageModel, Cmd.map HomeMsg pageCmd )

                Routes.NotFoundRoute ->
                    ( PageNone, Cmd.none )
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

        ( ListMsg subMsg, PageList pageModel ) ->
            let
                ( newPageModel, newCmd ) = List.update subMsg pageModel
            in
            ( { model | page = PageList newPageModel }, Cmd.map ListMsg newCmd )

        ( EditMsg subMsg, PageEdit pageModel ) ->
            let
                ( newPageModel, newCmd ) = Edit.update model.flags subMsg pageModel
            in
            ( { model | page = PageEdit newPageModel }, Cmd.map EditMsg newCmd )

        ( HomeMsg subMsg, PageHome pageModel ) ->
            let
                ( newPageModel, newCmd ) = Home.update subMsg pageModel
            in
            ( { model | page = PageHome newPageModel }, Cmd.map HomeMsg newCmd )

        ( HomeMsg _, _ ) -> ( model, Cmd.none )
        ( EditMsg _, _ ) -> ( model, Cmd.none )
        ( ListMsg _, _ ) -> ( model, Cmd.none )
        ( HelloMsg _, _ ) -> ( model, Cmd.none )

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
                PageList pageModel -> Html.map ListMsg (List.view pageModel)
                PageEdit pageModel -> Html.map EditMsg (Edit.view pageModel)
                PageHello pageModel -> Html.map HelloMsg (Hello.view pageModel)
                PageHome pageModel -> Home.view pageModel
                PageNone -> notFoundView
    in
    section [] [ page ]

notFoundView : Html msg
notFoundView =
    div [] [ text "Not found" ]