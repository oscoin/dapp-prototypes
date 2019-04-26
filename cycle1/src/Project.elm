module Project exposing
    ( Project
    , codeHostUrl
    , contract
    , description
    , encode
    , imageUrl
    , init
    , mapCodeHostUrl
    , mapContract
    , mapDescription
    , mapImageUrl
    , mapName
    , mapWebsiteUrl
    , name
    , websiteUrl
    )

import Json.Encode as Encode
import Project.Contract as Contract exposing (Contract)



-- META


type alias Meta =
    { codeHostUrl : String
    , description : String
    , imageUrl : String
    , name : String
    , websiteUrl : String
    }


initMeta : Meta
initMeta =
    { codeHostUrl = ""
    , description = ""
    , imageUrl = ""
    , name = ""
    , websiteUrl = ""
    }



-- PROJECT


type Project
    = Project Meta Contract


init : Project
init =
    Project initMeta Contract.default


mapCodeHostUrl : (String -> String) -> Project -> Project
mapCodeHostUrl change (Project meta currentContract) =
    Project { meta | codeHostUrl = change meta.codeHostUrl } currentContract


codeHostUrl : Project -> String
codeHostUrl (Project meta _) =
    meta.codeHostUrl


mapContract : (Contract -> Contract) -> Project -> Project
mapContract change (Project meta oldContract) =
    Project meta (change oldContract)


contract : Project -> Contract
contract (Project _ currentContract) =
    currentContract


mapDescription : (String -> String) -> Project -> Project
mapDescription change (Project meta currentContract) =
    Project { meta | description = change meta.description } currentContract


description : Project -> String
description (Project meta _) =
    meta.description


mapImageUrl : (String -> String) -> Project -> Project
mapImageUrl change (Project meta currentContract) =
    Project { meta | name = change meta.imageUrl } currentContract


imageUrl : Project -> String
imageUrl (Project meta _) =
    meta.imageUrl


mapName : (String -> String) -> Project -> Project
mapName change (Project meta currentContract) =
    Project { meta | name = change meta.name } currentContract


name : Project -> String
name (Project meta _) =
    meta.name


mapWebsiteUrl : (String -> String) -> Project -> Project
mapWebsiteUrl change (Project meta currentContract) =
    Project { meta | name = change meta.websiteUrl } currentContract


websiteUrl : Project -> String
websiteUrl (Project meta _) =
    meta.websiteUrl



-- ENCODING


encode : Project -> Encode.Value
encode (Project meta currentContract) =
    Encode.object
        [ ( "contract", Contract.encode currentContract )
        , ( "meta", encodeMeta meta )
        ]


encodeMeta : Meta -> Encode.Value
encodeMeta meta =
    Encode.object
        [ ( "codeHostUrl", Encode.string meta.codeHostUrl )
        , ( "description", Encode.string meta.description )
        , ( "imageUrl", Encode.string meta.imageUrl )
        , ( "name", Encode.string meta.name )
        , ( "websiteUrl", Encode.string meta.websiteUrl )
        ]
