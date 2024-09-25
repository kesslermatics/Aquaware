import React, { useState } from "react";
import AccountInfo from "./AccountInfo";
import PasswordInfo from "./PasswordInfo";
import EnvironmentInfo from "./EnvironmentInfo";
import PricingPlanInfo from "./PricingPlanInfo";

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
      <div className="w-3/4 bg-n-8 shadow-lg rounded-r-lg p-8">
        {renderTabContent()} {/* Content based on the selected tab */}
      </div>
    </div>
  );
};

export default Dashboard;
