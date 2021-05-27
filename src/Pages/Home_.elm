module Pages.Home_ exposing (Model, Msg, page)

import Decode.ByKategorie exposing (KategorieTupel, rootDecoder)
import Decode.Spiel exposing (Spiel)
import Decode.SpringDataRestSpiel exposing (..)
import Gen.Params.Home_ exposing (Params)
import Html
import Html.Attributes
import Html.Styled exposing (div, fromUnstyled, optgroup, option, select, span, text, toUnstyled)
import Html.Styled.Attributes as Attributes exposing (css)
import Http
import Json.Decode exposing (..)
import MultiSelect exposing (multiSelect)
import NaturalOrdering
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
    , kategorieSelected : List String
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
      , kategorieSelected = [ "Klassiker", "Builder", "Gamer's Games", "Familienspiele", "Würfelspiel", "Strategiespiele", "Knobelspiel", "Partyspiel", "Quiz", "Wirtschaftsspiele", "Kartenspiel", "2-Personen-Spiele" ]
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
    | MultiSelectChanged (List String)


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

        MultiSelectChanged strings ->
            let
                _ =
                    Debug.log "kategorien: " strings
            in
            ( { model | kategorieSelected = strings }, Cmd.none )



-- SUBSCRIPTIONS


subscriptions : Model -> Sub Msg
subscriptions model =
    Sub.none


multiselectOptions : Model -> MultiSelect.Options Msg
multiselectOptions model =
    let
        defaultOptions =
            MultiSelect.defaultOptions MultiSelectChanged

        kategorieTitel : List String
        kategorieTitel =
            case model.spieleRequest of
                ByKategorieSuccess list ->
                    List.map (\t -> Tuple.first t) list

                _ ->
                    []
    in
    { defaultOptions
        | items =
            List.map (\s -> { value = s, text = s, enabled = True }) kategorieTitel
    }


style : String -> String -> Html.Attribute msg
style key value =
    Html.Attributes.style key value



-- VIEW


view : Model -> View Msg
view model =
    { title = "GetJson"
    , body =
        List.map toUnstyled
            [ fromUnstyled <|
                multiSelect (multiselectOptions model)
                    [ style "width" "100%"
                    , style "height" "100%"
                    , Html.Attributes.size 12
                    ]
                    model.kategorieSelected
            , let
                { tableState, spieleRequest } =
                    model
              in
              case spieleRequest of
                ByKategorieFailure ->
                    text "fehler"

                ByKategorieLoading ->
                    text "lade"

                ByKategorieSuccess list ->
                    fromUnstyled <| Table.view tableConfig tableState <| flattenSpiele list model.kategorieSelected
            ]
    }


tableHead : List ( String, Table.Status, Html.Attribute msg ) -> Table.HtmlDetails msg
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
                <|
                    case status of
                        Table.Unsortable ->
                            [ Html.text name ]

                        Table.Sortable bool ->
                            [ Html.button []
                                [ Html.text name
                                , if bool then
                                    darkGrey "↓"

                                  else
                                    lightGrey "↓"
                                ]
                            ]

                        Table.Reversible (Just descending) ->
                            [ Html.button [] <|
                                if descending then
                                    [ Html.text name
                                    , Html.span [ styleLight ] [ Html.text "↑" ]
                                    , Html.span [ styleDark ] [ Html.text "↓" ]
                                    ]

                                else
                                    [ Html.text name
                                    , Html.span [ styleDark ] [ Html.text "↑" ]
                                    , Html.span [ styleLight ] [ Html.text "↓" ]
                                    ]
                            ]

                        Table.Reversible Nothing ->
                            [ Html.button []
                                [ Html.text name
                                , Html.span [ styleLight ] [ Html.text "↑" ]
                                , Html.span [ styleLight ] [ Html.text "↓" ]
                                ]
                            ]
            )
            list


styleDark =
    Html.Attributes.style "color" "#555"


styleLight =
    Html.Attributes.style "color" "#ccc"


darkGrey symbol =
    Html.span [ styleDark ] [ Html.text (" " ++ symbol) ]


lightGrey symbol =
    Html.span [ styleLight ] [ Html.text (" " ++ symbol) ]


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
            case spiel.spieldauerTyp of
                Nothing ->
                    "Fehler"

                Just t ->
                    case t of
                        Decode.Spiel.Einwert ->
                            if spiel.spieldauerMinutenMin == 0 then
                                ""

                            else
                                String.fromInt spiel.spieldauerMinutenMin

                        Decode.Spiel.ProSpieler ->
                            if spiel.spieldauerMinutenMax == 0 then
                                String.fromInt spiel.spieldauerMinutenMin ++ " pro Spieler"

                            else
                                String.fromInt spiel.spieldauerMinutenMin ++ "-" ++ String.fromInt spiel.spieldauerMinutenMax ++ " pro Spieler"

                        Decode.Spiel.MinMax ->
                            String.fromInt spiel.spieldauerMinutenMin ++ "-" ++ String.fromInt spiel.spieldauerMinutenMax

                        Decode.Spiel.Beliebig ->
                            "beliebig"

        spieleranzahl : Spiel -> String
        spieleranzahl spiel =
            if spiel.spieleranzahlMax == 99 then
                String.fromInt spiel.spieleranzahlMin ++ "+"

            else if spiel.spieleranzahlMin == spiel.spieleranzahlMax then
                if spiel.spieleranzahlMin == 0 then
                    ""

                else
                    String.fromInt spiel.spieleranzahlMin

            else
                String.fromInt spiel.spieleranzahlMin ++ "-" ++ String.fromInt spiel.spieleranzahlMax

        incOrDecNaturalSortOn : (Spiel -> String) -> Table.Sorter Spiel
        incOrDecNaturalSortOn on =
            Table.IncOrDec (List.sortWith <| NaturalOrdering.compareOn on)

        kategorie : Spiel -> String
        kategorie spiel =
            spiel.kategorie.name

        alter : Spiel -> String
        alter spiel =
            if spiel.altersempfehlung == 0 then
                ""

            else if spiel.altersempfehlungMax == 0 then
                String.fromInt spiel.altersempfehlung

            else if spiel.altersempfehlungMax == 99 then
                String.fromInt spiel.altersempfehlung ++ "+"

            else
                String.fromInt spiel.altersempfehlung ++ "-" ++ String.fromInt spiel.altersempfehlungMax
    in
    Table.customConfig
        { toId = \data -> String.fromInt data.id
        , toMsg = SetTableState
        , columns =
            [ Table.customColumn { name = "Name", viewData = .name, sorter = incOrDecNaturalSortOn .name }

            --, Table.stringColumn "Spieldauer" spieldauer
            , Table.customColumn { name = "Spieldauer-custom", viewData = spieldauer, sorter = incOrDecNaturalSortOn spieldauer }
            , Table.stringColumn "Spieler" spieleranzahl
            , Table.customColumn { name = "Alter", viewData = alter, sorter = incOrDecNaturalSortOn alter }
            , Table.stringColumn "Kategorie" kategorie
            ]
        , customizations = customizations
        }


flattenSpiele : List KategorieTupel -> List String -> List Spiel
flattenSpiele byKatgorie kategorieSelected =
    let
        getSpieleList : KategorieTupel -> List Spiel
        getSpieleList tuple =
            if List.member (Tuple.first tuple) kategorieSelected || kategorieSelected == [] then
                Tuple.second tuple

            else
                []
    in
    List.concatMap getSpieleList byKatgorie
