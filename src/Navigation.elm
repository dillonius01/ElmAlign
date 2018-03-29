module Navigation
    exposing
        ( Model
        , Msg
        , footerView
        , headerView
        , initialModel
        , update
        )

import Html exposing (..)
import Html.Attributes exposing (id)
import Html.Events exposing (onClick, onInput)


-- MODEL


type alias Model =
    { currentTab : MenuTab
    }


type MenuTab
    = AllCompanies
    | AllContacts


initialModel : Model
initialModel =
    { currentTab = AllCompanies
    }



-- UPDATE


type Msg
    = ChangeTab MenuTab


update : Msg -> Model -> Model
update message model =
    case message of
        ChangeTab newTab ->
            { model | currentTab = newTab }



-- VIEW


footerView : Html Msg
footerView =
    div [ id "footer" ]
        [ div [ id "btn-companies" ]
            [ button [ onClick (ChangeTab AllCompanies) ] [ text "Companies" ] ]
        , div [ id "btn-contacts" ]
            [ button [ onClick (ChangeTab AllContacts) ] [ text "Contacts" ] ]
        ]


headerView : Model -> Html msg
headerView model =
    let
        title =
            menuTabToString model.currentTab
    in
    h3 [] [ text title ]


menuTabToString : MenuTab -> String
menuTabToString tab =
    case tab of
        AllCompanies ->
            "Companies"

        AllContacts ->
            "Contacts"
