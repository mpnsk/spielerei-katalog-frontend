module UI exposing (layout)

import Gen.Route as Route exposing (Route)
import Html exposing (Html)
import Html.Attributes as Attr


layout : List (Html msg) -> List (Html msg)
layout children =
    let
        viewLink : String -> Route -> Html msg
        viewLink label route =
            --Html.a [ Attr.href url ] [ Html.text label ]
            Html.a [ Attr.href (Route.toHref route) ] [ Html.text label ]

        link : Route -> Html msg
        link route =
            viewLink (Route.toHref route) route
    in
    [ Html.div [ Attr.class "container" ]
        [ Html.header [ Attr.class "navbar" ]
            [ link Route.Home_

            --viewLink "Home" Route.Home_
            , link Route.GetSpiel
            , link Route.GetSpiele

            --, viewLink "Static" Route.AboutUs
            ]
        , Html.main_ [] children
        ]
    ]
