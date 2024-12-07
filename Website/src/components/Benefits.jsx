import Heading from "./Heading";
import Section from "./Section";
import { GradientLight } from "./design/Benefits";
import ClipPath from "../assets/svg/ClipPath";
import { FontAwesomeIcon } from "@fortawesome/react-fontawesome";
import {
  faTv,
  faCode,
  faChartLine,
  faRobot,
  faWater,
  faBookOpen,
} from "@fortawesome/free-solid-svg-icons";
import { useTranslation } from "next-i18next";
import benefitImage from "../../src/assets/benefits/image-2.png";

const Benefits = () => {
  const { t } = useTranslation();

  // Mapping the icons and additional data with the benefits from translation
  const benefitsData = [
    {
      id: "0",
      iconUrl: faTv,
      backgroundUrl: "assets/benefits/card-1.svg",
      light: false,
    },
    {
      id: "1",
      iconUrl: faCode,
      backgroundUrl: "assets/benefits/card-2.svg",
      light: true,
    },
    {
      id: "2",
      iconUrl: faChartLine,
      backgroundUrl: "assets/benefits/card-3.svg",
      light: false,
    },
    {
      id: "3",
      iconUrl: faBookOpen,
      backgroundUrl: "assets/benefits/card-4.svg",
      light: true,
    },
    {
      id: "4",
      iconUrl: faRobot,
      backgroundUrl: "assets/benefits/card-5.svg",
      light: false,
    },
    {
      id: "5",
      iconUrl: faWater,
      backgroundUrl: "assets/benefits/card-6.svg",
      light: true,
    },
  ];

  return (
    <Section id="features">
      <div className="container relative z-2">
        <Heading
          className="md:max-w-md lg:max-w-2xl"
          title={t("benefitsTitle")}
        />

        <div className="flex flex-wrap gap-10 mb-10">
          {benefitsData.map((item, index) => (
            <div
              className="block relative p-0.5 bg-no-repeat bg-[length:100%_100%] md:max-w-[24rem]"
              style={{
                backgroundImage: `url(${item.backgroundUrl})`,
              }}
              key={item.id}
            >
              <div className="relative z-2 flex flex-col min-h-[22rem] p-[2.4rem] pointer-events-none">
                <h5 className="h5 mb-5">{t(`benefits.${index}.title`)}</h5>
                <p className="body-2 mb-6 text-n-3">
                  {t(`benefits.${index}.text`)}
                </p>
                <div className="flex items-center mt-auto">
                  <FontAwesomeIcon icon={item.iconUrl} />
                </div>
              </div>

              {item.light && <GradientLight />}

              <div
                className="absolute inset-0.5 bg-n-8"
                style={{ clipPath: "url(#benefits)" }}
              >
                <div className="absolute inset-0 opacity-0 transition-opacity opacity-10">
                  <img
                    src={benefitImage}
                    width={380}
                    height={362}
                    alt={t(`benefits.${index}.title`)}
                    className="w-full h-full object-cover"
                  />
                </div>
              </div>

              <ClipPath />
            </div>
          ))}
        </div>
      </div>
    </Section>
  );
};

export default Benefits;
