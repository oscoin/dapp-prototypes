module Project exposing
    ( Address
    , Project
    , address
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



-- ADDRESS


type alias Address =
    String



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
    = Project Address Meta Contract


init : Project
init =
    Project "" initMeta Contract.default


address : Project -> Address
address (Project addr _ _) =
    addr


mapCodeHostUrl : (String -> String) -> Project -> Project
mapCodeHostUrl change (Project addr meta currentContract) =
    Project addr { meta | codeHostUrl = change meta.codeHostUrl } currentContract


codeHostUrl : Project -> String
codeHostUrl (Project _ meta _) =
    meta.codeHostUrl


mapContract : (Contract -> Contract) -> Project -> Project
mapContract change (Project addr meta oldContract) =
    Project addr meta (change oldContract)


contract : Project -> Contract
contract (Project _ _ currentContract) =
    currentContract


mapDescription : (String -> String) -> Project -> Project
mapDescription change (Project addr meta currentContract) =
    Project addr { meta | description = change meta.description } currentContract


description : Project -> String
description (Project _ meta _) =
    meta.description


mapImageUrl : (String -> String) -> Project -> Project
mapImageUrl change (Project addr meta currentContract) =
    Project addr { meta | name = change meta.imageUrl } currentContract


imageUrl : Project -> String
imageUrl (Project _ meta _) =
    meta.imageUrl


mapName : (String -> String) -> Project -> Project
mapName change (Project addr meta currentContract) =
    Project addr { meta | name = change meta.name } currentContract


name : Project -> String
name (Project _ meta _) =
    meta.name


mapWebsiteUrl : (String -> String) -> Project -> Project
mapWebsiteUrl change (Project addr meta currentContract) =
    Project addr { meta | name = change meta.websiteUrl } currentContract


websiteUrl : Project -> String
websiteUrl (Project _ meta _) =
    meta.websiteUrl



-- ENCODING


encode : Project -> Encode.Value
encode (Project _ meta currentContract) =
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
