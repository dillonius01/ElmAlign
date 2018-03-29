module Main exposing (..)

--import Filter.View exposing (filterView)

import Companies.Rest exposing (companiesDecoder)
import Companies.Types exposing (Companies, Company)
import Companies.View exposing (companiesListView)
import Contacts.Rest exposing (contactsDecoder)
import Contacts.Types exposing (Contact, Contacts)
import Filter.View exposing (filterView)
import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (onClick, onInput)
import Http
import Json.Decode exposing (Decoder)


main =
    Html.program
        { init = init
        , view = view
        , update = update
        , subscriptions = subscriptions
        }



-- MODEL


type alias Model =
    { companies : Companies
    , contacts : Contacts
    , errorMsg : String
    , filter : String
    }



-- INIT


init : ( Model, Cmd Msg )
init =
    let
        model =
            Model [] [] "" ""
    in
    model ! [ getAllCompanies, getAllContacts ]


type Msg
    = SetFilter String
    | AllCompanies (Result Http.Error Companies)
    | AllContacts (Result Http.Error Contacts)


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        SetFilter filter ->
            ( { model | filter = filter }, Cmd.none )

        AllCompanies (Ok companies) ->
            ( { model | companies = companies, errorMsg = "" }, Cmd.none )

        AllCompanies (Err error) ->
            ( { model | errorMsg = toString error }, Cmd.none )

        AllContacts (Ok contacts) ->
            ( { model | contacts = contacts, errorMsg = "" }, Cmd.none )

        AllContacts (Err error) ->
            ( { model | errorMsg = toString error }, Cmd.none )


type SupportedResource
    = GetAllCompanies
    | GetAllContacts



---------------------
-- HELPER METHODOS --
---------------------
--fetchResource : SupportedResource -> Cmd Msg
--fetchResource resource =
--    let
--        url =
--            makeApiEndpoint resource
--        request =
--            Http.get url (getDecoder resource)
--    in
--    Http.send (getMsg resource) request
--getMsg : SupportedResource -> Result Http.Error Msg a
--getMsg resource =
--    case resource of
--        GetAllCompanies ->
--            AllCompanies
--        GetAllContacts ->
--            AllContacts
--getDecoder : SupportedResource -> Decoder a
--getDecoder resource =
--    case resource of
--        GetAllCompanies ->
--            companiesDecoder
--        GetAllContacts ->
--            contactsDecoder
---------------------
---- END METHODS  ---
---------------------


getAllCompanies : Cmd Msg
getAllCompanies =
    let
        url =
            makeApiEndpoint GetAllCompanies

        request =
            Http.get url companiesDecoder
    in
    Http.send AllCompanies request


getAllContacts : Cmd Msg
getAllContacts =
    let
        url =
            makeApiEndpoint GetAllContacts

        request =
            Http.get url contactsDecoder
    in
    Http.send AllContacts request


makeApiEndpoint : SupportedResource -> String
makeApiEndpoint resource =
    let
        endpoint =
            case resource of
                GetAllCompanies ->
                    "companies"

                GetAllContacts ->
                    "contacts"
    in
    "https://shielded-everglades-49151.herokuapp.com/api/" ++ endpoint



-- SUBSCRIPTIONS


subscriptions : Model -> Sub Msg
subscriptions model =
    Sub.none



-- VIEW


view : Model -> Html Msg
view model =
    div []
        [ h3 [] [ text "Welcome to ElmAlign" ]
        , filterView model.filter SetFilter
        , companiesListView model.companies
        ]
