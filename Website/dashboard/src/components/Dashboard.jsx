import React, { useEffect, useState } from "react";
import Cookies from "js-cookie";
import { useTranslation } from "react-i18next";
import GreetingWidget from "../components/dashboard/GreetingWidget";
import EnvironmentsWidget from "../components/dashboard/EnvironmentsWidget";

const Dashboard = () => {
  const { t } = useTranslation();
  const [userData, setUserData] = useState(null);
  const [environments, setEnvironments] = useState([]);
  const [loading, setLoading] = useState(true);
  const [progress, setProgress] = useState(0);
  const [loadingMessage, setLoadingMessage] = useState(t("dashboard.loading"));


  const fetchUserData = async () => {
    try {
      setLoadingMessage(t("dashboard.loadingProfile"));
      let apiKey = Cookies.get("api_key");

      const response = await fetch("https://dev.aquaware.cloud/api/users/profile/", {
        method: "GET",
        headers: {
          "Content-Type": "application/json",
          "x-api-key": apiKey,
        },
      });

      if (response.ok) {
        const data = await response.json();
        setUserData(data);
        setProgress((prev) => prev + 33); // Update progress by 33%
      } else {
        throw new Error(t("dashboard.errors.fetchProfileFailed"));
      }
    } catch (error) {
      console.error(t("dashboard.errors.profileError"), error);
    }
  };

  const fetchEnvironments = async () => {
    try {
      setLoadingMessage(t("dashboard.loadingEnvironments"));
      const apiKey = Cookies.get("api_key");

      const response = await fetch("https://dev.aquaware.cloud/api/environments/", {
        method: "GET",
        headers: {
          "Content-Type": "application/json",
          "x-api-key": apiKey,
        },
      });

      if (response.ok) {
        const environmentsData = await response.json();
        const environmentsWithValues = await Promise.all(
          environmentsData.map(async (env) => {
            const valuesResponse = await fetch(
              `https://dev.aquaware.cloud/api/environments/${env.id}/values/latest/1/`,
              {
                method: "GET",
                headers: {
                  "Content-Type": "application/json",
                  "x-api-key": apiKey,
                },
              }
            );

            if (valuesResponse.ok) {
              const valuesData = await valuesResponse.json();
              return { ...env, values: valuesData };
            } else {
              console.error(t("dashboard.errors.fetchValuesFailed", { id: env.id }));
              return { ...env, values: [] };
            }
          })
        );

        setEnvironments(environmentsWithValues);
        setProgress((prev) => prev + 33); // Update progress by 33%
      } else {
        throw new Error(t("dashboard.errors.fetchEnvironmentsFailed"));
      }
    } catch (error) {
      console.error(t("dashboard.errors.environmentsError"), error);
    }
  };

  useEffect(() => {
    const loadData = async () => {
      try {
        setLoading(true);
        setProgress(0);
        await fetchUserData();
        await fetchEnvironments();
        setLoadingMessage(t("dashboard.finalizing"));
        setProgress(100); // Finish progress
      } catch (error) {
        console.error(t("dashboard.errors.loadingDataError"), error);
      } finally {
        setLoading(false);
      }
    };

    loadData();
  }, [t]);
  console.log(userData);
  return (
    <div className="flex flex-col min-h-screen bg-n-8">
      {loading ? (
        <div className="flex flex-col items-center justify-center h-screen">
          <p className="text-lg font-semibold mb-4">{loadingMessage}</p>
          <div className="relative w-3/4 bg-gray-300 rounded h-4">
            <div
              className="absolute bg-blue-500 h-4 rounded"
              style={{ width: `${progress}%` }}
            ></div>
          </div>
        </div>
      ) : (
        <main className="flex-grow p-6">
          <div className="grid grid-cols-1 gap-4">
            <div className="w-full">
              <GreetingWidget userData={userData} />
            </div>
            <div className="w-full">
              {environments.length > 0 ? (
                <EnvironmentsWidget environments={environments} />
              ) : (
                <div className="p-6 rounded">
                  <p className="text-lm text-n-1">
                    {t("dashboard.noEnvironments1")}{" "}
                  </p>
                  <p className="text-lm text-n-1">
                    {t("dashboard.noEnvironments2")}{" "}
                    <a
                      href="https://docs.aquaware.cloud/docs/getting-started/welcome"
                      target="_blank"
                      rel="noopener noreferrer"
                      className="text-n-3 underline"
                    >
                      {t("dashboard.startGuide")}
                    </a>
                  </p>
                  <p className="text-lm text-n-1">
                    {t("dashboard.noEnvironments3")}
                  </p>
                </div>
              )}
            </div>
          </div>
        </main>
      )}
    </div>
  );
};

export default Dashboard;
