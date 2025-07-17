import js from "@eslint/js";
import prettier from "eslint-config-prettier";
import simpleImportSort from "eslint-plugin-simple-import-sort";
import unicorn from "eslint-plugin-unicorn";
import ts from "typescript-eslint";

export default ts.config(
  {
    ignores: ["**/dist/", "**/node_modules/"],
  },

  {
    extends: [js.configs.recommended, ...ts.configs.strictTypeChecked, unicorn.configs.recommended, prettier],
    files: ["**/*.ts", "**/*.tsx"],
    languageOptions: {
      parserOptions: {
        project: true,
        projectService: true,
        tsconfigRootDir: import.meta.dirname,
        sourceType: "module",
      },
    },
    plugins: {
      "simple-import-sort": simpleImportSort,
    },
    rules: {
      "simple-import-sort/imports": "error",
      "simple-import-sort/exports": "error",
      "unicorn/filename-case": [
        "error",
        {
          cases: {
            camelCase: true,
            pascalCase: true,
          },
        },
      ],
    },
  },

  {
    extends: [js.configs.recommended, unicorn.configs.recommended],
    files: ["**/*.js", "**/*.cjs"],
    plugins: {
      "simple-import-sort": simpleImportSort,
    },
    rules: {
      "simple-import-sort/imports": "error",
      "simple-import-sort/exports": "error",

      "unicorn/filename-case": [
        "error",
        {
          cases: {
            camelCase: true,
            pascalCase: true,
          },
        },
      ],
    },
  },
  {
    files: ["**/*.d.ts"],
    rules: {
      "unicorn/filename-case": "off",
      "unicorn/prevent-abbreviations": "off",
    },
  },
);
