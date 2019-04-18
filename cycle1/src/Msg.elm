module Msg exposing (Msg(..))

import Browser
import Overlay.WalletSetup
import Page.KeyPairSetup
import Page.Register
import TopBar
import Url


type Msg
    = UrlChanged Url.Url
    | LinkClicked Browser.UrlRequest
    | OverlayWalletSetup Overlay.WalletSetup.Msg
    | PageKeyPairSetup Page.KeyPairSetup.Msg
    | PageRegister Page.Register.Msg
    | TopBarMsg TopBar.Msg
    | KeyPairCreated String
    | KeyPairFetched String
    | WalletWebExtPresent ()
