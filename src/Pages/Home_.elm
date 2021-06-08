module Pages.Home_ exposing (Model, Msg, page)

import Css
import Decode.SpringDataRestSpiel
import Gen.Params.Home_ exposing (Params)
import Html.Styled exposing (a, div, nav, p, span, text, toUnstyled)
import Html.Styled.Attributes as Attr exposing (attribute, class, css, href)
import Http
import Page
import Pagination exposing (rangePagination)
import Request
import Shared
import Svg.Styled exposing (path, svg)
import Svg.Styled.Attributes as SvgAttr exposing (fill)
import Tailwind.Breakpoints as Bp
import Tailwind.Utilities as Tw
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
    { spieleCollection : Maybe Decode.SpringDataRestSpiel.SpieleCollection }


initModel =
    { spieleCollection = Nothing }


init : ( Model, Cmd Msg )
init =
    ( initModel, Http.get { url = "http://localhost:8080/spiele", expect = Http.expectJson GotSpiele Decode.SpringDataRestSpiel.decodeSpieleCollection } )



-- UPDATE


type Msg
    = ReplaceMe
    | GotSpiele (Result Http.Error Decode.SpringDataRestSpiel.SpieleCollection)


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    let
        noop =
            ( model, Cmd.none )
    in
    case msg of
        ReplaceMe ->
            noop

        GotSpiele result ->
            case result of
                Ok x ->
                    ( { model | spieleCollection = Just x }, Cmd.none )

                Err error ->
                    noop



-- SUBSCRIPTIONS


subscriptions : Model -> Sub Msg
subscriptions model =
    Sub.none



-- VIEW


view : Model -> View Msg
view model =
    { title = "titel"
    , body =
        [ toUnstyled <|
            case model.spieleCollection of
                Nothing ->
                    text "loading"

                Just a ->
                    div [] rangePagination
        ]
    }
