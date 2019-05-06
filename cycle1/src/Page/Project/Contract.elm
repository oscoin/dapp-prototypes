module Page.Project.Contract exposing (view)

import Atom.Heading as Heading
import Atom.Icon as Icon
import Element exposing (Element)
import Element.Border as Border
import Molecule.ContractPreview as ContractPreview
import Molecule.Rule as Rule
import Project.Contract as Contract exposing (Contract)
import Style.Color as Color
import Style.Font as Font



-- VIEW


view : Contract -> Element msg
view contract =
    Element.column
        [ Element.spacing 24
        , Element.paddingEach { top = 44, right = 0, bottom = 0, left = 0 }
        , Element.width Element.fill
        , Element.centerX
        ]
        [ Heading.section
            [ Border.color Color.lightGrey
            , Border.widthEach { top = 0, right = 0, bottom = 1, left = 0 }
            ]
            "Project contract"
        , ContractPreview.view [] contract
        ]
