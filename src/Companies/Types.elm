module Companies.Types exposing (Companies, Company)


type alias Companies =
    List Company


type alias Company =
    { id : Int
    , name : String
    , score : Int
    }
