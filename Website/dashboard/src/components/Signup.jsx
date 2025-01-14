import { useState } from "react";
import { FontAwesomeIcon } from "@fortawesome/react-fontawesome";
import { faEye, faEyeSlash } from "@fortawesome/free-solid-svg-icons";
import Cookies from "js-cookie";
import { GoogleLogin } from "@react-oauth/google";
import backgroundVideo from "../assets/bg-aquarium2.mp4";
import { useTranslation } from "react-i18next";
import React from "react";

const Signup = () => {
  const { t } = useTranslation();
  const [firstName, setFirstName] = useState("");
  const [lastName, setLastName] = useState("");
  const [email, setEmail] = useState("");
  const [password, setPassword] = useState("");
  const [confirmPassword, setConfirmPassword] = useState("");
  const [showPassword, setShowPassword] = useState(false);
  const [showConfirmPassword, setShowConfirmPassword] = useState(false);
  const [error, setError] = useState("");

  const togglePasswordVisibility = () => {
    setShowPassword(!showPassword);
  };

  const toggleConfirmPasswordVisibility = () => {
    setShowConfirmPassword(!showConfirmPassword);
  };

  const handleSignup = async () => {
    if (password !== confirmPassword) {
      setError(t("signup.passwordMismatch"));
      return;
    }

    const response = await fetch(
      "https://dev.aquaware.cloud/api/users/auth/signup/",
      {
        method: "POST",
        headers: {
          "Content-Type": "application/json",
        },
        body: JSON.stringify({
          first_name: firstName,
          last_name: lastName,
          email: email,
          password: password,
          password2: confirmPassword,
        }),
        credentials: "include",
      }
    );

    const data = await response.json();

    if (response.ok) {
      Cookies.set("api_key", data.api_key);
      window.location.href = "/";
    } else if (response.status === 409) {
      setError(t("signup.emailInUse"));
    } else {
      setError(data.error || t("signup.invalidInput"));
    }
  };

  const handleGoogleSuccess = async (credentialResponse) => {
    const token = credentialResponse.credential;

    try {
      const response = await fetch(
        "https://dev.aquaware.cloud/api/users/auth/signup/google/",
        {
          method: "POST",
          headers: {
            "Content-Type": "application/json",
          },
          body: JSON.stringify({
            token: token,
          }),
        }
      );

      const data = await response.json();

      if (response.ok) {
        Cookies.set("api_key", data.api_key);
        window.location.href = "/";
      } else {
        console.error("Google signup failed:", data);
        setError(data.error || t("signup.googleSignupFailed"));
      }
    } catch (error) {
      console.error("Error during Google signup:", error);
      setError(t("signup.googleSignupError"));
    }
  };

  const handleGoogleFailure = (error) => {
    console.error("Google OAuth failure", error);
    setError(t("signup.googleLoginFailed"));
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
        {t("signup.videoNotSupported")}
      </video>
      <div className="w-full max-w-[500px] bg-n-1 rounded-lg shadow-lg p-8 z-2">
        <h1 className="text-3xl font-bold text-center text-n-8 mb-6">
          {t("signup.title")}
        </h1>

        {error && <p className="text-red-500 text-center mb-4">{error}</p>}

        <div className="w-full flex flex-col mb-4">
          <p className="text-base text-center mb-4 text-n-8">
            {t("signup.subtitle")}
          </p>
          <div className="flex space-x-4">
            <input
              type="text"
              placeholder={t("signup.firstNamePlaceholder")}
              value={firstName}
              onChange={(e) => setFirstName(e.target.value)}
              className="w-1/2 text-n-8 py-2 my-2 bg-transparent border-b border-gray-400 outline-none focus:border-blue-500"
            />
            <input
              type="text"
              placeholder={t("signup.lastNamePlaceholder")}
              value={lastName}
              onChange={(e) => setLastName(e.target.value)}
              className="w-1/2 text-n-8 py-2 my-2 bg-transparent border-b border-gray-400 outline-none focus:border-blue-500"
            />
          </div>
          <input
            type="email"
            placeholder={t("signup.emailPlaceholder")}
            value={email}
            onChange={(e) => setEmail(e.target.value)}
            className="w-full text-n-8 py-2 my-2 bg-transparent border-b border-gray-400 outline-none focus:border-blue-500"
          />
          <div className="relative w-full">
            <input
              type={showPassword ? "text" : "password"}
              placeholder={t("signup.passwordPlaceholder")}
              value={password}
              onChange={(e) => setPassword(e.target.value)}
              className="w-full text-n-8 py-2 my-2 bg-transparent border-b border-gray-400 outline-none focus:border-blue-500"
            />
            <span
              className="absolute right-2 top-4 cursor-pointer text-gray-500"
              onClick={togglePasswordVisibility}
            >
              {showPassword ? (
                <FontAwesomeIcon icon={faEyeSlash} className="mr-4" />
              ) : (
                <FontAwesomeIcon icon={faEye} className="mr-4" />
              )}
            </span>
          </div>
          <div className="relative w-full">
            <input
              type={showConfirmPassword ? "text" : "password"}
              placeholder={t("signup.confirmPasswordPlaceholder")}
              value={confirmPassword}
              onChange={(e) => setConfirmPassword(e.target.value)}
              className="w-full text-n-8 py-2 my-2 bg-transparent border-b border-gray-400 outline-none focus:border-blue-500"
            />
            <span
              className="absolute right-2 top-4 cursor-pointer text-gray-500"
              onClick={toggleConfirmPasswordVisibility}
            >
              {showConfirmPassword ? (
                <FontAwesomeIcon icon={faEyeSlash} className="mr-4" />
              ) : (
                <FontAwesomeIcon icon={faEye} className="mr-4" />
              )}
            </span>
          </div>
        </div>

        <button
          onClick={handleSignup}
          className="w-full bg-n-15 text-white font-semibold rounded-md py-3 mb-4"
        >
          {t("signup.signupButton")}
        </button>

        <div className="w-full flex items-center justify-center relative mb-4">
          <div className="w-full h-[1px] bg-gray-300"></div>
          <p className="absolute bg-white px-4 text-gray-500">
            {t("signup.or")}
          </p>
        </div>

        <div className="w-full flex items-center justify-center text-n-8 font-semibold rounded-md py-3 mb-6">
          <GoogleLogin
            className="w-full flex items-center justify-center text-n-8 font-semibold border border-gray-400 rounded-md py-3 mb-6"
            onSuccess={handleGoogleSuccess}
            onError={handleGoogleFailure}
          />
        </div>

        <p className="text-center text-sm text-gray-600 mt-4">
          {t("signup.alreadyHaveAccount")}{" "}
          <a className="text-blue-500 font-semibold" href="/login">
            {t("signup.loginLink")}
          </a>
        </p>
      </div>
    </div>
  );
};

export default Signup;
