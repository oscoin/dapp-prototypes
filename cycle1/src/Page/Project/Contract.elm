module Page.Project.Contract exposing (view)

import Atom.Button as Button
import Atom.Heading as Heading
import Element exposing (Element)
import Element.Border as Border
import Molecule.ContractPreview as ContractPreview
import Project.Contract as Contract exposing (Contract)
import Style.Color as Color



-- VIEW


view : Contract -> Bool -> Element msg
view contract isMaintainer =
    let
        header =
            if isMaintainer then
                Heading.sectionWithInfo
                    [ Border.color Color.lightGrey
                    , Border.widthEach { top = 0, right = 0, bottom = 1, left = 0 }
                    ]
                    "Project contract"
                    (Button.transparent [] "Edit")

            else
                Heading.section
                    [ Border.color Color.lightGrey
                    , Border.widthEach { top = 0, right = 0, bottom = 1, left = 0 }
                    ]
                    "Project contract"
    in
    Element.column
        [ Element.spacing 24
        , Element.paddingEach { top = 44, right = 0, bottom = 0, left = 0 }
        , Element.width Element.fill
        , Element.centerX
        ]
        [ header
        , ContractPreview.view [] contract
        ]
