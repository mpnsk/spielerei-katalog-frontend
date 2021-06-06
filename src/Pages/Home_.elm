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
                    pagination a.page
        ]
    }


pagination : Decode.SpringDataRestSpiel.Page -> Html.Styled.Html msg
pagination page123 =
    div [ class "bg-white px-4 py-3 flex items-center justify-between border-t border-gray-200 sm:px-6" ]
        [ div [ class "flex-1 flex justify-between sm:hidden" ]
            [ a [ class "relative inline-flex items-center px-4 py-2 border border-gray-300 text-sm font-medium rounded-md text-gray-700 bg-white hover:bg-gray-50", href "#" ]
                [ text "<<    " ]
            , a [ class "ml-3 relative inline-flex items-center px-4 py-2 border border-gray-300 text-sm font-medium rounded-md text-gray-700 bg-white hover:bg-gray-50", href "#" ]
                [ text ">>    " ]
            ]
        , div [ class "hidden sm:flex-1 sm:flex sm:items-center sm:justify-between" ]
            [ div []
                [ p [ class "text-sm text-gray-700" ]
                    [ text "Showing        "
                    , span [ class "font-medium" ]
                        [ text "1 " ]
                    , text "to        "
                    , span [ class "font-medium" ]
                        [ text "10 " ]
                    , text "of        "
                    , span [ class "font-medium" ]
                        [ text "97 " ]
                    , text "results      "
                    ]
                ]
            , div []
                [ nav [ attribute "aria-label" "Pagination", class "relative z-0 inline-flex rounded-md shadow-sm -space-x-px" ]
                    [ a [ class "relative inline-flex items-center px-2 py-2 rounded-l-md border border-gray-300 bg-white text-sm font-medium text-gray-500 hover:bg-gray-50", href "#" ]
                        [ span [ class "sr-only" ]
                            [ text "Previous" ]
                        , svg [ attribute "aria-hidden" "true", Svg.Styled.Attributes.class "h-5 w-5", fill "currentColor", Svg.Styled.Attributes.viewBox "0 0 20 20", attribute "xmlns" "http://www.w3.org/2000/svg" ]
                            [ Svg.Styled.path [ attribute "clip-rule" "evenodd", Svg.Styled.Attributes.d "M12.707 5.293a1 1 0 010 1.414L9.414 10l3.293 3.293a1 1 0 01-1.414 1.414l-4-4a1 1 0 010-1.414l4-4a1 1 0 011.414 0z", attribute "fill-rule" "evenodd" ]
                                []
                            , text "          "
                            ]
                        ]
                    , a [ attribute "aria-current" "page", class "z-10 bg-indigo-50 border-indigo-500 text-indigo-600 relative inline-flex items-center px-4 py-2 border text-sm font-medium", href "#" ]
                        [ text "1        " ]
                    , a [ class "bg-white border-gray-300 text-gray-500 hover:bg-gray-50 relative inline-flex items-center px-4 py-2 border text-sm font-medium", href "#" ]
                        [ text "2        " ]
                    , a [ class "bg-white border-gray-300 text-gray-500 hover:bg-gray-50 hidden md:inline-flex relative items-center px-4 py-2 border text-sm font-medium", href "#" ]
                        [ text "3        " ]
                    , span [ class "relative inline-flex items-center px-4 py-2 border border-gray-300 bg-white text-sm font-medium text-gray-700" ]
                        [ text "...        " ]
                    , a [ class "bg-white border-gray-300 text-gray-500 hover:bg-gray-50 hidden md:inline-flex relative items-center px-4 py-2 border text-sm font-medium", href "#" ]
                        [ text "8        " ]
                    , a [ class "bg-white border-gray-300 text-gray-500 hover:bg-gray-50 relative inline-flex items-center px-4 py-2 border text-sm font-medium", href "#" ]
                        [ text "9        " ]
                    , a [ class "bg-white border-gray-300 text-gray-500 hover:bg-gray-50 relative inline-flex items-center px-4 py-2 border text-sm font-medium", href "#" ]
                        [ text "10        " ]
                    , a [ class "relative inline-flex items-center px-2 py-2 rounded-r-md border border-gray-300 bg-white text-sm font-medium text-gray-500 hover:bg-gray-50", href "#" ]
                        [ span [ class "sr-only" ]
                            [ text "Next" ]
                        , svg [ attribute "aria-hidden" "true", Svg.Styled.Attributes.class "h-5 w-5", fill "currentColor", Svg.Styled.Attributes.viewBox "0 0 20 20", attribute "xmlns" "http://www.w3.org/2000/svg" ]
                            [ Svg.Styled.path [ attribute "clip-rule" "evenodd", Svg.Styled.Attributes.d "M7.293 14.707a1 1 0 010-1.414L10.586 10 7.293 6.707a1 1 0 011.414-1.414l4 4a1 1 0 010 1.414l-4 4a1 1 0 01-1.414 0z", attribute "fill-rule" "evenodd" ]
                                []
                            , text "          "
                            ]
                        ]
                    ]
                ]
            ]
        ]
