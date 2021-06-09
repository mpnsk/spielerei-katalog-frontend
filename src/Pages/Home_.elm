module Pages.Home_ exposing (Model, Msg, page)

import Css exposing (height, px, width)
import Decode.SpringDataRestSpiel exposing (AttachmentsObjectPreviewObject)
import Gen.Params.Home_ exposing (Params)
import Html.Styled exposing (a, div, img, nav, p, span, text, toUnstyled)
import Html.Styled.Attributes as Attr exposing (attribute, class, css, href, src, style)
import Http
import List
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
    ( initModel, Http.get { url = "http://localhost:8080/spiele?size=60", expect = Http.expectJson GotSpiele Decode.SpringDataRestSpiel.decodeSpieleCollection } )



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
                            [ Tw.bg_blue_200
                            , Tw.m_1
                            , Tw.inline_block
                            , Tw.w_full

                            --, height <| px 200
                            ]

                        divList =
                            List.map
                                (\spiel ->
                                    div [ css <| List.append style1 [] ]
                                        [ text spiel.name
                                        , case List.head spiel.attachments of
                                            Just attachment ->
                                                case findFirstInPreviewListWithHeightBigger200 attachment.preview of
                                                    Just preview ->
                                                        img [ src ("http://192.168.178.24:8082/" ++ attachment.trelloId ++ "/" ++ String.fromInt preview.width ++ "x" ++ String.fromInt preview.height ++ "/" ++ preview.trelloId ++ "/" ++ attachment.name) ] []

                                                    Nothing ->
                                                        text "kein preview"

                                            Nothing ->
                                                text "kein bild"
                                        ]
                                )
                                a.embedded.spiele
                    in
                    div [ style "columns" "3 200px", style "column-gap" "1rem", style "spacing" "20px" ]
                        divList
        ]
    }


findFirstInPreviewListWithHeightBigger200 : List AttachmentsObjectPreviewObject -> Maybe AttachmentsObjectPreviewObject
findFirstInPreviewListWithHeightBigger200 list =
    case List.head list of
        Just obj ->
            if obj.width >= 220 then
                Just obj

            else
                case List.tail list of
                    Nothing ->
                        Nothing

                    Just tail ->
                        findFirstInPreviewListWithHeightBigger200 tail

        Nothing ->
            Nothing
