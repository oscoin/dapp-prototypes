# Rationale

To evaluate if TypeScript is a good option for our frontend needs, we decided
to write a small SPA. This SPA will consist of:

- a screen with a single button, which when clicked, launches a wizard
- the wizard opens as a modal and implements the ["new proposal" feature][0]


# Setup

```
yarn create react-app experiment-typescript --typescript
```

# Observations

- create-react-app has built-in support for TS
- compiles to clean JS
- Jest is [converting to TS][3] (good sign for industry adoption)
- nvim-typescript is sketchy, breaks down in splits
- trying out CoC to see if that's better
  `:CocInstall coc-tsserver coc-tslint-plugin`
- vim setup turned out not to work very well, decided not to invest time into
  figuring out a working configuration, switched to vs code for the evaluation
- compiler error messages are quite cryptic
- no built-in pattern matching in TypeScript, everything needs to be built
  manually via `switch` statements, which is quite some overhead
- pattern matching exhaustiveness needs to be built manually
- it's possible to build a MVP that has feature parity to Reason, but it
  ends up being a lot more verbose
- we would need more time to learn and evaluate the type system more thoroughly


[0]: https://www.figma.com/file/MZMZAb21rrKaRJbYlg0XF44X/osc-prototype?node-id=1798%3A0
[1]: https://www.robertcooper.me/get-started-with-typescript-in-2019
[3]: https://github.com/facebook/jest/pull/7554#issuecomment-454358729
