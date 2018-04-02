module UtilsTests exposing (..)

import Expect exposing (..)
import Fuzz exposing (Fuzzer, int, list, string)
import Test exposing (..)
import Utils exposing (matchAnyString, sortByScoreDescending)


type alias DummyPerson =
    { name : String, score : Int }


personHigh =
    DummyPerson "Frank" 100


personMed =
    DummyPerson "Ling" 73


personLow =
    DummyPerson "Kudra" 35


unsortedPeople : List DummyPerson
unsortedPeople =
    [ personMed, personLow, personHigh ]


sortedPeople : List DummyPerson
sortedPeople =
    [ personHigh, personMed, personLow ]


utilsSuite : Test
utilsSuite =
    describe "Helper functions defined in Utils.elm"
        [ describe "matchAnyString"
            [ test "returns true if string matches any in list" <|
                \_ ->
                    let
                        filter =
                            "dino"

                        candidates =
                            [ "plant", "dinosaur" ]
                    in
                    Expect.true "Expected there to be a match" (matchAnyString filter candidates)
            , test "returns false if no matches" <|
                \_ ->
                    let
                        filter =
                            "eminem"

                        candidates =
                            [ "bigpoppa", "bigpun", "fatjoe" ]
                    in
                    Expect.false "Expected there not to be a match" (matchAnyString filter candidates)
            , test "matches regardless of case" <|
                \_ ->
                    let
                        filter =
                            "DINO"

                        candidates =
                            [ "plant", "dinosaur" ]
                    in
                    Expect.true "Expected there to be a match" (matchAnyString filter candidates)
            ]
        , describe "sortScoreByDescending"
            [ test "sorts by score descending" <|
                \_ ->
                    sortedPeople
                        |> Expect.equalLists (sortByScoreDescending unsortedPeople)
            ]
        ]
