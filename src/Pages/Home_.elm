module Pages.Home_ exposing (view)

import Html
import UI
import View exposing (View)


view : View msg
view =
    let
        list =
            [ "a", "b", "c", "d" ]

        listText : List String -> String
        listText =
            List.foldr (\x e -> x ++ e) ""
    in
    { title = "Homepage"
    , body =
        UI.layout [ Html.text "homepg" ]

    --[ Html.text <| "Hello, world!!!" ++ listText list ]
    }
