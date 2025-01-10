import React from "react";
import check from "@/assets/check.svg";
import { useTranslation } from "react-i18next";

const ComparePlans = () => {
  const { t } = useTranslation();

  return (
    <div className="flex flex-col items-center justify-center text-center mb-8">
      
      <div className="overflow-x-auto w-full">
        <table className="table-auto bg-n-8 border-collapse text-center mx-auto">
          <thead>
            <tr>
              <th className="p-4"></th>
              <th className="p-4 text-xl font-bold">
                {t("comparePlans.plans.hobby.name")}
                <div className="text-sm font-normal">
                  {t("comparePlans.plans.hobby.price")}
                </div>
              </th>
              <th className="p-4 text-xl font-bold">
                {t("comparePlans.plans.advanced.name")}
                <div className="text-sm font-normal">
                  {t("comparePlans.plans.advanced.price")}
                </div>
              </th>
              <th className="p-4 text-xl font-bold">
                {t("comparePlans.plans.premium.name")}
                <div className="text-sm font-normal">
                  {t("comparePlans.plans.premium.price")}
                </div>
              </th>
            </tr>
          </thead>
          <tbody>
            <tr>
              <td className="p-4 text-start">{t("comparePlans.features.0")}</td>
              <td className="p-4">
                <img src={check} alt="Check" className="w-6 h-6 mx-auto" />
              </td>
              <td className="p-4">
                <img src={check} alt="Check" className="w-6 h-6 mx-auto" />
              </td>
              <td className="p-4">
                <img src={check} alt="Check" className="w-6 h-6 mx-auto" />
              </td>
            </tr>
            <tr>
              <td className="p-4 text-start">{t("comparePlans.features.1")}</td>
              <td className="p-4">
                <img src={check} alt="Check" className="w-6 h-6 mx-auto" />
              </td>
              <td className="p-4">
                <img src={check} alt="Check" className="w-6 h-6 mx-auto" />
              </td>
              <td className="p-4">
                <img src={check} alt="Check" className="w-6 h-6 mx-auto" />
              </td>
            </tr>

            <tr>
              <td className="p-4 text-start">{t("comparePlans.features.2")}</td>
              <td className="p-4">
                {t("comparePlans.numberEnvironments.hobby")}
              </td>
              <td className="p-4">
                {t("comparePlans.numberEnvironments.advanced")}
              </td>
              <td className="p-4">
                {t("comparePlans.numberEnvironments.premium")}
              </td>
            </tr>
            <tr>
              <td className="p-4 text-start">{t("comparePlans.features.3")}</td>
              <td className="p-4">{t("comparePlans.uploadFrequency.hobby")}</td>
              <td className="p-4">
                {t("comparePlans.uploadFrequency.advanced")}
              </td>
              <td className="p-4">
                {t("comparePlans.uploadFrequency.premium")}
              </td>
            </tr>
            <tr>
              <td className="p-4 text-start">{t("comparePlans.features.4")}</td>
              <td className="p-4">{t("comparePlans.notAvailable")}</td>
              <td className="p-4">
                <img src={check} alt="Check" className="w-6 h-6 mx-auto" />
              </td>
              <td className="p-4">
                <img src={check} alt="Check" className="w-6 h-6 mx-auto" />
              </td>
            </tr>
            <tr>
              <td className="p-4 text-start">{t("comparePlans.features.5")}</td>
              <td className="p-4">{t("comparePlans.notAvailable")}</td>
              <td className="p-4">{t("comparePlans.notAvailable")}</td>
              <td className="p-4">
                <img src={check} alt="Check" className="w-6 h-6 mx-auto" />
              </td>
            </tr>
            <tr>
              <td className="p-4 text-start">{t("comparePlans.features.6")}</td>
              <td className="p-4">{t("comparePlans.notAvailable")}</td>
              <td className="p-4">{t("comparePlans.notAvailable")}</td>
              <td className="p-4">
                <img src={check} alt="Check" className="w-6 h-6 mx-auto" />
              </td>
            </tr>
          </tbody>
        </table>
      </div>
    </div>
  );
};

export default ComparePlans;
