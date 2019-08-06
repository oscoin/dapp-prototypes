module DAO.Champion exposing (Champion, coins, init)

import Person exposing (Person)


{-| The project member who proposed and therefore champions the change.
-}
type Champion
    = Champion Person


init : Person -> Champion
init p =
    Champion p


coins : Champion -> Int
coins (Champion p) =
    Person.coins p
