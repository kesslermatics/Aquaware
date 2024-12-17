import React from "react";
import Section from "./Section";
import { useTranslation } from "react-i18next";

const Footer = () => {
  const { t, i18n } = useTranslation();
  const currentYear = new Date().getFullYear();

  const handleLanguageChange = (event) => {
    i18n.changeLanguage(event.target.value);
  };

  return (
    <Section crosses className="!px-0 !py-10">
      <div className="container flex justify-between items-center gap-10 max-sm:flex-col">
        <p className="caption text-n-4">
          © {currentYear}. {t("footer.copyright")}
        </p>
        <div className="flex gap-5 items-center ml-auto">
          <a
            href="/impressum"
            className="text-n-4 text-sm hover:text-n-1 transition-colors"
          >
            {t("footer.links.impressum")}
          </a>
          <a
            href="/privacy"
            className="text-n-4 text-sm hover:text-n-1 transition-colors"
          >
            {t("footer.links.privacy")}
          </a>
          <a
            href="/terms-and-conditions"
            className="text-n-4 text-sm hover:text-n-1 transition-colors"
          >
            {t("footer.links.termsAndConditions")}
          </a>
          <select
            onChange={handleLanguageChange}
            value={i18n.language}
            className="text-n-4 text-sm hover:text-n-1 transition-colors border-b border-n-4 focus:outline-none"
            style={{
              background: "#07304F",
              color: "#FFFFFF",
              borderRadius: "4px",
              padding: "4px 8px",
            }}
          >
            <option value="en">English</option>
            <option value="de">Deutsch</option>
          </select>
        </div>
      </div>
    </Section>
  );
};

export default Footer;
