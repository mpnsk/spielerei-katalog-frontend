module Pages.GetSpiele exposing (Model, Msg, page)

import Decode.SpielDecoder exposing (..)
import Gen.Params.GetJson exposing (Params)
import Html exposing (text)
import Html.Attributes
import Http
import Page
import Request
import Shared
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


type Model
    = Failure
    | Loading
    | Success String
    | SuccessSpiel Spiel
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
    ( Loading
    , Http.get
        { url = "http://localhost:8080/spiele"
        , expect = Http.expectJson GotJsonCollection Decode.SpielDecoder.decodeSpieleCollection
        }
    )



-- UPDATE


type Msg
    = ReplaceMe
    | GotText (Result Http.Error String)
    | GotJson (Result Http.Error Spiel)
    | GotJsonCollection (Result Http.Error SpieleCollection)


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        ReplaceMe ->
            ( model, Cmd.none )

        GotText result ->
            case result of
                Ok value ->
                    ( Success value, Cmd.none )

                Err error ->
                    ( Failure, Cmd.none )

        GotJson result ->
            case result of
                Ok value ->
                    ( SuccessSpiel value, Cmd.none )

                Err error ->
                    ( Failure, Cmd.none )

        GotJsonCollection result ->
            case result of
                Ok value ->
                    ( SuccessSpiele value, Cmd.none )

                Err error ->
                    ( Failure, Cmd.none )



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
            , case model of
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
                        spiele : List Spiel
                        spiele =
                            spieleCollection.embedded.spiele

                        spiel2html : Spiel -> Html.Html msg
                        spiel2html spiel =
                            Html.div []
                                [ Html.text spiel.name
                                , Html.br [] []
                                , text spiel.beschreibung
                                , Html.br [] []
                                , text spiel.kategorie
                                , text " "
                                , Html.a [ Html.Attributes.href spiel.links.spiel.href ]
                                    [ Html.text spiel.links.spiel.href
                                    ]
                                ]

                        spieleHtml : List (Html.Html msg)
                        spieleHtml =
                            List.map spiel2html spiele

                        wrapInLi : Html.Html msg -> Html.Html msg
                        wrapInLi x =
                            Html.li [] [ x ]
                    in
                    Html.ul [] <|
                        List.map wrapInLi <|
                            spieleHtml
            ]
    }
