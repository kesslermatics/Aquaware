import React, { useState, useEffect } from "react";
import { useNavigate, useLocation } from "react-router-dom"; // React Router v6 Hooks für die Navigation
import AccountInfo from "./AccountInfo";
import EnvironmentInfo from "./EnvironmentInfo";
import PricingPlanInfo from "./PricingPlanInfo";
import Cookies from "js-cookie";
import MenuSvg from "../../assets/svg/MenuSvg";

const Dashboard = () => {
  const [activeTab, setActiveTab] = useState("account");
  const [menuOpen, setMenuOpen] = useState(false);
  const navigate = useNavigate(); // Hook für Navigation
  const location = useLocation(); // Hook für den Zugriff auf den aktuellen Standort (URL)

  useEffect(() => {
    const refreshToken = Cookies.get("refresh_token");
    if (!refreshToken) {
      navigate("/login"); // Umleitung zu /login, wenn kein Token
    }
  }, [navigate]);

  // Listen for changes in the URL hash to update the active tab
  useEffect(() => {
    const hash = location.hash.replace("#", ""); // Entferne das '#' und erhalte nur den Tab-Namen
    if (hash) {
      setActiveTab(hash);
    }
  }, [location]);

  const toggleNavigation = () => {
    setMenuOpen(!menuOpen);
  };

  const handleTabChange = (tab) => {
    setActiveTab(tab);
    navigate(`/dashboard#${tab}`); // Update the URL hash when the tab changes
    setMenuOpen(false); // Close the menu after changing the tab
  };

  const renderTabContent = () => {
    switch (activeTab) {
      case "account":
        return <AccountInfo />;
      case "environments":
        return <EnvironmentInfo />;
      case "pricingplans":
        return <PricingPlanInfo />;
      default:
        return <AccountInfo />;
    }
  };

  return (
    <div className="flex flex-col lg:flex-row min-h-screen bg-n-8">
      <div className="lg:hidden">
        <div className="flex items-center justify-between pt-5 pb-2 pl-5 border-b border-n-6 bg-n-8">
          <h3 className="text-lg font-semibold text-n-1">Dashboard</h3>
          <button
            onClick={toggleNavigation}
            className="p-4 text-n-1 hover:text-n-6"
          >
            <MenuSvg openNavigation={menuOpen} />
          </button>
        </div>
        {menuOpen && (
          <ul className="absolute top-16 left-0 w-full bg-n-8 p-6 z-50">
            <li
              className={`py-3 px-4 mb-2 text-n-1 rounded-lg cursor-pointer transition ${
                activeTab === "account" ? "bg-n-6 text-n-1" : "hover:bg-n-6"
              }`}
              onClick={() => handleTabChange("account")}
            >
              Account
            </li>
            <li
              className={`py-3 px-4 mb-2 text-n-1 rounded-lg cursor-pointer transition ${
                activeTab === "environments"
                  ? "bg-n-6 text-n-1"
                  : "hover:bg-n-6"
              }`}
              onClick={() => handleTabChange("environments")}
            >
              Environments
            </li>
            <li
              className={`py-3 px-4 mb-2 text-n-1 rounded-lg cursor-pointer transition ${
                activeTab === "pricingplans"
                  ? "bg-n-6 text-n-1"
                  : "hover:bg-n-6"
              }`}
              onClick={() => handleTabChange("pricingplans")}
            >
              Pricing Plans
            </li>
          </ul>
        )}
      </div>

      <div className="hidden lg:block lg:w-1/4 p-6 rounded-l-lg flex flex-col items-center border-r-2 border-n-6">
        <div className="mb-6">
          <h3 className="mt-4 text-lg font-semibold text-n-1">Dashboard</h3>
        </div>
        <ul className="w-full">
          <li
            className={`py-3 px-4 mb-2 text-n-1 rounded-lg cursor-pointer transition ${
              activeTab === "account" ? "bg-n-6 text-n-1" : "hover:bg-n-6"
            }`}
            onClick={() => handleTabChange("account")}
          >
            Account
          </li>
          <li
            className={`py-3 px-4 mb-2 text-n-1 rounded-lg cursor-pointer transition ${
              activeTab === "environments" ? "bg-n-6 text-n-1" : "hover:bg-n-6"
            }`}
            onClick={() => handleTabChange("environments")}
          >
            Environments
          </li>
          <li
            className={`py-3 px-4 mb-2 text-n-1 rounded-lg cursor-pointer transition ${
              activeTab === "pricingplans" ? "bg-n-6 text-n-1" : "hover:bg-n-6"
            }`}
            onClick={() => handleTabChange("pricingplans")}
          >
            Pricing Plans
          </li>
        </ul>
      </div>

      <div className="w-full lg:w-3/4 bg-n-8 rounded-r-lg p-8">
        {renderTabContent()}
      </div>
    </div>
  );
};

export default Dashboard;
