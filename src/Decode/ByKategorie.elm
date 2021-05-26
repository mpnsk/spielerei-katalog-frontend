module Decode.ByKategorie exposing (..)

import Decode.Spiel exposing (Spiel, spielMemberDecoder, spielObjectDecoder)
import Json.Decode



-- Required packages:
-- * elm/json


rootDecoder : Json.Decode.Decoder (List KategorieTupel)
rootDecoder =
    Json.Decode.keyValuePairs (Json.Decode.list spielObjectDecoder)


type alias KategorieTupel =
    ( String, List Spiel )


spielListDecoder : Json.Decode.Decoder (List Spiel)
spielListDecoder =
    Json.Decode.list spielMemberDecoder
