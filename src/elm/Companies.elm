module Companies
    exposing
        ( Companies
        , Company
        , Model
        , Msg
        , companyDecoder
        , init
        , initialModel
        , matchCompany
        , update
        , view
        )

import Html exposing (..)
import Html.Attributes exposing (..)
import Http
import Json.Decode as JD exposing (Decoder, field, int, map3, string)
import Utils exposing (listItemView, makeApiEndpoint, matchAnyString, sortByScoreDescending)


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


iconView : Html msg
iconView =
    i [ class "fa fa-building" ] []


textView : Company -> List (Html msg)
textView company =
    [ div [ class "ctn-text" ]
        [ h4 [ class "item-name" ] [ text company.name ]
        ]
    ]


companyView : Company -> Html msg
companyView company =
    listItemView company iconView (textView company)


view : String -> Model -> Html msg
view filter model =
    div [ class "companiesList" ] (generateCompanyList filter model.companies)


generateCompanyList : String -> Companies -> List (Html msg)
generateCompanyList filter companies =
    companies
        |> renderCompanies
        << sortByScoreDescending
        << matchCompanies filter


renderCompanies : Companies -> List (Html msg)
renderCompanies companies =
    List.map companyView companies


matchCompany : String -> Company -> Bool
matchCompany filter company =
    matchAnyString filter [ company.name ]


matchCompanies : String -> Companies -> Companies
matchCompanies filter companies =
    List.filter (matchCompany filter) companies
