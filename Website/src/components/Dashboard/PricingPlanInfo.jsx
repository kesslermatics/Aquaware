import { check } from "../../assets";
import { pricing } from "../../constants";
import Button from "../Button";
import { useState, useEffect } from "react";
import Cookies from "js-cookie";
import { PayPalScriptProvider, PayPalButtons } from "@paypal/react-paypal-js";

const PricingPlanInfo = () => {
  const [userPlan, setUserPlan] = useState(null);
  const [selectedPlan, setSelectedPlan] = useState(null);
  const [message, setMessage] = useState("");

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
    } else if (planId > userPlan) {
      return "bg-blue-500 text-white hover:bg-blue-600"; // Upgrade button
    } else if (planId < userPlan) {
      return "bg-blue-500 text-white hover:bg-blue-600"; // Downgrade button
    }
  };

  const isButtonDisabled = (planId) => {
    return planId == userPlan; // Disable button if it's the current plan
  };

  const initialOptions = {
    "client-id": import.meta.env.VITE_PAYPAL_CLIENT_ID,
    currency: "EUR",
    components: "buttons",
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

      {/* Display selected plan details */}
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

          <div className="mt-4">
            <PayPalScriptProvider options={initialOptions}>
              <PayPalButtons
                style={{
                  shape: "rect",
                  layout: "vertical",
                  color: "gold",
                  label: "paypal",
                }}
                createOrder={async () => {
                  try {
                    const response = await fetch(
                      "https://dev.aquaware.cloud/api/orders",
                      {
                        method: "POST",
                        headers: {
                          "Content-Type": "application/json",
                        },
                        body: JSON.stringify({
                          cart: [
                            {
                              id: selectedPlan.id,
                              quantity: 1,
                            },
                          ],
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
                }}
                onApprove={async (data, actions) => {
                  try {
                    const response = await fetch(
                      `https://dev.aquaware.cloud/api/orders/${data.orderID}/capture`,
                      {
                        method: "POST",
                        headers: {
                          "Content-Type": "application/json",
                        },
                        body: JSON.stringify({
                          plan: selectedPlan.id,
                        }),
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
                    } else {
                      const transaction =
                        orderData.purchase_units[0].payments.captures[0];
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
                }}
              />
            </PayPalScriptProvider>
            <p>{message}</p>
          </div>
        </div>
      )}
    </div>
  );
};

export default PricingPlanInfo;
