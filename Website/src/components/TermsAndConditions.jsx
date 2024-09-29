import React from "react";

const TermsAndConditions = () => {
  return (
    <div className="w-full max-w-4xl mx-auto p-6">
      <h1 className="text-3xl font-bold mb-4">Terms and Conditions</h1>
      <p className="text-sm text-gray-500 mb-6">
        Effective Date: September 2024
      </p>

      <section className="mb-8">
        <h2 className="text-xl font-semibold mb-2">1. Overview</h2>
        <p className="text-n-1">
          Aquaware is a Software-as-a-Service (SaaS) platform offering water
          monitoring and analysis tools. By using Aquaware, you agree to the
          terms outlined below.
        </p>
      </section>

      <section className="mb-8">
        <h2 className="text-xl font-semibold mb-2">
          2. Subscription and Payments
        </h2>
        <p className="text-n-1">
          Aquaware operates on a monthly subscription model. Payments are
          processed through PayPal.
        </p>
        <ul className="list-disc ml-5 mt-2 text-n-1">
          <li>
            <strong>Payment Method:</strong> Subscriptions are charged monthly
            via PayPal.
          </li>
          <li>
            <strong>No Refunds:</strong> Once payment is made, no refunds will
            be provided.
          </li>
          <li>
            <strong>Cancellation:</strong> Cancellation will take effect at the
            end of the current billing cycle.
          </li>
        </ul>
      </section>

      <section className="mb-8">
        <h2 className="text-xl font-semibold mb-2">3. Documentation</h2>
        <p className="text-n-1">
          All functionalities and instructions for using the service are
          documented and accessible via our{" "}
          <a
            href="https://aquaware.cloud/docs/index.html"
            className="text-blue-500"
          >
            Documentation
          </a>
          .
        </p>
      </section>

      <section className="mb-8">
        <h2 className="text-xl font-semibold mb-2">4. User Data & Privacy</h2>
        <p className="text-n-1">
          <strong>Account Creation:</strong> User data, including email and
          password, is securely stored. Passwords are hashed and protected
          according to industry standards.
        </p>
        <p className="text-n-1">
          <strong>Data Anonymization on Deletion:</strong> Upon account
          deletion, personal data is removed, and water data is anonymized.
        </p>
        <p className="text-n-1">
          For more details, refer to our{" "}
          <a href="https://aquaware.cloud/privacy" className="text-blue-500">
            Privacy Policy
          </a>
          .
        </p>
      </section>

      <section className="mb-8">
        <h2 className="text-xl font-semibold mb-2">5. Third-Party Login</h2>
        <p className="text-n-1">
          Aquaware provides the option to log in using Google. Cookies will be
          set to manage authentication tokens.
        </p>
        <p className="text-n-1">
          For more information on cookies, review our{" "}
          <a href="https://aquaware.cloud/privacy" className="text-blue-500">
            Cookie Policy
          </a>
          .
        </p>
      </section>

      <footer className="mt-10">
        <p className="text-n-1">
          For additional questions, contact us at{" "}
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
