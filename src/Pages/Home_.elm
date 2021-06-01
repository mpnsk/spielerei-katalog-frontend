module Pages.Home_ exposing (Model, Msg, page)

import Browser.Dom exposing (Element)
import Css
import Decode.ByKategorie exposing (KategorieTupel, rootDecoder)
import Decode.Spiel exposing (Spiel)
import Gen.Params.Home_ exposing (Params)
import Html.Attributes
import Html.Styled exposing (button, div, span, text)
import Html.Styled.Attributes exposing (css)
import Html.Styled.Events exposing (onClick)
import Http
import Input.Number
import MultiSelect exposing (multiSelect)
import NaturalOrdering
import Page
import Request
import Shared
import Table
import Tailwind.Breakpoints as Breakpoints
import Tailwind.Utilities as Tw
import Task exposing (Task)
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
    , spieleranzahl : Maybe Int
    , showFilter : Bool
    , filterDivHeight : Maybe Float
    , filterDivDelta : Maybe Float
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
      , spieleranzahl = Just 2
      , showFilter = False
      , filterDivHeight = Nothing
      , filterDivDelta = Nothing
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
    | InputUpdated (Maybe Int)
    | InputFocus Bool
    | ButtonClicked
    | GotFilterDiv (Result Browser.Dom.Error Element)


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    let
        noop =
            ( model, Cmd.none )

        recalculateFilterDivHeight =
            Task.attempt GotFilterDiv (Browser.Dom.getElement theFilterDivId)
    in
    case msg of
        SetTableState newState ->
            ( { model | tableState = newState }
            , Cmd.none
            )

        SpieleByKategorieReceived result ->
            case result of
                Ok value ->
                    ( { model | spieleRequest = ByKategorieSuccess value }, recalculateFilterDivHeight )

                Err error ->
                    ( { model | spieleRequest = ByKategorieFailure }, Cmd.none )

        MultiSelectChanged strings ->
            let
                _ =
                    Debug.log "kategorien: " strings
            in
            ( { model | kategorieSelected = strings }, Cmd.none )

        InputUpdated maybeInt ->
            let
                _ =
                    Debug.log "inputupdated" maybeInt
            in
            ( { model | spieleranzahl = maybeInt }, Cmd.none )

        InputFocus bool ->
            let
                _ =
                    Debug.log "inputfocus" bool
            in
            ( model, Cmd.none )

        ButtonClicked ->
            ( { model | showFilter = not model.showFilter }, recalculateFilterDivHeight )

        GotFilterDiv result ->
            case result of
                Ok value ->
                    let
                        _ =
                            Debug.log "element" value

                        delta =
                            Debug.log "delta" (value.element.height + value.element.x + value.element.x)
                    in
                    ( { model | filterDivHeight = Just value.element.height, filterDivDelta = Just 0 }, Cmd.none )

                Err error ->
                    let
                        _ =
                            Debug.log "error" error
                    in
                    noop



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



-- VIEW


view : Model -> View Msg
view model =
    { title = "GetJson"
    , body =
        List.map (\x -> Html.Styled.toUnstyled x)
            [ Html.Styled.div
                [ Html.Styled.Attributes.id theFilterDivId
                , Html.Styled.Attributes.style "position" "sticky"
                , Html.Styled.Attributes.style "top"
                    (case model.filterDivDelta of
                        Just f ->
                            (f |> String.fromFloat) ++ "px"

                        Nothing ->
                            "0px"
                    )
                , Html.Styled.Attributes.style "background-color" "white"
                , Html.Styled.Attributes.style "width" "100%"
                , Html.Styled.Attributes.style "z-index" "10"
                ]
                (if model.showFilter then
                    [ Html.Styled.div []
                        [ Html.Styled.label []
                            [ Html.Styled.text "Spieleranzahl"
                            , Html.Styled.fromUnstyled <|
                                Input.Number.input { onInput = InputUpdated, maxLength = Nothing, maxValue = Just 20, minValue = Just 1, hasFocus = Just InputFocus }
                                    []
                                    model.spieleranzahl
                            ]
                        ]
                    , Html.Styled.div []
                        [ Html.Styled.label []
                            [ Html.Styled.text "Kategorien"
                            , Html.Styled.fromUnstyled <|
                                multiSelect
                                    (multiselectOptions model)
                                    [ Html.Attributes.style "width" "100%"
                                    , Html.Attributes.size 12
                                    ]
                                    model.kategorieSelected
                            ]
                        ]
                    , button
                        [ onClick ButtonClicked
                        ]
                        [ text "toggle filter" ]
                    ]

                 else
                    [ div [] [ Html.Styled.text "nicht gefiltert " ]
                    , button
                        [ onClick ButtonClicked
                        ]
                        [ text "toggle filter" ]
                    ]
                )
            , let
                table =
                    case model.spieleRequest of
                        ByKategorieFailure ->
                            Html.Styled.text "fehler"

                        ByKategorieLoading ->
                            Html.Styled.text "lade"

                        ByKategorieSuccess list ->
                            Table.view (tableConfig model.filterDivHeight) model.tableState <| flattenSpiele list model.kategorieSelected
              in
              table
            ]
    }


tableHead : Maybe Float -> List ( String, Table.Status, Html.Styled.Attribute msg ) -> Table.HtmlDetails msg
tableHead height list =
    Table.HtmlDetails
        [ Html.Styled.Attributes.style "background-color" "white"
        , Html.Styled.Attributes.style "padding" "20px"
        ]
    <|
        List.map
            (\( name, status, attributes ) ->
                Html.Styled.th
                    [ attributes
                    , css <|
                        List.append
                            [ Tw.bg_gray_200, Tw.text_gray_600, Tw.border, Tw.border_gray_300, Tw.hidden, Breakpoints.lg [ Tw.table_cell ] ]
                        <|
                            case height of
                                Just h ->
                                    [ Tw.sticky, Css.top <| Css.px h ]

                                Nothing ->
                                    []
                    ]
                <|
                    case status of
                        Table.Unsortable ->
                            [ Html.Styled.text name ]

                        Table.Sortable bool ->
                            [ Html.Styled.text name
                            , if bool then
                                darkGrey "↓"

                              else
                                lightGrey "↓"
                            ]

                        Table.Reversible (Just descending) ->
                            if descending then
                                [ Html.Styled.text name
                                , Html.Styled.span [ styleLight ] [ Html.Styled.text "↑" ]
                                , Html.Styled.span [ styleDark ] [ Html.Styled.text "↓" ]
                                ]

                            else
                                [ Html.Styled.text name
                                , Html.Styled.span [ styleDark ] [ Html.Styled.text "↑" ]
                                , Html.Styled.span [ styleLight ] [ Html.Styled.text "↓" ]
                                ]

                        Table.Reversible Nothing ->
                            [ Html.Styled.text name
                            , Html.Styled.span [ styleLight ] [ Html.Styled.text "↑" ]
                            , Html.Styled.span [ styleLight ] [ Html.Styled.text "↓" ]
                            ]
            )
            list


styleDark =
    Html.Styled.Attributes.style "color" "#555"


styleLight =
    Html.Styled.Attributes.style "color" "#ccc"


darkGrey symbol =
    Html.Styled.span [ styleDark ] [ Html.Styled.text (" " ++ symbol) ]


lightGrey symbol =
    Html.Styled.span [ styleLight ] [ Html.Styled.text (" " ++ symbol) ]


tableConfig height =
    let
        defaultCustomizations : Table.Customizations data msg
        defaultCustomizations =
            Table.defaultCustomizations

        customizations =
            { defaultCustomizations
                | tableAttrs = [ Html.Styled.Attributes.style "width" "100%" ]
                , thead = tableHead height

                --, caption = Just <| { attributes = [], children = [ Html.Styled.text "caption" ] }
                , rowAttrs = \spiel -> [ css [ Breakpoints.lg [ Tw.table_row, Tw.flex_row, Tw.flex_nowrap, Tw.mb_0 ], Tw.flex, Tw.flex_row, Tw.flex_wrap, Tw.mb_10 ] ]
            }

        columnErscheinungsjahr =
            Table.stringColumn "Year"
                (\data ->
                    let
                        jahr =
                            case data.erscheinungsjahr of
                                Just j ->
                                    j

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

        spielToHtml : String -> (Spiel -> String) -> Spiel -> Table.HtmlDetails msg
        spielToHtml columnName spielToString spiel =
            Table.HtmlDetails
                [ css <|
                    [ Breakpoints.lg [ Tw.w_auto, Tw.table_cell, Tw.static ]
                    , Tw.w_full
                    , Tw.p_3
                    , Tw.text_gray_800
                    , Tw.text_center
                    , Tw.border
                    , Tw.border_b
                    , Tw.block
                    , Tw.relative
                    ]
                ]
                [ span [ css [ Breakpoints.lg [ Tw.hidden ], Tw.absolute, Tw.top_0, Tw.left_0, Tw.bg_blue_200, Tw.px_2, Tw.py_1, Tw.text_xs, Tw.font_bold ] ] [ text columnName ], text (spielToString spiel) ]
    in
    Table.customConfig
        { toId = \data -> String.fromInt data.id
        , toMsg = SetTableState
        , columns =
            [ --Table.customColumn { name = "Name", viewData = .name, sorter = incOrDecNaturalSortOn .name }
              Table.veryCustomColumn { name = "Titel", viewData = spielToHtml "Titel" .name, sorter = incOrDecNaturalSortOn .name }

            --, Table.stringColumn "Spieldauer" spieldauer
            --, Table.customColumn { name = "Spielminuten", viewData = spieldauer, sorter = incOrDecNaturalSortOn spieldauer }
            , Table.veryCustomColumn { name = "Spielminuten", viewData = spielToHtml "Spielminuten" spieldauer, sorter = incOrDecNaturalSortOn spieldauer }

            --, Table.stringColumn "Spieler" spieleranzahl
            , Table.veryCustomColumn { name = "Spieler", viewData = spielToHtml "Spieler" spieleranzahl, sorter = incOrDecNaturalSortOn spieleranzahl }

            --, Table.customColumn { name = "Alter", viewData = alter, sorter = incOrDecNaturalSortOn alter }
            , Table.veryCustomColumn { name = "Alter", viewData = spielToHtml "Alter" alter, sorter = incOrDecNaturalSortOn alter }

            --, Table.stringColumn "Kategorie" kategorie
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


theFilterDivId =
    "the-filter-div"
