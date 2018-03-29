module Filter.View exposing (filterView)

import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (onInput)


filterView : String -> (String -> msg) -> Html msg
filterView filter msg =
    div [ id "filter" ]
        [ input [ type_ "text", placeholder "filter", value filter, onInput msg ] []
        ]
