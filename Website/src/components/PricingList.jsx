import { check } from "../assets";
import Button from "./Button";
import { useTranslation } from "react-i18next";
import React from "react";

const PricingList = () => {
  const { t } = useTranslation();

  const pricingData = [
    {
      id: "1",
      title: t("pricing.hobbyPlan.title"),
      description: t("pricing.hobbyPlan.description"),
      price: t("pricing.hobbyPlan.price"),
      buttonText: t("pricing.hobbyPlan.buttonText"),
      buttonRef: "/signup",
      features: t("pricing.hobbyPlan.features", { returnObjects: true }),
    },
    {
      id: "2",
      title: t("pricing.advancedPlan.title"),
      description: t("pricing.advancedPlan.description"),
      price: t("pricing.advancedPlan.price"),
      buttonText: t("pricing.advancedPlan.buttonText"),
      buttonRef: "/dashboard#pricingplans",
      features: t("pricing.advancedPlan.features", { returnObjects: true }),
    },
    {
      id: "3",
      title: t("pricing.premiumPlan.title"),
      description: t("pricing.premiumPlan.description"),
      price: t("pricing.premiumPlan.price"),
      buttonText: t("pricing.premiumPlan.buttonText"),
      buttonRef: "/dashboard#pricingplans",
      features: t("pricing.premiumPlan.features", { returnObjects: true }),
    },
  ];

  return (
    <div className="flex gap-[1rem] max-lg:flex-wrap">
      {pricingData.map((item) => (
        <div
          key={item.id}
          className="w-[19rem] max-lg:w-full h-full px-6 bg-n-8 border border-n-6 rounded-[2rem] lg:w-auto even:py-14 odd:py-8 odd:my-4 [&>h4]:first:text-color-2 [&>h4]:even:text-color-1 [&>h4]:last:text-color-3"
        >
          <h4 className="h4 mb-4">{item.title}</h4>

          <p className="body-2 min-h-[4rem] mb-3 text-n-1/50">
            {item.description}
          </p>

          <div className="flex items-center h-[5.5rem] mb-6">
            {item.price && (
              <>
                <div className="text-[5.5rem] leading-none font-bold">
                  {item.price}
                </div>
                <div className="h3">€</div>
              </>
            )}
          </div>

          <Button
            className="w-full mb-6"
            href={item.buttonRef}
            white={!!item.price}
          >
            {item.buttonText}
          </Button>

          <ul>
            {item.features.map((feature, index) => (
              <li
                key={index}
                className="flex items-start py-5 border-t border-n-6"
              >
                <img src={check} width={24} height={24} alt="Check" />
                <p className="body-2 ml-4">{feature}</p>
              </li>
            ))}
          </ul>
        </div>
      ))}
    </div>
  );
};

export default PricingList;
