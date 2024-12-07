import { useState, useEffect } from "react";
import { useNavigate, useLocation } from "react-router-dom";
import AccountInfo from "../components/Dashboard/AccountInfo";
import PricingPlanInfo from "../components/Dashboard/PricingPlanInfo";
import Cookies from "js-cookie";
import MenuSvg from "../assets/svg/MenuSvg";
import { useTranslation } from "next-i18next";

const Dashboard = () => {
  const { t } = useTranslation();
  const [activeTab, setActiveTab] = useState("account");
  const [menuOpen, setMenuOpen] = useState(false);
  const navigate = useNavigate();
  const location = useLocation();

  useEffect(() => {
    const refreshToken = Cookies.get("refresh_token");
    if (!refreshToken) {
      navigate("/login");
    }
  }, [navigate]);

  useEffect(() => {
    const hash = location.hash.replace("#", "");
    if (hash) {
      setActiveTab(hash);
    }
  }, [location]);

  const toggleNavigation = () => {
    setMenuOpen(!menuOpen);
  };

  const handleTabChange = (tab) => {
    setActiveTab(tab);
    navigate(`/dashboard#${tab}`);
    setMenuOpen(false);
  };

  const renderTabContent = () => {
    switch (activeTab) {
      case "account":
        return <AccountInfo />;
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
          <h3 className="text-lg font-semibold text-n-1">{t("dashboard.title")}</h3>
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
              {t("dashboard.tabs.account")}
            </li>
            <li
              className={`py-3 px-4 mb-2 text-n-1 rounded-lg cursor-pointer transition ${
                activeTab === "pricingplans" ? "bg-n-6 text-n-1" : "hover:bg-n-6"
              }`}
              onClick={() => handleTabChange("pricingplans")}
            >
              {t("dashboard.tabs.pricingPlans")}
            </li>
          </ul>
        )}
      </div>

      <div className="hidden lg:block lg:w-1/4 p-6 rounded-l-lg flex flex-col items-center border-r-2 border-n-6">
        <div className="mb-6">
          <h3 className="mt-4 text-lg font-semibold text-n-1">{t("dashboard.title")}</h3>
        </div>
        <ul className="w-full">
          <li
            className={`py-3 px-4 mb-2 text-n-1 rounded-lg cursor-pointer transition ${
              activeTab === "account" ? "bg-n-6 text-n-1" : "hover:bg-n-6"
            }`}
            onClick={() => handleTabChange("account")}
          >
            {t("dashboard.tabs.account")}
          </li>
          <li
            className={`py-3 px-4 mb-2 text-n-1 rounded-lg cursor-pointer transition ${
              activeTab === "pricingplans" ? "bg-n-6 text-n-1" : "hover:bg-n-6"
            }`}
            onClick={() => handleTabChange("pricingplans")}
          >
            {t("dashboard.tabs.pricingPlans")}
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
