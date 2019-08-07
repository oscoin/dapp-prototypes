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


[0]: https://www.figma.com/file/MZMZAb21rrKaRJbYlg0XF44X/osc-prototype?node-id=1798%3A0
[1]: https://www.robertcooper.me/get-started-with-typescript-in-2019
[3]: https://github.com/facebook/jest/pull/7554#issuecomment-454358729
