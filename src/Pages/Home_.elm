module Pages.Home_ exposing (Model, Msg, page)

import Css exposing (height, padding, px, row, width)
import Decode.SpringDataRestSpiel exposing (AttachmentsObjectPreviewObject)
import Gen.Params.Home_ exposing (Params)
import Html
import Html.Styled exposing (a, div, fromUnstyled, img, nav, p, span, text, toUnstyled)
import Html.Styled.Attributes as Attr exposing (attribute, class, css, href, src, style)
import Http
import List
import Masonry exposing (fromItems)
import Page
import Pagination exposing (rangePagination)
import Request
import Shared
import Svg.Styled exposing (path, svg)
import Svg.Styled.Attributes exposing (spacing)
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


style1 =
    [ Tw.bg_blue_200
    , Tw.m_1
    , Tw.inline_block
    , Tw.w_full

    --, height <| px 200
    ]


spielToCard spiel =
    div [ css <| List.append style1 [] ]
        [ text spiel.name
        , case List.head spiel.attachments of
            Just attachment ->
                case findFirstInPreviewListWithHeightBigger200 attachment.preview of
                    Just preview ->
                        previewToImage attachment preview

                    Nothing ->
                        text "kein preview"

            Nothing ->
                text "kein bild"
        ]


previewToImage attachment preview =
    img [ src ("http://192.168.178.24:8081/" ++ attachment.trelloId ++ "/" ++ String.fromInt preview.width ++ "x" ++ String.fromInt preview.height ++ "/" ++ preview.trelloId ++ "/" ++ attachment.name) ] []


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
                        divList =
                            List.map
                                spielToCard
                                a.embedded.spiele

                        --masonry =
                        --    let
                        --        config =
                        --            let
                        --                viewItem id ( index, embeddedSpieleObject ) =
                        --                    let
                        --                        h =
                        --                            List.head embeddedSpieleObject.attachments
                        --                                |> Maybe.map (\att -> att.preview)
                        --                                |> Maybe.andThen List.head
                        --                                |> Maybe.map .height
                        --                                |> (\x ->
                        --                                        case x of
                        --                                            Just i ->
                        --                                                i
                        --
                        --                                            Nothing ->
                        --                                                200
                        --                                   )
                        --
                        --                        --|> Maybe.map .height
                        --                    in
                        --                    Html.div [ Html.Attributes.style "height" (String.fromInt h ++ "px"), Html.Attributes.style "background-color" "red" ]
                        --                        --[ Html.text <| "index" ++ String.fromInt index
                        --                        --, Html.text " "
                        --                        [ Html.text <| String.fromInt index ++ " " ++ embeddedSpieleObject.name
                        --                        ]
                        --            in
                        --            { toView = viewItem
                        --            , columns = 4
                        --            }
                        --    in
                        --    Masonry.view config <| Tuple.first <| (Masonry.init <| Just "masonry-id") <| List.indexedMap Tuple.pair a.embedded.spiele
                    in
                    div []
                        [ text "before masonry"
                        , let
                            viewMasonry args =
                                div [] <|
                                    List.map
                                        (\masonryColumn ->
                                            div [] <|
                                                List.map
                                                    (\( position, height_ ) ->
                                                        args.viewItem position height_
                                                    )
                                                    (List.reverse masonryColumn)
                                        )
                                        (List.reverse <| fromItems args.items args.columns)
                          in
                          div [] []
                        , div []
                            [ div [ css [ Tw.flex, Tw.flex_row ] ]
                                [ div [ css [ Tw.flex, Tw.flex_col ] ] [ div [] [ text " 1" ], div [] [ text " 2" ], div [] [ text " 3" ] ]
                                , div [ css [ Tw.flex, Tw.flex_col ] ] [ div [] [ text " 4" ], div [] [ text " 5" ], div [] [ text " 6" ] ]
                                , div [ css [ Tw.flex, Tw.flex_col ] ] [ text " 7", text " 8", text " 9" ]
                                ]
                            ]

                        --, fromUnstyled masonry
                        , let
                            viewItem position height_ =
                                div
                                    [ css
                                        [ Css.height <| px <| toFloat height_
                                        , Tw.bg_red_500
                                        ]
                                    ]
                                    [ text <|
                                        "( "
                                            ++ String.fromInt position
                                            ++ ", "
                                            ++ String.fromInt height_
                                            ++ " )"
                                    ]

                            masonry =
                                fromItems [ 10, 30, 30, 30, 10, 20, 20, 20, 10, 30, 30, 30, 10, 40, 40, 40 ] 4
                          in
                          case model.spieleCollection of
                            Just spieleCollection ->
                                let
                                    renderColumn col =
                                        div [ css [ Tw.flex, Tw.flex_col, Tw.space_y_1 ] ] <| List.map (\( position, height ) -> viewItem position height) <| List.reverse <| col
                                in
                                div
                                    [ css [ Tw.flex, Tw.flex_row, Tw.space_x_1 ]
                                    ]
                                    (List.map renderColumn <| List.reverse (fromItems spieleCollection.embedded.spiele 2))

                            Nothing ->
                                text "abc"
                        , text "after masonry"
                        , div [ style "columns" "3 200px", style "column-gap" "1rem", style "spacing" "20px" ] divList
                        ]
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
