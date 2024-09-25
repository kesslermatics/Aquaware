import React, { useState, useEffect } from "react";
import Cookies from "js-cookie";
import { format } from "date-fns"; // Nützlich zur Formatierung des Datums

const AccountInfo = () => {
  const [userData, setUserData] = useState({
    first_name: "",
    last_name: "",
    email: "",
    subscription_tier: "",
    date_joined: "",
  });
  const [loading, setLoading] = useState(true);
  const [error, setError] = useState(null);

  useEffect(() => {
    const fetchUserProfile = async () => {
      try {
        await ensureAccessToken(); // Refresh access token before making any requests
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
          throw new Error("Failed to fetch user profile.");
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
  }, []);

  // Function to ensure the access token is always fresh
  const ensureAccessToken = async () => {
    const refreshToken = Cookies.get("refresh_token");
    if (!refreshToken) {
      throw new Error("No refresh token available. Please log in again.");
    }

    await refreshAccessToken(refreshToken);
  };

  // Refresh access token function
  const refreshAccessToken = async (refreshToken) => {
    try {
      const response = await fetch(
        "https://dev.aquaware.cloud/api/users/token/refresh/",
        {
          method: "POST",
          headers: {
            "Content-Type": "application/json",
          },
          body: JSON.stringify({ refresh: refreshToken }),
          credentials: "include", // Ensure cookies are included in the request
        }
      );

      if (response.ok) {
        const data = await response.json();
        Cookies.set("access_token", data.access); // Save new access token in cookies
        return true;
      } else {
        console.error(response);
        throw new Error("Failed to refresh access token.");
      }
    } catch (error) {
      throw error;
    }
  };

  const handleInputChange = (e) => {
    const { name, value } = e.target;
    setUserData({
      ...userData,
      [name]: value,
    });
  };

  const handleSubmit = async (e) => {
    e.preventDefault();
    try {
      await ensureAccessToken(); // Ensure token is fresh before sending data
      const accessToken = Cookies.get("access_token");

      const response = await fetch("/api/users/profile/update/", {
        method: "PUT",
        headers: {
          "Content-Type": "application/json",
          Authorization: `Bearer ${accessToken}`,
        },
        body: JSON.stringify(userData),
      });

      if (!response.ok) {
        throw new Error("Failed to update profile.");
      }

      const updatedData = await response.json();
      setUserData(updatedData);
      alert("Profile updated successfully.");
    } catch (error) {
      setError(error.message);
    }
  };

  // Map subscription tier to plan name
  const getSubscriptionPlan = (tier) => {
    switch (tier) {
      case 1:
        return "Free Plan";
      case 2:
        return "Advanced Plan";
      case 3:
        return "Business Plan";
      default:
        return "Unknown Plan";
    }
  };

  if (loading) return <p>Loading...</p>;
  if (error) return <p className="text-red-500">{error}</p>;

  return (
    <div className="w-full max-w-lg mx-auto p-6 rounded-lg">
      <h2 className="text-2xl font-semibold mb-6">Account Settings</h2>
      <form onSubmit={handleSubmit}>
        <div className="mb-4">
          <label htmlFor="first_name" className="block text-n-1">
            First Name
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
            Last Name
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
            Email
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
            Subscription Tier
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
            Date Joined
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

        <div className="flex justify-between">
          <button
            type="submit"
            className="bg-blue-500 text-white px-4 py-2 rounded-lg hover:bg-blue-600"
          >
            Update Profile
          </button>
        </div>
      </form>
    </div>
  );
};

export default AccountInfo;
