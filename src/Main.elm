module Main exposing (..)

import Companies exposing (..)
import Contacts exposing (..)
import Filter exposing (..)
import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (onClick, onInput)
import Navigation exposing (..)


main =
    Html.program
        { init = init
        , view = view
        , update = update
        , subscriptions = subscriptions
        }



-- MODEL


type alias Model =
    { companies : Companies.Model
    , contacts : Contacts.Model
    , filter : Filter.Model
    , navigation : Navigation.Model
    }



-- INIT


initialModel : Model
initialModel =
    { companies = Companies.initialModel
    , contacts = Contacts.initialModel
    , filter = Filter.initialModel
    , navigation = Navigation.initialModel
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
    | NavigationMsg Navigation.Msg


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

        NavigationMsg subMsg ->
            let
                updatedNavigationModel =
                    Navigation.update subMsg model.navigation
            in
            ( { model | navigation = updatedNavigationModel }, Cmd.none )


subscriptions : Model -> Sub Msg
subscriptions model =
    Sub.none



-- VIEW


pageStyles : List ( String, String )
pageStyles =
    [ ( "font-family", "Arial" )
    , ( "padding", "1em 1em 0em 1em" )
    , ( "width", "320px" )
    , ( "float", "right" )
    , ( "border", "2px solid grey" )
    ]


view : Model -> Html Msg
view model =
    div [ Html.Attributes.style <| pageStyles ]
        [ Html.map NavigationMsg (Navigation.headerView model.navigation)
        , Html.map NavigationMsg Navigation.footerView
        , Html.map FilterMsg (Filter.view model.filter)
        , Html.map CompaniesMsg (Companies.view model.companies)
        ]
