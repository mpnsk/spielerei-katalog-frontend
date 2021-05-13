module Decode.SpielDecoder exposing (..)

import Json.Decode
import Json.Encode



-- generated from korban.net/elm/json2elm/


type alias Spiel =
    { altersempfehlung : Int
    , beschreibung : String
    , erscheinugsjahr : String
    , kategorie : String
    , leihpreis : Int
    , links : Links
    , name : String
    , spieldauerMinuten : Int
    , spieldauerTyp : String
    , spieleranzahlMax : Int
    , spieleranzahlMin : Int
    }


type alias Links =
    { self : LinksSelf
    , spiel : LinksSpiel
    }


type alias LinksSelf =
    { href : String
    }


type alias LinksSpiel =
    { href : String
    }


decodeSpiel : Json.Decode.Decoder Spiel
decodeSpiel =
    let
        fieldSet0 =
            Json.Decode.map8 Spiel
                (Json.Decode.field "altersempfehlung" Json.Decode.int)
                (Json.Decode.field "beschreibung" Json.Decode.string)
                (Json.Decode.field "erscheinugsjahr" Json.Decode.string)
                (Json.Decode.field "kategorie" Json.Decode.string)
                (Json.Decode.field "leihpreis" Json.Decode.int)
                (Json.Decode.field "_links" decodeLinks)
                (Json.Decode.field "name" Json.Decode.string)
                (Json.Decode.field "spieldauerMinuten" Json.Decode.int)
    in
    Json.Decode.map4 (<|)
        fieldSet0
        (Json.Decode.field "spieldauerTyp" Json.Decode.string)
        (Json.Decode.field "spieleranzahlMax" Json.Decode.int)
        (Json.Decode.field "spieleranzahlMin" Json.Decode.int)


decodeLinks : Json.Decode.Decoder Links
decodeLinks =
    Json.Decode.map2 Links
        (Json.Decode.field "self" decodeLinksSelf)
        (Json.Decode.field "spiel" decodeLinksSpiel)


decodeLinksSelf : Json.Decode.Decoder LinksSelf
decodeLinksSelf =
    Json.Decode.map LinksSelf
        (Json.Decode.field "href" Json.Decode.string)


decodeLinksSpiel : Json.Decode.Decoder LinksSpiel
decodeLinksSpiel =
    Json.Decode.map LinksSpiel
        (Json.Decode.field "href" Json.Decode.string)


encodeSpiel : Spiel -> Json.Encode.Value
encodeSpiel spiel =
    Json.Encode.object
        [ ( "_links", encodeLinks spiel.links )
        , ( "altersempfehlung", Json.Encode.int spiel.altersempfehlung )
        , ( "beschreibung", Json.Encode.string spiel.beschreibung )
        , ( "erscheinugsjahr", Json.Encode.string spiel.erscheinugsjahr )
        , ( "kategorie", Json.Encode.string spiel.kategorie )
        , ( "leihpreis", Json.Encode.int spiel.leihpreis )
        , ( "name", Json.Encode.string spiel.name )
        , ( "spieldauerMinuten", Json.Encode.int spiel.spieldauerMinuten )
        , ( "spieldauerTyp", Json.Encode.string spiel.spieldauerTyp )
        , ( "spieleranzahlMax", Json.Encode.int spiel.spieleranzahlMax )
        , ( "spieleranzahlMin", Json.Encode.int spiel.spieleranzahlMin )
        ]


encodeLinks : Links -> Json.Encode.Value
encodeLinks links =
    Json.Encode.object
        [ ( "self", encodeLinksSelf links.self )
        , ( "spiel", encodeLinksSpiel links.spiel )
        ]


encodeLinksSelf : LinksSelf -> Json.Encode.Value
encodeLinksSelf linksSelf =
    Json.Encode.object
        [ ( "href", Json.Encode.string linksSelf.href )
        ]


encodeLinksSpiel : LinksSpiel -> Json.Encode.Value
encodeLinksSpiel linksSpiel =
    Json.Encode.object
        [ ( "href", Json.Encode.string linksSpiel.href )
        ]
