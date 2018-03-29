module Utils exposing (..)

import Regex exposing (caseInsensitive, contains, regex)


makeApiEndpoint : String -> String
makeApiEndpoint resource =
    "https://shielded-everglades-49151.herokuapp.com/api/" ++ resource


matchAnyString : String -> List String -> Bool
matchAnyString searchText listToSearch =
    let
        re =
            caseInsensitive <| regex searchText
    in
    List.any (contains re) listToSearch
