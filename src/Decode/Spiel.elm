module Decode.Spiel exposing (..)

import Json.Decode


type alias Spiel =
    { altersempfehlung : Int
    , altersempfehlungMax : Int
    , beschreibung : String
    , erscheinungsjahr : Maybe String
    , id : Int
    , kategorie : KategorieObject
    , leihpreis : Int
    , name : String
    , spieldauerMinutenMax : Int
    , spieldauerMinutenMin : Int
    , spieldauerTyp : Maybe SpieldauerTyp
    , spieleranzahlMax : Int
    , spieleranzahlMin : Int
    }


type SpieldauerTyp
    = Einwert
    | ProSpieler
    | MinMax
    | Beliebig


spieldauerTypDecoder : Json.Decode.Decoder (Maybe SpieldauerTyp)
spieldauerTypDecoder =
    Json.Decode.maybe
        (Json.Decode.string
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
        )


spielMemberDecoder : Json.Decode.Decoder Spiel
spielMemberDecoder =
    spielObjectDecoder


spielObjectDecoder : Json.Decode.Decoder Spiel
spielObjectDecoder =
    let
        fieldSet0 =
            Json.Decode.map8 Spiel
                (Json.Decode.field "altersempfehlung" Json.Decode.int)
                (Json.Decode.field "altersempfehlungMax" Json.Decode.int)
                (Json.Decode.field "beschreibung" Json.Decode.string)
                (Json.Decode.field "erscheinugsjahr" <| Json.Decode.maybe Json.Decode.string)
                (Json.Decode.field "id" Json.Decode.int)
                (Json.Decode.field "kategorie" kategorieDecoder)
                (Json.Decode.field "leihpreis" Json.Decode.int)
                (Json.Decode.field "name" Json.Decode.string)
    in
    Json.Decode.map6 (<|)
        fieldSet0
        (Json.Decode.field "spieldauerMinutenMax" Json.Decode.int)
        (Json.Decode.field "spieldauerMinutenMin" Json.Decode.int)
        (Json.Decode.field "spieldauerTyp" spieldauerTypDecoder)
        (Json.Decode.field "spieleranzahlMax" Json.Decode.int)
        (Json.Decode.field "spieleranzahlMin" Json.Decode.int)


kategorieDecoder : Json.Decode.Decoder KategorieObject
kategorieDecoder =
    Json.Decode.map2 KategorieObject
        (Json.Decode.field "id" Json.Decode.int)
        (Json.Decode.field "name" Json.Decode.string)


type alias KategorieObject =
    { id : Int
    , name : String
    }
