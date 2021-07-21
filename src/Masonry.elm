module Masonry exposing (fromItems)

import Array
import Decode.SpringDataRestSpiel exposing (EmbeddedSpieleObject)
import List.Extra



-- from https://github.com/lucamug/elm-masonry


type alias Position =
    Int


type alias Height =
    Int


type alias Masonry =
    List (List ( Position, Height ))


type alias SpieleMasonry =
    List (List ( Position, EmbeddedSpieleObject ))


columnHeight : List ( Position, Height ) -> Height
columnHeight column =
    List.foldl (\( _, height ) total -> height + total) 0 column


spieleColumnHeight : List ( Position, EmbeddedSpieleObject ) -> Height
spieleColumnHeight column =
    List.foldl (\( _, height ) total -> height + total) 0 column


columnsHeights : Masonry -> List Height
columnsHeights masonry =
    List.map columnHeight masonry


positionOfShortestHeight : List Height -> Position
positionOfShortestHeight listOfHeights =
    let
        helper itemPosition itemHeight accPosition =
            if itemHeight == (Maybe.withDefault 0 <| List.minimum listOfHeights) then
                itemPosition

            else
                accPosition
    in
    List.Extra.indexedFoldl helper 0 listOfHeights


minimumHeightPosition : Masonry -> Position
minimumHeightPosition masonry =
    masonry |> columnsHeights |> positionOfShortestHeight


addItemToMasonry : Position -> Height -> Masonry -> Masonry
addItemToMasonry position height masonry =
    let
        minPosition : Position
        minPosition =
            minimumHeightPosition masonry

        column : List ( Position, Height )
        column =
            Maybe.withDefault [] <| Array.get minPosition (Array.fromList masonry)

        newColumn_ : List ( Position, Height )
        newColumn_ =
            ( position, height ) :: column
    in
    Array.toList <| Array.set minPosition newColumn_ (Array.fromList masonry)


fromItems : List Height -> Int -> Masonry
fromItems items columns =
    let
        repeat : List (List a)
        repeat =
            List.repeat columns []
    in
    List.Extra.indexedFoldl addItemToMasonry repeat items


fromSpiele : List EmbeddedSpieleObject -> Int -> SpieleMasonry
fromSpiele items columns =
    List.Extra.indexedFoldl addItemToSpieleMasonry (List.repeat columns []) items


addItemToSpieleMasonry : Position -> EmbeddedSpieleObject -> SpieleMasonry -> SpieleMasonry
addItemToSpieleMasonry position height masonry =
    []
