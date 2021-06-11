module Pages.List exposing (Msg, Model, init, update, view)

import Html exposing (..)
import Html.Attributes exposing (class, href)
import Html.Events exposing (onClick)
import Http
import Json.Decode as Decode
import Player exposing (Player)
import Routes
import Shared exposing (..)

type alias Model =
    {
        players : RemoteData (List Player),
        isShowText : Bool
    }


type Msg
    = OnFetchPlayers (Result Http.Error (List Player))
    | OnPressButton


init : Flags -> ( Model, Cmd Msg )
init flags =
    ( { players = Loading, isShowText = False  }, fetchPlayers flags )

update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        OnFetchPlayers (Ok players) ->
            ( { model | players = Loaded players }, Cmd.none )

        OnFetchPlayers (Err _) ->
            ( { model | players = Failure }, Cmd.none )

        OnPressButton ->
            ( {model | isShowText = (not model.isShowText) }, Cmd.none)



-- DATA




fetchPlayers : Flags -> Cmd Msg
fetchPlayers flags =
    Http.get
    {
        url = (flags.api ++ "/players")
        , expect = Http.expectJson OnFetchPlayers (Decode.list Player.decoder)
    }


htmlIf : Model -> Html Msg
htmlIf model =
    if model.isShowText then
        text "I can show this text"

    else
        text ""

view : Model -> Html Msg
view model =
    let
        content =
            case model.players of
                NotAsked ->
                    text ""

                Loading ->
                    text "Loading ..."

                Loaded players ->
                    viewWithData players

                Failure ->
                    text "Error"
    in
    div [] [
        section [ class "p-4" ] [ content ]
        , button [ onClick OnPressButton] [ text "Press me" ]
        , htmlIf model
    ]


viewWithData : List Player -> Html Msg
viewWithData players =
    table []
        [ thead []
            [ tr []
                [ th [ class "p-2" ] [ text "Id" ]
                , th [ class "p-2" ] [ text "Name" ]
                , th [ class "p-2" ] [ text "Level" ]
                , th [ class "p-2" ] [ text "Actions" ]
                ]
            ]
        , tbody [] (List.map playerRow players)
        ]


playerRow : Player -> Html Msg
playerRow player =
    tr []
        [ td [ class "p-2" ] [ text player.id ]
        , td [ class "p-2" ] [ text player.name ]
        , td [ class "p-2" ] [ text (String.fromInt player.level) ]
        , td [ class "p-2" ]
            [ editBtn player ]
        ]


editBtn : Player -> Html.Html Msg
editBtn player =
    let
        path =
            Routes.playerPath player.id
    in
    a
        [ class "btn regular"
        , href path
        ]
        [ i [ class "fa fa-edit mr-1" ] [], text "Edit" ]