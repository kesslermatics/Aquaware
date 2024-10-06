import { check } from "../../assets";
import { pricing } from "../../constants";
import { useState, useEffect, useRef } from "react";
import Cookies from "js-cookie";

const PricingPlanInfo = () => {
  const [userPlan, setUserPlan] = useState(null);
  const [selectedPlan, setSelectedPlan] = useState(null);
  const [message, setMessage] = useState("");
  const paypalRef = useRef(null);

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

      // If the token has expired, refresh it and retry the request
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

  useEffect(() => {
    if (selectedPlan && window.paypal) {
      paypalRef.current.innerHTML = ""; // Clear PayPal button container before rendering

      window.paypal
        .Buttons({
          style: {
            shape: "rect",
            layout: "vertical",
            color: "gold",
            label: "paypal",
          },
          message: {
            amount: selectedPlan.price,
          },
          async createOrder() {
            try {
              const response = await fetchWithTokenRefresh(
                "https://dev.aquaware.cloud/api/orders/create-order/",
                {
                  method: "POST",
                  headers: {
                    "Content-Type": "application/json",
                  },
                  body: JSON.stringify({
                    plan: selectedPlan.id,
                    amount: selectedPlan.price,
                  }),
                }
              );

              const orderData = await response.json();
              if (orderData.id) {
                return orderData.id;
              } else {
                const errorDetail = orderData?.details?.[0];
                const errorMessage = errorDetail
                  ? `${errorDetail.issue} ${errorDetail.description} (${orderData.debug_id})`
                  : JSON.stringify(orderData);

                throw new Error(errorMessage);
              }
            } catch (error) {
              console.error(error);
              setMessage(`Could not initiate PayPal Checkout...${error}`);
            }
          },
          async onApprove(data, actions) {
            try {
              const response = await fetchWithTokenRefresh(
                `https://dev.aquaware.cloud/api/orders/${data.orderID}/capture/`,
                {
                  method: "POST",
                  headers: {
                    "Content-Type": "application/json",
                  },
                }
              );

              const orderData = await response.json();
              const errorDetail = orderData?.details?.[0];

              if (errorDetail?.issue === "INSTRUMENT_DECLINED") {
                return actions.restart();
              } else if (errorDetail) {
                throw new Error(
                  `${errorDetail.description} (${orderData.debug_id})`
                );
              } else if (!orderData.purchase_units) {
                throw new Error(JSON.stringify(orderData));
              } else {
                const transaction =
                  orderData?.purchase_units?.[0]?.payments?.captures?.[0] ||
                  orderData?.purchase_units?.[0]?.payments?.authorizations?.[0];
                setMessage(
                  `Transaction ${transaction.status}: ${transaction.id}. See console for all available details`
                );
                console.log(
                  "Capture result",
                  orderData,
                  JSON.stringify(orderData, null, 2)
                );
              }
            } catch (error) {
              console.error(error);
              setMessage(
                `Sorry, your transaction could not be processed...${error}`
              );
            }
          },
        })
        .render(paypalRef.current);
    }
  }, [selectedPlan]);

  const handlePlanClick = (plan) => {
    if (plan.id !== userPlan) {
      setSelectedPlan(plan); // Set the selected plan for display
    }
  };

  const getButtonText = (planId) => {
    if (planId == userPlan) {
      return "Current Plan";
    } else if (planId > userPlan) {
      return "Upgrade";
    } else if (planId < userPlan) {
      return "Downgrade";
    }
  };

  const getButtonClass = (planId) => {
    if (planId == userPlan) {
      return "bg-green-500 text-white cursor-default";
    } else if (planId > userPlan || planId < userPlan) {
      return "bg-blue-500 text-white hover:bg-blue-600"; // Upgrade or Downgrade button
    }
  };

  const isButtonDisabled = (planId) => {
    return planId == userPlan; // Disable button if it's the current plan
  };

  return (
    <div className="flex flex-col min-h-screen py-8 px-4 bg-n-8 overflow-y-auto">
      <div className="flex flex-wrap gap-4 justify-center w-full max-w-7xl">
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
              onClick={() => handlePlanClick(item)} // Handle plan click
              disabled={isButtonDisabled(item.id)} // Disable button if it's the current plan
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

      {/* Display selected plan details and PayPal button */}
      {selectedPlan && (
        <div className="mt-8 w-full max-w-7xl mx-auto p-6 border border-n-6 rounded-xl shadow-lg">
          <h3 className="text-xl font-semibold mb-4">Selected Plan</h3>
          <p>
            <strong>Plan:</strong> {selectedPlan.title}
          </p>
          <p>
            <strong>Price:</strong> ${selectedPlan.price} / month
          </p>
          <p>
            <strong>Description:</strong> {selectedPlan.description}
          </p>

          <div
            className="mt-4"
            id="paypal-button-container"
            ref={paypalRef}
          ></div>
          <p>{message}</p>
        </div>
      )}
    </div>
  );
};

export default PricingPlanInfo;
