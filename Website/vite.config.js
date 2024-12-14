import { defineConfig } from "vite";
import legacy from "@vitejs/plugin-legacy";
import react from "@vitejs/plugin-react";

export default defineConfig({
  // works on both development and production build environments
  esbuild: {
    // configure this value when the browser version of the development environment is lower
    // minimum support es2015
    // https://esbuild.github.io/api/#target
    target: "es2015",
    include: /\.(ts|jsx|tsx)$/,
  },
  // for production build environments only
  build: {
    // minimum support es2015
    target: "es2015",
  },
  plugins: [
    react(),
    // for production build environments only
    legacy({
      // to be compatible with legacy browsers
      targets: ["ie >= 11"],
      // generate legacy browser's chunks
      renderLegacyChunks: true,
      /**
       * auto detect
       */
      modernPolyfills: true,
      /**
       * or add manually, for examples
       */
      // for legacy browsers only
      // polyfills: ['es/global-this', 'es/array/includes'],
      // for modern browsers only
      // modernPolyfills: ['es/global-this'],
    }),
    // Custom plugin to load markdown files
    {
      name: "markdown-loader",
      transform(code, id) {
        if (id.endsWith(".md")) {
          // For .md files, get the raw content
          return `export default ${JSON.stringify(code)};`;
        }
      },
    },
  ],
});
