import React from "react";
import Section from "./Section";
import { useTranslation } from "react-i18next";

const Footer = () => {
  const { t } = useTranslation();
  const currentYear = new Date().getFullYear();

  return (
    <Section crosses className="!px-0 !py-10">
      <div className="container flex justify-between items-center gap-10 max-sm:flex-col">
        <p className="caption text-n-4">
          © {new Date().getFullYear()}. {t("footer.copyright")}
        </p>
        <div className="flex gap-5 ml-auto">
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
        </div>
      </div>
    </Section>
  );
};

export default Footer;
