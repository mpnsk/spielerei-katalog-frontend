module Pages.GetJson exposing (Model, Msg, page)

import Decode.SpielDecoder exposing (..)
import Gen.Params.GetJson exposing (Params)
import Html
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
    | SuccessSpiel EmbeddedSpieleObject



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
        { url = "http://localhost:8080/spiele/7"
        , expect = Http.expectJson GotJson Decode.SpielDecoder.decodeEmbeddedSpieleObject
        }
    )



-- UPDATE


type Msg
    = ReplaceMe
    | GotText (Result Http.Error String)
    | GotJson (Result Http.Error EmbeddedSpieleObject)


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
            ]
    }
