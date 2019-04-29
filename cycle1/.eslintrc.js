module.exports = {
  env: {
    browser: true,
    es6: true,
    webextensions: true,
  },
  extends: 'eslint:recommended',
  parserOptions: {
    sourceType: 'module',
  },
  rules: {
    indent: ['error', 2],
    'linebreak-style': ['error', 'unix'],
    'no-console': 'off',
    quotes: ['error', 'single'],
    semi: ['error', 'never'],
  },
}
