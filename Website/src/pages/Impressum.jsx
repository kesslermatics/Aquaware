import { useTranslation } from "next-i18next";

const Impressum = () => {
  const { t } = useTranslation();

  return (
    <div className="w-full min-h-screen py-10 px-5 flex flex-col items-center">
      <div className="max-w-4xl w-full p-8 rounded-lg">
        <h1 className="text-3xl font-bold mb-6">
          {t("impressum.title")}
        </h1>

        <p className="mb-4">
          <strong>{t("impressum.section5")}</strong>
        </p>

        <p className="mb-4">
          <strong>{t("impressum.provider")}</strong>
          <br />
          Robert Kessler <br />
          Richard Strauss Straße 85 <br />
          85057 Ingolstadt <br />
          Germany
        </p>

        <p className="mb-4">
          <strong>{t("impressum.contactInfo")}</strong>
          <br />
          Email:{" "}
          <a href="mailto:info@kesslermatics.com" className="text-blue-500">
            info@kesslermatics.com
          </a>
        </p>

        <p className="mb-4">
          <strong>{t("impressum.vatNumber")}</strong>
          <br />
          {t("impressum.vatText")}
          <br />
          DE360096261
        </p>

        <p className="mb-4">
          <strong>{t("impressum.businessForm")}</strong>
          <br />
          {t("impressum.soleProprietorship")}
        </p>

        <p className="mb-4">
          <strong>{t("impressum.website")}</strong>
          <br />
          <a href="https://aquaware.cloud" className="text-blue-500">
            aquaware.cloud
          </a>
        </p>

        <p className="mb-4">
          <strong>{t("impressum.disclaimer")}</strong>
          <br />
          {t("impressum.disclaimerText")}
        </p>

        <p className="mb-4">
          <strong>{t("impressum.terms")}</strong>
          <br />
          {t("impressum.termsText")}{" "}
          <a
            href="https://aquaware.cloud/terms-and-conditions"
            className="text-blue-500"
          >
            {t("impressum.termsLink")}
          </a>
        </p>

        <p className="mb-4">
          <strong>{t("impressum.privacy")}</strong>
          <br />
          {t("impressum.privacyText")}{" "}
          <a href="https://aquaware.cloud/privacy" className="text-blue-500">
            {t("impressum.privacyLink")}
          </a>
        </p>

        <p className="mt-6 text-sm text-gray-500">
          {t("impressum.notice")}
        </p>
      </div>
    </div>
  );
};

export default Impressum;
