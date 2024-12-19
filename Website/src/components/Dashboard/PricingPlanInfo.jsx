import { check } from "../../assets";
import { useState, useEffect } from "react";
import Cookies from "js-cookie";
import Confetti from "react-confetti";
import ComparePlans from "../ComparePlans";
import { useTranslation } from "react-i18next";

const PricingPlanInfo = () => {
  const { t } = useTranslation();
  const [userPlan, setUserPlan] = useState(null);
  const [selectedPlan, setSelectedPlan] = useState(null);
  const [showConfetti, setShowConfetti] = useState(false);

  const refreshAccessToken = async () => {
    try {
      const refreshToken = Cookies.get("refresh_token");
      const response = await fetch(
        "https://dev.aquaware.cloud/api/users/auth/token/refresh/",
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
        throw new Error(t("pricingPlanInfo.errors.tokenRefresh"));
      }
    } catch (error) {
      console.error(t("pricingPlanInfo.errors.tokenRefreshError"), error);
      throw error;
    }
  };

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
      console.error(t("pricingPlanInfo.errors.fetchError"), error);
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
        console.error(t("pricingPlanInfo.errors.fetchPlanError"), error);
      }
    };

    fetchUserPlan();
  }, [t]);

  const handlePlanClick = (plan) => {
    const stripeLinks = {
      2: "https://buy.stripe.com/6oEbJQaODc4Idxe14a",
      3: "https://buy.stripe.com/4gwdRYaODc4Idxe6ov",
    };

    if (plan.id !== userPlan) {
      setSelectedPlan(plan);
      window.location.href = stripeLinks[plan.id];
    }
  };

  const getButtonText = (planId) => {
    if (planId === 1) {
      return t("pricingPlanInfo.buttonText.alwaysActive");
    }
    if (planId === userPlan) {
      return t("pricingPlanInfo.buttonText.currentPlan");
    } else if (planId > userPlan) {
      return t("pricingPlanInfo.buttonText.upgrade");
    } else if (planId < userPlan) {
      return t("pricingPlanInfo.buttonText.downgrade");
    }
  };

  const getButtonClass = (planId) => {
    if (planId === 1) {
      return "text-white cursor-default";
    }
    if (planId === userPlan) {
      return "bg-green-500 text-white cursor-default";
    } else if (planId > userPlan || planId < userPlan) {
      return "bg-blue-500 text-white hover:bg-blue-600";
    }
  };

  const isButtonDisabled = (planId) => planId === 1 || planId === userPlan;

  const planKeys = ["hobbyPlan", "advancedPlan", "premiumPlan"];

  return (
    <div className="flex flex-col min-h-screen py-8 px-4 bg-n-8 overflow-y-auto">
      <div className="flex flex-wrap gap-4 justify-center w-full max-w-7xl mb-16">
        <h2 className="text-2xl font-semibold">{t("pricingPlanInfo.title")}</h2>
        <p className="text-center mt-4 mb-4">
          {t("pricingPlanInfo.paymentInstruction")}
        </p>
        {userPlan !== 1 && (
          <div className=" text-center w-full max-w-7xl mx-auto p-6 rounded-xl shadow-lg bg-n-8">
            <a
              href="https://billing.stripe.com/p/login/fZeaGa4mc7Zi2oU8ww"
              target="_blank"
              rel="noopener noreferrer"
              className="inline-block bg-blue-500 text-white px-6 py-2 rounded-lg font-semibold text-center hover:bg-blue-600"
            >
              {t("pricingPlanInfo.manageSubscription")}
            </a>
          </div>
        )}
        {planKeys.map((key, index) => (
          <div
            key={index}
            className="w-full sm:w-[18rem] lg:w-[22rem] h-auto p-4 bg-n-8 border border-n-6 rounded-xl shadow-lg"
          >
            <h4 className="text-lg font-semibold mb-2 text-center">
              {t(`pricing.${key}.title`)}
            </h4>
            <p className="text-sm text-gray-500 text-center mb-4">
              {t(`pricing.${key}.description`)}
            </p>

            <div className="flex justify-center items-center mb-4">
              <span className="text-xl font-semibold">€</span>
              <span className="text-4xl font-bold ml-1">
                {t(`pricing.${key}.price`)} /m
              </span>
            </div>

            <button
              className={`w-full py-2 rounded-lg font-semibold text-center ${getButtonClass(
                index + 1
              )}`}
              onClick={() => handlePlanClick({ id: index + 1 })}
              disabled={isButtonDisabled(index + 1)}
            >
              {getButtonText(index + 1)}
            </button>

            <ul className="mt-4">
              {t(`pricing.${key}.features`, { returnObjects: true }).map(
                (feature, i) => (
                  <li
                    key={i}
                    className="flex items-center py-2 border-t border-gray-300"
                  >
                    <img src={check} alt="Check" className="w-4 h-4" />
                    <p className="text-sm ml-2">{feature}</p>
                  </li>
                )
              )}
            </ul>
          </div>
        ))}
      </div>
      <ComparePlans />
    </div>
  );
};

export default PricingPlanInfo;
