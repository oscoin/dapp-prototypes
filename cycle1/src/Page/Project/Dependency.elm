module Page.Project.Dependency exposing (view)

import Atom.Button as Button
import Atom.Heading as Heading
import Atom.Table as Table
import Element exposing (Element)
import Element.Background as Background
import Element.Border as Border
import Element.Font
import Style.Color as Color
import Style.Font as Font



-- MODEL


type alias Relative =
    { project : String
    , osrank : Float
    }


dependencies : List Relative
dependencies =
    [ { project = "IPFS"
      , osrank = 0.84
      }
    , { project = "Cabal package manager"
      , osrank = 0.12
      }
    , { project = "Radicle"
      , osrank = 0.74
      }
    , { project = "Julien package"
      , osrank = 0.99
      }
    , { project = "Vikings"
      , osrank = 0.03
      }
    ]


dependants : List Relative
dependants =
    [ { project = "Radicle"
      , osrank = 0.74
      }
    , { project = "Julien package"
      , osrank = 0.99
      }
    , { project = "IPFS"
      , osrank = 0.84
      }
    , { project = "Cabal package manager"
      , osrank = 0.12
      }
    , { project = "Vikings"
      , osrank = 0.03
      }
    ]



-- VIEW


view : Element msg
view =
    Element.row
        [ Element.spacing 24
        , Element.paddingEach { top = 64, right = 0, bottom = 0, left = 0 }
        , Element.width Element.fill
        ]
        [ viewDependency dependencies "Dependendents"
        , viewDependency dependants "Dependencies"
        ]


viewDependency : List Relative -> String -> Element msg
viewDependency dependenciesData title =
    Element.column
        [ Element.width Element.fill ]
        [ Heading.sectionWithCount [] title <| List.length dependenciesData
        , Element.table
            []
            { data = dependenciesData
            , columns =
                [ { header =
                        Table.headLeft
                            []
                            "PROJECT NAME"
                  , width = Element.px 442
                  , view =
                        \dependency ->
                            Element.el
                                ([ Element.paddingEach { top = 11, right = 0, bottom = 0, left = 24 }
                                 , Element.height <| Element.px 40
                                 ]
                                    ++ Font.mediumBodyText Color.darkGrey
                                )
                            <|
                                Element.text dependency.project
                  }
                , { header =
                        Table.headRight
                            []
                            "OSRANK"
                  , width = Element.px 83
                  , view =
                        \dependency ->
                            Element.el
                                ([ Element.paddingEach { top = 11, right = 24, bottom = 0, left = 0 }
                                 , Element.height <| Element.px 40
                                 , Element.Font.alignRight
                                 ]
                                    ++ Font.boldBodyTextMono Color.darkGrey
                                )
                            <|
                                Element.text (String.fromFloat dependency.osrank)
                  }
                ]
            }
        , Button.custom [ Element.width Element.fill ] Color.almostWhite Color.darkGrey "View all"
        ]
