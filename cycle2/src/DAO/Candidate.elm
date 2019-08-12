module DAO.Candidate exposing (Candidate, coins, init)

import Person exposing (Person)


{-| The person who is proposed to be added as a member.
-}
type Candidate
    = Candidate Person


init : Person -> Candidate
init p =
    Candidate p


coins : Candidate -> Int
coins (Candidate p) =
    Person.coins p
