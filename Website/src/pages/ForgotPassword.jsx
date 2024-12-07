import { useState } from "react";
import { useTranslation } from "next-i18next";

const ForgotPassword = () => {
  const { t } = useTranslation();
  const [email, setEmail] = useState(""); // State for the email input
  const [message, setMessage] = useState(""); // State for success messages
  const [error, setError] = useState(""); // State for error messages

  const handleForgotPassword = async () => {
    try {
      const response = await fetch(
        "https://dev.aquaware.cloud/api/users/forgot-password/",
        {
          method: "POST",
          headers: {
            "Content-Type": "application/json",
          },
          body: JSON.stringify({ email }),
          credentials: "include",
        }
      );

      if (response.ok) {
        // Handle success
        setMessage(t("forgotPassword.successMessage"));
        setError("");
      } else {
        // Handle server errors
        const data = await response.json();
        setError(data.error || t("forgotPassword.errorMessage"));
        setMessage("");
      }
    } catch {
      // Handle network or other request failures
      setError(t("forgotPassword.requestFailed"));
      setMessage("");
    }
  };

  return (
    <div className="w-full h-screen flex flex-col items-center justify-center bg-n-8">
      <div className="w-full max-w-[400px] bg-n-1 rounded-lg shadow-lg p-8">
        <h1 className="text-2xl font-bold text-center text-n-8 mb-6">
          {t("forgotPassword.title")}
        </h1>
        <p className="text-base text-center text-n-8 mb-6">
          {t("forgotPassword.description")}
        </p>

        {/* Display success message */}
        {message && <p className="text-green-500 text-center mb-4">{message}</p>}

        {/* Display error message */}
        {error && <p className="text-red-500 text-center mb-4">{error}</p>}

        <input
          type="email"
          placeholder={t("forgotPassword.emailPlaceholder")}
          value={email}
          onChange={(e) => setEmail(e.target.value)}
          className="w-full text-n-8 py-2 my-2 bg-transparent border-b border-gray-400 outline-none focus:border-blue-500"
        />

        <button
          onClick={handleForgotPassword}
          className="w-full bg-blue-500 text-white font-semibold rounded-md py-3 mt-4 hover:bg-blue-600"
        >
          {t("forgotPassword.sendButton")}
        </button>
      </div>
    </div>
  );
};

export default ForgotPassword;
