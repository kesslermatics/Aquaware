import { Route, Routes } from "react-router-dom";
import ButtonGradient from "./assets/svg/ButtonGradient";
import Benefits from "./components/Benefits";
import ApiInfo from "./components/ApiInfo";
import Footer from "./components/Footer";
import Header from "./components/Header";
import Hero from "./components/Hero";
import Pricing from "./components/Pricing";
import Services from "./components/Services";
import Docs from "./components/Docs";
import Login from "./components/Login";
import Signup from "./components/Signup";
import Dashboard from "./components/Dashboard/Dashboard";
import ForgotPassword from "./components/ForgotPassword";
import ResetPassword from "./components/ResetPassword";

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
                <Services />
                <Pricing />
              </>
            }
          />
          {/* Separate Routes */}
          <Route path="/hero" element={<Hero />} />
          <Route path="/benefits" element={<Benefits />} />
          <Route path="/api-info" element={<ApiInfo />} />
          <Route path="/services" element={<Services />} />
          <Route path="/pricing" element={<Pricing />} />
          <Route path="/signup" element={<Signup />} />
          <Route path="/login" element={<Login />} />
          <Route path="/dashboard" element={<Dashboard />} />
          <Route path="/forgot-password" element={<ForgotPassword />} />
          <Route path="/reset-password/:uid/:token" component={ResetPassword} />

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
