module Pages.Edit exposing (Model, Msg, init, update, view)

import Html exposing (..)
import Html.Attributes exposing (class)
import Html.Events exposing (onClick)
import Http
import Player exposing (Player)
import Shared exposing (..)

type alias Model = RemoteData Player

type Msg
    = OnFetchPlayer (Result Http.Error Player)
    | ChangeLevel Player Int
    | OnPlayerSave (Result Http.Error Player)


init : Flags -> String -> ( Model, Cmd Msg )
init flags playerId =
    ( Loading, fetchPlayer flags playerId )

update : Flags -> Msg -> Model -> ( Model, Cmd Msg )
update flags msg model =
    case msg of
        OnFetchPlayer (Ok player) ->
            ( Loaded player, Cmd.none )

        OnFetchPlayer (Err _) ->
            ( Failure, Cmd.none )

        ChangeLevel player howMuch ->
            let
                updatedPlayer =
                    { player | level = player.level + howMuch }
            in
            ( model, savePlayer flags updatedPlayer )

        OnPlayerSave (Ok player) ->
            ( Loaded player, Cmd.none )

        OnPlayerSave (Err _) ->
            ( model, Cmd.none )



-- DATA


fetchPlayer : Flags -> String -> Cmd Msg
fetchPlayer flags playerId =
    Http.get
    {
        url = (flags.api ++ "/players/" ++ playerId)
        , expect = Http.expectJson OnFetchPlayer (Player.decoder)
    }


savePlayer : Flags -> Player -> Cmd Msg
savePlayer flags player =
    Http.request
        { body = Player.encode player |> Http.jsonBody
        , expect = Http.expectJson OnPlayerSave Player.decoder
        , headers = []
        , method = "PATCH"
        , timeout = Nothing
        , tracker = Nothing
        , url = savePlayerUrl flags player.id
        }

savePlayerUrl : Flags -> String -> String
savePlayerUrl flags playerId =
    flags.api ++ "/players/" ++ playerId

-- VIEWS

view : Model -> Html Msg
view model =
    let
        content =
            case model of
                NotAsked ->
                    text ""

                Loading ->
                    text "Loading ..."

                Loaded player ->
                    viewWithData player

                Failure ->
                    text "Error"
    in
    section [ class "p-4" ]
        [ content ]


viewWithData : Player -> Html.Html Msg
viewWithData player =
    div []
        [ h1 [] [ text player.name ]
        , inputLevel player
        ]


inputLevel : Player -> Html.Html Msg
inputLevel player =
    div
        [ class "flex items-end py-2" ]
        [ label [ class "mr-3" ] [ text "Level" ]
        , div [ class "" ]
            [ span [ class "bold text-2xl" ] [ text (String.fromInt player.level) ]
            , btnLevelDecrease player
            , btnLevelIncrease player
            ]
        ]


btnLevelDecrease : Player -> Html.Html Msg
btnLevelDecrease player =
    button [ class "btn ml-3 h1", onClick (ChangeLevel player -1) ]
        [ i [ class "fa fa-minus-circle" ] [] ]


btnLevelIncrease : Player -> Html.Html Msg
btnLevelIncrease player =
    button [class "btn ml-3 h1", onClick (ChangeLevel player 1) ]
        [ i [ class "fa fa-plus-circle" ] [] ]