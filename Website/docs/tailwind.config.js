/** @type {import('tailwindcss').Config} */
import { fontFamily } from "tailwindcss/defaultTheme";
import plugin from "tailwindcss/plugin";

export default {
  content: [
    "./index.html",
    "./src/**/*.{js,ts,jsx,tsx,html}",
    "./public/assets/**/*.{js,ts,jsx,tsx,html}",
  ],
  theme: {
    extend: {
      colors: {
        color: {
          1: "#352cd4",
          2: "#FFC876",
          3: "#FF776F",
          4: "#7ADB78",
          5: "#858DFF",
          6: "#27c421",
        },
        stroke: {
          1: "#07304f",
        },
        n: {
          1: "#FFFFFF", // Weiß
          2: "#CAC6DD", // Sehr helles Grau
          3: "#ADA8C3", // Helles Grau mit leichtem Violett-Stich
          4: "#757185", // Mittelgrau
          5: "#3F3A52", // Dunkles Grau mit einem leichten Blau-Stich
          6: "#07304f", // Sehr dunkles Grau *
          7: "#051521", // Fast Schwarz
          8: "#031726", // Sehr dunkles Schwarz
          9: "#474060", // Dunkles Grau mit Blau-Violett-Ton
          10: "#43435C", // Blau-Grau, etwas dunkler als 9
          11: "#1B1B2E", // Sehr dunkles Blau-Schwarz
          12: "#2E2A41", // Dunkles Blau-Grau
          13: "#6C7275", // Grau mit leichtem Blau-Grün-Ton
          14: "#031726", // Marineblau
        },
      },
      fontFamily: {
        sans: ["var(--font-sora)", ...fontFamily.sans],
        code: "var(--font-code)",
        grotesk: "var(--font-grotesk)",
      },
      letterSpacing: {
        tagline: ".15em",
      },
      spacing: {
        0.25: "0.0625rem",
        7.5: "1.875rem",
        15: "3.75rem",
      },
      opacity: {
        15: ".15",
      },
      transitionDuration: {
        DEFAULT: "200ms",
      },
      transitionTimingFunction: {
        DEFAULT: "linear",
      },
      zIndex: {
        1: "1",
        2: "2",
        3: "3",
        4: "4",
        5: "5",
      },
      borderWidth: {
        DEFAULT: "0.0625rem",
      },
    },
  },
};
