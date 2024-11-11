import React, { useState } from "react";
import { useParams, useNavigate } from "react-router-dom";
import { FontAwesomeIcon } from "@fortawesome/react-fontawesome";
import { faEye, faEyeSlash } from "@fortawesome/free-solid-svg-icons";
import { useTranslation } from "react-i18next";

const ResetPassword = () => {
  const { t } = useTranslation();
  const { uid, token } = useParams();
  const history = useNavigate();
  const [newPassword, setNewPassword] = useState("");
  const [confirmPassword, setConfirmPassword] = useState("");
  const [error, setError] = useState("");
  const [successMessage, setSuccessMessage] = useState("");
  const [showNewPassword, setShowNewPassword] = useState(false);
  const [showConfirmPassword, setShowConfirmPassword] = useState(false);

  const handleResetPassword = async () => {
    if (newPassword !== confirmPassword) {
      setError(t("resetPassword.passwordMismatch"));
      return;
    }

    try {
      const response = await fetch(
        "https://dev.aquaware.cloud/api/users/reset-password/",
        {
          method: "POST",
          headers: {
            "Content-Type": "application/json",
          },
          body: JSON.stringify({
            uid,
            token,
            new_password: newPassword,
          }),
        }
      );

      if (response.ok) {
        setSuccessMessage(t("resetPassword.successMessage"));
        setTimeout(() => {
          history("/login");
        }, 2000);
      } else {
        const data = await response.json();
        setError(data.error || t("resetPassword.errorMessage"));
      }
    } catch (err) {
      setError(t("resetPassword.genericError"));
    }
  };

  return (
    <div className="w-full h-screen flex flex-col items-center justify-center bg-n-8">
      <div className="w-full max-w-[400px] bg-white rounded-lg shadow-lg p-8">
        <h1 className="text-2xl font-bold text-center text-n-8 mb-6">
          {t("resetPassword.title")}
        </h1>

        {error && <p className="text-red-500 text-center mb-4">{error}</p>}
        {successMessage && (
          <p className="text-green-500 text-center mb-4">{successMessage}</p>
        )}

        <div className="relative">
          <input
            type={showNewPassword ? "text" : "password"}
            placeholder={t("resetPassword.newPasswordPlaceholder")}
            value={newPassword}
            onChange={(e) => setNewPassword(e.target.value)}
            className="w-full text-n-8 py-2 my-2 bg-transparent border-b border-gray-400 outline-none focus:border-blue-500"
          />
          <button
            type="button"
            className="absolute right-2 top-1/2 transform -translate-y-1/2"
            onClick={() => setShowNewPassword(!showNewPassword)}
          >
            {showNewPassword ? (
              <FontAwesomeIcon icon={faEyeSlash} className="mr-4 text-n-8" />
            ) : (
              <FontAwesomeIcon icon={faEye} className="mr-4 text-n-8" />
            )}
          </button>
        </div>

        <div className="relative">
          <input
            type={showConfirmPassword ? "text" : "password"}
            placeholder={t("resetPassword.confirmPasswordPlaceholder")}
            value={confirmPassword}
            onChange={(e) => setConfirmPassword(e.target.value)}
            className="w-full text-n-8 py-2 my-2 bg-transparent border-b border-gray-400 outline-none focus:border-blue-500"
          />
          <button
            type="button"
            className="absolute right-2 top-1/2 transform -translate-y-1/2"
            onClick={() => setShowConfirmPassword(!showConfirmPassword)}
          >
            {showConfirmPassword ? (
              <FontAwesomeIcon icon={faEyeSlash} className="mr-4 text-n-8" />
            ) : (
              <FontAwesomeIcon icon={faEye} className="mr-4 text-n-8" />
            )}
          </button>
        </div>

        <button
          onClick={handleResetPassword}
          className="w-full bg-blue-500 text-white font-semibold rounded-md py-3 mt-4 hover:bg-blue-600"
        >
          {t("resetPassword.resetButton")}
        </button>
      </div>
    </div>
  );
};

export default ResetPassword;
