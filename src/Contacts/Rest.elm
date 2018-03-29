module Contacts.Rest exposing (contactsDecoder)

import Companies.Rest exposing (companyDecoder)
import Contacts.Types exposing (Contact, Contacts)
import Json.Decode exposing (Decoder, bool, field, int, list, map5, string)


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
    field "contacts" (list contactDecoder)
