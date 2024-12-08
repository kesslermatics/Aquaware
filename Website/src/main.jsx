import { StrictMode } from "react";
import { createRoot, hydrateRoot } from "react-dom/client";
import App from "./App.jsx";
import "./index.css";
import { BrowserRouter as Router } from "react-router-dom";
import { GoogleOAuthProvider } from "@react-oauth/google";
import "./i18n";

const rootElement = document.getElementById("root");

// Prüfe, ob bereits vorgerenderte (statische) Inhalte vorhanden sind.
// Wenn ja, dann "hydraten", ansonsten normal rendern.
if (rootElement && rootElement.hasChildNodes()) {
  hydrateRoot(
    rootElement,
    <StrictMode>
      <GoogleOAuthProvider clientId="191107134677-01dnm67luaua0bpalbkia3jucktqggoi.apps.googleusercontent.com">
        <Router>
          <App />
        </Router>
      </GoogleOAuthProvider>
    </StrictMode>
  );
} else {
  createRoot(rootElement).render(
    <StrictMode>
      <GoogleOAuthProvider clientId="191107134677-01dnm67luaua0bpalbkia3jucktqggoi.apps.googleusercontent.com">
        <Router>
          <App />
        </Router>
      </GoogleOAuthProvider>
    </StrictMode>
  );
}
