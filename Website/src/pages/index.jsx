import Head from 'next/head';
import Hero from '../components/Hero';
import Benefits from '../components/Benefits';
import ApiInfo from '../components/ApiInfo';
import Pricing from '../components/Pricing';
import ComparePlans from '../components/ComparePlans';
import TailoredTool from '../components/TailoredTool';
import AquawareApp from '../components/AquawareApp';
import { useTranslation } from 'next-i18next';
import { serverSideTranslations } from 'next-i18next/serverSideTranslations';
import nextI18NextConfig from '../../next-i18next.config.js';

const HomePage = () => {
  const { t } = useTranslation();

  return (
    <>
      <Head>
        <title>{t('seo.home.title', 'Home')}</title>
        <meta
          name="description"
          content={t(
            'seo.home.description',
            'Easily monitor and analyze water quality efficiently.'
          )}
        />
      </Head>
      <Hero />
      <Benefits />
      <ApiInfo />
      <Pricing />
      <ComparePlans />
      <AquawareApp />
      <TailoredTool />
    </>
  );
};

// Load translations server-side
export async function getStaticProps({ locale }) {
    return {
      props: {
        ...(await serverSideTranslations(locale, ['translation'], nextI18NextConfig)), // Specify "translation"
      },
    };
  }

export default HomePage;
