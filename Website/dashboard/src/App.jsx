import React, { useEffect } from "react";
import { Route, Routes, useNavigate, useLocation } from "react-router-dom";
import Dashboard from "./components/Dashboard";
import AccountInfo from "./components/AccountInfo";
import EnvironmentInfo from "./components/EnvironmentInfo";
import PricingPlanInfo from "./components/PricingPlanInfo";
import Login from "./components/Login";
import Signup from "./components/Signup";
import Cookies from "js-cookie";
import Header from "./components/Header";
import Success from "./components/Success";
import { useTranslation } from "react-i18next";

const App = () => {
  const navigate = useNavigate();
  const location = useLocation();
  const { i18n } = useTranslation();

  useEffect(() => {
    const publicRoutes = ["/login", "/signup"];
    const apiKey = Cookies.get("api_key");

    const savedLanguage = Cookies.get("language");
    if (!savedLanguage) {
      const systemLanguage = navigator.language.split("-")[0];
      const supportedLanguages = ["en", "de"]; 
      const defaultLanguage = supportedLanguages.includes(systemLanguage)
        ? systemLanguage
        : "en"; 

      i18n.changeLanguage(defaultLanguage); 
      Cookies.set("language", defaultLanguage, { secure: true }); 
    } else {
      i18n.changeLanguage(savedLanguage);
    }

    if (!apiKey && !publicRoutes.includes(location.pathname)) {
      navigate("/login");
    }
  }, [navigate, location, i18n]);

  // Check if the current route is a public route
  const isPublicRoute = ["/login", "/signup"].includes(location.pathname);

  return (
    <div className="min-h-screen bg-n-8">
      {/* Show Header only for non-public routes */}
      {!isPublicRoute && <Header />}
      <Routes>
        {/* Protected Routes */}
        <Route path="/" element={<Dashboard />} />
        <Route path="/account" element={<AccountInfo />} />
        <Route path="/environments" element={<EnvironmentInfo />} />
        <Route path="/pricingplans" element={<PricingPlanInfo />} />
        {/* Public Routes */}
        <Route path="/login" element={<Login />} />
        <Route path="/signup" element={<Signup />} />
        <Route path="/success" element={<Success />} />
      </Routes>
    </div>
  );
};

export default App;
