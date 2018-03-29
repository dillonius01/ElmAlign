module Utils exposing (..)


makeApiEndpoint : String -> String
makeApiEndpoint resource =
    "https://shielded-everglades-49151.herokuapp.com/api/" ++ resource



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
