module Utils
    exposing
        ( listItemView
        , makeApiEndpoint
        , matchAnyString
        , sortByScoreDescending
        , spinnerView
        )

import Html exposing (..)
import Html.Attributes exposing (..)
import Regex exposing (caseInsensitive, contains, regex)


makeApiEndpoint : String -> String
makeApiEndpoint resource =
    "https://shielded-everglades-49151.herokuapp.com/api/" ++ resource


matchAnyString : String -> List String -> Bool
matchAnyString searchText listToSearch =
    let
        re =
            caseInsensitive <| regex searchText
    in
    List.any (contains re) listToSearch


type alias HasScore r =
    { r
        | score : Int
    }


spinnerView : Html msg
spinnerView =
    div [ class "loading-spinner" ]
        [ div [ class "spinner-kid" ]
            [ i [ class "fas fa-spinner fa-pulse" ] []
            ]
        ]


listItemView : HasScore r -> Html msg -> List (Html msg) -> Html msg
listItemView item icon detailText =
    div [ class "list-inner-item contact" ]
        [ div [ class "list-inner-ctn ctn-85 ctn-padded-group" ]
            [ div [ class "list-inner-flex" ]
                [ div [ class "list-inner-ctn ctn-15" ]
                    [ div [ class "ctn-icon" ]
                        [ icon ]
                    ]
                , div [ class "list-inner-ctn ctn-85" ]
                    detailText
                ]
            ]
        , div [ class "list-inner-ctn ctn-15 ctn-top-group" ]
            [ div [ class "ctn-score" ]
                [ span [] [ text <| toString item.score ] ]
            ]
        ]


sortByScoreDescending : List (HasScore r) -> List (HasScore r)
sortByScoreDescending items =
    List.sortWith compareScores items


compareScores : HasScore r -> HasScore r -> Order
compareScores item1 item2 =
    descending item1.score item2.score


descending : comparable -> comparable -> Order
descending a b =
    case compare a b of
        LT ->
            GT

        GT ->
            LT

        EQ ->
            EQ
