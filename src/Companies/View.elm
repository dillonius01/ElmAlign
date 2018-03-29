module Companies.View exposing (companiesListView)

import Companies.Types exposing (Companies, Company)
import Html exposing (..)
import Html.Attributes exposing (..)


companyView : Company -> Html msg
companyView company =
    div [ class "company" ]
        [ h3 [] [ text company.name ]
        , span [] [ text <| toString company.score ]
        ]


companiesListView : Companies -> Html msg
companiesListView companies =
    div [ class "companiesList" ] (List.map companyView companies)
