module Decode.SpielDecoder exposing (..)

import Json.Decode
import Json.Encode



-- generated from korban.net/elm/json2elm/


type alias SpieleCollection =
    { embedded : Embedded
    , links : Links
    }


type alias Embedded =
    { spiele : List Spiel
    }


type alias Spiel =
    { altersempfehlung : Int
    , beschreibung : String
    , erscheinugsjahr : String
    , kategorie : String
    , leihpreis : Int
    , links : EmbeddedSpieleObjectLinks
    , name : String
    , spieldauerMinuten : Int
    , spieldauerTyp : String
    , spieleranzahlMax : Int
    , spieleranzahlMin : Int
    }


type alias EmbeddedSpieleObjectLinks =
    { self : EmbeddedSpieleObjectLinksSelf
    , spiel : EmbeddedSpieleObjectLinksSpiel
    }


type alias EmbeddedSpieleObjectLinksSelf =
    { href : String
    }


type alias EmbeddedSpieleObjectLinksSpiel =
    { href : String
    }


type alias Links =
    { profile : LinksProfile
    , self : LinksSelf
    }


type alias LinksSelf =
    { href : String
    }


type alias LinksProfile =
    { href : String
    }


decodeSpieleCollection : Json.Decode.Decoder SpieleCollection
decodeSpieleCollection =
    Json.Decode.map2 SpieleCollection
        (Json.Decode.field "_embedded" decodeEmbedded)
        (Json.Decode.field "_links" decodeLinks)


decodeEmbedded : Json.Decode.Decoder Embedded
decodeEmbedded =
    Json.Decode.map Embedded
        (Json.Decode.field "spiele" <| Json.Decode.list decodeSpiel)


decodeEmbeddedSpiele : Json.Decode.Decoder (List Spiel)
decodeEmbeddedSpiele =
    Json.Decode.list decodeEmbeddedSpieleMember


decodeEmbeddedSpieleMember : Json.Decode.Decoder Spiel
decodeEmbeddedSpieleMember =
    decodeSpiel


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
                (Json.Decode.field "_links" decodeEmbeddedSpieleObjectLinks)
                (Json.Decode.field "name" Json.Decode.string)
                (Json.Decode.field "spieldauerMinuten" Json.Decode.int)
    in
    Json.Decode.map4 (<|)
        fieldSet0
        (Json.Decode.field "spieldauerTyp" Json.Decode.string)
        (Json.Decode.field "spieleranzahlMax" Json.Decode.int)
        (Json.Decode.field "spieleranzahlMin" Json.Decode.int)


decodeEmbeddedSpieleObjectLinks : Json.Decode.Decoder EmbeddedSpieleObjectLinks
decodeEmbeddedSpieleObjectLinks =
    Json.Decode.map2 EmbeddedSpieleObjectLinks
        (Json.Decode.field "self" decodeEmbeddedSpieleObjectLinksSelf)
        (Json.Decode.field "spiel" decodeEmbeddedSpieleObjectLinksSpiel)


decodeEmbeddedSpieleObjectLinksSelf : Json.Decode.Decoder EmbeddedSpieleObjectLinksSelf
decodeEmbeddedSpieleObjectLinksSelf =
    Json.Decode.map EmbeddedSpieleObjectLinksSelf
        (Json.Decode.field "href" Json.Decode.string)


decodeEmbeddedSpieleObjectLinksSpiel : Json.Decode.Decoder EmbeddedSpieleObjectLinksSpiel
decodeEmbeddedSpieleObjectLinksSpiel =
    Json.Decode.map EmbeddedSpieleObjectLinksSpiel
        (Json.Decode.field "href" Json.Decode.string)


decodeLinks : Json.Decode.Decoder Links
decodeLinks =
    Json.Decode.map2 Links
        (Json.Decode.field "profile" decodeLinksProfile)
        (Json.Decode.field "self" decodeLinksSelf)


decodeLinksSelf : Json.Decode.Decoder LinksSelf
decodeLinksSelf =
    Json.Decode.map LinksSelf
        (Json.Decode.field "href" Json.Decode.string)


decodeLinksProfile : Json.Decode.Decoder LinksProfile
decodeLinksProfile =
    Json.Decode.map LinksProfile
        (Json.Decode.field "href" Json.Decode.string)


encodeSpieleCollection : SpieleCollection -> Json.Encode.Value
encodeSpieleCollection spieleCollection =
    Json.Encode.object
        [ ( "_embedded", encodeEmbedded spieleCollection.embedded )
        , ( "_links", encodeLinks spieleCollection.links )
        ]


encodeEmbedded : Embedded -> Json.Encode.Value
encodeEmbedded embedded =
    Json.Encode.object
        [ ( "spiele", Json.Encode.list encodeEmbeddedSpieleObject embedded.spiele )
        ]


encodeEmbeddedSpiele : List Spiel -> Json.Encode.Value
encodeEmbeddedSpiele =
    Json.Encode.list encodeEmbeddedSpieleMember


encodeEmbeddedSpieleMember : Spiel -> Json.Encode.Value
encodeEmbeddedSpieleMember embeddedSpiele =
    encodeEmbeddedSpieleObject embeddedSpiele


encodeEmbeddedSpieleObject : Spiel -> Json.Encode.Value
encodeEmbeddedSpieleObject embeddedSpieleObject =
    Json.Encode.object
        [ ( "_links", encodeEmbeddedSpieleObjectLinks embeddedSpieleObject.links )
        , ( "altersempfehlung", Json.Encode.int embeddedSpieleObject.altersempfehlung )
        , ( "beschreibung", Json.Encode.string embeddedSpieleObject.beschreibung )
        , ( "erscheinugsjahr", Json.Encode.string embeddedSpieleObject.erscheinugsjahr )
        , ( "kategorie", Json.Encode.string embeddedSpieleObject.kategorie )
        , ( "leihpreis", Json.Encode.int embeddedSpieleObject.leihpreis )
        , ( "name", Json.Encode.string embeddedSpieleObject.name )
        , ( "spieldauerMinuten", Json.Encode.int embeddedSpieleObject.spieldauerMinuten )
        , ( "spieldauerTyp", Json.Encode.string embeddedSpieleObject.spieldauerTyp )
        , ( "spieleranzahlMax", Json.Encode.int embeddedSpieleObject.spieleranzahlMax )
        , ( "spieleranzahlMin", Json.Encode.int embeddedSpieleObject.spieleranzahlMin )
        ]


encodeEmbeddedSpieleObjectLinks : EmbeddedSpieleObjectLinks -> Json.Encode.Value
encodeEmbeddedSpieleObjectLinks embeddedSpieleObjectLinks =
    Json.Encode.object
        [ ( "self", encodeEmbeddedSpieleObjectLinksSelf embeddedSpieleObjectLinks.self )
        , ( "spiel", encodeEmbeddedSpieleObjectLinksSpiel embeddedSpieleObjectLinks.spiel )
        ]


encodeEmbeddedSpieleObjectLinksSelf : EmbeddedSpieleObjectLinksSelf -> Json.Encode.Value
encodeEmbeddedSpieleObjectLinksSelf embeddedSpieleObjectLinksSelf =
    Json.Encode.object
        [ ( "href", Json.Encode.string embeddedSpieleObjectLinksSelf.href )
        ]


encodeEmbeddedSpieleObjectLinksSpiel : EmbeddedSpieleObjectLinksSpiel -> Json.Encode.Value
encodeEmbeddedSpieleObjectLinksSpiel embeddedSpieleObjectLinksSpiel =
    Json.Encode.object
        [ ( "href", Json.Encode.string embeddedSpieleObjectLinksSpiel.href )
        ]


encodeLinks : Links -> Json.Encode.Value
encodeLinks links =
    Json.Encode.object
        [ ( "profile", encodeLinksProfile links.profile )
        , ( "self", encodeLinksSelf links.self )
        ]


encodeLinksSelf : LinksSelf -> Json.Encode.Value
encodeLinksSelf linksSelf =
    Json.Encode.object
        [ ( "href", Json.Encode.string linksSelf.href )
        ]


encodeLinksProfile : LinksProfile -> Json.Encode.Value
encodeLinksProfile linksProfile =
    Json.Encode.object
        [ ( "href", Json.Encode.string linksProfile.href )
        ]
