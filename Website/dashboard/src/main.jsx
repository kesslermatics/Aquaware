import React from "react";
import { StrictMode } from "react";
import { createRoot, hydrateRoot } from "react-dom/client";
import App from "./App.jsx";
import "./index.css";
import { BrowserRouter as Router } from "react-router-dom";
import { GoogleOAuthProvider } from "@react-oauth/google";
import "./i18n";

const rootElement = document.getElementById("root");

if (rootElement && rootElement.hasChildNodes()) {
  hydrateRoot(
    rootElement,
      <GoogleOAuthProvider clientId="191107134677-01dnm67luaua0bpalbkia3jucktqggoi.apps.googleusercontent.com">
        <Router>
          <App />
        </Router>
      </GoogleOAuthProvider>
  );
} else {
  createRoot(rootElement).render(
      <GoogleOAuthProvider clientId="191107134677-01dnm67luaua0bpalbkia3jucktqggoi.apps.googleusercontent.com">
        <Router>
          <App />
        </Router>
      </GoogleOAuthProvider>
  );
}
