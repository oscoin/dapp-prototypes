module Msg exposing (Msg(..))

import Browser
import Page.KeyPairSetup
import TopBar
import Url


type Msg
    = UrlChanged Url.Url
    | LinkClicked Browser.UrlRequest
    | PageKeyPairSetup Page.KeyPairSetup.Msg
    | TopBarMsg TopBar.Msg
    | KeyPairCreated String
    | KeyPairFetched String
    | WalletWebExtPresent ()
