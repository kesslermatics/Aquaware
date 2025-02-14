import React, { useState, useEffect } from "react";
import { NavLink, useNavigate } from "react-router-dom";
import { useTranslation } from "react-i18next";
import Cookies from "js-cookie";
import { FiLogOut, FiMenu, FiX } from "react-icons/fi";
import aquawareLogo from "@/assets/aquaware.png";

const Header = () => {
  const { t, i18n } = useTranslation();
  const navigate = useNavigate();
  const [menuOpen, setMenuOpen] = useState(false);
  const [selectedLanguage, setSelectedLanguage] = useState("en"); // Default language

  // Load the saved language from cookies or set it based on system language
  useEffect(() => {
    const savedLanguage = Cookies.get("language"); // Check if a language is saved in cookies

    if (savedLanguage) {
      i18n.changeLanguage(savedLanguage);
      setSelectedLanguage(savedLanguage);
    } else {
      const systemLanguage = navigator.language.split("-")[0]; // Get system language (e.g., "de" or "en")
      const supportedLanguages = ["en", "de"]; // Supported languages
      const defaultLanguage = supportedLanguages.includes(systemLanguage)
        ? systemLanguage
        : "en"; // Default to English if not supported

      i18n.changeLanguage(defaultLanguage);
      setSelectedLanguage(defaultLanguage);
      Cookies.set("language", defaultLanguage, { secure: true }); // Save the selected language in cookies
    }
  }, [i18n]);

  // Handle language change and update cookies
  const changeLanguage = (lang) => {
    i18n.changeLanguage(lang);
    setSelectedLanguage(lang);
    Cookies.set("language", lang, { secure: true });
  };

  // Handle user logout
  const handleLogout = () => {
    Cookies.remove("api_key");
    navigate("/login");
  };

  return (
    <header className="bg-n-6 text-n-1 p-4">
      <div className="flex justify-between items-center">
        {/* Logo */}
        <div className="flex items-center space-x-4">
          <NavLink to="/" className="flex items-center space-x-2">
            <img src={aquawareLogo} alt="Aquaware Logo" className="w-8 h-8" />
            <span className="text-2xl font-bold">Aquaware</span>
          </NavLink>
        </div>

        {/* Hamburger menu button (visible only on small screens) */}
        <button
          className="lg:hidden text-white"
          onClick={() => setMenuOpen(!menuOpen)}
        >
          {menuOpen ? <FiX size={24} /> : <FiMenu size={24} />}
        </button>

        {/* Navigation (visible on larger screens) */}
        <nav className="hidden lg:flex items-center space-x-4">
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

          {/* Language selection */}
          <select
            className="px-2 py-1 border rounded bg-n-17 text-n-1"
            onChange={(e) => changeLanguage(e.target.value)}
            value={selectedLanguage}
          >
            <option value="en">English</option>
            <option value="de">Deutsch</option>
          </select>

          {/* Logout icon */}
          <button
            onClick={handleLogout}
            className="text-red-600 hover:text-red-800 p-2 rounded-full"
          >
            <FiLogOut size={24} />
          </button>
        </nav>
      </div>

      {/* Mobile navigation menu (only visible when menuOpen is true) */}
      {menuOpen && (
        <div className="lg:hidden mt-4 space-y-2 flex flex-col items-center bg-n-7 p-4 rounded-lg">
          <NavLink
            to="/"
            end
            className="block w-full text-center py-2 hover:bg-n-15 rounded"
            onClick={() => setMenuOpen(false)}
          >
            {t("header.home")}
          </NavLink>
          <NavLink
            to="/account"
            className="block w-full text-center py-2 hover:bg-n-15 rounded"
            onClick={() => setMenuOpen(false)}
          >
            {t("header.accountInfo")}
          </NavLink>
          <NavLink
            to="/environments"
            className="block w-full text-center py-2 hover:bg-n-15 rounded"
            onClick={() => setMenuOpen(false)}
          >
            {t("header.environmentInfo")}
          </NavLink>
          <NavLink
            to="/pricingplans"
            className="block w-full text-center py-2 hover:bg-n-15 rounded"
            onClick={() => setMenuOpen(false)}
          >
            {t("header.pricingPlans")}
          </NavLink>

          {/* Language selection */}
          <select
            className="px-2 py-1 border rounded bg-n-17 text-n-1 w-full text-center"
            onChange={(e) => changeLanguage(e.target.value)}
            value={selectedLanguage}
          >
            <option value="en">English</option>
            <option value="de">Deutsch</option>
          </select>

          {/* Logout icon */}
          <button
            onClick={handleLogout}
            className="text-red-600 hover:text-red-800 p-2 rounded-full"
          >
            <FiLogOut size={24} />
          </button>
        </div>
      )}
    </header>
  );
};

export default Header;
