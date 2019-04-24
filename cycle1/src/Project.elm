module Project exposing
    ( Project
    , codeHostUrl
    , description
    , encode
    , imageUrl
    , init
    , mapCodeHostUrl
    , mapDescription
    , mapImageUrl
    , mapName
    , mapWebsiteUrl
    , name
    , websiteUrl
    )

import Json.Encode as Encode



-- INTERN


type alias Model =
    { codeHostUrl : String
    , description : String
    , imageUrl : String
    , name : String
    , websiteUrl : String
    }


initModel : Model
initModel =
    { codeHostUrl = ""
    , description = ""
    , imageUrl = ""
    , name = ""
    , websiteUrl = ""
    }



-- DATA


type Project
    = Project Model


init : Project
init =
    Project initModel


mapCodeHostUrl : (String -> String) -> Project -> Project
mapCodeHostUrl change (Project model) =
    Project { model | codeHostUrl = change model.codeHostUrl }


codeHostUrl : Project -> String
codeHostUrl (Project model) =
    model.codeHostUrl


mapDescription : (String -> String) -> Project -> Project
mapDescription change (Project model) =
    Project { model | description = change model.description }


description : Project -> String
description (Project model) =
    model.description


mapImageUrl : (String -> String) -> Project -> Project
mapImageUrl change (Project model) =
    Project { model | name = change model.imageUrl }


imageUrl : Project -> String
imageUrl (Project model) =
    model.imageUrl


mapName : (String -> String) -> Project -> Project
mapName change (Project model) =
    Project { model | name = change model.name }


name : Project -> String
name (Project model) =
    model.name


mapWebsiteUrl : (String -> String) -> Project -> Project
mapWebsiteUrl change (Project model) =
    Project { model | name = change model.websiteUrl }


websiteUrl : Project -> String
websiteUrl (Project model) =
    model.name



-- ENCODING


encode : Project -> Encode.Value
encode (Project model) =
    Encode.object
        [ ( "name", Encode.string model.name )
        ]
