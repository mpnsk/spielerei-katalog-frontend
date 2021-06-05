module Pages.Home_ exposing (Model, Msg, page)

import Decode.SpringDataRestSpiel
import Gen.Params.Home_ exposing (Params)
import Html.Styled exposing (a, div, nav, p, span, text, toUnstyled)
import Html.Styled.Attributes exposing (attribute, class, href)
import Http
import Page
import Request
import Shared
import Svg.Styled exposing (svg)
import Svg.Styled.Attributes exposing (fill)
import View exposing (View)


page : Shared.Model -> Request.With Params -> Page.With Model Msg
page shared req =
    Page.element
        { init = init
        , update = update
        , view = view
        , subscriptions = subscriptions
        }



-- INIT


type alias Model =
    {}


initModel =
    {}


init : ( Model, Cmd Msg )
init =
    ( initModel, Http.get { url = "http://localhost:8080/spiele", expect = Http.expectJson GotSpiele Decode.SpringDataRestSpiel.decodeSpieleCollection } )



-- UPDATE


type Msg
    = ReplaceMe
    | GotSpiele (Result Http.Error Decode.SpringDataRestSpiel.SpieleCollection)


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        ReplaceMe ->
            ( model, Cmd.none )

        GotSpiele result ->
            ( model, Cmd.none )



-- SUBSCRIPTIONS


subscriptions : Model -> Sub Msg
subscriptions model =
    Sub.none



-- VIEW


view : Model -> View Msg
view model =
    { title = "titel123"
    , body = []
    }
