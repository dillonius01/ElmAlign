module Main exposing (..)

import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (onClick)
import Http
import Json.Decode as JD exposing (Decoder, field, int, string)


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
    }


type alias Companies =
    List Company


type alias Contacts =
    List Contact


type alias Company =
    { id : Int
    , name : String
    , score : Int
    }


type alias Contact =
    { id : Int
    , name : String
    , score : Int
    , company : Company
    , sharing : Bool
    }



-- INIT


init : ( Model, Cmd Msg )
init =
    let
        model =
            Model [] [] ""
    in
    ( model, getAllCompanies )



--( Model [] [] "", Cmd.none )
-- UPDATE


type Msg
    = FetchCompanies
    | AllCompanies (Result Http.Error Companies)
    | AllContacts Contacts


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        FetchCompanies ->
            ( model, getAllCompanies )

        AllCompanies (Ok companies) ->
            ( { model | companies = companies, errorMsg = "" }, Cmd.none )

        AllCompanies (Err error) ->
            ( { model | errorMsg = toString error }, Cmd.none )

        AllContacts contacts ->
            ( { model | contacts = contacts }, Cmd.none )


getAllCompanies : Cmd Msg
getAllCompanies =
    let
        url =
            makeApiEndpoint "companies"

        request =
            Http.get url companiesDecoder
    in
    Http.send AllCompanies request



-- DECODERS


companyDecoder : Decoder Company
companyDecoder =
    JD.map3 Company
        (field "id" int)
        (field "name" string)
        (field "score" int)



-- https://stackoverflow.com/questions/35801776/parsing-nested-json-in-elm


companiesDecoder : Decoder Companies
companiesDecoder =
    field "companies" (JD.list companyDecoder)


apiBase : String
apiBase =
    "https://shielded-everglades-49151.herokuapp.com/api/"


makeApiEndpoint : String -> String
makeApiEndpoint endpoint =
    apiBase ++ endpoint



-- SUBSCRIPTIONS


subscriptions : Model -> Sub Msg
subscriptions model =
    Sub.none



-- VIEW


view : Model -> Html Msg
view model =
    div []
        [ h3 [] [ text "Welcome to ElmAlign" ]
        , button [ onClick FetchCompanies ] [ text "Get Companies" ]
        ]
