# Rationale

To evaluate if clojurescript is a good option for our frontend needs,
we decided to write a small SPA. This SPA will consist of:

- a screen with a single button, which when clicked, launches a wizard
- the wizard opens as a modal and implements the ["new proposal" feature][2]


# Setup

Following the official [shadow-cljs][1] documentation.

```
npx create-cljs-project experiment-clojurescript  # init project
npx shadow-cljs watch frontend                    # start webserver
npx shadow-cljs node-repl                         # show REPL
```

Once the server is started, you can see the app in a browser via:
http://localhost:8080/


[1]: https://github.com/thheller/shadow-cljs
[2]: https://www.figma.com/file/MZMZAb21rrKaRJbYlg0XF44X/osc-prototype?node-id=1798%3A0
