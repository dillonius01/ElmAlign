module Utils exposing (..)

import Regex exposing (caseInsensitive, contains, regex)


makeApiEndpoint : String -> String
makeApiEndpoint resource =
    "https://shielded-everglades-49151.herokuapp.com/api/" ++ resource


matchString : String -> String -> Bool
matchString searchText toSearch =
    contains (caseInsensitive <| regex searchText) toSearch



--getAllCompanies : Cmd Msg
--getAllCompanies =
--    let
--        url =
--            makeApiEndpoint "companies"
--        request =
--            Http.get url companiesDecoder
--    in
--    Http.send LoadAllCompanies request
--getAllContacts : Cmd Msg
--getAllContacts =
--    let
--        url =
--            makeApiEndpoint "contacts"
--        request =
--            Http.get url contactsDecoder
--    in
--    Http.send LoadAllContacts request
-- SUBSCRIPTIONS
