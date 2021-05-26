module Pages.Home_ exposing (Model, Msg, page)

import Decode.ByKategorie exposing (KategorieTupel, rootDecoder)
import Decode.Spiel exposing (Spiel)
import Decode.SpringDataRestSpiel exposing (..)
import Gen.Params.Home exposing (Params)
import Html
import Html.Attributes
import Html.Styled exposing (div, fromUnstyled, optgroup, option, select, span, text, toUnstyled)
import Html.Styled.Attributes as Attributes exposing (css)
import Http
import Json.Decode exposing (..)
import Page
import Request
import Shared
import Table
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


type alias Model =
    { tableState : Table.State
    , spieleRequest : RequestByKategorieState
    }


type RequestByKategorieState
    = ByKategorieFailure
    | ByKategorieLoading
    | ByKategorieSuccess (List KategorieTupel)



-- INIT
--type alias Model =
--    {}


init : ( Model, Cmd Msg )
init =
    ( { tableState = Table.initialSort "Year"
      , spieleRequest = ByKategorieLoading
      }
    , Http.get
        { url = "http://192.168.178.24:8080/kategorie"
        , expect = Http.expectJson SpieleByKategorieReceived rootDecoder
        }
    )



-- UPDATE


type Msg
    = SetTableState Table.State
    | SpieleByKategorieReceived (Result Http.Error (List KategorieTupel))


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        SetTableState newState ->
            ( { model | tableState = newState }
            , Cmd.none
            )

        SpieleByKategorieReceived result ->
            case result of
                Ok value ->
                    ( { model | spieleRequest = ByKategorieSuccess value }, Cmd.none )

                Err error ->
                    ( { model | spieleRequest = ByKategorieFailure }, Cmd.none )



-- SUBSCRIPTIONS


subscriptions : Model -> Sub Msg
subscriptions model =
    Sub.none



-- VIEW


view : Model -> View Msg
view model =
    { title = "GetJson"
    , body =
        List.map toUnstyled
            [ let
                { tableState, spieleRequest } =
                    model
              in
              case spieleRequest of
                ByKategorieFailure ->
                    text "fehler"

                ByKategorieLoading ->
                    text "lade"

                ByKategorieSuccess list ->
                    fromUnstyled <| Table.view tableConfig tableState <| flattenSpiele list
            ]
    }


tableHead : List ( String, b, Html.Attribute msg ) -> Table.HtmlDetails msg
tableHead list =
    Table.HtmlDetails [] <|
        List.map
            (\( name, status, attributes ) ->
                Html.th
                    [ attributes
                    , Html.Attributes.style "position" "sticky"
                    , Html.Attributes.style "background-color" "white"
                    , Html.Attributes.style "top" "0px"
                    , Html.Attributes.style "padding" "20px"
                    ]
                    [ Html.text <| name ]
            )
            list


tableConfig : Table.Config Spiel Msg
tableConfig =
    let
        defaultCustomizations : Table.Customizations data msg
        defaultCustomizations =
            Table.defaultCustomizations

        customizations =
            { defaultCustomizations
                | tableAttrs = [ Html.Attributes.style "width" "100%" ]
                , thead = tableHead
            }

        columnErscheinungsjahr =
            Table.stringColumn "Year"
                (\data ->
                    let
                        jahr =
                            case data.erscheinungsjahr of
                                Just x ->
                                    x

                                Nothing ->
                                    ""
                    in
                    jahr
                )

        spieldauer : Spiel -> String
        spieldauer spiel =
            String.fromInt spiel.spieldauerMinutenMin ++ "-" ++ String.fromInt spiel.spieldauerMinutenMax

        spieleranzahl : Spiel -> String
        spieleranzahl spiel =
            String.fromInt spiel.spieleranzahlMin ++ "-" ++ String.fromInt spiel.spieleranzahlMax

        kategorie : Spiel -> String
        kategorie spiel =
            spiel.kategorie.name
    in
    Table.customConfig
        { toId = \data -> String.fromInt data.id
        , toMsg = SetTableState
        , columns =
            [ Table.stringColumn "Name" .name
            , Table.stringColumn "Spieldauer" spieldauer
            , Table.stringColumn "Spieler" spieleranzahl
            , Table.intColumn "Alter" .altersempfehlung
            , Table.stringColumn "Kategorie" kategorie
            ]
        , customizations = customizations
        }


flattenSpiele : List KategorieTupel -> List Spiel
flattenSpiele byKatgorie =
    let
        getSpieleList : KategorieTupel -> List Spiel
        getSpieleList tuple =
            Tuple.second tuple
    in
    List.concatMap getSpieleList byKatgorie
