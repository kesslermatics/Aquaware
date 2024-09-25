import React, { useState } from "react";
import AccountInfo from "./AccountInfo";
import EnvironmentInfo from "./EnvironmentInfo";
import PricingPlanInfo from "./PricingPlanInfo";
import Cookies from "js-cookie"; // Import Cookies for token management

const Dashboard = () => {
  const [activeTab, setActiveTab] = useState("account");

  const renderTabContent = () => {
    switch (activeTab) {
      case "account":
        return <AccountInfo />;
      case "password":
        return <PasswordInfo />;
      case "environments":
        return <EnvironmentInfo />;
      case "pricingplans":
        return <PricingPlanInfo />;
      default:
        return <AccountInfo />;
    }
  };

  // Logout function that removes the tokens and redirects to homepage
  const handleLogout = () => {
    Cookies.remove("access_token");
    Cookies.remove("refresh_token");
    window.location.href = "/"; // Redirect to homepage after logout
  };

  return (
    <div className="flex h-screen bg-n-8">
      {/* Sidebar */}
      <div className="w-1/4 shadow-lg p-6 rounded-l-lg flex flex-col items-center border-r-2 border-n-6">
        {/* User Profile Section */}
        <div className="mb-6">
          <h3 className="mt-4 text-lg font-semibold text-n-1">Dashboard</h3>
        </div>
        {/* Navigation Menu */}
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

        {/* Logout Button */}
        <button
          className="mt-8 bg-red-500 text-white px-4 py-2 rounded-lg hover:bg-red-600"
          onClick={handleLogout}
        >
          Logout
        </button>
      </div>

      {/* Content Area */}
      <div className="w-3/4 bg-n-8 shadow-lg rounded-r-lg p-8">
        {renderTabContent()} {/* Content based on the selected tab */}
      </div>
    </div>
  );
};

export default Dashboard;
