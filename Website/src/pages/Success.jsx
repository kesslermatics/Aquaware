import { useEffect } from "react";
import { useNavigate } from "react-router-dom";
import Confetti from "react-confetti";
import { useTranslation } from "next-i18next";

const Success = () => {
  const { t } = useTranslation();
  const navigate = useNavigate();

  useEffect(() => {
    const timer = setTimeout(() => {
      navigate("/dashboard#pricingplans");
    }, 5000);

    return () => clearTimeout(timer);
  }, [navigate]);

  return (
    <div className="flex flex-col items-center justify-center h-screen">
      <Confetti />
      <h1 className="text-4xl font-bold mb-4">
        {t("success.welcomeMessage")}
      </h1>
      <p className="text-xl">{t("success.redirectMessage")}</p>
    </div>
  );
};

export default Success;
