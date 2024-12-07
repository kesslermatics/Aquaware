import Section from "./Section";
import { useTranslation } from 'react-i18next';

const AquawareApp = () => {
  const { t } = useTranslation();

  return (
    <Section
      className="pt-[12rem] -mt-[5.25rem]"
      crosses
      crossesOffset="lg:translate-y-[5.25rem]"
      customPaddings
      id="hero"
    >
      <div className="flex flex-col items-center justify-center p-4" id="app">
        <h1 className="text-4xl font-bold mb-4">{t("aquawareApp.title")}</h1>
        <p className="text-lg text-center mb-8">
          {t("aquawareApp.description")}
        </p>
        <a
          href="https://play.google.com/store/apps/details?id=kesslermatics.aquaware"
          className="mb-20"
        >
          <img
            src="https://play.google.com/intl/de/badges/static/images/badges/de_badge_web_generic.png"
            alt={t("aquawareApp.downloadAlt")}
            className="w-48 h-auto"
          />
        </a>
      </div>
    </Section>
  );
};

export default AquawareApp;
