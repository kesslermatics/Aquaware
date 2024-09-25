import { check } from "../../assets";
import { pricing } from "../../constants";
import Button from "../Button";
import { useState, useEffect } from "react";
import Cookies from "js-cookie";

const PricingPlanInfo = () => {
  const [userPlan, setUserPlan] = useState(null);

  useEffect(() => {
    const fetchUserPlan = async () => {
      try {
        const accessToken = Cookies.get("access_token");
        const response = await fetch(
          "https://dev.aquaware.cloud/api/users/profile/",
          {
            method: "GET",
            headers: {
              "Content-Type": "application/json",
              Authorization: `Bearer ${accessToken}`,
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

  const getButtonText = (planId) => {
    if (planId == userPlan) {
      return "Current Plan"; // User's current plan
    }
    return "Get started";
  };

  const getButtonClass = (planId) => {
    if (planId === userPlan) {
      return "bg-green-500 text-white cursor-default"; // Styled for the current plan
    }
    return "bg-blue-500 text-white hover:bg-blue-600"; // Styled for other plans
  };

  return (
    <div className="flex flex-wrap gap-4 h-full justify-center">
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
                <span className="text-xl font-semibold">$</span>
                <span className="text-4xl font-bold ml-1">{item.price}</span>
              </>
            )}
          </div>

          <button
            className={`w-full py-2 rounded-lg font-semibold text-center ${getButtonClass(
              item.id
            )}`}
            disabled={item.id === userPlan} // Disable button if it's the current plan
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
  );
};

export default PricingPlanInfo;
