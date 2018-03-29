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
import Utils exposing (makeApiEndpoint)


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


contactView : Contact -> Html msg
contactView contact =
    div [ class "contact" ]
        [ h3 [] [ text contact.name ]
        , span [] [ text contact.company.name ]
        , span [] [ text <| toString contact.score ]
        ]


view : String -> Model -> Html Msg
view filter model =
    div []
        [ span [] [ text ("current filter: " ++ filter) ]
        , div [ class "contactsList" ] (List.map contactView model.contacts)
        ]



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
