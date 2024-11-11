import React from "react";
import { useTranslation } from "react-i18next";

const TermsAndConditions = () => {
  const { t } = useTranslation();

  return (
    <div className="w-full max-w-4xl mx-auto p-6">
      <h1 className="text-3xl font-bold mb-4">{t("terms.title")}</h1>
      <p className="text-sm text-gray-500 mb-6">
        {t("terms.effectiveDate")}
      </p>

      <section className="mb-8">
        <h2 className="text-xl font-semibold mb-2">{t("terms.overview.title")}</h2>
        <p className="text-n-1">{t("terms.overview.text")}</p>
      </section>

      <section className="mb-8">
        <h2 className="text-xl font-semibold mb-2">{t("terms.subscription.title")}</h2>
        <p className="text-n-1">{t("terms.subscription.description")}</p>
        <ul className="list-disc ml-5 mt-2 text-n-1">
          <li>
            <strong>{t("terms.subscription.paymentMethod.title")}</strong>{" "}
            {t("terms.subscription.paymentMethod.text")}
          </li>
          <li>
            <strong>{t("terms.subscription.noRefunds.title")}</strong>{" "}
            {t("terms.subscription.noRefunds.text")}
          </li>
          <li>
            <strong>{t("terms.subscription.cancellation.title")}</strong>{" "}
            {t("terms.subscription.cancellation.text")}
          </li>
        </ul>
      </section>

      <section className="mb-8">
        <h2 className="text-xl font-semibold mb-2">{t("terms.documentation.title")}</h2>
        <p className="text-n-1">
          {t("terms.documentation.text")}{" "}
          <a href="https://aquaware.cloud/docs/index.html" className="text-blue-500">
            {t("terms.documentation.linkText")}
          </a>
          .
        </p>
      </section>

      <section className="mb-8">
        <h2 className="text-xl font-semibold mb-2">{t("terms.userData.title")}</h2>
        <p className="text-n-1">
          <strong>{t("terms.userData.accountCreation.title")}</strong>{" "}
          {t("terms.userData.accountCreation.text")}
        </p>
        <p className="text-n-1">
          <strong>{t("terms.userData.dataAnonymization.title")}</strong>{" "}
          {t("terms.userData.dataAnonymization.text")}
        </p>
        <p className="text-n-1">
          {t("terms.userData.moreDetails")}{" "}
          <a href="https://aquaware.cloud/privacy" className="text-blue-500">
            {t("terms.userData.privacyLink")}
          </a>
          .
        </p>
      </section>

      <section className="mb-8">
        <h2 className="text-xl font-semibold mb-2">{t("terms.thirdPartyLogin.title")}</h2>
        <p className="text-n-1">{t("terms.thirdPartyLogin.text")}</p>
        <p className="text-n-1">
          {t("terms.thirdPartyLogin.cookieInfo")}{" "}
          <a href="https://aquaware.cloud/privacy" className="text-blue-500">
            {t("terms.thirdPartyLogin.cookieLinkText")}
          </a>
          .
        </p>
      </section>

      <footer className="mt-10">
        <p className="text-n-1">
          {t("terms.contactUs")}{" "}
          <a href="mailto:info@kesslermatics.com" className="text-blue-500">
            info@kesslermatics.com
          </a>
          .
        </p>
      </footer>
    </div>
  );
};

export default TermsAndConditions;
