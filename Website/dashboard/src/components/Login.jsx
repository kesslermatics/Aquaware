import { useState } from "react";
import { GoogleLogin } from "@react-oauth/google";
import Cookies from "js-cookie";
import backgroundVideo from "../assets/bg-aquarium2.mp4";
import { FontAwesomeIcon } from "@fortawesome/react-fontawesome";
import { faEye, faEyeSlash } from "@fortawesome/free-solid-svg-icons";
import { useTranslation } from "react-i18next";
import React from "react";
import { FaSpinner } from "react-icons/fa";

const Login = () => {
  const { t } = useTranslation();
  const [email, setEmail] = useState("");
  const [password, setPassword] = useState("");
  const [showPassword, setShowPassword] = useState(false);
  const [error, setError] = useState("");
  const [isLoadingLogin, setIsLoadingLogin] = useState(false);

  const handleLogin = async () => {
    setIsLoadingLogin(true);
    try {
      const response = await fetch(
        "https://dev.aquaware.cloud/api/users/auth/login/",
        {
          method: "POST",
          headers: {
            "Content-Type": "application/json",
          },
          body: JSON.stringify({
            email: email,
            password: password,
          }),
          credentials: "include",
        }
      );

      const data = await response.json();

      if (response.ok) {
        Cookies.set("api_key", data.api_key);
        window.location.href = "/";
      } else {
        setError(t("login.invalidCredentials"));
      }
    } catch (error) {
      setError(t("login.loginFailed"));
    } finally {
      setIsLoadingLogin(false);
    }
  };

  const handleGoogleLogin = async (tokenResponse) => {
    setIsLoadingLogin(true);
    try {
      const token = tokenResponse.credential;

      const response = await fetch(
        "https://dev.aquaware.cloud/api/users/auth/login/google/",
        {
          method: "POST",
          headers: {
            "Content-Type": "application/json",
          },
          body: JSON.stringify({
            token: token,
          }),
          credentials: "include",
        }
      );

      const data = await response.json();

      if (response.ok) {
        Cookies.set("api_key", data.api_key);
        window.location.href = "/";
      } else {
        setError(data.error || t("login.googleLoginFailed"));
      }
    } catch (error) {
      setError(t("login.googleLoginFailed"));
    } finally {
      setIsLoadingLogin(false);
    }
  };

  return (
    <div className="w-full h-screen flex flex-col items-center justify-center bg-n-8">
      <video
        autoPlay
        loop
        muted
        className="absolute left-0 w-full h-full object-cover opacity-10 z-1"
      >
        <source src={backgroundVideo} type="video/mp4" />
        {t("login.videoNotSupported")}
      </video>
      <div className="w-full max-w-[500px] bg-n-1 rounded-lg shadow-lg p-8 z-2">
        <h1 className="text-3xl font-bold text-center text-n-8 mb-6">
          {t("login.title")}
        </h1>

        {error && <p className="text-red-500 text-center mb-4">{error}</p>}

        <div className="w-full flex flex-col mb-4">
          <p className="text-base text-center mb-4 text-n-8">
            {t("login.welcomeMessage")}
          </p>
          <input
            type="email"
            placeholder={t("login.emailPlaceholder")}
            value={email}
            onChange={(e) => setEmail(e.target.value)}
            className="w-full text-n-8 py-2 my-2 bg-transparent border-b border-gray-400 outline-none focus:border-blue-500"
          />
          <div className="relative">
            <input
              type={showPassword ? "text" : "password"}
              placeholder={t("login.passwordPlaceholder")}
              value={password}
              onChange={(e) => setPassword(e.target.value)}
              className="w-full text-n-8 py-2 my-2 bg-transparent border-b border-gray-400 outline-none focus:border-blue-500"
            />
            <button
              type="button"
              className="absolute right-2 top-1/2 transform -translate-y-1/2"
              onClick={() => setShowPassword(!showPassword)}
            >
              {showPassword ? (
                <FontAwesomeIcon icon={faEyeSlash} className="mr-4 text-n-8" />
              ) : (
                <FontAwesomeIcon icon={faEye} className="mr-4 text-n-8" />
              )}
            </button>
          </div>
          <div className="text-right mt-2">
            <a href="/forgot-password" className="text-blue-500 font-semibold">
              {t("login.forgotPassword")}
            </a>
          </div>
        </div>

        <button
          onClick={handleLogin}
          disabled={isLoadingLogin}
          className={`w-full bg-n-15 text-white font-semibold rounded-md py-3 mb-4 ${
            isLoadingLogin ? "opacity-50 cursor-not-allowed" : ""
          }`}
        >
          {isLoadingLogin ? (
            <FaSpinner className="animate-spin text-center mx-auto text-2xl text-n-1" />
          ) : (
            t("login.loginButton")
          )}
        </button>

        <div className="w-full flex items-center justify-center text-n-8 font-semibold rounded-md py-3 mb-6">
          <GoogleLogin
            onSuccess={handleGoogleLogin}
            onError={() => setError(t("login.googleLoginFailed"))}
            useOneTap
          />
        </div>

        <p className="text-center text-sm text-gray-600 mt-6">
          {t("login.noAccount")}{" "}
          <a
            className="text-blue-500 font-semibold cursor-pointer"
            href="/signup"
          >
            {t("login.signUp")}
          </a>
        </p>
      </div>
    </div>
  );
};

export default Login;
