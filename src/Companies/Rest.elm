module Companies.Rest exposing (companiesDecoder, companyDecoder)

import Companies.Types exposing (Companies, Company)
import Json.Decode exposing (Decoder, field, int, list, map3, string)


-- https://stackoverflow.com/questions/35801776/parsing-nested-json-in-elm
-- Decoders


companyDecoder : Decoder Company
companyDecoder =
    map3 Company
        (field "id" int)
        (field "name" string)
        (field "score" int)


companiesDecoder : Decoder Companies
companiesDecoder =
    field "companies" (list companyDecoder)
