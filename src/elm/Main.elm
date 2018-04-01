module Main exposing (..)

import Companies exposing (..)
import Contacts exposing (..)
import Filter exposing (..)
import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (onClick)


main =
    Html.program
        { init = init
        , view = view
        , update = update
        , subscriptions = subscriptions
        }



-- MODEL


type MenuTab
    = AllCompanies
    | AllContacts


type alias Model =
    { companies : Companies.Model
    , contacts : Contacts.Model
    , filter : Filter.Model
    , currentTab : MenuTab
    }



-- INIT


initialModel : Model
initialModel =
    { companies = Companies.initialModel
    , contacts = Contacts.initialModel
    , filter = Filter.initialModel
    , currentTab = AllCompanies
    }


init : ( Model, Cmd Msg )
init =
    initialModel
        ! [ Cmd.map ContactsMsg Contacts.init
          , Cmd.map CompaniesMsg Companies.init
          ]


type Msg
    = FilterMsg Filter.Msg
    | CompaniesMsg Companies.Msg
    | ContactsMsg Contacts.Msg
    | ChangeTab MenuTab


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        FilterMsg subMsg ->
            let
                updatedFilterModel =
                    Filter.update subMsg model.filter
            in
            ( { model | filter = updatedFilterModel }, Cmd.none )

        CompaniesMsg subMsg ->
            let
                ( updatedCompaniesModel, companiesCmd ) =
                    Companies.update subMsg model.companies
            in
            ( { model | companies = updatedCompaniesModel }, Cmd.map CompaniesMsg companiesCmd )

        ContactsMsg subMsg ->
            let
                ( updatedContactsModel, contactsCmd ) =
                    Contacts.update subMsg model.contacts
            in
            ( { model | contacts = updatedContactsModel }, Cmd.map ContactsMsg contactsCmd )

        ChangeTab newTab ->
            ( { model | currentTab = newTab }, Cmd.none )


subscriptions : Model -> Sub Msg
subscriptions model =
    Sub.none



-- VIEW

view : Model -> Html Msg
view model =
    div [ ]
        [ headerView model.currentTab
        , footerView
        , Html.map FilterMsg (Filter.view model.filter)
        , bodyView model
        ]



-- NAVIGATION


headerView : MenuTab -> Html msg
headerView tab =
    h3 [] [ text (menuTabToString tab) ]


bodyView : Model -> Html Msg
bodyView model =
    let
        innerList =
            case model.currentTab of
                AllCompanies ->
                    Html.map CompaniesMsg (Companies.view model.filter.searchText model.companies)

                AllContacts ->
                    Html.map ContactsMsg (Contacts.view model.filter.searchText model.contacts)
    in
    div [ id "list-container" ] [ innerList ]


footerView : Html Msg
footerView =
    div [ id "footer" ]
        [ div [ id "btn-companies" ]
            [ button [ onClick (ChangeTab AllCompanies) ] [ text "Companies" ] ]
        , div [ id "btn-contacts" ]
            [ button [ onClick (ChangeTab AllContacts) ] [ text "Contacts" ] ]
        ]


menuTabToString : MenuTab -> String
menuTabToString tab =
    case tab of
        AllCompanies ->
            "Companies"

        AllContacts ->
            "Contacts"
