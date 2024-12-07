import PropTypes from 'prop-types'; // Import for PropTypes validation
import CookieConsent from 'react-cookie-consent'; // For cookie consent
import { GoogleOAuthProvider } from "@react-oauth/google";
import Header from '../components/Header'; // Import Header
import Footer from '../components/Footer'; // Import Footer
import '../i18n'; // Import i18n configuration for translations
import { appWithTranslation } from 'next-i18next'

const MyApp = ({ Component, pageProps }) => {
  return (
    <GoogleOAuthProvider clientId="191107134677-01dnm67luaua0bpalbkia3jucktqggoi.apps.googleusercontent.com">
      <Header />
      <main>
        <Component {...pageProps} />
      </main>
      <CookieConsent
        location="bottom"
        style={{ background: "#07304F", fontSize: "17px" }}
        buttonStyle={{
          background: "#031726",
          color: "#FFFFFF",
          fontSize: "17px",
          borderRadius: "8px",
          padding: "10px 20px",
        }}
        buttonText="Accept" // Replace translation for simplicity
      >
        We use cookies to enhance your experience. {/* Replace translation */}
      </CookieConsent>
      <Footer />
    </GoogleOAuthProvider>
  );
};

// Define PropTypes for validation
MyApp.propTypes = {
  Component: PropTypes.elementType.isRequired, // Ensure Component is a valid React element
  pageProps: PropTypes.object, // pageProps can be any object
};

// Default props (optional if you don't use additional defaults)
MyApp.defaultProps = {
  pageProps: {}, // Default pageProps to an empty object
};

export default appWithTranslation(MyApp);
