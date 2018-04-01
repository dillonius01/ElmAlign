module Utils exposing 
  ( makeApiEndpoint
  , matchAnyString
  , sortByScoreDescending)

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


type alias HasScore r =
    { r
        | score: Int
    }

sortByScoreDescending : List (HasScore r) -> List (HasScore r)
sortByScoreDescending items =
    List.sortWith compareScores items

compareScores : HasScore r -> HasScore r -> Order
compareScores item1 item2 =
    descending item1.score item2.score 

descending: comparable -> comparable -> Order
descending a b =
    case compare a b of
        LT ->
          GT  
        GT ->
          LT
        EQ ->
            EQ
