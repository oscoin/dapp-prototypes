# experiment-reason

## Log

* following ReasonReact
  [example](https://reasonml.github.io/reason-react/docs/en/installation)
* ran `bsb -init experiment-reason -theme react-hooks`
* tooling a bit more involved: `yarn start` + `yarn server` in parallel
* compiles real fast for small code bases
* has builtin router with clean API -> pattern-matching !!!
* strings in jsx are awkward
* OCaml has naming conventions which prevent `-`, there are workarounds
* ReasonReact explicitly prevents props spread for performance reasons
  * they use callbacks for it
  * gives clear ownership
* ContextProvider works like normal React
* no Mixins, fucntion composition instead
* callback declaration can be a bit unwiedly at times
* calling out and interfacing with raw JS is simple and safe
* following and applying React exampels (e.g. Portal) is doable without much
  overhead
* no visual API docs for ReasonReact, one has to read .rei files
* for unicode use special string syntax: `{js|...|js}`
* encountered runtime exception on match failure - there was a compiler
  warning. Maybe this can be bubbled up as error during compile time
* namespacing with modules is clean

## Run Project

```sh
npm install
npm start
# in another tab
npm run webpack
```

After you see the webpack compilation succeed (the `npm run webpack` step), open up `build/index.html` (**no server needed!**). Then modify whichever `.re` file in `src` and refresh the page to see the changes.

**For more elaborate ReasonReact examples**, please see https://github.com/reasonml-community/reason-react-example

## Run Project with Server

To run with the webpack development server run `npm run server` and view in the browser at http://localhost:8000. Running in this environment provides hot reloading and support for routing; just edit and save the file and the browser will automatically refresh.

Note that any hot reload on a route will fall back to the root (`/`), so `ReasonReact.Router.dangerouslyGetInitialUrl` will likely be needed alongside the `ReasonReact.Router.watchUrl` logic to handle routing correctly on hot reload refreshes or simply opening the app at a URL that is not the root.

To use a port other than 8000 set the `PORT` environment variable (`PORT=8080 npm run server`).

## Build for Production

```sh
npm run clean
npm run build
npm run webpack:production
```

This will replace the development artifact `build/Index.js` for an optimized version as well as copy `src/index.html` into `build/`. You can then deploy the contents of the `build` directory (`index.html` and `Index.js`).

If you make use of routing (via `ReasonReact.Router` or similar logic) ensure that server-side routing handles your routes or that 404's are directed back to `index.html` (which is how the dev server is set up).

**To enable dead code elimination**, change `bsconfig.json`'s `package-specs` `module` from `"commonjs"` to `"es6"`. Then re-run the above 2 commands. This will allow Webpack to remove unused code.
