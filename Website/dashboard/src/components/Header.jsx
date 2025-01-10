import React, { useEffect } from "react";
import { NavLink } from "react-router-dom";
import { useTranslation } from "react-i18next";
import aquawareLogo from "@/assets/aquaware.png"; // Pfad zum Logo

const Header = () => {
  const { t, i18n } = useTranslation();

  const changeLanguage = (lang) => {
    i18n.changeLanguage(lang);
  };

  return (
    <header className="flex justify-between items-center p-4 bg-n-6 text-n-1">
      <div className="flex items-center space-x-4">
        <NavLink to="/" className="flex items-center space-x-2">
          <img src={aquawareLogo} alt="Aquaware Logo" className="w-8 h-8" />
          <span className="text-2xl font-bold">Aquaware</span>
        </NavLink>
      </div>
      <nav className="flex space-x-4">
        <NavLink
          to="/"
          end
          className={({ isActive }) =>
            `px-4 py-2 rounded ${
              isActive ? "bg-n-17 text-white" : "hover:bg-n-15"
            }`
          }
        >
          {t("header.home")}
        </NavLink>
        <NavLink
          to="/account"
          className={({ isActive }) =>
            `px-4 py-2 rounded ${
              isActive ? "bg-n-17 text-white" : "hover:bg-n-15"
            }`
          }
        >
          {t("header.accountInfo")}
        </NavLink>
        <NavLink
          to="/environments"
          className={({ isActive }) =>
            `px-4 py-2 rounded ${
              isActive ? "bg-n-17 text-white" : "hover:bg-n-15"
            }`
          }
        >
          {t("header.environmentInfo")}
        </NavLink>
        <NavLink
          to="/pricingplans"
          className={({ isActive }) =>
            `px-4 py-2 rounded ${
              isActive ? "bg-n-17 text-white" : "hover:bg-n-15"
            }`
          }
        >
          {t("header.pricingPlans")}
        </NavLink>
        <select
          className="px-2 py-1 border rounded bg-n-17 text-n-1"
          onChange={(e) => changeLanguage(e.target.value)}
          value={i18n.language}
        >
          <option value="en">English</option>
          <option value="de">Deutsch</option>
          {/* Weitere Sprachen hier hinzufügen */}
        </select>
      </nav>
    </header>
  );
};

export default Header;
