module Filter exposing (Model, Msg, initialModel, update, view)

import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (onClick, onInput)


-- MODEL


type alias Model =
    { searchText : String
    }


initialModel : Model
initialModel =
    { searchText = ""
    }



-- UPDATE


type Msg
    = SetSearchText String
    | Clear


update : Msg -> Model -> Model
update message model =
    case message of
        SetSearchText text ->
            { model | searchText = text }

        Clear ->
            { model | searchText = "" }



-- VIEW


view : Model -> Html Msg
view model =
    div [ id "filter" ]
        [ input [ type_ "text", placeholder "filter", value model.searchText, onInput SetSearchText ] []
        , button [ onClick Clear ] [ text "Clear" ]
        ]
