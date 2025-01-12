import React, { useEffect, useState } from "react";
import { useTranslation } from "react-i18next";

const GreetingWidget = ({ userData }) => {
  const { t } = useTranslation();
  const [greeting, setGreeting] = useState("");

  useEffect(() => {
    const determineGreeting = () => {
      const hour = new Date().getHours();
      if (hour < 12) return t("greeting.morning");
      if (hour < 18) return t("greeting.afternoon");
      return t("greeting.evening");
    };

    setGreeting(determineGreeting());
  }, [t]);

  return (
    <div className="p-6 rounded">
      <h2 className="text-xl font-semibold">
        {greeting}, {userData ? `${userData.first_name}` : t("greeting.guest")}
      </h2>
      <p className="text-sm text-n-2 mt-2">
        {t("greeting.subtitle")}
      </p>
    </div>
  );
};

export default GreetingWidget;
