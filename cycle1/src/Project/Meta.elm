module Project.Meta exposing
    ( Meta
    , codeHostUrl
    , description
    , empty
    , encode
    , imageUrl
    , mapCodeHostUrl
    , mapDescription
    , mapImageUrl
    , mapName
    , mapWebsiteUrl
    , name
    , websiteUrl
    )

import Json.Encode as Encode


type alias Meta =
    { codeHostUrl : String
    , description : String
    , imageUrl : String
    , name : String
    , websiteUrl : String
    }


empty : Meta
empty =
    { codeHostUrl = ""
    , description = ""
    , imageUrl = ""
    , name = ""
    , websiteUrl = ""
    }


mapCodeHostUrl : (String -> String) -> Meta -> Meta
mapCodeHostUrl change meta =
    { meta | codeHostUrl = change meta.codeHostUrl }


codeHostUrl : Meta -> String
codeHostUrl meta =
    meta.codeHostUrl


mapDescription : (String -> String) -> Meta -> Meta
mapDescription change meta =
    { meta | description = change meta.description }


description : Meta -> String
description meta =
    meta.description


mapImageUrl : (String -> String) -> Meta -> Meta
mapImageUrl change meta =
    { meta | name = change meta.imageUrl }


imageUrl : Meta -> String
imageUrl meta =
    meta.imageUrl


mapName : (String -> String) -> Meta -> Meta
mapName change meta =
    { meta | name = change meta.name }


name : Meta -> String
name meta =
    meta.name


mapWebsiteUrl : (String -> String) -> Meta -> Meta
mapWebsiteUrl change meta =
    { meta | name = change meta.websiteUrl }


websiteUrl : Meta -> String
websiteUrl meta =
    meta.websiteUrl



-- ENCODING


encode : Meta -> Encode.Value
encode meta =
    Encode.object
        [ ( "codeHostUrl", Encode.string meta.codeHostUrl )
        , ( "description", Encode.string meta.description )
        , ( "imageUrl", Encode.string meta.imageUrl )
        , ( "name", Encode.string meta.name )
        , ( "websiteUrl", Encode.string meta.websiteUrl )
        ]
