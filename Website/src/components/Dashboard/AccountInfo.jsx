import React, { useState, useEffect } from "react";
import Cookies from "js-cookie";
import { format } from "date-fns";
import { useNavigate } from "react-router-dom";
import { useTranslation } from "react-i18next";
import { FaEye, FaEyeSlash, FaClipboard, FaSpinner } from "react-icons/fa";

const AccountInfo = () => {
  const { t } = useTranslation();
  const [userData, setUserData] = useState({
    first_name: "",
    last_name: "",
    email: "",
    subscription_tier: "",
    date_joined: "",
    api_key: "",
  });
  const [loading, setLoading] = useState(true);
  const [error, setError] = useState(null);
  const [successMessage, setSuccessMessage] = useState("");
  const [apiKeyVisible, setApiKeyVisible] = useState(false);
  const navigate = useNavigate();

  useEffect(() => {
    const fetchUserProfile = async () => {
      try {
        await ensureAccessToken();
        const accessToken = Cookies.get("access_token");

        const response = await fetch(
          "https://dev.aquaware.cloud/api/users/profile/",
          {
            method: "GET",
            headers: {
              "Content-Type": "application/json",
              Authorization: `Bearer ${accessToken}`,
            },
          }
        );

        if (!response.ok) {
          throw new Error(t("accountInfo.fetchError"));
        }

        const data = await response.json();
        setUserData(data);
        setLoading(false);
      } catch (error) {
        setError(error.message);
        setLoading(false);
      }
    };

    fetchUserProfile();
  }, [t]);

  const ensureAccessToken = async () => {
    const refreshToken = Cookies.get("refresh_token");
    if (!refreshToken) {
      throw new Error(t("accountInfo.noRefreshToken"));
    }

    await refreshAccessToken(refreshToken);
  };

  const refreshAccessToken = async (refreshToken) => {
    try {
      const response = await fetch(
        "https://dev.aquaware.cloud/api/users/auth/token/refresh/",
        {
          method: "POST",
          headers: {
            "Content-Type": "application/json",
          },
          body: JSON.stringify({ refresh: refreshToken }),
          credentials: "include",
        }
      );

      if (response.ok) {
        const data = await response.json();
        Cookies.set("access_token", data.access);
        return true;
      } else {
        throw new Error(t("accountInfo.tokenRefreshError"));
      }
    } catch (error) {
      throw error;
    }
  };

  const copyToClipboard = () => {
    navigator.clipboard.writeText(userData.api_key);
    setSuccessMessage(t("accountInfo.apiKeyCopied"));
    setTimeout(() => setSuccessMessage(""), 2000);
  };

  const handleInputChange = (e) => {
    const { name, value } = e.target;
    setUserData({
      ...userData,
      [name]: value,
    });
  };

  if (loading) {
    return (
      <div className="flex items-center justify-center h-screen">
        <FaSpinner className="animate-spin text-4xl text-blue-500" />
      </div>
    );
  }

  if (error) {
    return (
      <div className="flex items-center justify-center h-screen">
        <p className="text-red-500 text-4xl">{error}</p>
      </div>
    );
  }

  const handleSubmit = async (e) => {
    e.preventDefault();
    setSuccessMessage("");
    try {
      await ensureAccessToken();
      const accessToken = Cookies.get("access_token");

      const response = await fetch(
        "https://dev.aquaware.cloud/api/users/profile/",
        {
          method: "PUT",
          headers: {
            "Content-Type": "application/json",
            Authorization: `Bearer ${accessToken}`,
          },
          body: JSON.stringify({
            first_name: userData.first_name,
            last_name: userData.last_name,
          }),
          credentials: "include",
        }
      );

      if (!response.ok) {
        throw new Error(t("accountInfo.updateError"));
      }

      const updatedData = await response.json();
      setUserData(updatedData);
      setSuccessMessage(t("accountInfo.updateSuccess"));
    } catch (error) {
      setError(error.message);
    }
  };

  const handleLogout = () => {
    Cookies.remove("access_token");
    Cookies.remove("refresh_token");
    window.location.href = "/";
  };

  const handleRegenerateApiKey = async () => {
    try {
      await ensureAccessToken();
      const accessToken = Cookies.get("access_token");

      const response = await fetch(
        "https://dev.aquaware.cloud/api/users/auth/api-key/regenerate/",
        {
          method: "POST",
          headers: {
            "Content-Type": "application/json",
            Authorization: `Bearer ${accessToken}`,
          },
        }
      );

      if (response.ok) {
        const data = await response.json();
        setUserData((prevData) => ({ ...prevData, api_key: data.api_key }));
        setSuccessMessage(t("accountInfo.regenerateApiKeySuccess"));
      } else {
        throw new Error(t("accountInfo.regenerateApiKeyError"));
      }
    } catch (error) {
      setError(error.message);
    }
  };

  const getSubscriptionPlan = (tier) => {
    switch (tier) {
      case 1:
        return t("accountInfo.plans.free");
      case 2:
        return t("accountInfo.plans.advanced");
      case 3:
        return t("accountInfo.plans.premium");
      default:
        return t("accountInfo.plans.unknown");
    }
  };

  return (
    <div className="w-full max-w-lg mx-auto p-6 rounded-lg">
      <h2 className="text-2xl font-semibold mb-6">{t("accountInfo.title")}</h2>
      <form onSubmit={handleSubmit}>
        <div className="mb-4">
          <label htmlFor="first_name" className="block text-n-1">
            {t("accountInfo.firstName")}
          </label>
          <input
            type="text"
            id="first_name"
            name="first_name"
            value={userData.first_name}
            onChange={handleInputChange}
            className="w-full p-2 border bg-n-6 border-gray-300 rounded"
            required
          />
        </div>

        <div className="mb-4">
          <label htmlFor="last_name" className="block text-n-1">
            {t("accountInfo.lastName")}
          </label>
          <input
            type="text"
            id="last_name"
            name="last_name"
            value={userData.last_name}
            onChange={handleInputChange}
            className="w-full p-2 border bg-n-6 border-gray-300 rounded"
            required
          />
        </div>

        <div className="mb-4">
          <label htmlFor="email" className="block text-n-1">
            {t("accountInfo.email")}
          </label>
          <input
            type="email"
            id="email"
            name="email"
            value={userData.email}
            onChange={handleInputChange}
            className="w-full p-2 border border-gray-300 text-gray-500 rounded"
            required
            disabled
          />
        </div>

        <div className="mb-4">
          <label htmlFor="subscription_tier" className="block text-n-1">
            {t("accountInfo.subscriptionTier")}
          </label>
          <input
            type="text"
            id="subscription_tier"
            name="subscription_tier"
            value={getSubscriptionPlan(userData.subscription_tier)}
            onChange={handleInputChange}
            className="w-full p-2 border border-gray-300 text-gray-500 rounded"
            disabled
          />
        </div>

        <div className="mb-4">
          <label htmlFor="date_joined" className="block text-n-1">
            {t("accountInfo.dateJoined")}
          </label>
          <input
            type="text"
            id="date_joined"
            name="date_joined"
            value={format(new Date(userData.date_joined), "MMMM dd, yyyy")}
            onChange={handleInputChange}
            className="w-full p-2 border border-gray-300 text-gray-500 rounded"
            disabled
          />
        </div>

        <div className="mb-4">
          <label htmlFor="api_key" className="block text-n-1">
            {t("accountInfo.apiKey")}
          </label>
          <div className="flex items-center">
            <input
              type={apiKeyVisible ? "text" : "password"}
              id="api_key"
              value={userData.api_key}
              className="w-full p-2 border border-gray-300 text-gray-500 rounded"
              disabled
            />
            <button
              type="button"
              onClick={() => setApiKeyVisible(!apiKeyVisible)}
              className="bg-gray-500 text-white px-2 py-1 rounded-lg hover:bg-gray-600 flex items-center"
            >
              {apiKeyVisible ? <FaEyeSlash /> : <FaEye />}{" "}
            </button>
            <button
              type="button"
              onClick={copyToClipboard}
              className="bg-blue-500 text-white px-2 py-1 ml-2 rounded-lg hover:bg-blue-600 flex items-center"
            >
              <FaClipboard />
            </button>
          </div>
        </div>

        <div className="flex items-center justify-between mt-4">
          <button
            onClick={handleRegenerateApiKey}
            className="bg-blue-500 text-white px-4 py-2 rounded-lg hover:bg-blue-600"
          >
            {t("accountInfo.regenerateApiKey")}
          </button>
          {successMessage && (
            <span className="text-green-500 text-sm ml-4">
              {successMessage}
            </span>
          )}
        </div>

        <div className="flex items-center justify-between mt-4">
          <button
            type="submit"
            className="bg-blue-500 text-white px-4 py-2 rounded-lg hover:bg-blue-600"
          >
            {t("accountInfo.updateProfile")}
          </button>
        </div>
      </form>

      <div className="flex justify-start mt-4">
        <button
          onClick={handleLogout}
          className="bg-red-500 text-white px-4 py-2 rounded-lg hover:bg-red-600"
        >
          {t("accountInfo.logout")}
        </button>
      </div>
    </div>
  );
};

export default AccountInfo;
