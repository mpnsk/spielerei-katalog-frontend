module Decode.ByKategorieTest exposing (..)

import Decode.ByKategorie exposing (KlassikerObject)
import Decode.SpielDecoder exposing (EmbeddedSpieleObject)
import Expect
import Json.Decode
import Test exposing (..)



--suite : Test
--suite =
--    describe "basic decoding"
--        [ decodeTest
--
--        --, describe "json tests"
--        --    [ test1 ]
--        ]


jsonToTest =
    """
    {"Klassiker": [
        {
          "altersempfehlung": 8,
          "id": 172,
          "name": "Kniffel",
          "beschreibung": "",
          "spieldauerTyp": "Einwert",
          "spieldauerMinutenMin": 0,
          "spieldauerMinutenMax": 0,
          "erscheinugsjahr": null,
          "spieleranzahlMin": 1,
          "spieleranzahlMax": 99,
          "altersempfehlungMax": 0,
          "leihpreis": 0,
          "kategorie": {
            "id": 12,
            "name": "Klassiker"
          }
        }
        ]
    }
    """


keyValueTest : Test
keyValueTest =
    test "should decode object as tuple list" <|
        \_ ->
            let
                expected =
                    [ Ok [ ( "Klassiker", [ spielKniffel ] ) ] ]

                actual =
                    let
                        decoder : Json.Decode.Decoder (List ( String, List KlassikerObject ))
                        decoder =
                            Json.Decode.keyValuePairs (Json.Decode.list Decode.ByKategorie.klassikerObjectDecoder)
                    in
                    [ Json.Decode.decodeString decoder jsonToTest ]
            in
            Expect.equal expected actual


spielKniffel : KlassikerObject
spielKniffel =
    { id = 172
    , name = "Kniffel"
    , beschreibung = ""
    , spieldauerTyp = Nothing
    , spieldauerMinutenMin = 0
    , spieldauerMinutenMax = 0

    --, erscheinugsjahr = Just "123"
    , erscheinugsjahr = Nothing
    , kategorie = { id = 12, name = "Klassiker" }
    , leihpreis = 0
    , altersempfehlung = 8
    , altersempfehlungMax = 0
    , spieleranzahlMin = 1
    , spieleranzahlMax = 99
    }


{-| OnChangeTest a JSON object into an Elm `List` of pairs.

    decodeString (keyValuePairs int) "{ \"alice\": 42, \"bob\": 99 }"
        == Ok [ ( "alice", 42 ), ( "bob", 99 ) ]

-}
decodeTest =
    skip <|
        test "should decode to list of pairs" <|
            \_ ->
                let
                    result =
                        Json.Decode.decodeString
                            (Json.Decode.keyValuePairs Json.Decode.int)
                            "{ \"alice\": 42, \"bob\": 99 }"
                in
                Expect.equal
                    (Ok [ ( "alice", 42 ), ( "bob", 99 ) ])
                    result


test1 =
    test "True is false?" f


f =
    \_ ->
        Expect.notEqual True
            False


theJson =
    """
    {"Klassiker": [
         {
           "id": 172,
           "name": "Kniffel",
           "beschreibung": "",
           "spieldauerTyp": "Einwert",
           "spieldauerMinutenMin": 0,
           "spieldauerMinutenMax": 0,
           "erscheinugsjahr": null,
           "spieleranzahlMin": 1,
           "spieleranzahlMax": 99,
           "altersempfehlung": 8,
           "altersempfehlungMax": 0,
           "leihpreis": 0,
           "kategorie": {
             "id": 12,
             "name": "Klassiker"
           }
         }]
    }
    """
