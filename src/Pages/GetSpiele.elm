module Pages.GetSpiele exposing (Model, Msg, page)

import Decode.SpielDecoder exposing (..)
import Gen.Params.GetJson exposing (Params)
import Html exposing (text)
import Html.Attributes
import Http
import Page
import Request
import Shared
import Table exposing (Column)
import UI
import View exposing (View)


page : Shared.Model -> Request.With Params -> Page.With Model Msg
page shared req =
    Page.element
        { init = init
        , update = update
        , view = view
        , subscriptions = subscriptions
        }


type alias Model =
    { getSpiele : ConnectionState
    , tableState : Table.State
    }


type ConnectionState
    = Failure
    | Loading
    | Success String
    | SuccessSpiel EmbeddedSpieleObject
    | SuccessSpiele SpieleCollection



-- INIT
--type alias Model =
--    {}


init : ( Model, Cmd Msg )
init =
    let
        gotText : Result Http.Error String -> Msg
        gotText =
            GotText
    in
    ( { getSpiele = Loading
      , tableState = Table.initialSort "name"
      }
    , Http.get
        { url = "http://localhost:8080/spiele"
        , expect = Http.expectJson GotJsonCollection Decode.SpielDecoder.decodeSpieleCollection
        }
    )



-- UPDATE


type Msg
    = ReplaceMe
    | GotText (Result Http.Error String)
    | GotJson (Result Http.Error EmbeddedSpieleObject)
    | GotJsonCollection (Result Http.Error SpieleCollection)
    | SetTableState Table.State


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        ReplaceMe ->
            ( model, Cmd.none )

        GotText result ->
            case result of
                Ok value ->
                    ( { model | getSpiele = Success value }, Cmd.none )

                Err error ->
                    let
                        log =
                            Debug.log "json error? " error
                    in
                    ( { model | getSpiele = Failure }, Cmd.none )

        GotJson result ->
            case result of
                Ok value ->
                    ( { model | getSpiele = SuccessSpiel value }, Cmd.none )

                Err error ->
                    ( { model | getSpiele = Failure }, Cmd.none )

        GotJsonCollection result ->
            case result of
                Ok value ->
                    ( { model | getSpiele = SuccessSpiele value }, Cmd.none )

                Err error ->
                    let
                        log =
                            Debug.log "json error? " error
                    in
                    ( { model | getSpiele = Failure }, Cmd.none )

        SetTableState state ->
            ( { model | tableState = state }, Cmd.none )



-- SUBSCRIPTIONS


subscriptions : Model -> Sub Msg
subscriptions model =
    Sub.none



-- VIEW


view : Model -> View Msg
view model =
    --View.placeholder "GetJson"
    { title = "GetJson"
    , body =
        UI.layout
            [ Html.text "html text!"
            , Html.br [] []
            , Html.text "another text!"
            , Html.br [] []
            , Html.br [] []
            , Html.br [] []
            , Html.br [] []
            , case model.getSpiele of
                Loading ->
                    Html.text "loading..."

                Success value ->
                    Html.text <| "Success: " ++ value

                Failure ->
                    Html.text "a failure"

                SuccessSpiel spiel ->
                    Html.text spiel.name

                SuccessSpiele spieleCollection ->
                    let
                        spiele : List EmbeddedSpieleObject
                        spiele =
                            spieleCollection.embedded.spiele

                        spiel2html : EmbeddedSpieleObject -> List (Html.Html msg)
                        spiel2html spiel =
                            [ Html.text spiel.name
                            , Html.br [] []
                            , text spiel.beschreibung
                            , Html.br [] []
                            , text spiel.kategorie
                            , text " "
                            , Html.a [ Html.Attributes.href spiel.links.spiel.href ]
                                [ Html.text spiel.links.spiel.href
                                ]
                            , Html.br [] []
                            , text <|
                                case spiel.spieldauerTyp of
                                    Einwert ->
                                        "Standard"

                                    ProSpieler ->
                                        "pro Spieler"

                                    MinMax ->
                                        "von bis"

                                    Beliebig ->
                                        "beliebig"
                            ]
                    in
                    Table.view config model.tableState spiele

            --Html.ul []
            --    (spiele
            --        |> List.map spiel2html
            --        |> List.map (\input -> Html.li [] input)
            --    )
            ]
    }


config : Table.Config EmbeddedSpieleObject Msg
config =
    Table.config
        { toId = .name
        , toMsg = SetTableState
        , columns =
            [ Table.customColumn
                { name = "Name"
                , viewData = .name
                , sorter = Table.increasingOrDecreasingBy (\x -> String.toUpper x.name)
                }

            --, Table.decreasingBy
            --, Table.intColumn "Year" .year
            --, Table.stringColumn "City" .city
            --, Table.stringColumn "State" .state
            ]
        }
