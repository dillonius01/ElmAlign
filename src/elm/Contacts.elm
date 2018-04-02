module Contacts
    exposing
        ( Contacts
        , Model
        , Msg
        , init
        , initialModel
        , update
        , view
        )

import Companies exposing (Company, companyDecoder)
import Html exposing (..)
import Html.Attributes exposing (..)
import Http
import Json.Decode as JD exposing (Decoder, bool, field, int, map5, string)
import Regex exposing (..)
import Utils exposing (makeApiEndpoint, matchAnyString, sortByScoreDescending)


-- MODEL


type alias Model =
    { contacts : Contacts
    , errorMsg : String
    }


type alias Contacts =
    List Contact


type alias Contact =
    { id : Int
    , name : String
    , score : Int
    , company : Company
    , sharing : Bool
    }


initialModel : Model
initialModel =
    Model [] ""



-- UPDATE


type Msg
    = LoadAllContacts (Result Http.Error Contacts)


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        LoadAllContacts (Ok contacts) ->
            ( { model | contacts = contacts, errorMsg = "" }, Cmd.none )

        LoadAllContacts (Err error) ->
            ( { model | errorMsg = toString error }, Cmd.none )


init : Cmd Msg
init =
    let
        url =
            makeApiEndpoint "contacts"

        request =
            Http.get url contactsDecoder
    in
    Http.send LoadAllContacts request



-- VIEW


makeInitials : Contact -> String
makeInitials contact =
    contact.name
        |> String.trim
        |> String.split " "
        |> List.map (String.left 1)
        |> String.concat


contactView : Contact -> Html msg
contactView contact =
    div [ class "list-inner-item contact" ]
        [ div [ class "list-inner-ctn ctn-85 ctn-padded-group" ]
            [ div [ class "list-inner-flex" ]
                [ div [ class "list-inner-ctn ctn-15" ]
                    [ div [ class "ctn-icon" ]
                        [ span [] [ text (makeInitials contact) ] ]
                    ]
                , div [ class "list-inner-ctn ctn-85" ]
                    [ div [ class "ctn-text" ]
                        [ h4 [ class "item-name" ] [ text contact.name ]
                        ]
                    , div [ class "ctn-text" ]
                        [ h5 [ class "item-subtitle" ] [ text contact.company.name ]
                        ]
                    ]
                ]
            ]
        , div [ class "list-inner-ctn ctn-15 ctn-top-group" ]
            [ div [ class "ctn-score" ]
                [ span [] [ text <| toString contact.score ] ]
            ]
        ]


view : String -> Model -> Html msg
view filter model =
    div [ class "contactsList" ] (generateContactList filter model.contacts)


generateContactList : String -> Contacts -> List (Html msg)
generateContactList filter contacts =
    contacts
        |> renderContacts
        << sortByScoreDescending
        << matchContacts filter


renderContacts : Contacts -> List (Html msg)
renderContacts contacts =
    List.map contactView contacts


matchContacts : String -> Contacts -> Contacts
matchContacts filter contacts =
    List.filter (matchContact filter) contacts


matchContact : String -> Contact -> Bool
matchContact searchText contact =
    matchAnyString searchText [ contact.name, contact.company.name ]



-- DECODERS


contactDecoder : Decoder Contact
contactDecoder =
    map5 Contact
        (field "id" int)
        (field "name" string)
        (field "score" int)
        (field "company" companyDecoder)
        (field "sharing" bool)


contactsDecoder : Decoder Contacts
contactsDecoder =
    field "contacts" (JD.list contactDecoder)
