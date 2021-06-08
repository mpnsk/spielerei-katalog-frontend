module Pages.Home_ exposing (Model, Msg, page)

import Css exposing (height, px, width)
import Decode.SpringDataRestSpiel
import Gen.Params.Home_ exposing (Params)
import Html.Styled exposing (a, div, nav, p, span, text, toUnstyled)
import Html.Styled.Attributes as Attr exposing (attribute, class, css, href, style)
import Http
import Page
import Pagination exposing (rangePagination)
import Request
import Shared
import Svg.Styled exposing (path, svg)
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
                    let
                        style1 =
                            [ Tw.bg_blue_200, Tw.m_1, Tw.inline_block, Tw.w_full ]
                    in
                    div [ style "columns" "6 200px", style "column-gap" "1rem", style "spacing" "20px" ]
                        [ div [ css <| List.append style1 [ height <| px 200 ] ] [ text "1" ]
                        , div [ css <| List.append style1 [ height <| px 220 ] ] [ text "2" ]
                        , div [ css <| List.append style1 [ height <| px 220 ] ] [ text "3" ]
                        , div [ css <| List.append style1 [ height <| px 220 ] ] [ text "4" ]
                        , div [ css <| List.append style1 [ height <| px 220 ] ] [ text "5" ]
                        , div [ css <| List.append style1 [ height <| px 220 ] ] [ text "6" ]
                        , div [ css <| List.append style1 [ height <| px 250 ] ] [ text "7" ]
                        , div [ css <| List.append style1 [ height <| px 280 ] ] [ text "8" ]
                        , div [ css <| List.append style1 [ height <| px 270 ] ] [ text "9" ]
                        , div [ css <| List.append style1 [ height <| px 210 ] ] [ text "1" ]
                        , div [ css <| List.append style1 [ height <| px 250 ] ] [ text "2" ]
                        , div [ css <| List.append style1 [ height <| px 280 ] ] [ text "3" ]
                        , div [ css <| List.append style1 [ height <| px 270 ] ] [ text "4" ]
                        , div [ css <| List.append style1 [ height <| px 210 ] ] [ text "5" ]
                        , div [ css <| List.append style1 [ height <| px 220 ] ] [ text "6" ]
                        , div [ css <| List.append style1 [ height <| px 250 ] ] [ text "7" ]
                        , div [ css <| List.append style1 [ height <| px 280 ] ] [ text "8" ]
                        , div [ css <| List.append style1 [ height <| px 270 ] ] [ text "9" ]
                        , div [ css <| List.append style1 [ height <| px 210 ] ] [ text "1" ]
                        , div [ css <| List.append style1 [ height <| px 250 ] ] [ text "2" ]
                        , div [ css <| List.append style1 [ height <| px 280 ] ] [ text "3" ]
                        , div [ css <| List.append style1 [ height <| px 270 ] ] [ text "4" ]
                        , div [ css <| List.append style1 [ height <| px 210 ] ] [ text "5" ]
                        , div [ css <| List.append style1 [ height <| px 250 ] ] [ text "6" ]
                        , div [ css <| List.append style1 [ height <| px 280 ] ] [ text "7" ]
                        , div [ css <| List.append style1 [ height <| px 270 ] ] [ text "8" ]
                        , div [ css <| List.append style1 [ height <| px 210 ] ] [ text "9" ]
                        , div [ css <| List.append style1 [ height <| px 250 ] ] [ text "1" ]
                        , div [ css <| List.append style1 [ height <| px 280 ] ] [ text "2" ]
                        , div [ css <| List.append style1 [ height <| px 270 ] ] [ text "3" ]
                        , div [ css <| List.append style1 [ height <| px 210 ] ] [ text "4" ]
                        ]
        ]
    }
