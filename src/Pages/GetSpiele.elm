module Pages.GetSpiele exposing (Model, Msg, page)

import Decode.ByKategorie exposing (KategorieTupel, KlassikerObject)
import Decode.SpielDecoder exposing (..)
import Gen.Params.GetSpiele exposing (Params)
import Html
import Html.Attributes
import Http
import Json.Decode exposing (..)
import Page
import Request
import Shared
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
    {}


type ConnectionStateSpiele
    = SpieleLoading


type ConnectionStateByKategorie
    = ByKategorieFailure
    | ByKategorieLoading
    | ByKategorieSuccess (List ( String, List KlassikerObject ))



-- INIT
--type alias Model =
--    {}


init : ( Model, Cmd Msg )
init =
    ( {}
    , Http.get
        { url = "http://localhost:8080/kategorie"
        , expect = Http.expectString Noop
        }
    )



-- UPDATE


type Msg
    = ReplaceMe
    | Noop (Result Http.Error String)


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        ReplaceMe ->
            ( model, Cmd.none )

        Noop result ->
            ( model, Cmd.none )



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
        [ Html.select [ Html.Attributes.multiple True ]
            [ Html.optgroup []
                [ Html.option [] [ Html.text "html text1" ]
                , Html.option [] [ Html.text "html text2" ]
                , Html.option [] [ Html.text "html text3" ]
                ]
            ]
        ]
    }
