# Rationale

To evaluate if clojurescript is a good option for our frontend needs,
we decided to write a small SPA. This SPA will consist of:

- a screen with a single button, which when clicked, launches a wizard
- the wizard opens as a modal and implements the ["new proposal" feature][0]

Further documentation can be found [here][4] and [here][5].


# Setup
Install [Leiningen][1].

```
lein new figwheel experiment-clojurescript -- --reagent
```

Following [this][2] tutorial.

```
cd experiment-clojurescript
lein figwheel                     # launch "watchman"
```

Open your browser at [localhost:3449](http://localhost:3449/).

This will auto compile and send all changes to the browser without the
need to reload. After the compilation process is complete, you will
get a Browser Connected REPL. An easy way to try it is:

    (js/alert "Am I connected?")

and you should see an alert in the browser window.

To clean all compiled files:

    lein clean

To create a production build run:

    lein do clean, cljsbuild once min

And open your browser in `resources/public/index.html`. You will not
get live reloading, nor a REPL.


# Observations

- entry-point for documentation was confusing, shadow-cljs GitHub project page
  turned out to be the definitive source

- output JS kinda ugly, but according to Jelle can be switched to something
  more [readable][3]


# Outcome

Xla and I decided to stop looking at CLJS because most team members strongly
gravitate towards pure JS + Typescript + React, besides cloudhead dislikes CLJS.


[0]: https://www.figma.com/file/MZMZAb21rrKaRJbYlg0XF44X/osc-prototype?node-id=1798%3A0
[1]: https://leiningen.org/
[2]: https://www.youtube.com/watch?v=R07s6JpJICo
[3]: https://github.com/clojure/clojurescript-site/blob/master/content/reference/compiler-options.adoc#optimizations
[4]: https://medium.com/@jacekschae/learn-how-to-build-functional-front-ends-with-clojurescript-and-react-733fa260dd6b
[5]: https://reagent-project.github.io/
