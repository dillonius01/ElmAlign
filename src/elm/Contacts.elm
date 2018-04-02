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
import Utils exposing (listItemView, makeApiEndpoint, matchAnyString, sortByScoreDescending, spinnerView)


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


iconView : Contact -> Html msg
iconView contact =
    span [] [ text (makeInitials contact) ]


textView : Contact -> List (Html msg)
textView contact =
    [ div [ class "ctn-text" ]
        [ h4 [ class "item-name" ] [ text contact.name ]
        ]
    , div [ class "ctn-text" ]
        [ h5 [ class "item-subtitle" ] [ text contact.company.name ]
        ]
    ]


contactView : Contact -> Html msg
contactView contact =
    listItemView contact (iconView contact) (textView contact)


view : String -> Model -> Html msg
view filter model =
    if List.isEmpty model.contacts then
        spinnerView
    else
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
