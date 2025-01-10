import React from "react";
import { useTranslation } from "react-i18next";

const EnvironmentsWidget = ({ environments }) => {
  const { t } = useTranslation();

  return (
    <div className="w-full p-6">
      <h3 className="text-lg font-semibold mb-4">{t("environments.title")}</h3>
      <div className="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-3 gap-4">
        {environments.map((env) => (
          <div
            key={env.id}
            className="bg-n-6 p-4 rounded shadow flex flex-col"
          >
            {/* Environment Name */}
            <h4 className="text-md font-bold mb-2">{env.name}</h4>

            {/* Last Measurement */}
            {env.values.length > 0 ? (
              <>
                <p className="text-sm text-n-2 mb-2">
                  {t("environments.lastMeasured")}:{" "}
                  {new Date(env.values[0].values[0].measured_at).toLocaleString()}
                </p>

                {/* Tags for Parameters with Last Value */}
                <div className="flex flex-wrap gap-2 mt-2">
                  {env.values.map((param, idx) => (
                    <span
                      key={idx}
                      className="bg-blue-100 text-blue-600 px-2 py-1 rounded text-xs"
                    >
                      {param.parameter}: {param.values[0].value} {param.values[0].unit}
                    </span>
                  ))}
                </div>
              </>
            ) : (
              <p className="text-sm text-gray-500">
                {t("environments.noMeasurements")}
              </p>
            )}
          </div>
        ))}
      </div>
    </div>
  );
};

export default EnvironmentsWidget;
