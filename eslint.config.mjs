import { FlatCompat } from "@eslint/eslintrc";
import js from "@eslint/js";
import gitlabPlugin from "@gitlab/eslint-plugin";
import eslintPluginPrettier from "eslint-plugin-prettier";
import globals from "globals";
import path from "node:path";
import { fileURLToPath } from "node:url";

const __filename = fileURLToPath(import.meta.url);
const __dirname = path.dirname(__filename);
const compat = new FlatCompat({
  baseDirectory: __dirname,
  recommendedConfig: js.configs.recommended,
  allConfig: js.configs.all,
});

export default [
  // Étend la configuration recommandée d'ESLint
  ...compat.extends("eslint:recommended"),

  {
    plugins: {
      prettier: eslintPluginPrettier,
      "@gitlab": gitlabPlugin,
    },

    languageOptions: {
      globals: {
        ...globals.browser,
        ...globals.commonjs,
      },

      ecmaVersion: "latest",
      sourceType: "module",
    },

    ignores: [
      "node_modules/",
      "dist/",
      "build/",
      "package-lock.json",
      "package.json",
      "eslint.config.mjs",
      "prettier.config.cjs", // Ajout pour éviter les conflits
      "**/*.yml",
      "**/*.yaml",
    ],

    rules: {
      "no-console": "warn",
      "no-unused-vars": "warn",
      "no-undef": "error",
      "no-loop-func": "error",
      "consistent-return": "error",
      "promise/catch-or-return": "off",
      "@gitlab/vue-no-data-toggle": "off",
      "@gitlab/vue-prefer-dollar-scopedslots": "off",
      "@gitlab/no-runtime-template-compiler": "off",
      "@gitlab/no-absolute-urls": "off",
      "prettier/prettier": "error", // Exécute Prettier via ESLint
    },
  },
];
