# Cycle One Prototype

The goal of the first prototype is to focus on how OSS projects interested in
oscoin will be able to explore and interact with the network. We are limiting
the scope to one type of user, meaning we're looking at the different intents
that user type might have and how they then will interact with the network. We
will have time exploring other types of users and advanced interactions in
later iterations.

## Run

It is advised to use [elm-live](https://github.com/wking-io/elm-live) for
development, which can be used as such:

```
elm-live src/Main.elm --dir public/ --pushstate -- --debug --output public/scripts/main.js
```

To run and test the web extension install
[web-ext](https://github.com/mozilla/web-ext) and run the following command:

```
cd public/
web-ext run --verbose -u localhost:8000 --bc
```

This should open up an instance of Firefox with the wallet extension installed.
To have the contents of the popup windows re-build automatically on changes
run this:

```
elm-live src/WalletPopup.elm --start-page wallet-popup.html --dir public/ --port 8001 --pushstate -- --debug --output public/scripts/wallet-popup.js
```
