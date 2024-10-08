import { check } from "../../assets";
import { pricing } from "../../constants";
import { useState, useEffect } from "react";
import Cookies from "js-cookie";
import Confetti from "react-confetti";
import ComparePlans from "../ComparePlans";

const PricingPlanInfo = () => {
  const [userPlan, setUserPlan] = useState(null);
  const [selectedPlan, setSelectedPlan] = useState(null);
  const [showConfetti, setShowConfetti] = useState(false); // New state for confetti

  // Function to refresh the access token
  const refreshAccessToken = async () => {
    try {
      const refreshToken = Cookies.get("refresh_token");
      const response = await fetch(
        "https://dev.aquaware.cloud/api/users/token/refresh/",
        {
          method: "POST",
          headers: {
            "Content-Type": "application/json",
          },
          body: JSON.stringify({ refresh: refreshToken }),
        }
      );

      if (response.ok) {
        const data = await response.json();
        Cookies.set("access_token", data.access);
        return data.access;
      } else {
        throw new Error("Failed to refresh token");
      }
    } catch (error) {
      console.error("Error refreshing access token:", error);
      throw error;
    }
  };

  // Function to handle API requests with automatic token refresh
  const fetchWithTokenRefresh = async (url, options) => {
    try {
      let accessToken = Cookies.get("access_token");
      options.headers = {
        ...options.headers,
        Authorization: `Bearer ${accessToken}`,
      };

      let response = await fetch(url, options);

      if (response.status === 401) {
        accessToken = await refreshAccessToken();
        options.headers.Authorization = `Bearer ${accessToken}`;
        response = await fetch(url, options);
      }

      return response;
    } catch (error) {
      console.error("Error fetching data:", error);
    }
  };

  useEffect(() => {
    const fetchUserPlan = async () => {
      try {
        const response = await fetchWithTokenRefresh(
          "https://dev.aquaware.cloud/api/users/profile/",
          {
            method: "GET",
            headers: {
              "Content-Type": "application/json",
            },
            credentials: "include",
          }
        );

        if (response.ok) {
          const data = await response.json();
          setUserPlan(data.subscription_tier);
        }
      } catch (error) {
        console.error("Error fetching user plan:", error);
      }
    };

    fetchUserPlan();
  }, []);

  const handlePlanClick = (plan) => {
    if (plan.id !== userPlan) {
      setSelectedPlan(plan);
      // handle payment link redirection
      window.location.href = plan.stripeLink;
    }
  };

  const getButtonText = (planId) => {
    if (planId == 1) {
      return "Always Active";
    }
    if (planId == userPlan) {
      return "Current Plan";
    } else if (planId > userPlan) {
      return "Upgrade";
    } else if (planId < userPlan) {
      return "Downgrade";
    }
  };

  const getButtonClass = (planId) => {
    if (planId == 1) {
      return "text-white cursor-default";
    }
    if (planId == userPlan) {
      return "bg-green-500 text-white cursor-default";
    } else if (planId > userPlan || planId < userPlan) {
      return "bg-blue-500 text-white hover:bg-blue-600";
    }
  };

  const isButtonDisabled = (planId) => {
    if (planId == 1) {
      return true;
    }
    return planId == userPlan;
  };

  return (
    <div className="flex flex-col min-h-screen py-8 px-4 bg-n-8 overflow-y-auto">
      <div className="flex flex-wrap gap-4 justify-center w-full max-w-7xl mb-16">
        <h2 className="text-2xl font-semibold">Plan Information</h2>
        <p className="text-center mt-4 mb-4">
          We use Stripe for payment processing. Please ensure you use the same
          email address that you have registered with through our API, app, or
          on this website to complete your payment. This will help ensure your
          account is correctly linked with your subscription.
        </p>
        {/* Display customer portal link if userPlan is not 1 */}
        {userPlan != 1 && (
          <div className=" text-center w-full max-w-7xl mx-auto p-6 rounded-xl shadow-lg bg-n-8">
            <a
              href="https://billing.stripe.com/p/login/fZeaGa4mc7Zi2oU8ww"
              target="_blank"
              rel="noopener noreferrer"
              className="inline-block bg-blue-500 text-white px-6 py-2 rounded-lg font-semibold text-center hover:bg-blue-600"
            >
              Manage Your Active Subscription
            </a>
          </div>
        )}
        {pricing.map((item) => (
          <div
            key={item.id}
            className="w-full sm:w-[18rem] lg:w-[22rem] h-auto p-4 bg-n-8 border border-n-6 rounded-xl shadow-lg"
          >
            <h4 className="text-lg font-semibold mb-2 text-center">
              {item.title}
            </h4>
            <p className="text-sm text-gray-500 text-center mb-4">
              {item.description}
            </p>

            <div className="flex justify-center items-center mb-4">
              {item.price && (
                <>
                  <span className="text-xl font-semibold">€</span>
                  <span className="text-4xl font-bold ml-1">
                    {item.price} /m
                  </span>
                </>
              )}
            </div>

            <button
              className={`w-full py-2 rounded-lg font-semibold text-center ${getButtonClass(
                item.id
              )}`}
              onClick={() => handlePlanClick(item)}
              disabled={isButtonDisabled(item.id)}
            >
              {getButtonText(item.id)}
            </button>

            <ul className="mt-4">
              {item.features.map((feature, index) => (
                <li
                  key={index}
                  className="flex items-center py-2 border-t border-gray-300"
                >
                  <img src={check} alt="Check" className="w-4 h-4" />
                  <p className="text-sm ml-2">{feature}</p>
                </li>
              ))}
            </ul>
          </div>
        ))}
      </div>
      <ComparePlans />
    </div>
  );
};

export default PricingPlanInfo;
