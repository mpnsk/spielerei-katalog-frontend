module Decode.ByKategorie exposing (..)

import Json.Decode



-- Required packages:
-- * elm/json


type SpieldauerTyp
    = Einwert
    | ProSpieler
    | MinMax
    | Beliebig


type alias KlassikerObject =
    { altersempfehlung : Int
    , altersempfehlungMax : Int
    , beschreibung : String
    , erscheinugsjahr : Maybe String
    , id : Int
    , kategorie : KlassikerObjectKategorie
    , leihpreis : Int
    , name : String
    , spieldauerMinutenMax : Int
    , spieldauerMinutenMin : Int
    , spieldauerTyp : Maybe SpieldauerTyp
    , spieleranzahlMax : Int
    , spieleranzahlMin : Int
    }


type alias KategorieTupel =
    ( String, List KlassikerObject )


type alias KlassikerObjectKategorie =
    { id : Int
    , name : String
    }


rootDecoder : Json.Decode.Decoder (List KategorieTupel)
rootDecoder =
    Json.Decode.keyValuePairs (Json.Decode.list klassikerObjectDecoder)



--rootDecoder : Json.OnChangeTest.Decoder Root
--rootDecoder =
--    Json.OnChangeTest.map Root
--        (Json.OnChangeTest.field "Klassiker" <| Json.OnChangeTest.list klassikerObjectDecoder)


klassikerDecoder : Json.Decode.Decoder (List KlassikerObject)
klassikerDecoder =
    Json.Decode.list klassikerMemberDecoder


klassikerMemberDecoder : Json.Decode.Decoder KlassikerObject
klassikerMemberDecoder =
    klassikerObjectDecoder


klassikerObjectDecoder : Json.Decode.Decoder KlassikerObject
klassikerObjectDecoder =
    let
        fieldSet0 =
            Json.Decode.map8 KlassikerObject
                (Json.Decode.field "altersempfehlung" Json.Decode.int)
                (Json.Decode.field "altersempfehlungMax" Json.Decode.int)
                (Json.Decode.field "beschreibung" Json.Decode.string)
                (Json.Decode.field "erscheinugsjahr" <| Json.Decode.maybe Json.Decode.string)
                (Json.Decode.field "id" Json.Decode.int)
                (Json.Decode.field "kategorie" klassikerObjectKategorieDecoder)
                (Json.Decode.field "leihpreis" Json.Decode.int)
                (Json.Decode.field "name" Json.Decode.string)
    in
    Json.Decode.map6 (<|)
        fieldSet0
        (Json.Decode.field "spieldauerMinutenMax" Json.Decode.int)
        (Json.Decode.field "spieldauerMinutenMin" Json.Decode.int)
        (Json.Decode.field "spieldauerTyp" <| Json.Decode.maybe spieldauerTypDecoder)
        (Json.Decode.field "spieleranzahlMax" Json.Decode.int)
        (Json.Decode.field "spieleranzahlMin" Json.Decode.int)


klassikerObjectKategorieDecoder : Json.Decode.Decoder KlassikerObjectKategorie
klassikerObjectKategorieDecoder =
    Json.Decode.map2 KlassikerObjectKategorie
        (Json.Decode.field "id" Json.Decode.int)
        (Json.Decode.field "name" Json.Decode.string)


spieldauerTypDecoder : Json.Decode.Decoder SpieldauerTyp
spieldauerTypDecoder =
    Json.Decode.field "spieldauerTyp" Json.Decode.string
        |> Json.Decode.andThen
            (\str ->
                case str of
                    "Einwert" ->
                        Json.Decode.succeed Einwert

                    "ProSpieler" ->
                        Json.Decode.succeed ProSpieler

                    "MinMax" ->
                        Json.Decode.succeed MinMax

                    "Beliebig" ->
                        Json.Decode.succeed Beliebig

                    _ ->
                        Json.Decode.fail ("Trying to decode, but spieldauerTyp " ++ str ++ " is not supported.")
            )
