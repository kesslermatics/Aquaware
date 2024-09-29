import React from "react";

const Privacy = () => {
  return (
    <div className="w-full max-w-4xl mx-auto p-6">
      <h1 className="text-3xl font-bold mb-4">Privacy Policy</h1>
      <p className="text-sm text-gray-500 mb-6">
        Effective Date: September 2024
      </p>

      <section className="mb-8">
        <h2 className="text-xl font-semibold mb-2">1. Introduction</h2>
        <p className="text-n-1">
          At Aquaware, we are committed to protecting your privacy and ensuring
          that your personal data is handled with care. This privacy policy
          outlines how we collect, store, and use your information.
        </p>
      </section>

      <section className="mb-8">
        <h2 className="text-xl font-semibold mb-2">
          2. Information We Collect
        </h2>
        <p className="text-n-1">
          We collect the following types of personal information:
        </p>
        <ul className="list-disc ml-5 mt-2 text-n-1">
          <li>
            <strong>Personal Information:</strong> When creating an account, we
            collect your email, first name, last name, and password.
          </li>
          <li>
            <strong>Water Data:</strong> Water quality data such as temperature,
            pH, and other parameters are stored and used within the service.
          </li>
          <li>
            <strong>Cookies:</strong> We use cookies to manage session tokens
            and remember your login status. Cookies are stored securely and
            contain no sensitive information.
          </li>
        </ul>
      </section>

      <section className="mb-8">
        <h2 className="text-xl font-semibold mb-2">
          3. How We Use Your Information
        </h2>
        <p className="text-n-1">
          Your personal data is used for the following purposes:
        </p>
        <ul className="list-disc ml-5 mt-2 text-n-1">
          <li>To manage your account and provide our services.</li>
          <li>
            To monitor water data and provide analytics through the platform.
          </li>
          <li>
            To ensure secure login using hashed passwords and session cookies.
          </li>
          <li>
            To communicate with you regarding updates or changes to the service.
          </li>
        </ul>
      </section>

      <section className="mb-8">
        <h2 className="text-xl font-semibold mb-2">
          4. Third-Party Login & Cookies
        </h2>
        <p className="text-n-1">
          We offer login via Google. If you choose to log in using Google, we
          only access your basic profile information and email to create and
          manage your account.
        </p>
        <p className="text-n-1">
          We use cookies to store session tokens. These cookies help us
          authenticate users and ensure that your session remains active. They
          are stored securely and automatically expire when you log out or after
          a set period.
        </p>
      </section>

      <section className="mb-8">
        <h2 className="text-xl font-semibold mb-2">
          5. Data Retention & Deletion
        </h2>
        <p className="text-n-1">
          We retain your personal data for as long as your account is active.
          Upon deletion of your account, all personal data will be permanently
          deleted, and water data will be anonymized and unlinked from your
          account.
        </p>
        <p className="text-n-1">
          You can request data deletion or account termination at any time by
          contacting us at{" "}
          <a href="mailto:info@kesslermatics.com" className="text-blue-500">
            info@kesslermatics.com
          </a>
          .
        </p>
      </section>

      <section className="mb-8">
        <h2 className="text-xl font-semibold mb-2">6. Data Security</h2>
        <p className="text-n-1">
          We implement industry-standard security measures to protect your data.
          Passwords are hashed, and sensitive information is encrypted. Access
          to user data is restricted to authorized personnel only.
        </p>
      </section>

      <section className="mb-8">
        <h2 className="text-xl font-semibold mb-2">
          7. Changes to This Policy
        </h2>
        <p className="text-n-1">
          We reserve the right to update this privacy policy as needed to
          reflect changes in our service or legal requirements. Any significant
          updates will be communicated to you via email or within the platform.
        </p>
      </section>

      <footer className="mt-10">
        <p className="text-n-1">
          If you have any questions or concerns about our privacy policy, please
          contact us at{" "}
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
