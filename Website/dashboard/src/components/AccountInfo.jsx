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
  const [isDeleting, setIsDeleting] = useState(false);
  const [isDeleteDialogOpen, setIsDeleteDialogOpen] = useState(false);
  const [deleteInput, setDeleteInput] = useState("");
  const [successMessage, setSuccessMessage] = useState("");
  const [apiKeyVisible, setApiKeyVisible] = useState(false);
  const navigate = useNavigate();

  useEffect(() => {
    const fetchUserProfile = async () => {
      try {
        const apiKey = Cookies.get("api_key"); // API-Schlüssel aus Cookies holen
    
        const response = await fetch("https://dev.aquaware.cloud/api/users/profile/", {
          method: "GET",
          headers: {
            "Content-Type": "application/json",
            "x-api-key": apiKey,
          },
        });
    
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

  const handleDeleteAccount = async () => {
    ensureAccessToken();
    setIsDeleting(true);
    try {
      const apiKey = Cookies.get("api_key");

      const response = await fetch(
        "https://dev.aquaware.cloud/api/users/profile/",
        {
          method: "DELETE",
          headers: {
            Authorization: `Bearer ${accessToken}`,
            "x-api-key": apiKey,
          },
        }
      );

      if (response.ok) {
        alert(t("accountInfo.deleted_successfully"));
        Cookies.remove("api_key");
        window.location.href = "/";
      } else {
        const data = await response.json();
        alert(data.detail || t("accountInfo.deletion_failed"));
      }
    } catch (error) {
      alert(t("accountInfo.deletion_failed"));
    } finally {
      setIsDeleting(false);
      setIsDeleteDialogOpen(false);
      setDeleteInput("");
    }
  };

  const handleSubmit = async (e) => {
    e.preventDefault();
    setSuccessMessage("");
    try {
      await ensureAccessToken();
      const apiKey = Cookies.get("api_key");

      const response = await fetch(
        "https://dev.aquaware.cloud/api/users/profile/",
        {
          method: "PUT",
          headers: {
            "Content-Type": "application/json",
            "x-api-key": apiKey,
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
      const apiKey = Cookies.get("api_key");

      const response = await fetch(
        "https://dev.aquaware.cloud/api/users/auth/api-key/regenerate/",
        {
          method: "POST",
          headers: {
            "Content-Type": "application/json",
            "x-api-key": apiKey,
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
      <div className="flex justify-start mt-4">
        <button
          className="px-4 py-2 bg-red-500 text-white rounded-md hover:bg-red-700"
          onClick={() => setIsDeleteDialogOpen(true)}
        >
          {t("accountInfo.delete_account")}
        </button>
      </div>

      {/* Delete Dialog */}
      {isDeleteDialogOpen && (
        <div className="fixed inset-0 flex items-center justify-center bg-black bg-opacity-50 z-50">
          <div className="bg-white rounded-lg p-6 shadow-lg w-96">
            <h3 className="text-lg font-bold mb-4 text-red-500">
              {t("accountInfo.confirm_delete_title")}
            </h3>
            <p className="text-sm text-gray-600 mb-4">
              {t("accountInfo.confirm_delete_message")}
            </p>
            <input
              type="text"
              value={deleteInput}
              onChange={(e) => setDeleteInput(e.target.value)}
              placeholder={t("accountInfo.type_delete_to_confirm")}
              className="w-full border border-gray-300 rounded-md px-4 py-2 mb-4"
            />
            <div className="flex justify-end gap-4">
              <button
                onClick={() => {
                  setIsDeleteDialogOpen(false);
                  setDeleteInput("");
                }}
                className="px-4 py-2 bg-gray-500 text-white rounded-md hover:bg-gray-700"
              >
                {t("accountInfo.cancel")}
              </button>
              <button
                onClick={handleDeleteAccount}
                disabled={deleteInput !== "DELETE ACCOUNT" || isDeleting}
                className={`px-4 py-2 text-white rounded-md ${
                  deleteInput === "DELETE ACCOUNT" && !isDeleting
                    ? "bg-red-500 hover:bg-red-700"
                    : "bg-red-300 cursor-not-allowed"
                }`}
              >
                {isDeleting
                  ? t("accountInfo.deleting")
                  : t("accountInfo.delete")}
              </button>
            </div>
          </div>
        </div>
      )}
    </div>
  );
};

export default AccountInfo;
