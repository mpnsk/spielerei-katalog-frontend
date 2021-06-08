module Pagination exposing (..)

import Css
import Html.Styled exposing (a, div, nav, p, span, text)
import Html.Styled.Attributes as Attr exposing (css)
import Svg.Styled exposing (path, svg)
import Svg.Styled.Attributes as SvgAttr
import Tailwind.Breakpoints as Bp
import Tailwind.Utilities as Tw


rangePagination =
    --List.range 0 17
    --|> List.filter (\i -> Basics.modBy 2 i == 0)
    let
        x =
            clamp min 4 max

        min =
            1

        max =
            17

        start =
            [ text <| String.fromInt min ++ " ... " ]

        end =
            [ text <| " ... " ++ String.fromInt max ]
    in
    if x == min then
        List.append [ listToHtml (1 :: 2 :: 3 :: []) ] end

    else if x == min + 1 then
        List.append [ listToHtml (1 :: 2 :: 3 :: 4 :: []) ] end

    else if x == min + 2 then
        List.append [ listToHtml (1 :: 2 :: 3 :: 4 :: 5 :: []) ] end

    else if x == min + 3 then
        List.append [ listToHtml (1 :: 2 :: 3 :: 4 :: 5 :: 6 :: []) ] end

    else if x == min + 4 then
        List.append [ listToHtml (1 :: 2 :: 3 :: 4 :: 5 :: 6 :: 7 :: []) ] end

    else if x == max - 3 then
        List.append start [ listToHtml (x - 2 :: x - 1 :: x :: x + 1 :: x + 2 :: x + 3 :: []) ]

    else if x == max - 2 then
        List.append start [ listToHtml (x - 2 :: x - 1 :: x :: x + 1 :: x + 2 :: []) ]

    else if x == max - 1 then
        List.append start [ listToHtml (x - 2 :: x - 1 :: x :: x + 1 :: []) ]

    else if x == max then
        List.append start [ listToHtml (x - 2 :: x - 1 :: x :: []) ]

    else
        List.append (List.append start [ listToHtml (x - 2 :: x - 1 :: x :: x + 1 :: x + 2 :: []) ]) end


listToHtml list =
    list
        |> List.map String.fromInt
        |> List.map (\s -> " " ++ s ++ " ")
        |> List.foldr (++) ""
        |> text


paginationTw =
    {- This example requires Tailwind CSS v2.0+ -}
    div
        [ css
            [ Tw.bg_white
            , Tw.px_4
            , Tw.py_3
            , Tw.flex
            , Tw.items_center
            , Tw.justify_between
            , Tw.border_t
            , Tw.border_gray_200
            , Bp.sm
                [ Tw.px_6
                ]
            ]
        ]
        [ div
            [ css
                [ Tw.flex_1
                , Tw.flex
                , Tw.justify_between
                , Bp.sm
                    [ Tw.hidden
                    ]
                ]
            ]
            [ a
                [ Attr.href "#"
                , css
                    [ Tw.relative
                    , Tw.inline_flex
                    , Tw.items_center
                    , Tw.px_4
                    , Tw.py_2
                    , Tw.border
                    , Tw.border_gray_300
                    , Tw.text_sm
                    , Tw.font_medium
                    , Tw.rounded_md
                    , Tw.text_gray_700
                    , Tw.bg_white
                    , Css.hover
                        [ Tw.bg_gray_50
                        ]
                    ]
                ]
                [ text "Previous" ]
            , a
                [ Attr.href "#"
                , css
                    [ Tw.ml_3
                    , Tw.relative
                    , Tw.inline_flex
                    , Tw.items_center
                    , Tw.px_4
                    , Tw.py_2
                    , Tw.border
                    , Tw.border_gray_300
                    , Tw.text_sm
                    , Tw.font_medium
                    , Tw.rounded_md
                    , Tw.text_gray_700
                    , Tw.bg_white
                    , Css.hover
                        [ Tw.bg_gray_50
                        ]
                    ]
                ]
                [ text "Next" ]
            ]
        , div
            [ css
                [ Tw.hidden
                , Bp.sm
                    [ Tw.flex_1
                    , Tw.flex
                    , Tw.items_center
                    , Tw.justify_between
                    ]
                ]
            ]
            [ div []
                [ p
                    [ css
                        [ Tw.text_sm
                        , Tw.text_gray_700
                        ]
                    ]
                    [ text "Showing "
                    , span
                        [ css
                            [ Tw.font_medium
                            ]
                        ]
                        [ text " 1 " ]
                    , text " to "
                    , span
                        [ css
                            [ Tw.font_medium
                            ]
                        ]
                        [ text "10" ]
                    , text " of "
                    , span
                        [ css
                            [ Tw.font_medium
                            ]
                        ]
                        [ text "97" ]
                    , text "results"
                    ]
                ]
            , div []
                [ nav
                    [ css
                        [ Tw.relative
                        , Tw.z_0
                        , Tw.inline_flex
                        , Tw.rounded_md
                        , Tw.shadow_sm
                        , Tw.neg_space_x_px
                        ]
                    , Attr.attribute "aria-label" "Pagination"
                    ]
                    [ a
                        [ Attr.href "#"
                        , css
                            [ Tw.relative
                            , Tw.inline_flex
                            , Tw.items_center
                            , Tw.px_2
                            , Tw.py_2
                            , Tw.rounded_l_md
                            , Tw.border
                            , Tw.border_gray_300
                            , Tw.bg_white
                            , Tw.text_sm
                            , Tw.font_medium
                            , Tw.text_gray_500
                            , Css.hover
                                [ Tw.bg_gray_50
                                ]
                            ]
                        ]
                        [ span
                            [ css
                                [ Tw.sr_only
                                ]
                            ]
                            [ text "Previous" ]
                        , {- Heroicon name: solid/chevron-left -}
                          svg
                            [ SvgAttr.css
                                [ Tw.h_5
                                , Tw.w_5
                                ]
                            , SvgAttr.viewBox "0 0 20 20"
                            , SvgAttr.fill "currentColor"
                            , Attr.attribute "aria-hidden" "true"
                            ]
                            [ path
                                [ SvgAttr.fillRule "evenodd"
                                , SvgAttr.d "M12.707 5.293a1 1 0 010 1.414L9.414 10l3.293 3.293a1 1 0 01-1.414 1.414l-4-4a1 1 0 010-1.414l4-4a1 1 0 011.414 0z"
                                , SvgAttr.clipRule "evenodd"
                                ]
                                []
                            ]
                        ]
                    , {- Current: "z-10 bg-indigo-50 border-indigo-500 text-indigo-600", Default: "bg-white border-gray-300 text-gray-500 hover:bg-gray-50" -}
                      a
                        [ Attr.href "#"
                        , Attr.attribute "aria-current" "page"
                        , css
                            [ Tw.z_10
                            , Tw.bg_indigo_50
                            , Tw.border_indigo_500
                            , Tw.text_indigo_600
                            , Tw.relative
                            , Tw.inline_flex
                            , Tw.items_center
                            , Tw.px_4
                            , Tw.py_2
                            , Tw.border
                            , Tw.text_sm
                            , Tw.font_medium
                            ]
                        ]
                        [ text "1" ]
                    , a
                        [ Attr.href "#"
                        , css
                            [ Tw.bg_white
                            , Tw.border_gray_300
                            , Tw.text_gray_500
                            , Tw.relative
                            , Tw.inline_flex
                            , Tw.items_center
                            , Tw.px_4
                            , Tw.py_2
                            , Tw.border
                            , Tw.text_sm
                            , Tw.font_medium
                            , Css.hover
                                [ Tw.bg_gray_50
                                ]
                            ]
                        ]
                        [ text "2" ]
                    , a
                        [ Attr.href "#"
                        , css
                            [ Tw.bg_white
                            , Tw.border_gray_300
                            , Tw.text_gray_500
                            , Tw.hidden
                            , Tw.relative
                            , Tw.items_center
                            , Tw.px_4
                            , Tw.py_2
                            , Tw.border
                            , Tw.text_sm
                            , Tw.font_medium
                            , Css.hover
                                [ Tw.bg_gray_50
                                ]
                            , Bp.md
                                [ Tw.inline_flex
                                ]
                            ]
                        ]
                        [ text "3" ]
                    , span
                        [ css
                            [ Tw.relative
                            , Tw.inline_flex
                            , Tw.items_center
                            , Tw.px_4
                            , Tw.py_2
                            , Tw.border
                            , Tw.border_gray_300
                            , Tw.bg_white
                            , Tw.text_sm
                            , Tw.font_medium
                            , Tw.text_gray_700
                            ]
                        ]
                        [ text "..." ]
                    , a
                        [ Attr.href "#"
                        , css
                            [ Tw.bg_white
                            , Tw.border_gray_300
                            , Tw.text_gray_500
                            , Tw.hidden
                            , Tw.relative
                            , Tw.items_center
                            , Tw.px_4
                            , Tw.py_2
                            , Tw.border
                            , Tw.text_sm
                            , Tw.font_medium
                            , Css.hover
                                [ Tw.bg_gray_50
                                ]
                            , Bp.md
                                [ Tw.inline_flex
                                ]
                            ]
                        ]
                        [ text "8" ]
                    , a
                        [ Attr.href "#"
                        , css
                            [ Tw.bg_white
                            , Tw.border_gray_300
                            , Tw.text_gray_500
                            , Tw.relative
                            , Tw.inline_flex
                            , Tw.items_center
                            , Tw.px_4
                            , Tw.py_2
                            , Tw.border
                            , Tw.text_sm
                            , Tw.font_medium
                            , Css.hover
                                [ Tw.bg_gray_50
                                ]
                            ]
                        ]
                        [ text "9" ]
                    , a
                        [ Attr.href "#"
                        , css
                            [ Tw.bg_white
                            , Tw.border_gray_300
                            , Tw.text_gray_500
                            , Tw.relative
                            , Tw.inline_flex
                            , Tw.items_center
                            , Tw.px_4
                            , Tw.py_2
                            , Tw.border
                            , Tw.text_sm
                            , Tw.font_medium
                            , Css.hover
                                [ Tw.bg_gray_50
                                ]
                            ]
                        ]
                        [ text "10" ]
                    , a
                        [ Attr.href "#"
                        , css
                            [ Tw.relative
                            , Tw.inline_flex
                            , Tw.items_center
                            , Tw.px_2
                            , Tw.py_2
                            , Tw.rounded_r_md
                            , Tw.border
                            , Tw.border_gray_300
                            , Tw.bg_white
                            , Tw.text_sm
                            , Tw.font_medium
                            , Tw.text_gray_500
                            , Css.hover
                                [ Tw.bg_gray_50
                                ]
                            ]
                        ]
                        [ span
                            [ css
                                [ Tw.sr_only
                                ]
                            ]
                            [ text "Next" ]
                        , {- Heroicon name: solid/chevron-right -}
                          svg
                            [ SvgAttr.css
                                [ Tw.h_5
                                , Tw.w_5
                                ]
                            , SvgAttr.viewBox "0 0 20 20"
                            , SvgAttr.fill "currentColor"
                            , Attr.attribute "aria-hidden" "true"
                            ]
                            [ path
                                [ SvgAttr.fillRule "evenodd"
                                , SvgAttr.d "M7.293 14.707a1 1 0 010-1.414L10.586 10 7.293 6.707a1 1 0 011.414-1.414l4 4a1 1 0 010 1.414l-4 4a1 1 0 01-1.414 0z"
                                , SvgAttr.clipRule "evenodd"
                                ]
                                []
                            ]
                        ]
                    ]
                ]
            ]
        ]
