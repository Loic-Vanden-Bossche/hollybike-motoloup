import tseslint from "typescript-eslint";
import stylistic from "@stylistic/eslint-plugin";
import unusedImports from "eslint-plugin-unused-imports";

export default [
  {
    ignores: ["dist/**", "node_modules/**"],
  },
  ...tseslint.configs.recommended,
  {
    rules: {
      "no-unused-vars": ["off"],
      "@typescript-eslint/no-unused-vars": ["error", { argsIgnorePattern: "^_" }],
      "arrow-body-style": ["error", "as-needed"],
      "curly": ["error", "all"],
      "no-undef-init": ["error"],
      "no-var": ["error"],
      "prefer-arrow-callback": ["error"],
      "prefer-const": ["error", { destructuring: "all" }],
      "prefer-destructuring": ["error"],
      "prefer-exponentiation-operator": ["error"],
      "prefer-numeric-literals": ["error"],
      "prefer-object-spread": ["error"],
      "prefer-template": ["error"],
      "eol-last": ["error"],
      "@typescript-eslint/no-explicit-any": ["off"]
    },
    files: ["src/**/*.{tsx,ts}"]
  },
  {
    plugins: {
      "@stylistic": stylistic,
    },
    rules: {
      "@stylistic/array-bracket-newline": ["error", {multiline: true, minItems: 3}],
      "@stylistic/array-element-newline": ["error", {multiline: true, minItems: 3}],
      "@stylistic/arrow-parens": ["error", "as-needed", {requireForBlockBody: true}],
      "@stylistic/arrow-spacing": ["error", {before: true, after: true}],
      "@stylistic/block-spacing": ["error", "always"],
      "@stylistic/brace-style": ["error", "1tbs", {allowSingleLine: true}],
      "@stylistic/comma-dangle": ["error", "always-multiline"],
      "@stylistic/comma-spacing": ["error", {before: false, after: true}],
      "@stylistic/comma-style": ["error", "last"],
      "@stylistic/computed-property-spacing": ["error", "never", {enforceForClassMembers: true}],
      "@stylistic/dot-location": ["error", "property"],
      "@stylistic/eol-last": ["error", "always"],
      "@stylistic/function-call-argument-newline": ["error", "consistent"],
      "@stylistic/function-call-spacing": ["error", "never"],
      "@stylistic/function-paren-newline": ["error", "multiline"],
      "@stylistic/generator-star-spacing": ["error", "before"],
      "@stylistic/indent": ["error", "tab"],
      "@stylistic/jsx-quotes": ["error", "prefer-double"],
      "@stylistic/key-spacing": ["error", {beforeColon: false, afterColon: true, mode: "strict",}],
      "@stylistic/keyword-spacing": ["error", {before: true, after: true}],
      "@stylistic/linebreak-style": ["error", "unix"],
      "@stylistic/no-extra-parens": ["error", "all"],
      "@stylistic/no-extra-semi": ["error"],
      "@stylistic/no-floating-decimal": ["error"],
      "@stylistic/no-multi-spaces": ["error"],
      "@stylistic/no-multiple-empty-lines": ["error"],
      "@stylistic/no-trailing-spaces": ["error"],
      "@stylistic/no-whitespace-before-property": ["error"],
      "@stylistic/object-curly-newline": ["error", {multiline: true, minProperties: 2}],
      "@stylistic/object-curly-spacing": ["error", "always", {objectsInObjects: false, arraysInObjects: false}],
      "@stylistic/object-property-newline": ["error"],
      "@stylistic/operator-linebreak": ["error", "after"],
      "@stylistic/padded-blocks": ["error", "never"],
      "@stylistic/quote-props": ["error", "as-needed"],
      "@stylistic/quotes": ["error", "double", {avoidEscape: true, allowTemplateLiterals: "always"}],
      "@stylistic/rest-spread-spacing": ["error", "never"],
      "@stylistic/semi": ["error", "always"],
      "@stylistic/semi-style": ["error", "last"],
      "@stylistic/space-before-blocks": ["error", "always"],
    },
    files: ["src/**/*.{tsx,ts}"],
  },
  {
    plugins: {
      "@stylistic": stylistic,
    },
    rules: {
      "@stylistic/jsx-closing-bracket-location": ["error", "line-aligned"],
      "@stylistic/jsx-closing-tag-location": ["error"],
      "@stylistic/jsx-curly-newline": ["error", "consistent"],
      "@stylistic/jsx-curly-spacing": ["error", {when: "always", children: true, allowMultiline: false, spacing: { objectLiterals: "never" }, attributes: false}],
      "@stylistic/jsx-first-prop-new-line": ["error", "multiline"],
      "@stylistic/jsx-wrap-multilines": ["off"]
    },
    files: ["src/**/*.tsx"],
  },
  {
    plugins: {
      "unused-imports": unusedImports,
    },
    rules: {
      "unused-imports/no-unused-imports": ["error"],
    },
    files: ["src/**/*.{tsx,ts}"],
  },
];
