import React from "react";
import { Route, Routes, useLocation } from "react-router-dom";
import { Helmet } from "react-helmet";
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
import { useTranslation } from "react-i18next";
import PricingPlanInfo from "./components/Dashboard/PricingPlanInfo";
import ComparePlans from "./components/ComparePlans";
import Section from "./components/Section";
import TailoredTool from "./components/TailoredTool";
import AquawareApp from "./components/AquawareApp";
import CookieConsent from "react-cookie-consent";

const App = () => {
  const { t } = useTranslation();
  const location = useLocation();

  // Dynamische Metadaten basierend auf der Route
  const getMetaData = (path) => {
    switch (path) {
      case "/":
        return {
          title: t("seo.home.title"),
          description: t("seo.home.description"),
        };
      case "/hero":
        return {
          title: t("seo.hero.title"),
          description: t("seo.hero.description"),
        };
      case "/benefits":
        return {
          title: t("seo.benefits.title"),
          description: t("seo.benefits.description"),
        };
      case "/api-info":
        return {
          title: t("seo.apiInfo.title"),
          description: t("seo.apiInfo.description"),
        };
      case "/signup":
        return {
          title: t("seo.signup.title"),
          description: t("seo.signup.description"),
        };
      case "/login":
        return {
          title: t("seo.login.title"),
          description: t("seo.login.description"),
        };
      case "/dashboard":
        return {
          title: t("seo.dashboard.title"),
          description: t("seo.dashboard.description"),
        };
      case "/impressum":
        return {
          title: t("seo.impressum.title"),
          description: t("seo.impressum.description"),
        };
      case "/privacy":
        return {
          title: t("seo.privacy.title"),
          description: t("seo.privacy.description"),
        };
      case "/terms-and-conditions":
        return {
          title: t("seo.terms.title"),
          description: t("seo.terms.description"),
        };
      case "/success":
        return {
          title: t("seo.success.title"),
          description: t("seo.success.description"),
        };
      default:
        return {
          title: t("seo.default.title"),
          description: t("seo.default.description"),
        };
    }
  };

  const { title } = getMetaData(location.pathname);

  const schemaData = {
    "@context": "https://schema.org",
    "@type": "SoftwareApplication",
    name: "Aquaware",
    description:
      "Monitor and analyze water quality effortlessly with Aquaware – your all-in-one solution for aquarium and water environment insights.",
    applicationCategory: "Utility",
    operatingSystem: "All",
    softwareVersion: "1.2.3",
    url: "https://www.aquaware.cloud/",
    image: "https://www.aquaware.cloud/assets/aquaware.png",
    offers: {
      "@type": "Offer",
      price: "0.00",
      priceCurrency: "EUR",
      availability: "https://schema.org/InStock",
      url: "https://www.aquaware.cloud/#pricing",
    },
    aggregateRating: {
      "@type": "AggregateRating",
      ratingValue: "4.8",
      ratingCount: "128",
    },
    publisher: {
      "@type": "Organization",
      name: "Kesslermatics",
      url: "https://kesslermatics.com/",
      logo: "https://kesslermatics.com/assets/kesslermaticsLogoTransparent-UDeASpjR.png",
    },
  };

  return (
    <>
      <Helmet>
        <title>{title}</title>
        <link rel="canonical" href="https://www.aquaware.cloud/" />
        <meta
          property="og:title"
          content="Aquaware – Monitor and Analyze Your Water Quality"
        />
        <meta
          property="og:description"
          content="Easily monitor and analyze water quality to ensure a healthy environment for your aquatic life. Aquaware simplifies tracking essential parameters, giving you insights and control."
        />
        <meta property="og:type" content="website" />
        <meta property="og:url" content="https://www.aquaware.cloud/" />
        <meta
          property="og:image"
          content="https://www.aquaware.cloud/assets/aquaware.png"
        />
        <meta property="og:site_name" content="Aquaware" />
        <meta property="og:locale" content="en_US" />
        <script type="application/ld+json">{JSON.stringify(schemaData)}</script>
      </Helmet>

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
                <AquawareApp />
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
                <Helmet>
                  <title>{t("seo.404.title")}</title>
                  <meta name="description" content={t("seo.404.description")} />
                </Helmet>
                <h1>{t("app.404.title")}</h1>
                <p>{t("app.404.message")}</p>
              </div>
            }
          />

          <Route path="/docs/*" element={<Docs />} />
        </Routes>
        <Footer />
        <CookieConsent
          location="bottom"
          style={{ background: "#07304F", fontSize: "17px" }}
          buttonStyle={{
            background: "#031726",
            color: "#FFFFFF",
            fontSize: "17px",
            borderRadius: "8px",
            padding: "10px 20px",
          }}
          buttonText={t("cookieConsent.buttonText")}
        >
          {t("cookieConsent.message")}
        </CookieConsent>
      </div>
      <ButtonGradient />
    </>
  );
};

export default App;
