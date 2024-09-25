import React, { useState, useEffect } from "react";
import AccountInfo from "./AccountInfo";
import EnvironmentInfo from "./EnvironmentInfo";
import PricingPlanInfo from "./PricingPlanInfo";
import Cookies from "js-cookie"; // Um die Cookies zu überprüfen
import { disablePageScroll, enablePageScroll } from "scroll-lock";
import { HamburgerMenu } from "../design/Header";
import MenuSvg from "../../assets/svg/MenuSvg";

const Dashboard = () => {
  const [activeTab, setActiveTab] = useState("account");
  const [menuOpen, setMenuOpen] = useState(false);
  const [isLoggedIn, setIsLoggedIn] = useState(false); // Zustand für Login-Überprüfung

  // Überprüfe, ob der Nutzer eingeloggt ist
  useEffect(() => {
    const refreshToken = Cookies.get("refresh_token");
    if (refreshToken) {
      setIsLoggedIn(true); // Wenn ein refresh_token vorhanden ist, ist der Nutzer eingeloggt
    } else {
      setIsLoggedIn(false);
    }
  }, []);

  const toggleNavigation = () => {
    if (menuOpen) {
      setMenuOpen(false);
      enablePageScroll();
    } else {
      setMenuOpen(true);
      disablePageScroll();
    }
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
    <div className="flex flex-col lg:flex-row h-screen bg-n-8">
      {/* Hamburger menu for mobile view */}
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
          <ul className="absolute top-16 left-0 w-full bg-n-8 shadow-lg p-6 z-50">
            <li
              className={`py-3 px-4 mb-2 text-n-1 rounded-lg cursor-pointer transition ${
                activeTab === "account" ? "bg-n-15 text-n-1" : "hover:bg-n-16"
              }`}
              onClick={() => {
                setActiveTab("account");
                setMenuOpen(false); // Close menu after selection
              }}
            >
              Account
            </li>
            <li
              className={`py-3 px-4 mb-2 text-n-1 rounded-lg cursor-pointer transition ${
                activeTab === "environments"
                  ? "bg-n-15 text-n-1"
                  : "hover:bg-n-16"
              }`}
              onClick={() => {
                setActiveTab("environments");
                setMenuOpen(false); // Close menu after selection
              }}
            >
              Environments
            </li>
            <li
              className={`py-3 px-4 mb-2 text-n-1 rounded-lg cursor-pointer transition ${
                activeTab === "pricingplans"
                  ? "bg-n-15 text-n-1"
                  : "hover:bg-n-16"
              }`}
              onClick={() => {
                setActiveTab("pricingplans");
                setMenuOpen(false); // Close menu after selection
              }}
            >
              Pricing Plans
            </li>
          </ul>
        )}
      </div>

      {/* Sidebar for desktop view */}
      <div className="hidden lg:block lg:w-1/4 shadow-lg p-6 rounded-l-lg flex flex-col items-center border-r-2 border-n-6">
        <div className="mb-6">
          <h3 className="mt-4 text-lg font-semibold text-n-1">Dashboard</h3>
        </div>
        <ul className="w-full">
          <li
            className={`py-3 px-4 mb-2 text-n-1 rounded-lg cursor-pointer transition ${
              activeTab === "account" ? "bg-n-15 text-n-1" : "hover:bg-n-16"
            }`}
            onClick={() => setActiveTab("account")}
          >
            Account
          </li>
          <li
            className={`py-3 px-4 mb-2 text-n-1 rounded-lg cursor-pointer transition ${
              activeTab === "password" ? "bg-n-15 text-n-1" : "hover:bg-n-16"
            }`}
            onClick={() => setActiveTab("password")}
          >
            Password
          </li>
          <li
            className={`py-3 px-4 mb-2 text-n-1 rounded-lg cursor-pointer transition ${
              activeTab === "environments"
                ? "bg-n-15 text-n-1"
                : "hover:bg-n-16"
            }`}
            onClick={() => setActiveTab("environments")}
          >
            Environments
          </li>
          <li
            className={`py-3 px-4 mb-2 text-n-1 rounded-lg cursor-pointer transition ${
              activeTab === "pricingplans"
                ? "bg-n-15 text-n-1"
                : "hover:bg-n-16"
            }`}
            onClick={() => setActiveTab("pricingplans")}
          >
            Pricing Plans
          </li>
        </ul>
      </div>

      {/* Content Area */}
      <div className="w-full lg:w-3/4 bg-n-8 shadow-lg rounded-r-lg p-8 flex justify-center">
        {renderTabContent()}
      </div>
    </div>
  );
};

export default Dashboard;
