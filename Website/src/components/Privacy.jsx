import React from "react";
import { useTranslation } from "react-i18next";

const Privacy = () => {
  const { t } = useTranslation();

  return (
    <div className="w-full max-w-4xl mx-auto p-6">
      <h1 className="text-3xl font-bold mb-4">{t("privacy.title")}</h1>
      <p className="text-sm text-gray-500 mb-6">{t("privacy.effectiveDate")}</p>

      <section className="mb-8">
        <h2 className="text-xl font-semibold mb-2">{t("privacy.introduction.title")}</h2>
        <p className="text-n-1">{t("privacy.introduction.text")}</p>
      </section>

      <section className="mb-8">
        <h2 className="text-xl font-semibold mb-2">{t("privacy.infoWeCollect.title")}</h2>
        <p className="text-n-1">{t("privacy.infoWeCollect.description")}</p>
        <ul className="list-disc ml-5 mt-2 text-n-1">
          <li>
            <strong>{t("privacy.infoWeCollect.personalInfo.title")}</strong>{" "}
            {t("privacy.infoWeCollect.personalInfo.text")}
          </li>
          <li>
            <strong>{t("privacy.infoWeCollect.waterData.title")}</strong>{" "}
            {t("privacy.infoWeCollect.waterData.text")}
          </li>
          <li>
            <strong>{t("privacy.infoWeCollect.cookies.title")}</strong>{" "}
            {t("privacy.infoWeCollect.cookies.text")}
          </li>
        </ul>
      </section>

      <section className="mb-8">
        <h2 className="text-xl font-semibold mb-2">{t("privacy.useOfInfo.title")}</h2>
        <p className="text-n-1">{t("privacy.useOfInfo.description")}</p>
        <ul className="list-disc ml-5 mt-2 text-n-1">
          <li>{t("privacy.useOfInfo.purpose1")}</li>
          <li>{t("privacy.useOfInfo.purpose2")}</li>
          <li>{t("privacy.useOfInfo.purpose3")}</li>
          <li>{t("privacy.useOfInfo.purpose4")}</li>
        </ul>
      </section>

      <section className="mb-8">
        <h2 className="text-xl font-semibold mb-2">{t("privacy.thirdParty.title")}</h2>
        <p className="text-n-1">{t("privacy.thirdParty.googleLogin")}</p>
        <p className="text-n-1">{t("privacy.thirdParty.cookiesUsage")}</p>
      </section>

      <section className="mb-8">
        <h2 className="text-xl font-semibold mb-2">{t("privacy.dataRetention.title")}</h2>
        <p className="text-n-1">{t("privacy.dataRetention.text1")}</p>
        <p className="text-n-1">
          {t("privacy.dataRetention.text2")}{" "}
          <a href="mailto:info@kesslermatics.com" className="text-blue-500">
            info@kesslermatics.com
          </a>
          .
        </p>
      </section>

      <section className="mb-8">
        <h2 className="text-xl font-semibold mb-2">{t("privacy.dataSecurity.title")}</h2>
        <p className="text-n-1">{t("privacy.dataSecurity.text")}</p>
      </section>

      <section className="mb-8">
        <h2 className="text-xl font-semibold mb-2">{t("privacy.policyChanges.title")}</h2>
        <p className="text-n-1">{t("privacy.policyChanges.text")}</p>
      </section>

      <footer className="mt-10">
        <p className="text-n-1">
          {t("privacy.contactUs")}{" "}
          <a href="mailto:info@kesslermatics.com" className="text-blue-500">
            info@kesslermatics.com
          </a>
          .
        </p>
      </footer>
    </div>
  );
};

export default Privacy;
