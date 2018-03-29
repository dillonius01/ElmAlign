module Companies
    exposing
        ( Companies
        , Company
        , Model
        , Msg
        , companyDecoder
        , init
        , initialModel
        , update
        , view
        )

import Html exposing (..)
import Html.Attributes exposing (..)
import Http
import Json.Decode as JD exposing (Decoder, field, int, map3, string)
import Utils exposing (makeApiEndpoint)


-- MODEL


type alias Companies =
    List Company


type alias Company =
    { id : Int
    , name : String
    , score : Int
    }


type alias Model =
    { companies : Companies
    , errorMsg : String
    }


initialModel : Model
initialModel =
    Model [] ""



-- UPDATE


type Msg
    = LoadAllCompanies (Result Http.Error Companies)


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        LoadAllCompanies (Ok companies) ->
            ( { model | companies = companies, errorMsg = "" }, Cmd.none )

        LoadAllCompanies (Err error) ->
            ( { model | errorMsg = toString error }, Cmd.none )


init : Cmd Msg
init =
    let
        url =
            makeApiEndpoint "companies"

        request =
            Http.get url companiesDecoder
    in
    Http.send LoadAllCompanies request



-- DECODERS


companyDecoder : Decoder Company
companyDecoder =
    map3 Company
        (field "id" int)
        (field "name" string)
        (field "score" int)


companiesDecoder : Decoder Companies
companiesDecoder =
    field "companies" (JD.list companyDecoder)



-- VIEW


companyView : Company -> Html msg
companyView company =
    div [ class "company" ]
        [ h3 [] [ text company.name ]
        , span [] [ text <| toString company.score ]
        ]


view : String -> Model -> Html msg
view filter model =
    div []
        [ span [] [ text ("current filter: " ++ filter) ]
        , div [ class "companiesList" ] (List.map companyView model.companies)
        ]
