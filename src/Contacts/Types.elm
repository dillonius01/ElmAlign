module Contacts.Types exposing (Contact, Contacts)

import Companies.Types exposing (Company)


type alias Contacts =
    List Contact


type alias Contact =
    { id : Int
    , name : String
    , score : Int
    , company : Company
    , sharing : Bool
    }
