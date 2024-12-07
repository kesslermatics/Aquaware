import path from 'path';

const nextI18NextConfig = {
  i18n: {
    locales: ['en', 'de'], // Supported locales
    defaultLocale: 'en',   // Default language
    localeDetection: true,
  },
  interpolation: {
    escapeValue: false, // React already escapes by default
  },
};

export default nextI18NextConfig;
