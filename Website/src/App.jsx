import { Route, Routes } from "react-router-dom";
import ButtonGradient from "./assets/svg/ButtonGradient";
import Benefits from "./components/Benefits";
import ApiInfo from "./components/ApiInfo";
import Footer from "./components/Footer";
import Header from "./components/Header";
import Hero from "./components/Hero";
import Docs from "./components/Docs";
import Login from "./components/Login";
import Signup from "./components/Signup";
import Dashboard from "./components/Dashboard/Dashboard";
import ForgotPassword from "./components/ForgotPassword";
import ResetPassword from "./components/ResetPassword";
import Impressum from "./components/Impressum";
import Privacy from "./components/Privacy";
import Success from "./components/Success";
import Pricing from "./components/Pricing";
import TermsAndConditions from "./components/TermsAndConditions";
import { useEffect } from "react";
import PricingPlanInfo from "./components/Dashboard/PricingPlanInfo";
import ComparePlans from "./components/ComparePlans";
import Section from "./components/Section";
import TailoredTool from "./components/TailoredTool";

const App = () => {
  return (
    <>
      <Header />
      <div className="pt-[4.75rem] lg:pt-[5.25rem] overflow-hidden">
        <Routes>
          {/* Home Route */}
          <Route
            path="/"
            element={
              <>
                <Hero />
                <Benefits />
                <ApiInfo />
                <Pricing />
                <Section>
                  <ComparePlans />
                </Section>
                <TailoredTool />
              </>
            }
          />
          {/* Separate Routes */}
          <Route path="/hero" element={<Hero />} />
          <Route path="/benefits" element={<Benefits />} />
          <Route path="/api-info" element={<ApiInfo />} />
          <Route path="/signup" element={<Signup />} />
          <Route path="/login" element={<Login />} />
          <Route path="/dashboard" element={<Dashboard />} />
          <Route path="/forgot-password" element={<ForgotPassword />} />
          <Route
            path="/reset-password/:uid/:token"
            element={<ResetPassword />}
          />
          <Route path="/impressum" element={<Impressum />} />
          <Route path="/privacy" element={<Privacy />} />
          <Route
            path="/terms-and-conditions"
            element={<TermsAndConditions />}
          />
          <Route path="/success" element={<Success />} />

          {/* 404 Not Found */}
          <Route
            path="*"
            element={
              <div className="text-center">
                <h1>404 - Page Not Found</h1>
              </div>
            }
          />

          <Route path="/docs/*" element={<Docs />} />
        </Routes>
        <Footer />
      </div>
      <ButtonGradient />
    </>
  );
};

export default App;
