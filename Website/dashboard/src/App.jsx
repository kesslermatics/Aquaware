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

const App = () => {
  const navigate = useNavigate();
  const location = useLocation();

  useEffect(() => {
    const publicRoutes = ["/login", "/signup"];
    const refreshToken = Cookies.get("refresh_token");

    if (!refreshToken && !publicRoutes.includes(location.pathname)) {
      navigate("/login");
    }
  }, [navigate, location]);

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
